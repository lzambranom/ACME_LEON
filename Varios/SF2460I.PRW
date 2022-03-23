#include "RWMAKE.CH"
#INCLUDE "topconn.ch"
/*
Function SF2460I
Punto de entrada ejecutado despues del asiernto contable que graba el campo observacion proveniente del Pedido
*/
/* -------------------------------------------------------------------
Revisión para Acme por: Axel Diaz
Proposito: Agregar campos personalizados en Remisiones de Salida y Facturas
------------------------------------------------------------------------*/
*/
User Function SF2460I()
Local cEspe		:= AllTrim(cEspecie)
Local nReg 		:= SD2->(RECNO())
Local cxDescri	:= ""
Local cxRemito	:= ""
Local cxSerie	:= ""
Local cxItem	:= "" 
If (cEspe == 'NF' .Or. cEspe == 'NDC'  .Or. cEspe == 'RFN') 	
    ccDoc		:=	SF2->F2_DOC
    cObs		:=	SF2->F2_XOBS	
	//aAreaSD2	:=	SD2->(GetArea()) 
	
	If !Empty(SD2->D2_PEDIDO)  
	    cObs :=	Posicione("SC5",1,xFilial("SC5")+SD2->D2_PEDIDO,"C5_XOBS")
	    If cEspe == 'NF' .and. (FunName()=="MATA468N" .OR. FunName()=="MATA462N") .AND. !Empty(SD2->D2_PEDIDO)
		    RecLock("SF2",.F.)
		    	SF2->F2_XOBS 	:= 	cObs
		    MsUnLock()
		Endif
		
	Endif             
	//RestArea(aAreaSD2) 
EndIf
Return
