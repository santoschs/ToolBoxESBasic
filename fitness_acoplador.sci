//função Fuzzy
function [u] = fuzzy(A, B, C, D, xe)
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
    [u]=return(u);
endfunction

// Função de calculo de pertinência
function [a]=CalcPert(N)
    c= [0.0100000, 0.0100000, 0.0111111, 0.0142857, 0; 0.0125000, 0.0166667, 0.0166667, 0.0344828, 0; 0.0344828, 0.1111111, 2.000000, 2.000000, 0];//conjuntos Fuzzy
    a= 0;
    LineC = 1 ;
    ProxVariavel= 3 ;
    CountLines = 1 ;
    
    for x=CountLines:ProxVariavel
        c(LineC, 5) = fuzzy(c(LineC,1), c(LineC,2), c(LineC,3), c(LineC,4), N); // Valores: A,B,C,D,xe
        disp("c(LineC, 5) "+string(c(LineC, 5)))
        if(LineC==1 & c(LineC, 5)>0.6)
           a= -1*(c(LineC, 5)/100)/3;
        end
        if(LineC==3 & c(LineC, 5)>0.6)
           a= (c(LineC, 5)/100)/2;
        end
        LineC = LineC + 1 ;  
    end
    [a]=return(a);
endfunction


function [resultado, dados] = fitness_acoplador(dados, geracao, idx)
    unix("rm -f Acoplamento.dat")
    unix("rm -f malha-3")
    fd = mopen("malha-3", 'wt')
    mputl("      1 1.45 0.0", fd)
    mputl("      2 1.98 0.0", fd)
    mputl("      3 3.50 0.0", fd)
    [c, n] =size(dados)
    for i=1:n
        if dados(1,i) < 0.5
	    numerox="1.0"
        else
	    numerox="3.5"
        end
        if i < 7
            linha = "      "+string(i+3)+" "+numerox+" 0.0"
        elseif i < 97
            linha = "     "+string(i+3)+" "+numerox+" 0.0"
        else
            linha = "    "+string(i+3)+" "+numerox+" 0.0"
        end
        mputl(linha,fd)
    end
    mclose(fd)
    caminho = "/home/pesquisa01/Projetos/AcopladorFuzzy/2021/Entropia/ToolboxES/"
    unix(caminho+"Espalhamento");
    resultado=fscanfMat(caminho+"Acoplamento.dat");
    resultado = 1/resultado
    comando = "mv malha-3 Malhas/malha-3_"+string(geracao)+"_"+string(idx)+"_"+string(resultado)
    unix(comando)
    disp("--------------")
    disp("Geração " +string(geracao))
    disp(resultado)
    disp("--------------")
   

//   ---------------------------------------------------------
// Se for executar o fuzzy -- descomentar este trecho
// ---------------------------------------------------------
   w=CalcPert(resultado);
   resultado=resultado + w;
   disp("--------------")
   disp("Pos fuzzy")
   disp("w = "+string(w))
   disp(resultado)
   disp("--------------")
    
//    // ---------------------------------------------------------

endfunction
