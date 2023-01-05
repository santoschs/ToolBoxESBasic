// ---------------------------------------------
// ---------------------------------------------
// Author: Carlos Henrique da Silva Santos
// www.carlos-santos.com
// Rand is a source code to describe many 
// different random number generator in specific 
// cases
// Date: 18.Feb.2019
// ---------------------------------------------
// ---------------------------------------------

function [resultado] = basex_real(initial, final)
//initial==VarMin   // -->não modifica nada
//final==VarMax
    [linhai, colunai] = size(initial)
    [linhaf, colunaf] = size(final)
    if linhai>1 | colunai>1 then
        if (linhai ~= linhaf) | (colunai ~= colunaf) then
            disp("Error(bee_randi): The initial and final dimensions must be equal.")
        end
        resultado = zeros(linhai, colunai)
        for i=1:linhai
            for f=1:colunai
                resultado(i,f) = rand()*(final(i,f)-initial(i,f))+initial(i,f)    
            end
        end
    else
        resultado = rand()*(final-initial)+initial
    end
endfunction

function [resultado] = basex_real3(initial, final, yy) 
    [linhai, colunai]=size(initial)
    if (linhai==1) then
        for cont_coluna=1:yy
            resultado(cont_coluna,1) = rand()*(final-initial)+initial
        end
    else
        disp("Error(bee_rand:basex_int) Wrong varsize parameter")
    end
endfunction

function [resultado3] = basex_int(initial, final) 
    resultado3 = int(basex_real(initial, final))
endfunction

function [resultado2] = basex_int3(initial, final, xx) 
    resultado2 = int(basex_real3(initial, final, xx))
endfunction

function [resultado2] = basex_rand() 
    resultado2 = basex_real(0.0,1.0)
endfunction
