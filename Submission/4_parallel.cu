#include<stdio.h>
#include<stdlib.h>
#include<math.h>

__global__ void computeSparseMultiplication(double *m_m, double *c_m, double *output_m, int N, int mCols, int mRows){
  int i;
  i = threadIdx.x;
  if (i < N)
  {
      double res = 0;
      for(int j=0; j<mCols; j++){
          int mIndex = i*mCols + j;
        res += m_m[mIndex]*c_m[j];
      }
      output_m[i] = res;
  }
}

int main(){
    FILE *filePointer;
    char line[100] = {0};
    int mRows, mCols, numberOfNonZeroElements;
    // number of elements in vector has to be equal to 
    
    filePointer = fopen("input.txt", "r");
    while(!feof(filePointer)){
        fscanf(filePointer, "%d %d %d", &mRows, &mCols, &numberOfNonZeroElements);
        break;
    }
    
    double m[mRows][mCols], c[mCols], output[mRows];

    
    for(int j=0; j<mCols; j++){
        for(int k=0; k<mRows; k++){
            m[k][j] = 0;
        }
        c[j] = 0;
    }
    
    for(int i=0; i<numberOfNonZeroElements; i++){
        while(!feof(filePointer)){
            int x, y;
            double val;
            fscanf(filePointer, "%d %d %lf", &x, &y, &val);
            m[x][y] = val;
            break;
        }
    }

    for(int i=0; i<mCols; i++){
        while(!feof(filePointer)){
            double val;
            fscanf(filePointer, "%lf", &val);
            c[i] = val;
            break;
        }
    }
    
    double *m_m, *c_m, *output_m;
    cudaMallocManaged(&m_m, sizeof(double)*mRows*mCols);
    cudaMallocManaged(&c_m, sizeof(double)*mCols);
    cudaMallocManaged(&output_m, sizeof(double)*mRows);
    
     for(int j=0; j<mCols; j++){
        for(int k=0; k<mRows; k++){
            //m_m has to be 1D
            int id = j*mRows + k; 
            m_m[id] = m[k][j];
        }
        c_m[j] = c[j];
    }
    
    computeSparseMultiplication<<<1, mRows>>>(m_m, c_m, output_m, mRows, mCols, mRows);
//     printf("%s", cudaGetErrorString(cudaGetLastError()));
    cudaDeviceSynchronize();
    
    filePointer = fopen("output.txt", "w");
    for(int i=0; i<mRows; i++){
        fprintf(filePointer, "%0.6lf\n", output_m[i]);
    }
    fclose(filePointer);
    
    cudaFree(m_m);
    cudaFree(c_m);
    cudaFree(output_m);

}