#include <stdio.h>
#include<stdlib.h>
#include<math.h>

__global__ void parallelBubbleSorting(int* arr, int N, int maxElementsInArray){
    int threadIndex = threadIdx.x;
    int indexToStartFrom = threadIndex * maxElementsInArray;
    int indexTillEnd;
    if((threadIndex+1)*maxElementsInArray -1 >= N){
        indexTillEnd = N-1;
    }
    else{
        indexTillEnd = (threadIndex+1)*maxElementsInArray -1;
    }
    printf("%d %d\n", indexToStartFrom, indexTillEnd);
    // Can have any simple sorting algorithm here...
    /* Iterative Bubble Sort Algorithm */
    
    // bubble sort is crossing its limit with other arrays
    
    for(int i=indexToStartFrom; i<=indexTillEnd; i++){
        for(int j=indexToStartFrom; j<indexTillEnd; j++){
            if(arr[j]>arr[j+1]){
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
    /* Iterative Bubble Sort Algorithm End */
}

__global__ void parallelMerging(int* arr, int* arr2, int N, int maxElementsInArray){
    int threadIndex = threadIdx.x;
    int indexToStartFrom = threadIndex * maxElementsInArray;
    int indexTillEnd;
    if((threadIndex+1)*maxElementsInArray -1 >= N){
        indexTillEnd = N-1;
    }
    else{
        indexTillEnd = (threadIndex+1)*maxElementsInArray -1;
    }
    
//     printf("%d\n", indexTillEnd);
    
    
    int startIndexOfArray1=indexToStartFrom, startIndexOfArray2=((indexTillEnd+indexToStartFrom)/2)+1;
    int endIndexOfArray1=(indexTillEnd+indexToStartFrom)/2, endIndexOfArray2=indexTillEnd;
    int currentIndexOfArray1=startIndexOfArray1, currentIndexOfArray2=startIndexOfArray2;
    
    int indexTillWhereArrayIsFilled = indexToStartFrom;
  while (currentIndexOfArray1 <= endIndexOfArray1 &&
         currentIndexOfArray2 <= endIndexOfArray2) {
    if (arr[currentIndexOfArray1] < arr[currentIndexOfArray2]) {
      arr2[indexTillWhereArrayIsFilled] = arr[currentIndexOfArray1];
      currentIndexOfArray1++;
    } else {
      arr2[indexTillWhereArrayIsFilled] = arr[currentIndexOfArray2];
      currentIndexOfArray2++;
    }
    indexTillWhereArrayIsFilled++;
  }
    
    while(currentIndexOfArray1<=endIndexOfArray1){
        arr2[indexTillWhereArrayIsFilled] = arr[currentIndexOfArray1];
        currentIndexOfArray1++;
        indexTillWhereArrayIsFilled++;
    }
    while(currentIndexOfArray2<=endIndexOfArray2){
        arr2[indexTillWhereArrayIsFilled] = arr[currentIndexOfArray2];
        currentIndexOfArray2++;
        indexTillWhereArrayIsFilled++;
    }
    
    for(int i=indexToStartFrom; i<=indexTillEnd; i++){
        arr[i] = arr2[i];
    }
}

int main() {
  FILE *filePointer;
  char line[100] = {0};
  int N = 100000;
  int i=0;
    
  size_t size = N * sizeof(int);
  int *arr;
  int *arr2;
  cudaMallocManaged(&arr, size);
  cudaMallocManaged(&arr2, size);
  filePointer = fopen("input.txt", "r");

  while (fgets(line, sizeof(line), filePointer)) {
    arr[i] = atoi(line);
    i++;
  }
  fclose(filePointer);
    
    
  // strategy -> parllelly divide into really small blocks and bubble-sort them serially
  // merge them at the end
    
  // 5 Logarithmic Partitions
  int logartithmicPartitions = 5;
  
  // parallel execution in 32 threads to sync
  int threadCount = pow(2, logartithmicPartitions);
  int maxElementsInArray = N/threadCount;

  if(N%threadCount>0){
    maxElementsInArray++;
  }
    
  parallelBubbleSorting<<<1, threadCount>>>(arr, N, maxElementsInArray);
  cudaDeviceSynchronize();
  
  for(int i=threadCount/2; i>=1; i/=2){
      maxElementsInArray *= 2;
      parallelMerging<<<1, i>>>(arr, arr2, N, maxElementsInArray);
      cudaDeviceSynchronize();
  }
    
  for(int i=0; i<N; i++){
      if(i%(2*maxElementsInArray) == 0){
          printf("\n");
      }
    printf("%d\n", arr[i]);
  }
    
  return 0;
    
    
    
    
    
//   mergeSort(arr, 0, N - 1);
  
  filePointer = fopen("output.txt", "w");
  for(int i=0; i<N; i++)
  {
    fprintf(filePointer, "%d\n", arr[i]);
    //printf("%d\n", arr[i]);
  }
  cudaDeviceSynchronize();
  cudaFree(&arr);
  cudaFree(&arr2);
}