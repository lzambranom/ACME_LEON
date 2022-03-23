#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'FWMVCDef.ch'
#Include "rwmake.ch"
#Include "tbiconn.ch"
#Include 'AcmeDef.ch'
#include 'report.ch'
/*
#DEFINE CRLF 			chr(13)+chr(10)
#DEFINE LF 				chr(10)
#DEFINE AMARILLO 		"BR_AMARELO_OCEAN.PNG"
#DEFINE ROJO 			"BR_VERMELHO.PNG"
#DEFINE VERDE 			"BR_VERDE_OCEAN.PNG"
#DEFINE GRIS  			"BR_CINZA.PNG"
#DEFINE NEGRO 			"BR_PRETO.PNG"
#DEFINE MARRON 			"BR_MARROM.PNG"
#DEFINE BLANCO 			"BR_BRANCO.PNG"
#DEFINE AZUL 			"BR_AZUL_OCEAN.PNG"
#DEFINE ROSA			"BR_PINK.PNG"
#DEFINE NARANJA			"BR_LARANJA"
#DEFINE ESTADO_BLANCO	"1"  // cEstado1	:= '1' // Nuevo, Salida de Materia sin Ingreso aun						"ZX2_ESTADO = '1'",BLANCO 	, "Salida Almacen"
#DEFINE ESTADO_ROJO		"2"  // cEstado2	:= '2' // Ingreso, entrada de Materia, Entrada  Invalida SOBRA			"ZX2_ESTADO = '2'",ROJO		, "Entrada Invalida"
#DEFINE ESTADO_NARANJA	"3"  // cEstado3	:= '3' // Ingreso, entrada de Materia, Entrada  Faltan  Amarillo TIPO	"ZX2_ESTADO = '3'",NARANJA	, "Espera por Legalizar (Parcial)" 
#DEFINE ESTADO_AMARILLO	"4"  // cEstado3	:= '4' // Ingreso, entrada de Materia, Entrada  completa verde TIPO		"ZX2_ESTADO = '4'",AMARILLO	, "Espera por Legalizar (Parcial)" 
#DEFINE ESTADO_AZUL		"5"  // cEstado4	:= '5' // Ingreso, entrada de Materia, Rojo Sobra						"ZX2_ESTADO = '5'",AZUL		, "Parcialmente Legalizada"
#DEFINE ESTADO_VERDE	"6"  // cEstado5	:= '6' // Legalizada Verde												"ZX2_ESTADO = '6'",VERDE	, "Legalizada"		
#DEFINE TP_MOV_GRIS		"1"	 // Nueva Salida de Material
#DEFINE TP_MOV_VERDE	"2"	 // Salida y entrada de materia Cohinciden
#DEFINE TP_MOV_AMARILLO	"3"	 // La cantidad de Salida de Materia es Superior a la entrada
#DEFINE TP_MOV_ROJO		"4"  // La cantidad de Materia de Entrada es superrio a la de Salida
*/
/*
+-----------------------------------------------------------------------------------------+
| Programa  #MntaCol           |Autor  | Axel Diaz        |Fecha         |  10/12/2019    |
|-----------------------------------------------------------------------------------------|
| Desc.     #  Función para crear columnas de cuadrícula del Browser                      |
|           #  Array da columna                                                           |
|           #	[n] [01] Título de columna                                                |
|           #	[n] [02] Bloque de código de carga de datos                               |
|           #	[n] [03] Tipo de datos                                                    |
|           #	[n] [04] Máscara                                                          |
|           #	[n] [05] Alineación (0 = Centrado, 1 = Izquierda o 2 = Derecha)           |
|           #	[n] [06] Tamaño                                                           |
|           #	[n] [07] Decimal                                                          |
|           #	[n] [08] Indica si se debe editar                                         |
|           #	[n] [09] Bloque de código de validación de columna después de editar      |
|           #	[n] [10] Indica si se muestra la imagen                                   |
|           #	[n] [11] Doble clic en el bloque de código de ejecución                   |
|           #	[n] [12] Variable que se utilizará para editar (ReadVar)                  |
|           #	[n] [13] Encabezado Haga clic en Bloqueo de código de ejecución           |
|           #	[n] [14] Indica si la columna se elimina                                  |
|           #	[n] [15] Indica si la columna se mostrará en los detalles de exploración. |
|           #	[n] [16] Opciones de carga de datos (Ej: 1 = Sí, 2 = No)                  |
|	                                                                                      |
|-----------------------------------------------------------------------------------------|
| Uso       #                                                                             |
+-----------------------------------------------------------------------------------------+
*//*
User Function MntaCol(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal,ldetalle)
	Local aColumn	:= {}
	Local bData 	:= {||}
	Default nAlign 	:= 1
	Default nSize 	:= 20
	Default nDecimal:= 0
	Default nArrData:= 0
	If nArrData > 0
		bData := &("{||" + cCampo +"}") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,ldetalle, {}}
Return {aColumn}
/*
+---------------------------------------------------------------------------+
| Programa  #  SX3Datos  |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #  Función para buscar propiedades de un campos en SX3          |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # Ejemplo: SX3Datos("F1_FORNECE")                               |
+---------------------------------------------------------------------------+
*/
User Function SX3Datos(cCampo)
	Local aCampo	:= {}
	dbSelectArea("SX3")     
	SX3->(DbSetOrder(2))
	SX3->(DbSeek(cCampo))
	aCampo	:= {;
					SX3->X3_ORDEM,; 								// [01]
					ALLTRIM(SX3->X3_CAMPO),;						// [02]  // n OMBRE cAMPO
					ALLTRIM(SX3->X3_TIPO),;							// [03]
					SX3->X3_TAMANHO,;								// [04]
					SX3->X3_DECIMAL,;								// [05]
					ALLTRIM(SX3->X3_TITSPA),;						// [06]  // tITULO ESPAÑOL
					ALLTRIM(SX3->X3_DESCSPA),;						// [07]  // dESCRIP eSPAÑOL
					ALLTRIM(SX3->X3_PICTURE),;						// [08]
					SX3->X3_VALID,;									// [09]
					IIF(SX3->X3_USADO==".T.",.T.,.F.),;				// [10]
					SX3->X3_RELACAO,;								// [11]
					SX3->X3_F3,;									// [12]
					SX3->X3_NIVEL,;									// [13]
					SX3->X3_CHECK,;									// [14]
					SX3->X3_TRIGGER,;								// [15]
					IIF(SX3->X3_BROWSE==".T.",.T.,.F.),;			// [16]
					IIF(SX3->X3_VISUAL=="V",.F.,.T.),;				// [17]
					SX3->X3_CONTEXT,;								// [18]
					IIF(SX3->X3_OBRIGAT==".T.",.T.,.F.),;			// [19]
					SX3->X3_VLDUSER,;								// [20]
					SX3->X3_CBOXSPA,;								// [21]
					SX3->X3_PICTVAR,;								// [22]
					IIF(SX3->X3_WHEN==".T.",.T.,.F.),;				// [23]
					ALLTRIM(StrTran(SX3->X3_CAMPO, "_", "M" ));		// [24]
				}
Return aCampo
/*
+---------------------------------------------------------------------------+
| Programa  # CodBarrLee |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #  Ventana tipo MEMO que captura las entradas del lector del    |
|           #  codigo de barras                                             |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function CodBarrLee(oMdl,oVw)
	Local cTexto
	Local oDlg
	Local oMemo
	Local Retorno

	DEFINE MSDIALOG oDlg TITLE "Lectura de Códigos de Barra" FROM 0,0 TO 555,650 PIXEL
	     @ 005, 005 GET oMemo VAR cTexto MEMO SIZE 315, 250 OF oDlg PIXEL
	     @ 260, 280 Button "PROCESAR" Size 035, 015 PIXEL OF oDlg Action(processa( {|| u_CodBarProc(oDlg,cTexto,oMdl,oVw) }, "Procesando los Códigos", "Leyendo los registros y sumando, espere...", .f.))
	     @ 260, 230 Button "CANCELAR" Size 035, 015 PIXEL OF oDlg Action oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED
Return


/*
+---------------------------------------------------------------------------+
| Programa  # CodBarProc |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     # encargado de procesar los codigos de barra leidos             |
|           # y agruparlos y sumarlos para rellenar el grid                 |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function CodBarProc(oDlg,cTexto,oMdl,oView)
	Local aLineas	:= {}
	Local aLinTmp	:= {}
	Local aProduc	:= {}
	Local aCodBar	:= {}
	Local nI,nJ,nX := 0
	Local oModelZY2, oModelZX2
	Local lInsert	:= .T.
	Local lPaso		:= .F.
	Local nTamCod	:= 0
	Local nTamBar	:= 0

	dbSeek("B1_COD")
	nTamCod:=SX3->X3_TAMANHO
	dbSeek("B1_CODBAR")
	nTamBar:=SX3->X3_TAMANHO

	cTexto:=ALLTRIM(StrTran(cTexto, CRLF, LF ))
	If !EMPTY(cTexto)
		aLinTmp:=StrTokArr(cTexto,LF)  // trae el texto y pasa a un arreglo el codBarra
		procregua(Len(aLinTmp))
		// Limpia arreglo de ENTERs

		For nI:=1 to Len(aLinTmp)
			If !Empty(Alltrim(aLinTmp[nI]))
				AAdd( aLineas,ALLTRIM(aLinTmp[nI]))
			EndIf
		Next nI

		AAdd( aCodBar,{aLineas[1],1})  // Agrega el Cod Bar del Producto con  cantidad 1
		AAdd( aProduc,{aLineas[1],1})  // Agrega el Cod del Producto con  cantidad 1

		// Cuenta las repeticiones de los productos
		For nI:=2 to Len(aLineas)
			lAdd:= .T.
			incproc("Sumando...")
			For nJ:=1 to Len(aCodBar)     
				If aLineas[nI]==aCodBar[nJ][1]   // Si encuentra el codigo de barra nuevamente Suma 1   
					aCodBar[nJ][2]:=aCodBar[nJ][2]+1
					aProduc[nJ][2]:=aProduc[nJ][2]+1
					lAdd := .F.
				EndIf
			Next nJ
			If lAdd
				AAdd( aCodBar,{aLineas[nI],1})
				AAdd( aProduc,{aLineas[nI],1})
			EndIf
		Next nI

		// Se muestra la lectura 
		cTexto:="<table style='color: #000;' border='0' cellspacing='2' cellpadding='2'><tbody><tr style='background-color: #e0e0e0; text-align: center; color: black;'><td>#</td><td>Cod Producto</td><td>Cod Barra</td><td>Cantidad</td></tr>"
		For nI:=1 to len(aCodBar)
			aProduc[nI][1]:=""
			aProduc[nI][1]:=POSICIONE('SB1',5,xFilial("SB1")+SUBSTR(aCodBar[nI][1]+SPACE(nTamBar),1,nTamBar),"B1_COD")
			IF Empty(aProduc[nI][1])
				aProduc[nI][2]:=0
				aProduc[nI][1]:="<font color=RED>NO EXITE</font>"
			EndIf
		Next nI	

		For nI:=1 to len(aCodBar)
			cTexto:=cTexto+"<tr><td>"+cValToChar(nI)+"</td><td>"+aProduc[nI][1]+"</td><td>"+aCodBar[nI][1]+"</td><td>"+cValToChar(aCodBar[nI][2])+"</td></tr>"
		Next nI
		cTexto+="</tbody></table>"


		// Se espera por la aceptacion de los datos
		If MsgYesNo("¿Subir los códigos al sistema?..."+CRLF+cTexto)

		     oModelZX2:= oMdl:GetModel("ZX2MASTER")
		     oModelZY2:= oMdl:GetModel("ZY2DETAIL")

		     If INCLUI
		     	For nI:=1 to len(aProduc)
		     		incproc("Agregando...")
		     		If aProduc[nI][2]>0
			     		For nJ:=1 to (oModelZY2:Length()) 
			     			oModelZY2:GoLine( nJ )
			     			If oModelZY2:GetValue("ZY2_CODPRO")==aProduc[nI][1] 
			     				lInsert:=.F.
			     				nX:=nJ
			     			EndIf
			     		Next
			     		If lInsert
			     			oModelZY2:AddLine()
			     		Else
			     			oModelZY2:GoLine( nX )
			     			oModelZY2:UnDeleteLine()
				     	End
				     	oModelZY2:SetValue("ZY2_CODPRO"	, 	aProduc[nI][1] )
				     	oModelZY2:SetValue("ZY2_CODBAR" , 	aCodBar[nI][1] )
				     	oModelZY2:SetValue("ZY2_CANTO"	, 	aCodBar[nI][2]+ oModelZY2:GetValue("ZY2_CANTO"))
				     	oModelZY2:SetValue("LEGENDA"	, 	GRIS )
				     	lInsert:=.T.
			     	EndIf
		     	Next
		     Else
		     	lInsert:=.T.
		     	lPaso:= .F.
		     	For nI:=1 to len(aProduc)
		     		incproc("Cotejando...")
		     		If aProduc[nI][2]>0
			     		For nJ:=1 to (oModelZY2:Length()) 
			     			oModelZY2:GoLine( nJ )
			     			If ALLTRIM(oModelZY2:GetValue("ZY2_CODPRO"))==ALLTRIM(aProduc[nI][1])
			     				lInsert:=.F.
			     				nX:=nJ
			     			EndIf
			     		Next
			     		If lInsert
			     			lPaso:=.T.
			     			lIncAcme:= .T.
			     			//oModelZY2:AddLine()
			     			//
			     			//oModelZY2:SetValue("ZY2_CODPRO"	, 	ALLTRIM(aProduc[nI][1]) )
			     			//oModelZY2:SetValue("ZY2_CODBAR"	, 	ALLTRIM(aCodBar[nI][1]) )
			     			//oModelZY2:SetValue("ZY2_2CANTO"	, 	aProduc[nI][2]*(-1)) // Si se agrega Linea, llegaron productos que no pertenecen al Doc de salida
			     			//oModelZY2:SetValue("ZY2_2CANTD"	, 	aProduc[nI][2] )
			     			//oModelZY2:SetValue("LEGENDA"	, 	ROJO )
			     			//oModelZY2:SetValue("DESCRIP"	,	POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduc[nI][1]),'B1_DESC'))
			     			//oModelZY2:SetValue("DIFERENC"	,	aProduc[nI][2]*(-1))
			     			lIncAcme:= .F.
			     		Else
			     			oModelZY2:GoLine( nX )
			     			oModelZY2:UnDeleteLine()

			     			oModelZY2:SetValue("ZY2_CODPRO"	, 	ALLTRIM(aProduc[nI][1]) )
			     			oModelZY2:SetValue("ZY2_CANTO"	, 	oModelZY2:GetValue("ZY2_CANTO") ) 
			     			oModelZY2:SetValue("ZY2_CANTD"	, 	aProduc[nI][2]+oModelZY2:GetValue("ZY2_CANTD") )
			     			oModelZY2:SetValue("DIFERENC"	,	ABS(oModelZY2:GetValue("ZY2_CANTO")-aProduc[nI][2]))
			     			oModelZY2:SetValue("LEGENDA"	,;
			     					u_getImg(u_SemaGrid(	oModelZY2:GetValue("ZY2_UNORG"),;
			     										oModelZY2:GetValue("ZY2_UNORG"),;
			     										oModelZY2:GetValue("ZY2_CANTO"),;
			     										oModelZY2:GetValue("ZY2_CANTD");
			     									);
			     								);
			     							)
				     	End
				     	lInsert:=.T.
			     	EndIf
		     	Next
		     	oModelZY2:GoLine( 1 )
		     EndIf

		     Retorno := oDlg:End()
		     oModelZY2:GoLine( 1 )
			 oModelZY2:SetLine( 1 )
			 oView:Refresh()
			 If lPaso
			 	MsgAlert("Algunos productos de Entrada no están en el listado de Salida, por lo tanto no se agregaron")
			 EndIf
			 //MsgAlert("Actualizada")
		Else
			 MsgAlert("No se Transfirió")
		     Retorno := oDlg:End()
		EndIf
	Else
		MsgAlert("No se encontraron datos")
	    Retorno := oDlg:End()
	EndIf
Return(Retorno)
/*
+---------------------------------------------------------------------------+
| Programa  #  getImg   |Autor  | Axel Diaz      |Fecha |  10/12/2019       |
+---------------------------------------------------------------------------+
| Desc.     #  Función saber que color va en el grid                        |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function getImg(cTpMovSF)
	Local cImg
	DO CASE
	         CASE Empty(cTpMovSF) .OR. cTpMovSF == TP_MOV_GRIS 	// Empty(cUNDES) .and. nCANTD==0
	         	cImg := GRIS
	         CASE cTpMovSF == TP_MOV_VERDE 						// (nCANTO==nCANTD) .AND. (cUNDES==cUNORG)
	         	cImg := VERDE
	         CASE cTpMovSF == TP_MOV_AMARILLO  					// nCANTO>nCANTD
	         	cImg := AMARILLO
	         OTHERWISE											// nCANTO>nCANTD or cUNDES<>cUNORG
	         	cImg := ROJO
	ENDCASE
Return cImg 
/*
+---------------------------------------------------------------------------+
| Programa  #         |Autor  | Axel Diaz        |Fecha |  10/12/2019       |
+---------------------------------------------------------------------------+
| Desc.     #                                                               |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # Ejemplo:                                 |
+---------------------------------------------------------------------------+
*/
User Function GetSerAx(ofield)
	Public cSEAC001 := ""
	If u_GetSerAc()
		//If !Empty(cArq)
			oField:SetValue("ZX2_SERIE",cSEAC001)
		//EndIf
	EndIf
Return
/*
+---------------------------------------------------------------------------+
| Programa  # ValUsrSe|Autor  | Axel Diaz        |Fecha |  10/12/2019       |
+---------------------------------------------------------------------------+
| Desc.     #   Valida que el usuario este autorizado para esa serie        |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # Ejemplo:                                 |
+---------------------------------------------------------------------------+
*/
User Function ValUsrSe(cSerie, cUserID)
	Default cUserID	:= UsrRetName(RetCodUsr())
Return  !EMPTY(ALLTRIM(Posicione("ZZU",3,xFilial("ZZU")+ALLTRIM(cSerie)+ cUserID,"ZZU_SERIE")))
/*
+---------------------------------------------------------------------------+
| Programa  #         |Autor  | Axel Diaz        |Fecha |  10/12/2019       |
+---------------------------------------------------------------------------+
| Desc.     #                                                               |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # Ejemplo:                                                      |
+---------------------------------------------------------------------------+
*/
User Function GetSerAc()
	Local cFilSX5   := xFilial('SX5')
	Local aSerNF    := {}
	Local cTitle    := "Series Acme Leon"
	Local lOk       := .F.
	Local aSX5      := {}
	Local nX 		:= 1
	Local oDlg, oItem, nOAt
	Public cSEAC001 := ""
	//-- Verifica se a serie esta cadastrada na tabela zz - Series Acme.
	aSX5 := FWGetSX5("ZZ")
	For nX := 1 To Len(aSX5) // crea el arreglo con las series autorizadas
		If (aSX5[nX][1] == cFilSX5) .and. (aSX5[nX][2] == "ZZ") .and. u_ValUsrSe(ALLTRIM(aSX5[nX][3]),UsrRetName(RetCodUsr()))
			Aadd(aSerNF, {PadR(aSX5[nX][3],3), Soma1(aSX5[nX][4])})
		EndIf
	Next

	If Len(aSerNF) == 0 	// revisa si tiene alguna serie autorizada
		Help(NIL, NIL, AcmeHlpSinReg, NIL, AcmeHlpSinReg1, 1, 0, NIL, NIL, NIL, NIL, NIL, {AcmeHlpSinReg2})
		Return .F.
	EndIf

	// creao ventana de dialogo
	DEFINE MSDIALOG oDlg TITLE cTitle From 150,200 To 305,600 OF oMainWnd PIXEL
		@ 05,10 LISTBOX oItem VAR cOpc Fields HEADER OemToAnsi("SERIE"), OemToAnsi("NUMERO") SIZE 140,65  OF oDlg PIXEL
		oItem:SetArray(aSerNF)
		oItem:bLine := { || {aSerNF[oItem:nAt,1], aSerNF[oItem:nAt,2]}}
		DEFINE SBUTTON FROM 03,160 TYPE 1 ENABLE OF oDlg ACTION (lOk:=.T.,oDlg:End())
		DEFINE SBUTTON FROM 18,160 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg VALID (nOAT := oItem:nAT,.T.) CENTERED

	If lOk .And. (Inclui .Or. Altera)
			&(ReadVar()) := ALLTRIM(aSerNF[nOAt, 1])
			cSEAC001 := ALLTRIM(aSerNF[nOAt, 1])
	EndIf
Return lOk
/*
+---------------------------------------------------------------------------+
| Programa  #            |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #                                                               |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # VALIDACION MODELO AL CONFIRAR                                 |
+---------------------------------------------------------------------------+
*/
User Function AcmAction(oModel) 
	Local lRet := .T.
	Local nOperation := oModel:GetOperation()
	Alert(nOperation)
Return lRet 
/*
+---------------------------------------------------------------------------+
| Programa  #  GetSX5Num  |Autor  | Axel Diaz        |Fecha |  10/12/2019   |
+---------------------------------------------------------------------------+
| Desc.     #                                                               |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # Ejemplo: GetSX5Num("ZZ","DTD")                                |
+---------------------------------------------------------------------------+
*/
User Function GetSX5Num(cTabla,cSerie,nIndice,cDoc)
	Local cNextNum	:= ""
	Default nIndice	:= 1 
	Default cTabla	:= 'ZZ'
	Default cDoc	:=""

	If !EMPTY(ALLTRIM(cDoc)) 
		cDoc:=u_NumReal("ZZ",cDoc,cSerie)
		If U_ValSerDoc(cSerie, cDoc, nIndice )
			Return cDoc
		EndIf
	EndIf
	cNextNum	:= ALLTRIM(Soma1(alltrim(Posicione("SX5",1,xFilial("SX5")+cTabla+cSerie,"X5_DESCRI"))))
	While !U_ValSerDoc(cSerie, cNextNum, nIndice )
		cNextNum	:= Soma1(cNextNum)
	End
return cNextNum
/*
+---------------------------------------------------------------------------+
| Programa  #            |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #                                                               |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # VALIDACION MODELO AL CONFIRAR                                 |
+---------------------------------------------------------------------------+
*/
User Function ValSerDoc(cSerie, cDoc, nIndice)
	Local lRet 			:= .T.
	Local cDocFind		:= ""
	Local cDocZX2		:= ""
	Default lMessage	:= .T.
	Default nIndice	:= 1 

	IIF(nIndice==1,cDocZX2:="ZX2_DOC",cDocZX2:="ZX2_DOC2")
	cDoc:=u_NumReal("ZZ",cDoc,cSerie)
	cDocFind := POSICIONE("ZX2",nIndice,xFilial("ZX2")+cDoc+cSerie,cDocZX2)

	If !EMPTY(ALLTRIM(cDocFind))
		lRet:=.F.
	Else
		IIF(nIndice==1,cDocZX2:="ZX2_DOC2",cDocZX2:="ZX2_DOC")
		IIF(nIndice==1,nIndice:=2,nIndice:=1)
		cDocFind := POSICIONE("ZX2",nIndice,xFilial("ZX2")+cDoc+cSerie,cDocZX2)
		If !EMPTY(ALLTRIM(cDocFind))
			lRet:=.F.
		EndIf
	EndIf
Return lRet 
/*
+---------------------------------------------------------------------------+
| Programa  #            |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #                                                               |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # VALIDACION MODELO AL CONFIRAR                                 |
+---------------------------------------------------------------------------+
*/
User Function NumReal(cTabla,cDoc,cSerie)
	Local nlargo	:= LEN(ALLTRIM(alltrim(Posicione("SX5",1,xFilial("SX5")+cTabla+ cSerie,"X5_DESCRI"))))
	Local cDocZX2	:= Right(replicate("0",nlargo)+cValToChar(val(cDoc)),nlargo)
Return cDocZX2
/*
+---------------------------------------------------------------------------------------------------------+
| Programa  # SemaGrid   |Autor  | Axel Diaz        |Fecha |  10/12/2019                                  |
+---------------------------------------------------------------------------------------------------------+
| Desc.     #  cTp := "1" Nuevo, Salida de Materia sin Ingreso aun                                        |
|           #  cTp := "2" Ingreso, entrada de Materia, coinciden Verde                                    |
|           #  cTp := "3" Ingreso, entrada de Materia, Faltan  Amarillo                                   |
|           #  cTp := "4" Ingreso, entrada de Materia, Rojo Sobra                                         |
|			#DEFINE TP_MOV_GRIS		"1"	 // Nueva Salida de Material                                      |
|			#DEFINE TP_MOV_VERDE	"2"	 // Salida y entrada de materia Cohinciden                        |
|			#DEFINE TP_MOV_AMARILLO	"3"	 // La cantidad de Salida de Materia es Superior a la entrada     |
|			#DEFINE TP_MOV_ROJO		"4"  // La cantidad de Materia de Entrada es superrio a la de Salida  |
+---------------------------------------------------------------------------------------------------------+
| Uso       # Coloca en valor del estado en el Grip                                                       |
+---------------------------------------------------------------------------------------------------------+
*/
User Function SemaGrid(cUNORG,cUNDES,nCANTO,nCANTD)
	Local cTp := "1"
	DO CASE
	         CASE Empty(cUNDES) .and. nCANTD==0    				// inicio de salida, nuevo documento
	         	cTp := TP_MOV_GRIS
	         CASE !(cUNDES==cUNORG)   							// el tipo de unidad es diferente
	         	cTp := TP_MOV_ROJO
	         CASE nCANTO>nCANTD    								// la cantidad recibida es menor
	         	cTp := TP_MOV_AMARILLO
	         CASE nCANTO<nCANTD    								// la cantidad recibida es superior
	         	cTp := TP_MOV_ROJO
	         CASE (nCANTO==nCANTD) .AND. (cUNDES==cUNORG) 		//las cantidades cohinciden
	         	cTp := TP_MOV_VERDE
	         OTHERWISE  										// cualquier otro caso
	         	cTp := TP_MOV_GRIS
	ENDCASE
Return cTp
/*
+---------------------------------------------------------------------------+
| Programa  # ACM010()   |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #  cSerie,Serie del Documento de Salida                         |
|           #  cDoc, Numero de Documento de Salida 						    |
|           #  cSerie2, Serie del Documento de Entrada                      |
|           #  cDoc2, Numero de Documento de Entrada                        |
+---------------------------------------------------------------------------+
| Uso       # Invoca al Exceauto de Mata261 de transferencia entre Almacenes|
+---------------------------------------------------------------------------+
*/
User Function ACM010(oModel)
	Local oModelZX2		:= oModel:GetModel("ZX2MASTER")
	Local oModelZY2		:= oModel:GetModel("ZY2DETAIL")
	Local cAlmOri		:= oModelZX2:GetValue("ZX2_ALMORI")
	Local cAlmDes		:= oModelZX2:GetValue("ZX2_ALMDES")
	Local nX,nJ,nOpcAuto:= 0
	Local cDocumen 		:= ""
	Local cIdentO,cIdentD:= "" // Kardex
	Local lContinua 	:= .T.
	Local aProducto 	:= {} 		//{'000000000000001','000000000000001','000000000000003','000000000000003'} arreglo de productos de tranferencia
	Local aCantd		:= {}		//{1000,1000,3000,3000}
	Local aCantd2d		:= {}		//{1,1,1,1}
	Local aPriUM		:= {}		//{"UN","UN","UN","UN"}
	Local aSegUM		:= {}		//{"CX","CX","CX","CX"}
	Local aAuto			:= {}
	Local aLinha		:= {}
	Local lDiferencia	:= .F.
	Local cTpMov		:= ''
	Local cQry			:= ''
	Local cD3TMP		:= GetNextAlias()
	Local cESTADO		:= ""
	Private lMsErroAuto := .F.
	Private aRecSD3		:= {}
	Private cSerO		:= ""
	Private cDocO		:= ""
	Private cSerD		:= ""
	Private cDocD		:= ""



	conout("Inicio de Inclución de Tranferencia Multiple MATA261")

	// Proximo numero de documento de tranferencia
	cDocumen	:= GetSxeNum("SD3","D3_DOC")
	cSerO		:= oModelZX2:GetValue("ZX2_SERIE")
	cDocO		:= oModelZX2:GetValue("ZX2_DOC")
	cSerD		:= oModelZX2:GetValue("ZX2_SERIE2")
	cDocD		:= oModelZX2:GetValue("ZX2_DOC2")

	aadd(aAuto,{cDocumen,dDataBase}) //Cabecalho
	For nJ:=1 to (oModelZY2:Length()) 
		oModelZY2:GoLine( nJ )
		aadd(aProducto	,oModelZY2:GetValue("ZY2_CODPRO"))	;aadd(aProducto	,oModelZY2:GetValue("ZY2_CODPRO"))
		aadd(aCantd		,oModelZY2:GetValue("ZY2_CANTO"))	;aadd(aCantd	,oModelZY2:GetValue("ZY2_CANTD"))
		aadd(aCantd2d	,oModelZY2:GetValue("ZY2_2CANTO"))	;aadd(aCantd2d	,oModelZY2:GetValue("ZY2_2CANTD"))
		aadd(aPriUM		,oModelZY2:GetValue("ZY2_UNORG"))	;aadd(aPriUM	,oModelZY2:GetValue("ZY2_UNORG"))
		aadd(aSegUM		,oModelZY2:GetValue("ZY2_2UNORG"))	;aadd(aSegUM	,oModelZY2:GetValue("ZY2_2UNORG"))
		cTpMov:=oModelZY2:GetValue("ZY2_TPMOV")
		If cTpMov==TP_MOV_ROJO .OR. cTpMov==TP_MOV_GRIS  // Estado Rojo o Gris DEL grid
			MsgAlert("El Estado de este documento no permite realizar el despacho")
			Return
		ElseIf cTpMov==TP_MOV_AMARILLO // Estado Amarillo DEL grid
			lDiferencia	:= .T.
		EndIf
	Next
	conout("Inicio de ensamblando arreglo")
	for nX := 1 to len(aProducto) step 2
	    aLinha := {}
	    //Origen
	    conout("Producto"+aProducto[nX])
	    SB1->(DbSeek(xFilial("SB1")+PadR(aProducto[nX], tamsx3('D3_COD')[1])))
	    CriaSB2(SB1->B1_COD,cAlmDes)   // CREA EL PRODUCTO EN EL ALMACEN DESTINO
	    CriaSB2(SB1->B1_COD,cAlmOri)
	    aadd(aLinha,{"ITEM"			,'00'+cvaltochar(nX), Nil})
	    aadd(aLinha,{"D3_COD"		, SB1->B1_COD    	, Nil}) 	//Cod Produto origem
	    aadd(aLinha,{"D3_DESCRI"	, SB1->B1_DESC		, Nil}) 	//descr produto origem
	    aadd(aLinha,{"D3_UM"		, aPriUM[nX]		, Nil}) 	//unidade medida origem
	    aadd(aLinha,{"D3_SEGUM"		, aSegUM[nX]		, Nil}) 	//unidade medida origem
	    aadd(aLinha,{"D3_LOCAL"		, cAlmOri			, Nil}) 	//armazem origem
	    aadd(aLinha,{"D3_LOCALIZ"	, ""				, Nil}) 	//Informar endereÃ§o origem

	    //Destino
	    SB1->(DbSeek(xFilial("SB1")+PadR(aProducto[nX+1], tamsx3('D3_COD')[1])))
	    aadd(aLinha,{"D3_COD"		, SB1->B1_COD    	, Nil}) 	//cod produto destino
	    aadd(aLinha,{"D3_DESCRI"	, SB1->B1_DESC		, Nil}) 	//descr produto destino
	    aadd(aLinha,{"D3_UM"		, aPriUM[nX+1]		, Nil}) 	//unidade medida destino
	    aadd(aLinha,{"D3_SEGUM"		, aSegUM[nX+1]		, Nil}) 	//unidade medida origem
	    aadd(aLinha,{"D3_LOCAL"		, cAlmDes			, Nil}) 	//armazem destino
	    aadd(aLinha,{"D3_LOCALIZ"	, ""				, Nil}) 	//Informar endereÃ§o destino


	    aadd(aLinha,{"D3_NUMSERI"	, ""				, Nil})		//Numero serie
	    aadd(aLinha,{"D3_LOTECTL"	, ""				, Nil}) 	//Lote Origem
	    aadd(aLinha,{"D3_NUMLOTE"	, ""				, Nil}) 	//sublote origem
	    aadd(aLinha,{"D3_DTVALID"	, dDataBase			, Nil}) 	//data validade
	    aadd(aLinha,{"D3_POTENCI"	, 0					, Nil}) 	//Potencia
	    aadd(aLinha,{"D3_QUANT"		, aCantd[nX+1]		, Nil}) 	//Quantidade
	    aadd(aLinha,{"D3_QTSEGUM"	, aCantd2d[nX+1]	, Nil}) 	//Seg unidade medida
	    aadd(aLinha,{"D3_ESTORNO"	, ""				, Nil}) 	//Estorno
	    aadd(aLinha,{"D3_NUMSEQ"	, ""				, Nil}) 	//Numero sequencia D3_NUMSEQ

	    aadd(aLinha,{"D3_LOTECTL"	, ""				, Nil}) 	//Lote destino
	    aadd(aLinha,{"D3_NUMLOTE"	, ""				, Nil}) 	//sublote destino
	    aadd(aLinha,{"D3_DTVALID"	, dDataBase			, Nil}) 	//validade lote destino
	    aadd(aLinha,{"D3_ITEMGRD"	, ""				, Nil}) 	//Item Grade

	    aadd(aLinha,{"D3_CODLAN"	, ""				, Nil}) 	//cat83 prod origem
	    aadd(aLinha,{"D3_CODLAN"	, ""				, Nil}) 	//cat83 prod destino

	    aAdd(aAuto,aLinha)

	Next nX
	nOpcAuto := 3 // Inclusao
	conout("inicio Inclusion de transferencias multiple semaforizacion-despacho "+cSerO+RIGHT(cDocO,11))

	If SaldosExec(oModel)
		MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)
		if lMsErroAuto
			//MostraErro()
			DisarmTransaction()
			MostraErro()
			conout("Inclusion de transferencias multiple finalizó con errores " +cSerO+RIGHT(cDocO,11))
			cSD3AcDoc	:= ""
			lContinua 	:= .F.
		else
			conout("Fin Inclusion de transferencias multiple semaforizacion-despacho "+cSerO+RIGHT(cDocO,11)+" con exito, se procede a actualizar SD3")
			lContinua := .T.
			cQry:="SELECT D3_DOC FROM "+ RetSQLName("SD3")+" WHERE D3_FILIAL='"+xFilial("SD3")+"' AND R_E_C_N_O_='"+cValToChar(+aRecSD3[1][1])+"' AND D_E_L_E_T_=' '"
			dbUseArea(.T.,"TOPCONN", TcGenQry(nil,nil,cQry) ,cD3TMP,.T.,.T.)
			DbSelectArea(cD3TMP)
			(cD3TMP)->(DbGoTop())
			cSD3AcDoc:=(cD3TMP)->D3_DOC
			(cD3TMP)->(DbCloseArea())
			conout("Inclusion de movimiento multiple finalizó satisfactoriamente ("+cSerO+RIGHT(cDocO,11)+"->"+cSerD+RIGHT(cDocD,11)+")")
			//MsgInfo("La Legalización se realizó satisfactoriamente, pulse Botón cerrar en el menu superior")
		EndIf
	Else
		cSD3AcDoc:="SALDOINSU"
		conout("Saldo Insuficiente de transferencias multiple semaforizacion-despacho "+cSerO+RIGHT(cDocO,11))
		lContinua:= .F.
	EndIf
	conout("Movimiento Finalizado")

Return lContinua

/*
+---------------------------------------------------------------------------+
| Programa  # ConvUni   |Autor  | Axel Diaz        |Fecha |  10/12/2019     |
+---------------------------------------------------------------------------+
| Uso       # Hace la conversion de segunda unidad de medida                |
+---------------------------------------------------------------------------+
*/
User Function ConvUni(nCant,nConver,cOper)
	Local nSegCan:=0
	If cOper=="D"
		nSegCan:=nCant/nConver
	Else
		nSegCan:=nCant*nConver
	EndIf
Return nSegCan
/*
+----------------------------------------------------------------------------+
| Programa  # InverUni   |Autor  | Axel Diaz        |Fecha |  10/12/2019     |
+----------------------------------------------------------------------------+
| Uso       # Hace la conversion de segunda unidad de medida a Primera unidad|
+----------------------------------------------------------------------------+
*/
User Function InverUni(nCant,nConver,cOper)
	Local nSegCan:=0
	If cOper=="D"
		nSegCan:=nCant*nConver
	Else
		nSegCan:=nCant/nConver
	EndIf
Return nSegCan
/*
+----------------------------------------------------------------------------+
| Programa  # FacConv   |Autor  | Axel Diaz        |Fecha |  10/12/2019      |
+----------------------------------------------------------------------------+
| Uso       # Hace la conversion de segunda unidad de medida a Primera unidad|
+----------------------------------------------------------------------------+
*/
User Function FacConv(nCant,cProd,lInver)
	Local nSegCan	:= 0
	Local cOper		:= POSICIONE("SB1",1,xFilial()+cProd,"B1_TIPCONV")
	Local nConver	:= POSICIONE("SB1",1,xFilial()+cProd,"B1_CONV")
	If lInver
		nSegCan	:=	u_InverUni(nCant,nConver,cOper)
	Else
		nSegCan	:=	u_ConvUni(nCant,nConver,cOper)
	EndIf
Return nSegCan

/*
+----------------------------------------------------------------------------+
| Programa  # LeyenAcm     |Autor  | Axel Diaz        |Fecha |  10/12/2019   |
+----------------------------------------------------------------------------+
| Uso       # Muestra la leyenda en el grip                                  |
+----------------------------------------------------------------------------+
*/
User Function LeyenGrd()
     Local aLegenda := {}
     aAdd( aLegenda, { VERDE	,  	"Salida y la Entrada de material coinciden" })
     aAdd( aLegenda, { ROJO		,	"La cantidad en la Entrada es superior a la Salida" })
     aAdd( aLegenda, { GRIS		,	"Salida de Material sin Entrada" })
     aAdd( aLegenda, { AMARILLO	,	"La cantidad de la Salida es superior a la Entrada" })

     BrwLegenda( "Leyenda", "Leyenda de las lineas", aLegenda )
Return Nil
/*
+----------------------------------------------------------------------------+
| Programa  # LeyenAcm     |Autor  | Axel Diaz        |Fecha |  10/12/2019   |
+----------------------------------------------------------------------------+
| Uso       # Muestra la leyenda en el grip                                  |
+----------------------------------------------------------------------------+
*/
User Function LeyenBrw()
     Local aLegenda := {}
     aAdd( aLegenda, { VERDE		,  	EstadoDocLegalVERDE })
     aAdd( aLegenda, { VERDE_C		,  	EstadoDocLegalVERDEC })
     aAdd( aLegenda, { ROJO			,	EstadoDocLegalROJO })
     aAdd( aLegenda, { NARANJA		,	EstadoDocLegalNARANJA })
     aAdd( aLegenda, { AMARILLO		,	EstadoDocLegalAMARILLO })
     aAdd( aLegenda, { AZUL			,	EstadoDocLegalAZUL })
     aAdd( aLegenda, { BLANCO		,	EstadoDocLegalBLANCO })

     BrwLegenda( "Leyenda", "Leyenda de las lineas", aLegenda )
Return Nil

/*
+---------------------------------------------------------------------------+
|  Programa  |AjustaSX1            |Autor  |Axe Diaz |Data    06/01/2020    |
+---------------------------------------------------------------------------+
|  Uso       | Grupo de prerguntas al entrar                                |
+---------------------------------------------------------------------------+
*/
user Function AcmSX1(cPregunta)
	Local aRegs := {}
	Local cPerg := PADR(cPregunta,10)
	Local nI 	:= 0
	Local nJ	:= 0
	Local nLarDoc:= 0
	Local nLarSer:= 0
	// Local aHelpSpa:= {}
	DBSelectArea("SX3")
	DBSetOrder(2)
	dbSeek("ZX2_DOC")
	nLarDoc:=SX3->X3_TAMANHO
 	dbSeek("ZX2_SERIE")
	nLarSer:=SX3->X3_TAMANHO
	dbCloseArea("SX3")

	aAdd(aRegs,{cPerg,"01",DEFECHA		,DEFECHA	,DEFECHA	,"MV_CH01"	,"D"	, 08 	,0,2	,"G"	,"" 															,"MV_PAR01","" ,"" ,"" 	,"'01/01/20'"			,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02",AFECHA		,AFECHA		,AFECHA		,"MV_CH02"	,"D"	, 08 	,0,2	,"G"	,"!Empty(MV_PAR02) .And. MV_PAR01<=MV_PAR02" 					,"MV_PAR02","" ,"" ,"" 	,"'31/12/20'"			,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03",DESERIEO		,DESERIEO	,DESERIEO	,"MV_CH03"	,"C"	, 03	,0,2	,"G"	,"" 															,"MV_PAR03","" ,"" ,"" 	,"" 		 			,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04",ASERIE0		,ASERIE0	,ASERIE0	,"MV_CH04"	,"C"	, 03	,0,2	,"G"	,"!Empty(MV_PAR04) .And. MV_PAR03<=MV_PAR04" 					,"MV_PAR04","" ,"" ,"" 	,REPLICATE("Z",nLarSer) ,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05",DEDOCO		,DEDOCO		,DEDOCO		,"MV_CH05"	,"C"	, 13	,0,2	,"G"	,"" 															,"MV_PAR05","" ,"" ,"" 	,"" 					,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06",ADOCO		,ADOCO		,ADOCO		,"MV_CH06"	,"C"	, 13	,0,2	,"G"	,"!Empty(MV_PAR06) .And. MV_PAR05<=MV_PAR06" 					,"MV_PAR06","" ,"" ,"" 	,REPLICATE("Z",nLarDoc)	,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07",DESERIED		,DESERIED	,DESERIED	,"MV_CH07"	,"C"	, 03	,0,2	,"G"	,"" 															,"MV_PAR07","" ,"" ,"" 	,""						,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08",ASERIED		,ASERIED	,ASERIED	,"MV_CH08"	,"C"	, 03	,0,2	,"G"	,"!Empty(MV_PAR08) .And. MV_PAR07<=MV_PAR08" 					,"MV_PAR08","" ,"" ,""	,REPLICATE("Z",nLarSer) ,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09",DEDOCD		,DEDOCD		,DEDOCD		,"MV_CH09"	,"C"	, 13	,0,2	,"G"	,"" 															,"MV_PAR09","" ,"" ,"" 	,""						,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10",ADOCD		,ADOCD		,ADOCD		,"MV_CH10"	,"C"	, 13	,0,2	,"G"	,"!Empty(MV_PAR10) .And. MV_PAR09<=MV_PAR10" 					,"MV_PAR10","" ,"" ,"" 	,REPLICATE("Z",nLarDoc) ,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11",DIRDESTINO	,DIRDESTINO	,DIRDESTINO	,"MV_CH11"	,"C"	, 99	,0,2	,"G"	,"!Vazio().or.(MV_PAR11:=cGetFile('PDFs |*.*','',,,,176,.F.))" 	,"MV_PAR11","" ,"" ,"" 	,"C:\SPOOL\"			,"","","","","","","","","","","","","","","","","","","","","",""})


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
+-------------------------------------------------------------------------------------+
|  Programa  |MA261TRD3            |Autor  |Axe Diaz |Data    06/01/2020              |
+-------------------------------------------------------------------------------------+
|  Uso       | Punto de entrada de mata261 transferencia multiple                     |
+-------------------------------------------------------------------------------------+
| Se usa este punto de entrada para rellenar un arreglo definido como variable private|
| con esta variable se conocen los registros agregados, a traves del campo R_E_C_N_O_ |
| pudiendo actualizar campos especificos de la SD3                                    |
+-------------------------------------------------------------------------------------+
*/
// Punto entrada MATA261 execauto 
User Function MA261TRD3()
	If IsInCallStack("U_ACM010")
		aRecSD3 := PARAMIXB[1] 
	    For nX := 1 To Len(aRecSD3)
	    	SD3->(DbGoto(aRecSD3[nX][1])) // Requisicao RE4  // Salida del almacé
			If Reclock("SD3",.F.)
				Replace SD3->D3_OP With cSerO+RIGHT(cDocO,11)
				Replace SD3->D3_ACMSER With cSerO
				Replace SD3->D3_ACMDOC With cDocO
				MsUnlock()
			EndIF
	    	//cQry:= "UPDATE "+InitSqlName("SD3")+" SET D3_OP='"+cSerO+RIGHT(cDocO,11)+"',D3_ACMSER='"+cSerO+"',D3_ACMDOC='"+cDocO+"' FROM "+RetSQLName("SD3")+" WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_TM='999' AND R_E_C_N_O_='"+cValToChar(aRecSD3[nX][1])+"' AND D_E_L_E_T_=' '"
	    	//TCSQLEXEC(cQry)

	    	SD3->(DbGoto(aRecSD3[nX][2])) // Devolucao DE4  // Entrada al almacén
			If Reclock("SD3",.F.)
				Replace SD3->D3_OP With cSerD+RIGHT(cDocD,11)
				Replace SD3->D3_ACMSER With cSerD
				Replace SD3->D3_ACMDOC With cDocD
				MsUnlock()
			EndIF
	    	//cQry:= "UPDATE "+InitSqlName("SD3")+" SET D3_OP='"+cSerD+RIGHT(cDocD,11)+"',D3_ACMSER='"+cSerD+"',D3_ACMDOC='"+cDocD+"' FROM "+RetSQLName("SD3")+" WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_TM='499' AND R_E_C_N_O_='"+cValToChar(aRecSD3[nX][2])+"' AND D_E_L_E_T_=' '"
	    	//TCSQLEXEC(cQry)
    	Next nX
	EndIf
Return Nil

/*/{Protheus.doc} SaldosExec
description Calcula si hay saldo para la transferencia, antes de ejecutar el exeauto.
@type function
@version 
@author Axel Diaz
@since 1/6/2020
@param oModel, object, param_description
@return return_type, return_description
/*/
Static Function SaldosExec(oModel)
	Local oModelZX2		:= oModel:GetModel("ZX2MASTER")
	Local oModelZY2		:= oModel:GetModel("ZY2DETAIL")
	Local cAlmOri		:= oModelZX2:GetValue("ZX2_ALMORI")
	Local lSaldo		:= .T.
	Local NCantB2		:= 0
	cSaldo	:= ""
	For nI := 1 To oModelZY2:Length()
		oModelZY2:GoLine( nI )
		nCantY2	:=oModelZY2:GetValue("ZY2_CANTD")
		// Revisa el Saldo en SB2 y resta el saldo de este documento.
		NCantB2	:=POSICIONE("SB2",1, xFilial("SB2")+oModelZY2:GetValue("ZY2_CODPRO")+oModelZX2:GetValue("ZX2_ALMORI"),"B2_QATU")-;
					POSICIONE("SB2",1, xFilial("SB2")+oModelZY2:GetValue("ZY2_CODPRO")+oModelZX2:GetValue("ZX2_ALMORI"),"B2_QEMP")
		IF NCantB2-nCantY2<0
			lSaldo:=.F.
			cSaldo+="<br><b>"+oModelZY2:GetValue("ZY2_CODPRO")+"</b>-"+POSICIONE('SB1',1,xfilial('SB1')+oModelZY2:GetValue("ZY2_CODPRO"),'B1_DESC')
		EndIf
	NexT
//	If !lSaldo
//		Help(NIL, NIL, "Saldo Insuficiente",NIL,"Cantidad en la Bodega Origen es insuficiente para hacer el despacho interno", 1, 0, NIL, NIL, NIL, NIL, NIL,{"Revise las cantidades:"+cSaldo}) 
//	EndIf
Return lSaldo
/*
// Puntos entrada KARDEX
User Function MC030PRJ()  



Local ExpC1   := PARAMIXB[1]  
Local ExpA2   := PARAMIXB[2]  
Local ExpA3   := PARAMIXB[3] 

//Customização do usuário para manipulação dos campos do array na visualização da consulta do KarReturn {ExpA2, ExpA3}
Return {ExpA2,ExpA3}

User Function MC030PRD()
Local aRetCabec := {}
AADD(aRetCabec,'  ')     
AADD(aRetCabec,'                KARDEX CON SEGUNDA UNIDAD DE MEDIDA MODIFICADO PARA ACME LEON SAS')     
AADD(aRetCabec,'                -----------------------------------------------------------------') 
AADD(aRetCabec,'  ')      
Return aRetCabec  

User Function MC030PIC()
Local aPictures := ParamIXB[1] 
//-- Array contendo as picture de quantidade e total
//-- aPictures[1] 
//-- Picture da quantidade (Conteudo fixado em 11 Caracteres.)
//-- aPictures[2] 
//-- Picture do Total da Quantidade (Conteudo fixado em 13 Caracteres.)Local aPictRet := {}
//-- Validações do UsuarioReturn aPictRet 
//-- Array contendo as pictures de quantidade e total da quantidade 
return aPictures
// Arreglo de encabezado
User Function MC030ARR()
Local ExpA1 := PARAMIXB[1]
Local ExpC2 := PARAMIXB[2]  

//AddArray({SD1->D1_DTDIGIT,SUBS(SD1->D1_TES,1,3),SD1->D1_CF,SD1->D1_DOC," "," ",cIdent,TRANSF(SD1->D1_QUANT,cPictQT),TRANSF((IIF(mv_par05=1,SD1->D1_CUSTO,&("SD1->D1_CUSTO"+Str(mv_par05,1,0)))/SD1->D1_QUANT),PesqPict("SB2","B2_CM1")),TRANSF(IIF(mv_par05=1,SD1->D1_CUSTO,&("SD1->D1_CUSTO"+Str(mv_par05,1,0))),PesqPict("SD1","D1_CUSTO")),SD1->D1_LOTECTL,SD1->D1_NUMLOTE },aDados[i,1])

//Validações do Usuário Return(ExpA3) 
Return ExpA1

User Function MC030SALD()
Local ExpA1 := PARAMIXB[1]
Return ExpA1
