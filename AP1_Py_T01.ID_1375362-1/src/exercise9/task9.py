def main():
    x, point = input().split()
    x = int(x)
    point = float(point)
    list_float = list()
    for i in range(x + 1):
        list_float.append(float(input()))
    result = float(0)
    for i in range(x):
        result += list_float[i] * (x - i) * point ** (x - i - 1)
    print("{:.3f}".format(result))


if __name__ == "__main__":
    main()