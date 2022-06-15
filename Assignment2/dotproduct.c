#include<stdio.h>
double Calculatedotproduct(double A[], double B[], int nv)
{
	double p = 0;
	for (int i = 0; i < nv; i++)
		p = p + A[i] * B[i];
	return p;
}
int main()
{
	int nv;
	scanf("%d”,&nv);
	double A[nv], B[nv],p;
	int i;
	for(i = 0; i < nv ; i++)
		{
		A[i]=1*i;
		}
for(i = 0; i < nv ; i++)
	{
		B[i]=2*i;
	}
    p=Calculatedotproduct(A,B,nv);
    printf("%lf",p);
	return 0;
}