# Khai bao chuoi va ky tu xuong dong
.section .data
input_str: .string "Enter a string (10-chars): "
input_len = . -input_str

start_str: .string "Start index: "
start_len = . -start_str

end_str: .string "End index: "
end_len = . -end_str

newline: .byte 10

# Khai bao cac bien rong
.section .bss
	.lcomm input, 10
	.lcomm start_idx, 1
	.lcomm end_idx, 1


.section .text
	.globl _start
_start:
	# Xuat chuoi yeu cau nhap input
	movl $4, %eax		# sys_write
	movl $1, %ebx		# stdout
	movl $input_str, %ecx	# chuoi in
	movl $input_len, %edx	# do dai chuoi
	int $0x80

	# Nhap chuoi input
	movl $3, %eax		# sys_read
	movl $0, %ebx		# stdin
	movl $input, %ecx	# ecx = dia chi o nho de luu gia tri nhap vao
				# --> luu gia tri da khai bao bien input
	movl $11, %edx		# do dai toi da cua chuoi input (10 char + \0)
	int $0x80

	# Xuat chuoi yeu cau nhap start index
        movl $4, %eax
        movl $1, %ebx
        movl $start_str, %ecx
        movl $start_len, %edx
        int $0x80

	# Nhap start index
	movl $3, %eax
        movl $0, %ebx
        movl $start_idx, %ecx
        movl $2, %edx
	int $0x80

        # Xuat chuoi yeu cau nhap end index
        movl $4, %eax
        movl $1, %ebx
	movl $end_str, %ecx
        movl $end_len, %edx
	int $0x80

        # Nhap end index
        movl $3, %eax
        movl $0, %ebx
        movl $end_idx, %ecx
        movl $2, %edx
        int $0x80

	# Chuyen start_idx thanh int
	xorl %ebx, %ebx		# xor hai gia tri giong nhau
				# --> chuyen het cac bit ve 0
				# --> clear thanh ghi ebx
 	movb start_idx, %bl	# start_index = 1B = %bl -> de tinh toan
	subb $0x30, %bl		# ky tu trong %bl - '0' = int

	# Chuyen end_idx thanh int
 	xorl %eax, %eax		# clear thanh ghi eax
 	movb end_idx, %al
  	subb $0x30, %al

  	# Tinh do dai substring
  	subb %bl, %al		# al = end_idx - start_idx
    	addb $1, %al		# +1 cho \0

    	xorl %edx, %edx		# clear thanh ghi edx
    	movb %al, %dl		# thanh ghi dl (edx) dung de luu do dai chuoi
				# --> bat dau in tu base + do dai substring
				# tra lai thanh ghi eax de thuc hien lenh khac

	# Vi tri bat dau cua substring
    	movl $input, %ecx	# chuoi can in
    	addl %ebx, %ecx		# ebx chua start_idx
				# ecx = dia chi base input + start_idx
				# ecx = dia chi base input moi

	# In ra substring
    	movl $4, %eax
    	movl $1, %ebx
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
