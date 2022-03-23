//Bibliotecas
#Include "TopConn.ch"
#Include "Protheus.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2
#Define PAD_JUSTIFY 3 //Opção disponível somente a partir da versão 1.6.2 da TOTVS Printer


/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DEL PROGRAMA                           !
+----------------------------------------------------------------------------+
!DATOS DEL PROGRAMA                                                          !
+------------------+---------------------------------------------------------+
!Tipo              ! Reporte de PEdido de Compra Grafico                     !
+------------------+---------------------------------------------------------+
!Modulo            ! COMPRAS                                                 !
+------------------+---------------------------------------------------------+
!Descripcion       ! Impresion de reporte de Ordenes de Compra               !
!                  ! ACME.                                                   !
+------------------+---------------------------------------------------------+
!Autor             ! Gabriel Alejandro Pulido                                !
+------------------+---------------------------------------------------------+
!Fecha creacion    ! Abril/2020                                              !
+------------------+---------------------------------------------------------+
!   ATUALIZACIONES                                                           !
+-------------------------------------------+-----------+-----------+--------+
!Descripcion detallada de la actualizacion  !Nombre del ! Analista  !FEcha de!
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
.________________________________________________________________________________________.
|   //////  //////  //////  //    //  //////  | Developed For Protheus by TOTVS          |
|    //    //  //    //     //   //  //       | ADVPL                                    |
|   //    //  //    //      // //   //////    | TOTVS Technology                         |
|  //    //  //    //       ////       //     | Gabriel Alejandro Pulido -TOTVS Colombia.|
| //    //////    //        //    //////      | gabriel.pulido@totvs.com                 |
|_____________________________________________|__________________________________________|
|                          _==/                             \==                          |
|                         /XX/            |\___/|            \XX\                        |
|                       /XXXX\            |XXXXX|            /XXXX\                      |
|                      |XXXXXX\_         _XXXXXXX_         _/XXXXXX|                     |
|                      XXXXXXXXXXXxxxxxxxXXXXXXXXXXXxxxxxxxXXXXXXXXXXX                   |
|                     |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|                  |
|                     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                  |
|                     |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|                  |
|                      XXXXXX/^^^^"\XXXXXXXXXXXXXXXXXXXXX/^^^^^\XXXXXX                   |
|                      |XXX|       \XXX/^^\XXXXX/^^\XXX/       |XXX|                     |
|                        \XX\       \X/    \XXX/    \X/       /XX/                       |
|                           "\       "      \X/      "       /"                          |
|________________________________________________________________________________________|
|                          //       ////    //   //   //////   //                        |
|                        // //     //  //   //  //   //  //   //                         |
|                       //  //    //  //    // //   //////   //                          |
|                      ///////   //  //     ////   //       //                           |
|                     //    //  ////        //    //       ///////                       |
|_______________________________________________________________________________________*/
*/

User Function uPedCmp()

	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaSA2	:= SA2->(GetArea())
	Local aAreaSA5	:= SA5->(GetArea())
	Local aAreaSF4	:= SF4->(GetArea())
	Local cPerg		:= Padr('UPEDCMP',10)
	Private	lEnd		:= .f.
	If Upper(ProcName(2)) <> 'A120IMPRI'
		If !Pergunte(cPerg,.t.)
			Return
		Endif
		Private	cNumPed  	:= mv_par01			// Numero do Pedido de Compras
		Private	lImpPrc		:= 2 // (mv_par02==2)	// Imprime os Precos ?
		Private	nTitulo 	:= ""			// Titulo do Relatorio ?
		Private	cObserv1	:= ""			// 1a Linha de Observacoes
		Private	cObserv2	:= ""			// 2a Linha de Observacoes
		Private	cObserv3	:= ""			// 3a Linha de Observacoes
		Private	cObserv4	:= ""			// 4a Linha de Observacoes
		Private	lPrintCodFor:= 1 //  (mv_par08==1)	// Imprime o Cvvvvvvvvvvvvvvvvvvvvvvvvvvvodigo do produto no fornecedor ?
	Else
		Private	cNumPed  	:= SC7->C7_NUM		// Numero do Pedido de Compras
		Private	lImpPrc		:= .t.	// Imprime os Precos ?
		Private	nTitulo 	:= 2			// Titulo do Relatorio ?
		Private	cObserv1	:= ''			// 1a Linha de Observacoes
		Private	cObserv2	:= ''			// 2a Linha de Observacoes
		Private	cObserv3	:= ''			// 3a Linha de Observacoes
		Private	cObserv4	:= ''			// 4a Linha de Observacoes
		Private	lPrintCodFor:= .f.	// Imprime o Codigo do produto no fornecedor ?
	Endif
	DbSelectArea('SC7')
	SC7->(DbSetOrder(1))
	If	( ! SC7->(DbSeek(xFilial('SC7') + cNumPed)) )
		Help('',1,'UPEDCMP',,OemToAnsi('Pedido NO encontrado, Por favor valide el numero de documento.'),1)
		Return .f.
	EndIf
	Processa({ |lEnd| xPrintRel(),OemToAnsi('Generando el Reporte.')}, OemToAnsi('Espere...'))
	RestArea(aAreaSC7)
	RestArea(aAreaSA2)
	RestArea(aAreaSA5)
	RestArea(aAreaSF4)
Return


Static Function xPrintRel()
	Local _nT
	Static nPagAtu   := 1
	cFileLogo := "logotipopng.bmp"
	If !File(cFileLogo)
		cFileLogo := "logotipopng.bmp"//"lgrl" + cEmpAnt + cFilAnt + ".bmp"
	EndIf
	Private lEmail	:= .f.
	Private	lFlag	:= .t.,;	// Controla a impressao do fornecedor
	nLinha		:= 3000,;	// Controla a linha por extenso
	nLinFim		:= 0,;		// Linha final para montar a caixa dos itens
	lPrintDesTab:= .f.,;	// Imprime a Descricao da tabela (a cada nova pagina)
	cRepres		:= Space(80)

	Private	_nQtdReg	:= 0,;		// Numero de registros para intruir a regua
	_nValMerc 	:= 0,;		// Valor das mercadorias
	_nValIPI	:= 0,;		// Valor do I.P.I.
	_nValDesc	:= 0,;		// Valor de Desconto
	_nTotAcr	:= 0,;		// Valor total de acrescimo
	_nTotSeg	:= 0,;		// Valor de Seguro
	cTexto      := "",;
		cCompr      := "",;
		_nTotFre	:= 0		// Valor de Frete
	_nTotIcmsRet:= 0		// Valor do ICMS Retido KILDARE
	_nTotIPC    := 0		// Valor do IPC
	DbSelectArea('SA2')
	SA2->(DbSetOrder(1))
	If	! SA2->(DbSeek(xFilial('SA2')+SC7->(C7_FORNECE+C7_LOJA)))
		Help('',1,'REGNOIS')
		Return .f.
	EndIf
	lViewPDF := !lEmail
	lAdjustToLegacy := .T.   //.F.
	lDisableSetup  := .T.
	cFilename := Criatrab(Nil,.F.)
	oPrint := FWMSPrinter():New(cFilename, IMP_PDF, lAdjustToLegacy, , lDisableSetup,,,,,,,lViewPDF)
	oPrint:Setup()
	oPrint:SetResolution(78)
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:SetPaperSize(DMPAPER_A4)
	oPrint:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior
	oPrint:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF
	cDiretorio := oPrint:cPathPDF
	Private	oBrush		:= TBrush():New(,4),;
		oPen		:= TPen():New(0,5,CLR_BLACK),;
		cFileLogo	:= GetSrvProfString('Startpath','') + "logotipopng.bmp",;
		oFont07		:= TFont():New( "Arial",,07,,.t.,,,,,.f. )
	oFont08		:= TFont():New( "Arial",,09,,.f.,,,,,.f. )
	oFont08n    := TFont():New( "Arial",,09,,.t.,,,,,.f. )
	oFont09		:= TFont():New( "Arial",,09,,.f.,,,,,.f. )
	oFont10		:= TFont():New( "Arial",,09,,.f.,,,,,.f. )
	oFont10n	:= TFont():New( "Arial",,09,,.t.,,,,,.f. )
	oFont11		:= TFont():New( "Arial",,10,,.f.,,,,,.f. )
	oFont11n	:= TFont():New( "Arial",,10,,.t.,,,,,.f. )
	oFont12		:= TFont():New( "Arial",,11,,.f.,,,,,.f. )
	oFont12n	:= TFont():New( "Arial",,11,,.t.,,,,,.f. )
	oFont14		:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
	oFont15		:= TFont():New( "Arial",,12,,.f.,,,,,.f. )
	oFont18		:= TFont():New( "Arial",,14,,.f.,,,,,.f. )
	oFont16		:= TFont():New( "Arial",,14,,.f.,,,,,.f. )
	oFont16n	:= TFont():New( "Arial",,14,,.t.,,,,,.f. )
	oFont20		:= TFont():New( "Arial",,24,,.f.,,,,,.f. )
	oFont22		:= TFont():New( "Arial",,24,,.f.,,,,,.f. )

	cSELECT :=	"SC7.C7_FILIAL, SC7.C7_NUM, SC7.C7_EMISSAO, SC7.C7_FORNECE, SC7.C7_LOJA, SC7.C7_COND, SC7.C7_CONTATO, SC7.C7_OBS, "+;
		"SC7.C7_ITEM, SC7.C7_UM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_QUANT, SC7.C7_XOBSG, SC7.C7_USER,  "+;
		"SC7.C7_PRECO, SC7.C7_IPI, SC7.C7_TOTAL, SC7.C7_VLDESC, SC7.C7_DESPESA, "+;
		"SC7.C7_SEGURO, SC7.C7_VALFRE, SC7.C7_TES, SC7.C7_VALIMP1, '' C7_VALIMP8, SC7.C7_VALIMP4, SC7.C7_VALIMP7  ,SC7.C7_DATPRF, SC7.C7_USER, '' as C7_XLINPRE, SC7.C7_ITEMCTA, SC7.C7_MOEDA,SC7.C7_CC,SC7.C7_NUMSC,SC7.C7_CONTRA,  "+;
		"COALESCE(CAST(CAST(SC7.C7_OBSM AS VARBINARY(8000)) AS VARCHAR(8000)),' ') C7_OBSM"
	cFROM   :=	RetSqlName('SC7') + ' SC7 '
	cWHERE  :=	'SC7.D_E_L_E_T_ <>   '+CHR(39) + '*'            +CHR(39) + ' AND '+;
		'SC7.C7_FILIAL  =    '+CHR(39) + xFilial('SC7') +CHR(39) + ' AND '+;
		'SC7.C7_NUM     =    '+CHR(39) + cNumPed        +CHR(39)
	cORDER  :=	'SC7.C7_FILIAL, SC7.C7_ITEM '
	cQuery  :=	' SELECT '   + cSELECT + ;
		' FROM '     + cFROM   + ;
		' WHERE '    + cWHERE  + ;
		' ORDER BY ' + cORDER
	TCQUERY cQuery NEW ALIAS 'TRA'
	TcSetField('TRA','C7_DATPRF','D')
	If	! USED()
		MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
	EndIf
	DbSelectArea('TRA')
	Count to _nQtdReg
	ProcRegua(_nQtdReg)
	TRA->(DbGoTop())

	cTipoSC7	:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")
	cCompr   	:= UsrFullName(SC7->C7_USER)
	cAlter	 	:= ''
	cAprov	 	:= ''
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
				cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
	cObServ := ''
	While 	TRA->( ! Eof() )
		cTexto := alltrim (TRA->C7_XOBSG)
		xVerPag()
		If	( lFlag )
			oPrint:Say(0340,0100,OemToAnsi('RAZON SOCIAL:'),oFont11n)
			oPrint:Say(0340,0460,AllTrim(SA2->A2_NOME),oFont11)
			oPrint:Say(0380,0100,OemToAnsi('N.I.T. / C.C.:'),oFont11n)
			oPrint:Say(0380,0460,Transform(SA2->A2_CGC,'@R 9999999999-99'),oFont11)
			oPrint:Say(0420,0100,OemToAnsi('LUGAR DE ENTREGA:'),oFont11n)
			oPrint:Say(0420,0490,OemToAnsi('Cl 27 No. 7A - 01. PLANTA FUNZA'),oFont11)
			oPrint:Say(0300,1500,OemToAnsi('FECHA:'),oFont11n)
			oPrint:Say(0300,1810,Dtoc(SC7->C7_EMISSAO),oFont11)
			oPrint:Say(0340,1500,OemToAnsi('DIAS DE PAGO:'),oFont11n)
			If SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+SC7->C7_COND))
				oPrint:Say(0340,1820, SE4->E4_DESCRI,oFont11)
			Endif
			oPrint:Say(0380,1500,OemToAnsi('TELEFONO:'),oFont11n)
			oPrint:Say(0380,1810,SA2->A2_TEL,oFont11)
			oPrint:Say(0420,1500,OemToAnsi('DIRECCION:'),oFont11n)
			oPrint:Say(0420,1810,alltrim(SA2->A2_END)+' - '+AllTrim(SA2->A2_MUN)+' - '+AllTrim(SA2->A2_EST) ,oFont11)
			oPrint:Say(110,1980,SC7->C7_NUM,oFont16n)
			lFlag := .f.
		EndIf

		If	(lPrintDesTab)
			nLinha := 480
			oPrint:Box(nLinha,100,nLinha+70,2330)
			oPrint:Say(nLinha+35,0250,OemToAnsi('ARTICULO'),oFont11n)
			oPrint:Say(nLinha+35,0860,OemToAnsi('CANTIDAD'),oFont11n)
			oPrint:Say(nLinha+35,1060,OemToAnsi('UN'),oFont11n)
			oPrint:Say(nLinha+35,1280,OemToAnsi('FEC ENTREG'),oFont11n)
			oPrint:Say(nLinha+35,1500,OemToAnsi('VR. UNITARIO'),oFont11n)
			oPrint:Say(nLinha+35,1880,OemToAnsi('VR. TOTAL'),oFont11n)
			lPrintDesTab := .f.
			nLinha += 110
		EndIf
		cCodPro := ''
		cCodPro := TRA->C7_PRODUTO
		oPrint:Say(nLinha,0860,TransForm(TRA->C7_QUANT,'@E 99,999,999,999.99'),oFont10n)
		oPrint:Say(nLinha,1060,TRA->C7_UM,oFont10)
		oPrint:Say(nLinha,1280,DtoC(TRA->C7_DATPRF),oFont10n,,,,1)
		oPrint:Say(nLinha,1500,TransForm(TRA->C7_PRECO,'@E 99,999,999,999.99'),oFont10n)
		oPrint:Say(nLinha,1880,TransForm(TRA->C7_TOTAL,'@E 99,999,999,999.99'),oFont10n)
		SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+TRA->C7_PRODUTO))
		cDesc := AllTrim(SB1->B1_DESC) + " - " + alltrim(TRA->C7_OBSM)
		For _nT := 1 to MLCount( cDesc,36 )
			oPrint:Say(nLinha,0090,MemoLine( cDesc, 36, _nT ),oFont11)
			nLinha += 30
		Next _nT

		nLinha+=30
		_nValMerc 		+= TRA->C7_TOTAL
		_nValIPI		+= (TRA->C7_TOTAL * TRA->C7_IPI) / 100
		_nValDesc		+= TRA->C7_VLDESC
		_nTotAcr		+= TRA->C7_DESPESA
		_nTotSeg		+= TRA->C7_VALIMP4
		_nTotFre		+= TRA->C7_VALIMP7
		If	( Empty(TRA->C7_TES) )
			_nTotIcmsRet	+= TRA->C7_VALIMP1
		Else
			DbSelectArea('SF4')
			SF4->(DbSetOrder(1))
			If	SF4->(DbSeek(xFilial('SF4') + TRA->C7_TES))
				If	( AllTrim(SF4->F4_INCSOL) == 'S' )
					_nTotIcmsRet	+= TRA->C7_VALIMP1
				EndIf
			EndIf
		EndIf

		If	( Empty(TRA->C7_TES) )
			_nTotIPC 	+= TRA->C7_VALIMP8
		Else
			DbSelectArea('SF4')
			SF4->(DbSetOrder(1))
		EndIf

		IncProc()
		TRA->(DbSkip())
		If nLinha >= 2400

 			oPrint:Say(nLinha,0100,"NOTA: EL RECIBO DE MERCANCIA ES DE LUNES A VIERNES DE 7:00 AM 4:00 PM ",oFont11n)
			nLinha += 30
			oPrint:Say(nLinha,0100,"UNICAMENTE",oFont11n)
			nLinha += 50
			oPrint:Say(2760,0030, UPPER(cCompr) ,oFont11)
			oPrint:Say(2790,0030, "__________________________",oFont11)
			oPrint:Say(2840,0060, "Elaborado.          ",oFont11)
			oPrint:Say(2790,0610, "__________________________",oFont11)
			oPrint:Say(2840,0630, "Firma y Sello.       ",oFont11)
			oPrint:Say(2790,1410, "__________________________",oFont11)
			oPrint:Say(2840,1430, "Solicitado         ",oFont11)
			oPrint:Say(2990,0033, "Pagos unicamente Lunes. Confirmacion telefonica 11:30 a.m. a 5:00 p.m.",oFont12n)
			oPrint:Say(3030,0030, "El No de Remision  y No. Orden de Compra deben estar en la FACTURA.",oFont12)
			oPrint:EndPage()
			oPrint:StartPage()
			xCabec()
			oPrint:Say(0340,0100,OemToAnsi('RAZON SOCIAL:'),oFont11n)
			oPrint:Say(0340,0460,AllTrim(SA2->A2_NOME),oFont11)
			oPrint:Say(0380,0100,OemToAnsi('N.I.T. / C.C.:'),oFont11n)
			oPrint:Say(0380,0460,Transform(SA2->A2_CGC,'@R 9999999999-99'),oFont11)
			oPrint:Say(0420,0100,OemToAnsi('LUGAR DE ENTREGA:'),oFont11n)
			oPrint:Say(0420,0490,OemToAnsi('Cl 27 No. 7A - 01. PLANTA FUNZA'),oFont11)
			oPrint:Say(0300,1500,OemToAnsi('FECHA:'),oFont11n)
			oPrint:Say(0300,1810,Dtoc(SC7->C7_EMISSAO),oFont11)
			oPrint:Say(0340,1500,OemToAnsi('DIAS DE PAGO:'),oFont11n)
			If SE4->(dbSetOrder(1), dbSeek(xFilial("SE4")+SC7->C7_COND))
				oPrint:Say(0340,1820, SE4->E4_DESCRI,oFont11)
			Endif
			oPrint:Say(0380,1500,OemToAnsi('TELEFONO:'),oFont11n)
			oPrint:Say(0380,1810,SA2->A2_TEL,oFont11)
			oPrint:Say(0420,1500,OemToAnsi('DIRECCION:'),oFont11n)
			oPrint:Say(0420,1810,alltrim(SA2->A2_END)+' - '+AllTrim(SA2->A2_MUN)+' - '+AllTrim(SA2->A2_EST) ,oFont11)
			oPrint:Say(110,1980,SC7->C7_NUM,oFont16n)
			lFlag := .f.
			nLinha := 510
			oPrint:Box(nLinha,100,nLinha+70,2330)
			oPrint:Say(nLinha+40,0250,OemToAnsi('ARTICULO'),oFont11n)
			oPrint:Say(nLinha+40,0860,OemToAnsi('CANTIDAD'),oFont11n)
			oPrint:Say(nLinha+40,1060,OemToAnsi('UN'),oFont11n)
			oPrint:Say(nLinha+40,1280,OemToAnsi('FEC ENTREG'),oFont11n)
			oPrint:Say(nLinha+40,1500,OemToAnsi('VR. UNITARIO'),oFont11n)
			oPrint:Say(nLinha+40,1880,OemToAnsi('VR. TOTAL'),oFont11n)
			nLinha:= 630
		EndIf

	End
	//nLinha-=30
	xVerPag()
	xRodape()
	TRA->(DbCloseArea())
	oPrint:Preview()

Return


Static Function xCabec()
	oPrint:SayBitmap(005,010,cFileLogo,792,244)
	oPrint:Say(294,110,TransForm(SM0->M0_CGC,'@R 999999999-99'),oFont12n)
	oPrint:Say(090,850,AllTrim(Upper(SM0->M0_NOMECOM)),oFont12n)
	oPrint:Say(130,850,UPPER(AllTrim(SM0->M0_ENDCOB)),oFont12n)
	oPrint:Say(170,850,UPPER(AllTrim(SM0->M0_CIDCOB))+' - Tel:' + " 8258066 / 67 / 68",oFont12n)
	oPrint:Say(210,850,SM0->M0_INSC,oFont12n)
	//oPrint:Line(265,100,265,1270)
	oPrint:Box(030,1800,0150,2300)
	oPrint:Say(060,1830,OemToAnsi(UPPER('Orden de Compra')),oFont12n)
	cTextoDir := "Página No:" + cValToChar(nPagAtu)
	oPrint:Say(020,1830, cTextoDir,oFont12)
	oPrint:EndPage()
	nPagAtu++
Return


Static Function xRodape()
    Local nI := 0  //Definimos esta Variable Local para migracion M&H enero 2022
	nLinha := 2000
	oPrint:Line(nLinha,100,nLinha,2300)
	oPrint:Line(nLinha,1390,nLinha+60,1390)
	oPrint:Line(nLinha,1900,nLinha+60,1900)
	oPrint:Line(nLinha,2300,nLinha+60,2300)
	oPrint:Say(nLinha+30,1400,'Subtotal',oFont12)
	oPrint:Say(nLinha+30,2050,TransForm(_nValMerc,'@E 99,999,999,999.99'),oFont11,,,,1)
	nLinha += 60
	oPrint:Line(nLinha,1390,nLinha,2300)
	//xVerPag()
	oPrint:Line(nLinha,1390,nLinha+60,1390)
	oPrint:Line(nLinha,1900,nLinha+60,1900)
	oPrint:Line(nLinha,2300,nLinha+60,2300)
	oPrint:Say(nLinha+30,1400,'IVA',oFont12)
	oPrint:Say(nLinha+30,2050,TransForm(_nTotIcmsRet,'@E 99,999,999,999.99'),oFont11,,,,1)
	nLinha += 60
	oPrint:Line(nLinha,1390,nLinha,2300)
	xVerPag()
	oPrint:Line(nLinha,1390,nLinha+60,1390)
	oPrint:Line(nLinha,1900,nLinha+60,1900)
	oPrint:Line(nLinha,2300,nLinha+60,2300)
	oPrint:Say(nLinha+30,1400,'VALOR TOTAL ',oFont14)
	//oPrint:Say(nLinha+30,2050,TransForm(_nValMerc + _nValIPI - _nValDesc + _nTotAcr	+ _nTotSeg + _nTotFre + _nTotIcmsRet + _nTotIPC,'@E 99,999,999,999.99'),oFont11,,,,1)
	oPrint:Say(nLinha+30,2050,TransForm(_nValMerc - _nValDesc + _nTotIcmsRet ,'@E 99,999,999,999.99'),oFont11,,,,1)  // Modificado GAP 20-01-2022
	nLinha += 60
	nValor := 0
	xVerPag()
	oPrint:Line(nLinha,1390,nLinha,2300)
	nLinha += 60
	xVerPag()
	nValTot := 0
	nValTot := _nValMerc + _nValIPI - _nValDesc + _nTotAcr	+ _nTotSeg + _nTotFre + _nTotIcmsRet + _nTotIPC
	nValor := Extenso(nValTot,.F.,1,,"2",.t.,.t.)
	oPrint:Say(nLinha,0100,"SON: "+nValor,oFont12)
	nLinha += 50
	xVerPag()
	oPrint:Say(nLinha,0100,"NOTA: EL RECIBO DE MERCANCIA ES DE LUNES A VIERNES DE 7:00 AM 4:00 PM ",oFont11n)
	nLinha += 30
	xVerPag()
	oPrint:Say(nLinha,0100,"UNICAMENTE",oFont11n)
	nLinha += 50
	xVerPag()
	nI := 1
	For nI := 1 to MLCount( cTexto, 65 )
		oPrint:Say(nLinha,0090,MemoLine( cTexto, 65, nI ),oFont11)
		nLinha += 40
	Next nI
	nLinha += 50
	xVerPag()
	oPrint:Say(2760,0030, UPPER(cCompr) ,oFont11)
	oPrint:Say(2790,0030, "__________________________",oFont11)
	oPrint:Say(2840,0060, "Elaborado.          ",oFont11)
	oPrint:Say(2790,0610, "__________________________",oFont11)
	oPrint:Say(2840,0630, "Firma y Sello.       ",oFont11)
	oPrint:Say(2790,1410, "__________________________",oFont11)
	oPrint:Say(2840,1430, "Solicitado         ",oFont11)
	oPrint:Say(2990,0033, "Pagos unicamente Lunes. Confirmacion telefonica 11:30 a.m. a 5:00 p.m.",oFont12n)
	oPrint:Say(3030,0030, "El No de Remision  y No. Orden de Compra deben estar en la FACTURA.",oFont12)

Return

Static Function xVerPag()
	If	( nLinha >= 2800 )
		If	(!lFlag)
			xRodape()
			oPrint:EndPage()
			nLinha:= 600
		Else
			nLinha:= 800
		EndIf
		oPrint:StartPage()
		xCabec()
		lPrintDesTab := .t.
	EndIf
Return
