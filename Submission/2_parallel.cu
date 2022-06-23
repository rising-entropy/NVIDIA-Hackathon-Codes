#include<stdio.h>
#include<stdlib.h>
#include<math.h>

__global__ void calculateDotProduct(double* A, double* B, int N, double* res, int maxElementsInArray)
{
    int threadIndex = threadIdx.x;
    int indexToStartFrom = threadIndex * maxElementsInArray;
    int indexTillEnd;
    if((threadIndex+1)*maxElementsInArray -1 >= N){
        // indexTillEnd = N-1; //check later
        indexTillEnd = N;
    }
    else{
        indexTillEnd = (threadIndex+1)*maxElementsInArray -1;
    }
    double sum = 0;
    for(int i=indexToStartFrom; i<=indexTillEnd; i++){
        sum += (A[i]*B[i]);
    }
    res[threadIndex] = sum;
}

int main()
{
  FILE *filePointer;
  char line[100] = {0};
    int Nv;
  filePointer = fopen("input.txt", "r");
  while (fgets(line, sizeof(line), filePointer)){
    Nv = atoi(line);
    break;
  }
    
    int numberOfThreads = 218;
    size_t size_res = numberOfThreads * sizeof(double);
    int maxElementsInArray = Nv/numberOfThreads;
    if(Nv%numberOfThreads>0){
        maxElementsInArray++;
    }
    
    
    double* A;
    double* B;
    double* res;
    size_t size = Nv * sizeof(double);
   cudaMallocManaged(&A, size);
  cudaMallocManaged(&B, size);
  cudaMallocManaged(&res, size_res);  
  int i=0;
  while (fgets(line, sizeof(line), filePointer)) {
    if(i<Nv){
      A[i] = strtod(line, NULL);
    }
    else{
      B[i-Nv] = strtod(line, NULL);
    }
    i++;
  }
  fclose(filePointer);
    
    
  calculateDotProduct<<<1, numberOfThreads>>>(A, B, Nv, res, maxElementsInArray);
  cudaDeviceSynchronize();
  
    double p=0;
    for(int i=0; i<numberOfThreads; i++){
        p += res[i];
    }
    
  filePointer = fopen("output.txt", "w");
  fprintf(filePointer, "%0.6lf\n", p);
  fclose(filePointer);
    
    cudaFree(A);
    cudaFree(B);
    cudaFree(res);
    return 0;
}