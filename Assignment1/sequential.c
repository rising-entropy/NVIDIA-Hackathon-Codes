#include<stdio.h>
#include <stdlib.h>

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

    double arr[N];
    int i=0;
    while (fgets(line, sizeof(line), filePointer)) {
      arr[i] = strtod(line, NULL);
      i++;
    }
    fclose(filePointer);

    filePointer = fopen("output-s.txt", "w");
    double sum=0;
    for(int i=0; i<sizeof(arr)/sizeof(arr[0]); i++)
    {
        sum += arr[i];
        arr[i] = sum;
        
    }
    for(int i=0; i<sizeof(arr)/sizeof(arr[0]); i++)
    {
        fprintf(filePointer, "%0.4lf\n", arr[i]);
    }
    fclose(filePointer);
}