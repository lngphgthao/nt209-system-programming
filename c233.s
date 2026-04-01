.section .data
msg: .string "Enter a number: "  # thong bao nhap so
len_msg = .- msg               # cach tinh do dai chuoi
res_msg: .string "tbc: "
len_res = .- res_msg           # in ra do dai chuoi ket qua
enter: .byte 10

.section .bss
.lcomm num, 2                  # vung nho 2 byte de nhan so va phim enter
.lcomm tbc, 1      # vung nho 1 byte de luu ket qua

.section .text 
	.globl _start 

_start:
	movl $0, %esi          # luu tong gia tri vao thanh ghi %esi (khoi tao bang 0)


		# Nhap so thu 1
	movl $4, %eax          # sys_write
	movl $1, %ebx          # stdout
	movl $msg, %ecx        # luu dia chi cua  msg vao thanh ghi %ecx
	movl $len_msg, %edx    # so luong byte can in ra
	int $0x80              # goi he thong thuc thi

	movl $3, %eax          #sys_read
	movl $0, %ebx          #stdin
	movl $num, %ecx        # luu dia chi num vao thanh ghi %ecx
	movl $2, %edx          # doc toi da 2 byte (ki tu + enter)
	int $0x80 

	movl $0, %eax          # xoa sach %eax de chuan bi tinh toan
	movb (num), %al	       # lay 1 byte ky tu vua nhap vao %al
	subl $48, %eax         # tru 48 de chuyen tu ascii sang so nguyen
	addl %eax, %esi        # cong don so thu 1 vao %esi


 		# Nhap so thu 2
        movl $4, %eax          # sys_write
        movl $1, %ebx          # stdout
        movl $msg, %ecx        # luu dia chi cua  msg vao thanh ghi %ecx
        movl $len_msg, %edx    # so luong byte can in ra
        int $0x80              # goi he thong thuc thi

        movl $3, %eax          #sys_read
        movl $0, %ebx          #stdin
        movl $num, %ecx        # luu dia chi num vao thanh ghi %ecx
        movl $2, %edx          # doc toi da 2 byte (ki tu + enter)
        int $0x80 

        movl $0, %eax          # xoa sach %eax de chuan bi tinh toan
        movb (num), %al        # lay 1 byte ky tu vua nhap vao %al
        subl $48, %eax         # tru 48 de chuyen tu ascii sang so nguyen
        addl %eax, %esi        # cong don so thu 2 vao %esi


		# Nhap so thu 3
        movl $4, %eax          # sys_write
        movl $1, %ebx          # stdout
        movl $msg, %ecx        # luu dia chi cua  msg vao thanh ghi %ecx
        movl $len_msg, %edx    # so luong byte can in ra
        int $0x80              # goi he thong thuc thi

        movl $3, %eax          #sys_read
        movl $0, %ebx          #stdin
        movl $num, %ecx        # luu dia chi num vao thanh ghi %ecx
        movl $2, %edx          # doc toi da 2 byte (ki tu + enter)
        int $0x80 

        movl $0, %eax          # xoa sach %eax de chuan bi tinh toan
        movb (num), %al        # lay 1 byte ky tu vua nhap vao %al
        subl $48, %eax         # tru 48 de chuyen tu ascii sang so nguyen
        addl %eax, %esi        # cong don so thu 3 vao %esi


		# Nhap so thu 4
        movl $4, %eax          # sys_write
        movl $1, %ebx          # stdout
        movl $msg, %ecx        # luu dia chi cua  msg vao thanh ghi %ecx
        movl $len_msg, %edx    # so luong byte can in ra
        int $0x80              # goi he thong thuc thi

        movl $3, %eax          #sys_read
        movl $0, %ebx          #stdin
        movl $num, %ecx        # luu dia chi num vao thanh ghi %ecx
        movl $2, %edx          # doc toi da 2 byte (ki tu + enter)
        int $0x80 

        movl $0, %eax          # xoa sach %eax de chuan bi tinh toan
        movb (num), %al        # lay 1 byte ky tu vua nhap vao %al
        subl $48, %eax         # tru 48 de chuyen tu ascii sang so nguyen
        addl %eax, %esi        # cong don so thu 4  vao %esi

		# Tinh trung binh cong
	movl %esi, %eax        # Luu tong vao %eax de thuc hien phep chia
	movl $0, %edx          # xoa sach %edx truoc khi chia
	movl $4, %ebx          # so chia la 4
	divl %ebx              # chia %eax cho 4, ket qua phan nguyen nam o %eax

	addl $48, %eax         # cong 48 de chuyen so sang ky tu ascii
	movb %al, tbc  # luu ki tu vao o nho Trung binh cong de in ra ket qua

	movl $4, %eax         
	movl $1, %ebx
	movl $res_msg, %ecx
	movl $len_res, %edx
	int $0x80

	movl $4, %eax
	movl $1, %ebx
	movl $tbc, %ecx
	movl $1, %edx
	int $0x80

	movl $4, %eax
	movl $1, %ebx
	movl $enter, %ecx
	movl $1, %edx
	int $0x80


		# Thoat chuong trinh
	movl $1, %eax        #sys_exit
	movl $0, %ebx
	int $0x80
