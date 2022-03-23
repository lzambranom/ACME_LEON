#include "rwmake.ch"
#include "protheus.ch"
/*/{Protheus.doc} MT120GET
description Rutina que redimenciona el area del cabecero y detalle del pedido de compra
@type function
@version 
@author M&H
@since 16/3/2022
@return return_type, return_description

/*/

User Function MT120GET()
Local aRet:= PARAMIXB[1]
aRet[2,1] := 110 // Abaixando o começo da linha da getdados
aRet[1,3] := 105 // Abaixando a linha de contorno dos campos do cabeçalho
Return(aRet) 
