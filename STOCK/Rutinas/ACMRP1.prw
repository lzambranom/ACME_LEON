#include 'totvs.ch'
#include 'rptdef.ch'
#include 'rwmake.ch'
#include 'FWPrintSetup.ch'
#include 'FWMVCDEF.CH'
#include 'AcmeDef.ch'
#include 'TOPCONN.CH'
/*
+---------------------------------------------------------------------------+
| Programa  #    ACMRP1A       |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función  Remision de entrada de Productos                   |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # u_ACMRP1A()                                                   |
+---------------------------------------------------------------------------+
*/
User Function ACMRP1A()
	Local cQryBw, cArqTrb			:= ""
	Local cAliasTMP					:= GetNextAlias()
	Local oTempTable 
	Local aStrut					:= {}
	Local aCampos					:= {}
	Local aSeek						:= {}
	Local aIndexSF1					:= {}
	Private cMarca					:= cValToChar(Randomize(10,99))
	Private cFiltro					:= ""
	Private cRealNames				:= ""
	Private cCadastro 				:= "Generaci�n de PDF de Remisiones de Entrada"
	fFilAcm1(@cFiltro)
	If EMPTY(cFiltro)
		Return
	EndIf

	//--------------------------
	//Crear Campos Temporales
	//--------------------------

	AAdd( aStrut,{ "F1OK"			,"C",02						,0	} ) //01
	AAdd( aStrut,{ "F1FORNECE"		,"C",TamSX3("F1_FORNECE")[1],0	} ) //02
	AAdd( aStrut,{ "F1LOJA"			,"C",TamSX3("F1_LOJA")[1]	,0	} ) //03
	AAdd( aStrut,{ "F1NOME"			,"C",TamSX3("A2_NOME")[1]	,0	} ) //04
	AAdd( aStrut,{ "F1SERIE"		,"C",TamSX3("F1_SERIE")[1]	,0	} ) //05
	AAdd( aStrut,{ "F1DOC"			,"C",TamSX3("F1_DOC")[1]	,2	} ) //06
	AAdd( aStrut,{ "F1DTDIGIT"		,"D",TamSX3("F1_DTDIGIT")[1],0	} ) //07
	AAdd( aStrut,{ "F1EMISSAO"		,"D",TamSX3("F1_EMISSAO")[1],0	} ) //07
	
	oTempTable := FWTemporaryTable():New( cAliasTMP )
	oTemptable:SetFields( aStrut )
	oTempTable:AddIndex("indice1", {"F1FORNECE"} ) 
	oTempTable:AddIndex("indice2", {"F1SERIE", "F1DOC"} ) 
	oTempTable:Create()

	//------------------------------------
	//Executa query para RELLENADO da tabla temporal
	//------------------------------------
	
	//alert(oTempTable:GetRealName())
	
	cQryBw  := " INSERT INTO "+ oTempTable:GetRealName()
	cQryBw  += " (F1FORNECE, F1LOJA, F1NOME, F1SERIE, "
	cQryBw  += " F1DOC, F1DTDIGIT, F1EMISSAO ) "
	cQryBw	+= " SELECT "
	cQryBw	+= " F1_FORNECE AS F1FORNECE,"
	cQryBw	+= " F1_LOJA  AS F1LOJA, "
	cQryBw	+= " A2_NOME  AS F1NOME, "
	cQryBw	+= " F1_SERIE AS F1SERIE,"
	cQryBw	+= " F1_DOC AS F1DOC, "
	cQryBw	+= " F1_DTDIGIT AS  F1DTDIGIT,"
	cQryBw	+= " F1_EMISSAO AS F1EMISSAO" + CRLF
	cQryBw	+= " FROM "			+ InitSqlName("SF1") +" SF1 " 				+ CRLF
	cQryBw	+= " INNER JOIN "				+ InitSqlName("SA2") +" SA2 ON " 			+ CRLF
	cQryBw	+= " SA2.D_E_L_E_T_<>'*' AND " 												+ CRLF 
	cQryBw	+= " A2_FILIAL='"				+xFilial("SA2")+"' AND  " 					+ CRLF
	cQryBw	+= " A2_COD=F1_FORNECE "													+ CRLF
	cQryBw	+= " WHERE " 																+ CRLF
	cQryBw	+= " (F1_DOC     between '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "			+ CRLF
	cQryBw	+= " (F1_SERIE   between '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND " 			+ CRLF
	cQryBw	+= " (F1_FORNECE between '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND "			+ CRLF
	cQryBw	+= " (F1_LOJA    between '"+MV_PAR09+"' AND '"+MV_PAR10+"') AND " 			+ CRLF
	cQryBw	+= " (F1_DTDIGIT between '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' ) AND " + CRLF
	cQryBw	+= " SF1.D_E_L_E_T_<>'*' AND " 												+ CRLF
	cQryBw	+= " F1_FILIAL='"+xFilial("SF1")+"' " 										+ CRLF

	TcSqlExec(cQryBw)
	
	aCampos := {}
	AAdd( aCampos,{ "F1FORNECE"		,"C","Proveedor"		,"@!S"+cValToChar(TamSX3("F1_FORNECE")[1])		,"0"	} )
	AAdd( aCampos,{ "F1LOJA"		,"C","No.Tienda"		,"@!S"+cValToChar(TamSX3("F1_LOJA")[1])			,"0"	} )
	AAdd( aCampos,{ "F1NOME"		,"C","Nombre"			,"@!S"+cValToChar(TamSX3("A2_NOME")[1])			,"0"	} )
	AAdd( aCampos,{ "F1SERIE"		,"C","Serie"			,"@!S"+cValToChar(TamSX3("F1_SERIE")[1])		,"0"	} )
	AAdd( aCampos,{ "F1DOC"			,"C","Documento"		,"@!S"+cValToChar(TamSX3("F1_DOC")[1]	)		,"0"	} )
	AAdd( aCampos,{ "F1DTDIGIT"		,"D","Digitacion"		,"@!S"+cValToChar(TamSX3("F1_DTDIGIT")[1])		,"0"	} )
	AAdd( aCampos,{ "F1EMISSAO"		,"D","Emisi�n"			,"@!S"+cValToChar(TamSX3("F1_EMISSAO")[1])		,"0"	} )

	aRotina := {{"Genera PDFs "		, 	'U_ACMRP1B()',	0,3}}

	cRealAlias:=oTempTable:GetAlias()
	cRealNames:=oTempTable:GetRealName()
	dbSelectArea(cRealAlias)
	dbSetOrder(1)
	cMarca:=GETMARK(,cRealAlias,"F1OK")
	cFiltroSF1 	:= ''
	bFiltraBrw	:=	{|| FilBrowse(cRealAlias,@aIndexSF1,cFiltroSF1)}
	Eval( bFiltraBrw )
	MarkBrow(cRealAlias,"F1OK",,aCampos,.F.,cMarca)
	EndFilBrw(cRealAlias,@aIndexSF1)
	dbCloseArea(cRealAlias)
	oTempTable:Delete()
	
Return 
/*
+---------------------------------------------------------------------------+
| Programa  #   ACMRP1B       |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función que busca los marcados pata generar           |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function ACMRP1B()
	Local cAliasImp	:= GetNextAlias()
	Local cQueryMarca := "SELECT F1FORNECE, F1LOJA, F1SERIE,  F1DOC  FROM  " + cRealNames + " F1TMP  WHERE F1OK='"+cMarca+"'"
	dbUseArea(.T.,"TOPCONN", TcGenQry(nil,nil,cQueryMarca) ,cAliasImp,.T.,.T.)
	DbSelectArea(cAliasImp)
	(cAliasImp)->(DbGoTop())
	While (cAliasImp)->(!EOF())
		u_ACMRP1((cAliasImp)->F1DOC,(cAliasImp)->F1SERIE,(cAliasImp)->F1FORNECE,(cAliasImp)->F1LOJA)
		(cAliasImp)->(DbSkip())
	EndDO
Return
/*
+---------------------------------------------------------------------------+
| Programa  #   fFilAcm1       |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función que muestra grupo de preguntas al ingresar           |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
Static Function fFilAcm1(cFiltro)
	Local cPerg := "ACMRP1"
	ACMPREG1(cPerg)			// Inicializa SX1 para preguntas	
	If Pergunte(cPerg)
		cFiltro := "F1->F1_DTDIGI >='"+DTOS(MV_PAR01)+"' .AND. "
		cFiltro += "F1->F1_DTDIGI <='"+DTOS(MV_PAR02)+"' .AND. "
		cFiltro += "F1->F1_SERIE >='"+MV_PAR03+"' .AND. "
		cFiltro += "F1->F1_SERIE <='"+MV_PAR04+"' .AND. "
		cFiltro += "F1->F1_DOC >='"+MV_PAR05+"' .AND. "
		cFiltro += "F1->F1_DOC <='"+MV_PAR06+"' .AND."
		cFiltro += "F1->F1_FORNECE >='"+MV_PAR07+"' .AND."	
		cFiltro += "F1->F1_FORNECE <='"+MV_PAR08+"' .AND."	
		cFiltro += "F1->F1_LOJA >='"+MV_PAR09+"' .AND."	
		cFiltro += "F1->F1_LOJA >='"+MV_PAR10+"' "	
	Else
		cFiltro := ""
	EndIf	
Return ()
/*
+===========================================================================+
| Programa  # ACMRP1    |Autor  | Axel Diaz         |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para Impresion de Remisiones                         |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_ACMRP1()                                                  |
+===========================================================================+
*/
User Function ACMRP1(cDoc,cSerie,cFornece,cLoja)
	Local cFilName 			:= UPPER(AllTrim(cSerie)) + '_' + UPPER(AllTrim(cDoc))
	Local cQry				:= ""
	Local cPath				:= ALLTRIM(MV_PAR11)
	Local nPixelX 			:= 0
	Local nPixelY 			:= 0
	Local nHPage 			:= 0
	Local nVPage 			:= 0

	Private cRem			:= GetNextAlias()
	Private nFontAlto		:= 20
	Private oPrinter
	Private nLineasPag		:= 15			// <----- cantidad de lineas en el GRID
	Private nPagNum			:= 0
	Private nItemRegistro	:= 0			// Item del Registro
	Private oCouNew10		:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	Private oCouNew10N		:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
	Private oArial10 		:= TFont():New("Arial"		,10,10,,.F.,,,,.T.,.F.)
	Private oArial12 		:= TFont():New("Arial"		,12,12,,.F.,,,,.T.,.F.)
	Private oArial12N		:= TFont():New("Arial"      ,12,12,,.T.,,,,.F.,.F.)
	Private oArial14N		:= TFont():New("Arial"      ,14,14,,.T.,,,,.F.,.F.)

	Default cDoc			:= '0000000000000'
	Default cSerie			:= 'AAA'
	Default cFornece		:= '0000000000001'
	Default cLoja			:= '01'

	cQry			:= RQuery(cDoc,cSerie,cFornece,cLoja)

	// FWMsPrinter(): New( < cFilePrintert >, [ nDevice], [ lAdjustToLegacy], [ cPathInServer], [ lDisabeSetup ], [ lTReport], [ @oPrintSetup], [ cPrinter], [ lServer], [ lPDFAsPNG], [ lRaw], [ lViewPDF], [ nQtdCopy] )
	oPrinter:= FWMsPrinter():New(cFilName+".PDF",IMP_PDF,.T.,cPath,.T.,.T.,,,.T.,,,.T.,)
	oPrinter:SetPortrait()
	//oPrinter:SetPaperSize(DMPAPER_LETTER)
	oPrinter:SetPaperSize(0,133.993,203.08) // Mitad tamaño carta
	oPrinter:cPathPDF:= cPath
	nPixelX := oPrinter:nLogPixelX()
	nPixelY := oPrinter:nLogPixelY()

	nHPage := oPrinter:nHorzRes()
	nHPage *= (300/nPixelX)
	nVPage := oPrinter:nVertRes()
	nVPage *= (300/nPixelY)

	dbUseArea(.T.,"TOPCONN", TcGenQry(nil,nil,cQry) ,cRem,.T.,.T.)
	DbSelectArea(cRem)
	(cRem)->(DbGoTop())

	nPagNum	:= 0
	oPrinter:StartPage()

	AcmHeadPR()
	AcmDtaiPR()
	AcmFootPR()

	oPrinter:EndPage()
	oPrinter:Print()
	FreeObj(oPrinter)
	(cRem)->(DbCloseArea())
/*
+===========================================================================+
| Programa  # AcmHeadPR    |Autor  | Axel Diaz      |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para Impresion de Remisiones EMCABEZADO              |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_AcmHeadPR()                                               |
+===========================================================================+
*/
Static Function AcmHeadPR()
	Local cEmisor	   	:= Alltrim(SM0->M0_NOMECOM)
	Local cRfc			:= Alltrim(SM0->M0_CGC)
	Local cCalle		:= Alltrim(SM0->M0_ENDENT)
	Local cTelf			:= Alltrim(SM0->M0_TEL)
	Local cFileLogo		:= GetSrvProfString("Startpath","") + "mainlogoacme.png"
	Local n1Linea		:= 10
	local nMargIqz		:= 10
	local nLinea		:= 1
	Local nMargDer		:= 2400-10
	Local cSerIMP		:= (cRem)->F1_SERIE
	Local cDocIMP		:= (cRem)->F1_DOC
	Local cDT_IMP		:= (cRem)->F1_DTDIGIT
	
	Local cHorIMP		:= ""
	Local cResIMP		:= ""
	Local cTipoRem		:= AcmeTitRemE

	nPagNum++
	cRfc := substr(cRfc,1,3)+"."+substr(cRfc,4,3)+"."+substr(cRfc,7,3)+"-"+substr(cRfc,10,1)
				oPrinter:SayBitmap(10,10,cFileLogo,210*2,210)  // Logo
				oPrinter:Say(n1Linea					,2150			, AcmePagina + STRZERO(nPagNum,3)					,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, AcmeSerie+cSerIMP									,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, AcmeNumRem+Right(cDocIMP,8)						,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, AcmeFechaEla								,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, fecha(cDT_IMP, cHorIMP)							,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, AcmePEDIDO+(cRem)->D1_PEDIDO						,	oArial12,,,,2)
	nLinea:=1;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+450	, cEmisor + " " + cRfc 								,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+450	, cCalle											,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+450	, AcmeTelefo+cTelf									,	oArial12,,,,2)

	nLinea ++;	oPrinter:SayAlign(n1Linea+(nFontAlto*nLinea),1			, cTipoRem											,	oArial14N,2399,25,,2,0)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, "PROVEEDOR"										,	oArial12,,,,2)
	nLinea ++; 	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, (cRem)->A2_NOME									,	oArial12,,,,2)
	nLinea ++; 	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, IIF(EMPTY((cRem)->A2_CGC),(cRem)->A2_PFISICA, (cRem)->A2_CGC)									,	oArial12,,,,2)
	nLinea +=	0.5
	nLinea ++;  oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, "CODIGO"											,	oArial12n,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+300	, "PRODUCTO"										,	oArial12n,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1260	, "BODEGA"											,	oArial12n,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1880	, "CANTIDAD"										,	oArial12n,,,,2)
	nLinea ++
	nLinea ++;	oPrinter:Line(n1Linea+(nFontAlto*nLinea),nMargIqz,n1Linea+(nFontAlto*nLinea), nMargDer,,)
Return
/*
+===========================================================================+
| Programa  # AcmDtaiPR    |Autor  | Axel Diaz      |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para Impresion de Remisiones DETALLE                 |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_AcmDtaiPR()                                               |
+===========================================================================+
*/
Static Function AcmDtaiPR()
	Local n1Linea		:= 10
	local nMargIqz		:= 10
	local nLinea		:= 10
	Local nMargDer		:= 2400-10
	Local nCanIMP		:= 0
	Local cUniIMP		:= ""
	Local nCan2IMP		:= 0
	
	While !((cRem)->(EOF()))
		cCanIMP	:= cValToChar(	(cRem)->D1_QTSEGUM					)  	// CANTIDAD						Ej 2 CAJAS
		cUniIMP := ALLTRIM(		(cRem)->AH_DESCES					)	// UNIDAD DE MEDIDA SECUNDARIA	Ej CX
		cCan2IMP:= cValToChar(	(cRem)->D1_QUANT					)	// CANTIDAD EN SEGUNDA UNIDAD	Ej 7000 
		cCanxIMP:= cValToChar(	(cRem)->D1_QUANT/(cRem)->D1_QTSEGUM	)	// CANTIDAD POR SEGUNDA			
		nLinea ++;  oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, (cRem)->D1_COD								,	oArial12,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+300	, (cRem)->B1_DESC								,	oArial12,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1500	, (cRem)->NNR_DESCRI							,	oArial12n,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1260	, cCanIMP										,	oArial12,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1980	,"("+cUniIMP+"x"+cCanxIMP+")"					,	oArial10,,,,2)
		
		(cRem)->(dbSkip())
		If !((cRem)->(EOF())) .and. nLinea > 24
			AcmFootPR(cTipo)
			oPrinter:EndPage()
			oPrinter:StartPage()
			AcmHeadPR(cTipo,.T.)
			nLinea:=10
		EndIf
	EndDo
Return
/*
+===========================================================================+
| Programa  # AcmFootPR    |Autor  | Axel Diaz      |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para Impresion de Remisiones PIE DE PAGINA           |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_AcmFootPR()                                               |
+===========================================================================+
*/
Static Function AcmFootPR(lSaltoPagina)
	Local n1Linea		:= 30
	local nMargIqz		:= 10
	local nLinea		:= 25
	Local nMargDer		:= 2400-10
	Default lSaltoPagina:=.F.
	IF !lSaltoPagina
		(cRem)->(DbGoTop())
	EndIf
	cRespon	:= ALLTRIM("")
	nLinea ++;	oPrinter:Line(n1Linea+(nFontAlto*nLinea),nMargIqz,n1Linea+(nFontAlto*nLinea), nMargDer,,)
	nLinea ++;  oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+50	, "Elaborado::______________________"+cRespon		,	oArial12,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+700	, "Revisado:________________________"				,	oArial12,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1700	, "Aprovado:________________________"				,	oArial12,,,,2)
Return
/*
+===========================================================================+
| Programa  # RQuery    |Autor  | Axel Diaz      |Fecha |  10/12/2019       |
+===========================================================================+
| Desc.     #  Función para GENERAR EL SQL DE BUSQUEDA                      |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   RQuery()                                                    |
+===========================================================================+
*/
Static Function RQuery(cDoc,cSerie,cFornece,cLoja)
	Local cQry	:= ""

	cQry:=" SELECT  " 										+ CRLF
	cQry+=" NNR_DESCRI, " 									+ CRLF
	cQry+=" A2_NOME, A2_CGC, A2_PFISICA,  " 				+ CRLF
	cQry+=" B1_DESC,  " 									+ CRLF
	cQry+=" D1_ITEM, D1_COD, D1_UM, D1_SEGUM, D1_QUANT, D1_QTSEGUM, D1_NUMSEQ, D1_PEDIDO, AH_DESCES, " + CRLF
	cQry+=" F1_DOC, F1_SERIE, F1_EMISSAO, F1_REMITO, F1_TIPOREM, F1_SERIE2, F1_SDOCMAN, F1_DTDIGIT " + CRLF
	cQry+=" FROM "+ InitSqlName("SF1") +" SF1  " 			+ CRLF
	cQry+=" INNER JOIN "+ InitSqlName("SD1") +" SD1 ON  " 	+ CRLF
	cQry+=" SD1.D_E_L_E_T_=' ' AND " 						+ CRLF
	cQry+=" D1_FILIAL='"+xFilial("SD1")+"' AND " 			+ CRLF
	cQry+=" F1_DOC=D1_DOC AND " 							+ CRLF
	cQry+=" F1_SERIE=D1_SERIE AND   " 						+ CRLF
	cQry+=" F1_FORNECE=D1_FORNECE AND  " 					+ CRLF
	cQry+=" F1_LOJA=D1_LOJA " 								+ CRLF
	cQry+=" INNER JOIN "+ InitSqlName("SB1") +" SB1 ON  " 	+ CRLF
	cQry+=" SB1.D_E_L_E_T_=' ' AND " 						+ CRLF
	cQry+=" B1_FILIAL='"+xFilial("SB1")+"' AND  " 			+ CRLF
	cQry+=" B1_COD=D1_COD " 								+ CRLF
	cQry+=" INNER JOIN "+ InitSqlName("SA2") +" SA2 ON " 	+ CRLF
	cQry+=" SA2.D_E_L_E_T_=' ' AND " 						+ CRLF
	cQry+=" A2_FILIAL='"+xFilial("SA2")+"' AND  " 			+ CRLF
	cQry+=" A2_COD=F1_FORNECE " 							+ CRLF
	cQry+=" LEFT JOIN "+ InitSqlName("NNR") +" NNR ON  " 	+ CRLF
	cQry+=" NNR.D_E_L_E_T_=' ' AND " 						+ CRLF
	cQry+=" NNR_FILIAL='"+xFilial("NNR")+"' AND  "	 		+ CRLF
	cQry+=" D1_LOCAL=NNR_CODIGO " 							+ CRLF
	cQry+=" LEFT JOIN "+ InitSqlName("SAH") +" SAH ON  " 	+ CRLF 
	cQry+=" (SB1.B1_UM=SAH.AH_UNIMED AND SAH.D_E_L_E_T_=' ')" + CRLF
	cQry+=" WHERE  " 										+ CRLF
	cQry+=" SF1.D_E_L_E_T_=' ' AND  " 						+ CRLF
	cQry+=" F1_FILIAL='"+xFilial("SF1")+"' AND  "		 	+ CRLF
	cQry+=" F1_DOC='"+cDoc+"' AND " 						+ CRLF
	cQry+=" F1_SERIE='"+cSerie+"' AND  " 					+ CRLF
	cQry+=" F1_FORNECE='"+cFornece+"' AND " 				+ CRLF
	cQry+=" F1_LOJA='"+cLoja+"' " 							+ CRLF
	cQry+=" ORDER BY D1_ITEM " 								+ CRLF
Return cQry
/*
+===========================================================================+
| Programa  # FECHA     |Autor  | Axel Diaz      |Fecha |  10/12/2019       |
+===========================================================================+
| Desc.     #  Función para GENERAR FECHA                                   |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   FECHA()                                                    |
+===========================================================================+
*/
Static Function fecha(cFecha,cTime)
	Local aMes	:= {'Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'}
	Local cAno	:= ""
	Local cMes	:= ""
	Local cDia	:= ""
	Local cFullFecha := "  /  /  "
	If !EMPTY(AllTrim(cFecha))
		cAno	:= SUBSTR(cFecha,1,4)
		cMes	:= aMes[VAL(SUBSTR(cFecha,5,2))]
		cDia	:= SUBSTR(cFecha,7,2)
		cFullFecha := cDia+"/"+cMes+"/"+cAno+" "+cTime
	EndIf
Return cFullFecha

/*
+---------------------------------------------------------------------------+
|  Programa  |AjustaSX1            |Autor  |Axe Diaz |Data    06/01/2020    |
+---------------------------------------------------------------------------+
|  Uso       | Grupo de prerguntas al entrar                                |
+---------------------------------------------------------------------------+
*/
Static Function ACMPREG1(cPregunta)
	Local aRegs := {}
	Local cPerg := PADR(cPregunta,10)
	Local nI 	:= 0
	Local nJ	:= 0
	Local nLarDoc:= 0
	Local nLarSer:= 0
	Local nLarFor:= 0
	Local nLarLoj:= 0
	// Local aHelpSpa:= {}
	DBSelectArea("SX3")
	DBSetOrder(2)
	dbSeek("F1_DOC")
	nLarDoc:=SX3->X3_TAMANHO
	dbSeek("F1_SERIE")
	nLarSer:=SX3->X3_TAMANHO
	dbSeek("F1_FORNECE")
	nLarFor:=SX3->X3_TAMANHO
	dbSeek("F1_LOJA")
	nLarLoj:=SX3->X3_TAMANHO
	dbCloseArea("SX3")

	aAdd(aRegs,{cPerg,"01",DEFECHA		,DEFECHA	,DEFECHA	,"MV_CH01"	,"D"	, 08 		,0,2	,"G"	,"" 															,"MV_PAR01","" ,"" ,"" ,"'01/01/20'"				,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02",AFECHA		,AFECHA		,AFECHA		,"MV_CH02"	,"D"	, 08 		,0,2	,"G"	,"!Empty(MV_PAR02) .And. MV_PAR01<=MV_PAR02" 					,"MV_PAR02","" ,"" ,"" ,"'31/12/20'"				,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03",DESERIE		,DESERIE	,DESERIE	,"MV_CH03"	,"C"	, nLarSer	,0,2	,"G"	,"" 															,"MV_PAR03","" ,"" ,"" ,"" 							,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04",ASERIE		,ASERIE		,ASERIE		,"MV_CH04"	,"C"	, nLarSer	,0,2	,"G"	,"!Empty(MV_PAR03) .And. MV_PAR03<=MV_PAR04" 					,"MV_PAR04","" ,"" ,"" ,REPLICATE("Z",nLarSer) 		,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05",DEDOC		,DEDOCO		,DEDOC		,"MV_CH05"	,"C"	, nLarDoc	,0,2	,"G"	,"" 															,"MV_PAR05","" ,"" ,"" ,"" 							,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06",ADOC			,ADOC		,ADOC		,"MV_CH06"	,"C"	, nLarDoc	,0,2	,"G"	,"!Empty(MV_PAR06) .And. MV_PAR05<=MV_PAR06" 					,"MV_PAR06","" ,"" ,"" ,REPLICATE("Z",nLarDoc) 		,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07",DEPROVE		,DEPROVE	,DEPROVE	,"MV_CH07"	,"C"	, nLarFor	,0,2	,"G"	,"" 															,"MV_PAR07","" ,"" ,"" ,"" 							,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08",APROVE		,APROVE		,APROVE		,"MV_CH08"	,"C"	, nLarFor	,0,2	,"G"	,"!Empty(MV_PAR08) .And. MV_PAR07<=MV_PAR08" 					,"MV_PAR08","" ,"" ,"" ,REPLICATE("Z",nLarFor) 		,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09",DETIENDA		,DETIENDA	,DETIENDA	,"MV_CH09"	,"C"	, nLarLoj	,0,2	,"G"	,"" 															,"MV_PAR09","" ,"" ,"" ,"" 							,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10",ATIENDA		,ATIENDA	,ATIENDA	,"MV_CH10"	,"C"	, nLarLoj	,0,2	,"G"	,"!Empty(MV_PAR10) .And. MV_PAR09<=MV_PAR10" 					,"MV_PAR10","" ,"" ,"" ,REPLICATE("Z",nLarLoj) 		,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})		
	aAdd(aRegs,{cPerg,"11",DIRDESTINO	,DIRDESTINO	,DIRDESTINO	,"MV_CH11"	,"C"	, 99		,0,2	,"G"	,"!Vazio().or.(MV_PAR11:=cGetFile('PDFs |*.*','',,,,176,.F.))"	,"MV_PAR11","" ,"" ,"" ,"C:\SPOOL\"					,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For nI:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[nI,2])
			RecLock("SX1",.T.)
			For nJ:=1 to FCount()
				If nJ <= Len(aRegs[nI])
					FieldPut(nJ,aRegs[nI,nJ])
				Endif
			Next
			MsUnlock()
		Endif
	Next
Return

//*****


	/*
	cQryBw	:= " SELECT "
	cQryBw	+= " F1_OK AS F1OK,"
	cQryBw	+= " F1_FORNECE AS F1FORNECE,"
	cQryBw	+= " F1_LOJA  AS F1LOJA, "
	cQryBw	+= " A2_NOME  AS F1NOME, "
	cQryBw	+= " F1_SERIE AS F1SERIE,"
	cQryBw	+= " F1_DOC AS F1DOC, "
	cQryBw	+= " F1_DTDIGIT AS  F1DTDIGIT,"
	cQryBw	+= " F1_EMISSAO AS F1EMISSAO" + CRLF
	cQryBw	+= " FROM "			+ InitSqlName("SF1") +" SF1 " 				+ CRLF
	cQryBw	+= " INNER JOIN "				+ InitSqlName("SA2") +" SA2 ON " 			+ CRLF
	cQryBw	+= " SA2.D_E_L_E_T_<>'*' AND " 												+ CRLF 
	cQryBw	+= " A2_FILIAL='"				+xFilial("SA2")+"' AND  " 					+ CRLF
	cQryBw	+= " A2_COD=F1_FORNECE "													+ CRLF
	cQryBw	+= " WHERE " 																+ CRLF
	cQryBw	+= " (F1_DOC     between '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "			+ CRLF
	cQryBw	+= " (F1_SERIE   between '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND " 			+ CRLF
	cQryBw	+= " (F1_FORNECE between '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND "			+ CRLF
	cQryBw	+= " (F1_LOJA    between '"+MV_PAR09+"' AND '"+MV_PAR10+"') AND " 			+ CRLF
	cQryBw	+= " (F1_DTDIGIT between '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' ) AND " + CRLF
	cQryBw	+= " SF1.D_E_L_E_T_<>'*' AND " 												+ CRLF
	cQryBw	+= " F1_FILIAL='"+xFilial("SD1")+"' " 										+ CRLF
	
	//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryBw),cAliasF1,.T.,.T.)
	
	AAdd( aStrut,{ "F1OK"			,"C",02						,0	} ) //01
	AAdd( aStrut,{ "F1FORNECE"		,"C",TamSX3("F1_FORNECE")[1],0	} ) //02
	AAdd( aStrut,{ "F1LOJA"			,"C",TamSX3("F1_LOJA")[1]	,0	} ) //03
	AAdd( aStrut,{ "F1NOME"			,"C",TamSX3("A2_NOME")[1]	,0	} ) //04
	AAdd( aStrut,{ "F1SERIE"		,"C",TamSX3("F1_SERIE")[1]	,0	} ) //05
	AAdd( aStrut,{ "F1DOC"			,"C",TamSX3("F1_DOC")[1]	,2	} ) //06
	AAdd( aStrut,{ "F1DTDIGIT"		,"D",TamSX3("F1_DTDIGIT")[1],0	} ) //07
	AAdd( aStrut,{ "F1EMISSAO"		,"D",TamSX3("F1_EMISSAO")[1],0	} ) //07
	//Aadd( aStrut,{ "RECNO"			,"N",10						,0	} ) //10 
	
	AAdd( aCampos,{ "F1FORNECE"		,"Proveedor"		,02,"@!"			,1,TamSX3("F1_FORNECE")[1]	,0	} )
	AAdd( aCampos,{ "F1LOJA"		,"No.Tienda"		,03,"@!"			,1,TamSX3("F1_LOJA")[1]		,0	} )
	AAdd( aCampos,{ "F1NOME"		,"Nombre"			,04,"@!"			,1,TamSX3("A2_NOME")[1]		,0	} )
	AAdd( aCampos,{ "F1SERIE"		,"Serie"			,05,"@!"			,1,TamSX3("F1_SERIE")[1] 	,0	} )
	AAdd( aCampos,{ "F1DOC"			,"Documento"		,06,"@!"			,1,TamSX3("F1_DOC")[1]		,0	} )
	AAdd( aCampos,{ "F1DTDIGIT"		,"Digitacion"		,07,"@!"			,1,TamSX3("F1_DTDIGIT")[1]	,0	} )
	//AAdd( aCampos,{ "F1_EMISSAO"		,"Emisión"			,08,"@!"			,1,TamSX3("F1_EMISSAO")[1]	,0	} )
	*/
	
	//dbSelectArea(cAliasF1)

	//aStrut := dbStruct()
	//varinfo(aStrut)
	
	//------------------- 
	//Criação do objeto 
	//------------------- 
	
	If Select(cAliasTMP) <> 0
		dbSelectArea(cAliasTMP)
		dbCloseArea()
	EndIf
	
	//MsAguarde({|| SqlToTrb(cQryBw, aStrut, cAliasTMP )},OemToAnsi("Preparando Listado"))  //"Preparacao da Nota Fiscal"
	
	//cArqs := CriaTrab( aStrut, .T. )        
	//DbUseArea(.T., "DBFCDX", cArqs, cAliasTmp, .T., .F.)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryBw),cAliasTMP,.T.,.T.)
	
	oTempTable:=FWTemporaryTable():New( cAliasTMP)
	oTemptable:SetFields( aCampos ) 
	oTempTable:AddIndex("indice1", {"F1FORNECE"} ) 
	oTempTable:AddIndex("indice2", {"F1SERIE", "F1DOC"} ) 
	oTempTable:Create()
	//cQryBw("select * from SF10101")


	// Pasar Datos a la tabla Temporal
	/*
	While (cAliasF1)->(!Eof())
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->( RecLock(cAliasTMP,.T.) )
		(cAliasTMP)->F1OK			:= Space(2)
		(cAliasTMP)->F1FORNECE		:= (cAliasF1)->F1_FORNECE
		(cAliasTMP)->F1LOJA			:= (cAliasF1)->F1_LOJA
		(cAliasTMP)->F1NOMFOR		:= (cAliasF1)->A2_NOME
		(cAliasTMP)->F1SERIE		:= (cAliasF1)->F1_SERIE
		(cAliasTMP)->F1DOC			:= (cAliasF1)->F1_DOC
		(cAliasTMP)->F1DTDIGIT		:= (cAliasF1)->F1_DTDIGIT
		//(cAliasTMP)->F1EMISSAO		:= (cAliasF1)->F1_EMISSAO	
		(cAliasTMP)->( MsUnLock() )
		dbSelectArea(cAliasF1)
		(cAliasF1)->(dbSkip())
	End
	*/
	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetDescription("Impresi�n Remisi�n Entrada") 	//Titulo de la pantalla
	oBrowse:SetAlias(cAliasTMP) 			//Indica o alias da tabla que será utilizada en el  Browse
	oBrowse:SetFieldMark("F1OK") 		//Indica o campo que deverá ser atualizado com a marca no registro
	oBrowse:oBrowse:SetDBFFilter(.T.)
	oBrowse:oBrowse:SetUseFilter(.T.) 	//Habilita a utilização do filtro no Browse
	oBrowse:oBrowse:SetFixedBrowse(.T.)
	oBrowse:SetWalkThru(.F.) 			//Habilita a utilização da funcionalidade Walk-Thru no Browse
	oBrowse:SetAmbiente(.T.) 			//Habilita a utilização da funcionalidade Ambiente no Browse
	oBrowse:SetTemporary() 				//Indica que o Browse utiliza tabela temporária
	oBrowse:SetSeek(.T.,aSeek) 			//Habilita a utilização da pesquisa de registros no Browse
	oBrowse:SetFilterDefault("")		//Indica o filtro padrão do Browse
	oBrowse:Activate()
	oTempTable:Delete()

