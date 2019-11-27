.globl _start
#to do:
    # terminar o write
    # terminar o bico

int_handler:
    csrrw a6, mscratch, a6
    sw a0, 0(a6) # 
    sw a1, 4(a6) # 
    sw a2, 8(a6) # 
    sw a3, 12(a6) # 
    sw a4, 16(a6)
    sw a5, 20(a6)
    sw a7, 24(a6)
    sw t0, 28(a6)
    sw t1, 32(a6)
    sw t2, 36(a6)
    sw t3, 40(a6)
    sw t4, 44(a6)
    sw t5, 48(a6)
    sw t6, 52(a6)
    sw s0, 56(a6)
    sw s1, 60(a6)
    sw s2, 64(a6)
    sw s3, 68(a6)
    sw s4, 72(a6)
    sw s5, 76(a6)
    sw s6, 80(a6)
    sw s7, 84(a6)
    sw s8, 88(a6)
    sw s9, 92(a6)
    sw s10,96(a6)
    sw s11,100(a6)
    sw ra ,104(a6)
    sw sp, 108(a6)
    sw gp, 112(a6)
    sw tp, 116(a6)
    addi a6,a6,120
    csrrw a6,mscratch,a6

    csrr t0, mcause
    blt t0, zero, GPT # if t0 <= t1 then target


    li t1, 16
    beq a7, t1, ultrassom; # if t0 == t1 then target
    li t1,17
    beq a7,t1,servo_angles
    li t1, 18 # t1 = 
    beq a7, t1,engine_torque
    li t1,19  # t1 = 
    beq a7, t1, gps
    li t1, 20 # t1 =20 
    beq a7, t1, gyroscope; # if t0 == t1 then target
    li t1,21
    beq a7,t1,get_time
    li t1,22  # t1 = 
    beq a7,t1,set_time
    li t1, 64
    beq a7,t1,write
    j restaurar_contexto

GPT: #a terminar
    li t1,0xFFFF0104 
    lb t0, 0(t1) 
    beq zero, t0,gpt_restore; # if t0 == t1 then target

    la t1, sys_time # 
    lw t0, 0(t1) 
    addi t0, t0, 100; # t0 = t1 + imm
    sw t0, 0(t1)  
        
    li t1,0xFFFF0104  # t1 = 
    sw zero, 0(t1) # 
    

    li t1, 0xFFFF0100 # t1 = 
    li t0, 100 # t1 = 
    sw t0, 0(t1)

    j gpt_restore

ultrassom: #ultrassom feito
    li t1, 0xFFFF0020 # t1 = 
    sw zero, 0(t1)  
    loopultrassom:
        lw t0, 0(t1) # 
        beq t0, zero, loopultrassom; # if t0 == t1 then target
    li a1, 0xFFFF0024 
    lw a0, 0(a1) # 
    j restaurar_contexto_sem_a0
servo_angles:
    li t0,1  # t1 = 
    beq t0, a0, validservo # if t0 == t1 then target
    li t0,2
    beq t0,a0,validservo  # if t0 != t1 then target
    li t0,3  # t1 = 
    beq t0, a0,validservo
    li a0,-2  # t1 = 
    j end_of_servo_sys
    validservo:
        v1:
            bge a1, zero, valid_angle # if t0 >= t1 then target
            li a0,-1  # t1 = 
            j end_of_servo_sys
                valid_angle:
                    li t1, 1# t1 = 
                    beq a0, t1,servo1 # if t0 == t1 then target
                    li t1, 2 # t1 = 
                    beq a0, t1, servo2; # if t0 == t1 then target
                    j servo3                    
                    servo1:
                        li t1,16 
                        blt a1,t1,invalid_angle # if t0 <= t1 then target
                        li t1, 116  # t1 = 
                        bgt a1, t1,invalid_angle # if t0 > t1 then target
                        li t0,0xFFFF001E  # t1 = 
                        sw a1,0(t0)
                        li a0, 0 # t1 = 
                        j end_of_servo_sys  # jump to end_o
                    servo2:
                        li t1,52 # t1 = 
                        blt a1, t1, invalid_angle # if t0 < t1 then target
                        li t1, 90
                        blt t1,a1,invalid_angle # if t0 < t1 then target
                        li t0,0xFFFF001D  # t1 = 
                        sw a1, 0(t0) # 
                        li a0, 0 # t1 = 
                        j end_of_servo_sys  # jump to en
                    servo3:
                        blt a1, zero, invalid_angle # if t0 < t1 then target
                        li t1,156  # t1 = 
                        bgt a1, t1, invalid_angle # if t0 > t1 then target
                        li t0,0xFFFF001C  # t1 = 
                        sw a1, 0(t0) # 
                        li a0,0  # t1 = 
                        j end_of_servo_sys  # jump to target
    invalid_angle:
        li a0,-1  # t1 = 
        j restaurar_contexto_sem_a0  # jump to target
    end_of_servo_sys:
        j restaurar_contexto_sem_a0
engine_torque: 
    beq a0, zero, motor0 # if t0 == t1 then target
    li t1, 1  # t1 = 
    beq a0,t1,motor1
    li a0,-1  # t1 = 
    j restaurar_contexto_sem_a0  # jump to target
    
    
    motor0:
        li t1, 0xFFFF001A # t1 = 
        sh a1, 0(t1) # 
        li a0,0  # t1 = 
        j  restaurar_contexto_sem_a0 # jump to fim_set_torque
        
    motor1:
        li t1, 0xFFFF0018 # t1 = 
        sh a1, 0(t1) 
        li a0,0  # t1 = 
        j restaurar_contexto_sem_a0  # jump to 
    
gyroscope:
    li t1, 0xFFFF0004 # t1 =
    sw zero, 0(t1) 
    loopgyro:
        lw t0, 0(t1) # 
        beq t0, zero, loopgyro

    li t1, 0xFFFF0014 
    lw t2, 0(t1) 
    mv t0, t2
    andi t0,t0, 0x3FF
    sw t0, 8(a0)
    mv t0,t2
    li t4,0x3FF
    slli t4,t4,10
    and t0,t0,t4
    srli t0,t0,10
    sw t0 ,4(a0)
    mv t0,t2
    li t4, 0x3FF 
    slli t4,t4,20
    and t0,t4,t0
    srli t0,t0,20
    sw t0,0(a0)
    
    j restaurar_contexto  # jump to target
    
gps:
    li t0,0xFFFF0004
    sw zero, 0(t0)
    loopgps:
        lw t1, 0(t0) 
        beq zero,t1,loopgps
    li t0,0xFFFF0008
    lb t1, 0(t0) 
    sw t1, 0(a0) # 
    li t0, 0xFFFF000C
    lb t1, 0(t0) # 
    sw t1, 4(a0) # 
    li t0,0xFFFF0010
    lb t1, 0(t0) 
    sw t1, 8(a0)
    j restaurar_contexto    
get_time:
    la t1, sys_time # 
    lw a0, 0(t1) # 
    j restaurar_contexto_sem_a0  # jump to restaurar_c

set_time:
    la t1, sys_time
    sw a0, 0(t1) # 
    j restaurar_contexto  # jump to 
    
write: #to-do

    li t1,1  # t1 = 
    addi a0, a2, 0 # t0 = t1 + imm
    li t0,0xFFFF0109  # t1 = 
    sw t1, 0(t0)
    li t2, 0xFFFF0108 
    

    wait_uart:
        lb t3, 0(a1)
        sb t3, 0(t0)
        sb t1, 0(t2)
        uartready:
            lb t4, 0(t0)
            bne zero,t4,uartready
        addi a1, a1, 1 # t0 = t1 + imm
        addi a2, a2, -1; # t0 = t1 + imm
        bge a2,zero,wait_uart

    j restaurar_contexto_sem_a0  # jump to reast
    

restaurar_contexto_sem_a0:
    csrrw a6, mscratch, a6
    addi a6,a6, -120; # t0 = t1 + imm

    lw a1, 4(a6) # 
    lw a2, 8(a6) # 
    lw a3, 12(a6) # 
    lw a4, 16(a6)
    lw a5, 20(a6)
    lw a7, 24(a6)
    lw t0, 28(a6)
    lw t1, 32(a6)
    lw t2, 36(a6)
    lw t3, 40(a6)
    lw t4, 44(a6)
    lw t5, 48(a6)
    lw t6, 52(a6)
    lw s0, 56(a6)
    lw s1, 60(a6)
    lw s2, 64(a6)
    lw s3, 68(a6)
    lw s4, 72(a6)
    lw s5, 76(a6)
    lw s6, 80(a6)
    lw s7, 84(a6)
    lw s8, 88(a6)
    lw s9, 92(a6)
    lw s10,96(a6)
    lw s11,100(a6)
    lw ra ,104(a6)
    lw sp, 108(a6)
    lw gp, 112(a6)
    lw tp, 116(a6)

    csrr t0, mepc
    addi t0, t0, 4; # t0 = t1 + imm
    csrw mepc,t0

    csrrw a6, mscratch,a6
    mret

restaurar_contexto:
    csrrw a6, mscratch, a6
    addi a6,a6, -120; # t0 = t1 + imm
    
    lw a1, 4(a6) # 
    lw a2, 8(a6) # 
    lw a3, 12(a6) # 
    lw a4, 16(a6)
    lw a5, 20(a6)
    lw a7, 24(a6)
    lw t0, 28(a6)
    lw t1, 32(a6)
    lw t2, 36(a6)
    lw t3, 40(a6)
    lw t4, 44(a6)
    lw t5, 48(a6)
    lw t6, 52(a6)
    lw s0, 56(a6)
    lw s1, 60(a6)
    lw s2, 64(a6)
    lw s3, 68(a6)
    lw s4, 72(a6)
    lw s5, 76(a6)
    lw s6, 80(a6)
    lw s7, 84(a6)
    lw s8, 88(a6)
    lw s9, 92(a6)
    lw s10,96(a6)
    lw s11,100(a6)
    lw ra ,104(a6)
    lw sp, 108(a6)
    lw gp, 112(a6)
    lw tp, 116(a6)
    lw a0, 0(a6)
    csrrw a6, mscratch,a6

    csrr t0, mepc
    addi t0, t0, 4; # t0 = t1 + imm
    csrw mepc,t0

    mret

gpt_restore:
    csrrw a6, mscratch, a6
    lw a1, 4(a6) # 
    lw a2, 8(a6) # 
    lw a3, 12(a6) # 
    lw a4, 16(a6)
    lw a5, 20(a6)
    lw a7, 24(a6)
    lw t0, 28(a6)
    lw t1, 32(a6)
    lw t2, 36(a6)
    lw t3, 40(a6)
    lw t4, 44(a6)
    lw t5, 48(a6)
    lw t6, 52(a6)
    lw s0, 56(a6)
    lw s1, 60(a6)
    lw s2, 64(a6)
    lw s3, 68(a6)
    lw s4, 72(a6)
    lw s5, 76(a6)
    lw s6, 80(a6)
    lw s7, 84(a6)
    lw s8, 88(a6)
    lw s9, 92(a6)
    lw s10,96(a6)
    lw s11,100(a6)
    lw ra ,104(a6)
    lw sp, 108(a6)
    lw gp, 112(a6)
    lw tp, 116(a6)
    lw a0, 0(a6)
    
    
    csrrw a6, mscratch,a6
    mret

_start:
    #configurando os torques pra 0
    li t1, 0xFFFF0018 # t1 = 
    sw zero, 0(t1) # 
    li t1, 0xFFFF001A # t1 = 
    sw zero, 0(t1)

    #base
    li t1, 0xFFFF001E
    li t0,  31# t0 = 31
    sb t0, 0(t1) # 
    #mid
    li t1, 0xFFFF001D # t1 = 
    li t0, 80 # t1 = 
    sb t0, 0(t1) #
    #top
    li t1, 0xFFFF001C # t1 = 
    li t0, 78 # t1 = 
    sb t0, 0(t1) #
    
    # Configura o tratador de interrupções
    la t0, int_handler# Grava o endereço do rótulo int_handler
    csrw mtvec, t0       # no registrador mtvec
    # Habilita Interrupções Global
    csrr t1,mstatus
    # Seta o bit 7 (MPIE) 
    ori t1, t1, 0x80     # do registrador mstatus
    csrw mstatus, t1
    # Habilita Interrupções Externas
    csrr t1, mie         # Seta o bit 11 (MEIE) 
    li t2, 0x800         # do registrador mie
    or t1, t1, t2 
    csrw mie, t1
    # Ajusta o mscratch
    la   t1, reg_buffer
    # Coloca o endereço do buffer para salvar
    csrw mscratch, t1    # registradores em mscratch
    # Muda para o Modo de usuário
    csrr t1, mstatus
    # Seta os bits 11 e 12 (MPP)
    li t2, ~0x1800       # do registrador mstatus
    and t1, t1, t2       # com o valor 00
    csrw mstatus, t1
    la t0, user# Grava o endereço do rótulo user
    csrw mepc, t0        # no registrador mepc
    mret
    .align 4
    #configurando o GPT
     li t1, 0xFFFF0100 # t1 = 
     li t0, 100 # t1 = 
     sw t0, 0(t1) # 
    

user:
    li sp,0x7FFFFFC
    call main
loopinfinito:
    j loopinfinito
    
sys_time:
reg_buffer:.skip 200
    .word 0
