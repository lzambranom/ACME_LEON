#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'ACME271.ch'
/*/{Protheus.doc} ACME271
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@return return_type, return_description
/*/
User Function ACME271()
	Local oBrowse
	Local aArea			:= GetArea()
	Local aCampos		:= {}
	Local cZD3			:= GetNextAlias()
	Local cFiltro		:= ""
	Local aSeek			:= {}
	
	CHKFILE("ZX4")
	CHKFILE("ZY4")
	
 	Private aRotina		:= MenuDef()
 	Private cTMSelect	:= ""
 	Private cLCSelect	:= ""

 	fFilAcm1(@cFiltro)
	If EMPTY(cFiltro)
		//Return
	EndIf
 	
 	
 	Aadd(aSeek,{"Filial+Doc+Tm"   	, {{"","C",18,0, "ZX4_FILIAL+ZX4_DOC+ZX4_TM",""}},1,.T. } )
 	Aadd(aSeek,{"Filial+Tm+Doc"   	, {{"","C",18,0, "ZX4_FILIAL+ZX4_TM+ZX4_DOC",""}},2,.T. } )

	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias('ZX4')  
	oBrowse:SetDescription(OemToAnsi(STR001)) //"Movimientos Pistoleo Acme"
	oBrowse:AddLegend( "ZX4_TM>='500'", VERDE, EstadoVERDE) 
	oBrowse:AddLegend( "ZX4_TM<='499'", ROJO , EstadoROJO) 

	oBrowse:SetFixedBrowse(.F.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetFilterDefault(cFiltro)
	oBrowse:DisableDetails()
	oBrowse:SetSeek(.T.,aSeek)
	oBrowse:SetLocate()
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetWalkThru(.F.) 
	oBrowse:Refresh(.T.)
	oBrowse:SetDoubleClick({||AcmVerM() })
	oBrowse:Activate()
	oBrowse:Destroy()
	RestArea(aArea)	

Return NIL 
/*/{Protheus.doc} MenuDef
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@return return_type, return_description
/*/
Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina Title OemToAnsi(STR002) Action 'VIEWDEF.ACME271' OPERATION MODEL_OPERATION_VIEW      ACCESS 0  
	ADD OPTION aRotina Title OemToAnsi(STR003) Action 'VIEWDEF.ACME271' OPERATION MODEL_OPERATION_INSERT    ACCESS 0 //OPERATION 3 
	//ADD OPTION aRotina Title OemToAnsi(STR004) Action 'VIEWDEF.ACME271' OPERATION MODEL_OPERATION_UPDATE    ACCESS 0 //OPERATION 4  
	ADD OPTION aRotina Title OemToAnsi(STR005) Action 'VIEWDEF.ACME271' OPERATION MODEL_OPERATION_DELETE ACCESS 0  
	ADD OPTION aRotina Title OemToAnsi(STR006) Action 'VIEWDEF.ACME271' OPERATION MODEL_OPERATION_IMPRESION ACCESS 0  
	//ADD OPTION aRotina Title OemToAnsi(STR007) Action 'VIEWDEF.ACME271' OPERATION MODEL_OPERATION_COPIAR    ACCESS 0  
Return aRotina	

/*/{Protheus.doc} ModelDef
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@return return_type, return_description
/*/
Static Function ModelDef()  
	Local oStHeader 	:= FWFormStruct( 1, 'ZX4' ) 
	Local oStDetail 	:= FWFormStruct( 1, 'ZY4' ) 
	Local oModel  
	Local aZY4Rel	:= {}
	
	oModel := MPFormModel():New('ACME271M', { | oModel | PreVio(oModel) }, { | oModel | PosCommit( oModel ) } )  
	oModel:AddFields( 'ZX4MASTER', /*cOwner*/  , oStHeader)
	oModel:AddGrid  ( 'ZY4DETAIL', 'ZX4MASTER' , oStDetail, { |oModelGrid, nLine ,cAction,cField| ACMLPRE(oModelGrid, nLine, cAction, cField) })
	 
	//oModel:SetDescription(STR008)  // "Modelo de dados de Entrada/Salida"
	oModel:GetModel( 'ZX4MASTER' ):SetDescription(OemToAnsi(STR009)) // "Dados de Entrada/Salida"
	
	// Hacer la relaciï¿½n entre padre e hijo
	aAdd(aZY4Rel, {'ZY4_FILIAL'	, 'xFilial( "ZY4" )'})
	aAdd(aZY4Rel, {'ZY4_DOC'	, 'ZX4_DOC'			})
	aAdd(aZY4Rel, {'ZY4_TM' 	, 'ZX4_TM'			})

	oModel:SetRelation('ZY4DETAIL', aZY4Rel, ZY4->(IndexKey(1))) // IndexKey -> Quiero ordenar y luego filtrar
	oModel:GetModel('ZY4DETAIL'):SetUniqueLine({"ZY4_COD"})	// No repita informaciï¿½n o combinaciones {"CAMPO1", "CAMPO2", "CAMPOX"}
	oModel:SetPrimaryKey({})

	// Establecer las descripciones
	oModel:SetDescription(OemToAnsi(STR010)) // "Movimientos multiples Acme Leon"
	oModel:GetModel('ZX4MASTER'):SetDescription(OemToAnsi(STR011)) // "Encabezado Movimiento"
	oModel:GetModel('ZY4DETAIL'):SetDescription(OemToAnsi(STR012)) // "Detalles del Movimiento"
Return oModel

/*/{Protheus.doc} ViewDef
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@return return_type, return_description
/*/
Static Function ViewDef()  
	Local oModel	:= FWLoadModel('ACME271')
	Local oView 	:= FWFormView():New()
	Local oStHeader	:= FWFormStruct( 2, 'ZX4' )
	Local oStDetail	:= FWFormStruct( 2, 'ZY4' )

	oView:SetModel( oModel ) 
	oView:AddField('VIEW_ZX4'	,oStHeader,'ZX4MASTER')
	oView:AddGrid( 'VIEW_ZY4'	,oStDetail,'ZY4DETAIL')	
	
	oView:CreateHorizontalBox( 'SUPERIOR', 35 )  
	oView:CreateHorizontalBox( 'INFERIOR', 65 )

	oView:CreateVerticalBox( 'INFERIORIZQ', 10, 'INFERIOR' )  
	oView:CreateVerticalBox( 'INFERIORDER', 90, 'INFERIOR' ) 


	oView:SetOwnerView( 'VIEW_ZX4', 'SUPERIOR' )  
	oView:SetOwnerView( 'VIEW_ZY4', 'INFERIORDER' )

	oView:EnableTitleView('VIEW_ZX4',OemToAnsi(STR013))
	oView:EnableTitleView('VIEW_ZY4',OemToAnsi(STR014))

	oView:AddOtherObject("PANEL_CODBAR", {|oPanel| BTNPANELDER(oPanel)}) 
	oView:SetOwnerView("PANEL_CODBAR",'INFERIORIZQ')

	oView:SetCloseOnOk({||.T.})
	oView:AddIncrementField('VIEW_ZY4' , 'ZY4_ITEM' )
	oView:SetViewProperty( 'VIEW_ZY4', "SETCSS", { "QTableView { selection-background-color: #1C9DBD; }" } ) 
Return oView

/*/{Protheus.doc} fFilAcm1
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@param cFiltro, character, param_description
@return return_type, return_description
/*/
Static Function fFilAcm1(cFiltro)
cFiltro:="ZX4_TM>='000'"
Return


/*/{Protheus.doc} BTNPANELDER
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@param oPanel, object, param_description
@return return_type, return_description
/*/
Static Function BTNPANELDER( oPanel )  
	Local lOk := .F. 
	Local oView		:= FWViewActive()
	Local oModel	:= FWModelActive()
	Local cCSSCBar	:= ""
	Local nOperation 	:= oModel:GetOperation()
	
	cCSSCBar := "QPushButton {"
	cCSSCBar += " border: 1px solid gray; border-radius: 3px;"
	cCSSCBar += " background-image: url(rpo:captura1.png);background-repeat: none; background-position: center;"
	cCSSCBar += " padding: 0px;"
	cCSSCBar += "}"
	cCSSCBar += "QPushButton:pressed {"
	cCSSCBar += " background-image: url(rpo:captura2.png);background-repeat: none; background-position: center;"
	cCSSCBar += " border-style: inset;"
	cCSSCBar += "}"
	cCSSCBar += "QPushButton:hover {"
	cCSSCBar += " background-image: url(rpo:captura3.png);background-repeat: none; background-position: center;"
	cCSSCBar += "}"
 
	oTButton1 := TButton():New( 010, 005, " "  		,oPanel,{||U_CodBarL2(oModel,oView)}	, 55,20,,,.F.,.T.,.F.,,.F.,{|| IIF((!EMPTY(M->ZX4_DOC) .AND. !EMPTY(M->ZX4_TM) ),.T.,.F.)      }	,,.F. )   
	
	oTButton1:SetCss(cCSSCBar)

Return NIL

/*/{Protheus.doc} CodBarL2
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@param oMdl, object, param_description
@param oVw, object, param_description
@return return_type, return_description
/*/
User Function CodBarL2(oMdl,oVw)
	Local cTexto := ""//"17706516009178"+CRLF+"17706516009178"+CRLF+"17706516009178"+CRLF+"17706516009178"+CRLF+"17706516009178"+CRLF+"17706516009178"
	Local oDlg
	Local oMemo
	Local Retorno
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR023) FROM 0,0 TO 555,650 PIXEL
	     @ 005, 005 GET oMemo VAR cTexto MEMO SIZE 315, 250 OF oDlg PIXEL
	     @ 260, 280 Button OemToAnsi(STR024) Size 035, 015 PIXEL OF oDlg Action(processa( {|| u_CdBarPr2(oDlg,cTexto,oMdl,oVw) }, OemToAnsi(STR015), OemToAnsi(STR016), .f.))
	     @ 260, 230 Button OemToAnsi(STR025) Size 035, 015 PIXEL OF oDlg Action oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED
Return

/*/{Protheus.doc} CdBarPr2
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@param oDlg, object, param_description
@param cTexto, character, param_description
@param oMdl, object, param_description
@param oView, object, param_description
@return return_type, return_description
/*/
User Function CdBarPr2(oDlg,cTexto,oMdl,oView)
	Local aLineas    := {}
	Local aLinTmp    := {}
	Local aProduc    := {}
	Local aCodBar    := {}
	Local nI,nJ,nX   := 0
	Local oModelZY4, oModelZX4
	Local lInsert    := .T.
	Local lPaso      := .F.
	Local nTamCod    := 0
	Local nTamBar    := 0
	Private cCodBarx := ''
	dbSeek("B1_COD")
	nTamCod          := SX3->X3_TAMANHO
	dbSeek("B1_CODBAR")
	nTamBar          := SX3->X3_TAMANHO
	
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
			incproc(OemToAnsi(STR018))
			For nJ:=1 to Len(aCodBar)     
				If aLineas[nI]==aCodBar[nJ][1]   // Si encuentra el codigo de barra nuevamente Suma 1   
					aCodBar[nJ][2] := aCodBar[nJ][2]+1
					aProduc[nJ][2] := aProduc[nJ][2]+1
					lAdd           := .F.
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
			cCodBarx:=''
			BusCodBar(aCodBar[nI][1],) // POSICIONE('SB1',5,xFilial("SB1")+SUBSTR(aCodBar[nI][1]+SPACE(nTamBar),1,nTamBar),"B1_COD")
			aProduc[nI][1]:= cCodBarx
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
		If MsgYesNo(OemToAnsi(STR017)+CRLF+cTexto)
		     oModelZX4:= oMdl:GetModel("ZX4MASTER")
		     oModelZY4:= oMdl:GetModel("ZY4DETAIL")
		     If INCLUI
		     	For nI:=1 to len(aProduc)
		     		incproc(OemToAnsi(STR018))
		     		If aProduc[nI][2]>0
			     		For nJ:=1 to (oModelZY4:Length()) 
			     			oModelZY4:GoLine( nJ )
			     			If oModelZY4:GetValue("ZY4_COD")==aProduc[nI][1] 
			     				lInsert:=.F.
			     				nX:=nJ
			     			EndIf
			     		Next
			     		If lInsert
			     			oModelZY4:AddLine()
			     		Else
			     			oModelZY4:GoLine( nX )
			     			oModelZY4:UnDeleteLine()
				     	End
				     	oModelZY4:SetValue("ZY4_COD"	, 	aProduc[nI][1] )
				     	oModelZY4:SetValue("ZY4_CODBAR" , 	aCodBar[nI][1] )
				     	oModelZY4:SetValue("ZY4_QUANT"	, 	aCodBar[nI][2]+ oModelZY4:GetValue("ZY4_QUANT"))
						
				     	lInsert:=.T.
			     	EndIf
		     	Next
			 EndIf
		    
		     Retorno := oDlg:End()
		     oModelZY4:GoLine( 1 )
			 oModelZY4:SetLine( 1 )
			 oView:Refresh()
		Else
			 MsgAlert(OemToAnsi(STR020 ))
		     Retorno := oDlg:End()
		EndIf
	Else
		MsgAlert(OemToAnsi(STR021))
	    Retorno := oDlg:End()
	EndIf
Return(Retorno)

/*/{Protheus.doc} PreVio
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@param oModel, object, param_description
@return return_type, return_description
/*/
Static Function PreVio( oModel ) 
	Local lRet 			:= .T.
	Local oModelZX4	:= oModel:GetModel('ZX4MASTER')
	Local oModelZY4	:= oModel:GetModel('ZY4DETAIL')
	SetKey(VK_F4, {||  MaViewSB2(oModelZY4:GetValue('ZY4_COD')) })
Return lRet 
/*/{Protheus.doc} PosCommit
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@param oModel, object, param_description
@return return_type, return_description
/*/
Static Function PosCommit(oModel) 
	Local lRet 			:= .T.
	Local nOperation:= oModel:GetOperation()
	Local oModelZY4	:= oModel:GetModel('ZY4DETAIL')
	Local oModelZX4	:= oModel:GetModel('ZX4MASTER')
	Local nI		:=0
	Local lSaldo	:= .T.
	Local cSaldo	:= ""
	Local cDoc		:= oModel:GetValue("ZX4MASTER","ZX4_DOC" )
	Local cTM		:= oModel:GetValue("ZX4MASTER","ZX4_TM")
	Local nQUANT	:= 0
	Local nCantB2	:= 0

	Private cSD3Doc	:= ""
	If nOperation == MODEL_OPERATION_INSERT
		If VAL(ALLTRIM(cTM))>499  //Salida de Materiales.. se revisa Saldo
			For nI:=1 to (oModelZY4:Length()) 
				oModelZY4:GoLine( nI )
				
				nQUANT	:=oModelZY4:GetValue("ZY4_QUANT")
				// Revisa el Saldo en SB2 y resta el saldo de este documento.
				NCantB2	:=POSICIONE("SB2",1, xFilial("SB2")+oModelZY4:GetValue("ZY4_COD")+oModelZX4:GetValue("ZX4_LOCAL"),"B2_QATU")-;
						POSICIONE("SB2",1, xFilial("SB2")+oModelZY4:GetValue("ZY4_COD")+oModelZX4:GetValue("ZX4_LOCAL"),"B2_QEMP")
				IF NCantB2-nQUANT<0
					lSaldo:=.F.
					cSaldo+="<br><b>"+oModelZY4:GetValue("ZY4_COD")+"</b>-"+oModelZY4:GetValue("ZY4_DESCRI")
				Endif
			Next
		EndIf
		If lSaldo
			If u_ACEX271(oModel,nOperation)
				oModelZX4:SetValue("ZX4_RESPON"	,UsrRetName(RetCodUsr()))
				oModelZX4:SetValue("ZX4_TIME"	,TIME())
				oModelZX4:SetValue("ZX4_D3DOC"	,cSD3Doc)
			else
				lRet := .F.
				Help(NIL, NIL, STR031, NIL, STR032, 1, 0, NIL, NIL, NIL, NIL, NIL,{STR033})
			EndIf
		Else
			Help(NIL, NIL, STR028,NIL,STR029, 1, 0, NIL, NIL, NIL, NIL, NIL,{STR030+cSaldo}) 
			lRet := .F.
		EndIf
	ElseIf nOperation == MODEL_OPERATION_DELETE
	
		If u_ACEX271(oModel,MODEL_OPERATION_REVERSION)

		EndIf
	ENDIF
Return lRet 


Static Function ACMLPRE( oModelGrid, nLinha, cAcao, cCampo )
	Local lRet 		:= .T.
	Local oModel 	:= oModelGrid:GetModel()
	Local oModelZX4	:= oModel:GetModel("ZX4MASTER")
	Local oModelZY4	:= oModel:GetModel("ZY4DETAIL")
	Local nOperation:= oModel:GetOperation()

	If Empty(AllTrim(oModelZX4:GetValue('ZX4_TM'))) .OR. ;
		Empty(AllTrim(oModelZX4:GetValue('ZX4_DOC'))) .OR. ;
		Empty(AllTrim(oModelZX4:GetValue('ZX4_LOCAL')))
		MsgInfo(STR026,STR027)
		lRet := .F.
	EndIf
 
RETURN lRet 

/*/{Protheus.doc} ACEX261
description
@type function
@version 
@author Axel Diaz
@since 9/4/2020
@return return_type, return_description
/*/
User function ACEX271(oModel,nOperation)
	Local oModelZX4		:= oModel:GetModel("ZX4MASTER")
	Local oModelZY4		:= oModel:GetModel("ZY4DETAIL")
	Local nJ			:= 0
	Local _aCab1 		:= {}
	Local _aItem 		:= {}
	Local _atotitem		:= {}
	Local cDeposito		:= oModelZX4:GetValue("ZX4_LOCAL")
	Local dEmissao		:= oModelZX4:GetValue("ZX4_EMISSA")
	Local cCentCost		:= oModelZX4:GetValue("ZX4_CC")
	Local nSegunQt		:= 0
	Local nQuant		:= 0
	Local cCod 			:= ""
	Local cSD3DOC		:= ""
	Local cRetorno		:= " "
	Private cCodigoTM	:= oModelZX4:GetValue("ZX4_TM")
	Private cDoc		:= oModelZX4:GetValue("ZX4_DOC")
	Private cTMDesc		:= oModelZX4:GetValue("ZX4_TMDESC")
	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao

	If nOperation == MODEL_OPERATION_REVERSION
		cSD3DOC := oModelZX4:GetValue("ZX4_D3DOC")
	else
		cSD3DOC := NextNumero("SD3",2,"D3_DOC",.T.)
	EndIf	

	_aCab1 := {{"D3_DOC" ,NextNumero("SD3",2,"D3_DOC",.T.), NIL},;
			{"D3_TM" ,cCodigoTM , NIL},;
			{"D3_CC" ,cCentCost, NIL},;
			{"D3_EMISSAO" ,dEmissao, NIL}}

	For nJ:=1 to (oModelZY4:Length()) 
		oModelZY4:GoLine( nJ )
		nQuant	:=oModelZY4:GetValue("ZY4_QUANT")
		cCod	:=oModelZY4:GetValue("ZY4_COD")
		nSegunQt:=u_FacConv(nQuant,cCod,.F.)
		_aItem:={{"D3_COD" 		,cCod 								,NIL},;
				 {"D3_UM" 		,oModelZY4:GetValue("ZY4_UM")		,NIL},; 
				 {"D3_QUANT" 	,nQuant 							,NIL},;
				 {"D3_LOCAL" 	,cDeposito 							,NIL},;
				 {"D3_LOTECTL" 	,""									,NIL},;
				 {"D3_LOCALIZ" 	,""									,NIL},;
				 {"D3_SEGUM" 	,oModelZY4:GetValue("ZY4_SEGUM")	,NIL},;
				 {"D3_CONTA" 	,oModelZY4:GetValue("ZY4_CONTA")	,NIL},;
				 {"D3_DESCRI"	,oModelZY4:GetValue("ZY4_DESCRI")	,Nil},;
				 {"D3_DTVALID"	,ctod("  /  /  ")					,Nil},;
				 {"D3_NUMSERI"	,""									,Nil},;		//Numero serie
				 {"D3_NUMLOTE"	,""									,Nil},; 	//sublote origem
				 {"D3_POTENCI"	,0									,Nil},; 	//Potencia
				 {"D3_QTSEGUM"	,nSegunQt							,Nil},; 	//Seg unidade medida
	    		 {"D3_ESTORNO"	,""									,Nil},; 	//Estorno
	    		 {"D3_NUMSEQ"	,""									,Nil},; 	//Numero sequencia D3_NUMSEQ
	    		 {"D3_ITEMGRD"	,""									,Nil},;		//Item Grade
	    		 {"D3_CODLAN"	,""									,Nil}}		//cat83 prod origem
		If nOperation == MODEL_OPERATION_REVERSION		 
			aadd(_aItem,{"D3_ESTORNO"	,"S"						,Nil})		//Reversion
		EndIf
		aadd(_atotitem,_aitem) 
	Next nJ
	CriaSB2(oModelZY4:GetValue("ZY4_COD"),cDeposito)
	MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,nOperation)

	If lMsErroAuto 
		Mostraerro() 
		DisarmTransaction() 
		RETURN .F.
	EndIf
Return .T.

/*/
pUNTO DE ENTRADA
/*/
User Function MT241SD3()
	If isincallstack("U_ACME271")
		If Reclock("SD3",.F.)
			Replace  SD3->D3_OP			With SUBSTR(cTMDesc,2,3)+cDoc
			Replace  SD3->D3_ACMDOC		With cDoc
			Replace  SD3->D3_ACMSER		With cCodigoTM
			SD2->(MsUnlock())
			cSD3Doc:= SD3->D3_DOC
		Endif
	Endif
Return


Static Function AcmVer()
	Local oModel	:= FWLoadModel('ACME271')
	Local lRet	:= .F.
	If oModel:Activate(.T.)
			FWExecView("Ver documento",'VIEWDEF.ACME271',MODEL_OPERATION_VIEW,,,,,)
	Else
        Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0)   
    EndIf
Return lRet



User Function GetTMAc()
	// sustituye a SF5AC2
	Local lRet		:= .T.
	Local aTMAc		:=	{}
	Local lAllTm	:= .F.
	Local bLine, cOpc, nAt
	Local lOk       := .F.
	Local oDlg, oItem, nOAt
	Local cUser		:= AvKey(UsrRetName(RetCodUsr()),"ZZV_USRCOD")

	// Local cTMSelect	:= ""
	cTMSelect:=""
	DBSelectArea("ZZV")
	DBSetOrder(1)
    DBGotop()
    DBSeek(xfilial("ZZV")+cUser)
	While !Eof() .AND. ZZV->ZZV_USRCOD==cUser
		If Alltrim(ZZV->ZZV_TM)=="*"
			lAllTm	:= .T.
		EndIf
		aadd(aTMAc,{ZZV->ZZV_TM,ZZV->ZZV_TEXTO})
		DBSkip()
	Enddo
	DBCloseArea("ZZV")

	If lAllTm
		aTMAc:={}
		DBSelectArea("SF5")
		DBSetOrder(1)
    	DBGotop()
		WHILE !Eof()
			aadd(aTMAc,{SF5->F5_CODIGO,SF5->F5_TEXTO})
			DBSkip()
		ENDdo
	EndIf
	DBCloseArea("SF5")

	If Len(aTMAc) == 0 	// revisa si tiene alguna serie autorizada
		Help(NIL, NIL, "Usuario sin Asociacion", NIL, "Usuario sin asociacion de Movimientos", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Ubique la rutina de Administracion de Usuarios vs Movimientos "})
		Return lOk
	EndIf
	
	// creao ventana de dialogo
	DEFINE MSDIALOG oDlg TITLE "Tipos de Movimiento" From 150,175 To 305,640 OF oMainWnd PIXEL
		@ 05,10 LISTBOX oItem VAR cOpc Fields HEADER OemToAnsi("TM"), OemToAnsi("DescripciÃ³n") SIZE 200,65  OF oDlg PIXEL
		oItem:SetArray(aTMAc)
		oItem:bLine := { || {aTMAc[oItem:nAt,1], aTMAc[oItem:nAt,2]}}
		DEFINE SBUTTON FROM 03,210 TYPE 1 ENABLE OF oDlg ACTION (lOk:=.T.,oDlg:End())
		DEFINE SBUTTON FROM 18,210 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg VALID (nOAT := oItem:nAT,.T.) CENTERED
	
	If lOk .And. (Inclui .Or. Altera)
			&(ReadVar()) := ALLTRIM(aTMAc[nOAt, 1])
			cTMSelect := ALLTRIM(aTMAc[nOAt, 1])
	EndIf
Return lOk


User Function GetLOAc()
	// sustituye a SF5AC2
	Local lRet		:= .T.
	Local aLCAc		:=	{}
	Local lAllTm	:= .F.
	Local bLine, cOpc, nAt
	Local lOk       := .F.
	Local oDlg, oItem, nOAt
	Local cUser		:= AvKey(UsrRetName(RetCodUsr()),"ZZV_USRCOD")

	// Local cTMSelect	:= ""
	cLCSelect:=""
	DBSelectArea("ZZW")
	DBSetOrder(1)
    DBGotop()
    DBSeek(xfilial("ZZW")+cUser)
	While !Eof() .AND. ZZW->ZZW_USRCOD==cUser
		If Alltrim(ZZW->ZZW_LOCAL)=="*"
			lAllTm	:= .T.
		EndIf
		aadd(aLCAc,{ZZW->ZZW_LOCAL,ZZW->ZZW_DESCRI})
		DBSkip()
	Enddo
	DBCloseArea("ZZW")

	If lAllTm
		aLCAc:={}
		DBSelectArea("NNR")
		DBSetOrder(1)
    	DBGotop()
		WHILE !Eof()
			aadd(aLCAc,{NNR->NNR_CODIGO,NNR->NNR_DESCRI})
			DBSkip()
		ENDdo
	EndIf
	DBCloseArea("NNR")

	If Len(aLCAc) == 0 	// revisa si tiene alguna serie autorizada
		Help(NIL, NIL, "Usuario sin Asociacion", NIL, "Usuario sin asociacion de Bodega", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Ubique la rutina de Administracion de Usuarios vs Movimientos "})
		Return lOk
	EndIf
	
	// creao ventana de dialogo
	DEFINE MSDIALOG oDlg TITLE "Bodegas" From 150,175 To 305,640 OF oMainWnd PIXEL
		@ 05,10 LISTBOX oItem VAR cOpc Fields HEADER OemToAnsi("Bodega"), OemToAnsi("Descripción") SIZE 200,65  OF oDlg PIXEL
		oItem:SetArray(aLCAc)
		oItem:bLine := { || {aLCAc[oItem:nAt,1], aLCAc[oItem:nAt,2]}}
		DEFINE SBUTTON FROM 03,210 TYPE 1 ENABLE OF oDlg ACTION (lOk:=.T.,oDlg:End())
		DEFINE SBUTTON FROM 18,210 TYPE 2 ENABLE OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg VALID (nOAT := oItem:nAT,.T.) CENTERED
	
	If lOk .And. (Inclui .Or. Altera)
			&(ReadVar()) := ALLTRIM(aLCAc[nOAt, 1])
			cLCSelect := ALLTRIM(aLCAc[nOAt, 1])
	EndIf
Return lOk


/*/{Protheus.doc} Localtm
	(long_description)
	@type  Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function UserTM(cTM)
	Local lRet	:= .F.
	Local cUser	:= AvKey(UsrRetName(RetCodUsr()),"ZZV_USRCOD")
	DBSelectArea("ZZV")
	DBSetOrder(1)
    DBGotop()
    DBSeek(xfilial("ZZV")+cUser)
	While !Eof() .AND. ZZV->ZZV_USRCOD==cUser
		If ALLTRIM(ZZV->ZZV_TM)==ALLTRIM(cTM) .or. ALLTRIM(ZZV->ZZV_TM)=="*"
			lRet:=.T.
		EndIf
		DBSkip()
	Enddo
Return lRet

/*/{Protheus.doc} UsrLocal
description
@type function
@version 
@author Axel Diaz
@since 12/4/2020
@param cUser, character, param_description
@param cLocal, character, param_description
@return return_type, return_description
/*/
User Function UsrLocal(cLocal)
	Local lRet	:= .F.
	Local cUser	:= AvKey(UsrRetName(RetCodUsr()),"ZZV_USRCOD")
	DBSelectArea("ZZW")
	DBSetOrder(1)
    DBGotop()
    DBSeek(xfilial("ZZW")+cUser)
	While !Eof() .AND. ZZW_USRCOD==cUser
		If ALLTRIM(ZZW->ZZW_LOCAL)==ALLTRIM(cLocal) .or. ALLTRIM(ZZW->ZZW_LOCAL)=="*"
			lRet:=.T.
		EndIf
		DBSkip()
	Enddo
Return lRet

static function BusCodBar(cCodBar)
	Local cQry			:= ""
	Local cB1_Cod		:= ""
	Private cAliasCB	:= GetNextAlias()
	cQry	:= " SELECT B1_COD FROM "+ InitSqlName("SB1") +" SB1"
	cQry	+= " WHERE B1_FILIAL='"+xFilial("SB1")+"' AND D_E_L_E_T_=' ' " 
	cQry	+= " AND B1_CODBAR='"+alltrim(cCodBar)+"' 
	
	dbUseArea(.T.,"TOPCONN", TcGenQry(nil,nil,cQry) ,cAliasCB,.T.,.T.)
	DbSelectArea(cAliasCB)
	(cAliasCB)->(DbGoTop())
	If (cAliasCB)->(!EOF())
		cB1_Cod:=(cAliasCB)->B1_COD
		cCodBarx:=(cAliasCB)->B1_COD
	EndIf
	(cAliasCB)->(dbCloseArea())
Return cB1_Cod
	
	
	