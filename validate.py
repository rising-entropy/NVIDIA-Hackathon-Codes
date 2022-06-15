expectedFile = "f1.txt"
testFile = "f2.txt"

def main():
    f1 = open(expectedFile, "r")
    f2 = open(testFile, "r")
    v1 = f1.read()
    v2 = f2.read()
    v1 = v1.split("\n")
    v2 = v2.split("\n")

    for i in range(len(v1)):
        if v1[i] != v2[i]:
            print("Error - Not Matched")
            print("Expected -", v1[i])
            print("Found -", v2[i])
            print("Line No. -", i+1)
            return
    print("Both Files Matched! No error found!")

if __name__=="__main__":
    main()