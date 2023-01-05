// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// MetaIF....: Metaheuristics ToolBox
// Author....: Prof. Dr. Carlos Henrique da Silva Santos
// Date......: Sept 28, 2019
// Algorithms:
//  a) Artificial Immune System - opt-AiNet.: sia
//  b) Evolutionary Strategy Algorithm......: es
//  c) Genetic Algorithm....................: ga
//  d) Particle Swarm Optimization Algorithm: pso
//  e) Bat Swarm Intelligence Algorithm.....: bat
//  f) Cuckoo Swarm Intelligence Algorithm..: cuckoo
//  g) Bee Swarm Intellicence Algorithms....: beeoriginal
//                                            bee2007, bee2009, 
//                                            bee2011, bee2013
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
clc
clear
warning('off')
diretoriox = "/home/pesquisa01/Projetos/AcopladorFuzzy/2021/Entropia/ToolboxES/"
chdir(diretoriox)
exec("metaif.sci",-1)

fitness_name = "fitness_acoplador"
for i=1:107
    varMin(i)=0.0
    varMax(i)=1.0
end


parameters="nIterations=300 nPop=150 nPop2=110 MinMax=min taxa_entropia=0.4 taxa_aproximacao=0.4 taxa_melhores=10"
//p = metaif(algorithms="ga", fitness_name=fitness_name, parameters, varMin=varMin, varMax=varMax,"Resultados/rep")
p = metaif(algorithms="es", fitness_name=fitness_name, parameters, varMin=varMin, varMax=varMax,"Resultados/rep")
//p = metaif(algorithms="pso", fitness_name=fitness_name, parameters, varMin=varMin, varMax=varMax,"Resultados/rep")
//p = metaif(algorithms="cuckoo", fitness_name=fitness_name, parameters, varMin=varMin, varMax=varMax,"Resultados/rep")
//p = metaif(algorithms="sia", fitness_name=fitness_name, parameters, varMin=varMin, varMax=varMax,"Resultados/rep")
