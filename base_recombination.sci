// ---------------------------------------------
// ---------------------------------------------
// Author: Carlos Henrique da Silva Santos
// www.carlos-santos.com
// Recombination is the association between at
// least to different candidate solution to
// generate a new different candidate.
// It is an metaheuristic operator to contribute
// for the populational diversity along the 
// generations
// Date: 01.Nov.2018
// ---------------------------------------------
// ---------------------------------------------


// Simple Recombination 
function [matriz] = base_recombination_single(matriz, taxa)
    [linhas, colunas] = size(matriz)
    n_recombinacoes   = int(linhas*colunas*taxa/100)
    for i=1:n_recombinacoes    
        l1 = round(base_rand_real(0,1,1)*(linhas-1)+1);
        l2 = round(base_rand_real(0,1,1)*(linhas-1)+1);
        l3 = round(base_rand_real(0,1,1)*(linhas-1)+1);
        c  = round(base_rand_real(0,1,1)*(colunas-1)+1);
        matriz(l3,1:c) = matriz(l1,1:c)
        matriz(l3,c+1:colunas) = matriz(l1,c+1:colunas)
    end
endfunction

// Função de Recombinação dos pais para gerar filhos
function filhos = base_recombination_offspring(matriz, lambda)
    [linhas, colunas] = size(matriz)
    filhos = zeros(lambda,colunas)
    for i=1:lambda    
        l1 = round(base_rand_real(0,1,1)*(linhas-1)+1);
        l2 = round(base_rand_real(0,1,1)*(linhas-1)+1);
        if (colunas>2)
            c  = round(base_rand_real(0,1,1)*(colunas-1)+1);
        else
            c = 1;
        end
        filhos(i,1:c) = matriz(l1,1:c)
        filhos(i,c+1:colunas) = matriz(l2,c+1:colunas)
    end
endfunction

function [matriz] = base_recombination(matriz, taxa, rec_type)
    if rec_type=="single" then
        matriz = base_recombination_single(matriz, taxa)
    end
endfunction
