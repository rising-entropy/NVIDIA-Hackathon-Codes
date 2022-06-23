#include <stdio.h>
#include<stdlib.h>

void bubbleSort(int arr[], int l, int r) {
  for(int i=l; i<=r; i++){
      for(int j=l; j<r; j++){
          if(arr[j]>arr[j+1]){
              int temp = arr[j];
              arr[j] = arr[j+1];
              arr[j+1] = temp;
          }
      }
  }
}


int main() {
  FILE *filePointer;
  char line[100] = {0};
  int N = 100000;
  int arr[N], i=0;

  filePointer = fopen("input.txt", "r");

  while (fgets(line, sizeof(line), filePointer)) {
    arr[i] = atoi(line);
    i++;
  }
  fclose(filePointer);
  bubbleSort(arr, 0, N - 1);
  
  filePointer = fopen("output.txt", "w");
  for(int i=0; i<N; i++)
  {
    fprintf(filePointer, "%d\n", arr[i]);
    //printf("%d\n", arr[i]);
  }
}