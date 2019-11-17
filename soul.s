.globl _start
int_handler:
    csrrw a6, mscratch, a6
    sw a1, 0(a6) # 
    sw a2, 4(a6) # 
    sw a3, 8(a6) # 
    sw a4, 12(a6)
    sw a5, 16(a6)
    sw a6, 20(a6)
    sw a7, 24(a6)
    sw t0, 28(a6)
    sw t1, 32(a6)
    sw t2, 36(a6)

    li t1,0xFFFF0104 
    li t0,1  # t1 = 
    beq t0, t1, GPT; # if t0 == t1 then target


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

GPT: #a terminar
    la t1, sys_time # 
    lw t0, 0(t1) 
    addi t0, t0, 100; # t0 = t1 + imm
    sw t0, 0(t1)  
        
    li t1, 0xFFFF0100 # t1 = 
    li t0, 100 # t1 = 
    sw t0, 0(t1)
    
    li t1,0xFFFF0104  # t1 = 
    sw zero, 0(t1) # 
    

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
        sw a1, 0(t1) # 
        li a0,0  # t1 = 
        j  restaurar_contexto_sem_a0 # jump to fim_set_torque
        
    motor1:
        li t1, 0xFFFF0018 # t1 = 
        sw a1, 0(t1) 
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
    addi t0, t2, zero; # t0 = t1 + imm
    srli t0, t0, 20 #shiftando o x   
    sw t0, 0(a0) 
    addi t0, t2, zero
    and t0, t0 , 0xFFC00 #shiftando o y
    srli t2,t2,10
    sw t0, 4(a0)
    and t0,t0,0x3FF
    sw t1, 8(a0)   
    j restaurar_contexto  # jump to target
    
gps:
    li t0,0xFFFF0004
    sw zero, 0(t0)
    loopgps:
        lw t1, 0(t0) 
        beq zero,t1,loopgps
    li t1,0xFFFF0008
    lw t0, 0(t1) 
    sw t0, 0(a0) # 
    li t1, 0xFFFF000C
    lw t0, 0(t1) # 
    sw t0, 4(a0) # 
    li t1,0xFFFF0010
    lw t0, 0(t1) 
    sw t0, 8(a0)
    j restaurar_contexto    
get_time:
    la t1, sys_time # 
    lw a0, 0(t1) # 
    j restaurar_contexto_sem_a0  # jump to restaurar_c

set_time:
    la t1, sys_time
    sw a0, 0(t1) # 
    j restaurar_contexto  # jump to 
    
    
restaurar_contexto_sem_a0:
    lw a1, 0(a6) # 
    lw a2, 4(a6) # 
    lw a3, 8(a6)
    lw a4, 12(a6)
    lw a5, 16(a6)
    lw a6, 20(a6)
    lw a7, 24(a6)
    lw t1, 28(a6)
    lw t2 , 32(a6)

    csrr t0, mepc
    addi t0, t0, 4; # t0 = t1 + imm
    
    csrrw a6, mscratch,a6
    mret

restaurar_contexto:
    lw a1, 0(a6)
    
_start:
    #interrupcoes
    la t1, system_stack
    csrw mscratch, t1  # 

    la t1,  # 
    sw t1, 0(s1) # 
    
    la t0,int_handler #
    csrw mtvec, t0
    #
    csrr t1, mstatus
    ori t1, t1 , 0x80
    csrw mstatus,t1

    csrr t1, mie
    li t2, 0x800 # t2 = 
    or t1,t1,t2
    csrw mie, t1

    #modo usuario 
    csrr t1,mstatus
    li t2, ~0x1800
    and t1,t1,t2
    
    #configurando o GPT
    li t1, 0xFFFF0100 # t1 = 
    li t0, 100 # t1 = 
    sw t0, 0(t1) # 
    
    
    #configurando os torques pra 0
    li t1, 0xFFFF0018 # t1 = 
    sw zero, 0(t1) # 
    li t1, 0xFFFF001A # t1 = 
    sw zero, 0(t1)
    #

    #base
    li t1, 0xFFFF001E
    li t0,  31# t0 = 31
    sw t0, 0(t1) # 
    #mid
    li t1, 0xFFFF001D # t1 = 
    li t0, 80 # t1 = 
    sw t0, 0(t1) #
    #top
    li t1, 0xFFFF001C # t1 = 
    li t0, 78 # t1 = 
    sw t0, 0(t1) #
    
    #
    j main  # jump to target
    
.comm system_stack,100000,4
s_stack_end:
.comm user_stack, 80000,4
u_stack_end:

sys_time:
    .word 0