// x = 7xx z = -7x
#include api_robot.h

int main(){
    int cfim = 0;
    int tempo;
    int d1, d2, d3, d4, d5;
    int i1, i2, i3, i4, i5;

        while (cfim < 5){
            get_current_GPS_position(pos);
            corrige_caminho();
            if (distancia_inimigo(pos, dangerous_locations) <= 12100){
                while (distancia_inimigo(pos, dangerous_locations) < 16000){
                    evita_inimigo(pos, dangerous_locations);
                    get_current_GPS_position(pos);
                }
            }
            if distancia_amigo(pos, friends_locations) < 2500{
                cfim = cfim + 1;
                deleta_amigo(friends_locations);
            }

        }

    
    return 0;
}

int[] amigo_proximo(Vector3* pos, Vector3 amigos[]){
    d1 = ((pos.x - amigos[0].x)*(pos.x - amigos[0].x)) + ((pos.z - amigos[0].z)*(pos.z - amigos[0].z));
    d2 = ((pos.x - amigos[1].x)*(pos.x - amigos[1].x)) + ((pos.z - amigos[1].z)*(pos.z - amigos[1].z));
    d3 = ((pos.x - amigos[2].x)*(pos.x - amigos[2].x)) + ((pos.z - amigos[2].z)*(pos.z - amigos[2].z));
    d4 = ((pos.x - amigos[3].x)*(pos.x - amigos[3].x)) + ((pos.z - amigos[3].z)*(pos.z - amigos[3].z));
    d5 = ((pos.x - amigos[4].x)*(pos.x - amigos[4].x)) + ((pos.z - amigos[4].z)*(pos.z - amigos[4].z));
    
    if (d1<d2 && d1<d3 && d1<d4 && d1<d5){
        return [amigos[0].x, amigos[0].z];
    }
    if (d2<d1 && d2<d3 && d2<d4 && d2<d5){
        return [amigos[1].x, amigos[1].z];
    }
    if (d3<d2 && d3<d1 && d3<d4 && d3<d5){
        return [amigos[2].x, amigos[2].z];
    }
    if (d4<d2 && d4<d3 && d4<d1 && d4<d5){
        return [amigos[3].x, amigos[3].z];
    }
    if (d5<d2 && d5<d3 && d5<d4 && d5<d1){
        return [amigos[4].x, amigos[4].z];
    }
}

int[] distancia_amigo(Vector3* pos, Vector3 amigos[]){
    d1 = ((pos.x - amigos[0].x)*(pos.x - amigos[0].x)) + ((pos.z - amigos[0].z)*(pos.z - amigos[0].z));
    d2 = ((pos.x - amigos[1].x)*(pos.x - amigos[1].x)) + ((pos.z - amigos[1].z)*(pos.z - amigos[1].z));
    d3 = ((pos.x - amigos[2].x)*(pos.x - amigos[2].x)) + ((pos.z - amigos[2].z)*(pos.z - amigos[2].z));
    d4 = ((pos.x - amigos[3].x)*(pos.x - amigos[3].x)) + ((pos.z - amigos[3].z)*(pos.z - amigos[3].z));
    d5 = ((pos.x - amigos[4].x)*(pos.x - amigos[4].x)) + ((pos.z - amigos[4].z)*(pos.z - amigos[4].z));
    
    if (d1<d2 && d1<d3 && d1<d4 && d1<d5){
        return d1;
    }
    if (d2<d1 && d2<d3 && d2<d4 && d2<d5){
        return d2;
    }
    if (d3<d2 && d3<d1 && d3<d4 && d3<d5){
        return d3;
    }
    if (d4<d2 && d4<d3 && d4<d1 && d4<d5){
        return d4;
    }
    if (d5<d2 && d5<d3 && d5<d4 && d5<d1){
        return d5;
    }
}

float raiz(float n){
    float k = n/2;
    for (int i=0; i<100; i++){
        k = (k + n/k)/2
    }
    return k;
}

void corrige_caminho(){
    int coord[2]; // coordenada amigo proximo
    int vetor[2]; // vetor que liga uoli ao amigo
    float cos;
    float hipotenusa;
    float arco;
    Vector3* pos;
    Vector3* angles;
    get_gyro_angles(angles);
    get_current_GPS_position(pos);
    coord[0] = amigo_proximo(pos, friends_locations)[0];
    coord[1] = amigo_proximo(pos, friends_locations)[1];
    vetor[0] = coord[0] - pos[0];
    vetor[1] = coord[1] - pos[1];
    hipotenusa = vetor[0]*vetor[0]+vetor[1]*vetor[1];
    hipotenusa = raiz(hipotenusa);
    cos = vetor[0]/hipotenusa;
    if (cos>=-1 && cos<=-1/2){
        arco = (-2*3,141592*cos/3)+3,141592/3;
    }
    if (cos>-1/2 && cos<=1/2){
        arco = (-3,141592*cos/3)+3,141592/2;
    }
    if (cos>1/2 && cos<=1){
        arco = (-2*3,141592*cos/3)+2*3,141592/3;
    }

    arco = arco*57,2958;

    while (angles.x - arco > 2 || angles.x - arco < -2){
        get_gyro_angles(angles);
        set_torque(0, 20);
    }
    
    set_torque(100, 100);
    set_time(0);
    float distancia;
    distancia = distancia_amigo(pos, friends_locations);
    while(get_time() < 5000){
        if (distancia < distancia_amigo(pos, friends_locations)){
            set_torque(0, 20);
            break;
        }
    }
    set_time(0);
    while(get_time() < 5000){
    }

    get_gyro_angles(angles);
    get_current_GPS_position(pos);
    coord[0] = amigo_proximo(pos, friends_locations)[0];
    coord[1] = amigo_proximo(pos, friends_locations)[1];
    vetor[0] = coord[0] - pos[0];
    vetor[1] = coord[1] - pos[1];
    hipotenusa = vetor[0]*vetor[0]+vetor[1]*vetor[1];
    hipotenusa = raiz(hipotenusa);
    cos = vetor[0]/hipotenusa;
    if (cos>=-1 && cos<=-1/2){
        arco = (-2*3,141592*cos/3)+3,141592/3;
    }
    if (cos>-1/2 && cos<=1/2){
        arco = (-3,141592*cos/3)+3,141592/2;
    }
    if (cos>1/2 && cos<=1){
        arco = (-2*3,141592*cos/3)+2*3,141592/3;
    }

    arco = arco*57,2958;

    while (angles.x - arco > 2 || angles.x - arco < -2){
        get_gyro_angles(angles);
        set_torque(0, 20);
    }
    set_torque(100, 100);
}

int[] distancia_inimigo(Vector3* pos, Vector3 inimigo[]){
    i1 = ((pos.x - inimigo[0].x)*(pos.x - inimigo[0].x)) + ((pos.z - inimigo[0].z)*(pos.z - inimigo[0].z));
    i2 = ((pos.x - inimigo[1].x)*(pos.x - inimigo[1].x)) + ((pos.z - inimigo[1].z)*(pos.z - inimigo[1].z));
    i3 = ((pos.x - inimigo[2].x)*(pos.x - inimigo[2].x)) + ((pos.z - inimigo[2].z)*(pos.z - inimigo[2].z));
    i4 = ((pos.x - inimigo[3].x)*(pos.x - inimigo[3].x)) + ((pos.z - inimigo[3].z)*(pos.z - inimigo[3].z));
    i5 = ((pos.x - inimigo[4].x)*(pos.x - inimigo[4].x)) + ((pos.z - inimigo[4].z)*(pos.z - inimigo[4].z));
    
    if (i1<i2 && i1<i3 && i1<i4 && i1<i5){
        return i1;
    }
    if (i2<i1 && i2<i3 && i2<i4 && i2<i5){
        return i2;
    }
    if (i3<i2 && i3<i1 && i3<i4 && i3<i5){
        return i3;
    }
    if (i4<i2 && i4<i3 && i4<i1 && i4<i5){
        return i4;
    }
    if (i5<i2 && i5<i3 && i5<i4 && i5<i1){
        return i5;
    }
}

int[] inimigo_proximo(Vector3* pos, Vector3 inimigo[]){
    i1 = ((pos.x - inimigo[0].x)*(pos.x - inimigo[0].x)) + ((pos.z - inimigo[0].z)*(pos.z - inimigo[0].z));
    i2 = ((pos.x - inimigo[1].x)*(pos.x - inimigo[1].x)) + ((pos.z - inimigo[1].z)*(pos.z - inimigo[1].z));
    i3 = ((pos.x - inimigo[2].x)*(pos.x - inimigo[2].x)) + ((pos.z - inimigo[2].z)*(pos.z - inimigo[2].z));
    i4 = ((pos.x - inimigo[3].x)*(pos.x - inimigo[3].x)) + ((pos.z - inimigo[3].z)*(pos.z - inimigo[3].z));
    i5 = ((pos.x - inimigo[4].x)*(pos.x - inimigo[4].x)) + ((pos.z - inimigo[4].z)*(pos.z - inimigo[4].z));
    
    if (i1<i2 && i1<i3 && i1<i4 && i1<i5){
        return [inimigo[0].x, inimigo[0].z];
    }
    if (i2<i1 && i2<i3 && i2<i4 && i2<i5){
        return [inimigo[1].x, inimigo[1].z];
    }
    if (i3<i2 && i3<i1 && i3<i4 && i3<i5){
        return [inimigo[2].x, inimigo[2].z];
    }
    if (i4<i2 && i4<i3 && i4<i1 && i4<i5){
        return [inimigo[3].x, inimigo[3].z];
    }
    if (i5<i2 && i5<i3 && i5<i4 && i5<i1){
        return [inimigo[4].x, inimigo[4].z];
    }
}


void evita_inimigo(Vector3* pos, Vector3 inimigo[]){
    set_torque(0, 0);
    get_current_GPS_position(pos);
    int coordi[2]; // coordenada inimigo proximo
    int vetori[2]; // vetor que liga uoli ao inimigo
    float cos;
    float hipotenusa;
    float arco;
    Vector3* pos;
    Vector3* angles;
    get_gyro_angles(angles);
    get_current_GPS_position(pos);
    coordi[0] = amigo_proximo(pos, friends_locations)[0];
    coordi[1] = amigo_proximo(pos, friends_locations)[1];
    vetori[0] = coordi[0] - pos[0];
    vetori[1] = coordi[1] - pos[1];
    hipotenusa = vetori[0]*vetori[0]+vetori[1]*vetori[1];
    hipotenusa = raiz(hipotenusa);
    cos = vetori[0]/hipotenusa;
    if (cos>=-1 && cos<=-1/2){
        arco = (-2*3,141592*cos/3)+3,141592/3;
    }
    if (cos>-1/2 && cos<=1/2){
        arco = (-3,141592*cos/3)+3,141592/2;
    }
    if (cos>1/2 && cos<=1){
        arco = (-2*3,141592*cos/3)+2*3,141592/3;
    }

    arco = arco*57,2958;
    
    
    while ((angles.x - arco < 88 && angles.x - arco >= 0) || (angles.x - arco > 92 && angles.x - arco >=0) || (angles.x - arco > -88 && angles.x - arco < 0) || (angles.x - arco < -92 && angles.x - arco < 0) ){
        get_gyro_angles(angles);
        set_torque(0, 20);
    }

    set_torque(100, 100);
}

void deleta_amigo(Vector3 amigos[]){
    get_current_GPS_position(pos);
    set_torque(0, 0);
    if (distancia_amigo(pos, friends_locations) == d1 && d1 < 2500){
        friends_locations[0].x = -10000;
        friends_locations[0].z = -10000;
    }
    if (distancia_amigo(pos, friends_locations) == d2 && d2 < 2500){
        friends_locations[1].x = -10000;
        friends_locations[1].z = -10000;
    }
    if (distancia_amigo(pos, friends_locations) == d3 && d3 < 2500){
        friends_locations[2].x = -10000;
        friends_locations[2].z = -10000;
    }
    if (distancia_amigo(pos, friends_locations) == d4 && d4 < 2500){
        friends_locations[3].x = -10000;
        friends_locations[3].z = -10000;
    }
    if (distancia_amigo(pos, friends_locations) == d5 && d5 < 2500){
        friends_locations[4].x = -10000;
        friends_locations[4].z = -10000;
    }
}

