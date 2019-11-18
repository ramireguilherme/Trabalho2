set_torque:
    li t1,100  # t1 = 
    bltu t1, a0, invalid_torque
    bltu t1 ,a1,invalid_torque
    
    ret
    invalid_torque:
        li a0,-1  # t1 = 
        ret

get_us_distance:
    li a7, 16
    ecall
    ret
set_head_servo:
    li a7, 17 # t1 = 
    ecall
    ret
set_engine_torque:
    li a7, 18
    ecall
    ret
get_current_GPS_position:
    li a7, 19 # t1 = 
    ecall
    ret
read_gyro_angles:
    li a7, 20 # a7 =20
    ecall
    ret 
get_time:
    li a7, 21 # t1 = 
    ecall
    ret
set_time:
    li a7, 22 # a7 = 
    ecall
    ret
puts:
    mv  a1, a0 # t0 = t1
    li a0,1  # t1 = 
    li t0, 1
    addi t1, a1, 0  # t1 = 
    lb t2, 0(t1) 
    beq t2, zero,end_while ; # if t0 == t1 then target
    
    while:
        addi t0, t0, 1; # t0 = t1 + imm
        addi t1, t1, 1; # t0 = t1 + imm
        lb t2, 0(t1) # 
        beq t2, zero, end_while; # if t0 == t1 then target
    
    end_while:
    mv  a2, t0 # t0 = t1
    li a7, 64 # a7 = 64 
    ecall
    ret   


