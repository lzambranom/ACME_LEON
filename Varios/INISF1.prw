#Include 'protheus.ch'                    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINISF1     บAutor  ณMicrosiga           บFecha ณ  12/23/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Iniicializador estandard de para el campo razon social     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
