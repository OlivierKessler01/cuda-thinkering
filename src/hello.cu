#include <stdio.h>

/**
 * in_device_fn - This function call only be called from the device
 */
__device__ void in_device_fn() {
  printf("Hello from in_device_fn() in GPU thread %d\n", threadIdx.x);
}

/**
 * hello_from_gpu - This function can be called from device or host
 */
__global__ void hello_from_gpu(void) {
  printf("Hello from GPU thread %d\n", threadIdx.x);
  in_device_fn();
}

int main(void) {
  printf("Hello from CPU \n");
  hello_from_gpu<<<1, 100>>>();
  printf("CPU waits \n");

  cudaError_t cudaerr = cudaDeviceSynchronize();
  if (cudaerr != cudaSuccess)
    printf("kernel launch failed with error \"%s\".\n",
           cudaGetErrorString(cudaerr));

  cudaDeviceReset();
  return 0;
}
