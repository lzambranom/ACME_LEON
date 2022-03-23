#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'AcmeDef.ch'

/* -------------------------------------------------------------------
Function ACMNF001
Autor Axel Diaz
Proposito: Esta funcion permite relacionar a las fact de salida y pistoleo de chequeo 
autorizadas para la salida
------------------------------------------------------------------------*/
User Function ACMNF001()
	Local aArea			:= GetArea()
	Local oBrowse
	Local cFiltro		:= ""
	Private cCadastro 	:= cTituloNF
	Private aRotina		:= MenuDef()

	Processa( {|| ZSincr() }, "Buscando Factura", "Sincronizando facturas nuevas, espere...", .f.)
	
  		
	cFiltro		:=fFilAcm1()
	If EMPTY(cFiltro)
		Return
	EndIf  
 
	oBrowse:= FWMBrowse():New()
	oBrowse:SetDataTable(.T.)
	oBrowse:SetAlias("ZF2")
	oBrowse:SetDescription(cCadastro)
	oBrowse:AddLegend( "ZF2_XAUDIT <> ' '",VERDE		, "Legalizada")
	oBrowse:AddLegend( "ZF2_XAUDIT == ' '",ROJO			, "No Legalizada")
	

//	oBrowse:SetAmbiente(.T.)  
//	oBrowse:SetWalkThru(.F.)  
//	oBrowse:SetFixedBrowse(.T.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:DisableDetails()
//	cFiltro:=""
	oBrowse:SetFilterDefault(cFiltro)
	oBrowse:DisableDetails()	

	oBrowse:Refresh(.T.)
	oBrowse:Activate()
	oBrowse:Destroy()
	RestArea(aArea)
Return


/*
Rutina: 	MenuDef()
función:	define el Menu del Objheto Obrowser
*/
Static Function MenuDef()
	Local aRotine 		:= {}

	ADD OPTION aRotine  TITLE 'Legalizar' 						ACTION 'u_ACMNFLEGA'		OPERATION MODEL_OPERATION_UPDATE 	ACCESS 0 //OPERATION 4
	ADD OPTION aRotine  TITLE 'Visualizar de Documento' 		ACTION 'VIEWDEF.ACMNF001'	OPERATION MODEL_OPERATION_VIEW 		ACCESS 0 //OPERATION 1
	ADD OPTION aRotine  TITLE 'Leyenda' 						ACTION 'U_LeyeBrw2' 		OPERATION 9 						ACCESS 0 //OPERATION 9
	ADD OPTION aRotine  TITLE 'Imprimir Despacho Legalizado'	ACTION 'VIEWDEF.ACMNF001' 	OPERATION 9 						ACCESS 0 //OPERATION 9
	
Return aRotine

/*
Funcion ModelDef del MVC
*/
Static Function ModelDef()
	Local aZD2Rel		:= {}
	Local aTriggeDT		:= {}
	Local oStHeader 	:= GMSHead() 				// FWFormStruct( 1, 'ZF2' )  
	Local oStDetail 	:= GMSDetail()				// FWFormStruct( 1, 'ZD2' )  
	Local nAtual		:= 0 
	Local oModel // Modelo de datos construído 
	 
	oModel := MPFormModel():New( 'ACMNF01M' , /*<bPre >*/{ | oModel | PreCommit( oModel ) },/*<bPost >*/{ | oModel | PosCommit( oModel ) },/*<bCommit > *//*Commit(oMdl)*/ , /*<bCancel >*/ )  

	
	aAdd(aTriggeDT, CreaTrigger("ZD2_CANTSL" ,"ZD2_TPMOV"	,"U_SemaGrid(M->ZD2_UM,M->ZD2_UM,M->ZD2_QUANT,M->ZD2_CANTSL) "	,.F.,''	,0	,''	,''	,'001'))	
	aAdd(aTriggeDT, CreaTrigger("ZD2_CANTSL" ,"LEYENDA"		,"U_LeySemaNF(M->ZD2_UM,M->ZD2_UM,M->ZD2_QUANT,M->ZD2_CANTSL)"	,.F.,''	,0	,''	,'' ,'002'))
	aAdd(aTriggeDT, CreaTrigger("ZD2_CANTSL" ,"DIFERENC"	,"ABS((M->ZD2_QUANT)-(M->ZD2_CANTSL))"							,.F.,''	,0	,''	,'' ,'003'))

    For nAtual := 1 To Len(aTriggeDT)
        oStDetail:AddTrigger(   aTriggeDT[nAtual][01],; //Campo Origen
                            	aTriggeDT[nAtual][02],; //Campo Destino
                            	aTriggeDT[nAtual][03],; //Bloque de código de validacion que ejecutara el gatillo
                            	aTriggeDT[nAtual][04])  //Bloque de código de execucion 
    Next

	oModel:AddFields('ZF2MASTER',/*cOwner*/, oStHeader )  
	oModel:AddGrid('ZD2DETAIL','ZF2MASTER', oStDetail )  

	aAdd(aZD2Rel, {'ZD2_FILIAL'	, 'xFilial( "ZD2" )'	})
	aAdd(aZD2Rel, {'ZD2_DOC'	, 'ZF2_DOC'				})
	aAdd(aZD2Rel, {'ZD2_SERIE' 	, 'ZF2_SERIE'			}) 
	aAdd(aZD2Rel, {'ZD2_CLIENT'	, 'ZF2_CLIENT'			})
	aAdd(aZD2Rel, {'ZD2_LOJA' 	, 'ZF2_LOJA'			}) 
    	
	oModel:SetRelation('ZD2DETAIL', aZD2Rel, ZD2->(IndexKey(1))) 
	oModel:SetPrimaryKey({})
	oModel:SetDescription("Legalización Factura/Remisión Acme Leon")
	oModel:GetModel('ZF2MASTER'):SetDescription('Factura/Remisión de Salida')
	oModel:GetModel('ZD2DETAIL'):SetDescription('Detalles del Documento')
Return oModel

	 
Static Function ViewDef()  
	Local oModel := FWLoadModel( 'ACMNF001' )  
	Local oStHeader := GVSHead()  
	Local oStDetail	:= GVSDetail() 
	Local oView  
	oView := FWFormView():New()  
	oView:SetModel( oModel )  
	oView:AddField( 'VIEW_ZF2', oStHeader, 'ZF2MASTER' )
	oView:AddGrid(  'VIEW_ZD2', oStDetail, 'ZD2DETAIL' )
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',40)
	oView:CreateHorizontalBox('GRID',60)

	oView:CreateVerticalBox( 'GRIDIZQ', 90, 'GRID' )  
	oView:CreateVerticalBox( 'GRIDDER', 10, 'GRID' ) 

	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZF2','CABEC')
	oView:SetOwnerView('VIEW_ZD2','GRIDIZQ')

	//Habilitando título
	oView:EnableTitleView('VIEW_ZF2','Factura/Remisión de Salida')
	oView:EnableTitleView('VIEW_ZD2','Detalles del Documento')

	oView:AddOtherObject("PANEL", {|oPanel| BTNPANELDER(oPanel)}) 
	oView:SetOwnerView("PANEL",'GRIDDER')
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})

	oView:SetNoDeleteLine('VIEW_ZD2')
	oView:SetProgressBar(.T.)
Return oView
/*
+---------------------------------------------------------------------------+
| Programa  #  GMSHead   |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #  Función para crear FWFormModelStruct del modelo              |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
Static Function GMSHead()
	Local oStruct	:= FWFormModelStruct():New()
	Local aCampo	:= {}
	
	oStruct:AddTable('ZF2',{'ZF2_SERIE','ZX2_DOC','ZF2_DTDIGI', 'ZF2_CLIENT','ZF2_LOJA','ZF2_XAUDIT',;
	 						'ZF2_EMISSA', 'ZF2_NOME', 'ZX2_LEGALI', 'ZX2_TIME','ZX2_RESPON'},"Encabezado")

	aCampo:=u_SX3Datos('ZF2_SERIE');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_DOC');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_CLIENT');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_LOJA');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_EMISSA');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_DTDIGI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_NOME');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_LEGALI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_TIME');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_RESPON');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZF2_XAUDIT');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )

	oStruct:SetProperty('ZF2_SERIE'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZF2_DOC'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZF2_CLIENT'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZF2_LOJA'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZF2_NOME'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZF2_EMISSA'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZF2_DTDIGI'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZF2_LEGALI'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZF2_TIME'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZF2_RESPON'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZF2_XAUDIT'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))	
Return oStruct
/*
+---------------------------------------------------------------------------+
| Programa  #  GVSDetail   |Autor  | Axel Diaz      |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #  Función para crear FWFormModelStruct del modelo              |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
Static Function GVSDetail()
	Local oStruct 	:= FWFormViewStruct():New()
	Local aCampo	:= {}

	aCampo:=u_SX3Datos('ZD2_ITEM');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '02',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZD2_COD');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '03',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZD2_DESCRI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '04',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZD2_UM');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '05',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZD2_SEGUM');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '06',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZD2_QUANT');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '07',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZD2_LOCAL');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '08',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZD2_CANTSL');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '09',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)

										oStruct:AddField(/*cIdField*/ 'LEYENDA',/*cOrdem*/ '01', /*cTitulo*/ '#'		, /*cDescric*/ 'Leyenda'								,/*aHelp*/,/*cType*/ 'Get',/*cPicture*/ '@BMP',,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )
										oStruct:AddField(/*cIdField*/'DIFERENC',/*cOrdem*/ '10',/*cTitulo*/'Diferencia' , /*cDescric*/ 'Diferencia entre Factura y Legalización',/*aHelp*/,/*cType*/ 'N'  ,/*cPicture*/"@9999",,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )
	
	oStruct:SetProperty('ZD2_ITEM', 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZD2_COD', 		MVC_VIEW_CANCHANGE,.F.)	
	oStruct:SetProperty('ZD2_DESCRI', 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZD2_UM', 		MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZD2_SEGUM'	, 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZD2_QUANT', 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZD2_LOCAL', 	MVC_VIEW_CANCHANGE,.F.)
return oStruct
/*
+---------------------------------------------------------------------------+
| Programa  #  GVSHead   |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #  Función para crear FWFormModelStruct del modelo              |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
Static Function GVSHead()
	Local oStruct 	:= FWFormViewStruct():New()
	Local aCampo	:= {}
	
	aCampo:=u_SX3Datos('ZF2_SERIE');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '01',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZF2_DOC');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '02',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZF2_CLIENT');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '03',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZF2_LOJA');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '04',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZF2_NOME');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '05',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZF2_EMISSA');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '06',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZF2_DTDIGI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '07',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('ZF2_LEGALI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '08',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('ZF2_RESPON');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '09',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('ZF2_TIME');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '10',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)

//	oStruct:SetProperty('ZF2_LEGALI', 	MVC_VIEW_CANCHANGE,.F.)
//	oStruct:SetProperty('ZF2_TIME'	, 	MVC_VIEW_CANCHANGE,.F.)
//	oStruct:SetProperty('ZF2_RESPON', 	MVC_VIEW_CANCHANGE,.F.)

return oStruct

/*
+---------------------------------------------------------------------------+
| Programa  #  GMSDetail   |Autor  | Axel Diaz        |Fecha |  10/12/2019  |
+---------------------------------------------------------------------------+
| Desc.     #  Función para crear FWFormModelStruct del modelo dETALLE      |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
Static Function GMSDetail()
	Local oStruct	:= FWFormModelStruct():New()
	Local aCampo	:= {}

	oStruct:AddTable('ZD2',{'ZD2_ITEM','ZD2_COD','ZD2_SEGUM','ZD2_UM','ZD2_QUANT','ZD2_CLIENT','ZD2_LOJA','ZD2_DOC','ZD2_SERIE',;
							'ZD2_NUMSEQ','ZD2_DESCRI','ZD2_LOCAL','ZD2_TPMOV','ZD2_CANTSL', 'LEYENDA', 'DIFERENC'},"Detalles")		

	//      									AddField(<cTitulo >	,<cTooltip >,<cIdField >,<cTipo >	, <nTamanho >	, [ nDecimal ]	, [ bValid ], [ bWhen ]	, [ aValues ]	, [ lObrigat ]	, [ bInit ]	, <lKey >	, [ lNoUpd ], [ lVirtual ]	, [ cValid ])
	aCampo:=u_SX3Datos('ZD2_ITEM')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_COD')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_SEGUM')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_UM')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_QUANT')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_CLIENT');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_LOJA')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_DOC')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_SERIE')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_NUMSEQ');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_LOCAL');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_TPMOV');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_CANTSL');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZD2_DESCRI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )

										oStruct:AddField('Leyenda'	,'Leyenda'	,'LEYENDA' 	, 'C'		,20				, 0			,,,{}, .F.		, FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVCNF1InitPad()")	, .F., .F., .T., , ) 
										oStruct:AddField('Diferenc'	,'Diferenc'	,'DIFERENC'	, 'N'		,4				, 0			,,,{}, .F.		, FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVCNF1Dif()")		, .F., .F., .T., , ) 

	oStruct:SetProperty('ZD2_ITEM'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_COD'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_SEGUM'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_UM'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_QUANT'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_CLIENT'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_LOJA'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_DOC'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_SERIE'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_NUMSEQ'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_LOCAL'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZD2_TPMOV'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZD2_CANTSL'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZD2_DESCRI'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))

return oStruct
/*
Funcion de Botones en el Grid

*/
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
 
	oTButton1 := TButton():New( 010, 005, " "  		,oPanel,{||U_CodBarrNF(oModel,oView)}	, 55,20,,,.F.,.T.,.F.,,.F.,{||.T.}	,,.F. )   
	oTButton2 := TButton():New( 040, 005, cPNGLEGAL	,oPanel,{||U_LeyeNFGrd()}				, 55,20,,,.F.,.T.,.F.,,.F.,{||.T.}																						,,.F. )   
	
	oTButton1:SetCss(cCSSCBar)

Return NIL  


/*
Rutina fFilAcm1
Función: Función que muestra grupo de preguntas al ingresar           |
*/
Static Function fFilAcm1()
Local cPerg		:= "ACMNFPG1"
Local cFiltro	:=""
AcmSX1(cPerg)			// Inicializa SX1 para preguntas
If Pergunte(cPerg)
 	cFiltro := " ZF2->ZF2_EMISSA >='"	+ DTOC(MV_PAR02) +		"' .AND. "
 	cFiltro += " ZF2->ZF2_EMISSA <='"	+ DTOC(MV_PAR03) +		"' .AND. "
 	cFiltro += " ZF2->ZF2_SERIE >='"	+ MV_PAR04 +			"' .AND. "
 	cFiltro += " ZF2->ZF2_SERIE <='"	+ MV_PAR05 +			"' .AND. "
 	cFiltro += " ZF2->ZF2_DOC >='"		+ MV_PAR06 +			"' .AND. "
 	cFiltro += " ZF2->ZF2_DOC <='"		+ MV_PAR07 +			"' .AND. "
 	cFiltro += " ZF2->ZF2_CLIENT >='"	+ MV_PAR08 +			"' .AND. "
 	cFiltro += " ZF2->ZF2_CLIENT <='"	+ MV_PAR09 +			"' .AND. "
 	cFiltro += " ZF2->ZF2_LOJA >='"		+ MV_PAR10 +			"' .AND. "
 	cFiltro += " ZF2->ZF2_LOJA <='"		+ MV_PAR11 +			"' "
 	If MV_PAR01==1
		cFiltro += " .AND. ZF2->ZF2_XAUDIT <>' ' "
	ElseIf MV_PAR01==2
		cFiltro += " .AND. ZF2->ZF2_XAUDIT ==' ' "
	EndIf
EndIf

Return cFiltro
/*
Rutina: AcmSX1
Funcion: Crear el grupo de preguntas en la SX1 cuando no existe
*/
Static Function AcmSX1(cPregunta)
	Local aRegs := {}
	Local cPerg := PADR(cPregunta,10)
	Local nI 	:= 0
	Local nJ	:= 0
	Local nLarDoc:= 0
	Local nLarSer:= 0
	Local nLarLoj:= 0
	Local nLarClt:= 0
	// Local aHelpSpa:= {}
	DBSelectArea("SX3")
	DBSetOrder(2)
	dbSeek("ZF2_DOC")
	nLarDoc:=SX3->X3_TAMANHO
 	dbSeek("ZF2_SERIE")
	nLarSer:=SX3->X3_TAMANHO
 	dbSeek("ZF2_LOJA")
	nLarLoj:=SX3->X3_TAMANHO
 	dbSeek("ZF2_CLIENTE")
	nLarClt:=SX3->X3_TAMANHO	
	dbCloseArea("SX3")
	aAdd(aRegs,{cPerg,"01",NFLEGAL		,NFLEGAL	,NFLEGAL		,"MV_CH01"	,"N"	, 01 		,0,2	,"C"	,"" 															,"MV_PAR01","Si" ,"Si" 	,"Si" 	,"Ambos"				,"","No" ,"No" ,"No" ,"","","Ambos","Ambos","Ambos","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02",NFDFECHA		,NFDFECHA	,NFDFECHA		,"MV_CH02"	,"D"	, 08 		,0,2	,"G"	,"" 															,"MV_PAR02","" 	 ,"" 	,"" 	,"'01/01/20'"			,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03",NFAFECHA		,NFAFECHA	,NFAFECHA		,"MV_CH03"	,"D"	, 08 		,0,2	,"G"	,"!Empty(MV_PAR03) .And. MV_PAR02<=MV_PAR03" 					,"MV_PAR03","" 	 ,"" 	,"" 	,"'31/12/20'"			,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04",NFDSERIE		,NFDSERIE	,NFDSERIE		,"MV_CH04"	,"C"	, nLarSer	,0,2	,"G"	,"" 															,"MV_PAR04",""   ,"" 	,"" 	,"" 		 			,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05",NFASERIE		,NFASERIE	,NFASERIE		,"MV_CH05"	,"C"	, nLarSer	,0,2	,"G"	,"!Empty(MV_PAR05) .And. MV_PAR04<=MV_PAR05" 					,"MV_PAR05",""   ,"" 	,"" 	,REPLICATE("Z",nLarSer) ,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06",NFDDOC		,NFDDOC		,NFDDOC			,"MV_CH06"	,"C"	, nLarDoc	,0,2	,"G"	,"" 															,"MV_PAR06",""   ,""	,"" 	,"" 					,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07",NFADOC		,NFADOC		,NFADOC			,"MV_CH07"	,"C"	, nLarDoc	,0,2	,"G"	,"!Empty(MV_PAR07) .And. MV_PAR06<=MV_PAR07" 					,"MV_PAR07",""   ,""	,"" 	,REPLICATE("Z",nLarDoc)	,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08",NFDCLT		,NFDCLT		,NFDCLT			,"MV_CH08"	,"C"	, nLarClt	,0,2	,"G"	,"" 															,"MV_PAR08",""   ,""	,"" 	,""						,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"09",NFACLT		,NFACLT		,NFACLT			,"MV_CH09"	,"C"	, nLarClt	,0,2	,"G"	,"!Empty(MV_PAR09) .And. MV_PAR08<=MV_PAR09" 					,"MV_PAR09",""   ,""	,""		,REPLICATE("Z",nLarClt) ,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"10",NFDLOJA		,NFDLOJA	,NFDLOJA		,"MV_CH10"	,"C"	, nLarLoj	,0,2	,"G"	,"" 															,"MV_PAR10",""   ,""	,"" 	,""						,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"11",NFALOJA		,NFALOJA	,NFALOJA		,"MV_CH11"	,"C"	, nLarLoj	,0,2	,"G"	,"!Empty(MV_PAR11) .And. MV_PAR10<=MV_PAR11" 					,"MV_PAR11",""   ,""	,"" 	,REPLICATE("Z",nLarLoj) ,"","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"12",DIRDESTINO	,DIRDESTINO	,DIRDESTINO		,"MV_CH12"	,"C"	, 99		,0,2	,"G"	,"!Vazio().or.(MV_PAR12:=cGetFile('PDFs |*.*','',,,,176,.F.))" 	,"MV_PAR12",""   ,""	,"" 	,"C:\SPOOL\"			,"","","","","","","","","","","","","","","","","","","","","",""})


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
Function Sincroniza Tabla ZF2, ZD2
*/
Static Function ZSincr()
	Local cAliasSF2 	:= GetNextAlias()
	Local cAliasSD2 	:= GetNextAlias()	
	Local cQuery 		:= ""
		
	chkfile("ZD2")
	chkfile("ZF2")

	cQuery  := " SELECT F2_FILIAL='"+xFilial("ZF2")+"',F2_XAUDIT, F2_EMISSAO, F2_SERIE, F2_DOC, F2_CLIENTE, A1_NOME, F2_LOJA, F2_DTDIGIT, "	+ CRLF
	cQuery	+= " SF2.D_E_L_E_T_ AS F2BORRAR " 																								+ CRLF
	cQuery	+= " FROM "+ InitSqlName("SF2") +" SF2 " 																						+ CRLF
	cQuery	+= " INNER JOIN "+ InitSqlName("SA1") +" SA1 ON " 																				+ CRLF
	cQuery	+= " SA1.D_E_L_E_T_=' ' AND A1_FILIAL='"+xFilial("SA1")+"' AND " 																+ CRLF 
	cQuery	+= " A1_COD=F2_CLIENTE "																										+ CRLF	
	cQuery	+= " LEFT JOIN "+ InitSqlName("ZF2") +" ZF2 ON " 																				+ CRLF
	cQuery	+= " ZF2.D_E_L_E_T_<>'*' AND ZF2_FILIAL='"+xFilial("ZF2")+"'  " 																+ CRLF 
	cQuery	+= " AND ZF2_SERIE<>F2_SERIE AND ZF2_DOC<>F2_DOC AND ZF2_CLIENT<>F2_CLIENTE AND ZF2_LOJA<>F2_LOJA "								+ CRLF
	cQuery	+= " WHERE (F2_ESPECIE='RFN ' OR F2_ESPECIE='RTF ' OR F2_ESPECIE='NF  ' ) "														+ CRLF	
//	cQuery	+= " AND SF2.D_E_L_E_T_=' ' "																									+ CRLF	
	cQuery	+= " AND F2_FILIAL='"+xFilial("SF2")+"' "																						+ CRLF
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF2,.T.,.T.)

	procregua((cAliasSF2)->(RECCOUNT()))

	If (cAliasSF2)->( !Eof() )
		While (cAliasSF2)->( !Eof() )
			If EMPTY(POSICIONE("ZF2",1,xFilial("ZF2")+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA,"ZF2_CLIENT")) .AND. EMPTY(ALLTRIM((cAliasSF2)->F2BORRAR))
				RecLock("ZF2",.T.)
				ZF2->ZF2_FILIAL		:= (cAliasSF2)->F2_FILIAL
				ZF2->ZF2_EMISSA		:= Stod((cAliasSF2)->F2_EMISSAO)
				ZF2->ZF2_DTDIGI		:= Stod((cAliasSF2)->F2_DTDIGIT)
				ZF2->ZF2_SERIE 		:= (cAliasSF2)->F2_SERIE
				ZF2->ZF2_DOC 		:= (cAliasSF2)->F2_DOC
				ZF2->ZF2_CLIENT		:= (cAliasSF2)->F2_CLIENTE 
				ZF2->ZF2_NOME		:= (cAliasSF2)->A1_NOME 
				ZF2->ZF2_LOJA		:= (cAliasSF2)->F2_LOJA			
				ZF2->( MsUnLock() )
			ElseIf !EMPTY(POSICIONE("ZF2",1,xFilial("ZF2")+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA,"ZF2_CLIENT")) .AND. !EMPTY(ALLTRIM((cAliasSF2)->F2BORRAR))
				RecLock('ZF2', .F.)
				DbDelete()
				SB1->(MsUnlock())
			EndIf
			(cAliasSF2)->(dbSkip())
			incproc("Agregando")
		End
	EndIf
	
	dbCloseArea(cAliasSF2)

	cQuery  := " SELECT D2_FILIAL='"+xFilial("ZD2")+"',D2_ITEM,D2_COD,D2_SEGUM,D2_UM,D2_QUANT,D2_CLIENTE,D2_LOJA,D2_DOC,D2_SERIE, "			+ CRLF
	cQuery  += " D2_NUMSEQ,B1_DESC, D2_LOCAL, SD2.D_E_L_E_T_ AS D2BORRAR"																	+ CRLF
	cQuery  += " FROM "+ InitSqlName("SD2") +" SD2 "  																						+ CRLF			
	cQuery 	+= " INNER JOIN "+ InitSqlName("SB1") +" SB1 ON " 																				+ CRLF	
	cQuery	+= " SB1.D_E_L_E_T_<>'*' AND B1_FILIAL='"+xFilial("SB1")+"' AND " 																+ CRLF 
	cQuery	+= " B1_COD=D2_COD " 																											+ CRLF
	cQuery	+= " INNER JOIN "+ InitSqlName("ZF2") +" ZF2 ON " 																				+ CRLF
	cQuery	+= " ZF2.D_E_L_E_T_<>'*' AND ZF2_FILIAL='"+xFilial("ZF2")+"'  " 																+ CRLF
	cQuery	+= " AND ZF2_SERIE=D2_SERIE AND ZF2_DOC=D2_DOC AND ZF2_CLIENT=D2_CLIENTE AND ZF2_LOJA=D2_LOJA "									+ CRLF 
	cQuery	+= " LEFT JOIN "+ InitSqlName("ZD2") +" ZD2 ON " 																				+ CRLF	
	cQuery	+= " ZD2.D_E_L_E_T_<>'*' AND ZD2_FILIAL='"+xFilial("ZD2")+"' " 																	+ CRLF
	cQuery	+= " AND ZD2_SERIE<>D2_SERIE AND ZD2_DOC<>D2_DOC AND ZD2_CLIENT<>D2_CLIENTE AND ZD2_LOJA<>D2_LOJA "								+ CRLF
	cQuery	+= " WHERE D2_FILIAL='"+xFilial("SD2")+"' " 																					+ CRLF
//	cQuery	+= " AND SD2.D_E_L_E_T_=' ' " 																									+ CRLF	
 	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)

 	procregua((cAliasSD2)->(RECCOUNT()))
 	
	If (cAliasSD2)->( !Eof() )
		While (cAliasSD2)->( !Eof() )
			If EMPTY(POSICIONE("ZD2",1,xFilial("ZD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA,"ZD2_CLIENT")) .AND. EMPTY(ALLTRIM((cAliasSD2)->D2BORRAR))
				RecLock("ZD2",.T.)
				ZD2->ZD2_FILIAL	:= (cAliasSD2)->D2_FILIAL
				ZD2->ZD2_ITEM	:= (cAliasSD2)->D2_ITEM
				ZD2->ZD2_COD	:= (cAliasSD2)->D2_COD
				ZD2->ZD2_SEGUM	:= (cAliasSD2)->D2_SEGUM
				ZD2->ZD2_UM		:= (cAliasSD2)->D2_UM
				ZD2->ZD2_QUANT	:= (cAliasSD2)->D2_QUANT
				ZD2->ZD2_CLIENT	:= (cAliasSD2)->D2_CLIENTE
				ZD2->ZD2_LOJA	:= (cAliasSD2)->D2_LOJA
				ZD2->ZD2_DOC	:= (cAliasSD2)->D2_DOC
				ZD2->ZD2_SERIE	:= (cAliasSD2)->D2_SERIE
				ZD2->ZD2_NUMSEQ	:= (cAliasSD2)->D2_NUMSEQ
				ZD2->ZD2_DESCRI	:= (cAliasSD2)->B1_DESC 
				ZD2->ZD2_LOCAL	:= (cAliasSD2)->D2_LOCAL
				ZD2->ZD2_TPMOV	:= "1"
				ZD2->( MsUnLock() )
			ElseiF !EMPTY(POSICIONE("ZD2",1,xFilial("ZD2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA,"ZD2_CLIENT")) .AND. !EMPTY(ALLTRIM((cAliasSD2)->D2BORRAR))
				RecLock('ZD2', .F.)
				DbDelete()
				SB1->(MsUnlock())
			EndIf
			(cAliasSD2)->(dbSkip())
			incproc("Cotejando...")
		End
	EndIf
	dbCloseArea(cAliasSD2) 
Return
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
User Function CodBarrNF(oMdl,oVw)
	Local cTexto
	Local oDlg
	Local oMemo
	Local Retorno
	
	DEFINE MSDIALOG oDlg TITLE "Lectura de Codigos de Barra" FROM 0,0 TO 555,650 PIXEL
	     @ 005, 005 GET oMemo VAR cTexto MEMO SIZE 315, 250 OF oDlg PIXEL
	     @ 260, 280 Button "PROCESAR" Size 035, 015 PIXEL OF oDlg Action(processa( {|| u_CodProNF(oDlg,cTexto,oMdl,oVw) }, "Procesando los Códigos", "Leyendo los registros y sumando, espere...", .f.))
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
User Function CodProNF(oDlg,cTexto,oMdl,oView)
	Local aLineas	:= {}
	Local aLinTmp	:= {}
	Local aProduc	:= {}
	Local aCodBar	:= {}
	Local nI,nJ,nX := 0
	Local oModelZD2, oModelZF2
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
		    oModelZF2:= oMdl:GetModel("ZF2MASTER")
		    oModelZD2:= oMdl:GetModel("ZD2DETAIL")
	     	lInsert:=.T.
	     	lPaso:= .F.
	     	For nI:=1 to len(aProduc)
	     		incproc("Cotejando...")
	     		If aProduc[nI][2]>0
		     		For nJ:=1 to (oModelZD2:Length()) 
		     			oModelZD2:GoLine( nJ )
		     			If ALLTRIM(oModelZD2:GetValue("ZD2_COD"))==ALLTRIM(aProduc[nI][1])
		     				lInsert:=.F.
		     				nX:=nJ
		     			EndIf
		     		Next
		     		If lInsert
			     		lPaso:=.T.
			     		lIncAcme:= .T.
		     			oModelZD2:AddLine()
		     			oModelZD2:SetValue("ZD2_COD"	, 	ALLTRIM(aProduc[nI][1]) )
		     			oModelZD2:SetValue("ZD2_QUANT"	, 	aProduc[nI][2]*(-1)) // Si se agrega Linea, llegaron productos que no pertenecen al Doc de salida
		     			oModelZD2:SetValue("ZD2_CANTSL"	, 	aProduc[nI][2]+ oModelZD2:GetValue("ZD2_CANTSL") )
		     			oModelZD2:SetValue("LEYENDA"	, 	ROJO )
		     			oModelZD2:SetValue("ZD2_DESCRI"	,	POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduc[nI][1]),'B1_DESC'))
		     			oModelZD2:SetValue("ZD2_SEGUM"	,	POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduc[nI][1]),'B1_SEGUM'))
		     			oModelZD2:SetValue("ZD2_UM"		,	POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduc[nI][1]),'B1_UM'))
		     			oModelZD2:SetValue("DIFERENC"	,	aProduc[nI][2]*(-1))
			     		lIncAcme:= .F.
		     		Else
		     			oModelZD2:GoLine( nX )
		     			oModelZD2:UnDeleteLine()
		     			oModelZD2:SetValue("ZD2_CANTSL"	, 	aProduc[nI][2]+ oModelZD2:GetValue("ZD2_CANTSL") )
		     			oModelZD2:SetValue("DIFERENC"	,	ABS(oModelZD2:GetValue("ZD2_QUANT")-aProduc[nI][2]))
		     			//#DEFINE TP_MOV_GRIS		"1"	 // Nueva Salida de Material
		     			//#DEFINE TP_MOV_VERDE		"2"	 // Salida y entrada de materia Cohinciden
		     			//#DEFINE TP_MOV_AMARILLO	"3"	 // La cantidad de Salida de Materia es Superior a la entrada
		     			//#DEFINE TP_MOV_ROJO		"4"  // La cantidad de Materia de Entrada es superrio a la de Salida
		     			oModelZD2:SetValue("ZD2_TPMOV"	, IIF(oModelZD2:GetValue("ZD2_QUANT")==oModelZD2:GetValue("ZD2_CANTSL"),TP_MOV_VERDE,;
		     													IIF(oModelZD2:GetValue("ZD2_QUANT")>oModelZD2:GetValue("ZD2_CANTSL"),TP_MOV_AMARILLO,;
		     													TP_MOV_ROJO))	)
		     			oModelZD2:SetValue("LEYENDA"	,;
		     					u_getImg(u_SemaGrid(oModelZD2:GetValue("ZD2_UM"),;
		     										oModelZD2:GetValue("ZD2_UM"),;
		     										oModelZD2:GetValue("ZD2_QUANT"),;
		     										oModelZD2:GetValue("ZD2_CANTSL");
		     									);
		     								);
		     							)
			     	End
			     	lInsert:=.T.
		     	EndIf
	     	Next
	     	oModelZD2:GoLine( 1 )		

		    
		     Retorno := oDlg:End()
		     oModelZD2:GoLine( 1 )
			 oModelZD2:SetLine( 1 )
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
+----------------------------------------------------------------------------+
| Programa  # LeyenAcm     |Autor  | Axel Diaz        |Fecha |  10/12/2019   |
+----------------------------------------------------------------------------+
| Uso       # Muestra la leyenda en el grip                                  |
+----------------------------------------------------------------------------+
*/
User Function LeyeNFGrd()
     Local aLeyenda := {}
     aAdd( aLeyenda, { VERDE	,  	"Las cantidades coinciden" })
     aAdd( aLeyenda, { ROJO		,	"Las cantidades son superiores a la Factura" })
     aAdd( aLeyenda, { GRIS		,	"Sin Pistoleo" })
     aAdd( aLeyenda, { AMARILLO	,	"Las cantidades son inferiores a la Factura" })

     BrwLegenda( "Leyenda", "Leyenda de las lineas", aLeyenda )
Return Nil

/*
+---------------------------------------------------------------------------+
| Programa  #  MVC011InitPad   |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función derivada FWFormModelStruct del modelo para Colores   |
|           #  de la leyenda                                                |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function MVCNF1InitPad()
	Local cImg := GRIS
    cImg := u_getImg(ZD2->ZD2_TPMOV)
Return cImg
/*
+---------------------------------------------------------------------------+
| Programa  #  MVC011Dif       |Autor  | Axel Diaz      |Fecha |  10/12/2020|
+---------------------------------------------------------------------------+
| Desc.     #  Función derivada FWFormModelStruct del modelo para diferencia|
|           #  de cantidades                                                |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function MVCNF1Dif()
	Local nDif := 0
    If !INCLUI .AND. TYPE("ZD2_CANTSL")!='U'
        nDif:= (ZD2_QUANT)-(ZD2_CANTSL)
    EndIf
Return nDif
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
Static Function  PosCommit( oModel ) 
	Local lRet 			:= .T.
	Local nOperation:= oModel:GetOperation()
	Local oModelZD2	:= oModel:GetModel('ZD2DETAIL')
	Local oModelZF2	:= oModel:GetModel('ZF2MASTER')

	For nJ:=1 to (oModelZD2:Length()) 
		oModelZD2:GoLine( nJ )
		If !(oModelZD2:GetValue("ZD2_TPMOV")==TP_MOV_VERDE)
			lRet:=.F.
		EndIf
	Next
	If lRet
		oModelZF2:SetValue('ZF2_LEGALI'	, dDatabase					)
		oModelZF2:SetValue('ZF2_RESPON'	, UsrRetName(RetCodUsr())	)
		oModelZF2:SetValue('ZF2_TIME'	, TIME()					)
		oModelZF2:SetValue('ZF2_XAUDIT'	, '1'						)
	Else
		Help(NIL, NIL, "No coinciden las cantidades",NIL,"Las cantidades de cada producto no coinciden con la captura por lector de código de barra", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Realize una nueva captura'}) 
	EndIf
Return lRet 

/*
+---------------------------------------------------------------------------+
| Programa  #  LeySemaFo   |Autor  | Axel Diaz      |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #  Se genera con el disparador al entrar en la rutina           |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function LeySemaNF() 
	Local oModel 	:= FWModelActive() 
	Local oView		:= FWViewActive()
	Local cImg 		:= "br_amarelo_ocean.bmp"
	Local cTpMovSF      
    If oModel:GetID() == "ACMNF01M" .And. oModel:IsActive()
        cTpMovSF := oModel:GetValue("ZD2DETAIL","ZD2_TPMOV")
        cImg := u_getImg(cTpMovSF)
        oModel:SetValue("ZD2DETAIL","LEYENDA",cImg)
        oView:Refresh()
     EndIf
Return cImg

/*
+-------------------------------------------------------------------------------------------------------------------+
| Programa  #  CreaTrigger|Autor  | Axel Diaz        |Fecha |  10/12/2019   										|
+-------------------------------------------------------------------------------------------------------------------+
| Desc.     #                                                              											|
--------------------------------------------------------------------------------------------------------------------|
|           # Nome	Tipo		Descrição											Default	Obrigatório	Referência  |
|           #-------------------------------------------------------------------------------------------------------|
|           # cDom	Caracteres	Campo Dominio													X	                |
|           # cCDom	Caracteres	Campo de Contradominio											X	                |
|           # cRegra	Caracteres	Regra de Preenchimento										X	                |
|           # lSeek	Lógico		Se posicionara ou nao antes da execucao do gatilhos		.F.		                    |
|           # cAlias	Caracteres	Alias da tabela a ser posicionada							X	                |
|           # nOrdem	Numérico	Ordem da tabela a ser posicionada					0							|
|           # cChave	Caracteres	Chave de busca da tabela a ser posicionada			''							|
|           # cCondic	Caracteres	Condicao para execucao do gatilho					''							|
|           # cSequen	Caracteres	Sequencia do gatilho 															|
|           #					(usado para identificacao no caso de erro)				''							|
+-------------------------------------------------------------------------------------------------------------------+
| Uso       # cREA ARREGO PARA LOS TRRIGER                      													|	
+-------------------------------------------------------------------------------------------------------------------+
*/
Static Function CreaTrigger(cDom,cCDom,cRegra,lSeek,ctAlias,nOrdem,cChave,cCondic,cSequen)
	Local aAux :=   FwStruTrigger(;
	      cDom ,; 								// Campo Dominio
	      cCDom ,; 								// Campo de Contradominio
	      cRegra,;								// Regra de Preenchimento
	      lSeek ,; 								// Se posicionara ou nao antes da execucao do gatilhos
	      ctAlias,; 							// Alias da tabela a ser posicionada
	      nOrdem ,; 							// Ordem da tabela a ser posicionada
	      cChave ,; 							// Chave de busca da tabela a ser posicionada
	      cCondic,; 							// Condicao para execucao do gatilho
	      cSequen ) 							// Sequencia do gatilho (usado para identificacao no caso de erro)   
Return aAux

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
Static Function PreCommit( oModel ) 
	Local lRet 			:= .T.
	Local oModelZF2	:= oModel:GetModel('ZF2MASTER')
	If ALTERA .AND.	oModel:GetValue("ZF2MASTER","ZF2_XAUDIT")=='1'
		lRet:=.F.
		Help(NIL, NIL, "Documento Legalizado",NIL,"El documento seleccionado ya se encuentra Legalizado, no puede modificarse", 1, 0, NIL, NIL, NIL, NIL, NIL,NIL) 
	EndIf
Return lRet 

/*
+---------------------------------------------------------------------------+
| Programa  #  ACMEntrada     |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función para ingresas salida                                 |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function ACMNFLEGA()
	Local oModel	:= FWLoadModel('ACMNF001')
	Local oModelZF2	:= oModel:GetModel('ZF2MASTER')
	Local lRet	:= .F.
	If oModel:Activate(.T.)
		If oModel:GetValue("ZF2MASTER","ZF2_XAUDIT")<>'1'
			FWExecView("LEGALIZAR",'VIEWDEF.ACMNF001',MODEL_OPERATION_UPDATE,,{|| .T.})
			lRet := .T.
		Else
			Help(NIL, NIL, "Documento Legalizado",NIL,"El documento seleccionado ya se encuentra Legalizado, no puede modificarse", 1, 0, NIL, NIL, NIL, NIL, NIL,NIL) 
		EndIf	
	Else
		Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0) 
	EndIf
Return lRet