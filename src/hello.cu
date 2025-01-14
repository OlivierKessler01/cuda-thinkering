#include <stdio.h>

__global__ void helloFromGpu(void)
{
    printf("Hello from GPU \n");
}

int main(void)
{
    printf("Hello from CPU \n");
    helloFromGpu <<<1, 10>>>();
    cudaError_t cudaerr = cudaDeviceSynchronize();
    if (cudaerr != cudaSuccess)
        printf("kernel launch failed with error \"%s\".\n",
               cudaGetErrorString(cudaerr));
    cudaDeviceReset();
    return 0;
}
