.section .data
input_str: .string "Nhap chuoi (4 ky tu): "
input_len = . -input_str

n_str: .string "Nhap n (0-9): "
n_len = . -n_str

newline: .byte 10


.section .bss
	.lcomm input, 4
	.lcomm n, 1


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

        # Xuat chuoi yeu cau nhap n
        movl $4, %eax
        movl $1, %ebx
        movl $n_str, %ecx
        movl $n_len, %edx
        int $0x80

        # Nhap n
        movl $3, %eax
        movl $0, %ebx
        movl $n, %ecx
        movl $2, %edx
        int $0x80

	# Chuyen n thanh integer
	xorl %eax, %eax		# clear thanh ghi eax
	movb n, %al
	subb $0x30, %al		# ky tu trong %al - '0' = int

	# Ma hoa ky tu thu 1 trong chuoi
	movl $input, %ebx	# dung thanh ghi ebx tro den dia chi chuoi
	movb (%ebx), %cl	# lay ky tu thu 1 trong input
	addb %al, %cl		# dich n buoc so voi ky tu x

	# Kiem tra ky tu co can xoay vong hay khong
	movb %cl, %dl
	subb $123, %dl		# co lon hon 'z' hay khong
	sarb $7, %dl		# dich phai 7 bit de lay bit dau
				# 0x00 = lon hon = xoay vong, 0xFF = nho hon
	notb %dl		# dao nguoc dau de and voi 26
	andb $26, %dl		# 0x00 and 26 = 0, 0xFF and 26 = 26
	subb %dl, %cl		# lon hon 'z' - 26 = xoay vong
				# be hon 'z' - 0 = giu nguyen
	movb %cl, (%ebx)

        # Ma hoa ky tu thu 2 trong chuoi
	incl %ebx
        movb (%ebx), %cl       # lay ky tu thu 2 trong input
        addb %al, %cl

        # Kiem tra ky tu co can xoay vong hay khong
        movb %cl, %dl
        subb $123, %dl          # co lon hon 'z' hay khong
        sarb $7, %dl            # dich phai 7 bit de lay bit dau
                                # 0x00 = lon hon = xoay vong, 0xFF = nho hon
        notb %dl                # dao nguoc dau de and voi 26
        andb $26, %dl           # 0x00 and 26 = 0, 0xFF and 26 = 26
        subb %dl, %cl           # lon hon 'z' - 26 = xoay vong
                                # be hon 'z' - 0 = giu nguyen
        movb %cl, (%ebx)

        # Ma hoa ky tu thu 3 trong chuoi
	incl %ebx
        movb (%ebx), %cl       # lay ky tu thu 3 trong input
        addb %al, %cl

        # Kiem tra ky tu co can xoay vong hay khong
        movb %cl, %dl
        subb $123, %dl          # co lon hon 'z' hay khong
        sarb $7, %dl            # dich phai 7 bit de lay bit dau
                                # 0x00 = lon hon = xoay vong, 0xFF = nho hon
        notb %dl                # dao nguoc dau de and voi 26
        andb $26, %dl           # 0x00 and 26 = 0, 0xFF and 26 = 26
        subb %dl, %cl           # lon hon 'z' - 26 = xoay vong
                                # be hon 'z' - 0 = giu nguyen
        movb %cl, (%ebx)

        # Ma hoa ky tu thu 4 trong chuoi
        incl %ebx
        movb (%ebx), %cl       # lay ky tu thu 4 trong input
        addb %al, %cl

        # Kiem tra ky tu co can xoay vong hay khong
        movb %cl, %dl
        subb $123, %dl          # co lon hon 'z' hay khong
        sarb $7, %dl            # dich phai 7 bit de lay bit dau
                                # 0x00 = lon hon = xoay vong, 0xFF = nho hon
        notb %dl                # dao nguoc dau de and voi 26
        andb $26, %dl           # 0x00 and 26 = 0, 0xFF and 26 = 26
        subb %dl, %cl           # lon hon 'z' - 26 = xoay vong
                                # be hon 'z' - 0 = giu nguyen
        movb %cl, (%ebx)

	# Xuat chuoi da duoc ma hoa Caesar
        movl $4, %eax
        movl $1, %ebx
        movl $input, %ecx
        movl $4, %edx
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
