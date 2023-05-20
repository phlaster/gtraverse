module BDFS

export findpath, countsteps, dfs_path, bfs_path, dfs_steps, bfs_steps

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
    parent = fill(-1, length(graph.fadjlist))
    dataStructure = Int64[]
    push!(dataStructure, a)
    visited[a] = true
    while !isempty(dataStructure)
        curr_node = p!(dataStructure)
        for neighbor in graph.fadjlist[curr_node]
            if !visited[neighbor]
                visited[neighbor] = true
                parent[neighbor] = curr_node
                push!(dataStructure, neighbor)
            end
        end
        if curr_node == b
            nsteps = 0                           # <--- Отличия
            while curr_node != a                 # <--- от
                curr_node = parent[curr_node]    # <--- предыдущей
                nsteps += 1                      # <--- функции
            end                                  # <--- в
            return nsteps                        # <--- этих
        end
    end
    return -1                                    # <--- строках
end

dfs_steps(graph, a, b) = countsteps(pop!,      graph, a, b) 
bfs_steps(graph, a, b) = countsteps(popfirst!, graph, a, b)


# Средняя трудоёмкость для всего графа по каждой паре вершин туда и назад
function ψᵢ_sum_biDir_for_connected(graph::SimpleGraph)
    breadth = depth = 0
    for i in 1:nv(graph)
        for j in 1:nv(graph)
            breadth += bfs_steps(graph, i, j)
            depth += dfs_steps(graph, i, j)
        end
    end
    return depth/breadth
end

end #module