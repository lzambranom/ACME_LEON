#include 'protheus.ch'
#include 'rptdef.ch'
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "FWMVCDEF.CH"
#Include 'AcmeDef.ch'
// https://github.com/imsys/Protheus-Include/blob/7b56abf9727694f6d91eb3e0be42104d184a1f83/include/rptdef.ch
// cTipo 
//         1 Salida de Material
//         2 Entrada de Material
//         3 Legalización
// U_ACMR01('0000000000051','DTD','001','1')
/*
+===========================================================================+
| Programa  #ACMR01A    |Autor  | Axel Diaz         |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para Impresion de Remisiones entre bodegas           |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_ACMR01A()                                                 |
+===========================================================================+
*/
User Function ACMR01A(cTipo,cPath)
	Local lRet		:= .T.
	Local oModel	:= FWLoadModel('ACM001')
	If oModel:Activate(.T.)
		If cTipo=='1'
			U_ACMR01(oModel:GetValue("ZX2MASTER","ZX2_DOC"),;
					 oModel:GetValue("ZX2MASTER","ZX2_SERIE"),;
					 oModel:GetValue("ZX2MASTER","ZX2_SECUEN"),;
					 cTipo,cPath)
		ElseIf cTipo=='2'
			If !EMPTY(oModel:GetValue("ZX2MASTER","ZX2_DOC2"))
				U_ACMR01(oModel:GetValue("ZX2MASTER","ZX2_DOC2"),;
						 oModel:GetValue("ZX2MASTER","ZX2_SERIE2"),;
						 oModel:GetValue("ZX2MASTER","ZX2_SECUEN"),;
						 cTipo,cPath)
			Else
				lRet	:= .F.
				Help(NIL,NIL,"No Existe",NIL,"Este documento aun no tiene remisión de entrada", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Solo pordra imprimir remisiones de entrada cuando se registre la entrada de los productos'})
			EndIf
		Else
			If !EMPTY(oModel:GetValue("ZX2MASTER","ZX2_DTMOV"))
				U_ACMR01(oModel:GetValue("ZX2MASTER","ZX2_DOC"),;
						 oModel:GetValue("ZX2MASTER","ZX2_SERIE"),;
						 oModel:GetValue("ZX2MASTER","ZX2_SECUEN"),;
						 cTipo,cPath)
			Else
				lRet	:= .F.
				Help(NIL,NIL,"No Existe",NIL,"Este documento aun no está legalizado", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Solo pordra imprimir remisiones de Legalización cuando se registre el movimiento'})
			EndIf	
		EndIf    
	Else
        Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0)  
	EndIf
Return lRet
/*
+===========================================================================+
| Programa  # ACMR01    |Autor  | Axel Diaz         |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para Impresion de Remisiones entre bodegas           |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_ACMR01()                                                  |
+===========================================================================+
*/
User Function ACMR01(cDoc, cSerie, cSecuen, cTipo, cPath)
	Local cFilName 			:= UPPER(AllTrim(cSerie)) + '_' + UPPER(AllTrim(cDoc))
	Local cQry				:= ""
	Local cPath				:= ""
	Local nPixelX 			:= 0
	Local nPixelY 			:= 0
	Local nHPage 			:= 0
	Local nVPage 			:= 0
	Local cPerg				:= "ACMR01"
	Local nPasos			:= 3
	Private cRem			:= GetNextAlias()
	Private nFontAlto		:= 20
	Private oPrinter
	Private nLineasPag		:= 15			// <----- cantidad de lineas en el GRID
	Private nPagNum			:= 0
	Private nItemRegistro	:= 0			// Item del Registro
	Private oCouNew10		:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	Private oCouNew10N		:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
	Private oArial12 		:= TFont():New("Arial"		,12,12,,.F.,,,,.T.,.F.)
	Private oArial12N		:= TFont():New("Arial"      ,12,12,,.T.,,,,.F.,.F.)
	Private oArial14N		:= TFont():New("Arial"      ,14,14,,.T.,,,,.F.,.F.)

	Default cDoc			:= '0000000000036'
	Default cSerie			:= 'JRI'
	Default cSecuen			:= '001'
	Default cTipo			:= '1' // Salida de Material
			cQry			:= RQuery(cDoc,cSerie,cSecuen,cTipo)
	

	//ACMPREG1(cPerg)			// Inicializa SX1 para preguntas
	
	//If !Pergunte(cPerg)
	//	Return
	//EndIf
	//cPath:=ALLTRIM(MV_PAR01)
	
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
	nPasos:=0
	While !((cRem)->(EOF()))
		nPasos++
		(cRem)->(dbSkip())
	EndDo
	nPasos++
	nPasos++
	(cRem)->(DbGoTop())
	procregua(nPasos)
	nPagNum	:= 0
	oPrinter:StartPage()
	
	incproc("Generando Encabezados y detalles")
	AcmHeadPR(cTipo)
	AcmDtaiPR(cTipo)
	AcmFootPR(cTipo)

	oPrinter:EndPage()
	incproc("Generando archivo:"+cPath+cFilName+".PDF")
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
Static Function AcmHeadPR(cTipo)
	Local cEmisor	   	:= Alltrim(SM0->M0_NOMECOM)
	Local cRfc			:= Alltrim(SM0->M0_CGC)
	Local cCalle		:= Alltrim(SM0->M0_ENDENT)
	Local cTelf			:= Alltrim(SM0->M0_TEL)
	Local cFileLogo		:= GetSrvProfString("Startpath","") + "mainlogoacme.png"
	Local n1Linea		:= 10
	local nMargIqz		:= 10
	local nLinea		:= 1
	Local nMargDer		:= 2400-10
	Local cSerIMP		:= IIF(cTipo=='1'.or.cTipo=='3'	,(cRem)->ZX2_SERIE	,(cRem)->ZX2_SERIE2)
	Local cDocIMP		:= IIF(cTipo=='1'.or.cTipo=='3'	,(cRem)->ZX2_DOC	,(cRem)->ZX2_DOC2)
	Local cDT_IMP		:= IIF(cTipo=='1'.or.cTipo=='3'	,(cRem)->ZX2_DTDIGI	,(cRem)->ZX2_DTDIG2)
	Local cHorIMP		:= IIF(cTipo=='1'.or.cTipo=='3'	,(cRem)->ZX2_TIME1	,(cRem)->ZX2_TIME2)
	Local cResIMP		:= IIF(cTipo=='1'.or.cTipo=='3'	,(cRem)->ZX2_RESPO1	,(cRem)->ZX2_RESPO2)
	Local cTipoRem		:= IIF(cTipo=='1', "DESPACHO INTERNO SALIDA DE PRODUCTOS", IIF(cTipo=='3', "LEGALIZACION"	,"DESPACHO INTERNO ENTRADA DE PRODUCTOS"	))

	nPagNum++
	cRfc := substr(cRfc,1,3)+"."+substr(cRfc,4,3)+"."+substr(cRfc,7,3)+"-"+substr(cRfc,10,1)
				oPrinter:SayBitmap(10,10,cFileLogo,210*2,210)  // Logo
				oPrinter:Say(n1Linea					,2150			,"Página: " + STRZERO(nPagNum,3)					,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, "Serie:"+cSerIMP									,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, "Número:"+Right(cDocIMP,8)						,	oArial12,,,,2)	
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, "Fecha Elaboración"								,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, fecha(cDT_IMP, cHorIMP)							,	oArial12,,,,2)
	nLinea:=1;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+450	, cEmisor + " " + cRfc 								,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+450	, cCalle											,	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+450	, "Teléfono:"+cTelf									,	oArial12,,,,2)
	
	nLinea ++;	oPrinter:SayAlign(n1Linea+(nFontAlto*nLinea),1			, cTipoRem											,	oArial14N,2399,25,,2,0)
	nLinea ++
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+10	, "Almacén Origen :"+(cRem)->ZX2_ALMORI+" "+NNRSAL	,	oArial12,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1850	, "Legalización :"+Fecha((cRem)->ZX2_DTMOV,""),	oArial12,,,,2)
	nLinea ++;	oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+10	, "Almacén Destino:"+(cRem)->ZX2_ALMDES+" "+NNRENT	,	oArial12,,,,2)
	nLinea +=	0.5  
	nLinea ++;  oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, "CODIGO"											,	oArial12n,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+400	, "PRODUCTO"										,	oArial12n,,,,2)
				oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1780	, "CANTIDAD"										,	oArial12n,,,,2)
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
Static Function AcmDtaiPR(cTipo)
	Local n1Linea		:= 10
	local nMargIqz		:= 10
	local nLinea		:= 10
	Local nMargDer		:= 2400-10
	Local nCanIMP		:= 0
	Local cUniIMP		:= ""
	Local nCan2IMP		:= 0
	While !((cRem)->(EOF()))
		incproc("Generando detalles..")
		cCanIMP	:= cValToChar(	IIF(cTipo=='1' .OR. cTipo=='3'	,(cRem)->ZY2_CANTO						, (cRem)->ZY2_CANTD))	// Cantidad en 1a Unidad Medida
		cUniIMP := ALLTRIM(		IIF(cTipo=='1' .OR. cTipo=='3'	,(cRem)->UNIORI							, (cRem)->UNIORI))		// Nombre Unidad de Medida
		//cCan2IMP:= cValToChar(	IIF(cTipo=='1' .OR. cTipo=='3'	,(cRem)->ZY2_CANTO					, (cRem)->ZY2_CANTD))
		cCanxIMP:= cValToChar(	IIF(cTipo=='1' .OR. cTipo=='3'	,((cRem)->ZY2_2CANTO/(cRem)->ZY2_CANTO)	, ((cRem)->ZY2_2CANTD/(cRem)->ZY2_CANTD)))	// Cantidad en Segunda Unidad
		nLinea ++;  oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+5		, (cRem)->ZY2_CODPRO							,	oArial12,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+400	, (cRem)->B1_DESC								,	oArial12,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1780	, cCanIMP										,	oArial12,,,,2)
					oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+1880	, "("+cUniIMP+"x"+cCanxIMP+")"					,	oArial12,,,,2)
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
Static Function AcmFootPR(cTipo,lSaltoPagina)
	Local n1Linea		:= 30
	local nMargIqz		:= 10
	local nLinea		:= 25
	Local nMargDer		:= 2400-10
	Default lSaltoPagina:=.F.
	IF !lSaltoPagina
		(cRem)->(DbGoTop())
	EndIf
	cRespon	:= ALLTRIM(IIF(cTipo=='1' .OR. cTipo=='3'	,ZX2_RESPO1,ZX2_RESPO2))
	nLinea ++;	oPrinter:Line(n1Linea+(nFontAlto*nLinea),nMargIqz,n1Linea+(nFontAlto*nLinea), nMargDer,,)
	nLinea ++;  oPrinter:Say(n1Linea+(nFontAlto*nLinea)	,nMargIqz+50	, "Elaborado: "+cRespon								,	oArial12,,,,2)
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
Static Function RQuery(cDoc,cSerie,cSecuen,cTipo)
	Local cQry	:= ""
	
	If cTipo=='1' .or. cTipo=='3'
		cSerMov		:= 'SERIE'
		cDocMov		:= 'DOC'
	Else
		cSerMov		:= 'SERIE2'
		cDocMov		:= 'DOC2'
	EndIf
	
	cQry:=" SELECT " + CRLF
	cQry+=" A.ZX2_ESTADO,A.ZX2_SERIE,A.ZX2_DOC,A.ZX2_FLEGAL,A.ZX2_DTDIGI,A.ZX2_OBSER,A.ZX2_ALMORI, " + CRLF
	cQry+=" A.ZX2_ALMDES,A.ZX2_SERIE2,A.ZX2_DOC2,A.ZX2_D3DOC,A.ZX2_DTMOV,A.ZX2_SECUEN,A.ZX2_DTDIG2, " + CRLF
	cQry+=" A.ZX2_TIME1, A.ZX2_TIME2, A.ZX2_RESPO1,A.ZX2_RESPO2, " + CRLF
	cQry+=" B.ZY2_ITEM,B.ZY2_CODPRO,B.ZY2_UNORG,B.ZY2_UNDES,B.ZY2_CANTO,B.ZY2_CANTD, " + CRLF
	cQry+=" B.ZY2_LEGALI,B.ZY2_DTDIGI,B.ZY2_OBSERV,B.ZY2_TPMOV,B.ZY2_2UNORG, " + CRLF
	cQry+=" B.ZY2_2CANTO,B.ZY2_2CANTD,B.ZY2_SECUEN,B.ZY2_DTDIG2, " + CRLF
	cQry+=" C.B1_DESC, C.B1_CONV, " + CRLF
	cQry+=" D.NNR_DESCRI AS NNRSAL, " + CRLF
	cQry+=" E.NNR_DESCRI AS NNRENT, " + CRLF
	cQry+=" F.AH_DESCES  AS UNIORI  " + CRLF
	cQry+=" FROM "+ InitSqlName("ZX2") +" A  " + CRLF
	cQry+=" INNER JOIN "+ InitSqlName("ZY2") +" B ON " + CRLF
	cQry+=" 	A.ZX2_DOC=B.ZY2_DOC AND  " + CRLF
	cQry+=" 	A.ZX2_SERIE=B.ZY2_SERIE AND  " + CRLF
	cQry+=" 	A.ZX2_SECUEN=B.ZY2_SECUEN AND  " + CRLF
	cQry+=" 	A.D_E_L_E_T_=' ' AND " + CRLF
	cQry+=" 	B.D_E_L_E_T_=' ' AND " + CRLF
	cQry+=" 	A.ZX2_FILIAL='"+xFilial("ZX2")+"' AND  " + CRLF
	cQry+=" 	B.ZY2_FILIAL='"+xFilial("ZY2")+"' " + CRLF
	cQry+=" INNER JOIN "+ InitSqlName("SB1") +" C ON " + CRLF
	cQry+=" 	B.ZY2_CODPRO=C.B1_COD AND " + CRLF
	cQry+=" 	C.D_E_L_E_T_=' ' AND " + CRLF
	cQry+=" 	C.B1_FILIAL='"+xFilial("SB1")+"' " + CRLF
	cQry+=" LEFT JOIN "+ InitSqlName("NNR") +" D ON " + CRLF
	cQry+="	    A.ZX2_ALMORI=D.NNR_CODIGO AND " + CRLF
	cQry+="	    D.D_E_L_E_T_=' ' AND  " + CRLF
	cQry+="	    D.NNR_FILIAL='"+xFilial("NNR")+"' " + CRLF
	cQry+=" LEFT JOIN "+ InitSqlName("NNR") +" E ON " + CRLF
	cQry+="	    A.ZX2_ALMDES=E.NNR_CODIGO AND " + CRLF
	cQry+="	    E.D_E_L_E_T_=' ' AND  " + CRLF
	cQry+="	    E.NNR_FILIAL='"+xFilial("NNR")+"' " + CRLF
	cQry+=" LEFT JOIN "+ InitSqlName("SAH") +" F ON " + CRLF
	cQry+="	    B.ZY2_UNORG=F.AH_UNIMED  AND " + CRLF
	cQry+="	    F.D_E_L_E_T_=' '  " + CRLF
	cQry+=" WHERE " + CRLF
	cQry+=" A.ZX2_"+cDocMov+"='"+cDoc+"' AND  " + CRLF
	cQry+=" A.ZX2_"+cSerMov+"='"+cSerie+"' AND  " + CRLF
	cQry+=" A.ZX2_SECUEN='"+cSecuen+"' " + CRLF
	cQry+=" ORDER BY B.ZY2_ITEM " + CRLF
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

	aAdd(aRegs,{cPerg,"01",DIRDESTINO	,DIRDESTINO	,DIRDESTINO	,"MV_CH01"	,"C"	, 99		,0,2	,"G"	,"!Vazio().or.(MV_PAR01:=cGetFile('PDFs |*.*','',,,,176,.F.))" 			,"MV_PAR01","" ,"" ,"" ,".\"					,"","" ,"" ,"" ,"","","","","","","","","","","","","","","","","",""})
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
