.code

NtOpenProcess PROC
	mov rax, gs:[60h]                       ; Load PEB into RAX.
NtOpenProcess_Check_X_X_XXXX:               ; Check major version.
	cmp dword ptr [rax+118h], 5
	je  NtOpenProcess_SystemCall_5_X_XXXX
	cmp dword ptr [rax+118h], 6
	je  NtOpenProcess_Check_6_X_XXXX
	cmp dword ptr [rax+118h], 10
	je  NtOpenProcess_Check_10_0_XXXX
	jmp NtOpenProcess_SystemCall_Unknown
NtOpenProcess_Check_6_X_XXXX:               ; Check minor version for Windows Vista/7/8.
	cmp dword ptr [rax+11ch], 0
	je  NtOpenProcess_Check_6_0_XXXX
	cmp dword ptr [rax+11ch], 1
	je  NtOpenProcess_Check_6_1_XXXX
	cmp dword ptr [rax+11ch], 2
	je  NtOpenProcess_SystemCall_6_2_XXXX
	cmp dword ptr [rax+11ch], 3
	je  NtOpenProcess_SystemCall_6_3_XXXX
	jmp NtOpenProcess_SystemCall_Unknown
NtOpenProcess_Check_6_0_XXXX:               ; Check build number for Windows Vista.
	cmp word ptr [rax+120h], 6000
	je  NtOpenProcess_SystemCall_6_0_6000
	cmp word ptr [rax+120h], 6001
	je  NtOpenProcess_SystemCall_6_0_6001
	cmp word ptr [rax+120h], 6002
	je  NtOpenProcess_SystemCall_6_0_6002
	jmp NtOpenProcess_SystemCall_Unknown
NtOpenProcess_Check_6_1_XXXX:               ; Check build number for Windows 7.
	cmp word ptr [rax+120h], 7600
	je  NtOpenProcess_SystemCall_6_1_7600
	cmp word ptr [rax+120h], 7601
	je  NtOpenProcess_SystemCall_6_1_7601
	jmp NtOpenProcess_SystemCall_Unknown
NtOpenProcess_Check_10_0_XXXX:              ; Check build number for Windows 10.
	cmp word ptr [rax+120h], 10240
	je  NtOpenProcess_SystemCall_10_0_10240
	cmp word ptr [rax+120h], 10586
	je  NtOpenProcess_SystemCall_10_0_10586
	cmp word ptr [rax+120h], 14393
	je  NtOpenProcess_SystemCall_10_0_14393
	cmp word ptr [rax+120h], 15063
	je  NtOpenProcess_SystemCall_10_0_15063
	cmp word ptr [rax+120h], 16299
	je  NtOpenProcess_SystemCall_10_0_16299
	cmp word ptr [rax+120h], 17134
	je  NtOpenProcess_SystemCall_10_0_17134
	cmp word ptr [rax+120h], 17763
	je  NtOpenProcess_SystemCall_10_0_17763
	cmp word ptr [rax+120h], 18362
	je  NtOpenProcess_SystemCall_10_0_18362
	cmp word ptr [rax+120h], 18363
	je  NtOpenProcess_SystemCall_10_0_18363
	cmp word ptr [rax+120h], 19041
	je  NtOpenProcess_SystemCall_10_0_19041
	jmp NtOpenProcess_SystemCall_Unknown
NtOpenProcess_SystemCall_5_X_XXXX:          ; Windows XP and Server 2003
	mov eax, 0023h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_6_0_6000:          ; Windows Vista SP0
	mov eax, 0023h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_6_0_6001:          ; Windows Vista SP1 and Server 2008 SP0
	mov eax, 0023h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_6_0_6002:          ; Windows Vista SP2 and Server 2008 SP2
	mov eax, 0023h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_6_1_7600:          ; Windows 7 SP0
	mov eax, 0023h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_6_1_7601:          ; Windows 7 SP1 and Server 2008 R2 SP0
	mov eax, 0023h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_6_2_XXXX:          ; Windows 8 and Server 2012
	mov eax, 0024h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_6_3_XXXX:          ; Windows 8.1 and Server 2012 R2
	mov eax, 0025h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_10240:        ; Windows 10.0.10240 (1507)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_10586:        ; Windows 10.0.10586 (1511)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_14393:        ; Windows 10.0.14393 (1607)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_15063:        ; Windows 10.0.15063 (1703)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_16299:        ; Windows 10.0.16299 (1709)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_17134:        ; Windows 10.0.17134 (1803)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_17763:        ; Windows 10.0.17763 (1809)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_18362:        ; Windows 10.0.18362 (1903)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_18363:        ; Windows 10.0.18363 (1909)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_10_0_19041:        ; Windows 10.0.19041 (2004)
	mov eax, 0026h
	jmp NtOpenProcess_Epilogue
NtOpenProcess_SystemCall_Unknown:           ; Unknown/unsupported version.
	ret
NtOpenProcess_Epilogue:
	mov r10, rcx
	syscall
	ret
NtOpenProcess ENDP

NtAllocateVirtualMemory PROC
	mov rax, gs:[60h]                                 ; Load PEB into RAX.
NtAllocateVirtualMemory_Check_X_X_XXXX:               ; Check major version.
	cmp dword ptr [rax+118h], 5
	je  NtAllocateVirtualMemory_SystemCall_5_X_XXXX
	cmp dword ptr [rax+118h], 6
	je  NtAllocateVirtualMemory_Check_6_X_XXXX
	cmp dword ptr [rax+118h], 10
	je  NtAllocateVirtualMemory_Check_10_0_XXXX
	jmp NtAllocateVirtualMemory_SystemCall_Unknown
NtAllocateVirtualMemory_Check_6_X_XXXX:               ; Check minor version for Windows Vista/7/8.
	cmp dword ptr [rax+11ch], 0
	je  NtAllocateVirtualMemory_Check_6_0_XXXX
	cmp dword ptr [rax+11ch], 1
	je  NtAllocateVirtualMemory_Check_6_1_XXXX
	cmp dword ptr [rax+11ch], 2
	je  NtAllocateVirtualMemory_SystemCall_6_2_XXXX
	cmp dword ptr [rax+11ch], 3
	je  NtAllocateVirtualMemory_SystemCall_6_3_XXXX
	jmp NtAllocateVirtualMemory_SystemCall_Unknown
NtAllocateVirtualMemory_Check_6_0_XXXX:               ; Check build number for Windows Vista.
	cmp word ptr [rax+120h], 6000
	je  NtAllocateVirtualMemory_SystemCall_6_0_6000
	cmp word ptr [rax+120h], 6001
	je  NtAllocateVirtualMemory_SystemCall_6_0_6001
	cmp word ptr [rax+120h], 6002
	je  NtAllocateVirtualMemory_SystemCall_6_0_6002
	jmp NtAllocateVirtualMemory_SystemCall_Unknown
NtAllocateVirtualMemory_Check_6_1_XXXX:               ; Check build number for Windows 7.
	cmp word ptr [rax+120h], 7600
	je  NtAllocateVirtualMemory_SystemCall_6_1_7600
	cmp word ptr [rax+120h], 7601
	je  NtAllocateVirtualMemory_SystemCall_6_1_7601
	jmp NtAllocateVirtualMemory_SystemCall_Unknown
NtAllocateVirtualMemory_Check_10_0_XXXX:              ; Check build number for Windows 10.
	cmp word ptr [rax+120h], 10240
	je  NtAllocateVirtualMemory_SystemCall_10_0_10240
	cmp word ptr [rax+120h], 10586
	je  NtAllocateVirtualMemory_SystemCall_10_0_10586
	cmp word ptr [rax+120h], 14393
	je  NtAllocateVirtualMemory_SystemCall_10_0_14393
	cmp word ptr [rax+120h], 15063
	je  NtAllocateVirtualMemory_SystemCall_10_0_15063
	cmp word ptr [rax+120h], 16299
	je  NtAllocateVirtualMemory_SystemCall_10_0_16299
	cmp word ptr [rax+120h], 17134
	je  NtAllocateVirtualMemory_SystemCall_10_0_17134
	cmp word ptr [rax+120h], 17763
	je  NtAllocateVirtualMemory_SystemCall_10_0_17763
	cmp word ptr [rax+120h], 18362
	je  NtAllocateVirtualMemory_SystemCall_10_0_18362
	cmp word ptr [rax+120h], 18363
	je  NtAllocateVirtualMemory_SystemCall_10_0_18363
	cmp word ptr [rax+120h], 19041
	je  NtAllocateVirtualMemory_SystemCall_10_0_19041
	jmp NtAllocateVirtualMemory_SystemCall_Unknown
NtAllocateVirtualMemory_SystemCall_5_X_XXXX:          ; Windows XP and Server 2003
	mov eax, 0015h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_6_0_6000:          ; Windows Vista SP0
	mov eax, 0015h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_6_0_6001:          ; Windows Vista SP1 and Server 2008 SP0
	mov eax, 0015h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_6_0_6002:          ; Windows Vista SP2 and Server 2008 SP2
	mov eax, 0015h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_6_1_7600:          ; Windows 7 SP0
	mov eax, 0015h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_6_1_7601:          ; Windows 7 SP1 and Server 2008 R2 SP0
	mov eax, 0015h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_6_2_XXXX:          ; Windows 8 and Server 2012
	mov eax, 0016h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_6_3_XXXX:          ; Windows 8.1 and Server 2012 R2
	mov eax, 0017h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_10240:        ; Windows 10.0.10240 (1507)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_10586:        ; Windows 10.0.10586 (1511)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_14393:        ; Windows 10.0.14393 (1607)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_15063:        ; Windows 10.0.15063 (1703)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_16299:        ; Windows 10.0.16299 (1709)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_17134:        ; Windows 10.0.17134 (1803)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_17763:        ; Windows 10.0.17763 (1809)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_18362:        ; Windows 10.0.18362 (1903)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_18363:        ; Windows 10.0.18363 (1909)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_10_0_19041:        ; Windows 10.0.19041 (2004)
	mov eax, 0018h
	jmp NtAllocateVirtualMemory_Epilogue
NtAllocateVirtualMemory_SystemCall_Unknown:           ; Unknown/unsupported version.
	ret
NtAllocateVirtualMemory_Epilogue:
	mov r10, rcx
	syscall
	ret
NtAllocateVirtualMemory ENDP

NtWriteVirtualMemory PROC
	mov rax, gs:[60h]                              ; Load PEB into RAX.
NtWriteVirtualMemory_Check_X_X_XXXX:               ; Check major version.
	cmp dword ptr [rax+118h], 5
	je  NtWriteVirtualMemory_SystemCall_5_X_XXXX
	cmp dword ptr [rax+118h], 6
	je  NtWriteVirtualMemory_Check_6_X_XXXX
	cmp dword ptr [rax+118h], 10
	je  NtWriteVirtualMemory_Check_10_0_XXXX
	jmp NtWriteVirtualMemory_SystemCall_Unknown
NtWriteVirtualMemory_Check_6_X_XXXX:               ; Check minor version for Windows Vista/7/8.
	cmp dword ptr [rax+11ch], 0
	je  NtWriteVirtualMemory_Check_6_0_XXXX
	cmp dword ptr [rax+11ch], 1
	je  NtWriteVirtualMemory_Check_6_1_XXXX
	cmp dword ptr [rax+11ch], 2
	je  NtWriteVirtualMemory_SystemCall_6_2_XXXX
	cmp dword ptr [rax+11ch], 3
	je  NtWriteVirtualMemory_SystemCall_6_3_XXXX
	jmp NtWriteVirtualMemory_SystemCall_Unknown
NtWriteVirtualMemory_Check_6_0_XXXX:               ; Check build number for Windows Vista.
	cmp word ptr [rax+120h], 6000
	je  NtWriteVirtualMemory_SystemCall_6_0_6000
	cmp word ptr [rax+120h], 6001
	je  NtWriteVirtualMemory_SystemCall_6_0_6001
	cmp word ptr [rax+120h], 6002
	je  NtWriteVirtualMemory_SystemCall_6_0_6002
	jmp NtWriteVirtualMemory_SystemCall_Unknown
NtWriteVirtualMemory_Check_6_1_XXXX:               ; Check build number for Windows 7.
	cmp word ptr [rax+120h], 7600
	je  NtWriteVirtualMemory_SystemCall_6_1_7600
	cmp word ptr [rax+120h], 7601
	je  NtWriteVirtualMemory_SystemCall_6_1_7601
	jmp NtWriteVirtualMemory_SystemCall_Unknown
NtWriteVirtualMemory_Check_10_0_XXXX:              ; Check build number for Windows 10.
	cmp word ptr [rax+120h], 10240
	je  NtWriteVirtualMemory_SystemCall_10_0_10240
	cmp word ptr [rax+120h], 10586
	je  NtWriteVirtualMemory_SystemCall_10_0_10586
	cmp word ptr [rax+120h], 14393
	je  NtWriteVirtualMemory_SystemCall_10_0_14393
	cmp word ptr [rax+120h], 15063
	je  NtWriteVirtualMemory_SystemCall_10_0_15063
	cmp word ptr [rax+120h], 16299
	je  NtWriteVirtualMemory_SystemCall_10_0_16299
	cmp word ptr [rax+120h], 17134
	je  NtWriteVirtualMemory_SystemCall_10_0_17134
	cmp word ptr [rax+120h], 17763
	je  NtWriteVirtualMemory_SystemCall_10_0_17763
	cmp word ptr [rax+120h], 18362
	je  NtWriteVirtualMemory_SystemCall_10_0_18362
	cmp word ptr [rax+120h], 18363
	je  NtWriteVirtualMemory_SystemCall_10_0_18363
	cmp word ptr [rax+120h], 19041
	je  NtWriteVirtualMemory_SystemCall_10_0_19041
	jmp NtWriteVirtualMemory_SystemCall_Unknown
NtWriteVirtualMemory_SystemCall_5_X_XXXX:          ; Windows XP and Server 2003
	mov eax, 0037h
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_6_0_6000:          ; Windows Vista SP0
	mov eax, 0037h
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_6_0_6001:          ; Windows Vista SP1 and Server 2008 SP0
	mov eax, 0037h
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_6_0_6002:          ; Windows Vista SP2 and Server 2008 SP2
	mov eax, 0037h
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_6_1_7600:          ; Windows 7 SP0
	mov eax, 0037h
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_6_1_7601:          ; Windows 7 SP1 and Server 2008 R2 SP0
	mov eax, 0037h
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_6_2_XXXX:          ; Windows 8 and Server 2012
	mov eax, 0038h
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_6_3_XXXX:          ; Windows 8.1 and Server 2012 R2
	mov eax, 0039h
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_10240:        ; Windows 10.0.10240 (1507)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_10586:        ; Windows 10.0.10586 (1511)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_14393:        ; Windows 10.0.14393 (1607)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_15063:        ; Windows 10.0.15063 (1703)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_16299:        ; Windows 10.0.16299 (1709)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_17134:        ; Windows 10.0.17134 (1803)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_17763:        ; Windows 10.0.17763 (1809)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_18362:        ; Windows 10.0.18362 (1903)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_18363:        ; Windows 10.0.18363 (1909)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_10_0_19041:        ; Windows 10.0.19041 (2004)
	mov eax, 003ah
	jmp NtWriteVirtualMemory_Epilogue
NtWriteVirtualMemory_SystemCall_Unknown:           ; Unknown/unsupported version.
	ret
NtWriteVirtualMemory_Epilogue:
	mov r10, rcx
	syscall
	ret
NtWriteVirtualMemory ENDP

NtCreateThreadEx PROC
	mov rax, gs:[60h]                          ; Load PEB into RAX.
NtCreateThreadEx_Check_X_X_XXXX:               ; Check major version.
	cmp dword ptr [rax+118h], 6
	je  NtCreateThreadEx_Check_6_X_XXXX
	cmp dword ptr [rax+118h], 10
	je  NtCreateThreadEx_Check_10_0_XXXX
	jmp NtCreateThreadEx_SystemCall_Unknown
NtCreateThreadEx_Check_6_X_XXXX:               ; Check minor version for Windows Vista/7/8.
	cmp dword ptr [rax+11ch], 0
	je  NtCreateThreadEx_Check_6_0_XXXX
	cmp dword ptr [rax+11ch], 1
	je  NtCreateThreadEx_Check_6_1_XXXX
	cmp dword ptr [rax+11ch], 2
	je  NtCreateThreadEx_SystemCall_6_2_XXXX
	cmp dword ptr [rax+11ch], 3
	je  NtCreateThreadEx_SystemCall_6_3_XXXX
	jmp NtCreateThreadEx_SystemCall_Unknown
NtCreateThreadEx_Check_6_0_XXXX:               ; Check build number for Windows Vista.
	cmp word ptr [rax+120h], 6000
	je  NtCreateThreadEx_SystemCall_6_0_6000
	cmp word ptr [rax+120h], 6001
	je  NtCreateThreadEx_SystemCall_6_0_6001
	cmp word ptr [rax+120h], 6002
	je  NtCreateThreadEx_SystemCall_6_0_6002
	jmp NtCreateThreadEx_SystemCall_Unknown
NtCreateThreadEx_Check_6_1_XXXX:               ; Check build number for Windows 7.
	cmp word ptr [rax+120h], 7600
	je  NtCreateThreadEx_SystemCall_6_1_7600
	cmp word ptr [rax+120h], 7601
	je  NtCreateThreadEx_SystemCall_6_1_7601
	jmp NtCreateThreadEx_SystemCall_Unknown
NtCreateThreadEx_Check_10_0_XXXX:              ; Check build number for Windows 10.
	cmp word ptr [rax+120h], 10240
	je  NtCreateThreadEx_SystemCall_10_0_10240
	cmp word ptr [rax+120h], 10586
	je  NtCreateThreadEx_SystemCall_10_0_10586
	cmp word ptr [rax+120h], 14393
	je  NtCreateThreadEx_SystemCall_10_0_14393
	cmp word ptr [rax+120h], 15063
	je  NtCreateThreadEx_SystemCall_10_0_15063
	cmp word ptr [rax+120h], 16299
	je  NtCreateThreadEx_SystemCall_10_0_16299
	cmp word ptr [rax+120h], 17134
	je  NtCreateThreadEx_SystemCall_10_0_17134
	cmp word ptr [rax+120h], 17763
	je  NtCreateThreadEx_SystemCall_10_0_17763
	cmp word ptr [rax+120h], 18362
	je  NtCreateThreadEx_SystemCall_10_0_18362
	cmp word ptr [rax+120h], 18363
	je  NtCreateThreadEx_SystemCall_10_0_18363
	cmp word ptr [rax+120h], 19041
	je  NtCreateThreadEx_SystemCall_10_0_19041
	jmp NtCreateThreadEx_SystemCall_Unknown
NtCreateThreadEx_SystemCall_6_0_6000:          ; Windows Vista SP0
	mov eax, 00a7h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_6_0_6001:          ; Windows Vista SP1 and Server 2008 SP0
	mov eax, 00a5h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_6_0_6002:          ; Windows Vista SP2 and Server 2008 SP2
	mov eax, 00a5h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_6_1_7600:          ; Windows 7 SP0
	mov eax, 00a5h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_6_1_7601:          ; Windows 7 SP1 and Server 2008 R2 SP0
	mov eax, 00a5h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_6_2_XXXX:          ; Windows 8 and Server 2012
	mov eax, 00afh
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_6_3_XXXX:          ; Windows 8.1 and Server 2012 R2
	mov eax, 00b0h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_10240:        ; Windows 10.0.10240 (1507)
	mov eax, 00b3h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_10586:        ; Windows 10.0.10586 (1511)
	mov eax, 00b4h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_14393:        ; Windows 10.0.14393 (1607)
	mov eax, 00b6h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_15063:        ; Windows 10.0.15063 (1703)
	mov eax, 00b9h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_16299:        ; Windows 10.0.16299 (1709)
	mov eax, 00bah
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_17134:        ; Windows 10.0.17134 (1803)
	mov eax, 00bbh
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_17763:        ; Windows 10.0.17763 (1809)
	mov eax, 00bch
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_18362:        ; Windows 10.0.18362 (1903)
	mov eax, 00bdh
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_18363:        ; Windows 10.0.18363 (1909)
	mov eax, 00bdh
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_10_0_19041:        ; Windows 10.0.19041 (2004)
	mov eax, 00c1h
	jmp NtCreateThreadEx_Epilogue
NtCreateThreadEx_SystemCall_Unknown:           ; Unknown/unsupported version.
	ret
NtCreateThreadEx_Epilogue:
	mov r10, rcx
	syscall
	ret
NtCreateThreadEx ENDP

end