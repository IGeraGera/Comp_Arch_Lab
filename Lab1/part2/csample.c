
#include <stdio.h>
#include <unistd.h>

void main(int argc, char* argv[]){
    int x,y;
    x=2;
    y=x+2019;
    printf("This is a test.\n");
    printf("Now I am going to sleep\n");
    sleep(2);
    printf("Hello and Goodmorning world .The year is %d \n",y);
    return;
}