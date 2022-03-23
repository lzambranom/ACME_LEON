#include "rwmake.ch"
#include "protheus.ch"
/*/{Protheus.doc} MT120TEL
description Rutina que agrega el Campo Observaciones en Pedido de Compra
@type function
@version 
@author M&H
@since 16/3/2022
@return return_type, return_description
{@oDlg, aPosGet, aObj, nOpcx, nReg, @aDlgFields}
/*/
user function MT120TEL()
	local oNewDialog    := PARAMIXB[1]
	local aPosGet       := PARAMIXB[2]
	local aObj          := PARAMIXB[3]
	local nOpcx         := PARAMIXB[4]
	local nReg        	:= PARAMIXB[5]
	Local aDlgFields	:= PARAMIXB[6]
	Local cNomField     := "C7_XOBSG"
	Local l120Visual	:= .T.
	Local l120Inclui	:= .F.
	Local l120Altera	:= .F.
	Local l120Deleta	:= .F.
	//Public _cXNomePro   := SC7->C7_XNOME
	Public cXObserv     := SC7->C7_XOBSG
	
	Do Case
	Case aRotina[nOpcX][4] == 2
		l120Visual := .T.
	Case aRotina[nOpcX][4] == 3 .Or. lCop
		l120Inclui	:= .T.
		cXObserv := '                                                                                                                                                                                                                                                 '//
	Case aRotina[nOpcX][4] == 4
		l120Altera	:= .T.
	Case aRotina[nOpcX][4] == 5
		l120Deleta	:= .T.
		l120Visual	:= .T.
	EndCase

    
    @ 76,aPosGet[2,1] SAY Alltrim(RetTitle(cNomField)) of oNewDialog pixel size 060,006
    @ 75,aPosGet[2,1]+64 MSGET cXObserv SIZE 250,06 PICTURE PesqPict("SC7",cNomField) WHEN  (l120Inclui .And. VisualSX3(cNomField) .or. l120Altera) OF oNewDialog PIXEL SIZE 080,006
   	//@ 75,aPosGet[2,1]+64 MSGET cXObserv SIZE 250,06 PICTURE PesqPict("SC7",cNomField) OF oNewDialog PIXEL SIZE 080,006
   	
	aAdd(aDlgFields,{cNomField,"cXObserv"})
    
	
return .T.
