// ---------------------------------------------
// ---------------------------------------------
// Author: Carlos Henrique da Silva Santos
// www.carlos-santos.com
// Fitness is how the general obective function 
// is usually called by the metaheuristics devs
// Date: 18.Feb.2019
// ---------------------------------------------
// ---------------------------------------------


// -------------------------------
// Traditional Fitness
// -------------------------------
// execution of external fitness function by a name
//function z=base_execute_fitness(parametros, nome_funcao, geracao, id)
//    comando = strcat([string("z="),string(nome_funcao)]);
//    comando2 = strcat([string(comando),"(parametros, "]);
//    comando3 = strcat([string(comando2),"geracao, "]);
//    comando4 = strcat([string(comando3),"id)"]);
//    execstr(comando4);
//endfunction
//// main fitness call
//function f = base_fitness(P,nome_funcao, geracao)
//    [row col] = size(P);
//    f=[]
//    for i=1:row
//        f(i) = base_execute_fitness(P(i,:),nome_funcao, geracao, i);
//    end
//endfunction


function [z,w] = base_execute_fitness(parametros, nome_funcao, geracao, id)
    [nl, nc] = size(tokens(nome_funcao,"/"))
    if nl>1 then
        vetor = tokens(nome_funcao,"/")
        nome_funcao = vetor(nl)
    end
    comando = strcat([string("[z,w]="),string(nome_funcao)]);
    comando2 = strcat([string(comando),"(parametros, "]);
    comando3 = strcat([string(comando2),"geracao, "]);
    comando4 = strcat([string(comando3),"id)"]);
    execstr(comando4);
endfunction

// main fitness call
function [f,P] = base_fitness(P,nome_funcao, geracao)
    [row col] = size(P);
    f=[]
    for i=1:row
        [a,b] = base_execute_fitness(P(i,:),nome_funcao, geracao, i);
        f(i,:) = a
        P(i,:) = b
    end
endfunction
