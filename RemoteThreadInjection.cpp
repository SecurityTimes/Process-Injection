#include <Windows.h>
#include <stdio.h>

int Error(const char* str) {
	printf("%s (%u)\n", str, GetLastError());
	return 1;
}

int main(int argc, const char* argv[]) {
	if (argc < 3) {
		printf("Usage: RemoteThreadInjection.exe <PID> <DLLPath>\n");
		return 0;
	}

	int pid = atoi(argv[1]);
	HANDLE hProcess = OpenProcess(PROCESS_VM_WRITE | PROCESS_VM_OPERATION | PROCESS_CREATE_THREAD, FALSE, pid);
	if (!hProcess)
		return Error("Failed to Open Process");
	
	void* address = GetProcAddress(GetModuleHandle(L"kernel32.dll"), "LoadLibraryA");

	void* buffer = VirtualAllocEx(hProcess, nullptr, strlen(argv[2]), MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);
	if (!buffer)
		return Error("Failed to Allocate Memory");

	if (!WriteProcessMemory(hProcess, buffer, argv[2], strlen(argv[2]), nullptr))
		return Error("Failed in WriteProcessMemory");

	HANDLE hThread = CreateRemoteThread(hProcess, nullptr, 0, (LPTHREAD_START_ROUTINE)address, buffer, 0, nullptr);
	if (!hThread)
		return Error("Failed to Create Remote Thread");

	printf("Remote thread created successfully!");

	WaitForSingleObject(hThread, 5000);
	VirtualFreeEx(hProcess, buffer, 0, MEM_RELEASE);
	CloseHandle(hProcess);

	return 0;
}
