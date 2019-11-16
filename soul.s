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


    li t1, 16
    beq a7, t1, ultrassom; # if t0 == t1 then target
    li t1, 18 # t1 = 
    beq a7, t1,set_engine_torque 
    li t1, 20 # t1 =20 
    beq a7, t1, read_gyroscope; # if t0 == t1 then target

    
GPT:
    li t1, 0xFFFF0100 # t1 = 
    li t0, 1 # t1 = 
    sw t0, 0(t1) 
ultrassom: #ultrassom feito
    li t1, 0xFFFF0020 # t1 = 
    sw zero, 0(t1) # 
    loopultrassom:
        lw t0, 0(t1) # 
        beq t0, zero, loopultrassom; # if t0 == t1 then target
    li a1, 0xFFFF0024# a1 = 
    lw a0, 0(a1) # 
    j restaurar_contexto
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
        li t0, 360
        ble t0, a0, # if t0 <= t1 then target
        
    end_of_servo_sys:
        j restaurar_contexto
set_engine_torque:
    #ve se a0 eh igual a 0 ou 1
    li t1, 0 # t1 =0 
    beq a0, t1, c # if t0 == t1 then target
    li t1, 1  # t1 = 
    beq a0,t1,c
    li a0,-1  # t1 = 
    mret#tenq restaurar o contexto
    motor1:
        li t1, 0xFFFF001A # t1 = 
        sw a1, 0(t1) # 
        j fim_set_torque  # jump to fim_set_torque
        
    motor2:
        li t1, 0xFFFF0018 # t1 = 
        sw a1, 0(t1) 
    fim_set_torque: 

        li a0, 0 # a0 =0 
        j restaurar_contexto
        
read_gyroscope:
    li t1, 0xFFFF0004 # t1 =
    li t2,1  # t1 = 
    sw t2, 0(t1) #
    li t1, 0xFFFF0014 # t1 = 
    lw t2, 0(t1) 
    addi t0, t2, zero; # t0 = t1 + imm
    srli t0, t0 , 20 #shiftando o x   
    sw t0, 0(a0) # 
    addi t0, t2, zero
    and t0, t0 , 0xFFC00
    srli t2,t2,10
    sw t0, 4(a0)

    sw t1, 8(a0) # 
            
    
    addi t0, t2, zero; # t0 = t1 + imm
    sw t1, 0(s1) # 
gps:
    


restaurar_contexto:
    lw a1, 0(a6) # 
    lw a2, 4(a6) # 
    lw a3, 8(a6)
    lw a4, 12(a6)
    lw a5, 16(a6)
    lw a6, 20(a6)
    lw a7, 24(a6)
    lw t1, 28(a6)
    lw t2 , 32(a6)

    csrrw a6, mscratch,a6
    mret
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
