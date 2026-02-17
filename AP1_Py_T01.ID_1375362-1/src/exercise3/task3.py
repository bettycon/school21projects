def main():
    with open("input.txt", "r", encoding="UTF-8") as file:
        matrix = []
        for line in file:
            row = [int(x) for x in line.split()]
            if row:
                matrix.append(row)
    
    n = len(matrix)
    visited = [[False] * n for _ in range(n)]
    squares = 0
    circles = 0
    
    directions = [(1,0), (-1,0), (0,1), (0,-1)]
    
    def is_valid(i, j):
        return 0 <= i < n and 0 <= j < n
    
    def find_component(i, j):
        component = []
        stack = [(i, j)]
        visited[i][j] = True
        
        while stack:
            x, y = stack.pop()
            component.append((x, y))
            for dx, dy in directions:
                nx, ny = x + dx, y + dy
                if is_valid(nx, ny) and not visited[nx][ny] and matrix[nx][ny] == 1:
                    visited[nx][ny] = True
                    stack.append((nx, ny))
        return component
    
    def is_square(component):
        if len(component) < 4:
            return False
        
        min_i = min(x for x, y in component)
        max_i = max(x for x, y in component)
        min_j = min(y for x, y in component)
        max_j = max(y for x, y in component)
        
        width = max_j - min_j + 1
        height = max_i - min_i + 1
        
        return width == height and len(component) == width * height
    
    for i in range(n):
        for j in range(n):
            if matrix[i][j] == 1 and not visited[i][j]:
                component = find_component(i, j)
                if len(component) > 1:
                    if is_square(component):
                        squares += 1
                    else:
                        circles += 1
    
    print(squares, circles)

if __name__ == '__main__':
    main()