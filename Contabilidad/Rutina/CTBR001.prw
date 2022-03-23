#Include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBR001   ºAutor  ³Microsiga           º Data ³  12/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Funcion para traer las descripciones de las cuentas contables º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBR001 (_nOpc,_nRet)
Local _cDesc01	:= " "
Local _aArea	:= GetARea()

DBSelectArea("CT1")
DBSetOrder(1)

If _nOpc == 1   // cuenta contable
  	If !Empty(CTK->CTK_CREDIT) .and. _nRet == 2  
  	     DBSeek(Xfilial("CT1")+CTK->CTK_CREDIT)
		_cDesc01	:= CT1->CT1_DESC01 //Posicione("CT1",1,Xfilial("CT1")+PADR(&(CTK->CTK_CREDIT),20),"CT1_DESC01")
	EndIf
	If !Empty(CTK->CTK_DEBITO).and. _nRet == 1 
	     DBSeek(Xfilial("CT1")+CTK->CTK_DEBITO)
		_cDesc01	:= CT1->CT1_DESC01//Posicione("CT1",1,Xfilial("CT1")+PADR(&(CTK->CTK_DEBITO),20),"CT1_DESC01")
	EndIf 
EndIf

/*If _nOpc == 2 // centro de costo
	If !Empty(CTK->CTK_CCC) .and. _nRet == 2
		_cDesc01	:= Posicione("CTT",1,Xfilial("CTT")+PADR(&(CTK->CTK_CCC),9),"CTT_DESC01")
	EndIf
	If !Empty(CTK->CTK_CCD) .and. _nRet == 1
		_cDesc01	:= Posicione("CTT",1,Xfilial("CTT")+PADR(&(CTK->CTK_CCD),9),"CTT_DESC01")
	EndIf
EndIF
If _nOpc == 3 // ITEM contable
	If !Empty(CTK->CTK_ITEMC) .and. _nRet == 2
		_cDesc01	:= Posicione("CTD",1,Xfilial("CTD")+PADR(&(CTK->CTK_ITEMC),9),"CTD_DESC01")
	EndIf
	If !Empty(CTK->CTK_ITEMD) .and. _nRet == 1
		_cDesc01	:= Posicione("CTD",1,Xfilial("CTD")+PADR(&(CTK->CTK_ITEMD),9),"CTD_DESC01")
	EndIf
EndIf   */

RestArea(_aArea)
Return (_cDesc01)

