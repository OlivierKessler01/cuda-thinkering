/**
 * Add a huge amount of float on a GPU
 */

#include <cuda_runtime.h>
#include <stdio.h>
#include <sys/time.h>

__global__ void add(float *a, float *b, float *c, int N) {
  int i = (blockIdx.x * blockDim.x) + threadIdx.x;

  if (i < N) {
    c[i] = a[i] + b[i];
  }
}

int main(void) {
  float *a, *b, *c, *d_a, *d_b, *d_c;

  int dev = 0;
  cudaDeviceProp deviceProp;
  cudaGetDeviceProperties_v2(&deviceProp, dev);
  printf("Using device %d: %s\n", dev, deviceProp.name);
  cudaSetDevice(dev);

  int nElem = 1 << 26;
  size_t size = nElem * sizeof(float);
  printf("Vector size %d\n", nElem);

  a = (float *)malloc(size);
  b = (float *)malloc(size);
  c = (float *)malloc(size);

  for (int i = 0; i < nElem; i++) {
    a[i] = (float)rand() / (float)(RAND_MAX / 100);
    b[i] = (float)rand() / (float)(RAND_MAX / 100);
  }

  cudaMalloc(&d_a, size);
  cudaMalloc(&d_b, size);
  cudaMalloc(&d_c, size);

  cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

  int iLen = 1024;
  dim3 block(iLen);
  dim3 grid((nElem + block.x - 1) / block.x);

  add<<<grid, block>>>(d_a, d_b, d_c, nElem);

  printf("add<<%d,%d>>\n", grid.x, block.x);

  cudaError_t cudaerr = cudaDeviceSynchronize();

  if (cudaerr != cudaSuccess)
    printf("kernel launch failed with error \"%s\".\n",
           cudaGetErrorString(cudaerr));

  cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  free(a);
  free(b);
  free(c);

  return 0;
}
