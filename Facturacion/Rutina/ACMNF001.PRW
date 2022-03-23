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
USER FUNCTION ACMNF001
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
	//AAdd( aCampos,{ "F2_XNOME"      ,"Nombre"	        ,06     ,""       ,1     ,TamSX3("A1_NOME")[1]	    ,0,.F.	} )
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
	POSICIONE('SA1',1,xfilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_NOME')
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
	ADD OPTION aRotine  TITLE 'Leyenda' 						ACTION 'U_LeyeBrw2' 		OPERATION 9 						ACCESS 0 //OPERATION 9
	ADD OPTION aRotine  TITLE 'Imprimir Fact/Remi Legalizado'	ACTION 'VIEWDEF.ACMNF001' 	OPERATION 9 						ACCESS 0 //OPERATION 9
Return aRotine

/*/{Protheus.doc} LeyeBrw2
description
@type function
@version 
@author Axel Diaz
@since 23/5/2020
@return return_type, return_description
/*/
USER Function LeyeBrw2()
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
	Local aSD2Rel		:= {}
	Local aTriggeDT		:= {}
	Local oStHeader 	:= GMSHead() 				// FWFormStruct( 1, 'SF2' )
	Local oStDetail 	:= GMSDetail()				// FWFormStruct( 1, 'SF2' )
	Local nAtual		:= 0
	Local oModel // Modelo de datos construído

	oModel := MPFormModel():New( 'ACMNF01M' , /*<bPre >*/{ | oModel | PreCommit( oModel ) },/*<bPost >*/{ | oModel | PosCommit( oModel ) },/*<bCommit > *//*Commit(oMdl)*/ , /*<bCancel >*/ )  

	aAdd(aTriggeDT, CreaTrigger("D2_XCANTSL" ,"D2_XTPMOV"	,"U_SemaGrid(M->D2_UM,M->D2_UM,M->D2_QUANT,M->D2_XCANTSL) "	,.F.,''	,0	,''	,''	,'001'))	
	aAdd(aTriggeDT, CreaTrigger("D2_XCANTSL" ,"LEYENDA"		,"U_LeySemaNF(M->D2_UM,M->D2_UM,M->D2_QUANT,M->D2_XCANTSL)"	,.F.,''	,0	,''	,'' ,'002'))
	aAdd(aTriggeDT, CreaTrigger("D2_XCANTSL" ,"DIFERENC"	,"ABS((M->D2_QUANT)-(M->D2_XCANTSL))"						,.F.,''	,0	,''	,'' ,'003'))

    For nAtual := 1 To Len(aTriggeDT)
        oStDetail:AddTrigger(   aTriggeDT[nAtual][01],; //Campo Origen
                            	aTriggeDT[nAtual][02],; //Campo Destino
                            	aTriggeDT[nAtual][03],; //Bloque de código de validacion que ejecutara el gatillo
                            	aTriggeDT[nAtual][04])  //Bloque de código de execucion
    Next

	oModel:AddFields('SF2MASTER',/*cOwner*/, oStHeader )
	oModel:AddGrid('SD2DETAIL','SF2MASTER', oStDetail, ;
				/*bLinePre*/  { |oModelGrid, nLine ,cAction,cField| ACMLPRE(oModelGrid, nLine, cAction, cField) }, ;
				/*bLinePost*/ { |oModelGrid, nLine ,cAction,cField| ACMLPOS(oModelGrid, nLine, cAction, cField) }, ;
				/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)

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
	oView:AddField( 'VIEW_SF2', oStHeader, 'SF2MASTER' )
	oView:AddGrid(  'VIEW_SD2', oStDetail, 'SD2DETAIL' )
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',40)
	oView:CreateHorizontalBox('GRID',60)

	oView:CreateVerticalBox( 'GRIDIZQ', 90, 'GRID' )
	oView:CreateVerticalBox( 'GRIDDER', 10, 'GRID' )

	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_SF2','CABEC')
	oView:SetOwnerView('VIEW_SD2','GRIDIZQ')

	//Habilitando título
	oView:EnableTitleView('VIEW_SF2','Factura/Remisión de Salida')
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

	oStruct:AddTable('SF2',{'F2_SERIE','F2_DOC','F2_DTDIGIT', 'F2_CLIENTE','F2_LOJA', 'F2_XAUDIT',;
	 						'F2_EMISSAO', 'F2_XLEGALI', 'F2_XTIME','F2_XRESPON'},"Encabezado")

	aCampo:=u_SX3Datos('F2_SERIE');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('F2_DOC');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('F2_CLIENTE');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('F2_LOJA');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
										//oStruct:AddField(/*cIdField*/ 'F2_XNOME',/*cOrdem*/ '04', /*cTitulo*/ 'Nombre'		, /*cDescric*/ 'Nombre'							,/*aHelp*/,/*cType*/ ,/*cPicture*/,,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )

	aCampo:=u_SX3Datos('F2_EMISSAO');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('F2_DTDIGIT');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )

	aCampo:=u_SX3Datos('F2_XLEGALI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('F2_XTIME');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('F2_XRESPON');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )
	aCampo:=u_SX3Datos('F2_XAUDIT');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]	, aCampo[5]	,,,{}, aCampo[19], , .F., .F., .F., , )

	oStruct:SetProperty('F2_SERIE'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('F2_DOC'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('F2_CLIENTE'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('F2_LOJA'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	//oStruct:SetProperty('F2_XNOME'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('F2_EMISSAO'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('F2_DTDIGIT'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('F2_XLEGALI'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('F2_XTIME'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('F2_XRESPON'	, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('F2_XAUDIT'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	//oStruct:SetProperty('F2_XNOME'		, MODEL_FIELD_INIT,{|| posicione('SA1',1,xFilial('SA1')+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_NOME')})
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

	aCampo:=u_SX3Datos('D2_ITEM');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '02',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('D2_COD');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '03',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('D2_XDESCRI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '04',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('D2_UM');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '05',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('D2_SEGUM');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '06',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('D2_QUANT');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '07',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('D2_LOCAL');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '08',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('D2_XCANTSL');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '09',/*cTitulo*/ aCampo[6]	,/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8]	,/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)

										oStruct:AddField(/*cIdField*/ 'LEYENDA',/*cOrdem*/ '01', /*cTitulo*/ '#'		, /*cDescric*/ 'Leyenda'								,/*aHelp*/,/*cType*/ 'Get',/*cPicture*/ '@BMP',,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )
										oStruct:AddField(/*cIdField*/'DIFERENC',/*cOrdem*/ '10',/*cTitulo*/'Diferencia' , /*cDescric*/ 'Diferencia entre Factura y Legalización',/*aHelp*/,/*cType*/ 'N'  ,/*cPicture*/"@9999",,,/*lCanChange*/ .F.,,,,,,/*lVirtual*/.T.,, )
	oStruct:SetProperty('D2_ITEM', 		MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('D2_COD', 		MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('D2_XDESCRI', 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('D2_UM', 		MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('D2_SEGUM'	, 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('D2_QUANT', 	MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('D2_LOCAL', 	MVC_VIEW_CANCHANGE,.F.)
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

	aCampo:=u_SX3Datos('F2_SERIE');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '01',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('F2_DOC');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '02',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('F2_CLIENTE');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '03',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('F2_LOJA');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '04',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('F2_XNOME');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '05',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('F2_EMISSAO');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '06',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
	aCampo:=u_SX3Datos('F2_DTDIGIT');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '07',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('F2_XLEGALI');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '08',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('F2_XRESPON');	oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '09',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)
//	aCampo:=u_SX3Datos('F2_XTIME');		oStruct:AddField(/*cIdField*/ aCampo[2],/*cOrdem*/ '10',/*cTitulo*/ aCampo[6],/*cDescric*/ aCampo[7],/*aHelp*/ {},/*cType*/ aCampo[3],/*cPicture*/ aCampo[8],/*bPictVar*/,aCampo[12]/*cLookUp*/, /*lCanChange*/ aCampo[17],/*cFolder*/,/*cGroup*/,/*aComboValues*/,/*nMaxLenCombo*/,/*cIniBrow*/,/*lVirtual*/ .F. ,/*cPictVar*/,/*lInsertLine*/,/*nWidth*/)

//	oStruct:SetProperty('F2_XLEGALI', 	MVC_VIEW_CANCHANGE,.F.)
//	oStruct:SetProperty('F2_XTIME'	, 	MVC_VIEW_CANCHANGE,.F.)
//	oStruct:SetProperty('F2_XRESPON', 	MVC_VIEW_CANCHANGE,.F.)
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

	oStruct:AddTable('SD2',{'D2_ITEM','D2_COD','D2_SEGUM','D2_UM','D2_QUANT','D2_CLIENTE','D2_LOJA','D2_DOC','D2_SERIE',;
							'D2_NUMSEQ','D2_XDESCRI','D2_LOCAL','D2_XTPMOV','D2_XCANTSL', 'LEYENDA', 'DIFERENC'},"Detalles")

	//      									AddField(<cTitulo >	,<cTooltip >,<cIdField >,<cTipo >	, <nTamanho >	, [ nDecimal ]	, [ bValid ], [ bWhen ]	, [ aValues ]	, [ lObrigat ]	, [ bInit ]	, <lKey >	, [ lNoUpd ], [ lVirtual ]	, [ cValid ])
	aCampo:=u_SX3Datos('D2_ITEM')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_COD')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_SEGUM')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_UM')	;		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_QUANT')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_CLIENTE');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_LOJA')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_DOC')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_SERIE')	;	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_NUMSEQ');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_LOCAL');		oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_XTPMOV');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_XCANTSL');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )
	aCampo:=u_SX3Datos('D2_XDESCRI');	oStruct:AddField(aCampo[6]	,aCampo[7]	,aCampo[2]	,aCampo[3]	,aCampo[4]		, aCampo[5]		,			,			,{}				, aCampo[19]	, 			, .F.		, .F.		, .F.			, 			 )

										oStruct:AddField('Leyenda'	,'Leyenda'	,'LEYENDA' 	, 'C'		,20				, 0			,,,{}, .F.		, FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVCNF1InitPad()")	, .F., .F., .T., , ) 
										oStruct:AddField('Diferenc'	,'Diferenc'	,'DIFERENC'	, 'N'		,4				, 0			,,,{}, .F.		, FWBuildFeature( STRUCT_FEATURE_INIPAD, "u_MVCNF1Dif()")		, .F., .F., .T., , ) 

	oStruct:SetProperty('D2_ITEM'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_COD'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_SEGUM'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_UM'				, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_QUANT'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_CLIENTE'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_LOJA'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_DOC'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_SERIE'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_NUMSEQ'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_LOCAL'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))
	oStruct:SetProperty('D2_XTPMOV'			, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('D2_XCANTSL'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.T.'))
	oStruct:SetProperty('D2_XDESCRI'		, MODEL_FIELD_WHEN,		FwBuildFeature(STRUCT_FEATURE_WHEN,  '.F.'))

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
	Local oModelSD2, oModelSF2
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
			aProduc[nI][1]:= BusCodBar(ALLTRIM(aCodBar[nI][1])) //POSICIONE('SB1',5,xFilial("SB1")+SUBSTR(aCodBar[nI][1]+SPACE(nTamBar),1,nTamBar),"B1_COD")
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
		    oModelSF2:= oMdl:GetModel("SF2MASTER")
		    oModelSD2:= oMdl:GetModel("SD2DETAIL")
	     	lInsert:=.T.
	     	lPaso:= .F.
	     	For nI:=1 to len(aProduc)
	     		incproc("Cotejando...")
	     		If aProduc[nI][2]>0
		     		For nJ:=1 to (oModelSD2:Length()) 
		     			oModelSD2:GoLine( nJ )
		     			If ALLTRIM(oModelSD2:GetValue("D2_COD"))==ALLTRIM(aProduc[nI][1])
		     				lInsert:=.F.
		     				nX:=nJ
		     			EndIf
		     		Next
		     		If lInsert
			     		lPaso:=.T.
			     		lIncAcme:= .T.
						/*/
		     			oModelSD2:AddLine()
		     			oModelSD2:SetValue("D2_COD"		, 	ALLTRIM(aProduc[nI][1]) )
		     			oModelSD2:SetValue("D2_QUANT"	, 	aProduc[nI][2]*(-1)) // Si se agrega Linea, llegaron productos que no pertenecen al Doc de salida
		     			oModelSD2:SetValue("D2_XCANTSL"	, 	aProduc[nI][2]+ oModelSD2:GetValue("D2_XCANTSL") )
		     			oModelSD2:SetValue("LEYENDA"	, 	ROJO )
		     			oModelSD2:SetValue("D2_DESCRI"	,	POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduc[nI][1]),'B1_DESC'))
		     			oModelSD2:SetValue("D2_SEGUM"	,	POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduc[nI][1]),'B1_SEGUM'))
		     			oModelSD2:SetValue("D2_UM"		,	POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduc[nI][1]),'B1_UM'))
		     			oModelSD2:SetValue("DIFERENC"	,	aProduc[nI][2]*(-1))
						/*/
			     		lIncAcme:= .F.
		     		Else
		     			oModelSD2:GoLine( nX )
		     			oModelSD2:UnDeleteLine()
		     			oModelSD2:SetValue("D2_XCANTSL"	, 	aProduc[nI][2]+ oModelSD2:GetValue("D2_XCANTSL") )
		     			oModelSD2:SetValue("DIFERENC"	,	ABS(oModelSD2:GetValue("D2_QUANT")-aProduc[nI][2]))
		     			//#DEFINE TP_MOV_GRIS		"1"	 // Nueva Salida de Material
		     			//#DEFINE TP_MOV_VERDE		"2"	 // Salida y entrada de materia Cohinciden
		     			//#DEFINE TP_MOV_AMARILLO	"3"	 // La cantidad de Salida de Materia es Superior a la entrada
		     			//#DEFINE TP_MOV_ROJO		"4"  // La cantidad de Materia de Entrada es superrio a la de Salida
		     			oModelSD2:SetValue("D2_XTPMOV"	, IIF(oModelSD2:GetValue("D2_QUANT")==oModelSD2:GetValue("D2_XCANTSL"),TP_MOV_VERDE,;
		     													IIF(oModelSD2:GetValue("D2_QUANT")>oModelSD2:GetValue("D2_XCANTSL"),TP_MOV_AMARILLO,;
		     													TP_MOV_ROJO))	)
		     			oModelSD2:SetValue("LEYENDA"	,;
		     					u_getImg(u_SemaGrid(oModelSD2:GetValue("D2_UM"),;
		     										oModelSD2:GetValue("D2_UM"),;
		     										oModelSD2:GetValue("D2_QUANT"),;
		     										oModelSD2:GetValue("D2_XCANTSL");
		     									);
		     								);
		     							)
			     	End
			     	lInsert:=.T.
		     	EndIf
	     	Next
	     	oModelSD2:GoLine( 1 )

		    Retorno := oDlg:End()
		    oModelSD2:GoLine( 1 )
			oModelSD2:SetLine( 1 )
			oView:Refresh()
			If lPaso
				MsgAlert("Algunos productos del pistole no están en el documento a legalizar, por lo tanto no se agregaron")
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
    cImg := u_getImg(SD2->D2_XTPMOV)
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
    If !INCLUI .AND. TYPE("D2_XCANTSL")!='U'
        nDif:= (D2_QUANT)-(D2_XCANTSL)
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
	Local oModelSD2	:= oModel:GetModel('SD2DETAIL')
	Local oModelSF2	:= oModel:GetModel('SF2MASTER')

	For nJ:=1 to (oModelSD2:Length()) 
		oModelSD2:GoLine( nJ )
		If !(oModelSD2:GetValue("D2_XTPMOV")==TP_MOV_VERDE)
			lRet:=.F.
		EndIf
	Next
	If lRet
		oModelSF2:SetValue('F2_XLEGALI'	, dDatabase					)
		oModelSF2:SetValue('F2_XRESPON'	, UsrRetName(RetCodUsr())	)
		oModelSF2:SetValue('F2_XTIME'	, TIME()					)
		oModelSF2:SetValue('F2_XAUDIT'	, '1'						)
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
        cTpMovSF := oModel:GetValue("SD2DETAIL","D2_XTPMOV")
        cImg := u_getImg(cTpMovSF)
        oModel:SetValue("SD2DETAIL","LEYENDA",cImg)
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
	Local oModelSF2	:= oModel:GetModel('SF2MASTER')
	If ALTERA .AND.	oModel:GetValue("SF2MASTER","F2_XAUDIT")=='1'
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
	Local oModelSF2	:= oModel:GetModel('SF2MASTER')
	Local lRet	:= .F.
	If oModel:Activate(.T.)
		If oModel:GetValue("SF2MASTER","F2_XAUDIT")<>'1'
			FWExecView("LEGALIZAR",'VIEWDEF.ACMNF001',MODEL_OPERATION_UPDATE,,{|| .T.})
			lRet := .T.
		Else
			Help(NIL, NIL, "Documento Legalizado",NIL,"El documento seleccionado ya se encuentra Legalizado, no puede modificarse", 1, 0, NIL, NIL, NIL, NIL, NIL,NIL) 
		EndIf	
	Else
		Help( ,, 'HELP',, oModel:GetErrorMessage()[6], 1, 0) 
	EndIf
Return lRet
/*/{Protheus.doc} BusCodBar
description
@type function
@version 
@author Axel Diaz
@since 23/5/2020
@param cCodBar, character, param_description
@return return_type, return_description
/*/
static function BusCodBar(cCodBar)
	Local cQry			:= ""
	Local cB1_Cod		:= ""
	Private cAliasCB	:= GetNextAlias()
	cQry	:= " SELECT B1_COD FROM "+ InitSqlName("SB1") +" SB1"
	cQry	+= " WHERE B1_FILIAL='"+xFilial("SB1")+"' AND D_E_L_E_T_=' ' " 
	cQry	+= " AND B1_CODBAR='"+cCodBar+"' 
	
	dbUseArea(.T.,"TOPCONN", TcGenQry(nil,nil,cQry) ,cAliasCB,.T.,.T.)
	DbSelectArea(cAliasCB)
	(cAliasCB)->(DbGoTop())
	If (cAliasCB)->(!EOF())
		cB1_Cod:=(cAliasCB)->B1_COD
	EndIf
	(cAliasCB)->(dbCloseArea())
Return ""

/*/{Protheus.doc} ACMLPRE
description
@type function
@version 
@author Axel Diaz
@since 23/5/2020
@param oModelGrid, object, param_description
@param nLinha, numeric, param_description
@param cAcao, character, param_description
@param cCampo, character, param_description
@return return_type, return_description
/*/
Static Function ACMLPRE( oModelGrid, nLinha, cAcao, cCampo )
	Local lRet 		:= .T.
	Local oModel 	:= oModelGrid:GetModel()
	Local oModelSD2	:= oModel:GetModel('SD2DETAIL')
	Local oModelSF2	:= oModel:GetModel('SF2MASTER')
	Local nOperation:= oModel:GetOperation()
	// Valida si se puede quietar una linea del Grid  // Otros Valores -> cAcao= "CANSETVALUE" nOperation==MODEL_OPERATION_UPDATE<-Modificar
	If cAcao == 'DELETE' .AND. nOperation == MODEL_OPERATION_UPDATE
		lRet := .F.
		Help( ,, 'Help',, 'No puede eliminar lineas en la factura' +;
					CRLF + 'Linea Número ' + Alltrim( Str( nLinha ) ), 1, 0 )
	EndIf
	If nOperation==MODEL_OPERATION_UPDATE .and. cAcao=="SETVALUE" .and. cCAMPO=="D2_XCANTSL" // .OR. cCAMPO=="ZY2_UNDES" 
		oModelSD2:SetValue("D2_XTPMOV"	, IIF(oModelSD2:GetValue("D2_QUANT")==oModelSD2:GetValue("D2_XCANTSL"),TP_MOV_VERDE,;
										  IIF(oModelSD2:GetValue("D2_QUANT")>oModelSD2:GetValue("D2_XCANTSL"),TP_MOV_AMARILLO,;
										  TP_MOV_ROJO))	)
		oModelSD2:SetValue("LEYENDA"	,;
				u_getImg(u_SemaGrid(oModelSD2:GetValue("D2_UM"),;
									oModelSD2:GetValue("D2_UM"),;
									oModelSD2:GetValue("D2_QUANT"),;
									oModelSD2:GetValue("D2_XCANTSL");
								);
							);
						)
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