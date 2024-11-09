#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void cesar_encode(char* text,int shift){

    for (int i=0;text[i]!='\0';i++)
    {

        char c=text[i];
        char base;
        if (c>='a' && c<='z'){
        base='a';}

        if(c>='A' && c<='Z'){

        

        base='A';}
        text[i]=(c-base+shift)%26+base;
  

    

        
    }
}
int main(int argc,char* argv[]){
    char* text_to_encode[argc-1];
    int flag=0;
    if(argc <2){
        printf(1,"no text to encode passed\n");

    }
    else{
        flag=1;
        for (int i=1;i<argc;i++){

            text_to_encode[i-1]=argv[i];
    
        }
    }
    if(flag){
        for (int i=0;i<argc-1;i++){


        cesar_encode(text_to_encode[i],15);
  
        }

        int fd=open("result.txt",O_CREATE|O_RDWR);

        char * space=" ";
        char * next_line="\n";
        if (fd <0){
            printf(1,"Unable to open or create file \n");
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
                write(fd,space,strlen(space));
            }



            write(fd,next_line,strlen(next_line));
        }
        close(fd);

    }
    
    exit();
}
