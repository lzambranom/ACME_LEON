#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'ACMSE2.ch'
USER FUNCTION ACMSE2
	Local oBrowse
	Local aArea			:= GetArea()
	Local aCampos		:= {}
	Local cZD3			:= GetNextAlias()
	Local cFiltro		:= ""
	Local aSeek			:= {}
	
	CHKFILE("ZZZ")  // USUARIOS
	CHKFILE("ZZV")
	CHKFILE("ZZW")

 	Private aRotina	:= MenuDef()

 	fFilAcm1(@cFiltro)
	If EMPTY(cFiltro)
		//Return
	EndIf
 	
 	
 	Aadd(aSeek,{"Filial+Doc"   	, {{"","C",18,0, "ZZZ_FILIAL+ZZZ_USRCOD",""}},1,.T. } )
 
	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias('ZZZ')  
	oBrowse:SetDescription(OemToAnsi(STR001)) //"Movimientos Pistoleo Acme"
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

Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina Title OemToAnsi(STR002) Action 'VIEWDEF.ACMSE2' OPERATION MODEL_OPERATION_VIEW		ACCESS 0  
	ADD OPTION aRotina Title OemToAnsi(STR003) Action 'VIEWDEF.ACMSE2' OPERATION MODEL_OPERATION_INSERT		ACCESS 0 //OPERATION 3 
	ADD OPTION aRotina Title OemToAnsi(STR004) Action 'VIEWDEF.ACMSE2' OPERATION MODEL_OPERATION_UPDATE		ACCESS 0 //OPERATION 4  
	ADD OPTION aRotina Title OemToAnsi(STR005) Action 'VIEWDEF.ACMSE2' OPERATION MODEL_OPERATION_DELETE 	ACCESS 0  
	ADD OPTION aRotina Title OemToAnsi(STR006) Action 'VIEWDEF.ACMSE2' OPERATION MODEL_OPERATION_IMPRESION	ACCESS 0  
	//ADD OPTION aRotina Title OemToAnsi(STR007) Action 'VIEWDEF.ACME271' OPERATION MODEL_OPERATION_COPIAR    ACCESS 0  
Return aRotina	

Static Function ModelDef()  
	Local oStHeader 	:= FWFormStruct( 1, 'ZZZ' ) 
	Local oStDetZZV 	:= FWFormStruct( 1, 'ZZV' ) 
	Local oStDetZZW 	:= FWFormStruct( 1, 'ZZW' ) 
	Local oModel  
	Local aZZVRel		:= {}
	Local aZZWRel		:= {}

	oModel := MPFormModel():New('ACMSE2M')  
	oModel:AddFields( 'ZZZMASTER', /*cOwner*/  , oStHeader)
	oModel:AddGrid  ( 'ZZVDETAIL', 'ZZZMASTER' , oStDetZZV)
	oModel:AddGrid  ( 'ZZWDETAIL', 'ZZZMASTER' , oStDetZZW)

	aAdd(aZZVRel, {'ZZV_FILIAL'	, 'xFilial( "ZZV" )'})
	aAdd(aZZVRel, {'ZZV_USRCOD'	, 'ZZZ_USRCOD'		})
	oModel:SetRelation('ZZVDETAIL', aZZVRel, ZZV->(IndexKey(1))) // IndexKey -> Quiero ordenar y luego filtrar

	
	aAdd(aZZWRel, {'ZZW_FILIAL'	, 'xFilial( "ZZW" )'})
	aAdd(aZZWRel, {'ZZW_USRCOD'	, 'ZZZ_USRCOD'		})
	oModel:SetRelation('ZZWDETAIL', aZZWRel, ZZW->(IndexKey(1))) // IndexKey -> Quiero ordenar y luego filtrar

	oModel:GetModel('ZZVDETAIL'):SetUniqueLine({"ZZV_TM"})	// No repita informaci�n o combinaciones {"CAMPO1", "CAMPO2", "CAMPOX"}
	oModel:GetModel('ZZWDETAIL'):SetUniqueLine({"ZZW_LOCAL"})	// No repita informaci�n o combinaciones {"CAMPO1", "CAMPO2", "CAMPOX"}

	oModel:SetPrimaryKey({})

	// Establecer las descripciones
	oModel:SetDescription(OemToAnsi(STR010)) // "Movimientos multiples Acme Leon"
	oModel:GetModel('ZZZMASTER'):SetDescription(OemToAnsi(STR011)) // "Encabezado Movimiento"
	oModel:GetModel('ZZVDETAIL'):SetDescription(OemToAnsi(STR012)) // "Detalles del Movimiento"
	oModel:GetModel('ZZWDETAIL'):SetDescription(OemToAnsi(STR013)) // "Detalles del Almacen"	
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
	Local oModel	:= FWLoadModel('ACMSE2')
	Local oView 	:= FWFormView():New()
	Local oStHeader	:= FWFormStruct( 2, 'ZZZ' )
	Local oStDetZZV	:= FWFormStruct( 2, 'ZZV' )
	Local oStDetZZW	:= FWFormStruct( 2, 'ZZW' )

	oView:SetModel( oModel ) 
	oView:AddField('VIEW_ZZZ'	,oStHeader,'ZZZMASTER')
	oView:AddGrid( 'VIEW_ZZV'	,oStDetZZV,'ZZVDETAIL')	
	oView:AddGrid( 'VIEW_ZZW'	,oStDetZZW,'ZZWDETAIL')	

	oView:CreateHorizontalBox( 'SUPERIOR', 30 )  
	oView:CreateHorizontalBox( 'INFERIOR', 70 )

	oView:CreateVerticalBox( 'INFERIORIZQ', 50, 'INFERIOR' )  
	oView:CreateVerticalBox( 'INFERIORDER', 50, 'INFERIOR' ) 


	oView:SetOwnerView( 'VIEW_ZZZ', 'SUPERIOR' )  
	oView:SetOwnerView( 'VIEW_ZZV', 'INFERIORIZQ' )
	oView:SetOwnerView( 'VIEW_ZZW', 'INFERIORDER' )

	oView:EnableTitleView('VIEW_ZZZ',OemToAnsi(STR011))
	oView:EnableTitleView('VIEW_ZZV',OemToAnsi(STR012))
	oView:EnableTitleView('VIEW_ZZW',OemToAnsi(STR013))

	oView:SetCloseOnOk({||.T.})
	oView:SetViewProperty( 'VIEW_ZZV', "SETCSS", { "QTableView { selection-background-color: #1C9DBD; }" } ) 
	oView:SetViewProperty( 'VIEW_ZZW', "SETCSS", { "QTableView { selection-background-color: #1C9DBD; }" } ) 
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
	cFiltro:="ZZZ_USRCOD>=''"
	cFiltro:=""
Return

/*/{Protheus.doc} AcmVer
description
@type function
@version 
@author Axel Diaz
@since 12/4/2020
@return return_type, return_description
/*/
Static Function AcmVer()
	Local oModel	:= FWLoadModel('ACMSE2')
	Local lRet	:= .F.
	If oModel:Activate(.T.)
			FWExecView("Ver documento",'VIEWDEF.ACMSE2',MODEL_OPERATION_VIEW,,,,,)
	Else
        Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0)   
    EndIf
Return lRet



