// Name: Rishita Meharishi
//Date: May 13,2025
// Course CSC656-01 Spring 2025
// Citations:NVDIA developer blog, github copilot to fix errors, class slides, 
//modifiled the given code of my own .

// step 5
#include <iostream>
#include <math.h>

// CUDA kernel to add the elements of two arrays
__global__ void add(int n, float *x, float *y)
{
    // Compute the thread's unique index and stride
    int index = threadIdx.x;
    int stride = blockDim.x;

    // Each thread processes a subset of the array
    for (int i = index; i < n; i += stride)
    {
        y[i] = x[i] + y[i];
    }
}

int main(void)
{
    int N = 1 << 29; // Size of the arrays (1 million elements)

    // Allocate memory for arrays using Unified Memory
    float *x, *y;
    cudaMallocManaged(&x, N * sizeof(float));
    cudaMallocManaged(&y, N * sizeof(float));

    // Initialize arrays
    for (int i = 0; i < N; i++) {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    // Launch kernel with 256 threads and 1 block
    int threads_per_block = 256;
    int blocks_per_grid = 1;

    // from the NVIDIA tutotial article
    add<<<1, 256>>>(N, x, y);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // Print a few results to verify correctness
    std::cout << "y[0] = " << y[0] << ", y[N-1] = " << y[N-1] << std::endl;

    // Free memory
    cudaFree(x);
    cudaFree(y);

    return 0;
}