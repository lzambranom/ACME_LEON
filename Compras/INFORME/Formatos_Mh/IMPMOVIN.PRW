#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FONT.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CFATI01  ºAutor  ³Luis Fernando Ibarraº Data ³  25/08/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Emision de Orden de Carga                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ Emision de Orden de Carga      							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFernando.Ibarra  ³08/01/14 ³ Implementacion de Rutina                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico GLADYMAR       	                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function  IMPMOVIN(cTpSO)
	IMPSD3(SD3->D3_DOC,SD3->D3_DOC,SD3->D3_FILIAL,SD3->D3_ESTORNO,SD3->D3_CF,DTOS(SD3->D3_EMISSAO),cTpSO)
Return Nil

STATIC Function IMPSD3(cNroDoc1,cNroDoc2,cSucursal,cEstrn,cCf,cFch,cTpSO)  //U_GESTI301(cNroFat1,cNroFat2,cSerie,cSucursal)
	Private cSrFct	 := ""
	Private	cNroDoc	 := ""
	Private cFchFat	 := ""
	Private cSucOrg	 := ""
	Private cSucDst	 := ""
	Private cObsTrsp := ""
	Private	nNroPag	 := 1
	Private nLin 	 := 0
	Private cDsTpMvt := ""
	Private nNroTMvt := 0
	Private	cUsrImp	 := USRFULLNAME(RETCODUSR())

	IMPCFG(cNroDoc1,cNroDoc2,cSucursal,cCf,cEstrn,cFch)

Return Nil

Static Function IMPCFG(cNroDoc1,cNroDoc2,cSucursal,cCf,cEstrn,cFch)
	Private oPrn     := NIL
	Private oFont1   := NIL
	Private oFont2   := NIL
	Private oFont3   := NIL
	Private oFont4   := NIL
	Private oFont5   := NIL
	Private oFont6   := NIL
	Private lPrevio	 :=.T.
	Private nFinHoja := 1400
	Private nLin1	 := 0080
	Private nLin2	 := 0140
	Private nLin3	 := 0200
	Private nLin4	 := 0255
	Private nLin5	 := 0310
	Private nCol 	 := 75
	Private nCol1 	 := 800
	Private nCol2 	 := 1200
	Private nCol3 	 := 0350
	Private nCol4 	 := 0100
	nLin 	 		 := 0300
	oPrn := TMSPrinter():New("NOTA MOVIMIENTO ALMACEN")
	oPrn:Setup()
	oPrn:SetPortrait()
	DEFINE FONT oFont5 NAME "Arial" 				SIZE 0,10 	OF oPrn
	DEFINE FONT oFont6 NAME "Arial"		  			SIZE 0,10   OF oPrn
	DEFINE FONT oFont10N NAME "Arial" 				SIZE 0,10 Bold  OF oPrn
	DEFINE FONT oFont7 NAME "Arial" 				SIZE 0,10   OF oPrn
	DEFINE FONT oFont8 NAME "Arial"  				SIZE 0,10   OF oPrn

	IMPINTER(cNroDoc1,cNroDoc2,cSucursal,.F.,1,cCf,cEstrn,cFch) 				//Impresion Nota De Salida
Return Nil

Static Function IMPINTER(cNroDoc1,cNroDoc2,cSucursal,bImprimir,nCopia,cCf,cEstrn,cFch) //Datos Maestro de factura
	Local aMaestro  := {}
	Local aDetalle 	:= {}
	Local aDupla	:= {}
	Local nI       	:= 0
	Local bSw		:= .T.
	Local cMsgRmt	:= ""
	Local NextArea 	:= GetNextAlias()
	Local cSql     	:= ""
	Local cNroDoc	:= ""
	Local cDscTpMv	:= ""
	Local cDscAlm	:= ""
	Local cObsMvt	:= ""
	Local nTpMvto	:= 0
	Local cTrnsprt 	:= ""
	Local cPlaca    := ""
	Local cChofer	:= ""
	Local cNroLncs  := ""
	cSql           	:= cSql +" Select  D3_UM,D3_CF,D3_FILIAL,D3_TM,D3_COD,B1_DESC,D3_LOCAL,D3_DOC,D3_EMISSAO,D3_QUANT,D3_ESTORNO "
	cSql           	:= cSql +" From    SD3200 Inner Join  SB1200 On SB1200.D_E_L_E_T_ = ' ' And (D3_COD     = B1_COD  ) "
	cSql           	:= cSql +" Where    "
	cSql           	:= cSql +      " D3_LOCAL <> '95'        And "
	If (cEstrn == "S" )
		cSql        := cSql +      " D3_ESTORNO 	   = '"+cEstrn+"' And "
	EndIf
	cSql           	:= cSql +      " (D3_DOC Between '"+cNroDoc1+"' And '"+cNroDoc2+"' ) And "
	cSql           	:= cSql +      " (D3_EMISSAO= '"+ cFch + "' ) And "
	cSql           	:= cSql +      " D3_FILIAL = '"+cSucursal+"' and SD3200.D_E_L_E_T_ = ' '  "
	cSql           	:= cSql +" Order By D3_DOC "
	aArea 			:= GetArea()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	While (!Eof())
		If (cNroDoc!=D3_DOC)
			If (cNroDoc!="")
				aMaestro[6]  := ''
				aMaestro[7]  := ''
				aMaestro[8]  := ''
				aMaestro[9]  := ''
				aMaestro[10] := ''
				For nI := 1 To nCopia
					LOrTrpIm(bImprimir,aMaestro,aDetalle,cCf,cEstrn)    		//Imprimir Movimiento Interno
				Next nI
			EndIf
			cObsMvt		:= ""
			cNroDoc		:= D3_DOC
			aMaestro 	:= {}
			aDetalle 	:= {}
			aAdd(aMaestro,D3_DOC)		 			//1
			aAdd(aMaestro,D3_EMISSAO)    			//2
			aAdd(aMaestro,D3_TM)    	 	    	//3
			aAdd(aMaestro,GtNmbMvt(D3_TM,D3_CF,D3_ESTORNO,cSucursal))//4
			dbSelectArea(NextArea)
			aAdd(aMaestro,D3_FILIAL) 	 			//5
			aAdd(aMaestro,'') 	 			//6
			aAdd(aMaestro,"") 	 					//7
			aAdd(aMaestro,"") 	 					//8
			aAdd(aMaestro,"") 	 					//9
			aAdd(aMaestro,"") 	 					//10
			//aAdd(aMaestro,FWLeUserlg("D3_USERLGA")) //11
			aAdd(aMaestro,'')			  //11
			aAdd(aMaestro,'')				//12
			aAdd(aMaestro,'') 	 			//13
		EndIf
		aDupla:={}
		aAdd(aDupla,D3_TM)    	 			 		//1
		aAdd(aDupla,D3_COD)   	 			 		//2
		aAdd(aDupla,B1_DESC) 		 				//3
		aAdd(aDupla,'') 		 			 		//4
		aAdd(aDupla,D3_QUANT) 		 		 		//5
		aAdd(aDupla,POSICIONE('NNR',1,XFILIAL('NNR')+ D3_LOCAL,'NNR_DESCRI')	)	//6
		dbSelectArea(NextArea)
		aAdd(aDupla,D3_LOCAL)   	 			 	//7
		aAdd(aDupla,D3_UM) 	 			 		//8
		cObsMvt:=''
		//aAdd(aDupla,FWLeUserlg("D3_USERLGI"))   	//9
		aAdd(aDupla,'')
		//aAdd(aDupla,FWLeUserlg("D3_USERLGA"))   	//10
		aAdd(aDupla,'')
		cTrnsprt := ''
		cPlaca   := ''
		cChofer	 := ''
		cNroLncs := ''
		aAdd(aDetalle,aDupla)
		DbSkip()
	EndDo
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
	If ( ( Len(aMaestro) > 0 ) .And.  (Len(aDetalle) > 0 ) )
		LOrTrpIm(bImprimir,aMaestro,aDetalle,cCf,cEstrn)    				//Imprimir Movimiento Interno
	EndIf
	RestArea(aArea)
	oPrn:Refresh()
	If bImprimir
		oPrn:Print()
	Else
		oPrn:Preview()
	End If

	Ms_Flush()
	oPrn:End()
Return Nil

Static function LOrTrpIm (bImprimir,aMaestro,aDetalle,cCf,cEstrn)
	Local nI		:= 0
	Local nDim		:= len(aDetalle)
	cNroDoc			:= aMaestro[1]
	cSucOrg			:= GtNmbSuc(aMaestro[5])	 //Filial Destino
	cObsTrsp 		:= aMaestro[6]
	cDsTpMvt		:= aMaestro[4]
	nNroTMvt		:= Val(aMaestro[3])
	LImpTrsa(aMaestro,aDetalle,cCf,cEstrn)
Return Nil

Static Function GtNmbSuc(cFilSuc)
	Local bSw 		 := .T.
	Local cNmbSuc	 := ""
	Local aEmpresa	 := {}
	Local cCodEmp	 := Substr(AllTrim(CEMPANT),1,2)
	aEmpresa		 := SaveEmp()
	aArea 			 := GetArea()
	DbSelectArea( "SM0" )
	If SM0->(DbSeek(cCodEmp+cFilSuc))
		cNmbSuc:=SM0->M0_FILIAL
	EndIf
	RestArea(aArea)
	SetEmp(aEmpresa[3],aEmpresa[2])
Return cNmbSuc

Static Function GtNmbMvt (cTMvtAlm,cCF,cEstrn,cSucInf)
	Local NextArea 	:= GetNextAlias()
	Local cSql		:= ""
	Local cDscNmbe	:= ""
	cSql           	:= cSql +" Select   F5_TEXTO "
	cSql           	:= cSql +" From     SF5200 "
	cSql           	:= cSql          +" Where F5_CODIGO  = '" +cTMvtAlm+"' And "
	cSql           	:= cSql          +" SF5200.D_E_L_E_T_ = ' ' "
	aArea 			:= GetArea()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),NextArea ,.T.,.F.)
	dbSelectArea(NextArea)
	dbGoTop()
	If (!Eof())
		cDscNmbe := F5_TEXTO
	Else
		If  ((AllTrim(cTMvtAlm) == "499") .Or. (AllTrim(cTMvtAlm) == "999"))
			If (cCF $ 'DE4,RE4')
				cDscNmbe	:=  "Transferencia Entre Almacenes"
			Else
				If (cEstrn <> 'S')
					cDscNmbe	:=  "Ajuste de Inventario"
				Else
					cDscNmbe	:=  "Documento Revertido"
				EndIf
			EndIf
		EndIf
	EndIf
	#IFDEF TOP
	dBCloseArea(NextArea)
	#ENDIF
	RestArea(aArea)
Return cDscNmbe

////impresion de items
Static Function LImpTrsa(aMaestro,aDetalle,cCf,cEstrn)
	Local nDim	:=Len(aDetalle)
	Local nI	:=1
	cFchFat		:=ALLTRIM(STRZERO(Day(STOD(aMaestro[2])),2))+ALLTRIM("/")
	cFchFat		:=cFchFat+ALLTRIM(STRZERO(MONTH(STOD(aMaestro[2])),2))+ALLTRIM("/")
	cFchFat		:=cFchFat+ALLTRIM(STRZERO(Year(STOD(aMaestro[2])),4))
	fimpecab(cCf,cEstrn,alltrim(aMaestro[4]))

	For nI:=1 To nDim
		oPrn:Say(nLin,100,aDetalle[nI][2],oFont5)   												//Producto
		oPrn:Say(nLin,300,aDetalle[nI][3],oFont5)   												//Descripcion
		If (aDetalle[nI][1]=="999")
			oPrn:Say(nLin,2100,"("+TRANSFORM(aDetalle[nI][5],"@E 9,999,999,999.99")+")" + " " + aDetalle[nI][8],oFont5)   	//Cantidad
		Else
			oPrn:Say(nLin,2100,TRANSFORM(aDetalle[nI][5],"@E 9,999,999,999.99") + " "+ aDetalle[nI][8],oFont5)   			//Cantidad
		EndIf
		oPrn:Say(nLin,1200,aDetalle[nI][6],oFont8)   									   			//Almacen
		LNuevaLi(cEstrn)
	Next nI

	LNuevaLi(cEstrn)

	oPrn:Say(1500, 100   ,"Elaborado:   " + cUserName,oFont5) ///AllTrim(aMaestro[12])
	oPrn:Say(1500, 1000  ,"Revisado:"  ,oFont5) ///AllTrim(aMaestro[13])
	oPrn:Say(1500, 1800  ,"Aprobado:",oFont5)

	oPrn:EndPage()
Return Nil

/////i
Static Function fimpecab(cCf,cEstrn,cxMov)

	//oPrn:Say(nLin1,nCol  ,ALLTRIM(SM0->M0_NOMECOM)+"."			,oFont6)
	oPrn:Say(nLin2,nCol  ,"DATOS PROVEEDOR"		,oFont10N)
	oPrn:Say(nLin2,1050  ,"FECHA ELABORACION"		,oFont10N)
	oPrn:Say(nLin3 , 1060,cFchFat,oFont5 )
	oPrn:Say(nLin2,1800  ,"DOCUMENTO RESPALDO"		,oFont10N)
	oPrn:Say(nLin3,nCol  ,"ACME LEON PLASTICOS SAS" + SM0->M0_TEL				,oFont5)
	oPrn:Say(nLin4,nCol  ,"NIT   800039613 - 2"				,oFont5)

	oPrn:Box( nLin3 , 70 ,  300 , 800 )
	oPrn:Box( nLin3 , 1050 ,  300 , 1400 )
	oPrn:Box( nLin3 , 1750 ,  300 , 2300 )

	If (nNroTMvt < 500)
		oPrn:Say(nLin1,nCol1+50 ," INGRESO A "	+ upper(cxMov)	,oFont10N )
	Else
		oPrn:Say(nLin1,nCol1+50 ," SALIDA A "	+ upper(cxMov)	,oFont10N )
	EndIf

	oPrn:Say(nLin1 , 1900,Alltrim(cNroDoc),oFont6 )

	//Fecha Salida
	//oPrn:Say(nLin4 , 1850,cFchFat,oFont5 )

	oPrn:Line(440,080,440,2340)

	//Cabecera	Producto
	oPrn:Say(450, 100,"CODIGO" ,oFont6)
	oPrn:Say(450, 300,"PRODUCTO",oFont6)
	oPrn:Say(450, 1200,"BODEGA",oFont6)
	oPrn:Say(450, 2100,"CANTIDAD",oFont6)

	oPrn:Line(490,080,490,2340)

	nLin:=500
	If(cEstrn == "S" )
		//oPrn:SayBitmap(550,650, "anulada.jpg", 1059, 0476)
	EndIf
Return nil

Static Function LNuevaLi(cEstrn)
	nLin:=nLin+50
	If (nLin>=nFinHoja)
		oPrn:EndPage()
		oPrn:StartPage()
		nLin := 0300
		nNroPag:=nNroPag+1
		fimpecab(cEstrn)
		nLin:=500
	Endif
Return Nil

Static Function SetEmp(cCodEmp, cCodFil)
	Local aArea := GetArea()
	Local bSw 	:= .T.
	DbSelectArea( "SM0" )
	If SM0->(DbSeek(cCodEmp+cCodFil))
		cFilAnt := cCodFil
		cNumEmp :=cCodEmp+cCodFil
	Else
		bSw := .F.
	EndIf
	RestArea(aArea)
Return (bSw)
Static Function SaveEmp()
	Local aDatos := {}
	aAdd(aDatos, SM0->(Recno()))
	aAdd(aDatos, SM0->M0_CODFIL)
	aAdd(aDatos, SM0->M0_CODIGO)
Return aDatos