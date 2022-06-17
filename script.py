from enum import unique
import random

f = open("generate.txt", "w")

rows = 500
cols = 500
nonZeroNumbers = 3000

# 3000 Unique pairs for integers between 0 - 999

lstOfPairs = []
while(len(lstOfPairs)<=nonZeroNumbers-1):
    uniquePair = [random.randint(0, rows-1), random.randint(0, cols-1)]
    if uniquePair in lstOfPairs:
        pass
    lstOfPairs.append(uniquePair)

for l in lstOfPairs:
    v = str(random.uniform(-2, 2))
    f.write(str(l[0])+" "+str(l[1])+" "+v+"\n")

for i in range(cols):
    v = str(random.uniform(-2, 2))
    f.write(v+"\n")

# for i in range(rows):
#     for j in range(cols):
#         for k in range(M):
#             v = str(random.randint(-1, 2))
#             f.write(v+" ")
#         f.write("\n")

# A = 3
# B = 3
# C = 3
# for i in range(A):
#     for j in range(B):
#         for k in range(C):
#             v = str(random.randint(-1, 2))
#             f.write(v+" ")
#         f.write("\n")

f.close()