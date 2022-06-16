#include<stdio.h>
#include<stdlib.h>

__global__ void calculateDotProduct(double* a, double* b, double * c) 
{
	__shared__ double inter[threadsPerBlock];
	int id = threadIdx.x + blockIdx.x * blockDim.x;
	int j = threadIdx.x;
	
	float temp1 = 0;
	while (id < N){
		temp1 += a[id] * b[id];
		id += blockDim.x * gridDim.x;
	}
	
	inter[j] = temp1;
	__syncthreads();
	int b = blockDim.x/2;
	while (b != 0){
		if (j < i)
			inter[j] += inter[j+ b];
		__syncthreads();
		b /= 2;
	}
	
	if (j == 0)
		c[blockIdx.x] = inter[0];
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
                  double  *a, *b, sum, *c;
    	//float   *dev_a, *dev_b, *dev_c;
	cudaMallocManaged(&x, N*sizeof(float));
	cudaMallocManaged(&y, N*sizeof(float));
	//double A[Nv], B[Nv],p;
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

const int threadsPerBlock = 256;
const int blocksPerGrid = (Nv+threadsPerBlock-1) / threadsPerBlock);
calculateDotProduct<<<blocksPerGrid, threadsPerBlock>>>(a, b, c);
cudaDeviceSynchronize();

  filePointer = fopen("output.txt", "w");
  fprintf(filePointer, "%0.6lf\n", p);
  fclose(filePointer);
	return 0;
}