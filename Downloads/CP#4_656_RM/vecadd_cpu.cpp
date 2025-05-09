#include <iostream>
#include <math.h>
#include <chrono> // For chrono timer

// Function to add the elements of two arrays
void add(int n, float *x, float *y)
{
    for (int i = 0; i < n; i++)
        y[i] = x[i] + y[i];
}

int main(void)
{
    
    // Updated prob size to 29 isnted of 21
    int N = 1 << 29;

    // Allocate memory for arrays
    float *x = new float[N];
    float *y = new float[N];

    // Initialize x and y arrays on the host
    for (int i = 0; i < N; i++) {
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    // Measure time for the add() function
    auto start = std::chrono::high_resolution_clock::now();
    add(N, x, y);
    auto end = std::chrono::high_resolution_clock::now();

    // Calculate elapsed time in milliseconds
    std::chrono::duration<float> elapsed = end - start;
    float elapsed_ms = elapsed.count() * 1000.0f; // Convert seconds to milliseconds
    std::cout << "Elapsed time: " << elapsed_ms << " ms" << std::endl;

    // Check for errors (all values should be 3.0f)
    float maxError = 0.0f;
    for (int i = 0; i < N; i++)
        maxError = fmax(maxError, fabs(y[i] - 3.0f));
    std::cout << "Max error: " << maxError << std::endl;

    // Free memory
    delete[] x;
    delete[] y;

    return 0;
}