#include<stdio.h>
#include <stdlib.h>
#include<math.h>

__global__ void computePrefixSum(double* arr, double *prefixArraySums, int maxElementsInArray, int N){
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
        sum += arr[i];
        arr[i] = sum;
    }
    prefixArraySums[threadIndex] = sum;
}

__global__ void computeFinalSum(double* arr, double *prefixArraySums, int maxElementsInArray, int N){
    int threadIndex = threadIdx.x;
    int indexToStartFrom = threadIndex * maxElementsInArray;
    int indexTillEnd;
    if((threadIndex+1)*maxElementsInArray -1 >= N){
        indexTillEnd = N;
    }
    else{
        indexTillEnd = (threadIndex+1)*maxElementsInArray -1;
    }
    double numberToAdd = prefixArraySums[threadIndex];
    for(int i=indexToStartFrom; i<=indexTillEnd; i++){
        arr[i] += numberToAdd;
    }
}

int main()
{
    FILE *filePointer;
    char line[100] = {0};
    int N;

    filePointer = fopen("input.txt", "r");
    while (fgets(line, sizeof(line), filePointer)) {
      N = atoi(line);
      break;
    }
    
    // divide into 32 sub-arrays
    int totalNumberOfSubArrays = 360;
    double doubleType;
    
    
    size_t size = N * sizeof(double);
    size_t size2 = totalNumberOfSubArrays * sizeof(double);
    
    double *arr;
    cudaMallocManaged(&arr, size);
    
    double *prefixArraySums;
    cudaMallocManaged(&prefixArraySums, size2);
    int maxElementsInArray = N/totalNumberOfSubArrays;
    if(N%totalNumberOfSubArrays>0){
        maxElementsInArray++;
    }
    
    int i=0;
    while (fgets(line, sizeof(line), filePointer)) {
      arr[i] = strtod(line, NULL);
      i++;
    }
    fclose(filePointer);
    
    computePrefixSum<<<1, totalNumberOfSubArrays>>>(arr, prefixArraySums, maxElementsInArray, N);
    
    cudaDeviceSynchronize();
    
    // prefix sum
    double prefSumArray = 0;
    for(int j=0; j<totalNumberOfSubArrays; j++){
        double temp = prefSumArray;
        prefSumArray += prefixArraySums[j];
        prefixArraySums[j] = temp;
    }
    
    computeFinalSum<<<1, totalNumberOfSubArrays>>>(arr, prefixArraySums, maxElementsInArray, N);
    cudaDeviceSynchronize();
    
    // only to summon the output
    
    filePointer = fopen("output-p.txt", "w");
    for(int i=0; i<N; i++)
    {
      fprintf(filePointer, "%0.4lf\n", arr[i]);
    }
    fclose(filePointer);
    cudaFree(arr);  
}