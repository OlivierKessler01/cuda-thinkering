#include <stdio.h>

__global__ void helloFromGpu(void)
{
    printf("Hello from GPU \n");
}

int main(void)
{
    printf("Hello from CPU \n");
    helloFromGpu <<<1,10>>>();
    cudaDeviceReset();
    return 0;
}
