#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
//#include "console.h"
//#include "stdio.h"
//#include "string.h"
//#include "ctype.h"
void cesar_encode(char* text,int shift){
    //printf(1,"a");
    for (int i=0;text[i]!='\0';i++)
    {

        char c=text[i];
       
        text[i]=(c-shift);

        if(  c>='a' && c<='z' && text[i]<'a')
        text[i]+=26;
         if( c<='Z' && c>='A' && text[i]<'A')
        text[i]+=26;

     //   printf(1,"%c",text[i]);

       // printf(1,c);

        
    }
}
int main(int argc,char* argv[]){
    char* text_to_encode[argc-1];
    if(argc <2){
        printf(1,"no text to encode passed");

    }
    else{
        for (int i=1;i<argc;i++){
            //printf(1,argv[i]);
            text_to_encode[i-1]=argv[i];
            //printf(1,'\n');
        }
    }
         printf(1,'%c','\n');
    for (int i=0;i<argc-1;i++){
        //printf(1,text_to_encode[i]);
        //printf(1,"functions: \n");
        cesar_encode(text_to_encode[i],1);
       // printf(1,text_to_encode[i]);
       // printf(1,'%c','\n');
        }

        int fd=open("result.txt",O_CREATE|O_RDWR);
       // printf(1,"hi \n");
        char * space=" ";
        if (fd <0){
            printf(1,"Unable to open or create file");
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
                write(fd,space,strlen(space));
            }

            //printf(1,"hi2");


        }
        close(fd);
    exit();
}
