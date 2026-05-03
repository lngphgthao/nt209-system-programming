.section .data
prompt_str: .ascii "Enter a string (255 chars): "
prompt_len = . - prompt_str

result_msg: .ascii "Number of words: "
result_msg_len = . - result_msg

newline: .byte 10

.section .bss
    .lcomm input, 256       # Tăng buffer lên 256 bytes
    .lcomm output_buffer, 4 # 

.section .text
    .globl _start

_start:
    # 1. In ra chuoi (sys_write)
    movl $4, %eax
    movl $1, %ebx
    movl $prompt_str, %ecx
    movl $prompt_len, %edx
    int $0x80  

    # 2. Doc chuoi (sys_read)
    movl $3, %eax
    movl $0, %ebx
    movl $input, %ecx
    movl $256, %edx         
    int $0x80

    # 3. khoi tao bien  
    movl $input, %esi       # Trỏ con trỏ vào đầu chuỗi input
    movl $0, %ebx           # ebx dùng để đếm số từ (khởi tạo = 0)
    movl $0, %ecx           # ecx là cờ (0 = ngoài từ, 1 = trong từ)

count_loop:
    movb (%esi), %al        # Lấy 1 kí tự vào al

    cmpb $10, %al           # Gợi ý 2.3: kí tự xuống dòng
    je print_result 
    cmpb $0, %al            # Hết chuỗi
    je print_result 

    cmpb $32, %al           # Gợi ý 2.1: kiểm tra khoảng trắng
    je _space              

    cmpl $0, %ecx           # Kiểm tra xem đang ở trong hay ngoài chữ
    jne next_char           # Nếu đã ở trong chữ (%ecx != 0) thì bỏ qua
    
    incl %ebx               # Phát hiện từ mới -> tăng biến đếm
    movl $1, %ecx           # Bật cờ đánh dấu đang ở trong từ
    jmp next_char           

_space:
    movl $0, %ecx           # Gặp khoảng trắng -> hạ cờ

next_char:
    incl %esi               # Tăng con trỏ lên kí tự kế tiếp
    jmp count_loop          

print_result:
    pushl %ebx   # save ket qua  dem vao stack


    # In chu "Number of words: "
    movl $4, %eax 
    movl $1, %ebx 
    movl $result_msg, %ecx 
    movl $result_msg_len, %edx 
    int $0x80

    # Gợi ý 2.4: Chuyển đổi số nguyên thành chuỗi
    popl %eax     # lay so dem tu stack luu vao eax de chuan bi chia
    movl $output_buffer, %edi # Trỏ edi vào buffer để chứa chữ số
    movl $10, %esi          # Số chia là 10
    movl $0, %ecx           # Dùng ecx để đếm xem số có bao nhiêu chữ số
    
divide_loop:
    movl $0, %edx           # Xóa edx về 0 trước khi chia
    divl %esi               # %eax = %eax / 10, phần dư nằm ở edx
    pushl %edx              #  save  phần dư vào stack
    incl %ecx               # Tăng bộ đếm chữ số
    cmpl $0, %eax           # Nếu eax còn khác 0 thì lặp lại
    jne divide_loop
    
    movl %ecx, %ebx         # Lưu tổng số lượng chữ số vào ebx để làm độ dài lúc in
    
pop_loop:
    popl %eax               # Lấy từng chữ số từ stack ra
    addb $48, %al           # Chuyển số thành mã ascii
    movb %al, (%edi)        # Ghi vào output_buffer
    incl %edi               # Nhích buffer lên 1 ô
    loop pop_loop           # Lặp lại đến khi hết chữ số
    
    # In con số đếm được ra màn hình
    movl $4, %eax           # sys_write
    movl %ebx, %edx         # Độ dài chuỗi số đã cất ở ebx
    movl $1, %ebx           # stdout
    movl $output_buffer, %ecx # Chỗ chứa chữ số
    int $0x80

    # Xuống dòng
    movl $4, %eax
    movl $1, %ebx
    movl $newline, %ecx
    movl $1, %edx
    int $0x80

    # Thoát chương trình
    movl $1, %eax
    movl $0, %ebx
    int $0x80
