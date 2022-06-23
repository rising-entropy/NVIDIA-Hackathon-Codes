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
    int m[mRows][mCols][mWidth], c[convRows][convCols][mWidth];
    
    outputRows = mRows - convRows + 1;
    outputCols = mCols - convCols + 1;
    int output[outputRows][outputCols];
    
    for(int i=0; i<mWidth; i++){
        for(int j=0; j<mCols; j++){
            for(int k=0; k<mRows; k++){
                while(!feof(filePointer)){
                    fscanf(filePointer, "%d", &m[k][j][i]);
                    break;
                }
            }
        }
    }
    for(int i=0; i<mWidth; i++){
        for(int j=0; j<convCols; j++){
            for(int k=0; k<convRows; k++){
                while(!feof(filePointer)){
                    fscanf(filePointer, "%d", &c[k][j][i]);
                    break;
                }
            }
        }
    }

    // start finding convolutions
    for(int i=0; i<outputCols; i++){
        for(int j=0; j<outputRows; j++){
            
            
            int res = 0;
            for(int ii=0; ii<mWidth; ii++){
                for(int jj=0; jj<convCols; jj++){
                    for(int kk=0; kk<convRows; kk++){
                        res += m[j+kk][i+jj][ii]*c[kk][jj][ii];
                    }
                }
            }
            
            
            output[j][i] = res;
        }
    }

//     for(int i=0; i<outputCols; i++){
//         for(int j=0; j<outputRows; j++){
//             printf("%d ", output[j][i]);
//         }
//         printf("\n");
//     }

    filePointer = fopen("output.txt", "w");
    for(int i=0; i<outputCols; i++){
        for(int j=0; j<outputRows; j++){
            fprintf(filePointer, "%d ", output[j][i]);
        }
        fprintf(filePointer, "\n");
    }
    fclose(filePointer);
}