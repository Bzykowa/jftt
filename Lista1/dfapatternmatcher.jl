#Pattern matching algorithm using FA

#For proper Unicode handling
function validIndex(pattern, idx)
    if idx == 0
        return 0
    end
    i = 1
    for ind in eachindex(pattern)
        if i == idx
            return ind
        end
        i+=1
    end
    println("Index out of bound")
    lastindex(pattern)
end

#computing FA passes
function computeδ(pattern, alphabet)
    m = length(pattern)
    n = length(alphabet)
    δ = Dict{Tuple{Int32, Char}, Int32}()
    for q in 0:m
        for a in alphabet
            k = min(m,q+1)
            while .!(endswith(pattern[1:validIndex(pattern,q)]*a, pattern[1:validIndex(pattern,k)]))
                k-=1
            end
            δ[(q,a)] = k
        end
    end
    return δ
end

function FAMatcher(T, δ, m)
    n = length(T)
    q = 0
    for i in 1:n
        q = δ[(q,T[validIndex(T,i)])]
        if q == m
            println("Pattern found at: ",i-m)
        end
    end
end

alphabet = ARGS[1]
pattern = ARGS[2]
text = ARGS[3]
println(text)
println(pattern)
δ=computeδ(pattern, alphabet)
#println(δ)
FAMatcher(text, δ, length(pattern))
