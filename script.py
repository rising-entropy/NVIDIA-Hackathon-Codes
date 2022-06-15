import random

N = 100000

f = open("generate.txt", "w")

f.write(str(N)+"\n")
for i in range(N):
    v = str(random.uniform(-2, 2))
    v = v[0:5]
    f.write(v+"\n")

for i in range(N):
    v = str(random.uniform(-2, 1))
    v = v[0:5]
    f.write(v+"\n")

f.close()