def main():
    count = int(input())
    data = set()
    for i in range(count):
        digit = int(input())
        data.add(digit)
    print(len(data))


if __name__ == "__main__":
    main()