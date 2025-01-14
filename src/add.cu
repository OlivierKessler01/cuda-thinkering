#include <stdio.h>

__global__ void add(float *a, float *b, float *c, int N) {
  int i = (blockIdx.x * blockDim.x) + threadIdx.x;

  if (i < N) {
    c[i] = a[i] + b[i];
  }
}

int main(void) {
  int N = 8;
  size_t size = N * sizeof(float);
  float *a, *b, *c, *d_a, *d_b, *d_c;

  a = (float *)malloc(size);
  b = (float *)malloc(size);
  c = (float *)malloc(size);

  for (int i = 0; i < N; i++) {
    a[i] = (float)rand() / (float)(RAND_MAX / 100);
    b[i] = (float)rand() / (float)(RAND_MAX / 100);
  }

  cudaMalloc(&d_a, size);
  cudaMalloc(&d_b, size);
  cudaMalloc(&d_c, size);

  cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_c, c, size, cudaMemcpyHostToDevice);

  add<<<2, 4>>>(d_a, d_b, d_c, N);

  cudaError_t cudaerr = cudaDeviceSynchronize();
  if (cudaerr != cudaSuccess)
    printf("kernel launch failed with error \"%s\".\n",
           cudaGetErrorString(cudaerr));

  cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

  printf("Results : \n");
  for (int i = 0; i < N; i++) {
    printf("%f + %f = %f \n", a[i], b[i], c[i]);
  }

  return 0;
}
