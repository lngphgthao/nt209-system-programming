.section .data
input_str: .string "Enter a number (4-digits): "
input_len = . -input_str

newline: .byte 10

inc_str: .string "Tang dan"
inc_len = . -inc_str

dec_str: .string "Khong tang dan"
dec_len = . -dec_str


.section .bss
	.lcomm input, 4


.section .text
	.globl _start
_start:
	# Xuat chuoi yeu cau nhap input
	movl $4, %eax           # sys_write
        movl $1, %ebx           # stdout
        movl $input_str, %ecx   # chuoi in
        movl $input_len, %edx   # do dai chuoi
        int $0x80

        # Nhap chuoi input
        movl $3, %eax           # sys_read
        movl $0, %ebx           # stdin
        movl $input, %ecx       # luu gia tri da khai bao bien input
        movl $5, %edx          	# do dai toi da cua chuoi input (4 char + \0)
        int $0x80

	# Khoi tao bien chay vi tri de so sanh
	leal 3(%ecx), %ecx

_for_loop:
	# So sanh vi tri current (ecx) va vi tri goc cua input
	cmpl $input, %ecx
	jle _inc		# neu ecx < input --> duyet xong va nhay toi _inc

	# Neu vi tri hien tai > vi tri goc cua input
	movb (%ecx), %bl	# lay so o vi tri current
	cmpb -1(%ecx), %bl	# so sanh voi vi tri current - 1
	jle _dec		# neu current <= current - 1 --> nhay toi _dec

	# Neu current > current - 1
	decl %ecx		# doi vi tri current = current - 1
	jmp _for_loop		# tiep tuc vong for

_inc:
	# Xuat chuoi "Tang dan"
        movl $4, %eax
        movl $1, %ebx
        movl $inc_str, %ecx
        movl $inc_len, %edx
        int $0x80
	jmp _end

_dec:
	# Xuat chuoi "Khong tang dan"
	movl $4, %eax
	movl $1, %ebx
	movl $dec_str, %ecx
	movl $dec_len, %edx
	int $0x80

_end:
        # Xuong dong
        movl $4, %eax
        movl $1, %ebx
        movl $newline, %ecx
        movl $1, %edx
        int $0x80

        # Exit code
        movl $1, %eax
        int $0x80
