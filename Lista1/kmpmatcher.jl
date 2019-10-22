#pattern matching using Knuth-Morris-Pratt algorithm

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

function computePrefixF(pattern)
    m = length(pattern)
    π = Array{Int32, 1}(undef, m)
    π[1]=0
    k=0
    for q in 2:m
        while k>0 && (pattern[validIndex(pattern,k+1)]!=pattern[validIndex(pattern,q)])
            k = π[k]
        end
        if pattern[validIndex(pattern,k+1)]==pattern[validIndex(pattern,q)]
            k+=1
        end
        π[q]=k
    end
    return π
end

function KMPMatcher(text, pattern)
    n=length(text)
    m=length(pattern)
    π=computePrefixF(pattern)
    q=0 # #of matched symbols
    for i in 1:n    #traversing text from left to right
        while q>0 && pattern[validIndex(pattern,q+1)]!=text[validIndex(text,i)]
            q=π[q]  #next symbol doesn't match
        end
        if pattern[validIndex(pattern,q+1)]==text[validIndex(text,i)]
            q+=1    #next symbol matches
        end
        if q==m     #is whole pattern matched?
            println("Pattern exists at ",i-m)
            q=π[q]  #search for next pattern
        end
    end
end

pattern = ARGS[1]
text = ARGS[2]
println(text)
println(pattern)
KMPMatcher(text,pattern)
