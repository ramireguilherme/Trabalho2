read_ultrassonic_sensor:
    li a7, 16
    ecall
    ret
set_servo_angles:
    li a7, 17 # t1 = 
    ecall
    ret
set_engine_torque:
    li a7, 18
    ecall
    ret
read_gps:
    li a7, 19 # t1 = 
    ecall
    ret
read_gyroscope:
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
write:
    li a7, 64 # a7 = 64 
    ecall
    ret   
