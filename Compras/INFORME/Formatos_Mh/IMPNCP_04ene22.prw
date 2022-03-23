#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
#DEFINE DMPAPER_LETTER 1   // Letter 8 1/2 x 11 in

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IMPNCC �Erick Etcheverry Pe�a		 � Data �  21/12/21   ���
�������������������������������������������������������������������������͹��
���Descricao � Emision de nota de credito   			                  ���
�������������������������������������������������������������������������͹��
���Observacao� Emision de nota de credito Nacional                     	  ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	Local cSql	:= "SELECT F1_FILIAL,F1_SERIE,F1_DOC,F1_EMISSAO,F1_COND,F1_VALBRUT,ROUND(F1_DESCONT,2) F1_DESCONT,F1_BASIMP1,D1_PEDIDO,A2_MUN, A2_BAIRRO,A2_END,A2_NOME"
	cSql		:= cSql+",F1_FORNECE,F1_LOJA,F1_ESPECIE,F1_VEND1,D1_SERIORI,D1_NFORI,A2_CGC "
	cSql		:= cSql+" FROM " + RetSqlName("SF1") +" SF1 JOIN " + RetSqlName("SD1") +" SD1 ON (D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE AND D1_LOJA=F1_LOJA AND SD1.D_E_L_E_T_ = ' '  AND D1_ITEM = '0001' AND D1_ESPECIE = 'NCP' )"
	cSql		:= cSql+" LEFT JOIN " + RetSqlName("SA2") +" SA2 ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA AND SA2.D_E_L_E_T_ = ' ' "
	cSql		:= cSql+" WHERE F1_FILIAL= '" + xFilial("SF1") + "' AND F1_DOC= '" + alltrim(SF1->F1_DOC) + "' AND F1_SERIE='" + alltrim(SF1->F1_SERIE) + "' AND F1_ESPECIE = 'NCP' "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()

	cValfat := 0
	cnfori := D1_NFORI
	ccserie := D1_SERIORI

	///pedido compra original
	cxPed := GetAdvFVal("SD1","D1_PEDIDO",F1_FILIAL+cnfori+ccserie+F1_FORNECE+F1_LOJA,1,"")	//CODIGO ORDEN COMPRA

	AADD(aDupla,F1_FILIAL)		  	//1
	AADD(aDupla,F1_SERIE)           //2
	AADD(aDupla,F1_DOC)             //3
	AADD(aDupla,'')          //4 nroautorizacion
	AADD(aDupla,F1_EMISSAO)         //5
	AADD(aDupla,F1_FORNECE + ' - ' + ALLTRIM(A2_NOME))         //6//nombre
	AADD(aDupla,A2_CGC)            //7 nit cliente
	AADD(aDupla,F1_COND)            //8 //condicionpago
	AADD(aDupla,F1_VALBRUT)          //9
	AADD(aDupla,F1_DESCONT)         //10
	AADD(aDupla,F1_BASIMP1)  		//11
	AADD(aDupla,)          //12
	AADD(aDupla,'')          //13
	AADD(aDupla,cxPed)		    //14 nropedido
	AADD(aDupla,A2_MUN)		    	//15
	AADD(aDupla,A2_BAIRRO)		    //16
	AADD(aDupla,A2_END)		    //17
	AADD(aDupla,'')		    //18
	AADD(aDupla,F1_FORNECE)		    //19
	AADD(aDupla,F1_LOJA)		    //20
	AADD(aDupla,F1_ESPECIE)		    //21
	AADD(aDupla,cnfori)			    //22 ??? FP_SFC
	AADD(aDupla,ccserie)			    //23 ??? FP_SFC
	AADD(aDupla,cValfat)//24

	aDetalle:= FatDet (F1_DOC,F1_SERIE)                	   	//Datos detalle de factura

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
	oPrn:Say( 300, 80,"Tel�fono(s): 8258066"  ,oFont11N )

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

	Local   cSql		:= "SELECT D1_ITEM,B1_COD,B1_DESC,D1_LOCAL,D1_DTVALID,D1_QUANT,D1_VUNIT,D1_QUANT*D1_VUNIT D1_TOTAL,D1_ITEM "
	cSql				:= cSql+"FROM " + RetSqlName("SD1") +" SD1 JOIN	" + RetSqlName("SB1") +" SB1 ON   D1_COD=B1_COD  AND SB1.D_E_L_E_T_=' '  "
	cSql				:= cSql+"where D1_DOC='"+cDoc+"' AND D1_SERIE='"+cSerie+"' AND D1_ESPECIE='NCP' AND SD1.D_E_L_E_T_=' ' "
	cSql				:= cSql+" ORDER BY SD1.D1_ITEM"

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	While !Eof()
		cProducto	:=D1_ITEM
		cNombre		:=B1_DESC

		cPedido		:=""
		cItPedido	:=""
		nCant		:=D1_QUANT

		nPrecio		:=D1_VUNIT

		nTotal		:=Round(nCant*nPrecio,2)
		cxLocal := D1_LOCAL

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
