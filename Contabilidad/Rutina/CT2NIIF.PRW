#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCT2NIIF    บAutor  ณEDUAR ANDIA  	   บ Data ณ  12/07/2016   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Insert Contabilidad NIIFS de meses/a๑os pasados			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Colombia\GAMA                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CT2NIIF
Local aCab 		:= {}
Local aItem		:= {}
Local aTotItem 	:= {}
Local TRBCT2  	:= ""
Local cxEmp		:= ""
Local nxModulo	:= 0
Local dDataLc 	:= CTOD("0/0/0")  
Local cLote		:= ""
Local cDoc		:= ""
Local lTemNiif	:= .F.                
Local dDtLP	 	:= ""
Local cFilOri	:= xFilial()
Local __ClearCx := GetNewPar( "MV_CTBCLSC" , .T. )
Local lRpcSld	:= .F.	//Reprocesa Saldo?

nxModulo:= nModulo
nModulo	:= 34

TRBCT2 := GetNextAlias()
If Select(TRBCT2) > 0
	(TRBCT2)->(DbCloseArea())
EndIf
	
cQuery := " SELECT * FROM " + RetSqlName("CT2") + " CT2"
cQuery += " WHERE CT2.D_E_L_E_T_ <> '*'"
cQuery += " AND CT2_TPSALD = '1'"               

If Type("cOrigen")<>"U"	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Parametros - Desde PE -CT102BUT/DPCTB102GR 				ณ
	//ณ (Solo aplica al comprobante Seleccionado 				ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If cOrigen $ "BTN|MAN"	
	
		cQuery += " AND CT2_DATA = '" + DTOS(CT2->CT2_DATA) + "'"
		cQuery += " AND CT2_LOTE = '" + CT2->CT2_LOTE + "'"
		cQuery += " AND CT2_SBLOTE = '" + CT2->CT2_SBLOTE + "'"
		cQuery += " AND CT2_DOC = '" + CT2->CT2_DOC + "'"
	Else    
		CriaPerg("NIIFS01")		
		If Pergunte("NIIFS01",.T.)
		 	
		 	cQuery += " AND CT2_DATA BETWEEN '" + DTOS(mv_par01) + "' AND '" +  DTOS(mv_par02) + "'"			
			If !Empty(mv_par03)
				cQuery += " AND CT2_LOTE = '" + mv_par03 + "'"
			Endif
			If !Empty(mv_par04)
				cQuery += " AND CT2_SBLOTE = '" + mv_par04 + "'"
			Endif
			If !Empty(mv_par05)
				cQuery += " AND CT2_DOC = '" + mv_par05 + "'"
			Endif
		Endif
	Endif
Else
	Return
Endif

cQuery += " ORDER BY CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA"
DbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), TRBCT2, .F., .T.)

If cOrigen == "BTN" .OR. Empty(cOrigen)
	//Aviso("cQuery1",cQuery,{"OK"},,,,,.T.)
Endif

cxFil	:= "00"
//aGetEmp := fGetEmpresa()
While !(TRBCT2)->(Eof())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMudando de Filial							 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !Empty((TRBCT2)->CT2_FILIAL)
		If cxFil <> (TRBCT2)->CT2_FILIAL		
			/*
			aGetEmp := fGetEmpresa()
			If !fGoEmpresa(CEMPANT, (TRBCT2)->CT2_FILIAL)
				Exit
			Endif
			*/
		Endif	
		cxFil	:= (TRBCT2)->CT2_FILIAL	
	Endif
		
	cLote   := (TRBCT2)->CT2_LOTE
	cSubLot	:= (TRBCT2)->CT2_SBLOTE
	dDataLc := (TRBCT2)->CT2_DATA
	cDoc    := (TRBCT2)->CT2_DOC
			
	If Type("oxProcess")<>"U"
		cTxtReg1 :=	"Grabando ... " + dDataLc /*DTOC(dDataLc)*/ + "  " + cLote  + " / " + cSubLot + " / " + cDoc
		oxProcess:IncRegua1(cTxtReg1)
		oxProcess:SetRegua1(1)
	Endif
	
	aItem 	 := {}
	lTemNiif := HayTipo3( (TRBCT2)->R_E_C_N_O_ )
	dDtLP	 := (TRBCT2)->CT2_DATA
	cFilOri	 := (TRBCT2)->CT2_FILORI
	lRpcSld	 := .F.	//Reprocesa Saldo?
	
	While  !(TRBCT2)->(Eof()) .And. (TRBCT2)->CT2_DATA == dDataLc .AND. (TRBCT2)->CT2_LOTE == cLote .AND. (TRBCT2)->CT2_SBLOTE == cSubLot .AND. (TRBCT2)->CT2_DOC == cDoc
		
		If !lTemNiif
		
			RecLock("CT2",.T.)
			nQuant 	:= (TRBCT2)->( FCount() )
			nQtNo	:= 0
			
			For i := 1 To nQuant		
				cCampo := (TRBCT2)->(FieldName(i))
				If !(cCampo $ "R_E_C_N_O_|D_E_L_E_T_|R_E_C_D_E_L_")
					             					
					cValor := (TRBCT2)->(FieldGet( i ))
					
					If cCampo == "CT2_LINHA"
						cValor := MaxLinha( (TRBCT2)->R_E_C_N_O_ )
					Endif				
					If cCampo == "CT2_TPSALD"
						cValor := "3"
					Endif
					If cCampo == "CT2_HIST"
						//cValor := "HISTORIAL NIIF"
					Endif
					If cCampo $ "CT2_DEBITO|CT2_CREDIT"
						cValor := U_CtaNIIF(cValor)
					Endif
					If cCampo $ "CT2_ORIGEM"
						cValor := NumOrigem(cValor)
					Endif					
					If cCampo $ "CT2_CONVER"
						cValor := "1"
					Endif
					If cCampo $ "CT2_DTTX02"
						cValor := (TRBCT2)->CT2_DATA
					Endif
					If cValor <> Nil
						CT2->( FieldPut( i - nQtNo, cValor) ) 
					Endif
					//AADD(aCampos,( &( "CT2->"+(TRBCT2)->(FieldName(i))  )))
				Else
					nQtNo++	
				Endif
			Next i
			CT2->(MsUnlock()) 
		Endif
				
	(TRBCT2)->(DbSkip())
	EndDo
              
    
	If !(TRBCT2)->(Eof())
		If (TRBCT2)->CT2_DATA <> dDtLP
			lRpcSld := .T.	
		Endif
	Else
		lRpcSld := .T.
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Reprocesa Saldo contables                       			 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lRpcSld .AND. GetMv( "MV_ATUSAL" )== "S"
	
		If Type("oxProcess")<>"U"
			cTxtReg2 :=	".....Reprocesando saldos  ... " +  DTOS(CTOD(dDtLP))
			oxProcess:IncRegua2(cTxtReg2)
			oxProcess:SetRegua2(1)
		Endif
		
		If Type("dDtLP")<>"D"
			dDtLP := CTOD(DTOC(STOD(dDtLP)))
		Endif
		
		CTBA190(.T.,dDtLP,dDtLP,cFilOri,cFilOri,"3",.F.,"  ")	
		
		
		If cOrigen <> "MAN"
			//Efetua a limpeza dos caches da rotina		
			If __ClearCx
				ClearCx105()
			Endif
			
			If FindFunction("CTBLCUSO") .And. CTBLCUso()
				If (Type("__aCT2LC") == "A") .And. !Empty(__aCT2LC)
					CTBLCGerLC()
				Endif
			Endif
		Endif
		
		If Type("oxProcess")<>"U"
			cTxtReg2 :=	""
			oxProcess:IncRegua2(cTxtReg2)
			oxProcess:SetRegua2(1)
		Endif
	Endif
	
EndDo

//fRestEmpresa(aGetEmp)
If nxModulo <> 0
	nModulo	:= nxModulo
Endif

If Type("cOrigen")<>"U"
	If cOrigen == "BTN" .OR. Empty(cOrigen)
		Aviso(" >> [CTB NIIF]","Fin de Proceso",{"OK"})
	Endif
Endif

Return

//+------------------------------------------------------------------------+
//|Opera็๕es de abertura e restaura็ใo de outra filial					   |
//+------------------------------------------------------------------------+
Static Function fGetEmpresa
Local aAreaEmp := {}
aAdd(aAreaEmp, SM0->(Recno()))
aAdd(aAreaEmp, cFilAnt)
aAdd(aAreaEmp, cNumEmp)
Return aAreaEmp


Static Function fRestEmpresa(aAreaEmp)
Local aArea := GetArea()
SM0->(dbGoTo(aAreaEmp[1]))
cFilAnt := aAreaEmp[2]
cNumEmp := aAreaEmp[3]
RestArea(aArea)
Return

Static Function fGoEmpresa(cCodEmp, cCodFil)
Local aArea := GetArea()
Local lRet 	:= .T.
DbSelectArea( "SM0" )
If SM0->(DbSeek(cCodEmp+cFilAnt))
	cFilAnt := cCodFil
	cNumEmp := SM0->M0_CODIGO+SM0->M0_CODFIL
Else
	lRet := .F.
EndIf
RestArea(aArea)
Return(lRet)


//+------------------------------------------------------------------------+
//|Fun็ใo que retorna o Doc de Lan็.Padrใo 					 			   |
//+------------------------------------------------------------------------+
Static Function cGetCodLP(dDataLanc,cLote,cSubLote,cDoc)
Do While !ProxDoc(dDataLanc,@cLote,cSubLote,@cDoc)
Enddo
Return(cDoc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLancNIIF   บAutor  ณEDUAR ANDIA        บ Data ณ  28/07/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Crea Asiento NIIFS                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gama\Colombia                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LancNIIF(cOri)
Default	cOri	  := ""
Private oxProcess := NIL
Private cOrigen	  := cOri

oxProcess := MsNewProcess():New( { | lEnd | lOk := U_CT2NIIF() }, "Atualizando", "Aguarde, atualizando ...", .F. )
oxProcess:Activate()
Return

//+---------------------------------------------------------------------+
//|Fun็ใo que procura o utimo CT2_LINHA +1  					 	   	|
//+---------------------------------------------------------------------+
Static Function MaxLinha(nRecno)
Local nLin	:= "001"
Local cQry	:= ""

cQry := " SELECT MAX(CT2_LINHA) AS LINHA FROM " + RetSqlName("CT2")
cQry += " WHERE CT2_FILIAL+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC IN" 
cQry += " (SELECT CT2_FILIAL+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC FROM " + RetSqlName("CT2")
cQry += " WHERE R_E_C_N_O_ = '" + AllTrim(Str(nRecno)) + "')"
cQry += " AND D_E_L_E_T_ = '' "
cQry := ChangeQuery(cQry)
				
If Select("TRBLIN") > 0  //En uso
	TRBLIN->(DbCloseArea())
Endif
DbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), "TRBLIN", .F., .T.)

DbSelectArea("TRBLIN")
If !Empty(TRBLIN->(LINHA))
	nLin := Soma1(TRBLIN->(LINHA))
Endif
Return(nLin)

//+---------------------------------------------------------------------+
//|CT2_ORIGEM+500	 / 	"650-001"--> "650-501"	     					|
//+---------------------------------------------------------------------+
Static Function NumOrigem(cOri)
Local cNumOri 	:= ""
Default cOri	:= ""

cOri := AllTrim(cOri)
If !Empty(cOri)	//"575-003"
	If Len(cOri)==7
		cNumOri :=  Left(cOri,04) + AllTrim(Str(Val(Right(cOri,03)) + 500))
	Else
		cNumOri := cOri
	Endif
Endif
Return(cNumOri)

//+---------------------------------------------------------------------+
//|Verifica si en el comprobante ya existe tipo de Saldo 3 /NIIF	    |
//+---------------------------------------------------------------------+
Static Function HayTipo3(nRecno)
Local lRet	:= .F.
Local cQry3	:= ""

cQry3 := " SELECT * FROM " + RetSqlName("CT2")
cQry3 += " WHERE CT2_FILIAL+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC IN" 
cQry3 += " 		( 	SELECT CT2_FILIAL+CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC 
cQry3 += " 			FROM " + RetSqlName("CT2")
cQry3 += " 		 	WHERE R_E_C_N_O_ = '" + AllTrim(Str(nRecno)) + "')"
cQry3 += " AND CT2_TPSALD = '3'"
cQry3 += " AND D_E_L_E_T_ = '' "
cQry3 := ChangeQuery(cQry3)
				
If Select("SQLTP3") > 0  //En uso
	SQLTP3->(DbCloseArea())
Endif
DbUseArea(.T., "TOPCONN", TCGenQry(,, cQry3), "SQLTP3", .F., .T.)

DbSelectArea("SQLTP3")
If !Empty(SQLTP3->(CT2_DOC))
	lRet := .T.
Endif
Return(lRet)


//+------------------------------------------------------------------------+
//|Funci๓n que verifica si existe la Pregunta, caso no exista lo crea	   |
//+------------------------------------------------------------------------+
Static Function CriaPerg(cPerg)
Local aRegs := {}
Local i		:= 0

cPerg := PADR(cPerg,10)
aAdd(aRegs,{"01","De Fecha?     :","mv_ch1","D",08,0,0,"G","mv_par01",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"02","A Fecha?      :","mv_ch2","D",08,0,0,"G","mv_par02",""       ,""            ,""        ,""     ,""   ,""})
aAdd(aRegs,{"03","Lote?			:","mv_ch3","C",06,0,1,"G","mv_par03",""       ,""            ,""        ,""     ,"09" ,""})
aAdd(aRegs,{"04","Sub-Lote?		:","mv_ch4","C",03,0,1,"G","mv_par04",""       ,""            ,""        ,""     ,"SB" ,""})
aAdd(aRegs,{"05","Doc?			:","mv_ch5","C",06,0,1,"G","mv_par05",""       ,""            ,""        ,""     ,""   ,""})

DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aRegs)
   dbSeek(cPerg+aRegs[i][1])
   If !Found()
      RecLock("SX1",!Found())
         SX1->X1_GRUPO    := cPerg
         SX1->X1_ORDEM    := aRegs[i][01]
         SX1->X1_PERSPA   := aRegs[i][02]
         SX1->X1_VARIAVL  := aRegs[i][03]
         SX1->X1_TIPO     := aRegs[i][04]
         SX1->X1_TAMANHO  := aRegs[i][05]
         SX1->X1_DECIMAL  := aRegs[i][06]
         SX1->X1_PRESEL   := aRegs[i][07]
         SX1->X1_GSC      := aRegs[i][08]
         SX1->X1_VAR01    := aRegs[i][09]
         SX1->X1_DEFSPA1  := aRegs[i][10]
         SX1->X1_DEFSPA2  := aRegs[i][11]
         SX1->X1_DEFSPA3  := aRegs[i][12]
         SX1->X1_DEFSPA4  := aRegs[i][13]
         SX1->X1_F3       := aRegs[i][14]
         SX1->X1_VALID    := aRegs[i][15]         
      MsUnlock()
   Endif
Next i
Return
