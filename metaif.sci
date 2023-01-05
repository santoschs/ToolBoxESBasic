function [population] = metaif(algorithms, fitness_name, parameters, varMin, varMax, output_name)
    //diretoriox = get_absolute_file_path('metaif.sci')
    //chdir(diretoriox)
    exec("metaif_selection.sce",-1)
    [a, nargs] = argn()
    if nargs<6 then
        messagebox("There is necessary at least 3 parameters: Algorithm Name, Fitness Function and Algorithms Parameters")
    elseif isdef("algorithms","local")==0 then 
        messagebox("You must inform algorithms parameters to execute de optimization")
    elseif isdef("fitness_name","local")==0 then 
        messagebox("You must inform fitness_name to execute de optimization")
    elseif isdef("parameters","local")==0 then 
        messagebox("You must inform fitness_name to execute de optimization")
    elseif isdef("varMin","local")==0 then 
        messagebox("You must inform lowest parameters acceptable attributes values.")
    elseif isdef("varMax","local")==0 then 
        messagebox("You must inform highest parameters acceptable attributes values.")
    elseif isdef("output_name","local")==0 then 
        messagebox("You must inform the basic filename for the output data. Ex.: Results/antenna_.")
    else
        alg_type = strsplit(algorithms,"_")
        [nalgs, a] = size(alg_type)        
        [a, nfit] = size(fileinfo(fitness_name+'.sci')) // Checking the fitness call existance
        if  nfit > 0
            // Counting and selecting current metaheuristic
            for cont_algs = 1:nalgs
                // In case the algorithm is higher than 1, it must receive a previous population from ascendent algorithm
                output_name = output_name+"_"+string(alg_type(cont_algs))+"_"
                if (cont_algs > 1)
                    [population] = metaif_selection(algorithm_type=alg_type(cont_algs), fitness_name, parameters, VarMin=varMin, VarMax=varMax, output_name, cont_alg=cont_algs, population=population)
                else
                    [population] = metaif_selection(algorithm_type=alg_type(cont_algs), fitness_name, parameters, VarMin=varMin, VarMax=varMax, output_name, cont_alg=cont_algs)
                end
            end
        end
    end
endfunction
