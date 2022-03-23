#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT102BUT  �Autor  �EDUAR ANDIA         � Data �  19/07/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � PE - Que crea un Bot�n "Imprimir" en el browser de   	  ���
���          � "Asto.Conta.Auto"                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Colombia                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CT102BUT
Local aRotina  := ParamIxb

AADD( aRotina	, {"Imprimir"	,"U_ImpAsiento()"		,0,5})	//Imprimir
AADD( aRotina	, {"INC.NIIF"	,"U_LancNIIF('BTN')"	,0,4})	//Incluir NIIF (Modificar)
Return(aRotina)


//+---------------------------------------------------------+
//|Funci�n que llama al Informe del Comprobante Contable	|
//+---------------------------------------------------------+
User Function ImpAsiento
Local nTpSaldo	:= 1
Local nOpc		:= Aviso("Imprimir","Imprimir Comprobante Contable: ",{"COLGAAP","NIIFS"},,,,,,,1)

If nOpc == 1		
	U_CTBI001(.F.,nTpSaldo)
Else
	nTpSaldo := 3	//NIIFS
	U_CTBI001(.F.,nTpSaldo)
Endif
Return
