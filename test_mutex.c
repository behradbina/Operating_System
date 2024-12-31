#define CHILD_NUM 5

int main()
{
    int n = 10;
    for (int i = 0; i < CHILD_NUM; i++)
    {
        int pid = fork();

        if (!pid)
        {
            test_recursive_lock(n);
            exit();
        }
        
    }
    for (int i = 0; i < CHILD_NUM; i++)
    {
        wait();
    }

    exit();
    
}