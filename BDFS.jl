module BDFS

export findpath, countsteps, dfs_path, bfs_path, dfs_steps, bfs_steps, logspace, phi

using Graphs


# Вернёт пройденный маршрут
function findpath(p!, graph, a, b)
    visited = falses(length(graph.fadjlist))
    parent = fill(-1, length(graph.fadjlist))
    dataStructure = Int64[]
    push!(dataStructure, a)
    visited[a] = true
    while !isempty(dataStructure)
        curr_node = p!(dataStructure)             # <--- Сюда подставится нужная функция
        for neighbor in graph.fadjlist[curr_node]
            if !visited[neighbor]
                visited[neighbor] = true
                parent[neighbor] = curr_node
                push!(dataStructure, neighbor)
            end
        end
        if curr_node == b
            path = [b]
            while path[end] != a
                push!(path, parent[path[end]])
            end
            return reverse(path)
        end
    end
    return Int64[]
end

# Подставляя в 9-ю строчку выше нужную функцию удаления
# последнего или первого элемента добиваемся желаемого
dfs_path(graph, a, b) = findpath(pop!,      graph, a, b) 
bfs_path(graph, a, b) = findpath(popfirst!, graph, a, b)

# Перепишем для подсчёта количества шагов (уменьшим аллокации => увеличим быстродействие)
function countsteps(p!, graph, a, b)
    visited = falses(length(graph.fadjlist))
    dataStructure = Int64[]
    push!(dataStructure, a)
    visited[a] = true
    steps = 0
    while !isempty(dataStructure)
        curr_node = p!(dataStructure)
        steps += 1
        for neighbor in graph.fadjlist[curr_node]
            if !visited[neighbor]
                visited[neighbor] = true
                push!(dataStructure, neighbor)
            end
        end
        if curr_node == b
            return steps
        end
    end
    return -1
end
dfs_steps(graph, a, b) = countsteps(pop!,      graph, a, b) 
bfs_steps(graph, a, b) = countsteps(popfirst!, graph, a, b)


# Средняя трудоёмкость для всего графа по каждой паре вершин туда и назад
function phi(graph::SimpleGraph)
    ratio = 0.0
    n = 0
    for i in 1:nv(graph)
        for j in 1:nv(graph)
            breadth_steps = bfs_steps(graph, i, j)
            if breadth_steps <= 0
                continue
            else
                ratio += dfs_steps(graph, i, j) / breadth_steps
                n += 1
            end
        end
    end
    return ratio / n
end


logspace(
    start::Real,
    stop::Real,
    len=50,
    base=10
    ) = base.^range(start, stop, len)

logspace(
    T::DataType,
    start::Real,
    stop::Real,
    len=50,
    base=10
    ) = logspace(start, stop, len, base) .|> ceil .|> T;

end #module