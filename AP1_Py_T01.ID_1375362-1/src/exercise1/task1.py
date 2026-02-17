def main():
    result = 0.0
    vector1 = input().split()
    vector1 = [float(x) for x in vector1]
    vector2 = input().split()
    vector2 = [float(x) for x in vector2]
    for i in range(0, len(vector2)):
        result += vector1[i] * vector2[i]
    print(result)


if __name__ == '__main__':
    main()
