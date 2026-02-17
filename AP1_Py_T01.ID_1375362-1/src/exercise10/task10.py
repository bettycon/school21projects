def main():
    try:
        n, time_work = input().split()
        n = int(n)
        time_work = int(time_work)
        apparat = {}
        for i in range(n):
            temp_list_int = list(map(int, input().split()))
            year, cost, time = temp_list_int
            if year not in apparat:
                apparat[year] = []
            apparat[year].append((cost, time))
            
    except ValueError as e:
        print(f"Неверный ввод: {e}")
        return
    
    min_total_cost = float('inf')
    
    for year, devices in apparat.items():
        if len(devices) < 2:
            continue
            
        for i in range(len(devices)):
            for j in range(i + 1, len(devices)):
                cost1, time1 = devices[i]
                cost2, time2 = devices[j]
                
                if time1 + time2 >= time_work:
                    total_cost = cost1 + cost2
                    if total_cost < min_total_cost:
                        min_total_cost = total_cost
    
    if min_total_cost == float('inf'):
        print("Решение не найдено")
    else:
        print(min_total_cost)

if __name__ == '__main__':
    main()