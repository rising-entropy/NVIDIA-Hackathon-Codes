#include<stdio.h>
#include<stdlib.h>
#include<math.h>

int computeConvolutionValue(int rowIndex, int colIndex, int mRows, int mCols, int mWidth, int convRows, int convCols, int m[mRows][mCols][mWidth], int c[convRows][convCols][mWidth]){
    int res = 0;
    for(int i=0; i<mWidth; i++){
        for(int j=0; j<convCols; j++){
            for(int k=0; k<convRows; k++){
                res += m[rowIndex+k][colIndex+j][i]*c[k][j][i];
            }
        }
    }
    return res;
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

    for(int i=0; i<mRows; i++){
        double res = 0;
        for(int j=0; j<mCols; j++){
            res += m[i][j]*c[j];
        }
        output[i] = res;
    }


    filePointer = fopen("output.txt", "w");
    for(int i=0; i<mRows; i++){
        fprintf(filePointer, "%0.6lf\n", output[i]);
    }
    fclose(filePointer);
}