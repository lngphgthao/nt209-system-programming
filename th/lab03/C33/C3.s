.section .data
input_str: .string "Enter a number (1-digit): "
input_len = . -input_str

four_str: .string "Count 4x: "
four_len = . -four_str

count: .int 0
count_len = . -count

newline: .byte 10


.section .bss
	.lcomm input, 1


.section .text
	.globl _start
_start:
	# esi luu lan lap vong for, edi luu so luong chia het cho 4
	xorl %esi, %esi
	xorl %esi, %edi

_for_loop:
	# Tang so lan lap vong for
	incl %esi

	# So sanh so lan lap vong for
	cmpl $5, %esi
	jg _end

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
        movl $2, %edx          	# do dai toi da cua chuoi input (1 char + \0)
        int $0x80

	# Chuyen input thanh int
 	xorl %eax, %eax		# clear thanh ghi eax
 	movb input, %al
  	subb $0x30, %al

	# Do so chia het cho 4 se co 2 bit cuoi la 00
	# Thuc hien input & 3 (0011), check xem ket qua co bang 0
	# Neu bang 0 --> do 11 & 00 --> so chia het cho 4
	andb $3, %al
	jne _for_loop		# neu ket qua khac 0 --> tiep tuc vong lap

	# Neu ket qua bang 0, tang bien dem
	incl %edi
	jmp _for_loop

_end:
	# Xuat chuoi "Count 4x"
        movl $4, %eax
        movl $1, %ebx
        movl $four_str, %ecx
        movl $four_len, %edx
        int $0x80

	# Chuyen gia tri %edi thanh ma ASCII va chuyen vao bien count
	addl $0x30, %edi
	movl %edi, count

	# Xuat ket qua bien dem
	movl $4, %eax
	movl $1, %ebx
	movl $count, %ecx
	movl $count_len, %edx
	int $0x80

        # Xuong dong
        movl $4, %eax
        movl $1, %ebx
        movl $newline, %ecx
        movl $1, %edx
        int $0x80

        # Exit code
        movl $1, %eax
        int $0x80
