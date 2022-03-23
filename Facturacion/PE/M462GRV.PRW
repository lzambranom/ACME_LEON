#Include 'Protheus.ch'
/*
Programa  M462GRV    Autor  Microsiga          Fecha   09/02/2020 
Desc.      PE - Executado no momento de gerar a Remissão (Venda) de um Pedido de Venda                                      
*/
/* -------------------------------------------------------------------
Revisión para Acme por: Axel Diaz
Proposito: Copiar el campo Observacion y Descripción del Producto hacia un campo personalizado de acme
------------------------------------------------------------------------*/
*/
User Function M462GRV
Local aArea 		:= GetArea()
Local aAreaSC5		:= SC5->(Getarea())
Local aAreaSC6		:= SC6->(Getarea())
Local aAreaSC9		:= SC9->(Getarea())
Local nI			:= PARAMIXB[7]
Local _nPosCod		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_COD"		})
Local _nPosPED		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_PEDIDO"	})
Local _nPosItPV		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_ITEMPV"	})
Local _nPosDesc		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "D2_XDESCRI"	})
Local nX			:= 0 //

aSF2[nI][Ascan(aHeadSF2,{ |x| Alltrim(x)=="F2_XOBS" })] 	  := SC5->C5_XOBS

For nX:= 1 To Len(aCols)
	xcProduto := aCols[nx][_nPosCod]
	//aCols[nx][_nPosDesc]	:= Posicione("SB1",1,xFilial("SB1")+ xcProduto,"B1_DESC")
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))        //codigo
	SC6->(DbSeek(xFilial("SC6") +aCols[nx][_nPosPed] +aCols[nx][_nposItPV] +aCols[nx][_nPosCod]))
	If Found()
		aCols[nx][_nPosDesc]	:=  SC6->C6_DESCRI 
	Endif
next
RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aAreaSc9)
RestArea(aArea)
Return


