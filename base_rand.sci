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
function [resultado] = base_rand_real(initial, final, yyx)
    //initial==VarMin   // -->não modifica nada
    //final==VarMax
    [linhai, colunai] = size(initial)
    [linhaf, colunaf] = size(final)
    resultado=0
    if (linhai ~= linhaf) | (colunai ~= colunaf) then
        messagebox("Error(bee_rand: base_rand_kk): The initial and final dimensions must be equal.")
    elseif exists("yyx","local")==0 | yyx==0 then
        yyx=1
    else
        if colunai==1 & linhai>1
            colunai=linhai
            linhai=1
        end
        
        if linhai==1 & colunai==1 & yyx==1
            resultado = rand()*(final-initial)+initial
        elseif linhai==1 & colunai==1 & yyx>1
            resultado = rand(1,yyx)*(final-initial)+initial        
        else
            if colunai==1 & yyx>1
                final  = ones(yyx)*final
                initial= ones(yyx)*initial
            elseif colunai<yyx
                resultado = zeros(yyx, colunai)            
                for i=1:yyx
                    for f=1:colunai
                        resultado(i,f) = rand()*(final(f)-initial(f))+initial(f)
                    end
                end
            elseif colunai==yyx
                resultado = zeros(1,colunai)
                for f=1:colunai
                    resultado(f) = rand()*(final(f)-initial(f))+initial(f)
                end

            end
        end
    end
endfunction

function [resultado3] = base_rand_int(initial, final) 
    resultado3 = int(base_rand_real(initial, final,1))
endfunction

function [resultado2] = base_rand_int3(initial, final, xx) 
    resultado2 = int(base_rand_real(initial, final, xx))
endfunction

function [resultado2] = base_rand(initial, final, x) 
    resultado2 = base_rand_real(initial, final,x)
endfunction
