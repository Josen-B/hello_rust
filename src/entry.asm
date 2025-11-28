MBT_HDR_FLAGS    EQU 0x00010003
MBT_HDR_MAGIC    EQU 0x1BADB002    ; 多引导协议头魔数
MBT_HDR2_MAGIC   EQU 0xe85250d6    ; 第二版多引导协议头魔数

section .note.GNU-stack noalloc noexec nowrite progbits

global _start                    ; 导出_start符号
extern rust_main                 ; 导入外部的rust_main函数符号

[section .start.text]            ; 定义.start.text代码节
[bits 32]                        ; 汇编成32位代码

_start:
    jmp _entry
ALIGN 8
mbt_hdr:
    dd MBT_HDR_MAGIC
    dd MBT_HDR_FLAGS
    dd -(MBT_HDR_MAGIC+MBT_HDR_FLAGS)
    dd mbt_hdr
    dd _start
    dd 0
    dd 0
    dd _entry

; 以上是GRUB所需要的头
ALIGN 8
mbt2_hdr:
    DD  MBT_HDR2_MAGIC
    DD  0
    DD  mbt2_hdr_end - mbt2_hdr
    DD  -(MBT_HDR2_MAGIC + 0 + (mbt2_hdr_end - mbt2_hdr))
    DW  2, 0
    DD  24
    DD  mbt2_hdr
    DD  _start
    DD  0
    DD  0
    DW  3, 0
    DD  12
    DD  _entry
    DD  0
    DW  0, 0
    DD  8
mbt2_hdr_end:
; 以上是GRUB2所需要的头
; 包含两个头是为了同时兼容GRUB、GRUB2

ALIGN 8

_entry:
    ; 关中断
    cli
    ; 关不可屏蔽中断
    in al, 0x70
    or al, 0x80
    out 0x70, al
    
    ; 设置临时栈
    mov esp, 0x9000
    
    ; 检查CPU是否支持长模式
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .no_long_mode
    mov eax, 0x80000001
    cpuid
    test edx, (1 << 29)  ; LM位
    jz .no_long_mode
    
    ; 启用PAE
    mov eax, cr4
    or eax, (1 << 5)     ; PAE位
    mov cr4, eax
    
    ; 设置PML4表
    mov edi, 0x1000      ; PML4表地址
    xor eax, eax
    mov ecx, 4096
    rep stosb            ; 清零PML4表
    
    mov dword [edi], 0x2003  ; 第一个PDP条目
    add edi, 0x1000           ; PDP表地址
    mov dword [edi], 0x3003  ; 第一个PD条目
    add edi, 0x1000           ; PD表地址
    mov dword [edi], 0x0083  ; 第一个PT条目，映射前2MB
    
    ; 设置页目录基址寄存器
    mov eax, 0x1000      ; PML4表地址
    mov cr3, eax
    
    ; 启用长模式
    mov ecx, 0xC0000080  ; EFER MSR
    rdmsr
    or eax, (1 << 8)     ; LME位
    wrmsr
    
    ; 启用分页
    mov eax, cr0
    or eax, (1 << 31)    ; PG位
    mov cr0, eax
    
    ; 远跳转到64位代码
    lgdt [GDT_PTR]
    jmp dword 0x08:long_mode_start

.no_long_mode:
    ; 不支持长模式，挂起
    hlt
    jmp .no_long_mode

[bits 64]

long_mode_start:
    ; 设置64位数据段
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    ; 设置64位栈
    mov rsp, 0x9000
    
    ; 调用Rust主函数
    call rust_main
    
    ; 挂起系统
    hlt
    jmp $

; 全局描述符表
ALIGN 8
GDT_START:
knull_dsc:    dq 0
kcode_dsc:    dq 0x00af9e000000ffff    ; 64位代码段
kdata_dsc:    dq 0x00cf92000000ffff    ; 64位数据段
GDT_END:

GDT_PTR:
GDTLEN    dw GDT_END - GDT_START - 1
GDTBASE   dq GDT_START