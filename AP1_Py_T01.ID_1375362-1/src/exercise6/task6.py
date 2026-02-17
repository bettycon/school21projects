import json

def main():
    try:
        try:
            with open("input.txt", 'r', encoding="UTF-8") as file_in:
                data = file_in.read().strip()
                if not data:
                    raise ValueError("Empty file")
                data_json = json.loads(data)
        except (FileNotFoundError, json.JSONDecodeError) as e:
            raise ValueError(f"Ошибка чтения формата json: {e}")
        
        if not isinstance(data_json, dict) or 'list1' not in data_json or 'list2' not in data_json:
            raise ValueError("json должен содержать ключи list1 и list2")
        
        if not all(isinstance(data_json.get(k), list) for k in ('list1', 'list2')):
            raise ValueError("list1 и list2 должны быть списками")
        
        for key in ('list1', 'list2'):
            for item in data_json[key]:
                if not isinstance(item, dict) or 'title' not in item or 'year' not in item:
                    raise ValueError(f"Все элементы в {key} должны быть словарями с ключами 'title' и 'year'.")
                if not isinstance(item['title'], str) or not isinstance(item['year'], int):
                    raise ValueError(f"Элементы в {key} должны содержать 'title' (str) и 'year' (int).")
        
        for key in ('list1', 'list2'):
            for i in range(1, len(data_json[key])):
                if data_json[key][i]['year'] < data_json[key][i-1]['year']:
                    raise ValueError(f"Список {key} не отсортирован по году")

    except ValueError as e:
        print(e)
        return
    
    list1 = data_json['list1']
    list2 = data_json['list2']
    merged = []
    i = j = 0
    
    while i < len(list1) and j < len(list2):
        if list1[i]['year'] <= list2[j]['year']:
            merged.append(list1[i])
            i += 1
        else:
            merged.append(list2[j])
            j += 1
    
    while i < len(list1):
        merged.append(list1[i])
        i += 1
    
    while j < len(list2):
        merged.append(list2[j])
        j += 1
    
    data_dict = {'list0': merged}
    print(json.dumps(data_dict, indent=2, ensure_ascii=False))

if __name__ == '__main__':
    main()