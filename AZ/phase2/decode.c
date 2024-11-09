#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void cesar_decode(char* text,int shift){
 
    for (int i=0;text[i]!='\0';i++)
    {

        char c=text[i];
       
        text[i]=(c-shift);

        if(  c>='a' && c<='z' && text[i]<'a')
        text[i]+=26;
         if( c<='Z' && c>='A' && text[i]<'A')
        text[i]+=26;

  
        
    }
}
int main(int argc,char* argv[]){
    int flag=0;
    char* text_to_encode[argc-1];
    if(argc <2){
        printf(1,"no text to decode passed \n");

    }
    else{
        flag=1;
        for (int i=1;i<argc;i++){

            text_to_encode[i-1]=argv[i];

        }
    }
         printf(1,'%c','\n');
         if (flag){for (int i=0;i<argc-1;i++){

        cesar_decode(text_to_encode[i],15);

        }

        int fd=open("result.txt",O_CREATE|O_RDWR);

        char * space=" ";
        char * next_line="\n";
        if (fd <0){
            printf(1,"Unable to open or create file");
            exit();
        }
       
        else{
            for (int i=0;i<argc-1;i++){
                write(fd,text_to_encode[i],strlen(text_to_encode[i]));
                write(fd,space,strlen(space));
            }

            write(fd,next_line,strlen(next_line));


        }
        close(fd);}
    
    exit();
}
