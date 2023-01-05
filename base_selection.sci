// ---------------------------------------------
// ---------------------------------------------
// Author: Carlos Henrique da Silva Santos
// www.carlos-santos.com
// Selection is a procedure adoted in all 
// metaheuristic algorithm to sort and select
// best candidate solutions.
// Date: 01.Nov.2018
// ---------------------------------------------
// ---------------------------------------------


// -------------- General Ranking  -------------
function [Par, f, best] = base_selection_ranking(Pop,f, min_max,nindividuals)
    [nPop, nCrom] = size(Pop);
    nPop=nindividuals
    Par = zeros(nPop, nCrom);
    if strstr(string(min_max),"min") ~= "" then
        [of oi] = gsort(f,'g','i');
    else
        [of oi] = gsort(f);
    end
    Par = Pop(oi,:);
    f   = f(oi)
    best = Par(1,:);   

//    fit = linspace(2,0,nPop);      // ranking
//    if sum(fit)==0 then
//        cumFit = cumsum(fit)/(sum(fit)+1);
//    else
//        cumFit = cumsum(fit)/sum(fit);        
//    end
//    for i=1:nindividuals
//        index = find(cumFit < base_rand(0.0,1.0,1));
//        Par(i,:) = oPop(index($)+1,:);
//    end
endfunction

// ---- Selection of different populations----
function [pais, f_ordenado_pais] = base_selection_offsprings(populacao, f,muo, min_max)
    if strstr(string(min_max),"min") ~= "" then
        f_ordenado      = gsort(f,'g','i')
    else
        f_ordenado      = gsort(f)
    end
    [linha, coluna] = size(populacao)
    pais=[]
    f_ordenado_pais=[]
    if (linha < muo) then
        disp("muo: " + string(muo))
        disp("linha: " + string(linha))
        muo=linha
    end
    for indice_busca=1:muo
        i=1
        while (f_ordenado(indice_busca)~= f(i))
            i=i+1
        end
        pais(indice_busca,:)          = populacao(i,:)
        f_ordenado_pais(indice_busca) = f(i)        
    end
    //plot(f_ordenado_pais)
endfunction


// -------------- General Roulette Wheel   -------------
function [i] = base_selection_roulette_index(P)
    P=P+1
    r=base_rand_real(0.0,1.0,1);
    C=cumsum(P);
    i=find(r<=C,1);
endfunction

// The number of selected individual is similar to the population size
function [Par, f, best] = base_selection(Pop,f, min_max,nindividuals)
    [Par, f, best] = base_selection_ranking(Pop,f, min_max,nindividuals)
endfunction
