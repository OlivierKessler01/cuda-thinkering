/**
 * Add a huge amount of float on a CPU
 * Made to be a comparison point for the same computation over GPUs (see add.cu)
 */

#include <stdio.h>

__global__ void add(float *a, float *b, float *c, int N) {
  int i = (blockIdx.x * blockDim.x) + threadIdx.x;

  if (i < N) {
    c[i] = a[i] + b[i];
  }
}

int main(void) {
  int N = 1 <<26;
  size_t size = N * sizeof(float);
  float *a, *b, *c;

  a = (float *)malloc(size);
  b = (float *)malloc(size);
  c = (float *)malloc(size);

  for (int i = 0; i < N; i++) {
    a[i] = (float)rand() / (float)(RAND_MAX / 100);
    b[i] = (float)rand() / (float)(RAND_MAX / 100);
  }

  for (int i = 0; i < N; i++) {
    c[i] = a[i] + b[i];
  }

  return 0;
}
