def main():
    s = input().strip()
    
    if not s:
        print("Incorrect input")
        return
    
    for char in s:
        if char not in '+-.0123456789':
            print("Incorrect input")
            return
    
    has_sign = False
    for i, char in enumerate(s):
        if char in '+-':
            if i != 0:
                print("Incorrect input")
                return
            has_sign = True
        elif char == '.':
            break
    
    if s.count('.') > 1:
        print("Incorrect input")
        return
    
    if s in ['+', '-', '.', '+.', '-.']:
        print("Incorrect input")
        return
    
    if has_sign and len(s) == 1:
        print("Incorrect input")
        return
    
    sign = 1
    if s.startswith('-'):
        sign = -1
        s = s[1:]
    elif s.startswith('+'):
        s = s[1:]
    
    if not s:
        print("Incorrect input")
        return
    
    if '.' in s:
        parts = s.split('.')
        if len(parts) != 2:
            print("Incorrect input")
            return
        integer_part, fractional_part = parts
        if integer_part == '':
            integer_part = '0'
        if fractional_part == '':
            fractional_part = '0'
    else:
        integer_part = s
        fractional_part = '0'
    
    if not integer_part.isdigit() or not fractional_part.isdigit():
        print("Incorrect input")
        return
    
    int_value = 0
    for digit in integer_part:
        int_value = int_value * 10 + int(digit)
    
    frac_value = 0
    for digit in fractional_part:
        frac_value = frac_value * 10 + int(digit)
    
    result = sign * (int_value + frac_value / (10 ** len(fractional_part)))
    result *= 2
    print("{:.3f}".format(result))

if __name__ == '__main__':
    main()