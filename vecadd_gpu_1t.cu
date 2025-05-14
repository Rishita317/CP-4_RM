// Name: Rishita Meharishi
//Date: May 13,2025
// Course CSC656-01 Spring 2025
// Citations:NVDIA developer blog, github copilot to fix errors, class slides, 
//modifiled the given code of my own .

#include <iostream>
#include <math.h>

// CUDA kernel to add the elements of two arrays
// TODO done: Updating the add function with a prefix __global__

__global__ void add(int n, float *x, float *y)
{
    for (int i = 0; i < n; i++)
        y[i] = x[i] + y[i];
}

int main(void)
{
    // Updated problem size to 29 instead of 21
    int N = 1 << 29;

    // Allocate memory for arrays using Unified Memory
    float *x, *y;
    cudaMallocManaged(&x, N * sizeof(float));
    cudaMallocManaged(&y, N * sizeof(float));

    // Initialize x and y arrays on the host
    for (int i = 0; i < N; i++) {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    // Launch the add kernel on the GPU
    add<<<1, 1>>>(N, x, y);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // Free the allocated memory
    cudaFree(x);
    cudaFree(y);

    return 0;
}