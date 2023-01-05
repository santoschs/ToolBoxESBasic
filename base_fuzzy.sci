function [resultado] = base_fuzzy(value, parameters, fuzzy_type)
    resultado = base_fuzzy_pertinence(rules, value, first_step)
endfunction
function [cValue, fuzzy_rules] = base_fuzzy_parameters(parameters)
    fuzzy_rules = [0, 0, 0.1, 0.3, -1; 0.2, 0.2, 0.3, 0.6, -1; 0.5, 0.95, 1, 1, -1];
    cValue = 0.1
    comando = strsplit(parameters,"=")
    var     = comando(1)
    value   = comando(2)
    var = strsubst(var,")","")
    var = strsubst(var,"(","")
    var = strsubst(var,"[","")
    var = strsubst(var,"]","")
    value = strsplit(value,",")
    if (var=="cValue")
        cValue=strtod(value(1))
    end
    // interpreting the fuzzy intervals    
    linha = strsplit(parameters,"[")
    [ln, cn] = size(linha)
    if ln>1 then
        id_parameter = 0
        for i=1:ln
            if strindex(linha(i),"]")>0
                id_parameter = i
            end
        end
        dado = linha(i)
        dado = strsplit(dado,";")
        [ln, cn] = size(dado)
        for i=1:ln
            linha = dado(i)
            linha = strsubst(linha,")","")
            linha = strsubst(linha,"(","")
            linha = strsubst(linha,"[","")
            linha = strsubst(linha,"]","")
            linha = strsplit(linha,",")
            [lc, cc] = size(linha)
            if lc > 4
                lc = 4
            end
            for j=1:lc
                fuzzy_rules(i)(j) = strtod (linha(j))
            end
        end
    end    
endfunction
// Defining interval conditions values (rules)
function [u] = base_fuzzy_rules(A, B, C, D, xe)
    if(xe < A) | (xe >= D)
        u=0; //fora da faixa
    end
    if(xe > A) & (xe < B)
        u=((xe-A)/(B-A)); // inclinação positiva
    end
    if(xe >= B) & (xe <= C)
        u=1;
    end
    if(xe > C) & (xe < D) // inclinação negativa
        u=((D-xe)/(D-C));
    end
endfunction
// Fuzzy pertinance values
function [a]= base_fuzzy_pertinence(c, N, first_step)
    //    c= [0, 0, 0.1, 0.3, -1; 0.2, 0.2, 0.3, 0.6, -1; 0.5, 0.95, 1, 1, -1];//Fuzzy sets
    a=first_step;
    LineC = 1 ;
    ProxVariavel= 3 ;
    CountLines = 1 ;
    for x=CountLines:ProxVariavel 
        //        u=0;
        c(LineC, 5) = base_fuzzy_rules(c(LineC,1), c(LineC,2), c(LineC,3), c(LineC,4), N); // rules defined by A,B,C,D,xe
        if(LineC==3 & c(LineC, 5)>=first_step)
            a=-c(LineC, 5);
        elseif (LineC==2 & c(LineC, 5)>=first_step)
            a=c(LineC, 5);
        end
        LineC = LineC + 1 ;
    end
    return(a);
endfunction


