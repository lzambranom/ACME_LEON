#Include 'protheus.ch'                    
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �INISF1     �Autor  �Microsiga           �Fecha �  12/23/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Iniicializador estandard de para el campo razon social     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function INISF1(CaLIAS)
Local _cRetorno	:= ""
iF TYPE("cEspecie") <> 'U'
	If cAlias	== "SF1"
		If funname() $ "MATA465N|MATA462DN" 
			_cRetorno	:= Posicione("SA1",1,Xfilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NOME")
		Else
			_cRetorno	:= Posicione("SA2",1,Xfilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")
		EndIf
	ELSEif cAlias == "SF2"
		If Alltrim(cEspecie) $ "NCP|RCD|RTS"
			_cRetorno	:= Posicione("SA2",1,Xfilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_NOME")
		Else
			_cRetorno	:= Posicione("SA1",1,Xfilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME")
		EndIf
	EndIf
EndIf
Return _cRetorno
