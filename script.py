import random

N = 100000

f = open("generate.txt", "w")

for i in range(N):
    v = str(random.randint(-999999, 999999))
    f.write(v+"\n")
f.close()