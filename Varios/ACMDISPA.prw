#include 'protheus.ch'
#include 'parmtype.ch'

user function ACMDISPA()
	
return
// Disparador
// Calculo de Primera Unidad de Medida
// M->D2_QUANT  := NoRound(M->D2_QTSEGUM/ SB1->B1_CONV,TamSx3("D2_QTSEGUM")[2])     
User Function AcmDis01(cCodPro,nCant2da,cCampoDestino)
Local nCantidad	:= 0
Local cB1Conv	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_TIPCONV") //MD
Local nB1Fact	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_CONV") //Fat conv
If cB1Conv=="M"
	nCantidad:=NoRound(nCant2da/nB1Fact,TamSx3(cCampoDestino)[2])
Else
	nCantidad:=NoRound(nCant2da*nB1Fact,TamSx3(cCampoDestino)[2])
EndIf	
return nCantidad

// Disparador Precio Segunda Unidad->hacia Primera unidad
User Function AcmDis02(cCodPro,nPrec2da,cCampoDestino)
Local nPrecio	:= 0
Local cB1Conv	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_TIPCONV") //MD
Local nB1Fact	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_CONV") //Fat conv
If cB1Conv=="M"
	nPrecio:=NoRound(nPrec2da*nB1Fact,TamSx3(cCampoDestino)[2])
Else
	nPrecio:=NoRound(nPrec2da/nB1Fact,TamSx3(cCampoDestino)[2])
EndIf	
return nPrecio


// Disparador Precio pRIMERA Unidad->hacia sEGUNDA unidad
User Function AcmDis03(cCodPro,nPrecio,cCampoDestino)
Local nPrecio	:= 0
Local cB1Conv	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_TIPCONV") //MD
Local nB1Fact	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_CONV") //Fat conv
If cB1Conv=="M"
	nPrecio:=NoRound(nPrecio/nB1Fact,TamSx3(cCampoDestino)[2])
Else
	nPrecio:=NoRound(nPrecio*nB1Fact,TamSx3(cCampoDestino)[2])
EndIF
return nPrecio

User Function AcmDis04(cCodPro,cListPre,cCampoDestino,lPrimera)
Local nPrecio	:= 0
Local cB1Conv	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_TIPCONV") //MD
Local nB1Fact	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_CONV") //Fat conv
Local nPrcList	:= POSICIONE("DA1",2,xFilial("DA1")+cCodPro+cListPre,"DA1_PRCVEN")
IF lprimera
	nPrecio:= nPrcList 
ELSE
	If cB1Conv=="D"
		nPrecio:=NoRound(nPrcList/nB1Fact,TamSx3(cCampoDestino)[2])
	Else
		nPrecio:=NoRound(nPrcList*nB1Fact,TamSx3(cCampoDestino)[2])
	EndIf	
EndIf
return nPrecio

// CODIGO CORTO PRECI0O SEGUNDA UNIDAD
User Function AcmDis05(cCodCor,cListPre,cCampoDestino,lPrimera)
Local nPrecio	:= 0 
Local cB1Conv	:= POSICIONE("SB1",13,xFilial("SB1")+cCodCor,"B1_TIPCONV") //MD
Local nB1Fact	:= POSICIONE("SB1",13,xFilial("SB1")+cCodCor,"B1_CONV") //Fat conv
Local cCodigo	:= POSICIONE("SB1",13,xFilial("SB1")+cCodCor,"B1_COD")
Local nPrcList	:= POSICIONE("DA1",2,xFilial("DA1")+cCodigo+cListPre,"DA1_PRCVEN")
IF lprimera
	nPrecio:= nPrcList 
ELSE
	If cB1Conv=="M"
		nPrecio:=NoRound(nPrcList/nB1Fact,TamSx3(cCampoDestino)[2])
	Else
		nPrecio:=NoRound(nPrcList*nB1Fact,TamSx3(cCampoDestino)[2])
	EndIf	
EndIf
Return nPrecio

// PRECIO DE LISTA DIGITANDO PRECIO SEGUNDA UNIDAD HACIA PRUNIT
// nCondAgr
User Function AcmDis06(cCodPro,nPrecio2da,cCampoDestino)
	Local nPrecio	:= 0 
	Local cB1Conv	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_TIPCONV") 	//MD
	Local nB1Fact	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_CONV") 	//Fat conv

	If cB1Conv=="M"
		nPrecio:=NoRound(nPrecio2da*nB1Fact,TamSx3(cCampoDestino)[2])
	Else
		nPrecio:=NoRound(nPrecio2da/nB1Fact,TamSx3(cCampoDestino)[2])
	EndIf
return nPrecio

// solo EN PEDIDOS DE VENTA
User Function AcmDis07(cCodPro,nPrecio2da,cCampoDestino,nDesc1,nDesc2,nDesc3)

	Local nPrecio	:= 0 
	Local cB1Conv	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_TIPCONV") 	//MD
	Local nB1Fact	:= POSICIONE("SB1",1,xFilial("SB1")+cCodPro,"B1_CONV") 	//Fat conv
	Default nDesc1	:= 0
	Default nDesc2	:= 0
	Default nDesc3	:= 0

	If cB1Conv=="M"
		nPrecio:=NoRound(nPrecio2da*nB1Fact,TamSx3(cCampoDestino)[2])
	Else
		nPrecio:=NoRound(nPrecio2da/nB1Fact,TamSx3(cCampoDestino)[2])
	EndIf
	
	nPrecio:= nPrecio * (1-nDesc1/100)
	nPrecio:= nPrecio * (1-nDesc2/100)
	nPrecio:= nPrecio * (1-nDesc3/100)

return nPrecio

// pRECIO DE  LISTA DESDE EL CODIGO DE PRODUCTO
User Function AcmDis08(cCod,cListPre,cCampoDestino,lPrimera)
Local nPrecio	:= 0 
Local cB1Conv	:= POSICIONE("SB1",1,xFilial("SB1")+cCod,"B1_TIPCONV") //MD
Local nB1Fact	:= POSICIONE("SB1",1,xFilial("SB1")+cCod,"B1_CONV") //Fat conv
Local nPrcList	:= POSICIONE("DA1",2,xFilial("DA1")+cCod+cListPre,"DA1_PRCVEN")
IF lprimera
	nPrecio:= nPrcList 
ELSE
	If cB1Conv=="M"
		nPrecio:=NoRound(nPrcList/nB1Fact,TamSx3(cCampoDestino)[2])
	Else
		nPrecio:=NoRound(nPrcList*nB1Fact,TamSx3(cCampoDestino)[2])
	EndIf	
EndIf
Return nPrecio

     