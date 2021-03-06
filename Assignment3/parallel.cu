#include<stdio.h>
#include<stdlib.h>
#include<math.h>

// int computeConvolutionValue(int rowIndex, int colIndex, int mRows, int mCols, int mWidth, int convRows, int convCols, int m[mRows][mCols][mWidth], int c[convRows][convCols][mWidth]){
//     int res = 0;
//     for(int i=0; i<mWidth; i++){
//         for(int j=0; j<convCols; j++){
//             for(int k=0; k<convRows; k++){
//                 res += m[rowIndex+k][colIndex+j][i]*c[k][j][i];
//             }
//         }
//     }
//     return res;
// }

__global__ void computeConvolutionValue(int mRows, int mCols, int mWidth, int convRows, int convCols, int *m, int *c, int *output, int outputCols, int outputRows){
    int rowIndex=threadIdx.x, colIndex=blockIdx.x;
    // we need the index of m[rowIndex][colIndex][0]
    int res = 0;
    for(int i=0; i<mWidth; i++){
        for(int j=0; j<convCols; j++){
            for(int k=0; k<convRows; k++){
                //m[rowIndex+k][colIndex+j][i]*c[k][j][i]
                int indexOfC = i*(convCols*convRows) + (j*convRows) + k;
                int indexOfM = i*(mRows*mCols) + ((colIndex+j)*mRows) + (rowIndex+k);
                res += (c[indexOfC] * m[indexOfM]);
            }
        }
    }
    
    int indexToFillInValue = rowIndex + (outputRows*colIndex);
    output[indexToFillInValue] = res;
}

int main(){
    FILE *filePointer;
    char line[100] = {0};
    int mRows, mCols, mWidth, convRows, convCols;
    int outputRows, outputCols;
    int i=0;
    
    filePointer = fopen("input.txt", "r");
    while(!feof(filePointer)){
        fscanf(filePointer, "%d %d %d %d %d", &mRows, &mCols, &mWidth, &convRows, &convCols);
        break;
    }
//     int m[mRows][mCols][mWidth], c[convRows][convCols][mWidth];
    int *m, *c, *output;
    cudaMallocManaged(&m, sizeof(int)*mRows*mCols*mWidth);
    cudaMallocManaged(&c, sizeof(int)*convRows*convCols*mWidth);

    outputRows = mRows - convRows + 1;
    outputCols = mCols - convCols + 1;
//     int output[outputRows][outputCols];
    cudaMallocManaged(&output, sizeof(int)*outputRows*outputCols);
    
    int m_input[mRows][mCols][mWidth], c_input[convRows][convCols][mWidth];
    
    for(int i=0; i<mWidth; i++){
        for(int j=0; j<mCols; j++){
            for(int k=0; k<mRows; k++){
                while(!feof(filePointer)){
                    fscanf(filePointer, "%d", &m_input[k][j][i]);
                    break;
                }
            }
        }
    }
    for(int i=0; i<mWidth; i++){
        for(int j=0; j<convCols; j++){
            for(int k=0; k<convRows; k++){
                while(!feof(filePointer)){
                    fscanf(filePointer, "%d", &c_input[k][j][i]);
                    break;
                }
            }
        }
    }
    int val = 0;
    for(int i=0; i<mWidth; i++){
        for(int j=0; j<convCols; j++){
            for(int k=0; k<convRows; k++){
                c[val] = c_input[k][j][i];
                val++;
            }
        }
    }
    
    val = 0;
    for(int i=0; i<mWidth; i++){
        for(int j=0; j<mCols; j++){
            for(int k=0; k<mRows; k++){
                m[val] = m_input[k][j][i];
                val++;
            }
        }
    }
    
    
    int m2[mRows][mCols][mWidth], c2[convRows][convCols][mWidth];
    
    for(int i=0; i<mWidth*convCols*convRows; i++){
        
        int z = i/(convCols*convRows);
        int v = i - z*(convCols*convRows);
        int y = v/convRows;
        v -= y*convRows;
        int x = v;
        c2[x][y][z] = c[i];
    }
    
    for(int i=0; i<mWidth*mCols*mRows; i++){
        
        int z = i/(mCols*mRows);
        int v = i - z*(mCols*mRows);
        int y = v/mRows;
        v -= y*mRows;
        int x = v;
        m2[x][y][z] = m[i];
    }
    
    computeConvolutionValue<<<outputCols, outputRows>>>(mRows, mCols, mWidth, convRows, convCols, m, c, output, outputCols, outputRows);
    cudaDeviceSynchronize();
    
    int output_final[outputRows][outputCols];
    
    filePointer = fopen("output.txt", "w");
    
    val = 0;
    for(int i=0; i<outputCols*outputRows; i++){
//         printf("%d ", output[i]);
        fprintf(filePointer, "%d ", output[i]);
        val++;
        if(val==outputRows){
            val = 0;
//             printf("\n");
            fprintf(filePointer, "\n");
        }
    }
    
    fclose(filePointer);
    
    cudaFree(m);
    cudaFree(c);
    cudaFree(output);
    
    return 0;
}