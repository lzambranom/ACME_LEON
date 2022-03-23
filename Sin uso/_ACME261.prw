#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'ACME261.ch'

User Function ACME261()
	Local oBrowse
	Local aArea			:= GetArea()
	Local aCampos		:= {}
	Local cZD3			:= GetNextAlias()
	Local cFiltro		:= ""
	Local aSeek			:= {}
	
	CHKFILE("ZX4")
	CHKFILE("ZY4")
	
 	Private aRotina	:= MenuDef()
 	
 	/*
 	fFilAcm1(@cFiltro)
	If EMPTY(cFiltro)
		Return
	EndIf
 	*/
 	
 	Aadd(aSeek,{"Filial+Doc+Tm"   	, {{"","C",18,0, "ZX4_FILIAL+ZX4_DOC+ZX4_TM",""}},1,.T. } )
 	Aadd(aSeek,{"Filial+Tm+Doc"   	, {{"","C",18,0, "ZX4_FILIAL+ZX4_TM+ZX4_DOC",""}},2,.T. } )

	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias('ZX4')  
	oBrowse:AddLegend( "ZX4_TM>='500'", VERDE, EstadoVERDE) 
	oBrowse:AddLegend( "ZX4_TM<='499'", ROJO , EstadoROJO) 
	oBrowse:SetDescription('Movimientos Pistoleo Acme')
	oBrowse:SetFixedBrowse(.F.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:SetUseFilter(.T.)
	oBrowse:DisableDetails()
	oBrowse:SetSeek(.T.,aSeek)
	oBrowse:SetLocate()
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetWalkThru(.F.) 
	oBrowse:Refresh(.T.)
	oBrowse:SetDoubleClick({||U_AcmVerM() })
	oBrowse:Activate()
	oBrowse:Destroy()
	RestArea(aArea)	
Return NIL 

Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.ACME261' OPERATION MODEL_OPERATION_VIEW 	ACCESS 0  
	ADD OPTION aRotina Title 'Incluir'    Action 'VIEWDEF.ACME261' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3 
	ADD OPTION aRotina Title 'Alterar'    Action 'VIEWDEF.ACME261' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4  
	ADD OPTION aRotina Title 'Excluir'    Action 'VIEWDEF.ACME261' OPERATION MODEL_OPERATION_DELETE ACCESS 0  
	ADD OPTION aRotina Title 'Imprimir'   Action 'VIEWDEF.ACME261' OPERATION 8 ACCESS 0  
	ADD OPTION aRotina Title 'Copiar'     Action 'VIEWDEF.ACME261' OPERATION 9 ACCESS 0  
Return aRotina	

Static Function ModelDef()  
	Local oStHeader 	:= FWFormStruct( 1, 'ZX4' ) 
	Local oStDetail 	:= FWFormStruct( 1, 'ZY4' ) 
	Local oModel  
	Local aZY4Rel	:= {}
	
	oModel := MPFormModel():New('ACME261M' )  
	oModel:AddFields( 'ZX4MASTER', /*cOwner*/  , oStHeader)
	oModel:AddGrid  ( 'ZY4DETAIL', 'ZX4MASTER' , oStDetail)
	 
	oModel:SetDescription( 'Modelo de dados de Entrada/Salida' )  
	oModel:GetModel( 'ZX4MASTER' ):SetDescription( 'Dados de Entrada/Salida' ) 
	
	// Hacer la relación entre padre e hijo
	aAdd(aZY4Rel, {'ZY4_FILIAL'	, 'xFilial( "ZY4" )'})
	aAdd(aZY4Rel, {'ZY4_DOC'	, 'ZX4_DOC'			})
	aAdd(aZY4Rel, {'ZY4_TM' 	, 'ZX4_TM'			})

	oModel:SetRelation('ZY4DETAIL', aZY4Rel, ZY4->(IndexKey(1))) // IndexKey -> Quiero ordenar y luego filtrar
	oModel:GetModel('ZY4DETAIL'):SetUniqueLine({"ZY4_COD"})	// No repita información o combinaciones {"CAMPO1", "CAMPO2", "CAMPOX"}
	oModel:SetPrimaryKey({})

	// Establecer las descripciones
	oModel:SetDescription("Movimientos multiples Acme Leon")
	oModel:GetModel('ZX4MASTER'):SetDescription('Encabezado Movimiento')
	oModel:GetModel('ZY4DETAIL'):SetDescription('Detalles del Movimiento')
Return oModel

Static Function ViewDef()  
	Local oModel	:= FWLoadModel('ACME261')
	Local oView 	:= FWFormView():New()
	Local oStHeader	:= FWFormStruct( 2, 'ZX4' )
	Local oStDetail	:= FWFormStruct( 2, 'ZY4' )

	oView:SetModel( oModel ) 
	oView:AddField('VIEW_ZX4'	,oStHeader,'ZX4MASTER')
	oView:AddGrid( 'VIEW_ZY4'	,oStDetail,'ZY4DETAIL')	
	
	oView:CreateHorizontalBox( 'SUPERIOR', 15 )  
	oView:CreateHorizontalBox( 'INFERIOR', 85 )
	oView:SetOwnerView( 'VIEW_ZX4', 'SUPERIOR' )  
	oView:SetOwnerView( 'VIEW_ZY4', 'INFERIOR' )
	oView:SetCloseOnOk({||.T.})
	oView:AddIncrementField('VIEW_ZY4' , 'ZY4_ITEM' )
Return oView

Static Function fFilAcm1(cFiltro)
Return


user function ACEX261()
Local _aCab1 := {}
Local _aItem := {}
Local _atotitem:={}
Local cCodigoTM:="503"
Local cCodProd:="PRODUTO "
Local cUnid:="PC "

Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao

//Private _acod:={"1","MP1"}
//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST"

_aCab1 := {{"D3_DOC" ,NextNumero("SD3",2,"D3_DOC",.T.), NIL},;
           {"D3_TM" ,cCodigoTM , NIL},;
           {"D3_CC" ,"        ", NIL},;
           {"D3_EMISSAO" ,ddatabase, NIL}}


_aItem:={{"D3_COD" ,cCodProd ,NIL},;
  {"D3_UM" ,cUnid ,NIL},; 
  {"D3_QUANT" ,1 ,NIL},;
  {"D3_LOCAL" ,"01" ,NIL},;
  {"D3_LOTECTL" ,"",NIL},;
  {"D3_LOCALIZ" , "ENDEREÇO            ",NIL}}

aadd(_atotitem,_aitem) 
MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

If lMsErroAuto 
	Mostraerro() 
	DisarmTransaction() 
	break
EndIf

Return 