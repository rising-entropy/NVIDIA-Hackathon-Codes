import random

N = 100000

f = open("generate.txt", "w")

for i in range(N):
    v = str(random.uniform(0, 1))
    v = v[0:6]
    f.write(v+"\n")
f.close()