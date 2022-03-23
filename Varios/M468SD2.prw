#include 'protheus.ch'
#include 'parmtype.ch'
/*
Programa  M468SD2   
Desc.    en generacion de facturas para traer datos desde el pedido  
         de venta GERA REGISTROS EM SD2 E ACUMULA VALORES           
*/
User Function M468SD2()
	Local _aArea 	:= GetArea()
	Local aRetorno 	:= {}
	Local nReg 		:= SD2->(RECNO())
	Local cxClVl	:= ""
	Local cxItemCC  := ""
	Local cxDescri	:= ""
	Local cxObs		:= ""
	Local cxRemito	:= ""
	Local cxSerie	:= ""
	Local cxItem	:= "" 
	Local nxPrc2Ven	:= 0
	
	SD2->(DbGoTo(nReg))
	If !Empty(SD2->D2_REMITO)
		// Facturando por Remision
		cxRemito	:= SD2->D2_REMITO
		cxSerie		:= SD2->D2_SERIREM
		cxItem		:= SD2->D2_ITEMREM 
		
		/***    Posicionando em Remissao ****/
		Dbselectarea("SD2")
		SD2->(Dbsetorder(3))
		If SD2->(Dbseek(xFilial("SD2") + cxRemito + cxSerie + SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD + cxItem))
			cxDescri	:= SD2->D2_XDESCRI
			cxObs		:= SD2->D2_xObs
			nxPrc2Ven	:= SD2->D2_XPRC2DA
		Endif
		
		/***    Posicionando em Fatura ****/
		SD2->(DbGoTo(nReg))
		If Reclock("SD2",.F.)
			Replace  SD2->D2_XDESCRI	With cxDescri
			Replace  SD2->D2_XOBS		With cxObs
			Replace  SD2->D2_XPRC2DA	With nxPrc2Ven
			SD2->(MsUnlock())
		Endif
	Else
	
		// Facturando por Pedido    
		                   				 
		DbSelectarea("SC6")
		SC6->(Dbsetorder(1))
		If SC6->(Dbseek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
			If Reclock("SD2",.F.)
				Replace  SD2->D2_XDESCRI	With SC6->C6_DESCRI	 //Descripcion
				Replace  SD2->D2_XOBS		With SC6->C6_XOBS	 //xObservaciones
				Replace  SD2->D2_XPRC2DA	With SC6->C6_XPRC2DA // Precio Segunda Unidad
				MsUnlock()
			Endif
		Endif
	Endif
	RestArea(_aArea)
Return
