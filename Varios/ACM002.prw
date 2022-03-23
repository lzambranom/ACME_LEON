#include "protheus.ch"
#include "fwmvcdef.ch"
#Include 'AcmeDef.ch'
/*
+===========================================================================+
| Programa  #ACM002    |Autor  | Axel Diaz        |Fecha |  10/12/2019      |
+===========================================================================+
| Desc.     #  Modelo de Acme Semaforizacion sin las validciones de usuarios|
|           #  Desarrollado para copiar un registro en automatico           |
|           #  de residuo de una transferencia                              |
+===========================================================================+
| Uso       # 	@example                                                    |
|           #   u_ACM001()                                                  |
+===========================================================================+
*/
User Function ACM002()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZX2')
	oBrowse:SetDescription('Movimientos entre Bodegas (Semaforización)')
	oBrowse:Activate()
Return

Static Function MenuDef()
	Local aRotina := {}
	ADD OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.ACM002' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'          ACTION 'VIEWDEF.ACM002' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'          ACTION 'VIEWDEF.ACM002' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'          ACTION 'VIEWDEF.ACM002' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'         ACTION 'VIEWDEF.ACM002' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Copia Padrao'     ACTION 'VIEWDEF.ACM002' OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Copia com UI'     ACTION 'U_UICopy'        OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Copia sem UI'     ACTION 'U_NOUICopy'      OPERATION 9 ACCESS 0
Return aRotina

Static Function ModelDef()
	Local aZY2Rel:={}  
	Local oStHeader := FWFormStruct( 1, 'ZX2' )  
	Local oStDetail := FWFormStruct( 1, 'ZY2' )  
	Local oModel // Modelo de datos construído  
	oModel := MPFormModel():New( 'ACM002M' )  
	oModel:AddFields( 'ZX2MASTER', /*cOwner*/, oStHeader )  
	oModel:AddGrid( 'ZY2DETAIL', 'ZX2MASTER', oStDetail )  
	aAdd(aZY2Rel, {'ZY2_FILIAL'	, 'xFilial( "ZY2" )'	})
	aAdd(aZY2Rel, {'ZY2_DOC'	, 'ZX2_DOC'				})
	aAdd(aZY2Rel, {'ZY2_SERIE' 	, 'ZX2_SERIE'			}) 
	aAdd(aZY2Rel, {'ZY2_SECUEN' , 'ZX2_SECUEN'			}) 
	oModel:SetRelation('ZY2DETAIL', aZY2Rel, ZY2->(IndexKey(1))) 
	oModel:SetPrimaryKey({})
	oModel:SetDescription("Semaforización Acme Leon")
	oModel:GetModel('ZX2MASTER'):SetDescription('Encabezado Transferencia')
	oModel:GetModel('ZY2DETAIL'):SetDescription('Detalles de la Transferencia')
Return oModel

	 
Static Function ViewDef()  
	Local oModel := FWLoadModel( 'ACM002' )  
	Local oStHeader := FWFormStruct( 2, 'ZX2' )  
	Local oStDetail := FWFormStruct( 2, 'ZY2' )  
	Local oView  
	oView := FWFormView():New()  
	oView:SetModel( oModel )  
	oView:AddField( 'VIEW_ZX2', oStHeader, 'ZX2MASTER' )  
	oView:AddGrid( 'VIEW_ZY2', oStDetail, 'ZY2DETAIL' )  
	oView:CreateHorizontalBox( 'SUPERIOR', 15 )  
	oView:CreateHorizontalBox( 'INFERIOR', 85 )  
	oView:SetOwnerView( 'VIEW_ZX2', 'SUPERIOR' )  
	oView:SetOwnerView( 'VIEW_ZY2', 'INFERIOR' )
	oView:EnableTitleView('VIEW_ZX2','Encabezado Transferencia')
	oView:EnableTitleView('VIEW_ZY2','Detalles de la Transferencia')
Return oView 

/*
+---------------------------------------------------------------------------+
| Programa  #TransR    |Autor  | Axel Diaz        |Fecha |  10/12/2019      |
+---------------------------------------------------------------------------+
| Desc.     #  rutina excecuato que copia un documento con estado azul      |
+---------------------------------------------------------------------------+
| Uso       # 	                                                            |
+---------------------------------------------------------------------------+
*/
USER Function TransR()
	Local oModel
	Local oModelUpd
	Local nCantOri	:=0
	Local n2CantOri	:=0
	Local nCantDes	:=0
	Local n2CantDes	:=0	
	Local cSecuen	:= ""
	Local cSerie	:= ""
	Local cDoc		:= ""
	
	oModel		:= FWLoadModel('ACM002')
    oModel:SetOperation(MODEL_OPERATION_INSERT)
	//oModelUpd	:= FWLoadModel('ACM100')
    //oModelUpd:SetOperation(MODEL_OPERATION_UPDATE)
    
    
    If oModel:Activate(.T.)
    	If oModel:GetValue("ZX2MASTER","ZX2_ESTADO")==ESTADO_AZUL  // Valida el Estado
    		cSecuen	:= oModel:GetValue("ZX2MASTER","ZX2_SECUEN")
    		cSerie	:= oModel:GetValue("ZX2MASTER","ZX2_SERIE")
    		cDoc	:= oModel:GetValue("ZX2MASTER","ZX2_DOC")
    		// Se copia el registro del documento y se procede a borrar los datos innecesatios
	    	oModel:SetValue("ZX2MASTER","ZX2_SECUEN",soma1(oModel:GetValue("ZX2MASTER","ZX2_SECUEN"),3)) 	// suma la secuencia en un digito
	 		oModel:SetValue("ZX2MASTER","ZX2_ESTADO",ESTADO_BLANCO)   										// Coloca el estado del nuevo documento en blanco      
			oModel:SetValue("ZX2MASTER","ZX2_OBSER "," - DOCUMENTO CON RESIDUO - ")        
			oModel:SetValue("ZX2MASTER","ZX2_FLEGAL",CToD("  /  /  "))
			//oModel:SetValue("ZX2MASTER","ZX2_ALMDES","")
			oModel:SetValue("ZX2MASTER","ZX2_OK","")    
			oModel:SetValue("ZX2MASTER","ZX2_DOC2","")  
			oModel:SetValue("ZX2MASTER","ZX2_SERIE2","")
			oModel:SetValue("ZX2MASTER","ZX2_D3DOC","")
			oModel:SetValue("ZX2MASTER","ZX2_DTMOV",CToD("  /  /  "))  
			for nX:=1 to oModel:GetModel('ZY2DETAIL'):Length()
				oModel:GetModel('ZY2DETAIL'):GoLine( nX )
				oModel:SetValue("ZY2DETAIL","ZY2_SECUEN",soma1(oModel:GetValue("ZY2DETAIL","ZY2_SECUEN"),3))
				nCantOri:=  oModel:GetValue("ZY2DETAIL","ZY2_CANTO")
				n2CantOri:= oModel:GetValue("ZY2DETAIL","ZY2_2CANTO")
				nCantDes:=  oModel:GetValue("ZY2DETAIL","ZY2_CANTD")
				n2CantDes:= oModel:GetValue("ZY2DETAIL","ZY2_2CANTD")
				If nCantOri==nCantDes
					oModel:GetModel('ZY2DETAIL'):DeleteLine()
				Else
					oModel:SetValue("ZY2DETAIL","ZY2_CANTO",nCantOri-nCantDes)
					oModel:SetValue("ZY2DETAIL","ZY2_2CANTO",n2CantOri-n2CantDes)
					oModel:SetValue("ZY2DETAIL","ZY2_ESTADO",ESTADO_BLANCO)
					oModel:SetValue("ZY2DETAIL","ZY2_LEGALI",CToD("  /  /  "))
					oModel:SetValue("ZY2DETAIL","ZY2_DTDIGI",dDatabase)
					oModel:SetValue("ZY2DETAIL","ZY2_TPMOV",TP_MOV_GRIS)
					//oModel:SetValue("ZY2DETAIL","ZY2_UNDES","")
					oModel:SetValue("ZY2DETAIL","ZY2_CANTD",0)
					//oModel:SetValue("ZY2DETAIL","ZY2_2UNDES","")
					oModel:SetValue("ZY2DETAIL","ZY2_2CANTD",0)
				EndIf
			Next
			If oModel:VldData()
				oModel:CommitData()
				// MACHETAZO 
				TCSQLEXEC("UPDATE "+InitSqlName("ZX2")+" SET ZX2_ESTADO='"+ESTADO_VERDEC+"' FROM "+InitSqlName("ZX2")+" WHERE ZX2_SECUEN='"+cSecuen+"' AND ZX2_SERIE='"+cSerie+"' AND ZX2_DOC='"+cDoc+"' AND D_E_L_E_T_=' ' AND ZX2_FILIAL='"+XFILIAL("ZX2")+"' ")
			Else
				Help( ,, HelpAcme,, oModel:GetErrorMessage()[6], 1, 0)   
			EndIf
			//FWExecView("Residuo transferencia", "ACM002",MODEL_OPERATION_INSERT,/*oDlg*/,/*bCloseOnOk*/,/*bOk*/,/*nPercReducao*/,/*aEnableButtons*/,/*bCancel*/,,,oModel)

        Else
        	Help( ,, AcmeHlpTtlResiduo,, AcmeHlpDetResiduo, 1, 0)
        EndIf
    Else
        Help( ,, HelpAcme,, oModel:GetErrorMessage()[6], 1, 0)   
    EndIf
    
Return




