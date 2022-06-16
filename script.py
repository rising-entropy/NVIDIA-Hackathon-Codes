import random

N = 100

f = open("generate.txt", "w")

K = 3
L = 512
M = 512

for i in range(K):
    for j in range(L):
        for k in range(M):
            v = str(random.randint(-1, 2))
            f.write(v+" ")
        f.write("\n")

A = 3
B = 3
C = 3
for i in range(A):
    for j in range(B):
        for k in range(C):
            v = str(random.randint(-1, 2))
            f.write(v+" ")
        f.write("\n")

f.close()