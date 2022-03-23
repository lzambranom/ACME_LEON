#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'AcmeDef.ch'


// NOTA
//  SE DEBE AMPLIAR EL CAMPO FACTOR DE CONVERSION EN EL MAESTRO DE PRODUCTOS
//
/*
+===========================================================================+
| Programa  #ACM001    |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para crear columnas de SEMAFORIZACION                |
|           #                                                               |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_ACM001()                                                |
+===========================================================================+
*/
USER function ACM001()
	Local oBrowse
	Local aArea			:= GetArea()
	Local aCampos		:= {}
	Local cQry1			:= ""
	Local cZX2			:= GetNextAlias()
	Local cFiltro		:= ""
	Local aSeek			:= {}
	Private aRotina		:= MenuDef()
	Private lIncAcme	:= .F.	// Incluye o altera personalizado
	Private lLegaliza	:= .F.	// Variable que controla si estoy en la Ventana de Legalizacion
	Private lModiSal	:= .F.	// Variable que controla si estoy en la Ventada de Modificacion de Salida
	Private cSD3AcDoc	:= ""	// Variable que contiene el NUMERO DE despues de Oprimir el boton de legalizar 
	Private cPath		:= ".\"
	Private cDocModi	:= ""
	Private cSalFull	:= ""
	Private cSaldo		:= ""

	chkfile("ZX2")
	chkfile("ZX2")
	chkfile("ZZU")
	/*
	AAdd( aCampos,{ "ZX2_DOC"	,"número Salida"	,01,"@!",1,TamSX3("ZX2_DOC")[1]		,0,.T.	} )
	AAdd( aCampos,{ "ZX2_SERIE"	,"Serie Salida"		,02,"@!",1,TamSX3("ZX2_SERIE")[1]	,0,.T.	} )
	AAdd( aCampos,{ "ZX2_DOC2"	,"número Entrada"	,01,"@!",1,TamSX3("ZX2_DOC2")[1]	,0,.T.	} )
	AAdd( aCampos,{ "ZX2_SERIE2","Serie Entrada"	,02,"@!",1,TamSX3("ZX2_SERIE2")[1]	,0,.T.	} )
	AAdd( aCampos,{ "ZX2_FLEGAL","Fecha Legaliza"	,03,"@!",1,TamSX3("ZX2_FLEGAL")[1]	,0,.T.	} )
	AAdd( aCampos,{ "ZX2_DTDIGI","Fecha Digitaciï¿½n"	,04,"@!",1,TamSX3("ZX2_DTDIGI")[1]	,0,.T.	} )
	AAdd( aCampos,{ "ZX2_ALMORI","Almacï¿½n Origen  "	,05,"@!",1,TamSX3("ZX2_ALMORI")[1]	,0,.T.	} )
	AAdd( aCampos,{ "ZX2_ALMDES","Almacï¿½n Destino"	,06,"@!",1,TamSX3("ZX2_ALMDES")[1]	,0,.T.	} )
	AAdd( aCampos,{ "ZX2_OBSER"	,"Observaciï¿½n "		,07,"@!",1,TamSX3("ZX2_OBSER")[1]	,0,.T.	} )
	*/

	fFilAcm1(@cFiltro)
	If EMPTY(cFiltro)
		Return
	EndIf

	cPath:=ALLTRIM(MV_PAR11)
	Aadd(aSeek,{"Serie+Doc (Salida)"   	, {{"","C",16,0, "ZX2_SERIE+ZX2_DOC"   	,""}}	, 3, .T. } )
	Aadd(aSeek,{"Doc+Serie (Salida)"   	, {{"","C",16,0, "ZX2_DOC+ZX2_SERIE"   	,""}}	, 4, .T. } )
	Aadd(aSeek,{"Serie2+Doc2 (Entrada"  , {{"","C",16,0, "ZX2_SERIE2+ZX2_DOC2"  ,""}}	, 5, .T. } )
	Aadd(aSeek,{"Doc2+Serie2 (Entrada)"	, {{"","C",16,0, "ZX2_DOC2+ZX2_SERIE2"	,""}}	, 6, .T. } )


	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZX2")
	oBrowse:SetDescription(cTitulo)
	oBrowse:AddLegend( "ZX2_ESTADO = '9'",NEGRO			, EstadoDocLegalBLOCKB)
	oBrowse:AddLegend( "ZX2_ESTADO = '8'",MARRON		, EstadoDocLegalBLOCKA)
	oBrowse:AddLegend( "ZX2_ESTADO = '7'",VERDE_C		, EstadoDocLegalVERDEC)
	oBrowse:AddLegend( "ZX2_ESTADO = '6'",VERDE			, EstadoDocLegalVERDE)
	oBrowse:AddLegend( "ZX2_ESTADO = '5'",AZUL			, EstadoDocLegalAZUL)
	oBrowse:AddLegend( "ZX2_ESTADO = '4'",AMARILLO		, EstadoDocLegalAMARILLO)
	oBrowse:AddLegend( "ZX2_ESTADO = '3'",NARANJA		, EstadoDocLegalNARANJA)
	oBrowse:AddLegend( "ZX2_ESTADO = '2'",ROJO			, EstadoDocLegalROJO)
	oBrowse:AddLegend( "ZX2_ESTADO = '1'",BLANCO 		, EstadoDocLegalBLANCO)

	oBrowse:SetFixedBrowse(.F.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetFilterDefault(cFiltro)
	oBrowse:DisableDetails()
	oBrowse:SetSeek(.T.,aSeek)
	oBrowse:SetLocate()
	oBrowse:SetAmbiente(.F.)  // Habilita a utilizaï¿½ï¿½o da funcionalidade Walk-Thru no Browse
	oBrowse:SetWalkThru(.F.)  // Habilita a utilizaï¿½ï¿½o da funcionalidade Walk-Thru no Browse


	/*
	For nX:=1 to Len (aCampos)
		oBrowse:SetColumns(u_MntaCol(aCampos[nX][1],aCampos[nX][2],aCampos[nX][3],aCampos[nX][4],aCampos[nX][5],aCampos[nX][6],aCampos[nX][7], aCampos[nX][8]))
	Next nX
	*/
	oBrowse:Refresh(.T.)
	oBrowse:SetDoubleClick({||u_AcmVer() })
	oBrowse:Activate()
	oBrowse:Destroy()
	RestArea(aArea)
Return 

// -------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------------
// Definicion del Modelo para Semaforizacion
// -------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------------------------------

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Axel Diaz                                                    |
 | Data:  24/12/2019                                                   |
 | Desc:  Creaciï¿½n de Menu del modelo de datos MVC                     |
 *---------------------------------------------------------------------*/
Static Function MenuDef()
	Local aRot 		:= {}
	Local aRotInc	:= {}
	//Adicionando opï¿½ï¿½es

	ADD OPTION aRotInc TITLE 'Salida de Productos'    			ACTION 'VIEWDEF.ACM001' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotInc TITLE 'Entrada de Productos'  			ACTION 'u_ACMEntrada' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4

	ADD OPTION aRot TITLE 'Legalizar' 							ACTION 'U_ACM001Legal'  OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Movimiento de Productos'    			ACTION aRotInc 			OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Visualizar de Documento'  			ACTION 'VIEWDEF.ACM001' OPERATION MODEL_OPERATION_VIEW 	 ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Eliminar Documento'  				ACTION 'U_ACM001Delet' 	OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Modificar Documento Salida'			ACTION 'U_ACMSalida' 	OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 5
	ADD OPTION aRot TITLE 'Leyenda'  							ACTION 'U_LeyenBrw' 	OPERATION 9 					 ACCESS 0 //OPERATION 9
	ADD OPTION aRot TITLE 'Transferir Residuo'  				ACTION 'U_TransR' 		OPERATION 9 					 ACCESS 0 //OPERATION 9
	ADD OPTION aRot TITLE 'Imprimir Documento Salida'  			ACTION 'processa( {|| U_ACMR01A("1",cPath) }, "Preparando Archivo", "Leyendo registros de Salida...", .f.)' 	OPERATION 9 					 ACCESS 0 //OPERATION 9
	ADD OPTION aRot TITLE 'Imprimir Documento Entrada'  		ACTION 'processa( {|| U_ACMR01A("2",cPath) }, "Preparando Archivo", "Leyendo registros de Entrada...", .f.)' 	OPERATION 9 					 ACCESS 0 //OPERATION 9
	ADD OPTION aRot TITLE 'Imprimir Legalización' 				ACTION 'processa( {|| U_ACMR01A("3",cPath) }, "Preparando Archivo", "Leyendo registros...", .f.)' 	OPERATION 9 					 ACCESS 0 //OPERATION 9



Return aRot
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Axel Diaz                                                    |
 | Data:  24/12/2019                                                   |
 | Desc:  Creaciï¿½n de modelo de datos MVC                              |
 *---------------------------------------------------------------------*/
Static Function ModelDef()
	Local oModel
	Local oStHeader 	:= GMSHead()
	Local oStDetail 	:= GMSDetail()   	//Local oStDetail 	:= FWFormStruct( 1, 'ZY2' )
	Local aZY2Rel		:= {}
	Local aTriggeHD		:= {}
	Local aTriggeDT		:= {}
	//			MPFORMMODEL():New(<cID >,<bPre >,<bPost >,<bCommit >,<bCancel >)
	oModel := 	MPFormModel():New('ACM100', /*<bPre >*/{ | oModel | PreVio(oModel) },/*<bPost >*/{ | oModel | PosCommit( oModel ) },/*<bCommit > *//*Commit(oMdl)*/ , /*<bCancel >*/ )

	// Creacion de trigger para campos
	aAdd(aTriggeHD, CreaTrigger("ZX2_SERIE"	,"ZX2_DOC"		,"U_GetSX5Num('ZZ',M->ZX2_SERIE,1,M->ZX2_DOC)"							,.F.	,''		,0	,''							,'','001'))
	aAdd(aTriggeHD, CreaTrigger("ZX2_SERIE2","ZX2_DOC2"		,"U_GetSX5Num('ZZ',M->ZX2_SERIE2,2,M->ZX2_DOC2)"						,.F.	,''		,0	,''							,'','001'))

	aAdd(aTriggeDT, CreaTrigger("ZY2_CODPRO","ZY2_UNORG"	,"SB1->B1_UM"															,.T.	,'SB1'	,1	,'xFilial()+M->ZY2_CODPRO'	,'','001'))
	aAdd(aTriggeDT, CreaTrigger("ZY2_CODPRO","ZY2_2UNORG"	,"SB1->B1_SEGUM"														,.T.	,'SB1'	,1	,'xFilial()+M->ZY2_CODPRO'	,'','002'))
	aAdd(aTriggeDT, CreaTrigger("ZY2_CODPRO","ZY2_TPMOV"	,"U_SemaGrid(M->ZY2_UNORG,M->ZY2_UNORG,M->ZY2_CANTO,M->ZY2_CANTD)"	,.F.	,''		,0	,''	,'','003'))	
	aAdd(aTriggeDT, CreaTrigger("ZY2_CODPRO","DESCRIP"		,"SB1->B1_DESC"															,.T.	,'SB1'	,1	,'xFilial()+M->ZY2_CODPRO'	,'','004'))	
	aAdd(aTriggeDT, CreaTrigger("ZY2_CODPRO","ZY2_CODBAR"	,"SB1->B1_CODBAR"														,.T.	,'SB1'	,1	,'xFilial()+M->ZY2_CODPRO'	,'','005'))	
	aAdd(aTriggeDT, CreaTrigger("ZY2_CODBAR","ZY2_CODPRO"	,"SB1->B1_COD"															,.T.	,'SB1'	,5	,'xFilial()+M->ZY2_CODBAR'	,'','001'))	

	//aAdd(aTriggeDT, CreaTrigger("ZY2_CANTD" ,"ZY2_UNDES"	,"SB1->B1_UM"															,.T.	,'SB1'	,1	,'xFilial()+M->ZY2_CODPRO'	,'','001'))
	aAdd(aTriggeDT, CreaTrigger("ZY2_CANTD"	,"ZY2_2UNORG"	,"SB1->B1_SEGUM"														,.T.	,'SB1'	,1	,'xFilial()+M->ZY2_CODPRO'	,'','002'))
	aAdd(aTriggeDT, CreaTrigger("ZY2_CANTD" ,"ZY2_TPMOV"	,"U_SemaGrid(M->ZY2_UNORG,M->ZY2_UNORG,M->ZY2_CANTO,M->ZY2_CANTD)"		,.F.	,''		,0	,''							,'','003'))	
	aAdd(aTriggeDT, CreaTrigger("ZY2_CANTD" ,"LEYENDA"		,"U_LeySemaFo()"														,.F.	,''		,0	,''							,'','004'))	
	aAdd(aTriggeDT, CreaTrigger("ZY2_CANTD"	,"ZY2_2CANTD"	,"u_FacConv(M->ZY2_CANTD ,M->ZY2_CODPRO,.F.)"							,.F.	,''		,0	,''							,'','005'))
	aAdd(aTriggeDT, CreaTrigger("ZY2_CANTD"	,"DIFERENC"		,"ABS((M->ZY2_CANTO)-(M->ZY2_CANTD))"										,.F.	,''		,0	,''							,'','006'))	

	aAdd(aTriggeDT, CreaTrigger("ZY2_2CANTD","ZY2_CANTD"	,"u_FacConv(M->ZY2_2CANTD,M->ZY2_CODPRO,.T.)"							,.F.	,''		,0	,''							,'','001'))

	aAdd(aTriggeDT, CreaTrigger("ZY2_CANTO"	,"ZY2_2CANTO"	,"IIF(INCLUI .OR. lModiSal,u_FacConv(M->ZY2_CANTO,M->ZY2_CODPRO,.F.),M-ZY2_2CANTO)"	,.F.	,''		,0	,''							,'','001'))
	aAdd(aTriggeDT, CreaTrigger("ZY2_CANTO"	,"ZY2_TPMOV"	,"U_SemaGrid(M->ZY2_UNORG,M->ZY2_UNORG,M->ZY2_CANTO,M->ZY2_CANTD)"		,.F.	,''		,0	,''							,'','002'))
	//aAdd(aTriggeDT, CreaTrigger("ZY2_2CANTO","ZY2_CANTO"	,"u_FacConv(M->ZY2_2CANTO,M->ZY2_CODPRO,.T.)"							,.F.	,''		,0	,''							,'','001'))

	aAdd(aTriggeDT, CreaTrigger("ZY2_UNORG"	,"ZY2_TPMOV"	,"U_SemaGrid(M->ZY2_UNORG,M->ZY2_UNORG,M->ZY2_CANTO,M->ZY2_CANTD)"		,.F.	,''		,0	,''							,'','001'))

	aAdd(aTriggeDT, CreaTrigger("ZY2_TPMOV"	,"LEYENDA"		,"U_LeySemaFo()"														,.F.	,''		,0	,''							,'','001'))	

	//aAdd(aTriggeDT, CreaTrigger("ZY2_UNDES"	,"LEYENDA"		,"U_LeySemaFo()"														,.F.	,''		,0	,''							,'','001'))	
	//aAdd(aTriggeDT, CreaTrigger("ZY2_UNDES"	,"ZY2_TPMOV"	,"U_SemaGrid(M->ZY2_UNORG,M->ZY2_UNORG,M->ZY2_CANTO,M->ZY2_CANTD)"		,.F.	,''		,0	,''							,'','002'))	
	//aAdd(aTriggeDT, CreaTrigger("ZY2_UNDES"	,"ZY2_2UNDES"	,"SB1->B1_SEGUM"													,.T.	,'SB1'	,1	,'xFilial()+M->ZY2_CODPRO'	,'','003'))	


	// disparadores de encabezado
    For nAtual := 1 To Len(aTriggeHD)
        oStHeader:AddTrigger(   aTriggeHD[nAtual][01],; //Campo Origen
                            	aTriggeHD[nAtual][02],; //Campo Destino
                            	aTriggeHD[nAtual][03],; //Bloque de cï¿½digo de validacion que ejecutara el gatillo
                            	aTriggeHD[nAtual][04])  //Bloque de cï¿½digo de execucion 
    Next
    // disparadores de Detalle
    For nAtual := 1 To Len(aTriggeDT)
        oStDetail:AddTrigger(   aTriggeDT[nAtual][01],; //Campo Origen
                            	aTriggeDT[nAtual][02],; //Campo Destino
                            	aTriggeDT[nAtual][03],; //Bloque de cï¿½digo de validacion que ejecutara el gatillo
                            	aTriggeDT[nAtual][04])  //Bloque de cï¿½digo de execucion 
    Next


	// Creando el modelo y las relaciones
	oModel:AddFields('ZX2MASTER',/*cOwner*/	,oStHeader)
	oModel:AddGrid	('ZY2DETAIL','ZX2MASTER',oStDetail,;
				/*bLinePre*/  { |oModelGrid, nLine ,cAction,cField| ACMLPRE(oModelGrid, nLine, cAction, cField) }, ;
				/*bLinePost*/ { |oModelGrid, nLine ,cAction,cField| ACMLPOS(oModelGrid, nLine, cAction, cField) },;
				/*bPre - Grid Inteiro*/,;
				/*bPos - Grid Inteiro*/,;
				/*bLoad - Carga do modelo manualmente*/;
				)  //cOwner ï¿½ para quem pertence

	// Hacer la relaciï¿½n entre padre e hijo
	aAdd(aZY2Rel, {'ZY2_FILIAL'	, 'xFilial( "ZY2" )'	})
	aAdd(aZY2Rel, {'ZY2_DOC'	, 'ZX2_DOC'				})
	aAdd(aZY2Rel, {'ZY2_SERIE' 	, 'ZX2_SERIE'			})
	aAdd(aZY2Rel, {'ZY2_SECUEN' , 'ZX2_SECUEN'			}) 

	oModel:SetRelation('ZY2DETAIL', aZY2Rel, ZY2->(IndexKey(1))) // IndexKey -> Quiero ordenar y luego filtrar
	oModel:GetModel('ZY2DETAIL'):SetUniqueLine({"ZY2_CODPRO"})	// No repita informaciï¿½n o combinaciones {"CAMPO1", "CAMPO2", "CAMPOX"}
	oModel:SetPrimaryKey({})

	// Establecer las descripciones
	oModel:SetDescription("Despacho interno entre bodegas")
	oModel:GetModel('ZX2MASTER'):SetDescription('Encabezado Despacho')
	oModel:GetModel('ZY2DETAIL'):SetDescription('Detalles del Despacho')
Return oModel 
/*---------------------------------------------------------------------+
 | Func:  ViewDef                                                      |
 | Autor: Axel Diaz                                                    |
 | Data:  24/12/2019                                                   |
 | Desc:  Crea VISTA del modelo MVC                                    |
 +---------------------------------------------------------------------+
 */
Static Function ViewDef()
	Local oModel	:= FWLoadModel('ACM001')
	Local oView 	:= FWFormView():New()
	Local oStHeader	:= GVSHead()
	Local oStDetail	:= GVSDetail()
	Local bCodBarra,bAccion
	
	//-- Associa o View ao Model
	oView:SetModel(oModel)  //-- Define qual o modelo de dados serï¿½ utilizado

	//Adicionando os campos do cabeï¿½alho e o grid dos filhos
	oView:AddField('VIEW_ZX2'	,oStHeader,'ZX2MASTER')
	oView:AddGrid( 'VIEW_ZY2'	,oStDetail,'ZY2DETAIL')

	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',35)
	oView:CreateHorizontalBox('GRID',65)

	oView:CreateVerticalBox( 'GRIDIZQ', 90, 'GRID' )  
	oView:CreateVerticalBox( 'GRIDDER', 10, 'GRID' ) 

	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZX2','CABEC')
	oView:SetOwnerView('VIEW_ZY2','GRIDIZQ')

	//Habilitando tï¿½tulo
	oView:EnableTitleView('VIEW_ZX2','Encabezado Transferencia')
	oView:EnableTitleView('VIEW_ZY2','Detalles de la Transferencia')

	oView:AddOtherObject("OTHER_PANEL", {|oPanel| BTNPANELDER(oPanel)}) 
	oView:SetOwnerView("OTHER_PANEL",'GRIDDER')

	//Forï¿½a o fechamento da janela na confirmaï¿½ï¿½o
	oView:SetCloseOnOk({||.T.})

	oView:AddIncrementField('VIEW_ZY2' , 'ZY2_ITEM' )

	//bLeyenda 	:= {|oModel| U_LeyenBrw()}
	//bTransResi 	:= {|oModel| U_TransR(oModel)}
	//oView:AddUserButton("Leyenda","Leyenda",bLeyenda,"Leyenda del Browser")
	//oView:AddUserButton("Transferir Residuo ","Transferir Residuo ",bTransResi,"Transferir Residuo")
	//oView:SetViewProperty( 'VIEW_ZY2', "SETCSS", { "QTableView { selection-background-color: #1C9DBD; }" } ) 
	//oView:SetViewProperty( 'VIEW_ZY2', "SETCSS", { "QTableView QTableCornerButton::section {  background: red;   border: 2px outset red;}" } )
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
	
	oStruct:AddTable('ZX2',{'ZX2_SERIE','ZX2_BUSSER','ZX2_DOC','ZX2_DTDIGI','ZX2_OBSER','ZX2_ALMORI','ZX2_ALMDES', ;
						'ZX2_DOC2','ZX2_SERIE2','ZX2_ESTADO', 'ZX2_D3DOC', 'ZX2_DTMOV', 'ZX2_FLEGAL', 'ZX2_SECUEN', 'ZX2_DTDIG2',;
						'ZX2_TIME1','ZX2_TIME2','ZX2_RESPO1','ZX2_RESPO2'},"Encabezado")
	//oStruct:RemoveField('ZX2_OK')
	aCampo:=u_SX3Datos('ZX2_SERIE')
	//      AddField(<cTitulo >	, <cTooltip >	, <cIdField >	, <cTipo >	, <nTamanho >	, [ nDecimal ]	, [ bValid ]							, [ bWhen ], [ aValues ], [ lObrigat ]	, [ bInit ], <lKey >, [ lNoUpd ], [ lVirtual ], [ cValid ])
	oStruct:AddField(aCampo[6]	,aCampo[7]		,aCampo[2]		,aCampo[3]	,  aCampo[4]	, aCampo[5]		, /*{ |oMdl| u_GetSerAx(oMdl), .T. }*/	,			, {}		, aCampo[19]	, , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_DOC');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_DTDIGI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_OBSER');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_ALMORI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_SERIE2');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_DOC2');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )	
	aCampo:=u_SX3Datos('ZX2_DTDIG2');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )	
	aCampo:=u_SX3Datos('ZX2_ALMDES');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_ESTADO');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_D3DOC');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_DTMOV');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_FLEGAL');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_SECUEN');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_TIME1');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_TIME2');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_RESPO1');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX2_RESPO2');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )

//	oStruct:SetProperty('ZX2_DOC' 		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F. .AND. (IIF(INCLUI .AND. U_ValUsrSe(M->ZX2_SERIE), .T., .F.))'))
//	oStruct:SetProperty('ZX2_DOC' 		, MODEL_FIELD_OBRIGAT,.F.)
	oStruct:SetProperty('ZX2_DOC' 		, MODEL_FIELD_OBRIGAT,.T.)
	oStruct:SetProperty('ZX2_DOC' 		, MODEL_FIELD_VALID,	FwBuildFeature(STRUCT_FEATURE_VALID, 'U_ValSerDoc(M->ZX2_SERIE, M->ZX2_DOC, 1) .OR. Vazio()'))
	oStruct:SetProperty('ZX2_SERIE' 	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  'IIF(INCLUI, .T., .F.)'))
	oStruct:SetProperty('ZX2_SERIE' 	, MODEL_FIELD_OBRIGAT,.T.)
	oStruct:SetProperty('ZX2_SERIE' 	, MODEL_FIELD_VALID,	FwBuildFeature(STRUCT_FEATURE_VALID, 'U_ValUsrSe(M->ZX2_SERIE) .OR. Vazio()'))

	oStruct:SetProperty('ZX2_DTDIGI'	, MODEL_FIELD_INIT,{|| IIF(INCLUI,dDataBase, CTOD("  /  /  "))})
	oStruct:SetProperty('ZX2_DTDIGI'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))

	oStruct:SetProperty('ZX2_TIME1'		, MODEL_FIELD_INIT,{|| IIF(INCLUI,TIME(),"")})
	oStruct:SetProperty('ZX2_RESPO1'	, MODEL_FIELD_INIT,{|| IIF(INCLUI,UsrRetName(RetCodUsr()),"")})

	oStruct:SetProperty('ZX2_DTDIG2'	, MODEL_FIELD_INIT,{|| IIF(ALTERA,dDataBase, CTOD("  /  /  ")) })
	oStruct:SetProperty('ZX2_ALMORI'	, MODEL_FIELD_OBRIGAT,.T.)
	oStruct:SetProperty('ZX2_ALMORI'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  'IIF(INCLUI .OR. lModiSal, .T., .F.)'))
	oStruct:SetProperty('ZX2_ALMORI' 	, MODEL_FIELD_VALID,	FwBuildFeature(STRUCT_FEATURE_VALID, 'ExistCPO("NNR") .OR. Vazio()'))

	oStruct:SetProperty('ZX2_ALMDES'	, MODEL_FIELD_OBRIGAT,.T.)
	oStruct:SetProperty('ZX2_ALMDES'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  'IIF(INCLUI .OR. lModiSal , .T., .F.)'))
	oStruct:SetProperty('ZX2_ALMDES' 	, MODEL_FIELD_VALID,	FwBuildFeature(STRUCT_FEATURE_VALID, '(ExistCPO("NNR") .OR. Vazio()).AND.(M->ZX2_ALMDES<>M->ZX2_ALMORI .OR. Vazio())'))

	oStruct:SetProperty('ZX2_DOC2' 		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  'IIF(!INCLUI .AND. U_ValUsrSe(M->ZX2_SERIE2), .T., .F.)'))
	oStruct:SetProperty('ZX2_DOC2' 		, MODEL_FIELD_OBRIGAT,.F.)
	oStruct:SetProperty('ZX2_DOC2' 		, MODEL_FIELD_VALID,	FwBuildFeature(STRUCT_FEATURE_VALID, 'U_ValSerDoc(M->ZX2_SERIE2, M->ZX2_DOC2, 1) .OR. Vazio()'))

	oStruct:SetProperty('ZX2_SERIE2' 	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  'IIF(!INCLUI .AND. !lModiSal, .T., .F.)'))
	oStruct:SetProperty('ZX2_SERIE2' 	, MODEL_FIELD_OBRIGAT,.F.)
	oStruct:SetProperty('ZX2_SERIE2' 	, MODEL_FIELD_VALID,	FwBuildFeature(STRUCT_FEATURE_VALID, '(U_ValUsrSe(M->ZX2_SERIE2) .OR. Vazio()) .AND. (M->ZX2_SERIE<>M->ZX2_SERIE2 .OR. Vazio())'))

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

	oStruct:AddTable('ZY2',{'ZY2_ITEM','ZY2_DOC','ZY2_SERIE','ZY2_CODPRO','ZY2_UNORG','ZY2_CODBAR',;
							'ZY2_CANTO','ZY2_CANTD','ZY2_ESTADO','ZY2_LEGALI',;
							'ZY2_DTDIGI','ZY2_OBSERV','ZY2_TPMOV','ZY2_DOC2','ZY2_SERIE2',;
							'ZY2_2UNORG',; // 'ZY2_2UNDES','ZY2_UNDES',;
							'ZY2_2CANTO','ZY2_2CANTD','ZY2_SECUEN','ZY2_DTDIG2','LEGENDA','DESCRIP', 'DIFERENC'},;
					"Detalles")

	//      									AddField(<cTitulo >	,<cTooltip >,<cIdField >,<cTipo >	, <nTamanho > , [ nDecimal ]	, [ bValid ], [ bWhen ], [ aValues ], [ lObrigat ]	, [ bInit ], <lKey >, [ lNoUpd ], [ lVirtual ], [ cValid ])
	aCampo:=u_SX3Datos('ZY2_TPMOV')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}			, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_ITEM')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}			, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_DOC')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}			, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_SERIE')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_CODPRO');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_CODBAR');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )	
	aCampo:=u_SX3Datos('ZY2_UNORG')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_2UNORG');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	//aCampo:=u_SX3Datos('ZY2_UNDES');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	//aCampo:=u_SX3Datos('ZY2_2UNDES');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_CANTO')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_2CANTO');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_CANTD')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_2CANTD');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_ESTADO');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_LEGALI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_DTDIGI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_OBSERV');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_TPMOV')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_DOC2')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_SERIE2');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_SECUEN');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZY2_DTDIG2');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )

										oStruct:AddField('Legenda'	,'Legenda'	,'LEGENDA' 	, 'C'		,20				, 0			,,,{}, .F.		, FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVC011InitPad()")	, .F., .F., .T., , ) 
										oStruct:AddField('Descrip'	,'Descripción','DESCRIP', 'C'		,TamSX3("B1_DESC")[1], 0	,,,{}, .F.		, FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVC011Des()"), .F., .F., .T., , ) 
										oStruct:AddField('Diferenc'	,'Diferenc'	,'DIFERENC'	, 'N'		,4				, 0			,,,{}, .F.		, FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVC011Dif()")					, .F., .F., .T., , ) 


	oStruct:SetProperty('ZY2_DTDIGI'	, MODEL_FIELD_INIT,{|| IIF(INCLUI,dDataBase, CTOD("  /  /  "))})

	oStruct:SetProperty('ZY2_CODPRO' 	, MODEL_FIELD_VALID,	FwBuildFeature(STRUCT_FEATURE_VALID, 'Vazio().Or.ExistCpo("SB1",M->ZY2_CODPRO,1)'))
	oStruct:SetProperty('ZY2_UNORG' 	, MODEL_FIELD_VALID,	FwBuildFeature(STRUCT_FEATURE_VALID, 'Vazio().Or.ExistCpo("SAH",M->ZY2_UNORG,1)'))
 	oStruct:SetProperty('ZY2_2UNORG' 	, MODEL_FIELD_VALID,	FwBuildFeature(STRUCT_FEATURE_VALID, 'Vazio().Or.ExistCpo("SAH",M->ZY2_2UNORG,1)'))

	oStruct:SetProperty('ZY2_CODPRO' 	, MODEL_FIELD_OBRIGAT, .T. )
    oStruct:SetProperty('ZY2_CANTO' 	, MODEL_FIELD_OBRIGAT, .T. )
    oStruct:SetProperty('ZY2_2CANTO' 	, MODEL_FIELD_OBRIGAT, .T. )
    oStruct:SetProperty('ZY2_UNORG' 	, MODEL_FIELD_OBRIGAT, .T. )
	oStruct:SetProperty('ZY2_2UNORG' 	, MODEL_FIELD_OBRIGAT, .T. )
    oStruct:SetProperty('ZY2_DOC'		, MODEL_FIELD_OBRIGAT, .F. )
	oStruct:SetProperty('ZY2_SERIE'		, MODEL_FIELD_OBRIGAT, .F. )
	oStruct:SetProperty('ZY2_DOC2'		, MODEL_FIELD_OBRIGAT, .F. )
	oStruct:SetProperty('ZY2_SERIE2'	, MODEL_FIELD_OBRIGAT, .F. )
 
 	oStruct:SetProperty('ZY2_ITEM'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,	'.F.'))
	oStruct:SetProperty('ZY2_TPMOV'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,	'.F.'))
	oStruct:SetProperty('ZY2_UNORG'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,	'.F.'))
	oStruct:SetProperty('ZY2_2UNORG'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,	'.F.'))
	oStruct:SetProperty('ZY2_CANTO' 	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN, '.T.'))
	oStruct:SetProperty('ZY2_2CANTO' 	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN, '.T.'))
	oStruct:SetProperty('ZY2_CANTD' 	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN, 'IIF(INCLUI .OR. lIncAcme, .F., .T.)'))
	oStruct:SetProperty('ZY2_2CANTD' 	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN, 'IIF(INCLUI .OR. lIncAcme, .F., .T.)'))
	oStruct:SetProperty('ZY2_DTDIG2'	, MODEL_FIELD_INIT,{|| IIF(!INCLUI,dDataBase, CTOD("  /  /  ")) })

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

	aCampo:=u_SX3Datos('ZX2_SERIE');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '01',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX2_DOC');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '02',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX2_DTDIGI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '03',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX2_ALMORI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '04',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX2_SERIE2');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '05',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX2_DOC2');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '06',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX2_DTDIG2');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '07',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX2_ALMDES');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '08',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX2_OBSER');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '09',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/           ,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)

	oStruct:SetProperty('ZX2_DOC2'	, MVC_VIEW_CANCHANGE, IIF( ALTERA .AND. !lLegaliza .AND. !lModiSal, .T., .F.))
	oStruct:SetProperty('ZX2_DTDIG2', MVC_VIEW_CANCHANGE, .F.)

	oStruct:SetProperty('ZX2_DOC', MVC_VIEW_CANCHANGE, IIF( lModiSal .or. lIncAcme .OR. (INCLUI .AND. !lLegaliza) 	, .T., .F.))
	oStruct:SetProperty('ZX2_ALMDES', MVC_VIEW_CANCHANGE, IIF( lModiSal .or. lIncAcme .OR. (INCLUI .AND. !lLegaliza) 	, .T., .F.))
	oStruct:SetProperty('ZX2_ALMORI', MVC_VIEW_CANCHANGE, IIF( lModiSal .or. lIncAcme .OR. (INCLUI .AND. !lLegaliza) 	, .T., .F.))

return oStruct
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

	aCampo:=u_SX3Datos('ZY2_ITEM');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '02',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY2_CODPRO');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '03',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY2_CODBAR');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '05',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY2_UNORG');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '06',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ .F.,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY2_2UNORG');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '07',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ .F.,/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY2_CANTO');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '08',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY2_2CANTO');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '09',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	//aCampo:=u_SX3Datos('ZY2_UNDES');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '10',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	//aCampo:=u_SX3Datos('ZY2_2UNDES');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '11',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY2_CANTD');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '12',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY2_2CANTD');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '13',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY2_OBSERV');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '14',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)

										oStruct:AddField(/*cIdField*/ 'LEGENDA',/*cOrdem*/ '01', /*cTitulo*/ '#'		, /*cDescric*/ 'Leyenda'							,/*aHelp*/,/*cType*/ 'Get',/*cPicture*/ '@BMP',,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )
										oStruct:AddField(/*cIdField*/ 'DESCRIP',/*cOrdem*/ '04',/*cTitulo*/'Descripciï¿½n', /*cDescric*/ 'Descripciï¿½n del Producto'			,/*aHelp*/,/*cType*/ 'C'  ,/*cPicture*/"@!S45",,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )
										oStruct:AddField(/*cIdField*/'DIFERENC',/*cOrdem*/ '15',/*cTitulo*/'Diferencia' , /*cDescric*/ 'Diferencia entre salida y llegada'	,/*aHelp*/,/*cType*/ 'N'  ,/*cPicture*/"@9999",,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )

	oStruct:SetProperty('ZY2_CODPRO', MVC_VIEW_CANCHANGE,IIF( (INCLUI .AND. !lLegaliza)	.OR. lModiSal , .T., .F.))
	oStruct:SetProperty('ZY2_CODBAR', MVC_VIEW_CANCHANGE,IIF( (INCLUI .AND. !lLegaliza)	.OR. lModiSal , .T., .F.))
	oStruct:SetProperty('ZY2_CANTO'	, MVC_VIEW_CANCHANGE,IIF( lModiSal .or. lIncAcme .OR. (INCLUI .AND. !lLegaliza) 	, .T., .F.))
	oStruct:SetProperty('ZY2_2CANTO', MVC_VIEW_CANCHANGE,IIF( lModiSal .or. lIncAcme .OR. (INCLUI .AND. !lLegaliza)	, .T., .F.))
	oStruct:SetProperty('ZY2_UNORG'	, MVC_VIEW_CANCHANGE,.F. .AND. 	IIF( INCLUI .AND. !lLegaliza	, .T., .F.))
	oStruct:SetProperty('ZY2_2UNORG', MVC_VIEW_CANCHANGE,.F. .AND. 	IIF( INCLUI .AND. !lLegaliza	, .T., .F.))

	oStruct:SetProperty('ZY2_CANTD'	, MVC_VIEW_CANCHANGE,			IIF((!INCLUI .OR. !lIncAcme).AND. !lLegaliza .AND. !lModiSal	, .T., .F.))
	oStruct:SetProperty('ZY2_2CANTD', MVC_VIEW_CANCHANGE,			IIF((!INCLUI .OR. !lIncAcme).AND. !lLegaliza .AND. !lModiSal	, .T., .F.))

return oStruct

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
Static Function PreVio( oModel )
	Local lRet 			:= .T.
	Local oModelZX2	:= oModel:GetModel('ZX2MASTER')
	Local oModelZY2	:= oModel:GetModel('ZY2DETAIL')
	//PRIVATE cSD3AcDoc	:= ""
	//PRIVATE cSaldo		:= ""
	 SetKey(VK_F4, {||  MaViewSB2(oModelZY2:GetValue('ZY2_CODPRO')) })
		If lLegaliza
			cSD3AcDoc	:= ""
			cSaldo		:= ""
			oModelZX2:SetValue('ZX2_DTMOV',dDatabase)
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
Static Function Commit(oModel)
	Local lRet := .T.
Return lRet
/*
+---------------------------------------------------------------------------+
| Programa  #            |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #                                                               |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # VALIDACION MODELO AL DESPUES DE CONFIRMAR                     |
+---------------------------------------------------------------------------+
*/
Static Function PosCommit(oModel)
	Local lRet 		:= .T.
	Local nOperation:= oModel:GetOperation()
	Local oModelZY2	:= oModel:GetModel('ZY2DETAIL')
	Local oModelZX2	:= oModel:GetModel('ZX2MASTER')
	Local nI		:=0
	Local cDoc		:= oModel:GetValue("ZX2MASTER","ZX2_DOC" )
	Local cSerie	:= oModel:GetValue("ZX2MASTER","ZX2_SERIE")
	Local cNewDoc	:= u_GetSX5Num("ZZ",cSerie,1,cDoc)
	Local nCantY2	:= 0
	Local nCantB2	:= 0
	Local cSaldo	:= ""
	Local lSaldo	:= .T.
	Local cDoc2		:= ""
	Local cSerie2	:= ""
	Local cDoc2tmp	:= ""
	Local cSer2tmp	:= ""
	Local cNewDoc2	:= ""
	Local lTpMov1 	:= .F. // Nuevo, Salida de Materia sin Ingreso aun
	Local lTpMov2 	:= .F. // Ingreso, entrada de Materia, coinciden Verde
	Local lTpMov3 	:= .F. // Ingreso, entrada de Materia, Faltan  Amarillo
	Local lTpMov4 	:= .F. // Ingreso, entrada de Materia, Rojo Sobra
	Local nTpMov	:= 0
	Local cRSal		:= GetNextAlias()
	Local cReserv 	:= SUPERGETMV("MV_XACMRSV", .F., "3") //1= NO DEJA GRABAR SEMAFORIZACION SIN SALDO, 2= DEJA GRABAR NO MUESTRA MENSAJE, 3=DEJA GRABAR SI MUESRA MENSAJE 
	PRIVATE cSaldo	:= ""
	// -----------------------------------------------------
	// En caso de Insertar nuevo Registro de Salida
	// -----------------------------------------------------
	If nOperation==MODEL_OPERATION_INSERT .OR. lModiSal //Insert OR MODIFICANDO LA SALIDA.
		oModel:SetValue("ZX2MASTER","ZX2_ESTADO", 	ESTADO_BLANCO )
		oModel:SetValue("ZX2MASTER","ZX2_SECUEN", "001")
		oModel:SetValue("ZX2MASTER","ZX2_DOC",u_NumReal("ZZ",cDoc,cSerie ))
		cDoc:= oModel:GetValue("ZX2MASTER","ZX2_DOC" )
		If !(lModiSal .and. cDocModi==cDoc)
			If nOperation==MODEL_OPERATION_INSERT
				If !(cDoc==u_GetSX5Num("ZZ",cSerie,1,cDoc))
					If !U_ValSerDoc(cSerie,cDoc,1)
						cDoc:=u_GetSX5Num("ZZ",cSerie,1,cDoc)
						oModel:SetValue("ZX2MASTER","ZX2_DOC", 	cDoc )
						Help(NIL, NIL, "Número en Uso",NIL,"El número de documento de Salida ya está en uso", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Se asigno el número: '+cDoc}) 
					EndIf
				EndIf
				// Actualiza la Serie
				dbSelectArea("SX5")
				dbSetOrder(1)
				If dbSeek(xFilial("SX5") + "ZZ" + cSerie )
					IF (oModel:GetValue("ZX2MASTER","ZX2_DOC")>SX5->X5_DESCRI)
						RECLOCK("SX5", .F.)
						SX5->X5_DESCRI	:=oModel:GetValue("ZX2MASTER","ZX2_DOC")
						SX5->X5_DESCSPA	:=oModel:GetValue("ZX2MASTER","ZX2_DOC")
						SX5->X5_DESCENG	:=oModel:GetValue("ZX2MASTER","ZX2_DOC")
						MSUNLOCK()
					EndiF
				EndIf
				SX5->(dbcloseArea())
			Else
				If !U_ValSerDoc(cSerie,cDoc,1)   // Doc existe devuelve falso
					lRet:=.F.
					Help(NIL, NIL, "número en Uso",NIL,"El número de documento de Salida ya está en uso", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Busque un número no usado'}) 
					Return lRet
				EndIf
			EndIf
		EndIf
		// Cant Saldo
		cSalFull:= ""
		For nI := 1 To oModelZY2:Length()
			oModelZY2:GoLine( nI )
			oModelZY2:SetValue('ZY2_TPMOV', TP_MOV_GRIS)
			nCantY2	:=oModelZY2:GetValue("ZY2_CANTO")
			// Revisa el Saldo en SB2 y resta el saldo de este documento.
			NCantB2	:=POSICIONE("SB2",1, xFilial("SB2")+oModelZY2:GetValue("ZY2_CODPRO")+oModelZX2:GetValue("ZX2_ALMORI"),"B2_QATU")-;
						POSICIONE("SB2",1, xFilial("SB2")+oModelZY2:GetValue("ZY2_CODPRO")+oModelZX2:GetValue("ZX2_ALMORI"),"B2_QEMP")

			IF NCantB2-nCantY2<0
				lSaldo:=.F.
				cSaldo+="<br><b>"+oModelZY2:GetValue("ZY2_CODPRO")+"</b>-"+POSICIONE('SB1',1,xfilial('SB1')+oModelZY2:GetValue("ZY2_CODPRO"),'B1_DESC')
			Else
				cQry := " SELECT SUM(ZY2_CANTO) CANT  FROM "
				cQry += InitSqlName("ZX2")+" ZX2 INNER JOIN "+InitSqlName("ZY2")+" ZY2 ON "
				cQry += " ZX2_DOC=ZY2_DOC AND ZX2_SERIE=ZY2_SERIE AND ZY2.D_E_L_E_T_=' ' "
				cQry += " AND ZY2_CODPRO='"+oModelZY2:GetValue("ZY2_CODPRO")+"'" 
				cQry += " AND ZY2_FILIAL='"+xFilial("ZY2")+"' "
				cQry += " WHERE ZX2_D3DOC='               ' AND ZX2_ALMORI='"+oModelZX2:GetValue("ZX2_ALMORI")+"' AND ZX2.D_E_L_E_T_=' '"
				cQry += " AND ZX2_FILIAL='"+xFilial("ZX2")+"' "
				dbUseArea(.T.,"TOPCONN", TcGenQry(nil,nil,cQry) ,cRSal,.T.,.T.)
				DbSelectArea(cRSal)
				(cRSal)->(DbGoTop())

				If ((cRSal)->CANT+nCantY2)>NCantB2
					cSalFull +="El Cod:<b>"+oModelZY2:GetValue("ZY2_CODPRO")+"</b> - "
					cSalFull +="con Cant.SinLegalizar de:"+ cValToChar((cRSal)->CANT+nCantY2)
					cSalFull +="- Bodega #:"+oModelZX2:GetValue("ZX2_ALMORI")+"<br>"
				EndIf
				(cRSal)->(DbCloseArea())
			EndIf
		NexT

	// -----------------------------------------------------
	// En caso de Insertar nuevo Registro de Entrada o Legalización
	// -----------------------------------------------------
	ElseiF nOperation==MODEL_OPERATION_UPDATE // Modificar
		// ---------------------
		// En Caso de Legalizar
		// ---------------------
		If lLegaliza
			If !EMPTY(cSD3AcDoc) .AND. cSD3AcDoc<>"SALDOINSU"
				If oModelZX2:GetValue("ZX2_ESTADO")==ESTADO_AMARILLO .OR. oModelZX2:GetValue("ZX2_ESTADO")==ESTADO_BLOCK_A
					oModelZX2:SetValue("ZX2_ESTADO",ESTADO_VERDE)
				Else  // ESTADO_NARANJA
				    oModelZX2:SetValue("ZX2_ESTADO",ESTADO_AZUL)
				EndIf
				oModelZX2:SetValue("ZX2_FLEGAL"	,dDatabase)
				oModelZX2:SetValue("ZX2_D3DOC"	,cSD3AcDoc)
				For nI := 1 To oModelZY2:Length()
					oModelZY2:GoLine( nI )
					oModelZY2:SetValue("ZY2_LEGALI",dDataBase)
				Next 
				lRet	:= .T.
			Else 
				IF cSD3AcDoc<>"SALDOINSU"
					If oModelZX2:GetValue("ZX2_ESTADO")==ESTADO_BLOCK_A
						cQry:= "UPDATE "+InitSqlName("ZX2")+" SET ZX2_ESTADO='"+ESTADO_AMARILLO+"',ZX2_FLEGAL='"+DTOC("  /  /  ")+"' FROM "+RetSQLName("ZX2")+" WHERE ZX2_FILIAL='"+xFilial("ZX2")+"' AND ZX2_SERIE='"+cSerO+"' AND ZX2_DOC='"+cDocO+"' AND D_E_L_E_T_=' '"
					Else  // ESTADO_NARANJA
						cQry:= "UPDATE "+InitSqlName("ZX2")+" SET ZX2_ESTADO='"+ESTADO_NARANJA+"',ZX2_FLEGAL='"+DTOC(dDatabase)+"' FROM "+RetSQLName("ZX2")+" WHERE ZX2_FILIAL='"+xFilial("ZX2")+"' AND ZX2_SERIE='"+cSerO+"' AND ZX2_DOC='"+cDocO+"' AND D_E_L_E_T_=' '"
					EndIf
				ENDif
				lRet	:= .F.
			EndIf
		Else
			If Empty(oModelZX2:GetValue("ZX2_SERIE2")) .OR. Empty(oModelZX2:GetValue("ZX2_ALMDES"))	
				lRet	:= .F.
			Else
				For nI := 1 To oModelZY2:Length()
					oModelZY2:GoLine( nI )
					If lRet .and. !(oModelZY2:IsDeleted()) .and. Empty(oModelZY2:GetValue("ZY2_CANTD"))//	lRet .and. !(oModelZY2:IsDeleted()) .and. (Empty(oModelZY2:GetValue("ZY2_UNDES")) .OR. Empty(oModelZY2:GetValue("ZY2_CANTD"))) 
						lRet	:= .F.
					EndIf
				NexT
			EndIf
			If !lRet
				Help(NIL, NIL, "Completar Datos",NIL,"Los datos obligatorios no han sido diligenciados", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Revise los campos <br>Serie del documento de Entrada <b>(ZX2_SERIE2)</b>,<br>Bodega de entrada <b>(ZX2_ALMDES)</b>, <br>Cantidad <b>(ZY2_CANTD)</b>'}) // o <br>Unidad de Medida <b>(ZY2_UNDES)</b>
			Else
				cDoc2		:= oModel:GetValue("ZX2MASTER","ZX2_DOC2" )
				cSerie2		:= oModel:GetValue("ZX2MASTER","ZX2_SERIE2")
				nTpMov		:= oModel:GetValue("ZX2MASTER","ZX2_ESTADO")
				oModel:SetValue("ZX2MASTER","ZX2_DOC2",u_NumReal("ZZ",cDoc2,cSerie2 ))
				cDoc2		:= u_NumReal("ZZ",cDoc2,cSerie2 )

				If !U_ValSerDoc(cSerie2,cDoc2,2) .AND.  nTpMov==ESTADO_BLANCO  // Doc existe devuelve falso
					lRet:=.F.
					Help(NIL, NIL, "Número en Uso",NIL,"El número de documento de Entrada ya está en uso", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Busque un número no usado'}) 
					Return lRet
				Else
					oModelZY2:GoLine(1)
					cSer2tmp:=oModelZY2:GetValue("ZY2_SERIE2")
					cDoc2tmp:=oModelZY2:GetValue("ZY2_DOC2")
					If (cSerie2+cDoc2)<>(cSer2tmp+cDoc2tmp) .AND. !U_ValSerDoc(cSerie2,cDoc2,2)  // REVISA SI CAMBIO EN NUMERO EDITANDO LA ENTRADA
						lRet:=.F.
						Help(NIL, NIL, "Número en Uso",NIL,"El número de documento de Entrada ya está en uso", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Busque un numero no usado'}) 
						Return lRet
					endIf
				EndIf

				oModelZX2:SetValue("ZX2_DTDIG2",dDataBase)
				oModelZX2:SetValue("ZX2_RESPO2",UsrRetName(RetCodUsr()))
				oModelZX2:SetValue("ZX2_TIME2",TIME())
				cNewDoc2	:= u_GetSX5Num("ZZ",cSerie2,2,cDoc2)
				For nI := 1 To oModelZY2:Length()
					oModelZY2:GoLine( nI )
					If !(oModelZY2:IsDeleted())
						// ZY2_TPMOV := TP_MOV_GRIS	 Nuevo, Salida de Materia sin Ingreso aun
						// ZY2_TPMOV := TP_MOV_VERDE Ingreso, entrada de Materia, coinciden Verde
						// ZY2_TPMOV := TP_MOV_AMARILLO entrada de Materia, Faltan  Amarillo
						// ZY2_TPMOV := TP_MOV_ROJO	 Ingreso, entrada de Materia, Rojo Sobra

						If (oModelZY2:GetValue("ZY2_TPMOV")==TP_MOV_VERDE)
							lTpMov2	:= 	.T.
						ElseIf (oModelZY2:GetValue("ZY2_TPMOV")==TP_MOV_AMARILLO)
							lTpMov3	:=	.T.
						ElseIF (oModelZY2:GetValue("ZY2_TPMOV")==TP_MOV_ROJO)
							lTpMov4	:=	.T.
						EndIF
						oModelZY2:SetValue("ZY2_SERIE2",cSerie2)
						oModelZY2:SetValue("ZY2_DOC2",cDoc2)
						oModelZY2:SetValue("ZY2_DTDIG2",dDataBase)
					EndIf
				NexT

				If lTpMov4  		//  hubo un ROJO
					oModel:SetValue("ZX2MASTER","ZX2_ESTADO", 	ESTADO_ROJO )
				ElseIf lTpMov3		// hubo un AMARILLO
					oModel:SetValue("ZX2MASTER","ZX2_ESTADO", 	ESTADO_NARANJA )
				ElseIf lTpMov2		// hubo un  VERDE
					oModel:SetValue("ZX2MASTER","ZX2_ESTADO", 	ESTADO_AMARILLO )
				Else				// DESCONOCIDO
					oModel:SetValue("ZX2MASTER","ZX2_ESTADO", 	ESTADO_BLANCO )
				EndIf

				// Actualiza la Serie
				//If !(cDoc2==u_GetSX5Num("ZZ",cSerie2,2))
				//	Help(NIL, NIL, "número de documento Serie 2",NIL,"El número de documento serï¿½ cambiado, dado que el diligenciado "+cDoc+"ya está siendo utilizado o no cumple con el estandar", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Anote el nuevo número '+cNewDoc})
				//	cDoc2:=u_GetSX5Num("ZZ",cSerie2,2)
				//	oModel:SetValue("ZX2MASTER","ZX2_DOC2", 	cDoc2 )
				//EndIf
				dbSelectArea("SX5")
				dbSetOrder(1)
				If dbSeek(xFilial("SX5") + "ZZ" + cSerie2 )
					IF (oModel:GetValue("ZX2MASTER","ZX2_DOC2")>SX5->X5_DESCRI)
						RECLOCK("SX5", .F.)
						SX5->X5_DESCRI:=oModel:GetValue("ZX2MASTER","ZX2_DOC2")
						SX5->X5_DESCSPA:=oModel:GetValue("ZX2MASTER","ZX2_DOC2")
						SX5->X5_DESCENG:=oModel:GetValue("ZX2MASTER","ZX2_DOC2")
						MSUNLOCK()
					EndiF
				EndIf
				SX5->(dbcloseArea())
			EndIf
		EndIf
	EndIf
IF !lSaldo .or. cSD3AcDoc=="SALDOINSU"
	
	lRet:=.F.
	IF cSD3AcDoc<>"SALDOINSU"
	//Help(NIL, NIL, "Saldo Insuficiente",NIL,"Cantidad en la Bodega Origen es insuficiente para hacer el despacho interno", 1, 0, NIL, NIL, NIL, NIL, NIL,{"Revise las cantidades:"+cSaldo}) 
		Help(NIL, NIL, "Saldo Insuficiente",NIL,"La cantidad de productos diligenciados supera la cantidad en Inventario", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Revise las cantidades de:<br>'+cSaldo}) // o <br>Unidad de Medida <b>(ZY2_UNDES)</b>
	ELSE
		Help(NIL, NIL, "Saldo Insuficiente",NIL,"Cantidad en la Bodega Origen es insuficiente para hacer el despacho interno", 1, 0, NIL, NIL, NIL, NIL, NIL,{"Revise las cantidades"})
	ENDIF
EndIf
If !EMPTY(cSalFull) .and. lSaldo
	IF cReserv=='3'
		Help(NIL, NIL, "Saldo Comprometido(MV_XACMRSV)",NIL,"Documento grabado, PERO con saldo comprometido SIN Legalización:(Incluyendo este Despacho)", 1, 0, NIL, NIL, NIL, NIL, NIL,{'Revise:'+cSalFull}) // o <br>Unidad de Medida <b>(ZY2_UNDES)</b>
	ElseIf cReserv="1"
		Help(NIL, NIL, "Saldo Comprometido(MV_XACMRSV)",NIL,"Documento NO podrá grabarse con saldo comprometido sin Legalización:(Incluyendo este Despacho)", 1, 0, NIL, NIL, NIL, NIL, NIL,{cSalFull}) // o <br>Unidad de Medida <b>(ZY2_UNDES)</b>
	EndIf
EndIf
If lRet
	cDocModi:=""
EndIf
Return lRet 
/*
+---------------------------------------------------------------------------+
| Programa  #            |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #                                                               |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # VALIDACION MODELO DETAIL A CAMBIAR DE LINEA                   |
+---------------------------------------------------------------------------+
*/
Static Function ACMLPOS(oModel, nLinha, cAcao, cCampo)
	Local lRet := .T.
Return lRet
/*
+---------------------------------------------------------------------------+
| Programa  #            |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #   OPERATION MODEL_OPERATION_VIEW   OPERATION 1                |
|           #   OPERATION MODEL_OPERATION_INSERT OPERATION 3                |
|           #   OPERATION MODEL_OPERATION_UPDATE OPERATION 4                |
|           #   OPERATION MODEL_OPERATION_DELETE OPERATION 5                |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # VALIDACION MODELO AL ENTRAR EN LA LINEA                       |
+---------------------------------------------------------------------------+
*/
Static Function ACMLPRE( oModelGrid, nLinha, cAcao, cCampo )
	Local lRet 		:= .T.
	Local oModel 	:= oModelGrid:GetModel()
	Local oModelZX2	:= oModel:GetModel("ZX2MASTER")
	Local oModelZY2	:= oModel:GetModel("ZY2DETAIL")
	Local nOperation:= oModel:GetOperation()
	// Valida si se puede quietar una linea del Grid  // Otros Valores -> cAcao= "CANSETVALUE" nOperation==MODEL_OPERATION_UPDATE<-Modificar
	If cAcao == 'DELETE' .AND. nOperation == MODEL_OPERATION_UPDATE
		If !(oModelZY2:GetValue("ZY2_2CANTO")<=0)
			lRet := .F.
			Help( ,, 'Help',, 'No puede eliminar lineas de un tranferencia de entrada' +;
					CRLF + 'Linea Número ' + Alltrim( Str( nLinha ) ), 1, 0 )
		EndIf
	EndIf

	If nOperation==MODEL_OPERATION_INSERT .AND. INCLUI
		If Empty(AllTrim(oModelZX2:GetValue('ZX2_SERIE'))) .OR. ;
		   Empty(AllTrim(oModelZX2:GetValue('ZX2_DOC'))) .OR. ;
		   Empty(AllTrim(oModelZX2:GetValue('ZX2_ALMORI')))
		   MsgInfo('Uno de los campos del encabezado no está diligenciado.'+CRLF+'Favor revise, Serie/Número de documento y Bodega Origen ',"Completar encabezado")
		   //Help( ,, 'Help',, 'Uno de los campos del encabezado no esta diligenciado.' +;
		   //	CRLF + 'Favor revise, Serie o Número de documento y Almacen Origen ', 1, 0 )
		   lRet := .F.
		EndIf
	ElseIf nOperation==MODEL_OPERATION_INSERT .AND. !INCLUI
		lRet := .F.
	ElseIf nOperation==MODEL_OPERATION_UPDATE .and. cAcao=="SETVALUE" .and. (cCAMPO=="ZY2_UNORG" .OR. cCAMPO=="ZY2_CANTO" .OR. cCAMPO=="ZY2_CANTD") // .OR. cCAMPO=="ZY2_UNDES" 
		   oModelZY2:SetValue("LEGENDA",;
					u_getImg(u_SemaGrid(oModelZY2:GetValue("ZY2_UNORG"),;
										oModelZY2:GetValue("ZY2_UNORG"),;
										oModelZY2:GetValue("ZY2_CANTO"),;
										oModelZY2:GetValue("ZY2_CANTD"))))    // u_getImg(u_SemaGrid(oModelZY2:GetValue("ZY2_UNORG"),oModelZY2:GetValue("ZY2_UNDES"),oModelZY2:GetValue("ZY2_CANTO"),oModelZY2:GetValue("ZY2_CANTD"))))
	EndIf
Return lRet 
/*
+-------------------------------------------------------------------------------------------------------------------+
| Programa  #  CreaTrigger|Autor  | Axel Diaz        |Fecha |  10/12/2019   										|
+-------------------------------------------------------------------------------------------------------------------+
| Desc.     #                                                              											|
--------------------------------------------------------------------------------------------------------------------|
|           # Nome	Tipo		Descripcion											Default	Obrigatorio	Referï¿½ncia  |
|           #-------------------------------------------------------------------------------------------------------|
|           # cDom	Caracteres	Campo Dominio													X	                |
|           # cCDom	Caracteres	Campo de Contradominio											X	                |
|           # cRegra	Caracteres	Regra de Preenchimento										X	                |
|           # lSeek	Lï¿½gico		Se posicionara ou nao antes da execucao do gatilhos		.F.		                    |
|           # cAlias	Caracteres	Alias da tabela a ser posicionada							X	                |
|           # nOrdem	Numï¿½rico	Ordem da tabela a ser posicionada					0							|
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
| Programa  # BTNPANELDER | Autor |Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #                                                               |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # COLOCA EL MENU DERECHO EN EL GRIP DE LA TRANSFRENCIA          |
+---------------------------------------------------------------------------+
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

	oTButton1 := TButton():New( 010, 005, " "  		,oPanel,{||U_CodBarrLee(oModel,oView)}	, 55,20,,,.F.,.T.,.F.,,.F.,{|| IIF((!EMPTY(M->ZX2_SERIE) .AND. !EMPTY(M->ZX2_ALMORI).AND. !lLegaliza),.T.,.F.)      }	,,.F. )   
	oTButton2 := TButton():New( 040, 005, cPNGLEGAL	,oPanel,{||U_LeyenGrd()}				, 55,20,,,.F.,.T.,.F.,,.F.,{||.T.}																						,,.F. )   

	oTButton1:SetCss(cCSSCBar)

Return NIL
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
User Function LeySemaFo()
	Local oModel 	:= FWModelActive()
	Local oView		:= FWViewActive()
	Local cImg 		:= "br_amarelo_ocean.bmp"
	Local cTpMovSF
    If oModel:GetID() == "ACM001" .And. oModel:IsActive()
        cTpMovSF := oModel:GetValue("DETAILZY2","ZY2_TPMOV")
        cImg := u_getImg(cTpMovSF)
        oModel:SetValue("DETAILZY2","LEYENDA",cImg)
        oView:Refresh()
     EndIf
Return cImg
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
User Function MVC011InitPad()
	Local cImg := GRIS
    If !INCLUI
        cImg := u_getImg(ZY2->ZY2_TPMOV)
    EndIf
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
User Function MVC011Dif()
	Local nDif := 0
    If !INCLUI .AND. TYPE("ZY2_CANTO")!='U'.AND. TYPE("ZY2_CANTD")!='U'
        nDif:= (ZY2_CANTO)-(ZY2_CANTD)
    EndIf
Return nDif
/*
+---------------------------------------------------------------------------+
| Programa  #  MVC011DES       |Autor  | Axel Diaz      |Fecha |  10/12/2020|
+---------------------------------------------------------------------------+
| Desc.     #  Función derivada FWFormModelStruct del modelo para DESCRIOCIO|
|           #  deL PRODUCTO                                                |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function MVC011Des()
	Local cDescri := ""
    If !INCLUI .AND. TYPE("ZY2_CODPRO")!='U'
        cDescri:=POSICIONE('SB1',1,xfilial('SB1')+ZY2_CODPRO,'B1_DESC')
    EndIf
Return cDescri
/*
+---------------------------------------------------------------------------+
| Programa  #  ACM001Delet     |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función para borrar registo                                  |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function ACM001Delet()
	Local oModel	:= FWLoadModel('ACM001')
	Local lRet	:= .F.
	If oModel:Activate(.T.)
		If oModel:GetValue("ZX2MASTER","ZX2_ESTADO")=="1"
			FWExecView("Eliminar Registro",'VIEWDEF.ACM001',MODEL_OPERATION_DELETE,,{|| .T.})
			lRet	:= .T.
		Else
			Help( ,, 'No se puede eliminar',, "Este registo no puede ser eliminado, solo los documentos de salida sin registro de entrada pueden ser eliminados", 1, 0)  
		EndIf
    Else
        Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0)
    EndIf
Return lRet

/*
+---------------------------------------------------------------------------+
| Programa  #  ACM001Legal     |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función para borrar registo                                  |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function ACM001Legal()
	Local oModel	:= FWLoadModel('ACM001')
	Local lRet	:= .F.
	Local aButtons := {}
	lLegaliza:= .T.

	If oModel:Activate(.T.)
		If oModel:GetValue("ZX2MASTER","ZX2_ESTADO")==ESTADO_NARANJA .OR. oModel:GetValue("ZX2MASTER","ZX2_ESTADO")==ESTADO_AMARILLO
			aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"LEGALIZAR"},{.T.,"CANCELAR"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}
			FWExecView("Legalizar Documento",'VIEWDEF.ACM001',MODEL_OPERATION_UPDATE,,{|| U_ACM010(oModel)}, , ,aButtons )
			lRet	:= .T.
		Else
			Help( ,, 'No se puede legalizar',, "Este registo no puede ser legalizado, solo los documentos con estado AMARILLO o NARANJA pueden ser seleccionados", 1, 0)  
		EndIf
    Else
        Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0)
    EndIf
    lLegaliza:= .F.
Return lRet

/*
+---------------------------------------------------------------------------+
| Programa  #   fFilAcm1       |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función que muestra grupo de preguntas al ingresar           |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
Static Function fFilAcm1(cFiltro)
Local cPerg := "ACM0011B"
u_AcmSX1(cPerg)			// Inicializa SX1 para preguntas	
If Pergunte(cPerg)
 	cFiltro := "ZX2->ZX2_DTDIGI >='"+DTOS(MV_PAR01)+"' .AND. "
 	cFiltro += "ZX2->ZX2_DTDIGI <='"+DTOS(MV_PAR02)+"' .AND. "
 	cFiltro += "ZX2->ZX2_SERIE >='"+MV_PAR03+"' .AND. "
 	cFiltro += "ZX2->ZX2_SERIE <='"+MV_PAR04+"' .AND. "
 	cFiltro += "ZX2->ZX2_DOC >='"+MV_PAR05+"' .AND. "
 	cFiltro += "ZX2->ZX2_DOC <='"+MV_PAR06+"' .AND. "
 	cFiltro += "ZX2->ZX2_SERIE2 >='"+MV_PAR07+"' .AND. "
 	cFiltro += "ZX2->ZX2_SERIE2 <='"+MV_PAR08+"' .AND. "
 	cFiltro += "ZX2->ZX2_DOC2 >='"+MV_PAR09+"' .AND. "
 	cFiltro += "ZX2->ZX2_DOC2 <='"+MV_PAR10+"'"
 	Return ()
Else
	cFiltro := ""
	Return ()
EndIf	
/*
+---------------------------------------------------------------------------+
| Programa  #   AcmVer       |Autor  | Axel Diaz      |Fecha |  10/12/2019|
+---------------------------------------------------------------------------+
| Desc.     #  Función para visuilizas con dobleclic				           |
|           #                                                               |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
Static Function AcmVer()
	Local oModel	:= FWLoadModel('ACM001')
	Local lRet	:= .F.
	If oModel:Activate(.T.)
			FWExecView("Ver documento",'VIEWDEF.ACM001',MODEL_OPERATION_VIEW,,,,,)
	Else
        Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0)   
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
User Function ACMEntrada()
	Local oModel	:= FWLoadModel('ACM001')
	Local lRet	:= .F.
	lLegaliza	:= .F.
	If oModel:Activate(.T.)
			FWExecView("Registrar Ingreso",'VIEWDEF.ACM001',MODEL_OPERATION_UPDATE,,{|| .T.})
			lRet := .T.
		Else
			Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0) 
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
User Function ACMSalida()
	Local oModel	:= FWLoadModel('ACM001')
	Local lRet	:= .F.
	lLegaliza	:= .F.
	
	If oModel:Activate(.T.)
			If oModel:GetValue("ZX2MASTER","ZX2_ESTADO")==ESTADO_BLANCO
				lModiSal	:= .T.
				cDocModi	:= oModel:GetValue("ZX2MASTER","ZX2_DOC" )
				FWExecView("Modifica Salida",'VIEWDEF.ACM001',MODEL_OPERATION_UPDATE,,{|| .T.})
				lModiSal	:= .F.
				lRet := .T.
			Else
				cDocModi	:= ""
				Help( ,, 'HELP',, "Este documento ya tiene registro de entrada, ya no puede ser modificado", 1, 0) 
			EndIF
		Else
			Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0) 
	EndIf
Return lRet



