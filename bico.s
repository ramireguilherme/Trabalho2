read_ultrassonic_sensor:
    li a7, 16
    ecall
set_servo_angles:
    li a7, 17 # t1 = 
    ecall
set_engine_torque:
    li a7, 18
    ecall
    ret
read_gps:
    li a7, 19 # t1 = 
    ecall
read_gyroscope:
    li a7, 20 # a7 =20 
get_time:
    li a7, 21 # t1 = 
    ecall
set_time:
    li a7, 22 # a7 = 
    ecall
write:
    li a7, 64 # a7 = 64 
    ecall    
