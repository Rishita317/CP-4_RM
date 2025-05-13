// step 7

#include <iostream>
#include <math.h>

// CUDA kernel to add the elements of two arrays
__global__ void add(int n, float *x, float *y)
{
    // Compute the thread's unique index and stride
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;

    // Each thread processes a subset of the array
    for (int i = index; i < n; i += stride)
    {
        y[i] = x[i] + y[i];
    }
}

int main(void)
{
    int N = 1 << 20; // Size of the arrays (1 million elements)

    // Allocate memory for arrays using Unified Memory
    float *x, *y;
    cudaMallocManaged(&x, N * sizeof(float));
    cudaMallocManaged(&y, N * sizeof(float));

    // Initialize arrays
    for (int i = 0; i < N; i++) {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    // Define block size and calculate the number of blocks
    int blockSize = 256;
    int numBlocks = (N + blockSize - 1) / blockSize;

    // Print the number of thread blocks
    std::cout << "Number of thread blocks: " << numBlocks << std::endl;

    // Launch kernel with calculated number of blocks and threads per block
    add<<<numBlocks, blockSize>>>(N, x, y);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // Print a few results to verify correctness
    std::cout << "y[0] = " << y[0] << ", y[N-1] = " << y[N-1] << std::endl;

    // Free memory
    cudaFree(x);
    cudaFree(y);

    return 0;
}