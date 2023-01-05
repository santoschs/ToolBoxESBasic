// Original do Sistema
function [resultado ]= rand_sist()
    resultado=rand();
    return resultado;
endfunction

// Distribuicao uniforme com algoritmo de L´Ecuyer (ran2)
function [ran2_minmax]= ran2(idum)
    minimo = 0;
    maximo = 1;
    IM1 = 2147483563;
    IM2 = 2147483399;
    IA1 = 40014;
    IA2 = 40692; 
    IQ1 = 53668; 
    IQ2 = 52774;
    IR1 = 12211; 
    IR2 = 3791; 
    NTAB = 32; 
    IMM1 = IM1-1;
    NDIV = 1+IMM1/NTAB;
    EPS = 3.0e-16;
    RNMX = 1.0-EPS; 
    AM = 1.0/IM1;
    idum2 = 123456789;
    iy = 0;
    iv = ones(NTAB,1)*(-200);
    ran2_minmax=maximo*1.1
    while((ran2_minmax < minimo)|(ran2_minmax>maximo)) do
        if (idum <= 0) 
            if idum==0
                idum=1
            else
                idum=-idum
            end    
            idum2 = idum;
            disp(idum2)
            for j=NTAB+7:-1:0
                k = idum/IQ1;
                idum = IA1*(idum - k*IQ1) - k*IR1;
                if (idum < 0) 
                    idum = idum + IM1;
                end
                if (j <= NTAB) 
                    iv(j+1) = idum;
                end
            end
            iy = iv(1);
        end
        k = idum/IQ1;
        idum = IA1*(idum - k*IQ1) - k*IR1;
        if (idum < 0) 
            idum = idum + IM1;
        end
        k = idum2/IQ2;
        idum2 = IA2*(idum2 - k*IQ2) - k*IR2;    // Computa idum2 = (IA2*idum) %IM2 do mesmo modo.
        if (idum2 < 0) 
            idum2 = idum2+IM2;
        end
        j = iy/NDIV;                            // Será no range 0 .. NTAB-1.
        iy = iv(j+1) - idum2;                     // Aqui idum é variado aleatoriamente, idum e idum2 são
        iv(j+1) = idum;                          // combinados para gerar a saída.
        if (iy < 1) 
            iy = iy+IMM1;
        end
        temp = AM*iy
        if (temp > RNMX) 
            ran2_01 = RNMX; // Porque usuários não esperam valores de ponto final.
        else 
            ran2_01 = temp;
        end
        ran2_minmax = ran2_01;//*(maximo-minimo) + minimo;     // Conversão para distr. uniforme com min e max.
    end
    return ran2_minmax;
endfunction

// Distribuicao gaussiana
function [resultado]=randgaus(idum)
    minimo =0
    maximo =1
    mi     = 1
    sigma2 = 10
    band = 100
    iset = 0;
    minimum=0

    limit_inf = mi - (band/2);
    limit_sup = mi + (band/2);
    gauss_misigma2=limit_inf*0.99
    while ( (gauss_misigma2<limit_inf) | (gauss_misigma2>limit_sup) ) do
        if (idum < 0) 
            iset = 0;                  // Reinicialização
        end
        if (iset == 0)  
            rsq=2.0                      
            while (rsq >= 1.0 | rsq == 0.0) do
                v1 = 2.0*ran2(0,1) - 1.0;       // tomamos dois números uniformes no quadrado
                v2 = 2.0*ran2(0,1) - 1.0;       // de -1 a +1 em cada direção,
                rsq = v1*v1 + v2*v2;             // vemos se estão no círculo unitário,
            end  // e se não são, tentamos novamente.
            fac = sqrt(-2.0*log(rsq)/rsq);
            // Agora fazemos a transformação de Box-Mueller para termos dois números aleatórios. Retorna um e salva o outra para outra vez.
            gset = v1*fac;
            iset = 1;                            // Setar flag.
            gauss_01 = v2*fac;
        else                                 // Temos um número aleatorio extra em mãos,
            iset = 0;                            // então "dessetamos" o flag,
            gauss_01 = gset;                     // e o retornamos.
        end
        gauss_misigma2 = sqrt(sigma2)*gauss_01 + mi;  // Conversão para distr. gaussiana
    end

    if (gauss_misigma2 < 0)
        gauss_misigma2 = - gauss_misigma2;
    else
        gauss_misigma2 = gauss_misigma2 + (band/2);
    end
    resultado  = (gauss_misigma2*100/band)/100;
    resultado = minimo+(maximo-minimo)*resultado;   

    return resultado;                        // com média mi e variância sigma2.
endfunction


// Distribuicao Cauchy
function [resultado] = randcauchy()
    minimo = 0
    maximo = 1
    mi     = 1
    t      = 0
    band   = 100
    limit_inf = mi - (band/2);
    limit_sup = mi + (band/2);
    cauchy_mit=limit_inf*0.99;
    while ( (cauchy_mit<limit_inf) |(cauchy_mit>limit_sup) ) do
        na_unif = ran2(0,1);
        cauchy_mit = t*tan((na_unif-(1/2))*PI) + mi;
    end   

    if (cauchy_mit < 0)
        cauchy_mit = -cauchy_mit;
    else
        cauchy_mit = cauchy_mit + (band/2);
    end
    resultado  = (cauchy_mit*100/band)/100;
    resultado = minimo+(maximo-minimo)*resultado;   
    return resultado;  
endfunction

// Distribuicao Cauchy-Gauss: Híbrida
function [resultado]=rand_hyb_gc()

    minimo=0
    maximo=1
    mi    =1
    sig_t =1
    band  =100
    beta  =0.001

    limit_inf = mi - (band/2);
    limit_sup = mi + (band/2);
    hyb_gc = limit_inf*0.99
    while ( (hyb_gc<limit_inf) | (hyb_gc>limit_sup) ) do
        gaussian = randgaus(limit_inf, limit_sup, mi, sig_t, band);
        cauchy = randcauchy(limit_inf, limit_sup, mi, sig_t, band);
        hyb_gc = gaussian + beta*cauchy;
    end    
    valor = ((hyb_gc*100)/band)/100;
    if (valor < 0)
        valor = -valor+0.5;
    end
    resultado = minimo+(maximo-minimo)*valor; 
    return resultado; 
endfunction


function [resultado]= randx(opcao)
    t = clock()
    idum = t(6);
    idum=getdate("s")
    disp(idum)
    resultado = -100;
    select opcao,
    case 1 then resultado = rand_sist();
    case 2 then resultado = ran2(idum);
    case 3 then resultado = randgaus(idum);
    case 4 then resultado = randcauchy();
    case 5 then resultado = rand_hyb_gc();
        
    end  
    return resultado
endfunction
