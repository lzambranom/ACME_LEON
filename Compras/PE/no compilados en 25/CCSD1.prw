
//ENCABEZADO DE LA FACTURA

User Function CCSD1()
Local cConta:=""
Local cCcCT1:=""
Local cCCSD1:=""
Local cCC	:=""

cConta	:=SD1->D1_CONTA
cCCSD1	:=SD1->D1_CC
cCcCT1	:=Posicione("CT1",1,xFilial("CT1")+cConta,"CT1->CT1_ACCUST")

If  cCcCT1 = '1'
	cCC	:= cCCSD1
Else
	cCC	:= ''
EndIF
Return 	cCC
		