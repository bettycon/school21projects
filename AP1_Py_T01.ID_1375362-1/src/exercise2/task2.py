def main():
    digit = int(input())
    digit_list = []
    flag = True
    
    if digit >= 0:
        if digit == 0:
            digit_list = [0]
        else:
            temp = digit
            while temp != 0:
                digit_list.append(temp % 10)
                temp = temp // 10
        
        for i in range(0, len(digit_list) // 2):
            if digit_list[i] != digit_list[len(digit_list) - 1 - i]:
                flag = False
    else:
        flag = False
    
    if flag:
        print('True')
    else:
        print('False')

if __name__ == '__main__':
    main()