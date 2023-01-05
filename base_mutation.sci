// ---------------------------------------------
// ---------------------------------------------
// Author: Carlos Henrique da Silva Santos
// www.carlos-santos.com
// Mutation is a source code to describe many 
// individual random change operator in order 
// to contribute for its populational diversity 
// along the iteractive process (generations).
// Date: 01.Nov.2018
// ---------------------------------------------
// ---------------------------------------------


// General Call
function matriz = base_mutation(matriz, taxa, vMin, vMax, mutType)
    if strcmp(mutType,"simple")==0
        matriz = base_mutation_simple(matriz, taxa, vMin, vMax)
    elseif strcmp(mutType,"hypermutation")==0
        matriz = base_mutation_hypermutation(matriz, vMin, vMax)
    else
        messagebox("Error(base_Mutation): Undefined or Incorrect Mutation Type ("+mutType+")")
    end
endfunction
// -------------------------------
// Traditional Mutation
// -------------------------------
function matriz = base_mutation_simple(matriz, taxa, vMin, vMax)
    [linhas, colunas] = size(matriz)
    [minLinhas, minColunas]  = size(vMin)
    [maxLinhas, maxColunas]  = size(vMax)
    nMutar           = int(linhas*colunas*taxa/100)
    if nMutar==0 then
        nMutar=1
    end
    if (minLinhas ~= maxLinhas) | (minColunas ~= maxColunas) then
        messagebox ("Error (base_mutation_if): Min/Max size input size are different.")
        matriz=%f
    elseif (minLinhas==0) | (maxLinhas==0) | (minColunas==0) | (maxColunas==0)
        messagebox ("Error (base_mutation_elseif_1): Min/Max were not set.")
        // -------------------
        // Vector Mutation
        // -------------------
    elseif (minLinhas>1) | (maxLinhas>1)
        for i=1:nMutar    
            l = round(base_rand(0.0, 1.0,1) *(linhas-1)+1);
            c = round(base_rand(0.0, 1.0,1) *(colunas-1)+1);
            matriz(l,c) = base_rand(0.0, 1.0,1)*(vMax(c,1)-vMin(c,1))+vMin(c,1)
        end
        // -------------------
        // Scalar Mutation
        // -------------------
    elseif (minLinhas==1) & (maxLinhas==1) & (minColunas==1) & (maxColunas==1)
        for i=1:nMutar    
            l = round(base_rand(0.0, 1.0,1)*(linhas-1)+1);
            c = round(base_rand(0.0, 1.0,1)*(colunas-1)+1);
            matriz(l,c) = base_rand(0.0, 1.0,1)*(vMax-vMin)+vMin
        end
    else
        messagebox("Error (base_mutation_simple_else): General Error.")
    end
endfunction
// -------------------------------
// Hypermutation
// -------------------------------
function matriz = base_mutation_hypermutation(matriz, vMin, vMax)
    [linhas, colunas] = size(matriz)
    [minLinhas, minColunas]  = size(vMin)
    [maxLinhas, maxColunas]  = size(vMax)
    //nMutar           = int(linhas*colunas*taxa/100)
//    if nMutar==0 then
//        nMutar=1
//    end
    if (minLinhas ~= maxLinhas) | (minColunas ~= maxColunas) then
        messagebox ("Error (base_hypermutation_if1): Min/Max size input size are different.")
        matriz=%f
    elseif (minLinhas==0) | (maxLinhas==0) | (minColunas==0) | (maxColunas==0)
        messagebox ("Error (base_hypermutation_elseif_2): Min/Max were not set.")
        // -------------------
        // Vector Mutation
        // -------------------
    elseif (minLinhas==colunas) | (maxLinhas==colunas)
        for l=1:linhas
            for c=1:colunas
                matriz(l,c) = base_rand(0.0, 1.0,1)*(vMax(c,1)-vMin(c,1))+vMin(c,1)
            end
        end
    else
        messagebox("Error (base_hypermutation_else_3): General Error.")
    end
endfunction
