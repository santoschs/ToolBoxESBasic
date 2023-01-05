function [max_fit_best,  max_id_best, pais] = base_es(t_muo, t_lambda, t_nCrom, t_vMin, t_vMax, t_nGeracoes, t_pMut, es_tipo, t_min_max, t_nome_funcao, pais, taxa_entropia, taxa_aproximacao, taxa_melhores)
    // -------------- Programa Principal -------------------
    muo       = t_muo;          // Quantidade de pais (parents)
    lambda    = t_lambda;       // Quantidade filhos (offsprings)
    nCrom     = t_nCrom;        // Tamanho do Cromossomo - Quantidade de atributos
    nGeracoes = t_nGeracoes;    // Máxima quantidade de Gerações
    pMut      = t_pMut;         // Taxa/Probabilidade (%) de mutação
    vMin      = t_vMin;         // Valores mínimos aceitos por atributo
    vMax      = t_vMax;         // Valores máximos aceitos por atributo
    min_max   = t_min_max;      // Tipo de otimização "min" ou "max"
    nome_funcao = t_nome_funcao // Nome da função objetivo de interesse
    [f_pais,pais]  = base_fitness(pais, nome_funcao,0);     // Calculando o Fitness de cada Indivíduo
    // Iniciando as gerações/iterações
    for iGeracao=1:nGeracoes
        filhos  = base_recombination_offspring(pais,lambda);        
        //filhos  = es_mutacao(filhos,pMut, vMin, vMax);
        filhos  = base_mutation(filhos,pMut,VarMin, VarMax,"simple");
        [f_filhos, filhos] = base_fitness(filhos, nome_funcao, iGeracao);
        // considerando a seleção dos melhores individuos
        // de pais + filhos (muo+lambda)ES
        populacao = [pais; filhos]
        f         = [f_pais; f_filhos]
        //chamada da função entropia_shannon
        entropia = entropia_shannon(f)
        //Verifica a entropia e taxa de aproximação e gera diversidade 
        //ver o que f(1) com o Carlos para analizar o valor da taxa_aproximacao
        if entropia < taxa_entropia
            [f, populacao] = gerar_diversidade(f, populacao, VarMin, VarMax, nCrom, taxa_melhores, nome_funcao, iGeracao)
        end
        // Selecionando os melhore individuos
        [pais, f_pais]    = base_selection_offsprings(populacao,f,muo, min_max);
        max_id_best(iGeracao,:) = pais(1,:);
        max_fit_best(iGeracao)  = f_pais(1); 
        nome_arquivo = "ES/es_"+string(iGeracao)+".dat"
        csvWrite([f_pais, pais],nome_arquivo)
        //disp(max_id_best)
        //disp(max_fit_best)
        //nome_arquivo = "Resultados/ES/resultado_iterativo_es_"+string(iGeracao)+".dat"
        //disp("ES_geracao:"+string(iGeracao))
        //csvWrite([max_fit_best, max_id_best],nome_arquivo)
    end
endfunction



