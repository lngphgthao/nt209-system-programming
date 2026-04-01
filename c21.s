.section .data
msg: .string "NT209UIT"
len: .int 0
enter: .byte 10 # trong ascii, byte co gia tri 10 nghia la xuong dong

.section .text
	.globl _start

_start:
	movl $len, %edi # $len la dia chi cua len, luu dia chi cua len vao %edi
	subl $msg, %edi # tru di dia chi cua msg
	subl $1, %edi   # tru 1 di de bo di ki tu null

	addl $48, %edi  # cong 48 de chuyen so thanh ki tu
	movl %edi, len  # luu do dai cua ki tu vao len

	movl $4, %eax   # sys_write
	movl $1, %ebx   # stdout
	movl $len, %ecx # dua ki tu chua do dai len vao thanh ghi
	movl $1, %edx   # in ra do dai la 1 byte cua chuoi se nhan
	int $0x80       # goi he thong thuc thi
	
	movl $4, %eax   # sys_write
	movl $1, %ebx   # stdout
	movl $enter, %ecx # luu dia chi cua o nho enter vao thanh ghi
	movl $1, %edx   # in ra do dai cua chuoi se nhan
	int $0x80        # loi goi he thong

	movl $1, %eax   # sys_exit
	movl $0, %ebx
	int $0x80       # goi he thong thuc thi
