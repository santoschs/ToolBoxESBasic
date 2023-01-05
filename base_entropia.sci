function E = entropia_shannon(d)
    d=string(d);
    n=unique(string(d));
    N=size(d,'r');
 
    count=zeros(n);
    n_size = size(n,'r');
    for i = 1:n_size
       count(i) = sum(d == n(i));
    end
 
    E=0;
    for i=1:length(count)
        E = E - count(i)/N * log10(count(i)/N) / log10(N);
    end
endfunction

function [f, pop] = gerar_diversidade(f, pop, VarMin,VarMax,nCrom, nome_funcao, iGeracao)
    for i=50:100 // Carlos pediu essa alteração para ficar mais rápido e trocar apenas 30% da população
        candidate = base_rand(VarMin,VarMax,nCrom)
        population(i,:) = candidate
        [f(i), candidate] = base_fitness(candidate, nome_funcao,iGeracao);
    end
endfunction
        
