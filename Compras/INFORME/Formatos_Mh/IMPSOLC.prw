#Include "RwMake.ch"
#Include "TopConn.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  IMPSOLC  ºAutor  ³	Erick Etcheverry 		 º 07/12/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion ³Impresion de solicitud de compra	 	 	 	 	          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ACME LEON			      			                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPSOLC()
	Processa({|| fImpPres()},"Impresion de solicitud ","Imprimiendo solicitud...")
Return
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function fImpPres()
	Local lPrint	:= .f.
	Local nVias		:= 1
	Local nLin		:= 00.0
	Local cQuery
	Local consulta
	Local nDesc    := 00.0
	Local nRecargo := 00.0
	Local aDtHr		:= {}
	Local _aEtiq :={}
	Private nPag	:= 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define as fontes a serem utilizadas na impressao                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oFont10T  := TFont():New("Times New Roman",10,10,,.f.)
	oFont12T  := TFont():New("Times New Roman",12,12,,.f.)
	oFont14T  := TFont():New("Times New Roman",14,14,,.f.)
	oFont16T  := TFont():New("Times New Roman",16,16,,.f.)
	oFont18T  := TFont():New("Times New Roman",18,18,,.f.)

	oFont10TN  := TFont():New("Times New Roman",10,10,,.t.)
	oFont12TN  := TFont():New("Times New Roman",12,12,,.t.)
	oFont14TN  := TFont():New("Times New Roman",14,14,,.t.)
	oFont16TN  := TFont():New("Times New Roman",16,16,,.t.)
	oFont18TN  := TFont():New("Times New Roman",18,18,,.t.)

	oFont08C  := TFont():New("Courier New",08.8,08.8,,.f.)
	oFont09C  := TFont():New("Courier New",09,09,,.f.)
	oFont10C  := TFont():New("Courier New",09,09,,.f.)
	oFont12C  := TFont():New("Courier New",12,12,,.f.)
	oFont14C  := TFont():New("Courier New",14,14,,.f.)
	oFont16C  := TFont():New("Courier New",16,16,,.f.)
	oFont18C  := TFont():New("Courier New",18,18,,.f.)

	oFont09CN  := TFont():New("Courier New",09,09,,.t.)
	oFont10CN  := TFont():New("Courier New",10,10,,.t.)
	oFont12CN  := TFont():New("Courier New",12,12,,.t.)
	oFont14CN  := TFont():New("Courier New",14,14,,.t.)
	oFont16CN  := TFont():New("Courier New",16,16,,.t.)
	oFont18CN  := TFont():New("Courier New",18,18,,.t.,,,,,.t.)
	oFont20CN  := TFont():New("Courier New",20,20,,.t.)
	oFont22CN  := TFont():New("Courier New",22,22,,.t.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia o uso da classe ...                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrn:= TMSPrinter():New("Solicitud de compra")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define pagina no formato paisagem ...        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrn:SetPortrait()

	oPrn:Setup()

	cQuery := " SELECT C1_SOLICIT,C1_FORNECE,A2_NOME,C1_EMISSAO,C1_PRODUTO,B1_DESC,C1_QUANT,C1_UM,C1_NUM,C1_DATPRF   "
	cQuery += "FROM " + RetSqlName("SC1") + " SC1 "
	cQuery += "JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = C1_PRODUTO AND SB1.D_E_L_E_T_ = ' '   "
	cQuery += "LEFT JOIN " + RetSqlName("SA2") + " SA2 ON A2_COD = C1_FORNECE AND A2_LOJA = C1_LOJA  AND SA2.D_E_L_E_T_ = ' '  "
	cQuery += " WHERE C1_FILIAL = '"+trim(XFILIAL("SC1"))+"' "
	//cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += " AND C1_NUM = '"+trim(SC1->C1_NUM)+"' "
	cQuery += " AND C1_IMPORT <> 'S' AND SC1.D_E_L_E_T_ = ' ' "
	cQuery += " order by C1_PRODUTO "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
	//³ Caso area de trabalho estiver aberta, fecha... ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	If !Empty(Select("TRB"))
		dbSelectArea("TRB")
		dbCloseArea()
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
	//³ Executa query ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	TcQuery cQuery New Alias "TRB"
	dbSelectArea("TRB")
	dbGoTop()

	nLindet := 04.1
	nPag := 1
	cNroProforma:=""
	dfecha:=""

	cxSolicit := C1_SOLICIT

	while !EOF()

		dfecha:= C1_EMISSAO

		If nPag == 1 .and. C1_NUM <> cNroProforma .and.cNroProforma==""
			cNroProforma :=C1_NUM
			oPrn:StartPage()
		elseif C1_NUM <> cNroProforma
			cNroProforma :=C1_NUM

			nLindet := fImpTotales(nLindet+0.5,cxSolicit)
			nPag++
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := 01.0
			nLin := fImpCabec(nLin)
			nLindet := 04.1

		end

		IF nLindet == 04.1 .AND. nPag == 1
			nLin := 01.0
			nLin := fImpCabec(nLin)
		ENDIF

		nLindetcab := 04.1
		nLindetcab := fImpItemCab(nLindetcab)

		nLindet := fImpItem(nLindet)

		If nLindet > 22
			nPag+=1
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := 01.0
			nLin := fImpCabec(nLin)
			nLindet := 04.1
		Endif

		dbSkip()

	Enddo

	nLindet := fImpTotales(nLindet+0.5,cxSolicit)

	oPrn:EndPage()

	oPrn:Preview()

	TRB->(dbCloseArea())

RETURN

Static Function fImpItemCab(nLin)

	// ARTICULO	NOMBRE	PROCEDENCIA	UNIDAD	CANTIDAD	PRECIO	MONTO

	oPrn:Say( Tpix(nLin+00.0), Tpix(01.0), "__________________________________________________________________________________________________________________"	, oFont12C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(01.0), "CODIGO", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(02.9), "NOMBRE DEL PRODUCTO", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(11.8), "CANTIDAD", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(13.9), "UNIDAD", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(15.5), "NUMERO", oFont10C)
	oPrn:Say( Tpix(nLin+00.5), Tpix(18.1), "F.ENTREGA", oFont10C)
	oPrn:Say( Tpix(nLin+00.7), Tpix(01.0), "___________________________________________________________________________________________________________________"	, oFont12C)

Return(nLin+02.0)

Static Function fImpItem(nLin)

	oPrn:Say( Tpix(nLin+01.5), Tpix(01.0), C1_PRODUTO, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(02.9),B1_DESC , oFont08C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(11.8), Transform(C1_QUANT,"@A 999,999"), oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(13.9), C1_UM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(15.5),C1_NUM, oFont10C)
	oPrn:Say( Tpix(nLin+01.5), Tpix(18.1), dtoc(stod(C1_DATPRF)) , oFont10C)

	nLin:= nLin+00.6

Return(nLin)

Static Function TPix(nTam,cBorder,cTipo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desconta area nao imprimivel (Lexmark Optra T) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cBorder == "lb"			// Left Border
		nTam := nTam - 0.40
	ElseIf cBorder == "tb" 		// Top Border
		nTam := nTam - 0.60
	EndIf

	nPix := nTam * 120

Return(nPix)

Static Function fImpCabec(nLin)

	cFlogo := GetSrvProfString("Startpath","") + "AcmeLeon.png"
	oPrn:SayBitmap(170,120, cFlogo,370,250)

	oPrn:Say( Tpix(nLin+00.5), Tpix(4.5), "SOLICITUD DE COMPRAS MATERIA PRIMA", oFont16CN)
	oPrn:Say( Tpix(nLin+01.2), Tpix(4.5), "Fecha: "+ ffechalarga(C1_EMISSAO), oFont10CN) // CJ_EMISSAO
	oPrn:Say( Tpix(nLin+01.2), Tpix(16.0), "No. " + C1_NUM 			, oFont10CN)
	oPrn:Say( Tpix(nLin+01.9), Tpix(4.5), "Proveedor: " + alltrim(A2_NOME), oFont10CN)

Return(nLin+05.4)

Static Function fImpTotales(nLin,cElaborado)

	oPrn:Say( Tpix(nLin+05.0), Tpix(04.0), "Elaboro"															, oFont10C)
	oPrn:Say( Tpix(nLin+05.0), Tpix(14.0), "Autorizo"															, oFont10C)
	oPrn:Say( Tpix(nLin+04.3), Tpix(04.0), cUserName																, oFont10C)
	oPrn:Say( Tpix(nLin+04.5), Tpix(04.0), "_____________"															, oFont10C)
	oPrn:Say( Tpix(nLin+04.5), Tpix(13.5), "_____________"															, oFont10C)

Return(nLin+06.0)

Static Function ffechalarga(sfechacorta)

	//20101105

	Local sFechalarga:=""
	Local descmes := ""
	Local sdia:=substr(sfechacorta,7,2)
	Local smes:=substr(sfechacorta,5,2)
	Local sano:=substr(sfechacorta,0,4)

	if smes=="01"
		descmes :="Enero"
	endif
	if smes=="02"
		descmes :="Febrero"
	endif
	if smes=="03"
		descmes :="Marzo"
	endif
	if smes=="04"
		descmes :="Abril"
	endif
	if smes=="05"
		descmes :="Mayo"
	endif
	if smes=="06"
		descmes :="Junio"
	endif
	if smes=="07"
		descmes :="Julio"
	endif
	if smes=="08"
		descmes :="Agosto"
	endif
	if smes=="09"
		descmes :="Septiembre"
	endif
	if smes=="10"
		descmes :="Octubre"
	endif
	if smes=="11"
		descmes :="Noviembre"
	endif
	if smes=="12"
		descmes :="Diciembre"
	endif

	sFechalarga := sdia + " de " + descmes + " de " + sano

Return(sFechalarga)

Static Function diferencia(sfechafin,sfechaini)

	//20101105

	Local diasdia:=0
	Local diasmes:=0
	Local diasano:=0
	Local sdiafin:=val(substr(sfechafin,7,2))
	Local smesfin:=val(substr(sfechafin,5,2))
	Local sanofin:=val(substr(sfechafin,0,4))

	Local sdiaini:=val(substr(sfechaini,7,2))
	Local smesini:=val(substr(sfechaini,5,2))
	Local sanoini:=val(substr(sfechaini,0,4))

	if sdiafin>=sdiaini
		diasdia:=sdiafin-sdiaini
	else
		diasdia := (30+sdiafin)-sdiaini
		smesfin:=smesfin-1
	endif

	if smesfin<smesini
		diasmes:=((smesfin+12)-smesini)*30
	else
		diasmes := (smesfin-smesini)*30
	endif

	diferencia:=diasdia + diasmes

Return(diferencia)

Static Function cCodUser(cNomeUser)
	Local _IdUsuario:= ""
	/*±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±³  ³ PswOrder(nOrder): seta a ordem de pesquisa   ³±±
	±±³  ³ nOrder -> 1: ID;                             ³±±
	±±³  ³           2: nome;                           ³±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
	PswOrder(2)
	If pswseek(cNomeUser,.t.)
		_aUser      := PswRet(1)
		_IdUsuario  := _aUser[1][1]      // Código de usuario
	Endif

Return(_IdUsuario)
