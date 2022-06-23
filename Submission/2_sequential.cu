#include<stdio.h>
#include<stdlib.h>

double calculateDotProduct(double A[], double B[], int nv)
{
	double p = 0;
	for (int i = 0; i < nv; i++)
		p = p + A[i] * B[i];
	return p;
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
	double A[Nv], B[Nv],p;
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
  p = calculateDotProduct(A, B, Nv);
  filePointer = fopen("output.txt", "w");
  fprintf(filePointer, "%0.6lf\n", p);
  fclose(filePointer);
	return 0;
}