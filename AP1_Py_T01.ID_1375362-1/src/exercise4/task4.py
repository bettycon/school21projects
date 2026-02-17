def main():
    digit = input()
    try:
        digit = int(digit)
        if digit <= 0:
            raise ValueError("Natural number was expected")
    except ValueError:
        print("Natural number was expected")
        return
    
    paskal = [[1] * (i + 1) for i in range(digit)]
    for i in range(2, digit):
        for j in range(1, i):
            paskal[i][j] = paskal[i - 1][j - 1] + paskal[i - 1][j]
    
    for i in range(digit):
        for j in range(len(paskal[i])):
            if j != 0:
                print(" ", end="")
            print(paskal[i][j], end="")
        print()

if __name__ == '__main__':
    main()