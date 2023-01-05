function [population] = metaif_selection(algorithm_type, fitness_name, parameters, VarMin, VarMax, output_name, cont_alg, population)
    //-----------------------------------------------
    exec("base_rand.sci",-1)
    exec("base_fuzzy.sci",-1)
    exec("base_fitness_completo.sci",-1)
    exec("base_selection.sci",-1)
    exec("base_recombination.sci",-1)
    exec("base_mutation.sci",-1)
    exec("base_es.sci",-1)
    exec("base_entropia.sci",-1)
//    exec("base_ann_mlp.sci",-1)
    //-----------------------------------------------
    // General parameters
    //-----------------------------------------------
    ntestes=1                           // Number of tests to perform average results
    nPop=10;                            // Population Size (Colony Size)
    nPop2= 7                            // No ES são os Offpsrings e essa é a quantidade Ab no SIA e particle no PSO
    minMax="min"                        // max or min optimization
    MaxIt=1000;                          // Maximum Number of Iterations
    // ---------ES ----------- 
    esType = "mu+lambda"                //Selection Type
    // ---------PSO ----------- 
    pso_v1 = 1
    pso_v2 = 1
    pso_v3 = 1
    // -------- Bee Parameters --------
    nOnlooker=int(nPop*0.1);            // 
    beeExplorationPercentual=60         // Percentual of exploratories bees
    acCoef=1;                           // Acceleration Coefficient Upper Bound
    MR=0.5
    // ----- SIA Parameters ---------------
    clones          = 3                 // Quantidade de individuos clonados
    sigma           = 0.1               // Determinar a região para supressão no SIA
    minimo_clones   = int(nPop*0.1)     // Quantidade mínima de clones na populacao
    //----------------- parametros para o GA e ES ----------------------
    pCross    =  0.4                   // Taxa/Probabilidade (%) de recombinação
    pMut      =  0.25                  // Taxa/Probabilidade (%) de mutação
    //----------------- parametros Cuckoo ----------------------
    cuckoo_pa = 0.25
    //----------------- parametros Bat ----------------------
    ABat=0.5
    rBat=0.5
    //-----------------------------------------------
    //-----------------------------------------------    
    // Setting specfic parameters informed 
    //-----------------------------------------------
    //-----------------------------------------------    
    lista_comando = strsplit(parameters," ")
    //disp(lista_comando)
    [nls, ncls] = size(lista_comando)
    li=0
    ci=0
    id_indtemp = 0
    for cont_comando=1:nls
        comando = strsplit(lista_comando(cont_comando),"=")
        var     = comando(1)
        value   = comando(2)
        if (var=="nTest")
            ntestes=strtod(value(1))
        elseif (var=="nPop")
            temp=0
            temp=strsplit(value(1),",")
            [nl, nc] = size(temp)
            if (cont_alg > nl)
                cont_alg=nl
            end
            nPop = strtod(temp(cont_alg))
        elseif (var=="nPop2")
            nPop2=strtod(value(1))
        elseif (var=="MinMax")
            minMax=value
        elseif (var=="nIterations")
            temp=0
            temp=strsplit(value(1),",")
            [nl, nc] = size(temp)
            if (cont_alg > nl)
                cont_alg=nl
            end
            MaxIt = strtod(temp(cont_alg))            
        elseif (var=="nOnLooker")
            nOnLooker=value
        elseif (var=="beeExplorationPercentual")
            beeExplorationPercentual=strtod(value(1))
        elseif (var=="coefAcceleration")
            acCoef=strtod(value(1))
        elseif (var=="MR")
            MR=strtod(value(1))
        elseif (var=="nClones")
            clones=strtod(value(1))
        elseif (var=="sigma")
            sigma=strtod(value(1))
        elseif (var=="minClones")
            minimo_clones=strtod(value(1))
        elseif (var=="RecombinationFee")
            pCross=strtod(value(1))
        elseif (var=="MutationFee")
            pMut=strtod(value(1))
        elseif (var=="CuckooPA")
            cuckoo_pa=strtod(value(1))
        elseif(var=="batLoudness")
            ABat=strtod(value(1))
        elseif(var=="batPulseRate")
            rBat=strtod(value(1))
        elseif(var=="esType")
            esType = value            
        elseif(var=="pso_v1")
            pso_v1=strtod(value(1))
        elseif(var=="pso_v2")
            pso_v2=strtod(value(1))
        elseif(var=="pso_v3")
            pso_v3=strtod(value(1))
        elseif(var=="initial_individual_data")
            indtemp = fscanfMat(value(1))
            [li, ci] = size(indtemp)
            [lm, cm] = size(VarMax)
            if (li ~= lm) | (ci ~= cm)
                messagebox("The input individual data attributes size is different from Populational Attributes Size")
                return li
            end
        elseif(var=="id_initial_individual_data")
            id_indtemp =strtod(value(1))
        elseif(var=="taxa_entropia")
            ptaxa_entropia = strtod(value(1))
        elseif(var=="taxa_aproximacao")
            ptaxa_aproximacao = strtod(value(1))
        elseif(var=="taxa_melhores")
            ptaxa_melhores = strtod(value(1))
        end
        
    end
    //-----------------------------------------------
    nCrom = length(VarMin)
    max_id_best=zeros(MaxIt,nCrom)
    exec(fitness_name+'.sci', -1)
    testes=zeros(ntestes,MaxIt)
    BestCost=zeros(MaxIt,1)
    ptemp=0
    passada=1
    [nVar, ncol] = size(VarMin)
    // Checking previous population (set of candidate solution) pre-definition
    // In case it not happened, the following instruction will create a random 
    // population in the VarMin and VarMax range
    if  (exists("population"))==0 then
        population = zeros(nPop,nCrom)
        for i=1:nPop
            candidate = base_rand(VarMin,VarMax,nCrom)
            population(i,:) = candidate
        end
        if li>0 & ci > 0
            if id_indtemp ==0
                id_indtemp = int32(base_rand(1,nCrom,1))
            end
            population(id_indtemp,:) = indtemp' 
        end
    else
        // -----------------------------------------------------------
        // Verifying the population size to resize according to nPop
        // -----------------------------------------------------------    
        if  (cont_alg> 1) then
            [nl, nc] = size(population)
            pop_temp = zeros(nPop,nCrom)
            if (nl<nPop)
                for cont=nl:nPop
                    id=base_rand(1,nl,1)
                    pop_temp(cont,:) = population(id,:)
                end
            else//if(nl >= nPop)
                for cont=1:nPop
                    id=base_rand(1,nl,1)
                    pop_temp(cont,:) = population(id,:)
                end
            end
            population = pop_temp
        end
    end
    [nl,nc] = size(population)
    nPop=nl
    disp("metaif_selection: "+string(cont_alg)+" ; MaxIt=" + string(MaxIt)+" ; nPop="+string(nl)+" ; nPo2p="+string(nPop2)+" ; nParam="+string(nc)+"; Alg="+string(algorithm_type)+"  Fitness: " + string(fitness_name))
    //-----------------------------------------------
    mediatestes=zeros(MaxIt,1)
    for cont_teste=1:ntestes
        //acréscimo dos parametros (taxa_entropia=ptaxa_entropia, taxa_aproximacao=ptaxa_aproximacao, taxa_melhores=ptaxa_melhores)
       	if strstr(string(algorithm_type),"es") ~= ""
            [max_fit_best,  max_id_best, population] = base_es(nPop, nPop2, nCrom, VarMin, VarMax, MaxIt, pMut, esType, minMax, fitness_name, pais=population, taxa_entropia=ptaxa_entropia, taxa_aproximacao=ptaxa_aproximacao, taxa_melhores=ptaxa_melhores)
        end  
        //nome_arquivo = output_name+algorithm_type+"_fitness_"+string(cont_teste)+".dat"
        nome_arquivo = output_name+"_fitness_"+string(cont_teste)+".dat"
        csvWrite(max_fit_best,nome_arquivo)
        //nome_arquivo = output_name+algorithm_type+"_solucao_"+string(cont_teste)+".dat"
        nome_arquivo = output_name+"_solucao_"+string(cont_teste)+".dat"
        csvWrite(max_id_best,nome_arquivo)
        //nome_arquivo = output_name+algorithm_type+"_total_"+string(cont_teste)+".dat"
        nome_arquivo = output_name+"_total_"+string(cont_teste)+".dat"
        csvWrite([max_fit_best, max_id_best],nome_arquivo)
        mediatestes=mediatestes+max_fit_best/ntestes
        //Descrevendo a melhor solucao de todas as encontradas em todos os testes e algoritmos
        if strstr(minMax,"min") ~= ""
            if passada==1
                best_fit = max_fit_best(length(max_fit_best))
                [x,y] = size(max_id_best)
                best_candidate = max_id_best(x,:)
                best_algorithm = algorithm_type+"_"+string(cont_teste)
            elseif max_fit_best(length(max_fit_best)) < best_fit
                best_fit = max_fit_best(length(max_fit_best))
                best_candidate = max_id_best(x,:)
                best_algorithm = algorithm_type+"_"+string(cont_teste)
            end            
        else
            if passada==1
                best_fit = max_fit_best(length(max_fit_best))
                [x,y] = size(max_id_best)
                best_candidate = max_id_best(x,:)
                best_algorithm = algorithm_type+"_"+string(cont_teste)
            elseif max_fit_best(length(max_fit_best)) > best_fit
                best_fit = max_fit_best(length(max_fit_best))
                best_candidate = max_id_best(x,:)
                best_algorithm = algorithm_type+"_"+string(cont_teste)
            end            
        end
        passada=passada+1
    end
    // Salvando arquivos CSV de cada um dos testes
    //nome_arquivo = output_name+string(algorithm_type)+"_average_test.dat"
    nome_arquivo = output_name+"_average_test.dat"
    csvWrite(mediatestes,nome_arquivo)
    nome_arquivo = output_name+"_"+string(best_fit)+"_"+string(best_algorithm)+"_bestfit.dat"
    csvWrite(best_candidate,nome_arquivo)
endfunction
