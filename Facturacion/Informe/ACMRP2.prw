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
| Desc.     #  Función  Remision de salida de Productos DESPACHO A CLIENTES |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # u_ACMRP2A()                                                   |
+---------------------------------------------------------------------------+
*/
User Function ACMRP2A()
	Local cQryBw, cArqTrb			:= ""
	Local cAliasTMP					:= GetNextAlias()
	Local oTempTable 
	Local aStrut					:= {}
	Local aCampos					:= {}
	Local aSeek						:= {}
	Local aIndexSF2					:= {}
	Private cMarca					:= cValToChar(Randomize(10,99))
	Private cFiltro					:= ""
	Private cRealNames				:= ""
	Private cCadastro 				:= "Generación de PDF de Remisiones de Salida"
	fFilAcm2(@cFiltro)
	
	If EMPTY(cFiltro)
		Return
	EndIf

	//--------------------------
	//Crear Campos Temporales
	//--------------------------

	AAdd( aStrut,{ "F2OK"			,"C",02						,0	} ) //01
	AAdd( aStrut,{ "F2CLIENTE"		,"C",TamSX3("F2_CLIENTE")[1],0	} ) //02
	AAdd( aStrut,{ "F2LOJA"			,"C",TamSX3("F2_LOJA")[1]	,0	} ) //03
	AAdd( aStrut,{ "F2NOME"			,"C",TamSX3("A1_NOME")[1]	,0	} ) //04
	AAdd( aStrut,{ "F2SERIE"		,"C",TamSX3("F2_SERIE")[1]	,0	} ) //05
	AAdd( aStrut,{ "F2DOC"			,"C",TamSX3("F2_DOC")[1]	,2	} ) //06
	AAdd( aStrut,{ "F2DTDIGIT"		,"D",TamSX3("F2_DTDIGIT")[1],0	} ) //07
	AAdd( aStrut,{ "F2EMISSAO"		,"D",TamSX3("F2_EMISSAO")[1],0	} ) //07
	
	oTempTable := FWTemporaryTable():New( cAliasTMP )
	oTemptable:SetFields( aStrut )
	oTempTable:AddIndex("indice1", {"F2CLIENTE"} ) 
	oTempTable:AddIndex("indice2", {"F2SERIE", "F2DOC"} ) 
	oTempTable:Create()

	//------------------------------------
	//Executa query para RELLENADO da tabla temporal
	//------------------------------------
	
	//alert(oTempTable:GetRealName())
	
	cQryBw  := " INSERT INTO "+ oTempTable:GetRealName()
	cQryBw  += " (F2CLIENTE, F2LOJA, F2NOME, F2SERIE, "
	cQryBw  += " F2DOC, F2DTDIGIT, F2EMISSAO ) "
	cQryBw	+= " SELECT "
	cQryBw	+= " F2_CLIENTE AS F2CLIENTE,"
	cQryBw	+= " F2_LOJA  AS F2LOJA, "
	cQryBw	+= " A1_NOME  AS F2NOME, "
	cQryBw	+= " F2_SERIE AS F2SERIE,"
	cQryBw	+= " F2_DOC AS F2DOC, "
	cQryBw	+= " F2_DTDIGIT AS  F2DTDIGIT,"
	cQryBw	+= " F2_EMISSAO AS F2EMISSAO" + CRLF
	cQryBw	+= " FROM "			+ InitSqlName("SF2") +" SF2 " 				+ CRLF
	cQryBw	+= " INNER JOIN "				+ InitSqlName("SA1") +" SA1 ON " 			+ CRLF
	cQryBw	+= " SA1.D_E_L_E_T_<>'*' AND " 												+ CRLF 
	cQryBw	+= " A1_FILIAL='"				+xFilial("SA1")+"' AND  " 					+ CRLF
	cQryBw	+= " A1_COD=F2_CLIENTE "													+ CRLF
	cQryBw	+= " WHERE " 																+ CRLF
	If MV_PAR01==1
		cQryBw	+= " (SF2.F2_ESPECIE='RFN ' OR SF2.F2_ESPECIE='RTF ' ) AND  "			+ CRLF
	Else
		cQryBw	+= " SF2.F2_ESPECIE='NF  ' AND "										+ CRLF
	EndIf
	cQryBw	+= " (F2_DOC     between '"+MV_PAR06+"' AND '"+MV_PAR07+"') AND "			+ CRLF
	cQryBw	+= " (F2_SERIE   between '"+MV_PAR04+"' AND '"+MV_PAR05+"') AND " 			+ CRLF
	cQryBw	+= " (F2_CLIENTE between '"+MV_PAR08+"' AND '"+MV_PAR09+"') AND "			+ CRLF
	cQryBw	+= " (F2_LOJA    between '"+MV_PAR10+"' AND '"+MV_PAR11+"') AND " 			+ CRLF
	cQryBw	+= " (F2_DTDIGIT between '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' ) AND " + CRLF
	cQryBw	+= " SF2.D_E_L_E_T_<>'*' AND " 												+ CRLF
	cQryBw	+= " F2_FILIAL='"+xFilial("SF2")+"' " 										+ CRLF

	TcSqlExec(cQryBw)
	
	aCampos := {}
	AAdd( aCampos,{ "F2CLIENTE"		,"C","Cliente"		    ,"@!S"+cValToChar(TamSX3("F2_CLIENTE")[1])		,"0"	} )
	AAdd( aCampos,{ "F2LOJA"		,"C","No.Tienda"		,"@!S"+cValToChar(TamSX3("F2_LOJA")[1])			,"0"	} )
	AAdd( aCampos,{ "F2NOME"		,"C","Nombre"			,"@!S"+cValToChar(TamSX3("A1_NOME")[1])			,"0"	} )
	AAdd( aCampos,{ "F2SERIE"		,"C","Serie"			,"@!S"+cValToChar(TamSX3("F2_SERIE")[1])		,"0"	} )
	AAdd( aCampos,{ "F2DOC"			,"C","Documento"		,"@!S"+cValToChar(TamSX3("F2_DOC")[1]	)		,"0"	} )
	AAdd( aCampos,{ "F2DTDIGIT"		,"D","Digitacion"		,"@!S"+cValToChar(TamSX3("F2_DTDIGIT")[1])		,"0"	} )
	AAdd( aCampos,{ "F2EMISSAO"		,"D","Emisión"			,"@!S"+cValToChar(TamSX3("F2_EMISSAO")[1])		,"0"	} )

	aRotina := {{"Genera PDFs "		, 	'U_ACMRP2B()',	0,3}}

	cRealAlias:=oTempTable:GetAlias()
	cRealNames:=oTempTable:GetRealName()
	dbSelectArea(cRealAlias)
	dbSetOrder(1)
	cMarca:=GETMARK(,cRealAlias,"F2OK")
	cFiltroSF2 	:= ''
	bFiltraBrw	:=	{|| FilBrowse(cRealAlias,@aIndexSF2,cFiltroSF2)}
	Eval( bFiltraBrw )
	MarkBrow(cRealAlias,"F2OK",,aCampos,.F.,cMarca)
	EndFilBrw(cRealAlias,@aIndexSF2)
	dbCloseArea(cRealAlias)
	oTempTable:Delete()
	
Return 
/*
+---------------------------------------------------------------------------+
| Programa  #   ACMRP2B       |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función que busca los marcados pata generar           |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function ACMRP2B()
	Local cAliasImp	:= GetNextAlias()

	Local cQueryMarca := " SELECT F2CLIENTE, F2LOJA, F2SERIE,  F2DOC  FROM  " + cRealNames + " F2TMP  WHERE F2OK='"+cMarca+"'"
	dbUseArea(.T.,"TOPCONN", TcGenQry(nil,nil,cQueryMarca) ,cAliasImp,.T.,.T.)
	DbSelectArea(cAliasImp)
	(cAliasImp)->(DbGoTop())
	While (cAliasImp)->(!EOF())
		u_ACMRP2((cAliasImp)->F2DOC,(cAliasImp)->F2SERIE,(cAliasImp)->F2CLIENTE,(cAliasImp)->F2LOJA)
		(cAliasImp)->(DbSkip())
	EndDO
Return
/*
+---------------------------------------------------------------------------+
| Programa  #   fFilAcm2       |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función que muestra grupo de preguntas al ingresar          |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
Static Function fFilAcm2(cFiltro)
	Local cPerg := "ACMRP2"
	ACMPREG1(cPerg)			// Inicializa SX1 para preguntas	
	If Pergunte(cPerg)
		cFiltro := "F2->F2_DTDIGI >='"+DTOS(MV_PAR02)+"' .AND. "
		cFiltro += "F2->F2_DTDIGI <='"+DTOS(MV_PAR03)+"' .AND. "
		cFiltro += "F2->F2_SERIE >='"+MV_PAR04+"' .AND. "
		cFiltro += "F2->F2_SERIE <='"+MV_PAR05+"' .AND. "
		cFiltro += "F2->F2_DOC >='"+MV_PAR06+"' .AND. "
		cFiltro += "F2->F2_DOC <='"+MV_PAR07+"' .AND."
		cFiltro += "F2->F2_CLIENTE >='"+MV_PAR08+"' .AND."	
		cFiltro += "F2->F2_CLIENTE <='"+MV_PAR09+"' .AND."	
		cFiltro += "F2->F2_LOJA >='"+MV_PAR10+"' .AND."	
		cFiltro += "F2->F2_LOJA >='"+MV_PAR11+"' "	
	Else
		cFiltro := ""
	EndIf	
Return ()
/*
+===========================================================================+
| Programa  # ACMRP2    |Autor  | Axel Diaz         |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para Impresion de Remisiones                         |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_ACMRP2()                                                  |
+===========================================================================+
*/
User Function ACMRP2(cDoc,cSerie,cCliente,cLoja)
	Local cFilName 			:= UPPER(AllTrim(cSerie)) + '_' + UPPER(AllTrim(cDoc))
	Local cQry				:= ""
	Local cPath				:= ALLTRIM(MV_PAR12)
	Local nPixelX 			:= 0
	Local nPixelY 			:= 0
	Local nHPage 			:= 0
	Local nVPage 			:= 0

	Private cRem			:= GetNextAlias()
	Private nFontAlto		:= 44
	Private oPrinter
	Private nLineasPag		:= 48			// <----- cantidad de lineas en el GRID
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
	Default cCliente		:= '0000000000001'
	Default cLoja			:= '01'
	
	cQry			:= 	TipoQuery(MV_PAR01,cDoc,cSerie, cCliente,cLoja )
	//cQry			:= RQuery(cDoc,cSerie,cCliente,cLoja)

	dbUseArea(.T.,"TOPCONN", TcGenQry(nil,nil,cQry) ,cRem,.T.,.T.)
	DbSelectArea(cRem)
	(cRem)->(DbGoTop())

	If Empty((cRem)->F2_DOC)
		MsgAlert("La remision seleccionada no puede ser Impresa, dado que algunos datos relacionados fueron eliminados, Revise la existencia de los Producto, del Cliente, de los maestros.")
		Return
	EndIf
	
	// FWMsPrinter(): New( < cFilePrintert >, [ nDevice], [ lAdjustToLegacy], [ cPathInServer], [ lDisabeSetup ], [ lTReport], [ @oPrintSetup], [ cPrinter], [ lServer], [ lPDFAsPNG], [ lRaw], [ lViewPDF], [ nQtdCopy] )
	oPrinter:= FWMsPrinter():New(cFilName+".PDF",IMP_PDF,.T.,cPath,.T.,.T.,,,.T.,,,.T.,)
	oPrinter:SetPortrait()
	oPrinter:SetPaperSize(DMPAPER_LETTER)
	oPrinter:cPathPDF:= cPath
	//oPrinter:SetPaperSize(0,133.993,203.08) // Mitad tamaÃ±o carta

	nPixelX := oPrinter:nLogPixelX()
	nPixelY := oPrinter:nLogPixelY()

	nHPage := oPrinter:nHorzRes()
	nHPage *= (300/nPixelX)
	nVPage := oPrinter:nVertRes()
	nVPage *= (300/nPixelY)

	nPagNum	:= 0
	oPrinter:StartPage()

	AcmHeadPR()
	AcmDtaiPR()
	AcmFootPR()

	oPrinter:EndPage()
	oPrinter:Print()
	FreeObj(oPrinter)
	(cRem)->(DbCloseArea())

Return
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
	Local cSerIMP		:= (cRem)->F2_SERIE
	Local cDocIMP		:= (cRem)->F2_DOC
	Local cDT_IMP		:= (cRem)->F2_DTDIGIT
	
	Local cHorIMP		:= ""
	Local cResIMP		:= ""
	Local cTipoRem		:= AcmeTitRemS

	nPagNum++
	cRfc := substr(cRfc,1,3)+"."+substr(cRfc,4,3)+"."+substr(cRfc,7,3)+"-"+substr(cRfc,10,1)
				oPrinter:SayBitmap(10,10,cFileLogo,400,400)  // Logo
				oPrinter:Say(n1Linea					,2150			, AcmePagina + STRZERO(nPagNum,3)					,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, AcmeSerie+cSerIMP									,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, AcmeNumRem+Right(cDocIMP,8)						,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, AcmeFechaEla										,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, fecha(cDT_IMP, cHorIMP)							,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, AcmePEDIDO+(cRem)->D2_PEDIDO						,	oArial12,,,,2)
	nLinea:=1;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+450	, cEmisor + " " + cRfc 								,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+450	, cCalle											,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+450	, AcmeTelefo+cTelf									,	oArial12,,,,2)

	nLinea ++;	oPrinter:SayAlign(n1Linea+(nFontAlto*nLinea),1			, cTipoRem											,	oArial14N,2399,25,,2,0)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, "CLIENTE"											,	oArial12,,,,2)
	nLinea ++; 	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, (cRem)->A1_NOME									,	oArial12,,,,2)
	nLinea ++; 	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, IIF(EMPTY((cRem)->A1_CGC),(cRem)->A1_PFISICA, (cRem)->A1_CGC)									,	oArial12,,,,2)
	nLinea +=	0.5
	nLinea ++;  oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, "CODIGO"											,	oArial12n,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+300	, "ARTÍCULO"										,	oArial12n,,,,2)
				//oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1310	, "BODEGA"											,	oArial12n,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1820	, "CANTIDAD"										,	oArial12n,,,,2)
	nLinea +=	0.5
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
		cCanIMP	:= cValToChar(	(cRem)->D2_QUANT					)
		cUniIMP := ALLTRIM(		(cRem)->AH_DESCES					)
		cCan2IMP:= cValToChar(	(cRem)->D2_QTSEGUM					)
		cCanxIMP:= cValToChar(	(cRem)->D2_QTSEGUM/(cRem)->D2_QUANT	)
		cCanTxIMP:=cValToChar(	(cRem)->D2_QTSEGUM                  )
		nLinea ++;  oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, (cRem)->D2_COD								,	oArial12,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+300	, (cRem)->B1_DESC								,	oArial12,,,,2)
					//oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1310	, (cRem)->NNR_DESCRI							,	oArial12n,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1820	, cCanIMP										,	oArial12,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1900	, "("+cUniIMP+"x"+cCanxIMP+"= "+cCanTxIMP+")"					,	oArial10,,,,2)
					
		(cRem)->(dbSkip())
		If !((cRem)->(EOF())) .and. nLinea > nLineasPag
			//AcmFootPR(cTipo)
			AcmFootPR()
			oPrinter:EndPage()
			oPrinter:StartPage()
			//AcmHeadPR(cTipo,.T.)
			AcmHeadPR()
			nLinea:=10
		EndIf
	EndDo
Return
/*
+===========================================================================+
| Programa  # AcmFootPR    |Autor  | Axel Diaz      |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para Impresion de Remisiones PIE DE PAGINA          |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_AcmFootPR()                                               |
+===========================================================================+
*/
Static Function AcmFootPR(lSaltoPagina)
	Local n1Linea		:= 10
	local nMargIqz		:= 10
	local nLinea		:= 55
	Local nMargDer		:= 2400-10
	Default lSaltoPagina:=.F.
	IF !lSaltoPagina
		(cRem)->(DbGoTop())
	EndIf
	cRespon	:= ALLTRIM("")

				oPrinter:Line(n1Linea+(nFontAlto*nLinea),nMargIqz,n1Linea+(nFontAlto*nLinea), nMargDer,,)
	nLinea += 0.5	
				ImpMemo(oPrinter,zMemoToA("OBSERVACION:  "+(cRem)->F2_XOBS, 60),n1Linea+(nFontAlto*nLinea)        , nMargIqz+50, 1000  , nFontAlto, oArial12, 0, 0)
					// (oPrinter,aTexto                                         ,nLinMemo                          , nColumna   , nAncho, nAlto    , oFont1  , nAlinV, nAlinH, lSaltoObl, nLCorteObl)
	nLinea += 3				
	nLinea ++;	oPrinter:Line(n1Linea+(nFontAlto*nLinea),nMargIqz,n1Linea+(nFontAlto*nLinea), nMargDer,,)
	nLinea += 0.5
	nLinea ++;  oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+50	, "Elaborado:________________________"				,	oArial12,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+700	, "Revisado: ________________________"				,	oArial12,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1700	, "Aprovado: ________________________"				,	oArial12,,,,2)

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
Static Function RQuery(cDoc,cSerie,cCliente,cLoja)
	Local cQry	:= ""

	cQry:=" SELECT  " + CRLF
	cQry+=" NNR_DESCRI, " + CRLF
	cQry+=" A1_NOME, A1_CGC, A1_PFISICA,  " + CRLF
	cQry+=" B1_DESC,  " + CRLF
	cQry+=" D2_ITEM, D2_COD, D2_UM, D2_SEGUM, D2_QUANT, D2_QTSEGUM, D2_NUMSEQ, D2_PEDIDO, " + CRLF
	cQry+=" F2_DOC, F2_SERIE, F2_EMISSAO, F2_TIPOREM, F2_SERIE2, F2_SDOCMAN, F2_DTDIGIT " + CRLF
	cQry+=" FROM "+ InitSqlName("SF2") +" SF2  " + CRLF
	cQry+=" INNER JOIN "+ InitSqlName("SD2") +" SD2 ON  " + CRLF
	cQry+=" SD2.D_E_L_E_T_=' ' AND " + CRLF
	cQry+=" D2_FILIAL='"+xFilial("SD2")+"' AND " + CRLF
	cQry+=" F2_DOC=D2_DOC AND " + CRLF
	cQry+=" F2_SERIE=D2_SERIE AND   " + CRLF
	cQry+=" F2_CLIENTE=D2_CLIENTE AND  " + CRLF
	cQry+=" F2_LOJA=D2_LOJA " + CRLF
	cQry+=" INNER JOIN "+ InitSqlName("SB1") +" SB1 ON  " + CRLF
	cQry+=" SB1.D_E_L_E_T_=' ' AND " + CRLF
	cQry+=" B1_FILIAL='"+xFilial("SB1")+"' AND  " + CRLF
	cQry+=" B1_COD=D2_COD " + CRLF
	cQry+=" INNER JOIN "+ InitSqlName("SA1") +" SA1 ON " + CRLF
	cQry+=" SA1.D_E_L_E_T_=' ' AND " + CRLF
	cQry+=" A1_FILIAL='"+xFilial("SA1")+"' AND  " + CRLF
	cQry+=" A1_COD=F2_CLIENTE " + CRLF
	cQry+=" LEFT JOIN "+ InitSqlName("NNR") +" NNR ON  " + CRLF
	cQry+=" NNR.D_E_L_E_T_=' ' AND " + CRLF
	cQry+=" NNR_FILIAL='"+xFilial("NNR")+"' AND  " + CRLF
	cQry+=" D2_LOCAL=NNR_CODIGO " + CRLF
	cQry+=" WHERE  " + CRLF
	cQry+=" SF2.D_E_L_E_T_=' ' AND  " + CRLF
	cQry+=" F2_FILIAL='"+xFilial("SF2")+"' AND  " + CRLF
	cQry+=" F2_DOC='"+cDoc+"' AND " + CRLF
	cQry+=" F2_SERIE='"+cSerie+"' AND  " + CRLF
	cQry+=" F2_CLIENTE='"+cCliente+"' AND " + CRLF
	cQry+=" F2_LOJA='"+cLoja+"' " + CRLF
	cQry+=" ORDER BY D2_ITEM " + CRLF
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
	dbSeek("F2_DOC")
	nLarDoc:=SX3->X3_TAMANHO
	dbSeek("F2_SERIE")
	nLarSer:=SX3->X3_TAMANHO
	dbSeek("F2_CLIENTE")
	nLarFor:=SX3->X3_TAMANHO
	dbSeek("F2_LOJA")
	nLarLoj:=SX3->X3_TAMANHO
	dbCloseArea("SX3")

	aAdd(aRegs,{cPerg,"01",DOCUPRN		,DOCUPRN	,DOCUPRN	,"MV_CH01"	,"C"	, 08 		,0,2	,"C"	,"" 															,"MV_PAR01","Remision Salida" ,"Remision Salida" ,"Remision Salida" ,""					,"","Despacho Fact","Despacho Fact","Despacho Fact","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02",DEFECHA		,DEFECHA	,DEFECHA	,"MV_CH02"	,"D"	, 08 		,0,2	,"G"	,"" 															,"MV_PAR02","" ,"" ,"" ,"'01/01/20'"				,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03",AFECHA		,AFECHA		,AFECHA		,"MV_CH03"	,"D"	, 08 		,0,2	,"G"	,"!Empty(MV_PAR03) .And. MV_PAR02<=MV_PAR03" 					,"MV_PAR03","" ,"" ,"" ,"'31/12/20'"				,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04",DESERIE		,DESERIE	,DESERIE	,"MV_CH04"	,"C"	, nLarSer	,0,2	,"G"	,"" 															,"MV_PAR04","" ,"" ,"" ,"" 							,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05",ASERIE		,ASERIE		,ASERIE		,"MV_CH05"	,"C"	, nLarSer	,0,2	,"G"	,"!Empty(MV_PAR05) .And. MV_PAR04<=MV_PAR05"	 				,"MV_PAR05","" ,"" ,"" ,REPLICATE("Z",nLarSer) 		,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06",DEDOC		,DEDOCO		,DEDOC		,"MV_CH06"	,"C"	, nLarDoc	,0,2	,"G"	,"" 															,"MV_PAR06","" ,"" ,"" ,"" 							,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07",ADOC			,ADOC		,ADOC		,"MV_CH07"	,"C"	, nLarDoc	,0,2	,"G"	,"!Empty(MV_PAR07) .And. MV_PAR06<=MV_PAR07" 					,"MV_PAR07","" ,"" ,"" ,REPLICATE("Z",nLarDoc) 		,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08",DECLIENTE	,DECLIENTE	,DECLIENTE	,"MV_CH08"	,"C"	, nLarFor	,0,2	,"G"	,"" 															,"MV_PAR08","" ,"" ,"" ,"" 							,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09",ACLIENTE		,ACLIENTE	,ACLIENTE	,"MV_CH09"	,"C"	, nLarFor	,0,2	,"G"	,"!Empty(MV_PAR09) .And. MV_PAR08<=MV_PAR09" 					,"MV_PAR09","" ,"" ,"" ,REPLICATE("Z",nLarFor) 		,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10",DETIENDA		,DETIENDA	,DETIENDA	,"MV_CH10"	,"C"	, nLarLoj	,0,2	,"G"	,"" 															,"MV_PAR10","" ,"" ,"" ,"" 							,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11",ATIENDA		,ATIENDA	,ATIENDA	,"MV_CH11"	,"C"	, nLarLoj	,0,2	,"G"	,"!Empty(MV_PAR11) .And. MV_PAR010<=MV_PAR11" 					,"MV_PAR11","" ,"" ,"" ,REPLICATE("Z",nLarLoj) 		,"","","","","","","","","","","","","","","","","","","","","",""})		
	aAdd(aRegs,{cPerg,"12",DIRDESTINO	,DIRDESTINO	,DIRDESTINO	,"MV_CH12"	,"C"	, 99		,0,2	,"G"	,"!Vazio().or.(MV_PAR12:=cGetFile('PDFs |*.*','',,,,176,.F.))" 	,"MV_PAR12","" ,"" ,"" ,"C:\SPOOL\"					,"","","","","","","","","","","","","","","","","","","","","",""})
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

/*
+===========================================================================+
|  Programa  Tipoquery Autor  Axel Diaz Fecha 04/06/2018                    |
|                                                                           |
|  Uso       | Signature                                                    |
+===========================================================================+
*/
Static function TipoQuery(cDocQuery,cDocumento,cSerie, cCliente,cLoja )
	Local cQueryRem	:=''
	Local cPedido	:=''
	dbSelectArea("SF2")
	dbSetOrder(2)
	dbGoTop()
	DbSeek( xFilial("SF2") + cCliente + cLoja + cDocumento + cSerie )
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2") + cDocumento + cSerie + cCliente + cLoja)
	cPedido:=SD2->D2_PEDIDO
	If cDocQuery==1
		cQueryRem	:= " SELECT DISTINCT "
		cQueryRem	+= " F2_CLIENTE, D2_ITEM, F2_DOC,F2_SERIE,F2_EMISSAO, F2_VALBRUT, F2_MOEDA, F2_DESCONT, F2_VALMERC, " + CRLF
		cQueryRem	+= " F2_VALIMP1, F2_VALIMP2, F2_VALIMP3, F2_VALIMP4, F2_VALIMP5, F2_VALIMP6, F2_VALIMP7, F2_VALIMP8,  F2_VALIMP9, " + CRLF
		cQueryRem	+= " F2_FRETE, F2_ESPECIE, F2_USERLGI, F2_TIPREF, F2_DTDIGIT, " + CRLF
		cQueryRem	+= " D2_DESCON, D2_VALBRUT, D2_PEDIDO, " + CRLF
		cQueryRem	+= " D2_PRCVEN, D2_TOTAL, D2_COD, D2_ITEM, D2_UM, " + CRLF
		cQueryRem	+= " D2_VALIMP1, D2_VALIMP2, D2_VALIMP3, D2_VALIMP4, D2_VALIMP5, D2_VALIMP6, D2_VALIMP7, D2_VALIMP8, D2_VALIMP9, " + CRLF
		cQueryRem	+= " B1_DESC, B1_CODBAR,  " + CRLF
		cQueryRem	+= " D2_QTSEGUM,  " + CRLF
		cQueryRem	+= " A1_END, A1_COD_MUN, A1_BAIRRO, A1_ESTADO, A1_PAIS, A1_NOME, A1_CGC, A1_PFISICA, " + CRLF
		cQueryRem	+= " J1_BAIRRO, J1_COD_MUN, J1_END, J1_ESTADO,  J1_NOME,  J1_PAIS, " + CRLF
		cQueryRem	+= " CC2_MUN, D2_QUANT, "  + CRLF
		cQueryRem	+= " C5_NUM, C5_EMISSAO, C5_CLIENT, C5_LOJAENT, C5_CLIENTE, C5_LOJACLI, " + CRLF
		cQueryRem	+= " FP_NUMINI, FP_NUMFIM, FP_CAI, FP_DTRESOL, A7_CODCLI, A7_DESCCLI, " + CRLF
		cQueryRem	+= " AH_DESCES, " + CRLF
		cQueryRem	+= " SUBSTRING((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),C5_XOBS))),1,LEN((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),C5_XOBS))))) AS C5_XOBS, "  + CRLF
		cQueryRem	+= " SUBSTRING((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),F2_XOBS))),1,LEN((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),F2_XOBS))))) AS F2_XOBS " + CRLF
		cQueryRem	+= " FROM "+ InitSqlName("SF2") +" SF2  " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SA1") +" SA1 ON (SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA=SF2.F2_LOJA AND SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SD2") +" SD2 ON (SD2.D2_DOC = SF2.F2_DOC  AND  SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SB1") +" SB1 ON (SB1.B1_COD = SD2.D2_COD AND SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("CC2") +" CC2 ON (CC2.CC2_CODMUN = SA1.A1_COD_MUN AND CC2.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= "  LEFT JOIN "+ InitSqlName("SC5") +" SC5 ON (SC5.C5_NUM=SD2.D2_PEDIDO AND SC5.C5_FILIAL='"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= "  LEFT JOIN "+ InitSqlName("SC6") +" SC6 ON (SC6.C6_NUM=SC5.C5_NUM AND SC6.C6_FILIAL='"+xFilial("SC6")+"' AND SC6.C6_ITEM=D2_ITEM AND SC6.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= "  LEFT JOIN "+ InitSqlName("SA7") +" SA7 ON (SA7.A7_CLIENTE = SF2.F2_CLIENTE AND SA7.A7_PRODUTO = SD2.D2_COD AND SA7.A7_FILIAL='"+xFilial("SA7")+"' AND SA7.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= "  LEFT JOIN "+ InitSqlName("SFP") +" SFP ON "  + CRLF
		cQueryRem	+= "  (SFP.FP_SERIE=SF2.F2_SERIE AND ( "+cValToChar(VAL(cDocumento))+" BETWEEN CAST(FP_NUMINI as BIGINT) AND CAST(FP_NUMFIM as BIGINT) )  AND SFP.FP_FILIAL='"+xFilial("SFP")+"' AND SFP.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= "  LEFT  JOIN ( SELECT A1_BAIRRO AS J1_BAIRRO,  A1_COD_MUN AS J1_COD_MUN, A1_END AS J1_END, A1_ESTADO AS J1_ESTADO, A1_NOME AS J1_NOME, A1_PAIS AS J1_PAIS, A1_COD AS J1_COD, A1_LOJA AS J1_LOJA, A1_FILIAL AS J1_FILIAL, D_E_L_E_T_ AS JD_E_L_E_T_ FROM "+ InitSqlName("SA1")+" SA1 )" + CRLF
		cQueryRem	+= "   XX1 ON (XX1.J1_COD = SC5.C5_CLIENT  AND XX1.J1_LOJA=SC5.C5_LOJAENT AND XX1.J1_FILIAL='"+xFilial("SA1")+"' AND XX1.JD_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= "  LEFT JOIN "+ InitSqlName("SAH") +" SAH ON (SB1.B1_UM=SAH.AH_UNIMED AND SAH.D_E_L_E_T_=' '  )" + CRLF
		cQueryRem	+= " WHERE (SF2.F2_ESPECIE='RFN ' OR SF2.F2_ESPECIE='RTF ' ) AND F2_DOC='"+cDocumento+"' AND F2_FILIAL='"+xFilial('SF2')+"'AND F2_SERIE='"+cSerie+"' AND SF2.D_E_L_E_T_=' '" + CRLF
	elseIf (cDocQuery==2 .and. EMPTY(ALLTRIM(cPedido))) // FACTURA MANUAL
		cQueryRem	:= " SELECT " + CRLF
		cQueryRem	+= " F2_CLIENTE, D2_ITEM, F2_DOC, F2_SERIE, F2_EMISSAO, F2_VALBRUT, F2_MOEDA, F2_DESCONT, F2_VALMERC, " + CRLF
		cQueryRem	+= " F2_VALIMP1, F2_VALIMP2, F2_VALIMP3, F2_VALIMP4, F2_VALIMP5, F2_VALIMP6, F2_VALIMP7, F2_VALIMP8,  F2_VALIMP9, " + CRLF
		cQueryRem	+= " D2_DESCON, D2_VALBRUT, D2_PEDIDO, F2_FRETE, F2_ESPECIE, F2_USERLGI, F2_TIPREF, F2_DTDIGIT, " + CRLF
		cQueryRem	+= " D2_PRCVEN, D2_TOTAL, D2_COD, D2_ITEM, D2_UM, " + CRLF
		cQueryRem	+= " D2_VALIMP1, D2_VALIMP2, D2_VALIMP3, D2_VALIMP4, D2_VALIMP5, D2_VALIMP6, D2_VALIMP7, D2_VALIMP8, D2_VALIMP9, " + CRLF
		cQueryRem	+= " B1_DESC,  B1_CODBAR,  " + CRLF
		cQueryRem	+= " D2_QUANT, D2_QTSEGUM, " + CRLF
		cQueryRem	+= " A1_END, A1_COD_MUN, A1_BAIRRO, A1_ESTADO, A1_PAIS, A1_NOME, A1_CGC, A1_PFISICA, " + CRLF
		cQueryRem	+= " CC2_MUN,F2_COND, E4_DESCRI, D2_LOTECTL, D2_DTVALID, "  // Estas Lineas para Factura Salida
		cQueryRem	+= " E1_VENCREA, E1_DESCFIN, FP_NUMINI, FP_NUMFIM, FP_CAI, FP_DTRESOL, A7_CODCLI, A7_DESCCLI, " + CRLF
		cQueryRem	+= " AH_DESCES, " + CRLF
		cQueryRem	+= " SUBSTRING((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),F2_XOBS))),1,LEN((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),F2_XOBS))))) AS F2_XOBS " + CRLF
		cQueryRem	+= " FROM "+ InitSqlName("SF2") +" SF2  " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SA1") +" SA1 ON (SA1.A1_COD = SF2.F2_CLIENTE  AND SA1.A1_LOJA=SF2.F2_LOJA AND SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SD2") +" SD2 ON (SD2.D2_DOC = SF2.F2_DOC  AND  SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SB1") +" SB1 ON (SB1.B1_COD = SD2.D2_COD AND SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("CC2") +" CC2 ON (CC2.CC2_CODMUN = SA1.A1_COD_MUN AND CC2.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SE4") +" SE4 ON (SE4.E4_CODIGO = SF2.F2_COND AND SE4.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SE1") +" SE1 ON (SE1.E1_NUM=SF2.F2_DOC AND SE1.E1_PREFIXO=SF2.F2_SERIE AND SE1.E1_FILIAL='"+xFilial("SE1")+"' AND SE1.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= "  LEFT JOIN "+ InitSqlName("SA7") +" SA7 ON (SA7.A7_CLIENTE = SF2.F2_CLIENTE AND SA7.A7_PRODUTO = SD2.D2_COD AND SA7.A7_FILIAL='"+xFilial("SA7")+"' AND SA7.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= "  LEFT JOIN "+ InitSqlName("SFP") +" SFP ON "  + CRLF
		cQueryRem	+= " (SFP.FP_SERIE=SF2.F2_SERIE AND ( "+cValToChar(VAL(cDocumento))+" BETWEEN CAST(FP_NUMINI as BIGINT) AND CAST(FP_NUMFIM as BIGINT) )  AND SFP.FP_FILIAL='"+xFilial("SFP")+"' AND SFP.D_E_L_E_T_=' ') "  + CRLF
		cQueryRem	+= "  LEFT JOIN "+ InitSqlName("SAH") +" SAH ON (SB1.B1_UM=SAH.AH_UNIMED AND SAH.D_E_L_E_T_=' '  )" + CRLF
		cQueryRem	+= " WHERE SF2.F2_ESPECIE='NF  ' AND F2_DOC='"+cDocumento+"' AND F2_FILIAL='"+xFilial('SF2')+"' AND F2_SERIE='"+cSerie+"' AND SF2.D_E_L_E_T_=' ' "  + CRLF // Factura
	elseif (cDocQuery==2 .and. !EMPTY(ALLTRIM(cPedido)))   // PARA FACTURAS CON PEDIDO DE VENTA
		cQueryRem	:= " SELECT DISTINCT " + CRLF
		cQueryRem	+= " C6_ITEM, C6_DESCONT, " + CRLF
		cQueryRem	+= " A1_BAIRRO, A1_CGC, A1_COD_MUN, A1_END, A1_ESTADO, A1_NOME, A1_PAIS, A1_PFISICA, " + CRLF
		cQueryRem	+= " J1_BAIRRO, J1_COD_MUN, J1_END, J1_ESTADO,  J1_NOME,  J1_PAIS, " + CRLF
		cQueryRem	+= " A7_CODCLI, A7_DESCCLI, " + CRLF
		cQueryRem	+= " B1_DESC,  B1_CODBAR,  " + CRLF
		cQueryRem	+= " C5_EMISSAO, C5_NUM, C5_CLIENT, C5_LOJAENT, C5_CLIENTE, C5_LOJACLI,"
		cQueryRem	+= " CC2_MUN, " + CRLF
		cQueryRem	+= " D2_COD, D2_DESCON, D2_DTVALID, D2_ITEM, D2_LOTECTL, D2_PEDIDO, D2_PRCVEN, D2_QTSEGUM, D2_TOTAL, D2_UM, " + CRLF
		cQueryRem	+= " D2_VALBRUT, D2_VALIMP1, D2_VALIMP2, D2_VALIMP3, D2_VALIMP4, D2_VALIMP5, D2_VALIMP6, D2_VALIMP7, D2_VALIMP8, " + CRLF
		cQueryRem	+= " D2_VALIMP9, D2_QUANT, " + CRLF
		cQueryRem	+= " E1_DESCFIN, E1_VENCREA, " + CRLF
		cQueryRem	+= " F2_CLIENTE, F2_COND, F2_DESCONT, F2_DOC , F2_EMISSAO, F2_ESPECIE, F2_FRETE, F2_MOEDA, F2_SERIE, F2_VALBRUT, " + CRLF
		cQueryRem	+= " F2_VALIMP1, F2_VALIMP2, F2_VALIMP3, F2_VALIMP4, F2_VALIMP5, F2_VALIMP6, F2_VALIMP7, F2_VALIMP8, F2_VALIMP9, " + CRLF
		cQueryRem	+= " F2_VALMERC, F2_USERLGI, F2_TIPREF, F2_DTDIGIT, " + CRLF
		cQueryRem	+= " FP_CAI, FP_DTRESOL, FP_NUMFIM, FP_NUMINI, " + CRLF
		cQueryRem	+= " AH_DESCES, " + CRLF
		cQueryRem	+= " SUBSTRING((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),F2_XOBS))),1,LEN((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),F2_XOBS))))) AS F2_XOBS, "
		cQueryRem	+= " SUBSTRING((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),C5_XOBS))),1,LEN((CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),C5_XOBS))))) AS C5_XOBS "
		cQueryRem	+= " FROM "+ InitSqlName("SD2")+" SD2 " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SF2")+" SF2 ON (SF2.F2_FILIAL='"+xFilial("SF2")+"' AND SF2.F2_DOC=SD2.D2_DOC AND SF2.F2_SERIE=SD2.D2_SERIE AND SF2.F2_ESPECIE='NF  ' AND SF2.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SA1")+" SA1 ON (SA1.A1_COD = SF2.F2_CLIENTE  AND SA1.A1_LOJA=SF2.F2_LOJA AND SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("CC2")+" CC2 ON (CC2.CC2_CODMUN = SA1.A1_COD_MUN AND CC2.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SE4")+" SE4 ON (SE4.E4_CODIGO = SF2.F2_COND AND SE4.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SE1")+" SE1 ON (SE1.E1_NUM=SF2.F2_DOC AND SE1.E1_PREFIXO=SF2.F2_SERIE AND SE1.E1_FILIAL='"+xFilial("SE1")+"' AND SE1.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= " INNER JOIN "+ InitSqlName("SB1")+" SB1 ON (SB1.B1_COD = SD2.D2_COD AND SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= " LEFT  JOIN "+ InitSqlName("SC5")+" SC5 ON (SC5.C5_NUM=SD2.D2_PEDIDO AND SC5.C5_FILIAL='"+xFilial("SC5")+"' AND SC5.D_E_L_E_T_=' ')   " + CRLF
		cQueryRem	+= " LEFT  JOIN "+ InitSqlName("SA7")+" SA7 ON (SA7.A7_CLIENTE = SF2.F2_CLIENTE AND SA7.A7_PRODUTO = SD2.D2_COD AND SA7.A7_FILIAL='"+xFilial("SA7")+"' AND SA7.D_E_L_E_T_=' ')  " + CRLF
		cQueryRem	+= " LEFT  JOIN "+ InitSqlName("SFP")+" SFP ON (SFP.FP_SERIE=SF2.F2_SERIE AND ( "+cValToChar(VAL(cDocumento))+" BETWEEN CAST(FP_NUMINI as BIGINT) AND CAST(FP_NUMFIM as BIGINT) ) AND SFP.FP_FILIAL='"+xFilial("SFP")+"' AND SFP.D_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= " LEFT  JOIN "+ InitSqlName("SC6")+" SC6 ON (SC6.C6_NUM=SD2.D2_PEDIDO AND SC6.C6_FILIAL='"+xFilial("SC6")+"' AND SC6.C6_NOTA=SD2.D2_DOC AND C6_SERIE=SF2.F2_SERIE AND C6_PRODUTO=D2_COD AND C6_QTDVEN=D2_QUANT AND C6_VALOR=D2_TOTAL AND D2_ITEMPV=C6_ITEM AND SC6.D_E_L_E_T_=' ' ) " + CRLF
		cQueryRem	+= " LEFT  JOIN ( SELECT A1_BAIRRO AS J1_BAIRRO,  A1_COD_MUN AS J1_COD_MUN, A1_END AS J1_END, A1_ESTADO AS J1_ESTADO, A1_NOME AS J1_NOME, A1_PAIS AS J1_PAIS, A1_COD AS J1_COD, A1_LOJA AS J1_LOJA, A1_FILIAL AS J1_FILIAL, D_E_L_E_T_ AS JD_E_L_E_T_ FROM "+ InitSqlName("SA1")+" SA1 )" + CRLF
		cQueryRem	+= " XX1 ON (XX1.J1_COD = SC5.C5_CLIENT  AND XX1.J1_LOJA=SC5.C5_LOJAENT AND XX1.J1_FILIAL='"+xFilial("SA1")+"' AND XX1.JD_E_L_E_T_=' ') " + CRLF
		cQueryRem	+= "  LEFT JOIN "+ InitSqlName("SAH") +" SAH ON (SB1.B1_UM=SAH.AH_UNIMED AND SAH.D_E_L_E_T_=' '  )" + CRLF
		cQueryRem	+= " WHERE SF2.F2_ESPECIE='NF  ' AND ( SD2.D2_DOC='"+cDocumento+"' AND SD2.D2_SERIE='"+cSerie+"'  AND SD2.D2_FILIAL='"+xFilial("SD2")+"' AND SD2.D_E_L_E_T_=' ' ) " + CRLF
		cqueryRem	+= " ORDER BY D2_PEDIDO, C6_ITEM, D2_ITEM " + CRLF
		cqueryRem	+= " " + CRLF
	EndIf
	/*
	DEFINE MSDIALOG oDlg TITLE "QUERY" FROM 0,0 TO 555,650 PIXEL
	     @ 005, 005 GET oMemo VAR cqueryRem MEMO SIZE 315, 250 OF oDlg PIXEL
	     @ 260, 230 Button "CANCELAR" Size 035, 015 PIXEL OF oDlg Action oDlg:End()	     
	ACTIVATE MSDIALOG oDlg CENTERED
	*/
Return cQueryRem


/*/{Protheus.doc} zMemoToA
Função Memo To Array, que quebra um texto em um array conforme número de colunas
@author Atilio
@since 15/08/2014
@version 1.0
    @param cTexto, Caracter, Texto que será quebrado (campo MEMO)
    @param nMaxCol, Numérico, Coluna máxima permitida de caracteres por linha
    @param cQuebra, Caracter, Quebra adicional, forçando a quebra de linha além do enter (por exemplo '<br>')
    @param lTiraBra, Lógico, Define se em toda linha será retirado os espaços em branco (Alltrim)
    @return nMaxLin, Número de linhas do array
    @example
    cCampoMemo := SB1->B1_X_TST
    nCol        := 200
    aDados      := u_zMemoToA(cCampoMemo, nCol)
    @obs Difere da MemoLine(), pois já retorna um Array pronto para impressão
/*/
 
Static Function zMemoToA(cTexto, nMaxCol, cQuebra, lTiraBra)
    Local aTexto    := {}
    Local aAux      := {}
    Local nAtu      := 0
    Default cTexto  := ''
    Default nMaxCol := 60
    Default cQuebra := ';'
    Default lTiraBra:= .T.
 
    //Quebrando o Array, conforme -Enter-
    aAux:= StrTokArr(cTexto,Chr(13))
     
    //Correndo o Array e retirando o tabulamento
    For nAtu:=1 TO Len(aAux)
        aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
    Next
     
    //Correndo as linhas quebradas
    For nAtu:=1 To Len(aAux)
     
        //Se o tamanho de Texto, for maior que o número de colunas
        If (Len(aAux[nAtu]) > nMaxCol)
         
            //Enquanto o Tamanho for Maior
            While (Len(aAux[nAtu]) > nMaxCol)
                //Pegando a quebra conforme texto por parâmetro
                nUltPos:=RAt(cQuebra,SubStr(aAux[nAtu],1,nMaxCol))
                 
                //Caso não tenha, a última posição será o último espaço em branco encontrado
                If nUltPos == 0
                    nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))
                EndIf
                 
                //Se não encontrar espaço em branco, a última posição será a coluna máxima
                If(nUltPos==0)
                    nUltPos:=nMaxCol
                EndIf
                 
                //Adicionando Parte da Sring (de 1 até a Úlima posição válida)
                aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))
                 
                //Quebrando o resto da String
                aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))
            EndDo
             
            //Adicionando o que sobrou
            aAdd(aTexto,aAux[nAtu])
        Else
            //Se for menor que o Máximo de colunas, adiciona o texto
            aAdd(aTexto,aAux[nAtu])
        EndIf
    Next
     
    //Se for para tirar os brancos
    If lTiraBra
        //Percorrendo as linhas do texto e aplica o AllTrim
        For nAtu:=1 To Len(aTexto)
            aTexto[nAtu] := Alltrim(aTexto[nAtu])
        Next
    EndIf
Return aTexto


Static Function ImpMemo(oPrinter,aTexto, nLinMemo, nColumna, nAncho, nAlto, oFont1, nAlinV, nAlinH, lSaltoObl, nLCorteObl)
	Local nActual	:= 0
	Local nLinLoc	:= 0
	Local lSalto	:= .F.
	Local nLinTmp	:= 0
	Default lSaltoObl := .T.
	Default nLCorteObl := 200
    For nActual := 1 To Len(aTexto)
    	nLinLoc += 1
    	nLinTmp := nLinMemo+(nLinLoc*nAlto)-nAlto
    	oPrinter:SayAlign(nLinTmp, nColumna, aTexto[nActual], oFont1, nAncho, nAlto,CLR_BLACK, nAlinV, nAlinH )
    Next
Return nLinTmp
