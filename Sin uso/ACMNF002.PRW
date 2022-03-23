#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'AcmeDef.ch'
/*/{Protheus.doc} ACMNF002
description
@type function
@version 
@author Axel Diaz
@since 23/5/2020
@return return_type, return_description
/*/
USER FUNCTION ACMNF002
	Local oBrowse
	Local aArea			:= GetArea()
	Local cFiltro		:= ""
    Local aCampos		:= {}
	Private aRotina		:= MenuDef()

	cFiltro		:=fFilAcm1()
	If EMPTY(cFiltro)
		Return
	EndIf

                //   cCampo         ,cTitulo            ,nArrData,cPicture,nAlign,nSize,nDecimal, ldetalle)
//	AAdd( aCampos,{ "F2_XAUDIT"     ,"Legalizada?"		,01     ,""       ,1     ,TamSX3("F2_XAUDIT")[1]	,0,.F.	} )
	AAdd( aCampos,{ "F2_SERIE"      ,"Serie"			,02     ,""       ,1     ,TamSX3("F2_SERIE")[1]	    ,0,.F.	} )
	AAdd( aCampos,{ "F2_DOC"        ,"Num.Documento"	,03     ,""       ,1     ,TamSX3("F2_DOC")[1]	    ,0,.F.	} )
	AAdd( aCampos,{ "F2_CLIENTE"    ,"Cod.Cliente"		,04     ,""       ,1     ,TamSX3("F2_CLIENTE")[1]	,0,.F.	} )
	AAdd( aCampos,{ "F2_LOJA"       ,"Tienda Clt."		,05     ,""       ,1     ,TamSX3("F2_LOJA")[1]	    ,0,.F.	} )
	AAdd( aCampos,{ "POSICIONE('SA1',1,xfilial('SA1')+F2_CLIENTE+F2_LOJA,'A1_NOME')"       ,"Nombre"	        ,06     ,""       ,1     ,TamSX3("A1_NOME")[1]	    ,0,.F.	} )
	AAdd( aCampos,{ "F2_DTDIGIT"    ,"Fch.Digitació"	,07     ,""       ,1     ,TamSX3("F2_DTDIGIT")[1]	,0,.F.	} )
	AAdd( aCampos,{ "F2_EMISSAO"    ,"Fch.Emisión"		,08     ,""       ,1     ,TamSX3("F2_EMISSAO")[1]	,0,.F.	} )
	AAdd( aCampos,{ "F2_XLEGALI"    ,"Fch.Legaliz"		,09     ,""       ,1     ,TamSX3("F2_XLEGALI")[1]	,0,.F.	} )
	AAdd( aCampos,{ "F2_XTIME"      ,"Hora Legali"		,10     ,""       ,1     ,TamSX3("F2_XTIME")[1]	    ,0,.F.	} )
	AAdd( aCampos,{ "F2_XRESPON"    ,"Responsable"		,11     ,""       ,1     ,TamSX3("F2_XRESPON")[1]	,0,.F.	} )

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("SF2")
	oBrowse:SetDescription(cTituloNF)
	oBrowse:AddLegend("F2_XAUDIT <> ' '"	,VERDE, "Legalizada")
	oBrowse:AddLegend("F2_XAUDIT == ' '"	,ROJO	, "No Legalizada")
	For nX:=1 to Len (aCampos)
		oBrowse:SetColumns(MONCOL(aCampos[nX]))
	Next nX	
	oBrowse:SetFixedBrowse(.F.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetFilterDefault(cFiltro)
	oBrowse:DisableDetails()
	oBrowse:SetLocate()
	oBrowse:SetAmbiente(.F.)  // Habilita a utilizaï¿½ï¿½o da funcionalidade Walk-Thru no Browse
	oBrowse:SetWalkThru(.F.)  // Habilita a utilizaï¿½ï¿½o da funcionalidade Walk-Thru no Browse
	oBrowse:Refresh(.T.)
	oBrowse:Activate()
	oBrowse:Destroy()
	RestArea(aArea)
Return

STATIC FUNCTION MONCOL( aCampos )
	Local cCampo  := aCampos[1]
	Local cTitCamp:= aCampos[2]
	Local nArrData:= aCampos[3]
	Local cPicture:= aCampos[4]
	Local nAlign  := aCampos[5]
	Local nSize   := aCampos[6]
	Local nDecimal:= aCampos[7]
	Local ldetalle:= aCampos[8]
	Local aColumn
	Local bData 	:= {||}
	Default nAlign 	:= 1
	Default nSize 	:= 20
	Default nDecimal:= 0
	Default nArrData:= 0

	If nArrData > 0
		bData := &("{||" + cCampo +"}") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf

	/* Array da coluna
	[n][01] Título da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Máscara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edição
	[n][09] Code-Block de validação da coluna após a edição
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execução do duplo clique
	[n][12] Variável a ser utilizada na edição (ReadVar)
	[n][13] Code-Block de execução do clique no header
	[n][14] Indica se a coluna está deletada
	[n][15] Indica se a coluna será exibida nos detalhes do Browse
	[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
	*/
	/*              01   02   03   04      05      06   07      08    09    10   11     12    13    14   15 16  */
	aColumn := {cTitCamp,bData,  ,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,ldetalle, {}}
Return {aColumn}

/*/{Protheus.doc} fFilAcm1
description
@type function
@version 
@author Axel Diaz
@since 23/5/2020
@return return_type, return_description
/*/
Static Function fFilAcm1()
Local cPerg		:= "ACMNFPG1"
Local cFiltro	:=""
AcmSX1(cPerg)			// Inicializa SX1 para preguntas
If Pergunte(cPerg)
    cFiltro := " (F2_ESPECIE='RFN ' .OR. F2_ESPECIE='RTF ' .OR. F2_ESPECIE='NF  ' ) .AND. "
 	cFiltro += " SF2->F2_EMISSAO >='"+ DTOC(MV_PAR02) +		"' .AND. "
 	cFiltro += " SF2->F2_EMISSAO <='"+ DTOC(MV_PAR03) +		"' .AND. "
 	cFiltro += " SF2->F2_SERIE >='"	+ MV_PAR04 +			"' .AND. "
 	cFiltro += " SF2->F2_SERIE <='"	+ MV_PAR05 +			"' .AND. "
 	cFiltro += " SF2->F2_DOC >='"	+ MV_PAR06 +			"' .AND. "
 	cFiltro += " SF2->F2_DOC <='"	+ MV_PAR07 +			"' .AND. "
 	cFiltro += " SF2->F2_CLIENTE >='"+ MV_PAR08 +			"' .AND. "
 	cFiltro += " SF2->F2_CLIENTE <='"+ MV_PAR09 +			"' .AND. "
 	cFiltro += " SF2->F2_LOJA >='"	+ MV_PAR10 +			"' .AND. "
 	cFiltro += " SF2->F2_LOJA <='"	+ MV_PAR11 +			"' "
 	If MV_PAR01==1
		cFiltro += " .AND. SF2->F2_XAUDIT <>' ' "
	ElseIf MV_PAR01==2
		cFiltro += " .AND. SF2->F2_XAUDIT ==' ' "
	EndIf
EndIf
Return cFiltro
/*
Rutina: AcmSX1
Funcion: Crear el grupo de preguntas en la SX1 cuando no existe
{Protheus.doc} AcmSX1
description
@type function
@version 
@author Axel Diaz
@since 23/5/2020
@param cPregunta, character, param_description
@return return_type, return_description
/*/
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
	dbSeek("F2_DOC");nLarDoc:=SX3->X3_TAMANHO
 	dbSeek("F2_SERIE");nLarSer:=SX3->X3_TAMANHO
 	dbSeek("F2_LOJA");nLarLoj:=SX3->X3_TAMANHO
 	dbSeek("F2_CLIENTE");nLarClt:=SX3->X3_TAMANHO	
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

/*/{Protheus.doc} MenuDef
description
@type function
@version 
@author Axel Diaz
@since 22/5/2020
@return return_type, return_description
/*/
Static Function MenuDef()
	Local aRotine 		:= {}
	ADD OPTION aRotine  TITLE 'Legalizar' 						ACTION 'u_ACMNFLEGA'		OPERATION MODEL_OPERATION_UPDATE 	ACCESS 0 //OPERATION 4
	ADD OPTION aRotine  TITLE 'Visualizar de Documento' 		ACTION 'VIEWDEF.ACMNF001'	OPERATION MODEL_OPERATION_VIEW 		ACCESS 0 //OPERATION 1
	ADD OPTION aRotine  TITLE 'Leyenda' 						ACTION 'LeyeBrw2' 		    OPERATION 9 						ACCESS 0 //OPERATION 9
	ADD OPTION aRotine  TITLE 'Imprimir Despacho Legalizado'	ACTION 'VIEWDEF.ACMNF001' 	OPERATION 9 						ACCESS 0 //OPERATION 9
Return aRotine

/*/{Protheus.doc} LeyeBrw2
description
@type function
@version 
@author Axel Diaz
@since 23/5/2020
@return return_type, return_description
/*/
STATIC Function LeyeBrw2()
     Local aLegenda := {}
     aAdd( aLegenda, { VERDE		,  	EstadoNFVerde })
     aAdd( aLegenda, { ROJO			,	EstadoNFRojo  })
     BrwLegenda( "Leyenda", "Leyenda de las lineas", aLegenda )
Return Nil

/*/{Protheus.doc} ModelDef
description
@type function
@version
@author Axel Diaz
@since 22/5/2020
@return return_type, return_description
/*/
Static Function ModelDef()
	Local aZY6Rel		:= {}
	Local aTriggeDT		:= {}
	Local oStHeader 	:= GMSHead() 				// FWFormStruct( 1, 'SF2' )
	Local oStDetail 	:= GMSDetail()				// FWFormStruct( 1, 'SF2' )
	Local nAtual		:= 0
	Local oModel // Modelo de datos construído

	oModel := MPFormModel():New( 'ACMNF01M' , /*<bPre >*/{ | oModel | PreCommit( oModel ) },/*<bPost >*/{ | oModel | PosCommit( oModel ) },/*<bCommit > *//*Commit(oMdl)*/ , /*<bCancel >*/ )  

	aAdd(aTriggeDT, CreaTrigger("SD2_CANTSL" ,"D2_TPMOV"	,"U_SemaGrid(M->D2_UM,M->D2_UM,M->D2_QUANT,M->D2_CANTSL) "	,.F.,''	,0	,''	,''	,'001'))	
	aAdd(aTriggeDT, CreaTrigger("D2_CANTSL" ,"LEYENDA"		,"U_LeySemaNF(M->D2_UM,M->D2_UM,M->D2_QUANT,M->D2_CANTSL)"	,.F.,''	,0	,''	,'' ,'002'))
	aAdd(aTriggeDT, CreaTrigger("D2_CANTSL" ,"DIFERENC"	,"ABS((M->D2_QUANT)-(M->D2_CANTSL))"							,.F.,''	,0	,''	,'' ,'003'))

    For nAtual := 1 To Len(aTriggeDT)
        oStDetail:AddTrigger(   aTriggeDT[nAtual][01],; //Campo Origen
                            	aTriggeDT[nAtual][02],; //Campo Destino
                            	aTriggeDT[nAtual][03],; //Bloque de código de validacion que ejecutara el gatillo
                            	aTriggeDT[nAtual][04])  //Bloque de código de execucion
    Next

	oModel:AddFields('SF2MASTER',/*cOwner*/, oStHeader )
	oModel:AddGrid('SD2DETAIL','SF2MASTER', oStDetail )

	aAdd(aSD2Rel, {'D2_FILIAL'	, 'xFilial( "SD2" )'	})
	aAdd(aSD2Rel, {'D2_DOC'	    , 'F2_DOC'				})
	aAdd(aSD2Rel, {'D2_SERIE' 	, 'F2_SERIE'			})
	aAdd(aSD2Rel, {'D2_CLIENTE' , 'F2_CLIENTE'			})
	aAdd(aSD2Rel, {'D2_LOJA' 	, 'F2_LOJA'			})

	oModel:SetRelation('SD2DETAIL', aSD2Rel, SD2->(IndexKey(1)))
	oModel:SetPrimaryKey({})
	oModel:SetDescription("Legalización Factura/Remisión Acme Leon")
	oModel:GetModel('SF2MASTER'):SetDescription('Factura/Remisión de Salida')
	oModel:GetModel('SD2DETAIL'):SetDescription('Detalles del Documento')
Return oModel

/*/{Protheus.doc} ViewDef
description
@type function
@version 
@author Axel Diaz
@since 22/5/2020
@return return_type, return_description
/*/
Static Function ViewDef()
	Local oModel := FWLoadModel( 'ACMNF001' )
	Local oStHeader := GVSHead()
	Local oStDetail	:= GVSDetail()
	Local oView
	oView := FWFormView():New()
	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZX6', oStHeader, 'ZX6MASTER' )
	oView:AddGrid(  'VIEW_SD2', oStDetail, 'SD2DETAIL' )
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',40)
	oView:CreateHorizontalBox('GRID',60)

	oView:CreateVerticalBox( 'GRIDIZQ', 90, 'GRID' )
	oView:CreateVerticalBox( 'GRIDDER', 10, 'GRID' )

	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZX6','CABEC')
	oView:SetOwnerView('VIEW_SD2','GRIDIZQ')

	//Habilitando título
	oView:EnableTitleView('VIEW_ZX6','Factura/Remisión de Salida')
	oView:EnableTitleView('VIEW_SD2','Detalles del Documento')

	oView:AddOtherObject("PANEL", {|oPanel| BTNPANELDER(oPanel)})
	oView:SetOwnerView("PANEL",'GRIDDER')

	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})

	oView:SetNoDeleteLine('VIEW_SD2')
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
	
	oStruct:AddTable('ZX6',{'ZX6_SERIE','ZX2_DOC','ZX6_DTDIGI', 'ZX6_CLIENT','ZX6_LOJA','ZX6_XAUDIT',;
	 						'ZX6_EMISSA', 'ZX6_NOME', 'ZX2_LEGALI', 'ZX2_TIME','ZX2_RESPON'},"Encabezado")

	aCampo:=u_SX3Datos('ZX6_SERIE');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_DOC');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_CLIENT');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_LOJA');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_EMISSA');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_DTDIGI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_NOME');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_LEGALI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_TIME');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_RESPON');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('ZX6_XAUDIT');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )

	oStruct:SetProperty('ZX6_SERIE'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZX6_DOC'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZX6_CLIENT'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZX6_LOJA'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZX6_NOME'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZX6_EMISSA'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZX6_DTDIGI'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZX6_LEGALI'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZX6_TIME'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZX6_RESPON'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZX6_XAUDIT'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
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

	aCampo:=u_SX3Datos('ZY6_ITEM');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '02',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY6_COD');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '03',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY6_DESCRI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '04',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY6_UM');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '05',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY6_SEGUM');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '06',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY6_QUANT');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '07',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY6_LOCAL');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '08',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZY6_CANTSL');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '09',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)

										oStruct:AddField(/*cIdField*/ 'LEYENDA',/*cOrdem*/ '01', /*cTitulo*/ '#'		, /*cDescric*/ 'Leyenda'								,/*aHelp*/,/*cType*/ 'Get',/*cPicture*/ '@BMP',,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )
										oStruct:AddField(/*cIdField*/'DIFERENC',/*cOrdem*/ '10',/*cTitulo*/'Diferencia' , /*cDescric*/ 'Diferencia entre Factura y Legalización',/*aHelp*/,/*cType*/ 'N'  ,/*cPicture*/"@9999",,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )

	oStruct:SetProperty('ZY6_ITEM', 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZY6_COD', 		MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZY6_DESCRI', 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZY6_UM', 		MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZY6_SEGUM'	, 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZY6_QUANT', 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZY6_LOCAL', 	MVC_VIEW_CANCHANGE,.F.)
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

	aCampo:=u_SX3Datos('ZX6_SERIE');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '01',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX6_DOC');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '02',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX6_CLIENT');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '03',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX6_LOJA');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '04',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX6_NOME');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '05',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX6_EMISSA');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '06',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('ZX6_DTDIGI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '07',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('ZX6_LEGALI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '08',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('ZX6_RESPON');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '09',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('ZX6_TIME');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '10',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)

//	oStruct:SetProperty('ZX6_LEGALI', 	MVC_VIEW_CANCHANGE,.F.)
//	oStruct:SetProperty('ZX6_TIME'	, 	MVC_VIEW_CANCHANGE,.F.)
//	oStruct:SetProperty('ZX6_RESPON', 	MVC_VIEW_CANCHANGE,.F.)

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

	oStruct:AddTable('ZY6',{'ZY6_ITEM','ZY6_COD','ZY6_SEGUM','ZY6_UM','ZY6_QUANT','ZY6_CLIENT','ZY6_LOJA','ZY6_DOC','ZY6_SERIE',;
							'ZY6_NUMSEQ','ZY6_DESCRI','ZY6_LOCAL','ZY6_TPMOV','ZY6_CANTSL', 'LEYENDA', 'DIFERENC'},"Detalles")		

	//      									AddField(<cTitulo >	,<cTooltip >,<cIdField >,<cTipo >	, <nTamanho >	, [ nDecimal ]	, [ bValid ], [ bWhen ]	, [ aValues ]	, [ lObrigat ]	, [ bInit ]	, <lKey >	, [ lNoUpd ], [ lVirtual ]	, [ cValid ])
	aCampo:=u_SX3Datos('ZY6_ITEM')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_COD')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_SEGUM')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_UM')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_QUANT')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_CLIENT');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_LOJA')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_DOC')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_SERIE')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_NUMSEQ');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_LOCAL');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_TPMOV');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_CANTSL');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('ZY6_DESCRI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )

										oStruct:AddField('Leyenda'	,'Leyenda'	,'LEYENDA' 	, 'C'		,20				, 0			,,,{}, .F.		, FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVCNF1InitPad()")	, .F., .F., .T., , ) 
										oStruct:AddField('Diferenc'	,'Diferenc'	,'DIFERENC'	, 'N'		,4				, 0			,,,{}, .F.		, FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVCNF1Dif()")		, .F., .F., .T., , ) 

	oStruct:SetProperty('ZY6_ITEM'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_COD'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_SEGUM'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_UM'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_QUANT'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_CLIENT'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_LOJA'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_DOC'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_SERIE'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_NUMSEQ'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_LOCAL'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('ZY6_TPMOV'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZY6_CANTSL'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('ZY6_DESCRI'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))

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
