
//#Include "CTBR400.Ch"
#Include "PROTHEUS.Ch"

#DEFINE TAM_VALOR  20
#DEFINE TAM_CONTA  17

Static lFWCodFil := FindFunction("FWCodFil") 
Static lCtbIsCube 	:= FindFunction("CtbIsCube")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ PROR403  ³ Autor ³ Lucas Riva Tsuda  	³ Data ³ 24.11.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Por Tercero 		         			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ PROR402()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ SIGACTB - Especifico Colombia						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PROR404(	cContaIni, cContaFim, dDataIni, dDataFim, cMoeda, cSaldos,;
					cBook, lCusto, cCustoIni, cCustoFim, lItem, cItemIni, cItemFim,;
					lNit, cNitIni, cNitFim,lSaltLin,cMoedaDesc,aSelFil )


Local aArea := GetArea()
Local aCtbMoeda		:= {}

Local cArqTmp		:= "" 
Local lOk := .T.
Local lExterno		:= cContaIni <> Nil 

PRIVATE cTipoAnt	:= ""
PRIVATE cPerg	 	:= "PROR403"
PRIVATE nomeProg  	:= "CTBR402"  
PRIVATE nSldTransp	:= 0 // Esta variavel eh utilizada para calcular o valor de transporte
PRIVATE oReport   
PRIVATE nLin		:= 0 
PRIVATE cnPerg	 	:= "PROR403"

DbSelectArea("CT0")
DbSetOrder(1)
DbSeek(xFilial("CT0")+ "05" )

PRIVATE cPlano  := CT0->CT0_ENTIDA
PRIVATE cCodigo	:= ""

DEFAULT lCusto		:= .F.
DEFAULT lItem		:= .F.
DEFAULT lNit		:= .F.
DEFAULT lSaltLin	:= .T.
DEFAULT cMoedaDesc  := cMoeda // RFC - 18/01/07 | BOPS 103653
DEFAULT aSelFil		:= {}

Ajusta402SX1(cnPerg)
aPergs := {}

			  //"X1_PERGUNT"			,"X1_PERSPA"					,"X1_PERENG"			,"X1_VARIAVL","X1_TIPO"	,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC"	,"X1_VALID"	,"X1_VAR01","X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"		,"X1_VAR02"		,"X1_DEF02"	,"X1_DEFSPA2","X1_DEFENG2"	,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"	,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,"X1_F3","X1_GRPSXG","X1_PYME","X1_HELP","X1_PICTURE"	}			
DbSelectArea("SX1")
DbSetOrder(1)
DbSeek(Padr("PROR403",Len(X1_GRUPO))+"18")

If cpaisLoc =="COL"
	aAdd( aPergs , {"Imprime N.I.T. Vlr ?"	,"¿Imprime N.I.T. Valor ?" 		,"Print Value N.I.T. ?"	,"mv_chi"	,"N"		,1			,			,1	   		,"C"		,""			,"mv_par18","Sim" 		,"Si"			,"Yes"			,""				,""				,"Nao"		,"No"		,"No"	 		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""				,""				,""			,""		,"S"		,""		,""	  		,""		 		,{|| .T.}})
	aAdd( aPergs , {"Da N.I.T. de Valor ?"	,"¿De N.I.T. de Valor ?"   		,"From Value N.I.T. ?"	,"mv_chj"	,"C"		,15			,			,	   		,"G"		,""			,"mv_par19",""	   		,""				,""				,""				,""				,""	  		,""			,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""				,""				,""			,"CV01"	,"S"		,"006"	,""	 		,""		 		,{|| .T.}})
	aAdd( aPergs , {"Ate N.I.T. de Valor ?","¿A N.I.T. de Valor ?"			,"To Value N.I.T. ?"	,"mv_chk"	,"C"		,15			,			,	   		,"G"		,""			,"mv_par20",""	   		,""	   			,""				,"ZZZZZZZZZZZZZZZZZZZZ"	,""		,""			,""			,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 		,""				,""			,"CV01"	,"S"		,"006"	,""	 		,""		  		,{|| .T.}})
	aAdd( aPergs , {"Impr Cod NITValor ?"	,"¿Imprime Codigo NIT Valor ?"	,"Print Val.NITCode ?"	,"mv_chr"	,"N"		,1			,			,1			,"C"		,""			,"mv_par27","Normal"	,"Normal"		,"Normal"		,""				,""				,"Reduzido"	,"Reducido"	,"Reduced"		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""	   		,""		   		,""		   		,""			,""		,""			,""		,""	   		,""				,{|| .T.}})

	If !("N.I.T." $ SX1->X1_PERGUNT)		
		//AjustaSX1('PROR403',aPergs)
		Ajusta402SX1('PROR403',aPergs)
	Endif
	
	DbSeek(Padr("PROR403",Len(X1_GRUPO))+"19")
	If !(SX1->X1_TAMANHO == 15)		
		//AjustaSX1('PROR403',aPergs)  
		Ajusta402SX1('PROR403',aPergs)
	Endif
	

	aPergs:={}
	aAdd( aPergs , {"Ordena por ?"	,"¿Ordene por ?" 		,"Order By ?"	,"mv_chp"	,"N"		,1			,			,1	   		,"C"		,""			,"mv_par39","N.I.T" 		,"N.I.T"			,"N.I.T"			,""				,""				,"Cuenta"		,"Cuenta"		,"Cuenta"	 		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""				,""				,""			,""		,"S"		,""		,""	  		,""		 		,{|| .T.}})
	DbSeek(Padr("PROR403",Len(X1_GRUPO))+"39")
	If !("Ord" $ SX1->X1_PERGUNT)	
		//AjustaSX1('PROR403',aPergs)
		Ajusta402SX1('PROR403',aPergs)
	Endif
/*		
ElseIf cpaisLoc =="PER" 
	aAdd( aPergs , {"Imprime R.U.C. Vlr ?"	,"¿Imprime R.U.C. Valor ?" 		,"Print Value R.U.C. ?"	,"mv_chi"	,"N"		,1			,			,1	   		,"C"		,""			,"mv_par18","Sim" 		,"Si"			,"Yes"			,""				,""				,"Nao"		,"No"		,"No"	 		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""				,""				,""			,""		,"S"		,""		,""	  		,""		 		,{|| .T.}})
	aAdd( aPergs , {"Da R.U.C. de Valor ?"	,"¿De R.U.C. de Valor ?"   		,"From Value R.U.C.?"	,"mv_chj"	,"C"		,6			,			,	   		,"G"		,""			,"mv_par19",""	   		,""				,""				,""				,""				,""	  		,""			,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""				,""				,""			,"CV01"	,"S"		,"006"	,""	 		,""		 		,{|| .T.}})
	aAdd( aPergs , {"Ate R.U.C. de Valor ?","¿A R.U.C. de Valor ?"			,"To Value R.U.C. ?"	,"mv_chk"	,"C"		,6			,			,	   		,"G"		,""			,"mv_par20",""	   		,""	   			,""				,"ZZZZZZZZZZZZZZZZZZZZ"	,""		,""			,""			,""				,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""		 		,""				,""			,"CV01"	,"S"		,"006"	,""	 		,""		  		,{|| .T.}})
	aAdd( aPergs , {"Impr Cod RUCValor ?"	,"¿Imprime Codigo RUC Valor ?"	,"Print Val.NITCode ?"	,"mv_chr"	,"N"		,1			,			,1			,"C"		,""			,"mv_par27","Normal"	,"Normal"		,"Normal"		,""				,""				,"Reduzido"	,"Reducido"	,"Reduced"		,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""			,""	   		,""		   		,""		   		,""			,""		,""			,""		,""	   		,""				,{|| .T.}})

	If !("R.U.C." $ SX1->X1_PERGUNT)
		AjustaSX1('PROR403',aPergs)
	Endif*/
EndIf
lOk := AMIIn(34)		// Acesso somente pelo SIGACTB
	                    
If lOk
	Pergunte("PROR403", .F.)
	If !lExterno
		lOk := Pergunte("PROR403", .t.)
	Endif
Endif

If lOk
	//Verifica se o relatorio foi chamado a partir de outro programa. Ex. CTBC402
	If !lExterno
		lCusto	:= Iif(mv_par12 == 1,.T.,.F.)
		lItem	:= Iif(mv_par15 == 1,.T.,.F.)
		lNit	:= Iif(mv_par18 == 1,.T.,.F.)
		// Se aFil nao foi enviada, exibe tela para selecao das filiais
		If lOk .And. mv_par36 == 1 .And. Len( aSelFil ) <= 0
				aSelFil := AdmGetFil()
	
			If Len( aSelFil ) <= 0
				lOk := .F.
			EndIf 
		EndIf
	Else  //Caso seja externo, atualiza os parametros do relatorio com os dados passados como parametros.
		mv_par01 := cContaIni
		mv_par02 := cContaFim
		mv_par03 := dDataIni
		mv_par04 := dDataFim
		mv_par05 := cMoeda
		mv_par06 := cSaldos
		mv_par07 := cBook
		mv_par12 := If(lCusto =.T.,1,2)
		mv_par13 := cCustoIni
		mv_par14 := cCustoFim
		mv_par15 := If(lItem =.T.,1,2)
		mv_par16 := cItemIni
		mv_par17 := cItemFim
		mv_par18 := If(lNit =.T.,1,2)
		mv_par19 := cNitIni
		mv_par20 := cNitFim
		mv_par31 := If(lSaltLin==.T.,1,2)
		mv_par32 := 56
		mv_par34 := cMoedaDesc
	Endif
Endif   
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! ct040Valid(mv_par07) // Set Of Books
		lOk := .F.
EndIf 

If lOk .And. mv_par32 < 10
		ShowHelpDlg("MINQTDELIN", {"Valor informado inválido do","'Num. linhas p/ o razão'"},5,{"Favor preencher uma quantidade","mínima de 10 linhas"},5)   
		lOk := .F.
EndIf

If lOk
    aCtbMoeda  	:= CtbMoeda(MV_PAR05) // Moeda?
    If Empty( aCtbMoeda[1] )
			Help(" ",1,"NOMOEDA")
		    lOk := .F.
		Endif
  
	IF lOk .And. ! Empty( mv_par34 )
			aCtbMoeddesc := CtbMoeda(mv_par34) // Moeda?

		    If Empty( aCtbMoeddesc[1] )
				Help(" ",1,"NOMOEDA")
			    lOk := .F.
			Endif
			aCtbMoeddesc := nil
		Endif
Endif 

If lOk
	U_XCTB402(aCtbMoeda,lCusto,lItem,lNit,@cArqTmp,aSelFil )
Endif

If Select("cArqTmp") > 0
		dbSelectArea("cArqTmp")
		Set Filter To
		dbCloseArea()

		If Select("cArqTmp") == 0
			FErase(cArqTmp+GetDBExtension())
			FErase(cArqTmp+OrdBagExt())
		EndIf
EndIf	
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBR402R4 º Autor ³                    º Data ³  15/09/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Impressao do relatorio em R4                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XCTB402(aCtbMoeda,lCusto,lItem,lNit,cArqTmp,aSelFil )
	
oReport := U_ReportDef(aCtbMoeda,lCusto,lItem,lNit,@cArqTmp,aSelFil)
oReport:PrintDialog()
             
oReport := Nil

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Cicero J. Silva    º Data ³  01/08/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aCtbMoeda  - Matriz ref. a moeda                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ReportDef(aCtbMoeda,lCusto,lItem,lNit,cArqTmp,aSelFil)

Local oReport
Local oSection1
Local oSection1_1
Local oSection2
Local oSection2_2
Local oSection3
Local cDesc1		:= "Este programa imprimirá el Balance "
Local cDesc2		:= "de Terceros específico Colombia"
Local cDesc3		:= ""
Local titulo		:= "Balance de Terceros"
Local cNormal		:= ""
Local cPerg	   		:= "PROR403" 
Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCusto	:= TAMSX3("CT3_CUSTO")
Local nTamConta	:= Len(CriaVar("CT1_CONTA"))
Local nTamHist	:= If(cPaisLoc$"CHI|ARG",29,Len(CriaVar("CT2_HIST")))
Local nTamItem	:= Len(CriaVar("CTD_ITEM"))
Local nTamNit	:= Len(CriaVar("CV0_CODIGO"))
Local nTamLote	:= Len(CriaVar("CT2_LOTE")+CriaVar("CT2_SBLOTE")+CriaVar("CT2_DOC")+CriaVar("CT2_LINHA"))
Local nTamSegOfi:= Len(CriaVar("CT2_SEGOFI"))
Local nTamData	:= 10
Local lAnalitico	:= Iif(mv_par08==1,.T.,.F.)// Analitico ou Resumido dia (resumo)
Local lPrintZero	:= IIf(mv_par30==1,.T.,.F.)// Imprime valor 0.00    ?
Local lSalto		:= Iif(mv_par21==1,.T.,.F.)// Salto de pagina                       ³

Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayNit		:= "N.I.T."
Local nDigitAte		:= 0
Local aSetOfBook 	:= CTBSetOf(mv_par07)// Set Of Books	
Local cPicture 		:= aSetOfBook[4]
Local cDescMoeda 	:= aCtbMoeda[2]
Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par05)// Moeda
Local nTamTransp    := 0
Local nTamFilial 	:= ( lFWCodFil, TamSx3( "CT2_FILIAL" )[1], TamSx3( "CT2_FILIAL" )[1] )//IIf( lFWCodFil, FWGETTAMFILIAL, TamSx3( "CT2_FILIAL" )[1] )

//21/03
Local cHour := ""
Local cMin  := ""
Local cSecs := ""
Local cTime := ""

Private lAnalit  := lAnalitico        

IF MV_PAR35 == 1 // COLOCA O TAMANHO DAS ENTIDADES NO TAMANHO MAXIMO DE 20 PARA IMPRESSAO CORRETA DAS MASCARAS.
	aTamCusto[1]	:= 20
	nTamItem		:= 20
	nTamNit			:= 20
ENDIF

If mv_par11 == 3 						//// SE O PARAMETRO DO CODIGO ESTIVER PARA IMPRESSAO
	nTamConta := Len(CT1->CT1_CODIMP)	//// USA O TAMANHO DO CAMPO CODIGO DE IMPRESSAO
Else
	If lAnalitico 
		If (lCusto .Or. lItem .Or. lNit)
			nTamConta := 30						// Tamanho disponivel no relatorio para imprimir
		Else
			nTamConta := 40						// Tamanho disponivel no relatorio para imprimir
		Endif
	EndIf		
Endif   
/*
If cPaisLoc = "PER"
	cSayNit := "R.U.C."
Endif
*/

//---21/03-------------------------------------------------------------------------------
cTime := Time() // Resultado: 10:37:17
cHour := SubStr( cTime, 1, 2 ) // Resultado: 10
cMin  := SubStr( cTime, 4, 2 ) // Resultado: 37
cSecs := SubStr( cTime, 7, 2 ) // Resultado: 17

nomeProg := "PROR403_"+IIF(MV_PAR06=="1","COLGAAP_","NIIF_")+DtoS(dDataBase)+"_"+cHour+cMin+cSecs
//----------------------------------------------------------------------------------------

oReport := TReport():New(nomeProg,titulo,cPerg, {|oReport| ReportPrint(oReport,aCtbMoeda,aSetOfBook,cPicture,cDescMoeda,nDecimais,nTamConta,lAnalitico,lCusto,lItem,lNit,cArqTmp,aSelFil)},cDesc1+cDesc2+cDesc3)
  
oReport:SetTotalInLine(.F.)
oReport:EndPage(.T.)

If lAnalitico
	oReport:SetLandScape(.T.)
Else
	oReport:SetPortrait(.T.)
EndIf

oReport:lFooterVisible 	:= .F.		// Não imprime rodapé do protheus		
// oSection1

oSection1 := TRSection():New(oReport,"Conta",{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	//"Conta"

If lSalto
	oSection1:SetPageBreak(.T.)
EndIf

TRCell():New(oSection1,"CONTA"	,"cArqTmp","CUENTA",/*Picture*/,aTamConta[1],/*lPixel*/,/*{|| }*/)	//"CONTA"
TRCell():New(oSection1,"DESCCC"	,"cArqTmp","DESCRIPCION",/*Picture*/,nTamConta+20,/*lPixel*/,/*{|| }*/)		//"DESCRICAO"  

TRCell():New(oSection1,"SALCUEN"	,"cArqTmp","SALDO ANTERIOR",/*Picture*/,aTamConta[1],/*lPixel*/,/*{|| }*/)	//"CONTA"

oSection1:SetReadOnly()
    



// oSection2
oSection2 := TRSection():New(oReport,"Costo",{"cArqTmp","CT2"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	//"Custo"
oSection2:SetHeaderPage(.T.)
oSection2:SetReadOnly()       

TRCell():New(oSection2,"DATAL"		,"cArqTmp","FECHA",/*Picture*/,nTamData,/*lPixel*/,/*{|| }*/,/*"LEFT"*/,,/*"LEFT"*/,,,.F.)	// "DATA"
TRCell():New(oSection2,"CORRELATIVO"	,""       ,"LOTE/SUB/DOC/LINEA",/*Picture*/,If(nTamSegOfi < 25, 25,nTamSegOfi),/*lPixel*/,{|| cArqTmp->(LOTE+SUBLOTE+DOC+LINHA) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// "LOTE/SUB/DOC/LINHA"

TRCell():New(oSection2,"XCONTA"	,"cArqTmp",Upper("CUENTA") ,/*Picture*/,20,/*lPixel*/,{|| cArqTmp->CONTA ,Nil },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// CUENTA

TRCell():New(oSection2,"HISTORICO"	,""		  ,"HISTORICO",/*Picture*/,nTamHist	,/*lPixel*/,{|| cArqTmp->HISTORICO},/*"LEFT"*/,.T.,/*"LEFT"*/,,,.F.)// "HISTORICO"	
TRCell():New(oSection2,"XPARTIDA"	,"cArqTmp","X PARTIDA",/*Picture*/,20,/*lPixel*/,/*{|| }*/,/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// "XPARTIDA"

TRCell():New(oSection2,"CCUSTO"		,"cArqTmp",Upper(cSayCusto),/*Picture*/,aTamCusto[1],/*lPixel*/,{|| IIF(lCusto == .T.,cArqTmp->CCUSTO,Nil) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Centro de Custo
TRCell():New(oSection2,"ITEM"		,"cArqTmp",Upper(cSayItem) ,/*Picture*/,nTamItem,/*lPixel*/,{|| IIF(lItem == .T.,cArqTmp->ITEM,Nil) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Item Contabil
TRCell():New(oSection2,"NIT"		,"cArqTmp",Upper(cSayNit) ,PesqPict("CT2","CT2_EC05DB")/*Picture*/,nTamNit,/*lPixel*/,{|| IIF(lNit == .T.,cArqTmp->NIT,Nil) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Classe de Valor


TRCell():New(oSection2,"DESCNIT"	,"cArqTmp",Upper("DESCRI") ,/*Picture*/,20,/*lPixel*/,{|| IIF(lNit == .T.,Posicione("CV0",2,xFilial("CV0")+cArqTmp->NIT,"CV0_DESC"),Nil) },/*"LEFT"*/,,/*"LEFT"*/,,,.F.)// Classe de Valor

TRCell():New(oSection2,"CLANCDEB"	,"cArqTmp","DEBITO",/*Picture*/,TAM_VALOR,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCDEB,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },/*"RIGHT"*/,,"CENTER",,,.F.)// "DEBITO"
TRCell():New(oSection2,"CLANCCRD"	,"cArqTmp","CREDITO",/*Picture*/,TAM_VALOR,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCCRD,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },/*"RIGHT"*/,,"CENTER",,,.F.)// "CREDITO"
TRCell():New(oSection2,"CTPSLDATU"	,"cArqTmp","SALDO ACTUAL",/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| }*/,/*"RIGHT"*/,,"CENTER",,,.F.)// "SALDO ATUAL"



If cPaisLoc $ "CHI|ARG|PER"
	TRCell():New(oSection2,"SEGOFI"	,"cArqTmp","SEGOFI",/*Picture*/,TamSx3("CT2_SEGOFI")[1],/*lPixel*/,{|| cArqTmp->SEGOFI }) //"SEGOFI"
EndIf

//*************************************************************
// Tratamento do campo SEGOFI para Chile e Argentina          *
// Caso o relatorio seja resumido imprime na coluna historico *
// Caso seja analitico imprime em uma nova coluna.            *
//*************************************************************

If cPaisLoc $ "CHI|ARG|PER" .and. lAnalitico //Se for relatorio analitico

	oSection2:Cell("HISTORICO"):SetSize(29)
	oSection2:Cell("HISTORICO"):SetBlock( { || Subs(cArqTmp->HISTORICO,1,29)})

ElseIf cPaisLoc $ "CHI|ARG|PER" .and. !lAnalitico //Se for relatorio Resumido

	oSection2:Cell("SEGOFI"):Hide()
	oSection2:Cell("SEGOFI"):HideHeader()

	oSection2:Cell("CORRELATIVO"):SetTitle(" " + " - " + "SEGOFI") //STR0034
	oSection2:Cell("CORRELATIVO"):SetSize(oSection2:Cell("CORRELATIVO"):GetSize() + Len(CriaVar("CT2_SEGOFI")) )
 	oSection2:Cell("CORRELATIVO"):SetBlock( { || cArqTmp->SEGOFI+" - "+cArqTmp->SEGOFI } )
  	oSection2:Cell("HISTORICO"):SetBlock( { || Subs(cArqTmp->HISTORICO,1,40)})
EndIf      

        
//****************************************
// Oculta campos para relatorio resumido *
//****************************************

If !lAnalitico // Resumido

  	oSection2:Cell("CORRELATIVO"):Hide()
	oSection2:Cell("CORRELATIVO"):SetTitle('')


  	oSection2:Cell("HISTORICO"):Hide()
 	oSection2:Cell("HISTORICO"):SetTitle('')
    
	oSection2:Cell("DESCNIT"):Hide()
 	oSection2:Cell("DESCNIT"):SetTitle('')

                                                 
    oSection2:Cell("XPARTIDA"):Disable() 	 
//  oSection2:Cell("FILIAL"):Disable() 	  	

EndIf   

oSection2:Cell("XCONTA"):Disable() 	 
// Inibir a coluna FILIAL do relatorio quando utiliza multi-filiais
                        
If !lAnalitico
	nTamTransp := oSection2:Cell("DATAL"):GetSize() + oSection2:Cell("CORRELATIVO"):GetSize() + oSection2:Cell("HISTORICO"):GetSize();
	              +oSection2:Cell("DESCNIT"):GetSize()+ oSection2:Cell("CLANCDEB"):GetSize() + oSection2:Cell("CLANCCRD"):GetSize()+3 
Else

	nTamTransp := oSection2:Cell("DATAL"):GetSize() + oSection2:Cell("CORRELATIVO"):GetSize() + oSection2:Cell("HISTORICO"):GetSize();
	              + oSection2:Cell("DESCNIT"):GetSize() + oSection2:Cell("XPARTIDA"):GetSize() + oSection2:Cell("CCUSTO"):GetSize();
	              + oSection2:Cell("ITEM"):GetSize() + oSection2:Cell("NIT"):GetSize() + oSection2:Cell("CLANCDEB"):GetSize();
	              + oSection2:Cell("CLANCCRD"):GetSize() + 4


Endif   

oSection2:Cell("DATAL"):lHeaderSize		:= .F.
oSection2:Cell("CORRELATIVO"):lHeaderSize	:= .F.
oSection2:Cell("CLANCDEB"):lHeaderSize	:= .F.
oSection2:Cell("CLANCCRD"):lHeaderSize	:= .F.
oSection2:Cell("CTPSLDATU"):lHeaderSize	:= .F.


//********************************
// Imprime linha saldo anterior  *
//********************************
           
//oSection1_1 - Totalizadores Conta               
oSection1_1 := TRSection():New(oReport,"Total Cuenta ",/*{"cArqTmp","CT2"}*/,/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) //STR0050

// Tamanho da coluna descrição da seção Section1_1
nTamDesc := nTamData + nTamSegOfi + nTamHist

TRCell():New(oSection1_1,"DESCRICAO","cArqTmp","",/*Picture*/,nTamDesc,/*lPixel*/,{|| })
TRCell():New(oSection1_1,"SALDOANT"	,"cArqTmp","",/*Picture*/,TAM_VALOR + 40,/*lPixel*/,{|| },"RIGHT",,"RIGHT")
oSection1_1:SetHeaderSection(.F.)  
oSection1_1:SetReadOnly()  

//oSection3 - Totalizadores Transporte

oSection3 := TRSection():New(oReport,"Total Transporte",/*Alias*/,/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/,,,,,,.F.,,,)	//" Total Transporte"

TRCell():New(oSection3,"CTRANSP"	,/*Alias*/,/*titulo*/,/*Picture*/,nTamTransp,/*lPixel*/,/*{||}*/,,,,,,.F.)	
TRCell():New(oSection3,"CSLDATU"	,/*Alias*/,/*titulo*/,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{||}*/,,,/*"RIGHT"*/,,,.F.)
oSection3:SetHeaderSection(.F.) 
oSection3:SetReadOnly()    

oSection3:Cell("CTRANSP"):lHeaderSize := .F.
oSection3:Cell("CSLDATU"):lHeaderSize := .F.
     
//oReport:ParamReadOnly() 

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintº Autor ³ Cicero J. Silva    º Data ³  14/07/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportPrint(oReport,aCtbMoeda,aSetOfBook,cPicture,cDescMoeda,nDecimais,nTamConta,lAnalitico,lCusto,lItem,lNIt,cArqTmp,aSelFil)

Local oSection1 	:= oReport:Section(1)
Local oSection2		:= oReport:Section(2)
Local oSection1_1	:= oReport:Section(3)
Local oSection3		:= oReport:Section(4)    

Local cFiltro		:= oSection2:GetAdvplExp()

Local cSayCusto		:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayNit		:= "NIT"

Local aSaldo		:= {}
Local aSaldoAnt		:= {}

Local cContaIni		:= mv_par01 // da conta
Local cContaFIm		:= mv_par02 // ate a conta 
Local cMoeda		:= mv_par05 // Moeda
Local cSaldo		:= mv_par06 // Saldos
Local cCustoIni		:= mv_par13 // Do Centro de Custo
Local cCustoFim		:= mv_par14 // At‚ o Centro de Custo
Local cItemIni		:= mv_par16 // Do Item 
Local cItemFim		:= mv_par17 // Ate Item 
Local cNitIni		:= mv_par19 // Imprime Classe de Valor?
Local cNitFim		:= mv_par20 // Ate a Classe de Valor
Local cContaAnt		:= ""
Local cDescConta	:= ""
Local cCodRes		:= ""
Local cResCC		:= ""
Local cResItem		:= ""
Local cResNit		:= ""
Local cDescSint		:= ""
Local cContaSint	:= ""
Local cNormal 		:= ""

Local xConta		:= ""

Local cSepara1		:= ""
Local cSepara2		:= ""
Local cSepara3		:= ""
Local cSepara4		:= ""
Local cMascara1		:= ""
Local cMascara2		:= ""
Local cMascara3		:= ""
Local cMascara4		:= ""

Local dDataAnt		:= CTOD("  /  /  ")
Local dDataIni		:= mv_par03 // da data
Local dDataFim		:= mv_par04 // Ate a data

Local nTotDeb		:= 0
Local nTotCrd		:= 0

Local nTotCtDeb		:= 0
Local nTotCtCrd		:= 0
Local nSaldoCtAt    := 0
Local nSldGerAtu    := 0
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nVlrDeb		:= 0
Local nVlrCrd		:= 0
Local nCont			:= 0
Local nTotTransp	:= 0

Local lNoMov		:= .T.//Iif(mv_par09==1,.T.,.F.) // Imprime conta sem movimento?
Local lSldAnt		:= .T.//Iif(mv_par09==3,.T.,.F.) // Imprime conta sem movimento?
Local lJunta		:= Iif(mv_par10==1,.T.,.F.) // Junta Contas com mesmo C.Custo?
Local lPrintZero	:= Iif(mv_par30==1,.T.,.F.) // Imprime valor 0.00    ?
Local lImpLivro		:= .t.
Local lImpTermos	:= .f.
Local lEmissUnica	:= If(GetNewPar("MV_CTBQBPG","M") == "M",.T.,.F.)			/// U=Quebra única (.F.) ; M=Multiplas quebras (.T.)
Local lSldAntCta	:= Iif(mv_par33 == 1, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr
Local lSldAntCC		:= Iif(mv_par33 == 2, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr
Local lSldAntIt  	:= Iif(mv_par33 == 3, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr
Local lSldAntCv  	:= Iif(mv_par33 == 4, .T.,.F.)// Saldo Ant. nivel?Cta/C.C/Item/Cl.Vlr

Local cMoedaDesc	:= iif( Empty( mv_par34 ) , cMoeda , mv_par34 ) // RFC - 18/01/07 | BOPS 103653
Local nMaxLin   	:= mv_par32 // Num.linhas p/ o Razao?
Local nLinReport	:= 8
Local lResetPag		:= .T.
Local m_pag			:= 1 // controle de numeração de pagina
Local l1StQb		:= .T.  
Local nPagIni		:= mv_par22
Local nPagFim		:= mv_par23
Local nReinicia		:= mv_par24
Local nBloco		:= 0
Local nBlCount		:= 1
Local cEspFil		:= ""
Local cFilSTR   	:= ""
Local cMasc 		:= ""
Local aMasc			:= {}
Local nMascFor		:= 0
Local nPosMV		:= 0
Local nAte	 		:= Len(alltrim(mv_par36))
Local nX
Local cNome         :=""    


IF mv_par36 == 1 .And. Len( aSelFil ) <= 0
	aSelFil := AdmGetFil()
EndIf

If oReport:GetOrientation() == 1 .or. !lAnalitico // Resumido     
    
   	nTransp := oSection2:Cell("DATAL"):GetSize() + oSection2:Cell("CORRELATIVO"):GetSize() + oSection2:Cell("HISTORICO"):GetSize();
             +oSection2:Cell("DESCNIT"):GetSize() + oSection2:Cell("XPARTIDA"):GetSize()+ oSection2:Cell("CLANCDEB"):GetSize();
	         + oSection2:Cell("CLANCCRD"):GetSize()+6
   
	If oReport:nDevice == 1
		nTransp -= 20
	Endif 
	
	oSection3:Cell("CTRANSP"):SetSize(nTransp) 	
   	oSection2:Cell("CCUSTO"):Disable()	
  	oSection2:Cell("ITEM"):Disable()
  	oSection2:Cell("NIT"):Disable()  


 	//MsgAlert("Atenção, as colunas das entidades Cl Valor, C.Custo e Item Contábil  não serão impressas no modo retrato ou na opção Resumido.") // "Atenção, as colunas das entidades Cl Valor, C.Custo e Item Contábil  não serão impressas no modo retrato ou na opção Resumido.")	  		 
 	MsgAlert("Atención, las columnas de las entidades C.Custo, Item Contable y Terceros no serán imprimidas en modo retrato o en las opciones 'Resumido' o 'Sintetico'.") // "Atenção, as colunas das entidades Cl Valor, C.Custo e Item Contábil  não serão impressas no modo retrato ou na opção Resumido.")	  		 
 	
Endif     


// Mascara da Conta
cMascara1 := IIf (Empty(aSetOfBook[2]),GetMv("MV_MASCARA"),RetMasCtb(aSetOfBook[2],@cSepara1) )

If lCusto .Or. lItem .Or. lNit
	// Mascara do Centro de Custo
	cMascara2 := IIf ( Empty(aSetOfBook[6]),GetMv("MV_MASCCUS"),RetMasCtb(aSetOfBook[6],@cSepara2) )
	// Mascara do Item Contabil
	dbSelectArea("CTD")
	cMascara3 := IIf ( Empty(aSetOfBook[7]),ALLTRIM(STR(Len(CTD->CTD_ITEM))) , RetMasCtb(aSetOfBook[7],@cSepara3) )
	// Mascara da Classe de Valor
	dbSelectArea("CV0")
	cMascara4 := ALLTRIM(STR(Len(CV0->CV0_CODIGO)))
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par29==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par29==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par29==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If oReport:Title() == oReport:cRealTitle //If Type("NewHead")== "U" 
	IF lAnalitico
		cTitulo	:=Iif(cPaisLoc=="PER","RAZAO ANALITICO EM ",	"AUXILIAR TERCERO EN ")	//"RAZAO ANALITICO EM "  
		//Titulo:=cTitulo
		Titulo  := cTitulo + Alltrim(cDescMoeda) + " - " + Tabela("SL", MV_PAR06, .F.)//" DE " + DTOC(dDataIni) +;	// "DE"
					//" A " + DTOC(dDataFim) + CtbTitSaldo(mv_par06)	//                                                                        	
	Else
		cTitulo	:=	Iif(cPaisLoc=="PER","RAZAO SINTETICO EM ",	"AUXILIAR TERCERO EN ")	//"RAZAO SINTETICO EM "     
		Titulo  := cTitulo + Alltrim(cDescMoeda) + " - " + Tabela("SL", MV_PAR06, .F.) //" DE " + DTOC(dDataIni) +;	// "DE"
					//" ATE " + DTOC(dDataFim) + CtbTitSaldo(mv_par06)	// "ATE"
	EndIf    
Else
	Titulo := oReport:Title()  //NewHead
	cTitulo:=Titulo

EndIf     


If FindFunction("CABRELPER") .and.  cPaisLoc=="PER" 
	oReport:SetTitle(cTitulo)   
	oReport:SetCustomText( {|| CABRELPER(      ,          ,         ,          ,             ,dDataFim,oReport:Title()                ,             ,        ,             ,        ,oReport,.T.         ,@lResetPag,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb,            ,cTitulo) } )
Else
	oReport:SetTitle(Titulo)
	oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,oReport:Title(),,,,,oReport,.T.,@lResetPag,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb) } )
Endif

oSection1:OnPrintLine( {|| CTR402Maxl(@nMaxLin,@nLinReport)} )	  
oSection1_1:OnPrintLine( {|| CTR402Maxl(@nMaxLin,@nLinReport)} )	  
oSection2:OnPrintLine( {|| CTR402Maxl(@nMaxLin,@nLinReport)} )	  

oReport:OnPageBreak( {|| CTR402Maxl(@nMaxLin,@nLinReport)} )	 

If lImpLivro
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Arquivo Temporario para Impressao   					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgMeter({|	oMeter, oText, oDlg, lEnd | U_xCTBNIT(	oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
							cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
							aSetOfBook,lNoMov,cSaldo,lJunta,IIF(mv_par39==1,"4","1")/*IIF(mv_par39==1 .OR. cpaisLoc != "COL","1","4")*/,lAnalitico,,,cFiltro,lSldAnt,aSelFil) },;
				"Criando Archivo Temporario...",;		// "Criando Arquivo Tempor rio..."
				"Emision del Balance de Terceros")		// "Emissao do Razao"				

	dbSelectArea("cArqTmp")
	dbGoTop()

	oReport:SetMeter( RecCount() )
	oReport:NoUserFilter()

Endif

//If mv_par39==2 .And. lAnalitico
If mv_par39==1 .And. lAnalitico
	oBrkConta 	:= TRBreak():New( oSection2, { || cArqTmp->CONTA+cArqTmp->NIT }, OemToAnsi("Total Cuenta+NIT"), )
	oBrkCont2 	:= TRBreak():New( oReport, { || cArqTmp->CONTA}, OemToAnsi("TOTAL CUENTA "), )		
Else
	oBrkConta 	:= TRBreak():New( oSection2, { || cArqTmp->CONTA}, OemToAnsi("Total Cuenta " ), )		
EndIf	                                                                                                             

oTotDeb 	:= TRFunction():New( oSection2:Cell("CLANCDEB")	, ,"ONPRINT", oBrkConta,"",cPicture,;
					{ || ValorCTB(nTotDeb  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)

oTotCred	:= TRFunction():New( oSection2:Cell("CLANCCRD")	, ,"ONPRINT", oBrkConta,""/*Titulo*/,cPicture,;
					{ || ValorCTB(nTotCrd  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)
oTotTpSld 	:= TRFunction():New( oSection2:Cell("CTPSLDATU")	, ,"ONPRINT", oBrkConta,""/*Titulo*/,cPicture,;	 
						{ || ValorCTB(nSaldoAtu,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)


If mv_par39==1 .And. lAnalitico
//If mv_par39==2 .And. lAnalitico

	oTotCtDeb 	:= TRFunction():New( oSection2:Cell("CLANCDEB")	, ,"ONPRINT", oBrkCont2,"",cPicture,;
						{ || ValorCTB(nTotCtDeb  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)	
	oTotCtCred	:= TRFunction():New( oSection2:Cell("CLANCCRD")	, ,"ONPRINT", oBrkCont2,""/*Titulo*/,cPicture,;
						{ || ValorCTB(nTotCtCrd  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)
	oTotCtSld 	:= TRFunction():New( oSection2:Cell("CTPSLDATU") , ,"ONPRINT", oBrkCont2,""/*Titulo*/,cPicture,;	 
							{ || ValorCTB(nSaldoCtAt,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)		
EndIf
						
						

If lImpLivro .And. mv_par28 == 1	//Imprime total Geral
           
	oBrkEnd 	:= TRBreak():New( oReport, { || /*cArqTmp->(Eof())*/	}, OemToAnsi("T O T A L  G E N E R A L  ==> "), )//"T O T A L  G E R A L  ==> "
	oTotGerDeb 	:= TRFunction():New( oSection2:Cell("CLANCDEB")	, ,"ONPRINT", oBrkEnd,/*Titulo*/,cPicture,;
				{ || ValorCTB(nTotGerDeb  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)
	oTotGerCred	:= TRFunction():New( oSection2:Cell("CLANCCRD")	, ,"ONPRINT", oBrkEnd,/*Titulo*/,cPicture,;
				{ || ValorCTB(nTotGerCrd  ,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)
	oSldGerAtu 	:= TRFunction():New( oSection2:Cell("CTPSLDATU")	, ,"ONPRINT", oBrkEnd,""/*Titulo*/,cPicture,;	 
	            { || ValorCTB(nSldGerAtu,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2)		
				
                                        
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Saldo Anterior do Centro de Custo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par39==1 .And. lAnalitico 
	//oSection1_1:Cell("DESCRICAO"):SetBlock( {|| xConta } )      
	//aTst := SaldoCT7Fil(cArqTmp->CONTA,MV_PAR03,MV_PAR05,MV_PAR06,,,,aSelFil)
	oSection1:Cell("SALCUEN"):SetBlock( {|| ValorCTB(SaldoCT7Fil(cArqTmp->CONTA,MV_PAR03,MV_PAR05,MV_PAR06,,,,aSelFil)[6],,,TAM_VALOR,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) } )//"SALDO ANTERIOR: "
	
	oSection1_1:Cell("DESCRICAO"):SetBlock( {|| xConta } )
	oSection1_1:Cell("SALDOANT"):SetBlock( {|| "SAL ANTERIOR NIT "+cArqTmp->NIT+" : " + ValorCTB(aSaldoAnt[6],,,TAM_VALOR,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) } )//"SALDO ANTERIOR: "
Else
	oSection1_1:Cell("DESCRICAO"):SetBlock( {|| xConta } )
	oSection1_1:Cell("SALDOANT"):SetBlock( {|| "SALDO ANTERIOR : " + ValorCTB(aSaldoAnt[6],,,TAM_VALOR,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) } )//"SALDO ANTERIOR: "
EndIf	

oSection1_1:Cell("DESCRICAO"):HideHeader() 
oSection1_1:Cell("SALDOANT"):HideHeader() 

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If lImpLivro
	If cArqTmp->(EoF())              
		// Atencao ### "Nao existem dados para os parâmetros especificados."
		Aviso("Atencion","No existem datos para los parametros especificados.",{"Ok"})
		oReport:CancelPrint()
		Return
	Else
		While lImpLivro .And. cArqTmp->(!Eof()) .And. !oReport:Cancel()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³INICIO DA 1a SECAO             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    If oReport:Cancel()
		    	Exit
		    EndIf        
		   		

			// Conta Sintetica	
			cContaSint := u_xCtr402Si(cArqTmp->CONTA,@cDescSint,cMoeda,@cDescConta,@cCodRes,cMoedaDesc)
			cNormal := CT1->CT1_NORMAL
			
 			oSection1:Cell("DESCCC"):SetBlock( { || " - " + cDescSint } )  
			oSection1:Cell("DESCCC"):SetSize(LEN(cDescSint)+3)
			If mv_par11 == 3
				oSection1:Cell("CONTA" ):SetBlock( { || EntidadeCTB(CT1->CT1_CODIMP,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.) } )
			Else
				oSection1:Cell("CONTA" ):SetBlock( { || EntidadeCTB(cContaSint,0,0,Len(cContaSint),.F.,cMascara1,cSepara1,,,,,.F.) } )
			Endif

			oSection3:Cell("CTRANSP"):SetBlock( { || Iif(nLinReport == 11,  "Transporte", "Transporte")}) 
			oSection3:Cell("CSLDATU"):SetBlock( { || ValorCTB(nSldTransp,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) })  
 			                                                    
                  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³INICIO DA IMPRESSAO DA 1A SECAO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
    	 	oSection1:Init() 
    	 	nLin := 3

	     	oSection1:PrintLine() 
		    oSection1:Finish()  
		
			nSaldoCtAt   := 0
			nTotCtDeb	 := 0
			nTotCtCrd    := 0                                           
			
            cContaSup:= cArqTmp->CONTA
            
			Do While cArqTmp->(!Eof() .And. cContaSup == cArqTmp->CONTA ) .And. !oReport:Cancel()   
			
			   //Busca os saldos por Conta+Nit
				If lSldAntCC
					aSaldo    := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo,aSelFil)	
					aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,aSelFil)
				ElseIf lSldAntIt
					aSaldo    := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo,aSelFil)	
					aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,aSelFil)
				Else 
					If MV_PAR39 == 1
					//If lAnalitico 
						//aSaldo    := U_SldTotCVX(cNitIni,cNitFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo,aSelFil)	
						//aSaldoAnt := U_SldTotCVX(cNitIni,cNitFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,aSelFil)
						aSaldo    := U_xSldCVX(cArqTmp->NIT,cArqTmp->NIT,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo,aSelFil,,,,,,,.F.)	
						aSaldoAnt := U_xSldCVX(cArqTmp->NIT,cArqTmp->NIT,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,aSelFil,,,,,,,.T.)				
					Else
						aSaldo 		:= SaldoCT7Fil(cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo,,,,aSelFil)	
						aSaldoAnt	:= SaldoCT7Fil(cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,"CTBR402",,,aSelFil)				
					EndIf	
				EndIf 
				
			   	If f180Fil(lNoMov,aSaldo,dDataIni,dDataFim)
					dbSkip()
					Loop
				EndIf
				
				
			   	nSaldoAtu  := aSaldoAnt[6]         
			   	nSaldoCtAt += aSaldoAnt[6]             
			   	nSldGerAtu += aSaldoAnt[6]
			
				xConta := "CUENTA - "	
	
				If mv_par11 == 1							// Imprime Cod Normal
					xConta += EntidadeCTB(cArqTmp->CONTA,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.)
				Else
					dbSelectArea("CT1")
					dbSetOrder(1)
					MsSeek(xFilial("CT1")+cArqTMP->CONTA,.F.)
					If mv_par11 == 3						// Imprime Codigo de Impressao
						xConta += EntidadeCTB(CT1->CT1_CODIMP,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.)
					Else										// Caso contrário usa codigo reduzido
						xConta += EntidadeCTB(CT1->CT1_RES,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.)
					EndIf
				
					cDescConta := &("CT1->CT1_DESC" + cMoedaDesc )
				Endif
	
				If !lAnalitico 
					xConta +=  " - " + Left(cDescConta,30)
				Else
					xConta +=  " - " + Left(cDescConta,40)
				Endif
	
				oSection1_1:Init()   
				nLin := 2
		     	oSection1_1:PrintLine()
			    oSection1_1:Finish()
						                                    
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³FIM DA 1a SECAO³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³INICIO DA 2a SECAO³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("cArqTmp")
				
				//*************Modificado por Otavio Campos *******14/07/2014************************************
				
				//cContaAnt:= IIF( mv_par39==2 .And. lAnalitico, cArqTmp->CONTA+cArqTmp->NIT, cArqTmp->CONTA )
				cContaAnt:= IIF( mv_par39==1 .And. lAnalitico, cArqTmp->CONTA+cArqTmp->NIT, cArqTmp->CONTA )
				
				//If mv_par39==2 .And. lAnalitico 
				If mv_par39==1 .And. lAnalitico
					cCondic := "CONTA+NIT"
				Else 
					cCondic := "CONTA"
				EndIf           			                                                  
				
				dDataAnt	:= CTOD("  /  /  ")
				oSection2:Init()                            
				//mv_par39==1
				             
				
				Do While cArqTmp->(!Eof() .And. &cCondic == cContaAnt ) .And. !oReport:Cancel()   
	
				    If oReport:Cancel()
				    	Exit
				    EndIf        			    			    			    
			   		
			   			    
					If dDataAnt <> cArqTmp->DATAL 
						If ( cArqTmp->LANCDEB <> 0 .Or. cArqTmp->LANCCRD <> 0 )
							oSection2:Cell("DATAL"):SetBlock( { || dDataAnt } )
						Endif	
						dDataAnt := cArqTmp->DATAL    
					EndIf	
	   					
					If lAnalitico //Se for relatorio analitico   				
	   						
						nSaldoAtu 	:= nSaldoAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD
						nTotDeb		+= cArqTmp->LANCDEB
						nTotCrd		+= cArqTmp->LANCCRD                               
						nSaldoCtAt	:= nSaldoCtAt - cArqTmp->LANCDEB + cArqTmp->LANCCRD
						nTotCtDeb	+= cArqTmp->LANCDEB
						nTotCtCrd	+= cArqTmp->LANCCRD
						nSldGerAtu  := nSldGerAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD
						nTotGerDeb	+= cArqTmp->LANCDEB
						nTotGerCrd	+= cArqTmp->LANCCRD		
						
						
						dbSelectArea("cArqTmp")				
		   					   				
						If mv_par11 == 1 // Impr Cod (Normal/Reduzida/Cod.Impress)
							oSection2:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(cArqTmp->XPARTIDA,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.) } )
						ElseIf mv_par11 == 3
							oSection2:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(CT1->CT1_CODIMP,0,0,nTamConta,.F.,cMascara1,cSepara1,,,,,.F.) } )
						Else
							dbSelectArea("CT1")
							dbSetOrder(1)
							MsSeek(xFilial("CT1")+cArqTmp->XPARTIDA,.F.)
							oSection2:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(CT1->CT1_RES,0,0,TAM_CONTA,.F.,cMascara1,cSepara1,,,,,.F.) } )
						Endif
						
					   //oSection2:Cell("Filial"):SetBlock( { || cArqTmp->FILORI } )
						
						If lCusto
							If mv_par25 == 1 //Imprime Cod. Centro de Custo Normal 
								oSection2:Cell("CCUSTO"):SetBlock( { || EntidadeCTB(cArqTmp->CCUSTO,0,0,TAM_CONTA,.F.,cMascara2,cSepara2,,,,,.F.) } )
							Else 
								dbSelectArea("CTT")
								dbSetOrder(1)
								dbSeek(xFilial("CTT")+cArqTmp->CCUSTO)				
								cResCC := CTT->CTT_RES
								oSection2:Cell("CCUSTO"):SetBlock( { || EntidadeCTB(cResCC,0,0,TAM_CONTA,.F.,cMascara2,cSepara2,,,,,.F.) } )
								dbSelectArea("cArqTmp")
							Endif                                                       
						Endif
						If lItem 						//Se imprime item 
							If mv_par26 == 1 //Imprime Codigo Normal Item Contabl
								oSection2:Cell("ITEM"):SetBlock( { || EntidadeCTB(cArqTmp->ITEM,0,0,TAM_CONTA,.F.,cMascara3,cSepara3,,,,,.F.) } )
							Else
								dbSelectArea("CTD")
								dbSetOrder(1)
								dbSeek(xFilial("CTD")+cArqTmp->ITEM)				
								cResItem := CTD->CTD_RES
								oSection2:Cell("ITEM"):SetBlock( { || EntidadeCTB(cResItem,0,0,TAM_CONTA,.F.,cMascara3,cSepara3,,,,,.F.) } )
								dbSelectArea("cArqTmp")					
							Endif
						Endif
						If lNIt //Se imprime classe de valor
							oSection2:Cell("NIT"):SetBlock( { || EntidadeCTB(cArqTmp->NIT,0,0,TAM_CONTA,.F.,"",cSepara4,,,,,.F.) } )
						Endif
	
						oSection2:Cell("CTPSLDATU"):SetBlock( { || ValorCTB(nSaldoAtu,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) } )
				        nLin := 1
				     	oSection2:PrintLine() 
				     	
						nSldTransp := nSaldoAtu // Valor a Transportar - 1
	
					    oReport:IncMeter()
	
						// Procura complemento de historico e imprime
					  	ImpCompl( oSection2 ) // oReport)
				        
						dbSkip()
				
					Else // !lAnalitico	 -- Se for resumido.                               			
						
						dbSelectArea("cArqTmp")
						
						While dDataAnt == cArqTmp->DATAL .And. cContaAnt == cArqTmp->CONTA
							nVlrDeb	+= cArqTmp->LANCDEB		                                         
							nVlrCrd	+= cArqTmp->LANCCRD		                                         
							nTotGerDeb	+= cArqTmp->LANCDEB
							nTotGerCrd	+= cArqTmp->LANCCRD			
							dbSkip()
						EndDo
						
						nSaldoAtu	:= nSaldoAtu - nVlrDeb + nVlrCrd
					  	oSection2:Cell("CLANCDEB"):SetBlock( { || ValorCTB(nVlrDeb,,,TAM_VALOR,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) })// Debito
					  	oSection2:Cell("CLANCCRD"):SetBlock( { || ValorCTB(nVlrCrd,,,TAM_VALOR,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) })// Credito
						oSection2:Cell("CTPSLDATU"):SetBlock( { || ValorCTB(nSaldoAtu,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) })// Sinal do Saldo Atual => Consulta Razao
	
						//Imprime Section(1) - resumida.
						nLin := 1
				     	oSection2:PrintLine()
					    oReport:IncMeter()
	
						nSldTransp := nSaldoAtu // Valor a Transportar  
	
						nTotDeb		+= nVlrDeb
						nTotCrd		+= nVlrCrd         
						nVlrDeb	:= 0
						nVlrCrd	:= 0
					Endif // lAnalitico		   			
				EndDo //cArqTmp->(!Eof()) .And. cArqTmp->CONTA == cContaAnt

 	   			If nSldTransp != 0  
 	   				nLinReport+=3
	 	   		Endif
 		        
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³FIM DA 2a SECAO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 				oSection2:Finish()   
			    nSldTransp  := 0
				nSaldoAtu   := 0
				nTotDeb	    := 0
				nTotCrd	    := 0                              			
	      EndDo				 		            			

		EndDo //lImpLivro .And. !cArqTmp->(Eof()) 
	EndIf //!(cArqTmp->(RecCount()) == 0 .And. !Empty(aSetOfBook[5]))
EndIf // lImpLivro

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao dos Termos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lImpTermos 							// Impressao dos Termos
	
	oSection2:SetHeaderPage(.F.) // Desabilita a impressao 
	
	cArqAbert:=GetNewPar("MV_LRAZABE","")
	cArqEncer:=GetNewPar("MV_LRAZENC","")
	
    If Empty(cArqAbert)
		ApMsgAlert(	"Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. " +; //"Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. "
					"Utilize como base o parametro MV_LDIARAB.") //"Utilize como base o parametro MV_LDIARAB."
	Endif
Endif

If lImpTermos .And. ! Empty(cArqAbert)	
	dbSelectArea("SM0")
	aVariaveis:={}

	For nCont:=1 to FCount()	
		If FieldName(nCont)=="M0_CGC"
			AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 99.999.999/9999-99")})
		Else
            If FieldName(nCont)=="M0_NOME"
                Loop
            EndIf
			AADD(aVariaveis,{FieldName(nCont),FieldGet(nCont)})
		Endif
	Next

	dbSelectArea("SX1")
	dbSeek( padr( "CTR402" , Len( X1_GRUPO ) , ' ' ) + "01" )
	While ! Eof() .And. SX1->X1_GRUPO  == padr( "PROR403" , Len( X1_GRUPO ) , ' ' )
		AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
		dbSkip()
	End

	If AliasIndic( "CVB" )
		dbSelectArea( "CVB" )
		CVB->(dbSeek( xFilial( "CVB" ) ))
		For nCont:=1 to FCount()
			If FieldName(nCont)=="CVB_CGC"
				AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 99.999.999/9999-99")})
			ElseIf FieldName(nCont)=="CVB_CPF"
				AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 999.999.999-99")})
			Else
				AADD(aVariaveis,{FieldName(nCont),FieldGet(nCont)})
			Endif
		Next
	EndIf

	AADD(aVariaveis,{"M_DIA",StrZero(Day(dDataBase),2)})
	AADD(aVariaveis,{"M_MES",MesExtenso()})
	AADD(aVariaveis,{"M_ANO",StrZero(Year(dDataBase),4)})

	If !File(cArqAbert)
		aSavSet:=__SetSets()
		cArqAbert:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If !File(cArqEncer)
		aSavSet:=__SetSets()
		cArqEncer:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqAbert#NIL
		oReport:EndPage()
		ImpTerm2(cArqAbert,aVariaveis,,,,oReport)
	Endif
	If cArqEncer#NIL
		oReport:EndPage()
		ImpTerm2(cArqEncer,aVariaveis,,,,oReport)
	Endif	 
Endif 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo TXT			                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MV_PAR37 == 1
	GerArq(AllTrim(MV_PAR38))
EndIf


dbselectArea("CT2")
If !Empty(dbFilter())
	dbClearFilter()
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTR402MaxLºAutor  ³                    º Data ³  25/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³														      º±±
±±º          ³						                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR402                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function CTR402MaxL(nMaxLin, nLinReport)
Local oSection1	:= oReport:Section(1)
Local oSection3	:= oReport:Section(4)  
Local lSalLin 	:= IIf(mv_par31==1,.T.,.F.)//"Salta linha entre contas?"  

If oSection1:Printing() .AND. lSalLin
	oReport:SkipLine()
	nLinReport++
Endif 
     
nLinReport+=nLin 

If nLinReport >= nMaxLin  

	If nSldTransp != 0
		oSection3:Init()
		oSection3:PrintLine()
		oReport:EndPage()
		
		nLinReport := 11		
		oSection3:PrintLine()
		oReport:SkipLine()
		oSection3:Finish()
	Else 
		oReport:EndPage()
		nLinReport := 9 + nLin
    Endif
Endif

Return Nil
      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpCompl  ºAutor  ³Cicero J. Silva     º Data ³  27/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a descricao, da conta contabil, item, centro de     º±±
±±º          ³custo ou classe valor                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ImpCompl(oSection2)
	oSection2:Cell("DATAL"		):Hide()
	oSection2:Cell("CORRELATIVO"):Hide()
 	oSection2:Cell("XPARTIDA"	):Hide()
	oSection2:Cell("CCUSTO"		):Hide()
	oSection2:Cell("ITEM"		):Hide()
	oSection2:Cell("NIT"		):Hide()
	oSection2:Cell("CLANCDEB"	):Hide()
	oSection2:Cell("CLANCCRD"	):Hide()
	oSection2:Cell("CTPSLDATU"	):Hide()
	
	// Procura pelo complemento de historico
	dbSelectArea("CT2")               
	dbSetOrder(10)
	If MsSeek(xFilial("CT2")+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI),.F.)
		dbSkip()

		If CT2->CT2_DC == "4"			//// TRATAMENTO PARA IMPRESSAO DAS CONTINUACOES DE HISTORICO
			While !CT2->(Eof()) .And.;
					CT2->CT2_FILIAL == xFilial("CT2") .And.;
					 CT2->CT2_LOTE == cArqTMP->LOTE .And.;
					  CT2->CT2_SBLOTE == cArqTMP->SUBLOTE .And.;
					   CT2->CT2_DOC == cArqTmp->DOC .And.;
						CT2->CT2_SEQLAN == cArqTmp->SEQLAN .And.;
						 CT2->CT2_EMPORI == cArqTmp->EMPORI .And.;
						  CT2->CT2_FILORI == cArqTmp->FILORI .And.;
						   CT2->CT2_DC == "4" .And.;
				    	    DTOS(CT2->CT2_DATA) == DTOS(cArqTmp->DATAL)

				oSection2:Cell("HISTORICO"):SetBlock({|| CT2->CT2_HIST } )
				oSection2:Printline()

				CT2->(dbSkip())			
			EndDo	
		EndIf
	EndIf                  

	oSection2:Cell("HISTORICO"):SetBlock( { || cArqTmp->HISTORICO } )

	oSection2:Cell("DATAL"		):Show()
	oSection2:Cell("CORRELATIVO"	):Show()
  	oSection2:Cell("XPARTIDA"	):Show()
	oSection2:Cell("CCUSTO"		):Show()
	oSection2:Cell("ITEM"		):Show()
	oSection2:Cell("NIT"		):Show()
	oSection2:Cell("CLANCDEB"	):Show()
	oSection2:Cell("CLANCCRD"	):Show()
	oSection2:Cell("CTPSLDATU"	):Show()

	dbSelectArea("cArqTmp")

Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f180Fil   ºAutor  ³Cicero J. Silva     º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR402                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function f180Fil(lNoMov,aSaldo,dDataIni,dDataFim)

Local lDeixa	:= .F.

	If !lNoMov //Se imprime conta sem movimento
		If aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0 
			lDeixa	:= .T.
		Endif	
	Endif             
	
	If lNoMov .And. aSaldo[6] == 0 .And. cArqTmp->LANCDEB ==0 .And. cArqTmp->LANCCRD == 0 
		If CtbExDtFim("CT1") 			
			dbSelectArea("CT1") 
			dbSetOrder(1) 
			If MsSeek(xFilial()+cArqTmp->CONTA)
				If !CtbVlDtFim("CT1",dDataIni) 		
					lDeixa	:= .T.
	            EndIf                                   
	            
	            If !CtbVlDtIni("CT1",dDataFim)
					lDeixa	:= .T.
	            EndIf                                   

		    EndIf
		EndIf
	EndIf

	dbSelectArea("cArqTmp")

Return (lDeixa)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CTBGeRaNIT³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Cria Arquivo Temporario para imprimir o Razao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³CTBGeRaNIT(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim³±±
±±³			  ³cCustoIni,cCustoFim,cItemIni,cItemFim,cNitIni,cNitFim,    ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo,lAnalit)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nome do arquivo temporario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ ExpL4 = Indica se imprime analitico ou sintetico           ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xCTBNIT(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
						cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
						aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,lAnalit,c2Moeda,;
						nTipo,cUFilter,lSldAnt,aSelFil)

Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCusto	:= TAMSX3("CT3_CUSTO") 
Local aTamVal	:= TAMSX3("CT2_VALOR")
Local aCtbMoeda	:= {}
Local aSaveArea := GetArea()                       
Local aCampos
Local cChave
Local nTamHist	:= Len(CriaVar("CT2_HIST"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM"))
Local nTamNit	:= Len(CriaVar("CV0_CODIGO"))
Local nDecimais	:= 0    
Local cMensagem		:= "El plano gerencial no esta disponible nese relatorio."//STR0030// O plano gerencial nao esta disponivel nesse relatorio. 
Local lCriaInd := .F.
Local nTamFilial 	:= IIf( lFWCodFil, TamSx3( "CT2_FILIAL" )[1] , TamSx3( "CT2_FILIAL" )[1] )//IIf( lFWCodFil, FWGETTAMFILIAL, TamSx3( "CT2_FILIAL" )[1] )
Local nTamSegOfi:= Len(CriaVar("CT2_SEGOFI"))


DEFAULT c2Moeda := ""
DEFAULT nTipo	:= 1
DEFAULT cUFilter:= ""
DEFAULT lSldAnt	:= .T.//.F.
DEFAULT aSelFil := {}

#IFDEF TOP
//If TcSrvType() != "AS/402" .And. cTipo == "1" .And. FunName() == 'PROR402' .And. TCGetDb() $ "MSSQL7/MSSQL"		
If TcSrvType() != "AS/402" .And. cTipo == "4" .And. FunName() == 'PROR403' .And. TCGetDb() $ "MSSQL7/MSSQL"		
	DEFAULT cUFilter	:= ".T."		
Else
#ENDIF

DEFAULT cUFilter	:= ""

#IFDEF TOP
Endif
#ENDIF

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
                
aCampos :={	{ "CONTA"		, "C", aTamConta[1], 0 },;  		// Codigo da Conta
			{ "XPARTIDA"   	, "C", aTamConta[1] , 0 },;		// Contra Partida
			{ "TIPO"       	, "C", 01			, 0 },;			// Tipo do Registro (Debito/Credito/Continuacao)
			{ "LANCDEB"		, "N", aTamVal[1]+2, nDecimais },; // Debito
			{ "LANCCRD"		, "N", aTamVal[1]+2	, nDecimais },; // Credito
			{ "SALDOSCR"	, "N", aTamVal[1]+2, nDecimais },; 			// Saldo
			{ "TPSLDANT"	, "C", 01, 0 },; 					// Sinal do Saldo Anterior => Consulta Razao
			{ "TPSLDATU"	, "C", 01, 0 },; 					// Sinal do Saldo Atual => Consulta Razao			
			{ "HISTORICO"	, "C", nTamHist   	, 0 },;			// Historico
			{ "CCUSTO"		, "C", aTamCusto[1], 0 },;			// Centro de Custo
			{ "ITEM"		, "C", nTamItem		, 0 },;			// Item Contabil
			{ "NIT"			, "C", nTamNit		, 0 },;			// Classe de Valor
			{ "DATAL"		, "D", 10			, 0 },;			// Data do Lancamento
			{ "LOTE" 		, "C", 06			, 0 },;			// Lote
			{ "SUBLOTE" 	, "C", 03			, 0 },;			// Sub-Lote
			{ "DOC" 		, "C", 06			, 0 },;			// Documento
			{ "LINHA"		, "C", 03			, 0 },;			// Linha
			{ "SEQLAN"		, "C", 03			, 0 },;			// Sequencia do Lancamento
			{ "SEQHIST"		, "C", 03			, 0 },;			// Seq do Historico
			{ "EMPORI"		, "C", 02			, 0 },;			// Empresa Original
			{ "FILORI"		, "C", nTamFilial	, 0 },;			// Filial Original
			{ "NOMOV"		, "L", 01			, 0 },;			// Conta Sem Movimento
			{ "FILIAL"		, "C", nTamFilial	, 0 },;	  		// Filial do sistema
			{ "SEGOFI"		, "C", nTamSegOfi	, 0}}			// Numero do Correlativo


If ! Empty(c2Moeda)
	Aadd(aCampos, { "LANCDEB_1"	, "N", aTamVal[1]+2, nDecimais }) // Debito
	Aadd(aCampos, { "LANCCRD_1"	, "N", aTamVal[1]+2, nDecimais }) // Credito
	Aadd(aCampos, { "TXDEBITO"	, "N", aTamVal[1]+2, 6 }) // Taxa Debito
	Aadd(aCampos, { "TXCREDITO"	, "N", aTamVal[1]+2, 6 }) // Taxa Credito
Endif
																	
// Se o arquivo temporario de trabalho esta aberto
If ( Select ( "cArqTmp" ) > 0 )
	cArqTmp->(dbCloseArea())
EndIf

cArqTmp := CriaTrab(aCampos, .T.)
dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )
lCriaInd := .T.

DbSelectArea("cArqTmp")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"			// Razao por Conta
    If FunName() <> "PROR403"
    	If lAnalit
			cChave   := "CONTA+NIT+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		EndIf	
	Else        
		If lAnalit
			cChave   := "CONTA+NIT+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
		Else
			cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		EndIf	
	EndIf
ElseIf cTipo == "2"		// Razao por Centro de Custo                   
	If lAnalit 				// Se o relatorio for analitico
		If FunName() <> "CTBC440"
			cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
		EndIf
	Else                                                                  
		cChave 	:= "CCUSTO+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif
ElseIf cTipo == "3" 		//Razao por Item Contabil      
	If lAnalit 				// Se o relatorio for analitico               
		If FunName() <> "CTBC480"
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
		Endif
	Else                                                                  
		cChave 	:= "ITEM+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif
ElseIf cTipo == "4"		//Razao por Classe de Valor	
	/*If lAnalit 				// Se o relatorio for analitico               
		If FunName() <> "CTBC490"	
			cChave 	:= "NIT+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"	
		Else
			cChave 	:= "NIT+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
		EndIf
	Else                                                                  
		cChave 	:= "NIT+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif*/
	//29/03	
	cChave 	:= "CONTA+NIT+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
EndIf

dbSelectArea("cArqTmp")

If lCriaInd
	IndRegua("cArqTmp",cArqTmp,cChave,,,"Selecionando Registros...")  //"Selecionando Registros..."
	dbSelectArea("cArqTmp")
	dbSetIndex(cArqTmp+OrdBagExt())
Endif	
dbSetOrder(1)
                                                                                        
If !Empty(aSetOfBook[5])
	MsgAlert(cMensagem)	
	Return
EndIf                   

//CT2->(dbGotop())
#IFDEF TOP
	//If TcSrvType() != "AS/402" .And. cTipo == "1" .And. FunName() == 'PROR402' .And. TCGetDb() $ "MSSQL7/MSSQL"		
	If TcSrvType() != "AS/402" .And. cTipo == "4" .And. FunName() == 'PROR403' .And. TCGetDb() $ "MSSQL7/MSSQL"		
		U_xCtbQry(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
				aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt,aSelFil,lAnalit)	
	Else
#ENDIF
	// Monta Arquivo para gerar o Razao
	U_xCtbRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
			cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
			aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt,aSelFil,lAnalit)
#IFDEF TOP
	EndIf
#ENDIF	

RestArea(aSaveArea)

Return cArqTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbRazNIT  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbRazNIT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,		   ³±±
±±³			  ³cCustoIni,cCustoFim, cItemIni,cItemFim,cNitIni,cNitFim,   ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo)                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xCtbRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
					  	cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
					  	aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt,aSelFil,lAnalit)

Local cCpoChave	:= ""
Local cClave2   := ""
Local cTmpChave	:= ""
Local cContaI	:= ""
Local cContaF	:= ""
Local cCustoI	:= ""
Local cCustoF	:= ""
Local cItemI	:= ""
Local cItemF	:= ""
Local cNitI	:= ""
Local cNitF	:= ""
Local cVldEnt	:= ""
Local cAlias	:= ""
Local lUFilter	:= !Empty(cUFilter)			//// SE O FILTRO DE USUÁRIO NÃO ESTIVER VAZIO - TEM FILTRO DE USUÁRIO
Local cFilMoeda	:= "" 							
Local cAliasCT2	:= "CT2"	
Local bCond		:= {||.T.}
Local cQryFil	:= '' // variavel de condicional da query
Local cTmpCT2Fil

#IFDEF TOP
	Local cQuery	:= ""
	Local cOrderBy	:= ""
	Local nI	:= 0
	Local aStru	:= {}
#ENDIF

DEFAULT cUFilter := ".T."
DEFAULT lSldAnt	 := .T.//.F.
DEFAULT aSelFil 	:= {}

cQryFil := " CT2_FILIAL " + GetRngFil( aSelFil ,"CT2", .T., @cTmpCT2Fil) 

cCustoI	:= CCUSTOINI
cCustoF := CCUSTOFIM
cContaI	:= CCONTAINI
cContaF := CCONTAFIM
cItemI	:= CITEMINI      
cItemF 	:= CITEMFIM
cNitI	:= CNITINI
cNitF 	:= CNITFIM

#IFDEF TOP
	If TcSrvType() != "AS/402"
		If !Empty(c2Moeda) 			
			cFilMoeda	:= " (CT2_MOEDLC = '" + cMoeda + "' OR "		
			cFilMoeda	+= " CT2_MOEDLC = '" + c2Moeda + "') " 			
		Else
			cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "				
		EndIf
	Else
#ENDIF 
	If !Empty(c2Moeda) 			
		cFilMoeda	:= " (CT2_MOEDLC = '" + cMoeda + "' .Or. "		
		cFilMoeda	+= " CT2_MOEDLC = '" + c2Moeda + "') " 			
	Else
		cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "				
	EndIf
#IFDEF TOP
	EndIf
#ENDIF 

oMeter:nTotal := CT1->(RecCount())

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m os d‚bitos ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cTipo <> "1"
	If cTipo = "2" .And. Empty(cCustoIni)
		CTT->(DbSeek(xFilial("CTT")))
		cCustoIni := CTT->CTT_CUSTO
	Endif
	If cTipo = "3" .And. Empty(cItemIni)
		CTD->(DbSeek(xFilial("CTD")))
		cItemIni := CTD->CTD_ITEM
	Endif
	If cTipo = "4" .And. Empty(cNitIni)
		CV0->(DbSeek(xFilial("CV0")+"01"))
		cClVlIni := CV0->CV0_CODIGO
	Endif
Endif

#IFDEF TOP
	If TcSrvType() != "AS/402"

		If cTipo == "1"
			dbSelectArea("CT2")
			dbSetOrder(2)
			cValid	:= 	"CT2_DEBITO>='" + cContaIni + "' AND " +;
						"CT2_DEBITO<='" + cContaFim + "'"
			cVldEnt := 	"CT2_CCD>='" + cCustoIni + "' AND " +;
						"CT2_CCD<='" + cCustoFim + "' AND " +;
						"CT2_ITEMD>='" + cItemIni + "' AND " +;
						"CT2_ITEMD<='" + cItemFim + "' AND " +;
						"CT2_EC05DB>='" + cNitIni + "' AND " +;
						"CT2_EC05DB<='" + cNitFim + "'"						
			If lAnalit			
				cOrderBy:= " CT2_FILIAL, CT2_DEBITO, CT2_EC05DB, CT2_DATA "
			Else
				cOrderBy:= " CT2_FILIAL, CT2_DEBITO, CT2_EC05DB, CT2_DATA "			
			EndIf	
		ElseIf cTipo == "2"
			dbSelectArea("CT2")
			dbSetOrder(4)
			cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCD <= '" + cCustoFim + "'"
			cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
						"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
						"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMD <= '" + cItemFim + "'  AND  " +;
						"CT2_EC05DB >= '" + cNitIni + "'  AND  " +;
						"CT2_EC05DB <= '" + cNitFim + "'" 
			cOrderBy:= " CT2_FILIAL, CT2_CCD, CT2_DATA "						
		ElseIf cTipo == "3"
			dbSelectArea("CT2")
			dbSetOrder(6)
			cValid 	:= 	"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMD <= '" + cItemFim + "'"
			cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
						"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
						"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCD <= '" + cCustoFim + "'  AND  " +;
						"CT2_EC05DB >= '" + cNitIni + "'  AND  " +;
						"CT2_EC05DB <= '" + cNitFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_ITEMD, CT2_DATA "												
		ElseIf cTipo == "4"
			dbSelectArea("CT2")
			dbSetOrder(8)
			cValid 	:= 	"CT2_EC05DB >= '" + cNitIni + "'  AND  " +;
						"CT2_EC05DB <= '" + cNitFim + "'"
			cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
						"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
						"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCD <= '" + cCustoFim + "'  AND  " +;
						"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMD <= '" + cItemFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_EC05DB, CT2_DATA "												
		EndIf                                           

		cAliasCT2	:= "cAliasCT2"
		
		cQuery	:= " SELECT * "
		cQuery	+= " FROM " + RetSqlName("CT2")  
		cQuery	+= " WHERE " + cQryFil + " AND "
		cQuery	+= cValid + " AND "
		cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
		cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
		cQuery	+= cVldEnt+ " AND " 
		cQuery	+= cFilMoeda + " AND " 
		cQuery	+= " CT2_TPSALD = '"+ cSaldo + "'"
		cQuery	+= " AND (CT2_DC = '1' OR CT2_DC = '3')"
		cQuery   += " AND CT2_VALOR <> 0 "
		cQuery	+= " AND D_E_L_E_T_ = ' ' " 
		cQuery	+= " ORDER BY "+ cOrderBy
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
		aStru := CT2->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next ni		

		If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
			If !Empty(cVldEnt)
				cVldEnt  += " AND "			/// SE JÁ TIVER CONTEUDO, ADICIONA "AND"				
				cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
			EndIf		
		EndIf	
		                                     
		If (!lUFilter) .or. Empty(cUFilter)
			cUFilter := ".T."
		EndIf			
		
		dbSelectArea(cAliasCT2)				
		While !Eof()
			If &cUFilter                                          
				U_xGrvRNIT(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo)
				dbSelectArea(cAliasCT2)
			EndIf
			dbSkip()
		EndDo			
		If ( Select ( "cAliasCT2" ) <> 0 )
			dbSelectArea ( "cAliasCT2" )
			dbCloseArea ()
		Endif
		
    Else    
#ENDIF    
	If cTipo == "1"
		dbSelectArea("CT2")                              
		dbSetOrder(2)
		cValid	:= 	"CT2_DEBITO>='" + cContaIni + "' .And. " +;
					"CT2_DEBITO<='" + cContaFim + "'"
		cVldEnt := 	"CT2_CCD>='" + cCustoIni + "' .And. " +;
					"CT2_CCD<='" + cCustoFim + "' .And. " +;
					"CT2_ITEMD>='" + cItemIni + "' .And. " +;
					"CT2_ITEMD<='" + cItemFim + "' .And. " +;
					"CT2_EC05DB>='" + cNitIni + "' .And. " +;
					"CT2_EC05DB<='" + cNitFim + "'"
		bCond 	:= { ||CT2->CT2_DEBITO >= cContaIni .And. CT2->CT2_DEBITO <= cContaFim}
	ElseIf cTipo == "2"
		dbSelectArea("CT2")
		dbSetOrder(4)
		cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'"
		cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'  .And.  " +;
					"CT2_EC05DB >= '" + cNitIni + "'  .And.  " +;
					"CT2_EC05DB <= '" + cNitFim + "'"
	ElseIf cTipo == "3"
		dbSelectArea("CT2")
		dbSetOrder(6)
		cValid 	:= 	"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'"
		cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
					"CT2_EC05DB >= '" + cNitIni + "'  .And.  " +;
					"CT2_EC05DB <= '" + cNitFim + "'"
	ElseIf cTipo == "4"
		dbSelectArea("CT2")
		dbSetOrder(8)
		cValid 	:= 	"CT2_EC05DB >= '" + cNitIni + "'  .And.  " +;
					"CT2_EC05DB <= '" + cNitFim + "'"
		cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
					"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'"
	EndIf
		
	If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
		If !Empty(cVldEnt)
			cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."		
		EndIf
	Endif
	
	cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
		
	If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO

		dbSelectArea("CT2")
		dbSetOrder(2)
		
		dbSelectArea("CT1")
		dbSetOrder(3)
		cFilCT1 := xFilial("CT1")
		cFilCT2	:= xFilial("CT2")
		cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica
		
		While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
			dbSelectArea("CT2")
			MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
			While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DEBITO == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim
		        
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
		
				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(U_xGrvRNIT(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo
			CT1->(dbSkip())
		EndDo
	Else
		dbSelectArea("CT2")

		cTabCad := "CTT"
		cEntIni	:= cCustoIni
		bCond 	:= { || CT2->CT2_CCD == CTT->CTT_CUSTO}
		bCondCad:= { || .T.}
		dbSetOrder(4)

		If cTipo == "3"
			cTabCad := "CTD"
			cEntIni := cItemIni
			bCond 	:= { || CT2->CT2_ITEMD == CTD->CTD_ITEM}			
			dbSetOrder(6)
		ElseIf cTipo == "4"
			cTabCad := "CV0"
			cEntIni := cNitIni
			bCond 	:= { || CT2->CT2_EC05DB == CV0->CV0_CODIGO}
			dbSetOrder(8)
		EndIf
		
		dbSelectArea(cTabCad)
		dbSetOrder(2)
		cFilEnt := xFilial(cTabCad)
		cFilCT2	:= xFilial("CT2")
		cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica
		
		If cTipo == "2"
			bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
		ElseIf cTipo == "3"
   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
  		ElseIf cTipo == "4"
			bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CV0->CV0_CODIGO <= cNitFim }  		
  		EndIf
		
		While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES
	
			dbSelectArea("CT2")    			
			If cTipo == "2"
				MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
			ElseIf cTipo == "3"
				MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)			
			Else
				MsSeek(cFilCT2+CV0->CV0_CODIGO+DTOS(dDataIni),.T.)						
			EndIf

			dbSelectArea("CT2")									/// WHILE CT2 - DEBITOS
			While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim
		
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf

				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(U_xGrvRNIT(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo	
			(cTabCad)->(dbSkip())
		EndDo
	Endif
		
#IFDEF TOP
	EndIf
#ENDIF


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m os creditos³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"
	dbSelectArea("CT2")
	dbSetOrder(3)
ElseIf cTipo == "2"
	dbSelectArea("CT2")
	dbSetOrder(5)
ElseIf cTipo == "3"
	dbSelectArea("CT2")
	dbSetOrder(7)
ElseIf cTipo == "4"		
	dbSelectArea("CT2")
	dbSetOrder(9)
EndIf

#IFDEF TOP
	If TcSrvType() != "AS/402"                          
		If cTipo == "1"
			cValid	:= 	"CT2_CREDIT>='" + cContaIni + "' AND " +;
						"CT2_CREDIT<='" + cContaFim + "'"
			cVldEnt :=	"CT2_CCC>='" + cCustoIni + "' AND " +;
						"CT2_CCC<='" + cCustoFim + "' AND " +;
						"CT2_ITEMC>='" + cItemIni + "' AND " +;
						"CT2_ITEMC<='" + cItemFim + "' AND " +;
						"CT2_EC05CR>='" + cNitIni + "' AND " +;
						"CT2_EC05CR<='" + cNitFim + "'"
			If lAnalit
				cOrderBy:= " CT2_FILIAL, CT2_CREDIT, CT2_EC05CR, CT2_DATA "																	
			Else
			    cOrderBy:= " CT2_FILIAL, CT2_CREDIT, CT2_DATA "																	
			EndIf	
		ElseIf cTipo == "2"
			cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'"
			cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
						"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
						"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMC <= '" + cItemFim + "'  AND  " +;
						"CT2_EC05CR >= '" + cNitIni + "'  AND  " +;
						"CT2_EC05CR <= '" + cNitFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_CCC, CT2_DATA "																	
		ElseIf cTipo == "3"
			cValid 	:= 	"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMC <= '" + cItemFim + "'"
			cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
						"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
						"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'  AND  " +;
						"CT2_EC05CR >= '" + cNitIni + "'  AND  " +;
						"CT2_EC05CR <= '" + cNitFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_ITEMC, CT2_DATA "																	
		ElseIf cTipo == "4"		
			cValid 	:= 	"CT2_EC05CR >= '" + cNitIni + "'  AND  " +;
						"CT2_EC05CR <= '" + cNitFim + "'"
			cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
						"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
						"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'  AND  " +;
						"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMC <= '" + cItemFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_EC05CR, CT2_DATA "																						
		EndIf	                    
		
		cAliasCT2	:= "cAliasCT2"		
		
		cQuery	:= " SELECT * "
		cQuery	+= " FROM " + RetSqlName("CT2")  
		cQuery	+= " WHERE " + cQryFil + " AND "
		cQuery	+= cValid + " AND "
		cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
		cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
		cQuery	+= cVldEnt+ " AND " 
		cQuery	+= cFilMoeda + " AND " 
		cQuery	+= " CT2_TPSALD = '"+ cSaldo + "' AND "  
		cQuery	+= " (CT2_DC = '2' OR CT2_DC = '3') AND "
		cQuery	+= " CT2_VALOR <> 0 AND "
		cQuery	+= " D_E_L_E_T_ = ' ' " 
		cQuery	+= " ORDER BY "+ cOrderBy
		cQuery := ChangeQuery(cQuery)
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
		
		aStru := CT2->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next ni		
		

		If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
			If !Empty(cVldEnt)
				cVldEnt  += " AND "			/// SE JÁ TIVER CONTEUDO, ADICIONA "AND"				
				cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
			EndIf		
		EndIf	
		
		If (!lUFilter) .or. Empty(cUFilter)
			cUFilter := ".T."
		EndIf			
		
		dbSelectArea(cAliasCT2)				
		While !Eof()
			If &cUFilter
				U_xGrvRNIT(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo)
				dbSelectArea(cAliasCT2)
		    EndIf
			dbSkip()
		EndDo
		
		If ( Select ( "cAliasCT2" ) <> 0 )
			dbSelectArea ( "cAliasCT2" )
			dbCloseArea ()
		Endif

	Else
#ENDIF
	bCond	:= {||.T.}

	If cTipo == "1"
		cValid	:= 	"CT2_CREDIT>='" + cContaIni + "'.And." +;
					"CT2_CREDIT<='" + cContaFim + "'"
		cVldEnt :=	"CT2_CCC>='" + cCustoIni + "'.And." +;
					"CT2_CCC<='" + cCustoFim + "'.And." +;
					"CT2_ITEMC>='" + cItemIni + "'.And." +;
					"CT2_ITEMC<='" + cItemFim + "'.And." +;
					"CT2_EC05CR>='" + cNitIni + "'.And." +;
					"CT2_EC05CR<='" + cNitFim + "'"
		bCond 	:= { ||CT2->CT2_CREDIT >= cContaIni .And. CT2->CT2_CREDIT <= cContaFim}
	ElseIf cTipo == "2"
		cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "'"
		cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "' .And. " +;
					"CT2_EC05CR >= '" + cNitIni + "' .And. " +;
					"CT2_EC05CR <= '" + cNitFim + "'"
	ElseIf cTipo == "3"
		cValid 	:= 	"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "'"
		cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "' .And. " +;
					"CT2_EC05CR >= '" + cNitIni + "' .And. " +;
					"CT2_EC05CR <= '" + cNitFim + "'"
	ElseIf cTipo == "4"		
		cValid 	:= 	"CT2_EC05CR >= '" + cNitIni + "' .And. " +;
					"CT2_EC05CR <= '" + cNitFim + "'"
		cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "' .And. " +;
					"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "'"
	EndIf	
	
	If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
		If !Empty(cVldEnt)
			cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."		
		EndIf
	Endif
	
	cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
	
	If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO
		dbSelectArea("CT2")
		dbSetOrder(3)
		
		dbSelectArea("CT1")
		dbSetOrder(3)
		cFilCT1 := xFilial("CT1")
		cFilCT2	:= xFilial("CT2")
		cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica
		
		While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
			dbSelectArea("CT2")
			MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
			While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_CREDIT == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim

				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
	
				If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					If Empty(c2Moeda)			
						If CT2->CT2_MOEDLC <> cMoeda
							dbSkip()
							Loop
						EndIF
					Else
						If !(&(cFilMoeda))
							dbSkip()
							Loop
						EndIf			
					EndIf			
					CT2->(U_xGrvRNIT(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo			
			CT1->(dbSkip())
		EndDo
	Else
		dbSelectArea("CT2")

		cTabCad := "CTT"
		cEntIni	:= cCustoIni
		bCond 	:= { || CT2->CT2_CCC == CTT->CTT_CUSTO}
		bCondCad:= { || .T.}
		dbSetOrder(5)

		If cTipo == "3"
			cTabCad := "CTD"
			cEntIni := cItemIni
			bCond 	:= { || CT2->CT2_ITEMC == CTD->CTD_ITEM}			
			dbSetOrder(7)
		ElseIf cTipo == "4"
			cTabCad := "CTH"
			cEntIni := cNitIni
			bCond 	:= { || CT2->CT2_EC05CR == CV0->CV0_CODIGO}					
			dbSetOrder(9)
		EndIf
		
		dbSelectArea(cTabCad)
		dbSetOrder(2)
		cFilEnt := xFilial(cTabCad)
		cFilCT2	:= xFilial("CT2")
		cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica
		
		If cTipo == "2"
			bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
		ElseIf cTipo == "3"
   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
  		ElseIf cTipo == "4"
			bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CV0->CV0_CODIGO <= cNitFim }  		
  		EndIf
		
		While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES
	
			dbSelectArea("CT2")    	
			If cTipo == "2"
				MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
			ElseIf cTipo == "3"
				MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)			
			Else
				MsSeek(cFilCT2+CV0->CV0_CODIGO+DTOS(dDataIni),.T.)						
			EndIf

			dbSelectArea("CT2")									/// WHILE CT2 - CREDITO
			While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim

				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
		
				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(U_xGrvRNIT(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo	
			(cTabCad)->(dbSkip())
		EndDo
	EndIf

#IFDEF TOP
	EndIf
#ENDIF

If lNoMov .or. lSldAnt
	//If cTipo == "1"
	If cTipo == "4"
		dbSelectArea("CT1")
		dbSetOrder(3)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CT1_FILIAL == '" + xFilial("CT1") + "' .And. CT1_CONTA >= '"+cContaI+ "' .And. CT1_CONTA <= '" +;
						cContaF + "' .And. CT1_CLASSE = '2'","Selecionando Registros...")
		cCpoChave := "CT1_CONTA"
		cTmpChave := "CONTA"
	ElseIf cTipo == "2"
		dbSelectArea("CTT")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTT_FILIAL == '" + xFilial("CTT") + "' .And. CTT_CUSTO >= '"+cCustoI+"' .And. CTT_CUSTO <= '" +;
						cCUSTOF + "' .And. CTT_CLASSE == '2'","Selecionando Registros...")
		cCpoChave := "CTT_CUSTO"
		cTmpChave := "CCUSTO"
	ElseIf ctipo == "3"
		dbSelectArea("CTD")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTD_FILIAL == '" + xFilial("CTD") + "' .And. CTD_ITEM >= '"+cItemI+"' .And. CTD_ITEM <= '" +;
						cITEMF + "' .And. CTD_CLASSE == '2'","Selecionando Registros...")
		cCpoChave := "CTD_ITEM"
		cTmpChave := "ITEM"
	//ElseIf ctipo == "4"
	ElseIf ctipo == "X"
		/*dbSelectArea("CV0")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CV0_FILIAL == '" + xFilial("CV0") + "' .and. CV0_PLANO='01' .And. CV0_CODIGO >= '"+cNitI+"' .And. CV0_CODIGO <= '" +;
						cNitF + "' .And. CV0_CLASSE == '2'","Selecionando Registros...")
		cCpoChave := "CV0_CODIGO"*/
		If Empty(cNitI)
			cNitI := "1"
		EndIf
		
		dbSelectArea("CVX")
		dbSetOrder(3)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CVX_FILIAL == '" + xFilial("CVX") +;
						"' .and. CVX_CONFIG='05' .And. CVX_NIV05 >= '"+cNitI+"' .And. CVX_NIV05 <= '" +;
						cNitF + "' .And. CVX_NIV01 >= '" + cContaI + "' .and. CVX_NIV01 <= '" +;
						cContaF + "' .And. CVX_DATA >= '" + DtoC(dDataIni) + "' .And. CVX_DATA <= '" +;
						DtoC(dDataFim) + "'","Selecionando Registros...")
		cCpoChave := "CVX_NIV05"
		cClave2	  := "CVX_NIV01"
		cTmpChave := "NIT"
		
	EndIf

	cAlias := "TEM"//Alias()

	While !(cAlias)->(Eof())
		dbSelectArea("cArqTmp")
		cKey2Seek	:= &(cAlias + "->" + cCpoChave)
		If !DbSeek(cKey2Seek)
			
			If lNoMov		
				//U_XCtbGrv(cKey2Seek,dDataIni,cTmpChave)
				//U_XCtbGrv(cKey2Seek,dDataIni,cTmpChave,/*cMoeda*/,/*cSaldo*/,/*aSelFil*/,cTipo,/*lAnalit*/,cNitIni,cNitFim,/*&(cAlias + "->" + cClave2)*/)
				U_XCtbGrv(cKey2Seek,dDataIni,"CONTA",cMoeda,cSaldo,aSelFil,cTipo,lAnalit,cNitIni,cNitFim)	
			//--29/03--ElseIf cTipo == "1"		/// SOMENTE PARA O RAZAO POR CONTA
				/// TRATA OS DADOS PARA A PERGUNTA "IMPRIME CONTA SEM MOVIMENTO" = "NAO C/ SLD.ANT."

				//--29/03--If SaldoCT7Fil(cKey2Seek,dDataIni,cMoeda,cSaldo,'CTBR402')[6] <> 0 .and. cArqTMP->CONTA <> cKey2Seek
					/// SE TIVER SALDO ANTERIOR E NÃO TIVER MOVIMENTO GRAVADO
				 	//U_XCtbGrv(cKey2Seek,dDataIni,cTmpChave) 
				 	//--29/03--U_XCtbGrv(cKey2Seek,dDataIni,cTmpChave,/*cMoeda*/,/*cSaldo*/,/*aSelFil*/,/*cTipo*/,/*lAnalit*/,cNitIni,cNitFim)
		  		//--29/03--EndIf					
			EndIf
		Endif
		DbSelectArea(cAlias)
		
		(cAlias)->(DbSkip())
	EndDo

	DbSelectArea(cAlias)
	DbClearFil()
	RetIndex(cAlias)
Endif

CtbTmpErase(cTmpCT2Fil)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvRNIT ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario - Razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvRNIT(lJunta,cMoeda,cSaldo,cTipo)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpL1 = Se Junta CC ou nao                                 ³±±
±±³           ³ ExpC1 = Moeda                                              ³±±
±±³           ³ ExpC2 = Tipo de saldo                                      ³±±
±±            ³ ExpC3 = Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cAliasQry = Alias com o conteudo selecionado do CT2        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xGrvRNIT(lJunta,cMoeda,cSaldo,cTipo,c2Moeda,cAliasCT2,nTipo)

Local cConta
Local cContra
Local cCusto
Local cItem
Local cNit
Local cChave   	:= ""
Local lImpCPartida := GetNewPar("MV_IMPCPAR",.T.) // Se .T.,     IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
                                                  // se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.
DEFAULT cAliasCT2	:= "CT2"

If !Empty(c2Moeda) 

	If lAnalit
		If cTipo == "1"
			cChave	:=	(cAliasCT2)->(CT2_DEBITO+CT2_EC05DB+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
		Else
	    	cChave	:=	(cAliasCT2)->(CT2_CREDIT+CT2_EC05CR+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
	 	EndIf          
	 Else
		If cTipo == "1"
			cChave	:=	(cAliasCT2)->(CT2_DEBITO+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
		Else
	    	cChave	:=	(cAliasCT2)->(CT2_CREDIT+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
	 	EndIf          	 
	 EndIf	
EndIf


If cTipo == "1"
	cConta 	:= (cAliasCT2)->CT2_DEBITO
	cContra	:= (cAliasCT2)->CT2_CREDIT
	cCusto	:= (cAliasCT2)->CT2_CCD
	cItem	:= (cAliasCT2)->CT2_ITEMD
	cNit	:= (cAliasCT2)->CT2_EC05DB
EndIf	
If cTipo == "2"
	cConta 	:= (cAliasCT2)->CT2_CREDIT
	cContra := (cAliasCT2)->CT2_DEBITO
	cCusto	:= (cAliasCT2)->CT2_CCC
	cItem	:= (cAliasCT2)->CT2_ITEMC
	cNit	:= (cAliasCT2)->CT2_EC05CR
EndIf		           

dbSelectArea("cArqTmp")
dbSetOrder(1)	
If !Empty(c2Moeda) 
	If MsSeek(cChave,.F.)
		Reclock("cArqTmp",.F.)
	Else
		RecLock("cArqTmp",.T.)		
	EndIf
Else
	RecLock("cArqTmp",.T.)
EndIf

Replace DATAL		With (cAliasCT2)->CT2_DATA
Replace TIPO		With cTipo
Replace LOTE		With (cAliasCT2)->CT2_LOTE
Replace SUBLOTE		With (cAliasCT2)->CT2_SBLOTE
Replace DOC			With (cAliasCT2)->CT2_DOC
Replace LINHA		With (cAliasCT2)->CT2_LINHA
Replace CONTA		With cConta

If lImpCPartida
	Replace XPARTIDA	With cContra
EndIf

Replace CCUSTO		With cCusto
Replace ITEM		With cItem
Replace NIT			With cNit
Replace HISTORICO	With (cAliasCT2)->CT2_HIST
Replace EMPORI		With (cAliasCT2)->CT2_EMPORI
Replace FILORI		With (cAliasCT2)->CT2_FILORI
Replace SEQHIST		With (cAliasCT2)->CT2_SEQHIST
Replace SEQLAN		With (cAliasCT2)->CT2_SEQLAN
Replace NOMOV		With .F.							// Conta com movimento 
Replace SEGOFI		With (cAliasCT2)->CT2_SEGOFI		// Conta com movimento 


If cPaisLoc $ "CHI|ARG"
	Replace SEGOFI With (cAliasCT2)->CT2_SEGOFI// Correlativo para Chile
EndIf

If Empty(c2Moeda)	//Se nao for Razao em 2 Moedas
	If cTipo == "1"
		Replace LANCDEB	With LANCDEB + (cAliasCT2)->CT2_VALOR
	EndIf	
	If cTipo == "2"
		Replace LANCCRD	With LANCCRD + (cAliasCT2)->CT2_VALOR
	EndIf	    
	If (cAliasCT2)->CT2_DC == "3"
		Replace TIPO	With cTipo
	Else
		Replace TIPO 	With (cAliasCT2)->CT2_DC
	EndIf		
Else	//Se for Razao em 2 Moedas
	If (nTipo = 1 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = cMoeda //Se Imprime Valor na Moeda ou ambos
		If cTipo == "1"
			Replace LANCDEB With (cAliasCT2)->CT2_VALOR	
		Else			
			Replace LANCCRD With (cAliasCT2)->CT2_VALOR	
		EndIf
	EndIf
    If (nTipo = 2 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = c2Moeda	//Se Imprime Moeda Corrente ou Ambas
		If cTipo == "1"
			Replace LANCDEB_1	With (cAliasCT2)->CT2_VALOR
		Else
			Replace LANCCRD_1	With (cAliasCT2)->CT2_VALOR
		Endif
	EndIf
	If LANCDEB_1 <> 0 .And. LANCDEB <> 0 
		Replace TXDEBITO  	With LANCDEB_1 / LANCDEB		
	Endif                                               
	If LANCCRD_1 <> 0 .And. LANCCRD <> 0
		Replace TXCREDITO 	With LANCCRD_1 / LANCCRD
	EndIf	
	If (cAliasCT2)->CT2_DC == "3"
		Replace TIPO	With cTipo
	Else
		Replace TIPO 	With (cAliasCT2)->CT2_DC
	EndIf			
EndIf

If nTipo = 1 .And. (LANCDEB + LANCCRD) = 0
	DbDelete()
ElseIf nTipo = 2 .And. (LANCDEB_1 + LANCCRD_1) = 0
	DbDelete()
Endif
If ! Empty(c2Moeda) .And. LANCDEB + LANCDEB_1 + LANCCRD + LANCCRD_1 = 0
	DbDelete()
Endif
MsUnlock()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvNNIT ³ Autor ³ Pilar S. Albaladejo ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario sem movimento.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvNNIT(cConta)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ cConteudo = Conteudo a ser gravado no campo chave de acordo³±±
±±³           ³             com o razao impresso                           ³±±
±±³           ³ dDataL = Data para verificacao do movimento da conta       ³±±
±±³           ³ cCpoChave = Nome do campo para gravacao no temporario      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XCtbGrv(cConteudo,dDataL,cCpoTmp,cMoeda,cSaldo,aSelFil,cTipo,lAnalit,cNitIni,cNitFim,_cCuenta)

Local cQuery             
Local cCVXTmpFil                             
Local cQryFil 
DEFAULT aSelFil	 := {}                                                  
DEFAULT cTipo    := "4" 
DEFAULT lAnalit  := .T.   
DEFAULT _cCuenta := ""  
          
cQryFil := GetRngFil( aSelFil, "CVX", .T., @cCVXTmpFil)     
     
If lAnalit .and. cTipo= "4"  
	
	//Busca os NITs Por conta para atualizar o saldo anterior
	cQuery := " SELECT DISTINCT CVX_NIV05"
	cQuery += " FROM " + RetSqlName("CVX")
	cQuery += " WHERE CVX_FILIAL " + cQryFil
	cQuery += " AND CVX_NIV01 = '"+cConteudo+"' "
	cQuery += " AND CVX_MOEDA = '"+cMoeda+"' "  
	cQuery += " AND CVX_NIV05 >= '"+cNitIni+"' "
	cQuery += " AND CVX_NIV05 <= '"+cNitFim+"' "
	cQuery += " AND CVX_TPSALD IN ('"+cSaldo+"') "
	cQuery += " AND CVX_DATA < '"+DTOS(dDataL)+"' "
	If lCtbIsCube .And. CtbIsCube()
		cQuery += " 	AND CVX_CONFIG = '05' "
	Else
		cQuery += " 	AND CVX_CONFIG = '01' "
	EndIf
	
	cQuery += "	 AND D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery(cQuery)
	                    
	If Select("cArqENT") > 0
		dbSelectArea("cArqENT")
		cArqENT->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqENT",.T.,.F.)
	       
	
	While !cArqENT->(Eof()) // Atualiza 
	
		dbSelectArea("cArqTmp")
		dbSetOrder(1)	
		
		If !("cArqTmp")->(MsSeek(cConteudo+cArqENT->CVX_NIV05))
		
			RecLock("cArqTmp",.T.)
			Replace &(cCpoTmp)	With cConteudo
			If cCpoTmp = "CONTA"
				Replace HISTORICO		With "CUENTA + NIT SIN MOVIMIENTO EN EL PERIODO"		//"CONTA SEM MOVIMENTO NO PERIODO"
			ElseIf cCpoTmp = "CCUSTO"
				Replace HISTORICO		With Upper(AllTrim(CtbSayApro("CTT"))) + " "  + "SIN MOVIMIENTO EN EL PERIODO"	//"SEM MOVIMENTO NO PERIODO"
			ElseIf cCpoTmp = "ITEM"
				Replace HISTORICO		With Upper(AllTrim(CtbSayApro("CTD"))) + " "  + "SIN MOVIMIENTO EN EL PERIODO"	//"SEM MOVIMENTO NO PERIODO"
			ElseIf cCpoTmp = "NIT"
				Replace HISTORICO		With Upper(AllTrim("NIT")) + Alltrim(cArqENT->CVX_NIV05) + "SIN MOVIMIENTO EN EL PERIODO"	//"SEM MOVIMENTO NO PERIODO"
			Endif
			Replace DATAL 			WITH dDataL 
			// Grava filial do sistema para uso no relatorio
			Replace FILORI			With cFilAnt		
			Replace NIT 			With Alltrim(cArqENT->CVX_NIV05)  
			
			MsUnlock()
		
		EndIf
		
		dbSelectArea("cArqENT")
		DbSkip()	
	EndDo
Else

	dbSelectArea("cArqTmp")
	dbSetOrder(1)	
		
	RecLock("cArqTmp",.T.)
	Replace &(cCpoTmp)	With cConteudo
	If cCpoTmp = "CONTA"
		Replace HISTORICO		With "CUENTA+NIT SIN MOVIMIENTO EN EL PERIODO"		//"CONTA SEM MOVIMENTO NO PERIODO"
	ElseIf cCpoTmp = "CCUSTO"
		Replace HISTORICO		With Upper(AllTrim(CtbSayApro("CTT"))) + " "  + "SIN MOVIMIENTO EN EL PERIODO"	//"SEM MOVIMENTO NO PERIODO"
	ElseIf cCpoTmp = "ITEM"
		Replace HISTORICO		With Upper(AllTrim(CtbSayApro("CTD"))) + " "  + "SIN MOVIMIENTO EN EL PERIODO"	//"SEM MOVIMENTO NO PERIODO"
	ElseIf cCpoTmp = "NIT"
		Replace HISTORICO		With IIF(!Empty(cConteudo),"NIT " + Alltrim(cConteudo) + " SIN MOVIMIENTO EN EL PERIODO","CUENTA SIN NIT Y SIN MOVIMIENTO EN EL PERIODO") 
	Endif
	
	If !Empty(_cCuenta)
		Replace CONTA WITH _cCuenta
	EndIf
	
	Replace DATAL 			WITH dDataL 
	// Grava filial do sistema para uso no relatorio
	Replace FILORI		With cFilAnt
	Replace NIT 		With cConteudo//cArqCT2->NIT
	
	MsUnlock()

EndIf	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³Ctr402Sint³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Imprime conta sintetica da conta do razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³Ctr402Sint( cConta,cDescSint,cMoeda,cDescConta,cCodRes	   ³±±
±±³		      |		   	 , cMoedaDesc)									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Conta Sintetic		                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpC1 = Conta                                              ³±±
±±³           ³ ExpC2 = Descricao da Conta Sintetica                       ³±±
±±³           ³ ExpC3 = Moeda                                              ³±±
±±³           ³ ExpC4 = Descricao da Conta                                 ³±±
±±³           ³ ExpC5 = Codigo reduzido                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xCtr402Si(cConta,cDescSint,cMoeda,cDescConta,cCodRes,cMoedaDesc)

Local aSaveArea := GetArea()

Local nPosCT1					//Guarda a posicao no CT1
Local cContaPai	:= ""
Local cContaSint	:= ""

// seta o default da descrição da moeda para a moeda corrente
Default cMoedaDesc := cMoeda

dbSelectArea("CT1")
dbSetOrder(1)
If dbSeek(xFilial("CT1")+cConta)
	nPosCT1 	:= Recno()
	cDescConta  := &("CT1->CT1_DESC" + cMoedaDesc )

	If Empty( cDescConta )
		cDescConta  := CT1->CT1_DESC01
	Endif

	cCodRes		:= CT1->CT1_RES
	cContaPai	:= CT1->CT1_CTASUP

	If dbSeek(xFilial("CT1")+cContaPai)
		cContaSint 	:= CT1->CT1_CONTA
		cDescSint	:= &("CT1->CT1_DESC" + cMoedaDesc )

		If Empty(cDescSint)
			cDescSint := CT1->CT1_DESC01
		Endif
	EndIf	

	dbGoto(nPosCT1)
EndIf	

RestArea(aSaveArea)

Return cContaSint

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbQryRNIT ³ Autor ³ Simone Mie Sato       ³ Data ³ 22/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbQryRNIT(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,	   ³±±
±±³			  ³	cCustoIni,cCustoFim, cItemIni,cItemFim,cNitIni,cNitFim,  ³±±
±±³			  ³	cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,  ³±±
±±³			  ³	cTipo)                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xCtbQry(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				  cItemIni,cItemFim,cNitIni,cNitFim,cMoeda,dDataIni,dDataFim,;
				  aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt,aSelFil,lAnalit)

Local aSaveArea := GetArea()
Local nMeter	:= 0
Local cQuery	:= ""
Local aTamVlr	:= TAMSX3("CT2_VALOR")     
Local lNoMovim	:= .F.
Local cContaAnt	:= ""
Local cCampUSU	:= ""
local aStrSTRU	:= {}
Local nStr		:= 0
Local cQryFil	:= '' // variavel de condicional da query
Local lImpCPartida := GetNewPar( "MV_IMPCPAR" , .T.)	// Se .T.,     IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
Local cCVXTmpFil
														// se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.
Local cDtSldIni     := cValtochar(year(dDataIni))+"0101"														
Local cTmpCT2Fil
DEFAULT lSldAnt 	:= .T.//.F.
DEFAULT aSelFil 	:= {}
          
cQryFil2 := GetRngFil( aSelFil, "CVX", .T., @cCVXTmpFil)     


// trataviva para o filtro de multifiliais 
cQryFil := " CT2.CT2_FILIAL " + GetRngFil( aSelFil, "CT2", .T., @cTmpCT2Fil )

oMeter:SetTotal(CT2->(RecCount()))
oMeter:Set(0)

cQuery	:= " SELECT CT1_CONTA CONTA, ISNULL(CT2_CCD,'') CUSTO,ISNULL(CT2_ITEMD,'') ITEM, ISNULL(CT2_EC05DB,'') NIT, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "	
cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'') SUBLOTE, ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_CREDIT,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '1' TIPOLAN, "	

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY

////////////////////////////////////////////////////////////
cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI"       
If cPaisLoc $ "CHI|ARG|PER"
	cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI"
EndIf

cQuery += " FROM "+ RetSqlName("CT1") + " CT1 LEFT JOIN " + RetSqlName("CT2") + " CT2 "
cQuery += " ON " + cQryFil

cQuery	+= " AND CT2.CT2_DEBITO = CT1.CT1_CONTA"  
cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
cQuery	+= " AND CT2.CT2_CCD >= '" + cCustoIni + "' AND CT2.CT2_CCD <= '" + cCustoFim +"'"
cQuery  += " AND CT2.CT2_ITEMD >= '" + cItemIni + "' AND CT2.CT2_ITEMD <= '"+ cItemFim +"'"
cQuery  += " AND CT2.CT2_EC05DB >= '" + cNitIni + "' AND CT2.CT2_EC05DB <= '" + cNitFim +"'"
cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
cQuery  += " AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') "
cQuery  += " AND CT2_VALOR <> 0 "
cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "	
cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = '' "

cQuery	+= " UNION "

cQuery	+= " SELECT CT1_CONTA CONTA, ISNULL(CT2_CCC,'') CUSTO, ISNULL(CT2_ITEMC,'') ITEM, ISNULL(CT2_EC05CR,'') NIT, ISNULL(CT2_DATA,'') DDATA, ISNULL(CT2_TPSALD,'') TPSALD, "	
cQuery	+= " ISNULL(CT2_DC,'') DC, ISNULL(CT2_LOTE,'') LOTE, ISNULL(CT2_SBLOTE,'')SUBLOTE, ISNULL(CT2_DOC,'') DOC, ISNULL(CT2_LINHA,'') LINHA, ISNULL(CT2_DEBITO,'') XPARTIDA, ISNULL(CT2_HIST,'') HIST, ISNULL(CT2_SEQHIS,'') SEQHIS, ISNULL(CT2_SEQLAN,'') SEQLAN, '2' TIPOLAN, "	

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := CT2->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif

cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY

cQuery  += " ISNULL(CT2_VALOR,0) VALOR, ISNULL(CT2_EMPORI,'') EMPORI, ISNULL(CT2_FILORI,'') FILORI "              
If cPaisLoc $ "CHI|ARG|PER"
	cQuery	+= ", ISNULL(CT2_SEGOFI,'') SEGOFI"
EndIf

cQuery += " FROM "+RetSqlName("CT1")+ ' CT1 LEFT JOIN '+ RetSqlName("CT2") + ' CT2 '
cQuery += " ON " + cQryFil

cQuery	+= " AND CT2.CT2_CREDIT =  CT1.CT1_CONTA "
cQuery  += " AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+ "' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
cQuery	+= " AND CT2.CT2_CCC >= '" + cCustoIni + "' AND CT2.CT2_CCC <= '" + cCustoFim +"'"
cQuery  += " AND CT2.CT2_ITEMC >= '" + cItemIni + "' AND CT2.CT2_ITEMC <= '"+ cItemFim +"'"
cQuery  += " AND CT2.CT2_EC05CR >= '" + cNitIni + "' AND CT2.CT2_EC05CR <= '" + cNitFim +"'"
cQuery  += " AND CT2.CT2_TPSALD = '"+ cSaldo + "'"
cQuery	+= " AND CT2.CT2_MOEDLC = '" + cMoeda +"'"
cQuery  += " AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') "
cQuery  += " AND CT2_VALOR <> 0 "
cQuery	+= " AND CT2.D_E_L_E_T_ = ' ' "	
cQuery	+= " WHERE CT1.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery	+= " AND CT1.CT1_CLASSE = '2' "
cQuery	+= " AND CT1.CT1_CONTA >= '"+ cContaIni+"' AND CT1.CT1_CONTA <= '"+cContaFim+"'"
cQuery	+= " AND CT1.D_E_L_E_T_ = ' ' "	            


If lAnalit .And. cTipo ="4" .And. lSldAnt //29/03
	            
	cQuery	+= " UNION "
	cQuery	+= " SELECT DISTINCT CONTA, CUSTO, ITEMC, NIT, DDATA, TPSALD, DC, LOTE, SUBLOTE, DOC, LINHA, XPARTIDA, HIST, SEQHIS, SEQLAN, TIPOLAN, VALOR, EMPORI, FILORI " 
	cQuery	+= "  FROM ( "
	cQuery	+= " 	SELECT DISTINCT CVX_NIV01 CONTA, ' ' CUSTO, ' 'ITEMC, CVX_NIV05 NIT, ' ' DDATA, ' ' TPSALD, ' ' DC, ' ' LOTE,"
	cQuery	+= " 		   ' 'SUBLOTE, ' ' DOC, ' ' LINHA, ' ' XPARTIDA, ' ' HIST, ' ' SEQHIS, ' ' SEQLAN,' ' TIPOLAN, 0 VALOR,"
	cQuery	+= " 		   ' ' EMPORI,' ' FILORI"
	cQuery	+= "	 FROM "+ RetSqlName("CVX") 
	cQuery	+= " 	WHERE  CVX_FILIAL "+cQryFil2
	cQuery	+= " 	AND CVX_NIV01 >= '"+cContaIni+"'" 
	cQuery	+= " 	AND CVX_NIV01 <= '"+cContaFim+"'" 
	cQuery	+= " 	AND CVX_NIV05 >= '"+cNitIni+"'" 
	cQuery	+= " 	AND CVX_NIV05 <= '"+cNitFim+"'" 	
	cQuery	+= " 	AND CVX_MOEDA = '"+cMoeda+"' "
	cQuery	+= " 	AND CVX_TPSALD IN ('"+cSaldo+"') "
	cQuery	+= " 	AND CVX_DATA < '"+DTOS(dDataIni)+"'"
	//29/03--cQuery	+= " 	AND ((CVX_DATA >= '"+cDtSldIni+"' AND  SUBSTRING(CVX_NIV01,1,1)>='4' ) OR (SUBSTRING(CVX_NIV01,1,1)<'4') )   "    
	

	
	If lCtbIsCube .And. CtbIsCube()
		cQuery += " 			AND CVX_CONFIG = '05' "
	Else
		cQuery += " 			AND CVX_CONFIG = '01' "
	EndIf
	cQuery	+= " 	AND CVX_SLDCRD > 0 "
	cQuery	+= " 	AND D_E_L_E_T_ = ' ' "
	cQuery	+= " 	AND CVX_NIV01+CVX_NIV05 NOT IN (SELECT DISTINCT (CT2_CREDIT+CT2_EC05CR) CONTA  "
	cQuery	+= " 							FROM  "+ RetSqlName("CT2")+" CT2 " 
	cQuery	+= " 							WHERE  "+cQryFil
	cQuery	+= " 							 AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+"' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
	cQuery	+= " 							 AND CT2.CT2_EC05CR >= '"+cNitIni+"' AND CT2.CT2_EC05CR <= '"+cNitFim+"'" 
	cQuery	+= " 							 AND CT2.CT2_TPSALD = '"+cSaldo+"' AND CT2.CT2_MOEDLC = '"+cMoeda+"'" 
	cQuery	+= " 							 AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') "
	cQuery	+= "	 						 AND CT2_VALOR <> 0 AND CT2.D_E_L_E_T_ = ' ' " 
	cQuery	+= " 							 AND CT2.CT2_CREDIT >= '"+cContaIni+"'" 
	cQuery	+= " 							 AND CT2.CT2_CREDIT <= '"+cContaFim+" ' "
	cQuery	+= " 							 AND CT2.D_E_L_E_T_ = ' ' ) "
	cQuery	+= " 	UNION "
	cQuery	+= " 	SELECT DISTINCT CVX_NIV01 CONTA, ' ' CUSTO, ' 'ITEMC, CVX_NIV05 NIT, ' ' DDATA, ' ' TPSALD, ' ' DC, ' ' LOTE,"
	cQuery	+= " 		   ' 'SUBLOTE, ' ' DOC, ' ' LINHA, ' ' XPARTIDA, ' ' HIST, ' ' SEQHIS, ' ' SEQLAN,' ' TIPOLAN, 0 VALOR, "
	cQuery	+= " 	   	' ' EMPORI,' ' FILORI "
	cQuery	+= " 	FROM "+ RetSqlName("CVX")+" CVX "
	cQuery	+= " 	WHERE  CVX_FILIAL "+cQryFil2
	cQuery	+= " 	AND CVX_NIV01 >= '"+cContaIni+"'" 
	cQuery	+= " 	AND CVX_NIV01 <= '"+cContaFim+"'" 
	cQuery	+= " 	AND CVX_NIV05 >= '"+cNitIni+"'" 
	cQuery	+= " 	AND CVX_NIV05 <= '"+cNitFim+"'" 
	cQuery	+= " 	AND CVX_MOEDA = '"+cMoeda+"' "
	cQuery	+= " 	AND CVX_TPSALD IN ('"+cSaldo+"') "
	cQuery	+= " 	AND CVX_DATA < '"+DTOS(dDataIni)+"'"
//	cQuery	+= " 	AND CVX_DATA >= '"+cDtSldIni+"'"
	//29/03--cQuery	+= " 	AND ((CVX_DATA >= '"+cDtSldIni+"' AND  SUBSTRING(CVX_NIV01,1,1)>='4' ) OR (SUBSTRING(CVX_NIV01,1,1)<'4') )   "    

	If lCtbIsCube .And. CtbIsCube()
		cQuery += " 			AND CVX_CONFIG = '05' "
	Else
		cQuery += " 			AND CVX_CONFIG = '01' "
	EndIf
	cQuery	+= "	AND CVX_SLDDEB > 0"
	cQuery	+= " 	AND D_E_L_E_T_ = ' '"
	cQuery	+= " 	AND CVX_NIV01+CVX_NIV05 NOT IN (SELECT DISTINCT CT2_DEBITO+CT2_EC05DB CONTA "
	cQuery	+= " 							FROM  "+ RetSqlName("CT2")+" CT2 " 
	cQuery	+= " 							WHERE  "+cQryFil
	cQuery	+= " 							 AND CT2.CT2_DATA >= '"+DTOS(dDataIni)+"' AND CT2.CT2_DATA <= '"+DTOS(dDataFim)+"'"
	cQuery	+= " 							 AND CT2.CT2_EC05DB >= '"+cNitIni+"' AND CT2.CT2_EC05DB <= '"+cNitFim+"'" 
	cQuery	+= " 							 AND CT2.CT2_TPSALD = '"+cSaldo+"' AND CT2.CT2_MOEDLC = '"+cMoeda+"'" 
	cQuery	+= " 							 AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') "
	cQuery	+= " 						 	AND CT2_VALOR <> 0 AND CT2.D_E_L_E_T_ = ' '  "
	cQuery	+= " 						 	AND CT2.CT2_DEBITO >= '"+cContaIni+"'" 
	cQuery	+= " 						 	AND CT2.CT2_DEBITO <= '"+cContaFim+"'" 
	cQuery	+= " 						 	AND CT2.D_E_L_E_T_ = ' ' )   ) TAB "			
	
EndIf


//cQuery := ChangeQuery(cQuery)
		   
//MemoWrite( 'c:\CTBR402.txt', cQuery )  
If Select("cArqCT2") > 0
	dbSelectArea("cArqCT2")
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)

TcSetField("cArqCT2","CT2_VLR"+cMoeda,"N",aTamVlr[1],aTamVlr[2])
TcSetField("cArqCT2","DDATA","D",8,0)
                                                            		
If !Empty(cUFilter)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
			TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
		EndIf
	Next
Endif
 			

dbSelectarea("cArqCT2")
If Empty(cUFilter)
	cUFilter := ".T."
Endif						

While !Eof()                                              
	If Empty(cArqCT2->DDATA) //Se nao existe movimento 
		cContaAnt	:= cArqCT2->CONTA	
		
		If !Empty(cArqCT2->TIPOLAN)
			dbSkip()
		EndIf
			
		If Empty(cArqCT2->DDATA) .And. cContaAnt == cArqCT2->CONTA
			lNoMovim	:= .T.
		EndIf
	Endif        
	
	If &("cArqCT2->("+cUFilter+")")						
		If lNoMovim
			If lNoMov  
				If CtbExDtFim("CT1")							    
					dbSelectArea("CT1")
					dbSetOrder(1) 
					If MsSeek(xFilial()+cArqCT2->CONTA)
						If CtbVlDtFim("CT1",dDataIni) 
							//U_XCtbGrv(cArqCT2->CONTA,dDataIni,"CONTA")	//Esta sendo passado "CONTA" fixo, porque essa funcao esta sendo
							U_XCtbGrv(cArqCT2->CONTA,dDataIni,"CONTA",cMoeda,cSaldo,/*aSelFil*/,cTipo,lAnalit,cNitIni,cNitFim,/*&(cAlias + "->" + cClave2)*/) 									
						EndIf												//chamada somente para o CTBR402
					EndIf				
				Else
					U_XCtbGrv(cArqCT2->CONTA,dDataIni,"CONTA")	//Esta sendo passado "CONTA" fixo, porque essa funcao esta sendo 				
				EndIf												//chamada somente para o CTBR402
			ElseIf lSldAnt 
				If SaldoCT7Fil(cArqCT2->CONTA,dDataIni,cMoeda,cSaldo,'CTBR402')[6] <> 0 .and. cArqTMP->CONTA+cArqTMP->NIT <> cArqCT2->CONTA+cArqCT2->NIT  
						U_XCtbGrv(cArqCT2->CONTA,dDataIni,"CONTA",cMoeda,cSaldo,aSelFil,cTipo,lAnalit,cNitIni,cNitFim)	
				Endif							
			EndIf
		Else
			RecLock("cArqTmp",.T.)		    	
		    Replace DATAL		With cArqCT2->DDATA
			Replace TIPO		With cArqCT2->DC
			Replace LOTE		With cArqCT2->LOTE
			Replace SUBLOTE		With cArqCT2->SUBLOTE
			Replace DOC			With cArqCT2->DOC
			Replace LINHA		With cArqCT2->LINHA
			Replace CONTA		With cArqCT2->CONTA			
			Replace CCUSTO		With cArqCT2->CUSTO
			Replace ITEM		With cArqCT2->ITEM
			Replace NIT			With cArqCT2->NIT

			If lImpCPartida
				Replace XPARTIDA	With cArqCT2->XPARTIDA
			EndIf		

			Replace HISTORICO	With cArqCT2->HIST
			Replace EMPORI		With cArqCT2->EMPORI
			Replace FILORI		With cArqCT2->FILORI
			Replace SEQHIST		With cArqCT2->SEQHIS
			Replace SEQLAN		With cArqCT2->SEQLAN

			If cPaisLoc $ "CHI|ARG|PER"
				Replace SEGOFI With cArqCT2->SEGOFI// Correlativo para Chile
			EndIf
	
			If cArqCT2->TIPOLAN = '1'
				Replace LANCDEB	With LANCDEB + cArqCT2->VALOR
			EndIf
			If cArqCT2->TIPOLAN = '2'
				Replace LANCCRD	With LANCCRD + cArqCT2->VALOR
			EndIf	
			MsUnlock()
		Endif         
	EndIf
	lNoMovim	:= .F.	
	dbSelectArea("cArqCT2")	
	dbSkip()
	nMeter++
	oMeter:Set(nMeter)		
Enddo	


CtbTmpErase(cTmpCT2Fil)

RestArea(aSaveArea)

Return

Return    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ AjustaSX1 ³ Autor ³ Ivan Haponczuk      ³ Data ³ 05.12.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajusta as perguntas usadas da SX1.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPerg - Nome do grupo de perguntas.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nulo                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISR011                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ajusta402SX1(cnPerg)
	       
	PutSx1(cnPerg,"37","Gera Arquivo?","¿Genera Archivo?","Generates file?","MV_CH0","N",1,0,0,"C","","","","","MV_PAR37","Sim","Si","Yes","",;
	       "Nao","No","No","","","","","","","","","",{"Informe se deve ser gerado o arquivo magnetico"},{"Generate a magnetic file"},{"Informe si debe generar un arquivo magnetico"})
	
	PutSx1(cnPerg,"38","Diretorio ?","¿Directorio?","Directory?","MV_CHV","C",40,0,0,"G","","DIR","","","MV_PAR38","","","","",;
	       "","","","","","","","","","","","",{"Diretorio do arquivo"},{"Directory file determination"},{"Directorio de los archivos"})
	       
	//PutSx1(cnPerg,"39","Arq. de destino ?             ","¿Arch de destino ?            ","Arch. target?                 ","MV_CH8","G",02,0,0,"C","","","","","MV_PAR39","","","","",;
	//       "","","","","","","","","","","","",{"Arquivo destino"},{"target file"},{"El archivo de destino"})
	       
Return Nil



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ GerArq   ³ Autor ³ Marivaldo           ³ Data ³ 23.04.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Gera o arquivo magnético do Diario contabil                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³ cDir - Diretorio de criacao do arquivo.                    ³±±
±±³            ³ cArq - Nome do arquivo com extensao do arquivo.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³ Nulo                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Fiscal Peru - Diario contabil - Arquivo Magnetico          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GerArq(cDir)

Local nHdl    := 0
Local nSinal  := 0
Local nlF3Bas := 0
Local cLin    := ""
Local cSep    := "|"
//Local cTipDoc := ""
//Local cSerie  := ""
//Local cNumDoc := ""
//Local dEmiss  := CTOD("  /  /  ")
Local n		  :=0
Local cArq    :=""
Local nCont   :=0

FOR nCont:=LEN(ALLTRIM(cDir)) TO 1 STEP -1
	IF SUBSTR(cDir,nCont,1)=='\'
		cDir:=Substr(cDir,1,nCont)
		EXIT
	ENDIF
NEXT


//Nome do arquivo TXT conforme layout (7_2Nombres) - SUNAT
cArq += "LE"                            // Fixo  'LE'
cArq +=  AllTrim(SM0->M0_CGC)           // Ruc
cArq +=  AllTrim(Str(Year(MV_PAR03)))   // Ano
cArq +=  AllTrim(Strzero(Month(MV_PAR03),2))  // Mes
cArq +=  "00"                            // Fixo '00'
cArq += "060100"                         // Fixo '060100'
cArq += "00"                             // Fixo '00'
cArq += "1"
cArq += "1"
cArq += "1"
cArq += "1"
cArq += ".TXT" // Extensao

nHdl := fCreate(cDir+cArq)
If nHdl <= 0
	ApMsgStop("Ocorreu um erro ao criar o arquivo.")
Else
	
	dbSelectArea("cArqTmp")
	cArqTmp->(dbGoTop())
	Do While cArqTmp->(!EOF())
		if cArqTmp->LANCDEB > 0 .or. cArqTmp->LANCCRD > 0
			//01 - Periodo
			cLin :=""
			cLin += SubStr(DTOS(cArqTmp->DATAL),1,6)+"00"
			cLin += cSep
			
			//02 - Num correlativo
			cLin += AllTrim(cArqTmp->SEGOFI)+cArqTmp->LINHA+IIF(cArqTmp->LANCDEB>0,'D','H')
			cLin += cSep
			
			//03 - Codigo da conta contabil
			cLin += cArqTmp->CONTA
			cLin += cSep
			
			//04  - Data da contabilizacao
			cLin += SubStr(DTOC(cArqTmp->DATAL),1,6)+SubStr(DTOS(cArqTmp->DATAL),1,4)
			cLin += cSep
			
			//05 - Historico
			cLin += cArqTmp->HISTORICO
			cLin += cSep
			
			//06  - Conta Debito
			cLin += cArqTmp->(Alltrim(Str(cArqTmp->LANCDEB)))
			cLin += cSep
			
			//07 - Conta Credito
			cLin += cArqTmp->(Alltrim(Str(cArqTmp->LANCCRD)))
			cLin += cSep
			
			//08 - Estado da Operacao
			cLin += '1'
			cLin += cSep
			
			cLin += chr(13)+chr(10)
			fWrite(nHdl,cLin)
		endif
		cArqTmp->(dbSkip())
		n:=n+1
	EndDo
	fClose(nHdl)
	
EndIf

Return Nil


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SaldtotCVX ³ Autor ³ Pilar S. Albaladejo 			   ³ Data ³ 27/11/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna os saldos do intervalo de contas e centro de custo		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³SaldtotCVX(cCusIni,cCusFim,cContaIni,cContaFim,dData,cMoeda,cTpSald)	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												 			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Centro de Custo Inicial          				 			 ³±±
±±³          ³ ExpC2 = Centro de Custo Final            				 			 ³±±
±±³          ³ ExpC3 = Conta Final                      				 			 ³±±
±±³          ³ ExpC4 = Conta Final                      				 			 ³±±
±±³          ³ ExpD1 = Data                              			 				 ³±±
±±³          ³ ExpC3 = Moeda                            				 			 ³±±
±±³          ³ ExpC4 = Tipo de Saldo                       				 			 ³±±
±±³          ³ ExpC5 = Filial Especifica                   				 			 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                 
User Function xSldCVX(cNitIni,cNitFim,cContaIni,cContaFim,dData,cMoeda,cTpSald,aSelFil,lRecDesp0,cRecDesp,dDtZeraRD,;
lImpAntLP,dDataLP,cArqCVX,lConsSaldo)

Local aSaveArea	:= CVX->(GetArea())
Local aSaveAnt	:= GetArea()
Local lNaoAchei	:= .F.
Local nDebito	:= 0					// Valor Debito na Data
Local nCredito 	:= 0					// Valor Credito na Data
Local nAtuDeb  	:= 0					// Saldo Atual Devedor
Local nAtuCrd	:= 0					// Saldo Atual Credor
Local nVlDebAtu := 0					// Valor do Debito Atual
Local nVlCrdAtu := 0                    // Valor do Credito Atual
Local nVlDebAnt := 0					// Valor do Debito Anterior
Local nVlCrdAnt := 0                    // Valor do Credito Anterior
Local nAntDeb	:= 0					// Saldo Anterior Devedor
Local nAntCrd	:= 0					// Saldo Anterior Credor
Local nSaldoAnt := 0					// Saldo Anterior (com sinal)
Local nSaldoAtu := 0					// Saldo Atual (com sinal)
Local cCC
Local cConta
Local nCont		:= 0
Local nTamRecDes:= Len(Alltrim(cRecDesp))
Local aSldRecDes	:= {}
Local nSldRDAtuD	:=	0
Local nSldRDAtuC	:=	0
Local nSldAtuRD		:=	0
Local cContaAux
Local cCustoAux
Local lTeveAPLP
Local nRecOri
Local bCondLP
Local cQryFil	:= ""
Local cTipoSaldo	:= ""
Local lDefTop 		:= IfDefTopCTB() // verificar se pode executar query (TOPCONN)
Local cCVXTmpFil
Local _lCtbIsCube	:= FindFunction( "CtbIsCube" ) .And. CtbIsCube()
Local cDtSldIni     := cValtochar(year(dData))+"0101"

DEFAULT cTpSald := Iif(Empty(cTpSald),"1",cTpSald)
DEFAULT lConsSaldo:= .F.
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp 	:= ""
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")
//DEFAULT lImpAntLp 	:= .F.
DEFAULT lImpAntLp 	:= .T.
DEFAULT dDataLp	  	:= CTOD("  /  /  ")
DEFAULT aSelFil		:= {}
DEFAULT cArqCVX		:= Nil
Private __aTamVlr := TamSX3("CT7_ATUDEB")

cTipoSaldo := StrTran(StrTran(cTpSald,"','",""),";","")
cQryFil := GetRngFil( aSelFil, "CVX", .T., @cCVXTmpFil)

If lRecDesp0 .And. ( Empty(cRecDesp) .Or. Empty(dDtZeraRD) )
	lRecDesp0 := .F.
EndIf


IF cArqCVX == nil
	cArqCVX	:= RetSqlName("CVX")
Endif

cQuery := " SELECT SUM(CVX_SLDDEB) SLDANTDB, SUM(CVX_SLDCRD) SLDANTCR "
cQuery += " FROM " + cArqCVX
cQuery += " WHERE CVX_FILIAL " + cQryFil
cQuery += " AND CVX_NIV01 >= '"+cContaIni+"' "
cQuery += " AND CVX_NIV01 <= '"+cContaFim+"' "
/*
If !lImpAntLP .And. lRecDesp0
	For nCont	:= 1 to nTamRecDes
		If nCont == 1
			cQuery += "	 AND ( (CVX_NIV01 NOT LIKE '"+Substr(cRecDesp,nCont,1)+"%')"
		Else
			cQuery += "	 AND  (CVX_NIV01 NOT LIKE '"+Substr(cRecDesp,nCont,1)+"%')"
		EndIf
	Next
	cQuery += " OR "
	cQuery += " ( "
	For nCont	:= 1 to nTamRecDes
		If nTamRecDes == 1
			cQuery += " ( CVX_NIV01 LIKE '"+Substr(cRecDesp,nCont,1)+"%')  AND "
		Else
			If nCont == 1
				cQuery += " ( CVX_NIV01 LIKE '"+Substr(cRecDesp,nCont,1)+"%' OR "
			ElseIf nCont < nTamRecDes
				cQuery += "  CVX_NIV01 LIKE '"+Substr(cRecDesp,nCont,1)+"%' OR "
			ElseIf nCont == nTamRecDes
				cQuery += " CVX_NIV01 LIKE '"+Substr(cRecDesp,nCont,1)+"%') AND "
			EndIf
		EndIf
	Next
	cQuery += " CVX_DATA > '" +DTOS(dDtZeraRD)+"') "
	cQuery += " ) "
EndIf
*/
If Empty(cNitIni)
	cNitIni := "1"
EndIf

cQuery += " AND CVX_NIV05 >= '"+cNitIni+"' "
cQuery += " AND CVX_NIV05 <= '"+cNitFim+"' "
cQuery += " AND CVX_MOEDA = '"+cMoeda+"' "
cQuery += " AND CVX_TPSALD IN ('"+cTpSald+"') "
//cQuery += " AND CVX_DATA < '"+DTOS(dData)+"' "
//If lConsSaldo //Saldo Inicial
	//cQuery += " AND CVX_DATA = '"+DTOS(dData-1)+"' "
	cQuery += " AND CVX_DATA < '"+DTOS(dData)+"' "
	cQuery	+= " 	AND ((CVX_DATA >= '"+cDtSldIni+"' AND  SUBSTRING(CVX_NIV01,1,1)>='4' ) OR (SUBSTRING(CVX_NIV01,1,1)<'4') )   "
//Else
	//cQuery += " AND CVX_DATA >= '"+DTOS(dData)+"' "
//EndIf
 

If lCtbIsCube .And. CtbIsCube()
	cQuery += " 			AND CVX_CONFIG = '05' "
Else
	cQuery += " 			AND CVX_CONFIG = '01' "
EndIf

cQuery += "	 AND D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)         

If Select("SLDTOTCVX") > 0
	dbSelectArea("SLDTOTCVX")
	SLDTOTCVX->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SLDTOTCVX",.T.,.F.)

TcSetField("SLDTOTCVX","SLDANTDB","N",__aTamVlr[1],__aTamVlr[2])
TcSetField("SLDTOTCVX","SLDANTCR","N",__aTamVlr[1],__aTamVlr[2])

dbSelectArea("SLDTOTCVX")
dbGoTop()

nAntDeb 	:= SLDTOTCVX->SLDANTDB
nAntCrd 	:= SLDTOTCVX->SLDANTCR

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query Mov. no Dia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := " SELECT SUM(CVX_SLDDEB) DEBITO, SUM(CVX_SLDCRD) CREDIT  "
cQuery += " FROM " + cArqCVX
cQuery += " WHERE CVX_FILIAL " + cQryFil
cQuery += " AND CVX_NIV01 >= '"+cContaIni+"' "
cQuery += " AND CVX_NIV01 <= '"+cContaFim+"' "
cQuery += " AND CVX_NIV05 >= '"+cNitIni+"' "
cQuery += " AND CVX_NIV05 <= '"+cNitFim+"' "
cQuery += " AND CVX_MOEDA = '"+cMoeda+"' "
cQuery += " AND CVX_TPSALD IN ('"+cTpSald+"') "
//cQuery += " AND CVX_DATA = '"+DTOS(dData)+"' "
cQuery += " AND CVX_DATA >= '"+cDtSldIni+"' "
//cQuery	+= " 	AND ((CVX_DATA >= '"+cDtSldIni+"' AND  SUBSTRING(CVX_NIV01,1,1)>='4' ) OR (SUBSTRING(CVX_NIV01,1,1)<'4') )   "    

If lCtbIsCube .And. CtbIsCube()
	cQuery += " 			AND CVX_CONFIG = '05' "
Else
	cQuery += " 			AND CVX_CONFIG = '01' "
EndIf                                         

cQuery += " 	 AND D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
If Select("SLDTOTCVX") > 0
	dbSelectArea("SLDTOTCVX")
	SLDTOTCVX->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SLDTOTCVX",.T.,.F.)

TcSetField("SLDTOTCVX","DEBITO"  ,"N",__aTamVlr[1],__aTamVlr[2])
TcSetField("SLDTOTCVX","CREDIT"  ,"N",__aTamVlr[1],__aTamVlr[2])

dbSelectArea("SLDTOTCVX")
dbGoTop()

// Movimentacao da data
nDebito		:= SLDTOTCVX->DEBITO
nCredito	:= SLDTOTCVX->CREDIT

nAtuDeb := nAntDeb + nDebito
nAtuCrd := nAntCrd + nCredito

nSaldoAtu := nAtuCrd - nAtuDeb
nSaldoAnt := nAntCrd - nAntDeb

If Select("SLDTOTCVX") > 0
	dbSelectArea("SLDTOTCVX")
	SLDTOTCVX->(dbCloseArea())
	CtbTmpErase(cCVXTmpFil)
Endif

CVX->(RestArea(aSaveArea))
RestArea(aSaveAnt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt/*nSaldoAnt/3*/,nAntDeb,nAntCrd}



