.section .data
    prompt:      .string "Nhap nam sinh (4 ky tu): "
    prompt_len = . - prompt - 1                       

    msg_chua:      .string "Chua vao UIT\n"           
    msg_chua_len = . - msg_chua - 1                   

    msg_dang:      .string "Dang hoc tai UIT\n"       
    msg_dang_len = . - msg_dang - 1                   

    msg_da:      .string "Da tot nghiep\n"            
    msg_da_len = . - msg_da - 1                       

    current_year: .int 2026                           # năm hiện tại

    # --- CHUỖI CHO PHẦN NÂNG CAO ---
    msg_tuoi:           .string "Tuoi: "
    msg_tuoi_len      = . - msg_tuoi - 1

    msg_nam_vao:        .string "Nam du kien vao UIT: "
    msg_nam_vao_len   = . - msg_nam_vao - 1

    msg_nam_tn:         .string "Nam du kien TN: "
    msg_nam_tn_len    = . - msg_nam_tn - 1

    msg_da_tn_nam:      .string "Nam da TN: "
    msg_da_tn_nam_len = . - msg_da_tn_nam - 1


.section .bss
    .lcomm input, 6          
    .lcomm num_buffer, 12    # buffer chứa chuỗi số khi in
    
    # Các biến lưu trữ tạm thời để in ở cuối
    .lcomm age_val, 4        # lưu tuổi
    .lcomm year_val, 4       # lưu năm (dự kiến/đã TN)
    .lcomm msg1_addr, 4      # lưu địa chỉ chuỗi trạng thái
    .lcomm msg1_len, 4       # lưu độ dài chuỗi trạng thái
    .lcomm msg2_addr, 4      # lưu địa chỉ chuỗi năm
    .lcomm msg2_len, 4       # lưu độ dài chuỗi năm


.section .text
    .globl _start
_start:
    # 1. Yêu cầu nhập
    movl $4, %eax            
    movl $1, %ebx            
    movl $prompt, %ecx       
    movl $prompt_len, %edx   
    int $0x80

    # 2. Đọc năm sinh
    movl $3, %eax            
    movl $0, %ebx            
    movl $input, %ecx        
    movl $5, %edx            
    int $0x80

    # 3. Chuyển chuỗi sang số nguyên
    movl $input, %esi        
    xorl %eax, %eax          
    movb (%esi), %al         
    subl $48, %eax           
    movl $1000, %ecx         
    imull %ecx, %eax         
    movl %eax, %edi          

    xorl %eax, %eax          
    movb 1(%esi), %al        
    subl $48, %eax           
    movl $100, %ecx          
    imull %ecx, %eax         
    addl %eax, %edi          

    xorl %eax, %eax          
    movb 2(%esi), %al        
    subl $48, %eax           
    movl $10, %ecx           
    imull %ecx, %eax         
    addl %eax, %edi          

    xorl %eax, %eax          
    movb 3(%esi), %al        
    subl $48, %eax           
    addl %eax, %edi          # edi = năm sinh hoàn chỉnh

    # 4. Tính tuổi và lưu lại
    movl current_year, %eax  
    subl %edi, %eax          # eax = tuổi
    movl %eax, age_val       # Lưu tuổi vào biến age_val
    movl %edi, %ebx          # Giữ năm sinh trong ebx

    # 5. So sánh để set dữ liệu chuẩn bị in
    cmpl $18, %eax           
    jl _chua_vao             

    cmpl $22, %eax           
    jg _da_tot_nghiep        

    # --- NHÁNH: ĐANG HỌC ---
    movl $msg_dang, msg1_addr
    movl $msg_dang_len, msg1_len
    movl $msg_nam_tn, msg2_addr
    movl $msg_nam_tn_len, msg2_len
    addl $22, %ebx           # Tính năm dự kiến TN
    movl %ebx, year_val      # Lưu vào biến year_val
    jmp _print_phase         # Nhảy tới phần in

_chua_vao:
    # --- NHÁNH: CHƯA VÀO UIT ---
    movl $msg_chua, msg1_addr
    movl $msg_chua_len, msg1_len
    movl $msg_nam_vao, msg2_addr
    movl $msg_nam_vao_len, msg2_len
    addl $18, %ebx           # Tính năm dự kiến vào UIT
    movl %ebx, year_val
    jmp _print_phase

_da_tot_nghiep:
    # --- NHÁNH: ĐÃ TỐT NGHIỆP ---
    movl $msg_da, msg1_addr
    movl $msg_da_len, msg1_len
    movl $msg_da_tn_nam, msg2_addr
    movl $msg_da_tn_nam_len, msg2_len
    addl $22, %ebx           # Tính năm đã TN
    movl %ebx, year_val
    jmp _print_phase

    # ==========================================
    # PHẦN IN ẤN CHUNG (KHÔNG XÀI HÀM)
    # ==========================================
_print_phase:
    # 6.1. In Trạng thái (msg1)
    movl $4, %eax
    movl $1, %ebx
    movl msg1_addr, %ecx
    movl msg1_len, %edx
    int $0x80

    # 6.2. In chữ "Tuoi: "
    movl $4, %eax
    movl $1, %ebx
    movl $msg_tuoi, %ecx
    movl $msg_tuoi_len, %edx
    int $0x80

    # 6.3. Chuyển số tuổi ra chuỗi và in
    movl age_val, %eax       # Lấy số tuổi
    movl $num_buffer, %esi
    addl $11, %esi           # Trỏ về cuối buffer
    movb $10, (%esi)         # Nạp dấu xuống dòng '\n'
    movl $10, %ecx           # Số chia = 10
.L_div_age:
    decl %esi
    xorl %edx, %edx
    divl %ecx                # Chia eax cho 10, dư nằm ở edx
    addb $48, %dl            # Chuyển số dư thành ASCII
    movb %dl, (%esi)
    testl %eax, %eax         # Kiểm tra thương = 0 chưa?
    jnz .L_div_age           # Chưa thì lặp lại

    movl $num_buffer, %edx
    addl $12, %edx
    subl %esi, %edx          # Tính độ dài chuỗi cần in vào edx
    movl $4, %eax            # sys_write
    movl $1, %ebx
    movl %esi, %ecx          # esi đang trỏ tới đầu chuỗi số
    int $0x80

    # 6.4. In chữ Năm tương ứng (msg2)
    movl $4, %eax
    movl $1, %ebx
    movl msg2_addr, %ecx
    movl msg2_len, %edx
    int $0x80

    # 6.5. Chuyển số Năm ra chuỗi và in
    movl year_val, %eax      # Lấy số năm
    movl $num_buffer, %esi
    addl $11, %esi
    movb $10, (%esi)
    movl $10, %ecx
.L_div_year:
    decl %esi
    xorl %edx, %edx
    divl %ecx
    addb $48, %dl
    movb %dl, (%esi)
    testl %eax, %eax
    jnz .L_div_year

    movl $num_buffer, %edx
    addl $12, %edx
    subl %esi, %edx          # Tính độ dài
    movl $4, %eax
    movl $1, %ebx
    movl %esi, %ecx
    int $0x80

_end:
    # Thoát chương trình
    movl $1, %eax            
    movl $0, %ebx            
    int $0x80
