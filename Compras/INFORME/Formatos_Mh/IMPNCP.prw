#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPNCC ³Erick Etcheverry Peña		 º Data ³  21/12/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emision de nota de credito   			                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ Emision de nota de credito Nacional                     	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPNCP()  //U_GFATI301()
	FatLocal('Nota Credito Proveedor',.F.)
Return nil

Static function FatLocal(cTitulo,bImprimir)
	Local nLinInicial := 1
	Private oPrn    := NIL
	Private oFont10  := NIL
	Private lPrevio	:=.T.

	oPrn := TMSPrinter():New(cTitulo)
	oPrn:Setup()
	oPrn:SetCurrentPrinterInUse()
	oPrn:SetPortrait()
	oPrn:setPaperSize(DMPAPER_LETTER)

	DEFINE FONT oFont08 NAME "Arial" SIZE 0,08 OF oPrn
	DEFINE FONT oFont09 NAME "Arial" SIZE 0,09 OF oPrn
	DEFINE FONT oFont10 NAME "Arial" SIZE 0,10 OF oPrn
	DEFINE FONT oFont10N NAME "Arial" SIZE 0,10 Bold  OF oPrn
	DEFINE FONT oFont105N NAME "Arial" SIZE 0,10.5 Bold  OF oPrn
	DEFINE FONT oFont11 NAME "Arial" SIZE 0,11  OF oPrn
	DEFINE FONT oFont11N NAME "Arial" SIZE 0,11 Bold  OF oPrn
	DEFINE FONT oFont12 NAME "Arial" SIZE 0,12 OF oPrn
	DEFINE FONT oFont12N NAME "Arial" SIZE 0,12 Bold  OF oPrn
	FatMat(cTitulo,bImprimir,1,nLinInicial) //Impresion de factura

return Nil
static function FatMat(cTitulo,bImprimir,nLinInicial) //Datos Maestro de factura; ,nLinInicial
	Local aDupla   := {}
	Local aDetalle := {}
	Local nCantReg := 0
	Local bSw	   := .T.
	Local cMsgFat  := ""
	Local NextArea := GetNextAlias()
	Local cDireccion := ""
	Local cTelefono := ""
	Local cFilFact := ""
	LOCAL cF2udir := ""
	LOCAL cF2unom := ""
	LOCAL cF2unit := ""
	local cF2vend := ""
	local ccserie := ""

	Local cSql	:= "SELECT F2_FILIAL,F2_SERIE,F2_DOC,F2_EMISSAO,F2_COND,F2_VALBRUT,ROUND(F2_DESCONT,2) F2_DESCONT,F2_BASIMP1,D2_PEDIDO,A2_MUN, A2_BAIRRO,A2_END,A2_NOME"
	cSql		:= cSql+",F2_CLIENTE,F2_LOJA,F2_ESPECIE,F2_VEND1,D2_SERIORI,D2_NFORI,A2_CGC "
	cSql		:= cSql+" FROM " + RetSqlName("SF2") +" SF2 JOIN " + RetSqlName("SD2") +" SD2 ON (D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_LOJA=F2_LOJA AND SD2.D_E_L_E_T_ = ' '  AND D2_ITEM = '01' AND D2_ESPECIE = 'NCP' )"
	cSql		:= cSql+" LEFT JOIN " + RetSqlName("SA2") +" SA2 ON A2_COD = F2_CLIENTE AND A2_LOJA = F2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
	cSql		:= cSql+" WHERE F2_FILIAL= '" + xFilial("SF2") + "' AND F2_DOC= '" + alltrim(SF2->F2_DOC) + "' AND F2_SERIE='" + alltrim(SF2->F2_SERIE) + "' AND F2_ESPECIE = 'NCP' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()

	cValfat := 0
	cnfori := D2_NFORI
	ccserie := D2_SERIORI

	///pedido compra original
	cxPed := GetAdvFVal("SD1","D1_PEDIDO",F2_FILIAL+cnfori+ccserie+F2_CLIENTE+F2_LOJA,1,"")	//CODIGO ORDEN COMPRA

	AADD(aDupla,F2_FILIAL)		  	//1
	AADD(aDupla,F2_SERIE)           //2
	AADD(aDupla,F2_DOC)             //3
	AADD(aDupla,'')          //4 nroautorizacion
	AADD(aDupla,F2_EMISSAO)         //5
	AADD(aDupla,alltrim(F2_CLIENTE) + ' - ' + ALLTRIM(A2_NOME))         //6//nombre
	AADD(aDupla,A2_CGC)            //7 nit cliente
	AADD(aDupla,F2_COND)            //8 //condicionpago
	AADD(aDupla,F2_VALBRUT)          //9
	AADD(aDupla,F2_DESCONT)         //10
	AADD(aDupla,F2_BASIMP1)  		//11
	AADD(aDupla,)          //12
	AADD(aDupla,'')          //13
	AADD(aDupla,cxPed)		    //14 nropedido
	AADD(aDupla,A2_MUN)		    	//15
	AADD(aDupla,A2_BAIRRO)		    //16
	AADD(aDupla,A2_END)		    //17
	AADD(aDupla,'')		    //18
	AADD(aDupla,F2_CLIENTE)		    //19
	AADD(aDupla,F2_LOJA)		    //20
	AADD(aDupla,F2_ESPECIE)		    //21
	AADD(aDupla,cnfori)			    //22 ??? FP_SFC
	AADD(aDupla,ccserie)			    //23 ??? FP_SFC
	AADD(aDupla,cValfat)//24

	aDetalle:= FatDet (F2_DOC,F2_SERIE)                	   	//Datos detalle de factura

	nCantReg:=len(aDetalle)
	cFilFact := aDupla[1]
	DbSelectArea("SM0")
	SM0->(DBSETORDER(1))
	SM0->(DbSeek(cEmpAnt+cFilFact))

	cDireccion := AllTrim(SM0->M0_ENDENT)+"; "+ AllTrim(SM0->M0_CIDENT)
	cTelefono := "Telefono: "+AllTrim(SM0->M0_TEL)+If(!Empty(SM0->M0_FAX)," Fax: "+AllTrim(SM0->M0_FAX),"")

	FatImp(cTitulo,bImprimir,aDupla,aDetalle,nLinInicial,"ORIGINAL",cDireccion,cTelefono)    	//Imprimir Factura

	dbSelectArea(NextArea)
	aDupla:={}

	#IFDEF TOP
		dBCloseArea(NextArea)
	#ENDIF

	oPrn:Refresh()
	If bImprimir
		oPrn:Print()
	Else
		oPrn:Preview()
	End If

	oPrn:End()

return aDupla

static function FatImp(cTitulo,bImprimir,aMaestro,aDetalle,nLinInicial,cTipo,cDireccion,cTelefono)
	Local _nInterLin := 780
	Local aInfUser := pswret()
	Local nI:=0
	Local nDim:=0
	Default nLinInicial := 0

	nDim:=len(aDetalle)

	CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	_nInterLin += nLinInicial + 70

	For nI:=1 to nDim
		oPrn:Say(_nInterLin,100,aDetalle[nI][1],oFont10) //Codigo del Producto
		oPrn:Say(_nInterLin,320,aDetalle[nI][2],oFont08)  //Descripcion
		oPrn:Say(_nInterLin,1350,aDetalle[nI][6],oFont10)  //Local
		oPrn:Say(_nInterLin,1500,alltrim(FmtoValor(aDetalle[nI][3],14,2)),oFont10)  //Precio Unitario
		oPrn:Say(_nInterLin,1800,alltrim(FmtoValor(aDetalle[nI][4],14,2)),oFont10)  //Precio Unitario
		oPrn:Say(_nInterLin,2100,alltrim(FmtoValor(aDetalle[nI][5],16,2)),oFont10)  //Total

		_nInterLin:=_nInterLin+50
	Next

	PieFact(nLinInicial,aMaestro)

return nil

Static Function CabFact(nLinInicial,aMaestro,cTipo,cDireccion,cTelefono)
	Local cFecVen := ""
	Local nInDe
	oPrn:StartPage()

	/*cFLogoMarkas := GetSrvProfString("Startpath","") + "Logo01.bmp"
	oPrn:SayBitmap(090,80, cFLogoMarkas,400,180)*/

	oPrn:Say(180, 80, "ACME LEON PLASTICOS SAS" ,oFont11N )
	oPrn:Say(220, 80, "NIT 800039813 -2" ,oFont11N )
	oPrn:Say( 260, 80,"Direccion: CL 27 No. 7A-01"  ,oFont11N )
	oPrn:Say( 300, 80,"Teléfono(s): 8258066"  ,oFont11N )

	oPrn:Box( nLinInicial + 230 , 1620 ,  290 , 2300 )
	oPrn:Say( nLinInicial + 240, 1670,"Fecha: "  ,oFont11N )
	oPrn:Say( nLinInicial + 240, 2045,DTOC(STOD(aMaestro[5])) ,oFont11 )

	oPrn:Box( nLinInicial + 500 , 80 ,  630 , 1100 ) // nit

	oPrn:Box( nLinInicial + 500 , 1270 ,  630 , 2180 ) // parte

	oPrn:Say( nLinInicial + 450, 100,"Datos Proveedor " ,oFont11N )
	oPrn:Say( nLinInicial + 450, 1290,"Documentos Respaldo " ,oFont11N )

	oPrn:Say( nLinInicial + 510, 100,aMaestro[6] ,oFont11N ) // Nombre del Cliente

	oPrn:Say( nLinInicial + 570, 100, "NIT: " ,oFont11N )
	oPrn:Say( nLinInicial + 570, 290, aMaestro[7] ,oFont11N ) //NIT del Cliente

	oPrn:Say( nLinInicial + 510, 1290,"Doc. Proveedor: " ,oFont11N )
	oPrn:Say( nLinInicial + 510, 1590,alltrim(aMaestro[22]) +" - " + alltrim(aMaestro[23]),oFont11N) //Nro Factura
	oPrn:Say( nLinInicial + 570, 1290,"Orden de Compra: " ,oFont11N )
	oPrn:Say( nLinInicial + 570, 1620, alltrim(aMaestro[14])  ,oFont11N )

	oPrn:Say(nLinInicial + 680, 200, "DEVOLUCION DE MATERIA PRIMA" ,oFont12N ) 													//Nombre
	oPrn:Say(nLinInicial + 680, 1500, "DMP   " + alltrim(aMaestro[3]),oFont12N )

	oPrn:Say(nLinInicial + 780, 100, "CODIGO" ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 780, 310, "PRODUCTO" ,oFont11N )
	oPrn:Say(nLinInicial + 780, 1350, "BGA" ,oFont11N ) 												//Nombre
	//Nombre
	oPrn:Say(nLinInicial + 780, 1520, "CANT." ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 780, 1820, "Vr. UNT." ,oFont11N ) 													//Nombre
	oPrn:Say(nLinInicial + 780, 2110, "VR. TOTAL" ,oFont11N ) 													//Nombre

	oPrn:Box( nLinInicial + 775 , 80 ,  775 , 2370 )
	oPrn:Box( nLinInicial + 840 , 80 ,  840 , 2370 )
Return Nil

Static Function PieFact(nLinInicial,aMaestro)

	oPrn:Say(nLinInicial + 3000, 200, "Elaborado por: " + cUsername ,oFont11N )
	oPrn:Say(nLinInicial + 3000, 1050, "Revisado:" ,oFont11N )
	oPrn:Say(nLinInicial + 3000, 1800, "Aprobado:" ,oFont10N )

	oPrn:EndPage()

Return Nil

static function FatDet (cDoc,cSerie)
	Local 	aDupla		:= {}
	Local 	aDatos		:= {}
	Local 	cProducto	:= ""
	Local	cNombre		:= ""
	Local	nPrecio		:= 0
	Local	nCant		:= 0
	Local	nTotal		:= 0
	Local 	NextArea	:= GetNextAlias()

	Local   cSql		:= "SELECT D2_ITEM,B1_COD,B1_DESC,D2_LOCAL,D2_DTVALID,D2_QUANT,D2_PRCVEN, D2_TOTAL,D2_ITEM "
	cSql				:= cSql+"FROM " + RetSqlName("SD2") +" SD2 JOIN	" + RetSqlName("SB1") +" SB1 ON   D2_COD=B1_COD  AND SB1.D_E_L_E_T_=' '  "
	cSql				:= cSql+"where D2_DOC='"+cDoc+"' AND D2_SERIE='"+cSerie+"' AND D2_ESPECIE='NCP' AND SD2.D_E_L_E_T_=' ' "
	cSql				:= cSql+" ORDER BY SD2.D2_ITEM"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	While !Eof()
		cProducto	:=D2_ITEM
		cNombre		:=B1_DESC

		cPedido		:=""
		cItPedido	:=""
		nCant		:=D2_QUANT

		nPrecio		:=D2_PRCVEN

		nTotal		:= iif(nCant > 0,Round(nCant*nPrecio,2),D2_TOTAL)
		cxLocal := D2_LOCAL

		aDupla:={}
		AADD(aDupla,cProducto)  //1
		AADD(aDupla,cNombre)    //2
		AADD(aDupla,nCant)      //3
		AADD(aDupla,nPrecio)    //4
		AADD(aDupla,nTotal)     //5
		AADD(aDupla,cxLocal)     //6
		AADD(aDatos,aDupla)
		DbSkip()
	end do
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
return  aDatos

Static Function FmtoValor(cVal,nLen,nDec)
	Local cNewVal := ""
	If nDec == 2
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf

	cNewVal := PADL(cNewVal,nLen,CHR(32))

Return cNewVal
