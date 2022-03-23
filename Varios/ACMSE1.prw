#include 'protheus.ch'
#include 'parmtype.ch'
#DEFINE CRLF chr(13)+chr(10)

/* -------------------------------------------------------------------
Function ACMSE1
Autor Axel Diaz
Proposito: Esta funcion permite relacionar a los usuarios con las series 
autorizadas para el traslado entre bodegas
------------------------------------------------------------------------
*/
User Function ACMSE1()
	Local aArea			:= GetArea()
	Local cAliasZZU 	:= GetNextAlias()
	Local cQuery 		:= ""
	Local aCampos		:= {}
	Private cCadastro 	:= "Maestro de Series y Usuarios"
	Private aRotina		:= MenuDef()
              
	
	chkfile("ZX2")
	chkfile("ZX2")
	chkfile("ZZU")
	
	If Select(cAliasZZU) > 0
		(cAliasZZU)->( dbCloseArea() )
	EndIf
	
	AAdd( aCampos,{ "ZZU_SERIE"		,"Serie"					,01,"@!",1,TamSX3("ZZU_SERIE")[1]	,0,.T.	} )
	AAdd( aCampos,{ "ZZU_USRCOD"	,"Usuario Autorizado"		,02,"@!",1,TamSX3("ZZU_USRCOD")[1]	,0,.T.	} )
	
	
	AADD(aRotina,{"Pesquisar"	,"AxPesqui",0,1})
	AADD(aRotina,{"Visualizar"	,"AxVisual",0,2})
	AADD(aRotina,{"Incluir"		,"AxInclui",0,3})
	AADD(aRotina,{"Modifica"	,"AxAltera",0,4})
	AADD(aRotina,{"Eliminar"	,"AxDeleta",0,5})
	
	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias("ZZU")
	oBrowse:SetDescription(cCadastro)
	
	oBrowse:SetAmbiente(.T.)  // Habilita a utilização da funcionalidade Walk-Thru no Browse
	oBrowse:SetWalkThru(.F.)  // Habilita a utilização da funcionalidade Walk-Thru no Browse
	oBrowse:SetFixedBrowse(.T.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:DisableDetails()
	
	For nX:=1 to Len (aCampos)
		oBrowse:SetColumns(MontaColunas(aCampos[nX][1],aCampos[nX][2],aCampos[nX][3],aCampos[nX][4],aCampos[nX][5],aCampos[nX][6],aCampos[nX][7], aCampos[nX][8]))
	Next nX	
	oBrowse:Refresh(.T.)
	oBrowse:Activate()
	oBrowse:Destroy()
	RestArea(aArea)
Return

/*
+===========================================================================+
| Programa  #MontaColunas|Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+===========================================================================+
| Desc.     #  Función para crear columnas de cuadrícula                    |
|           #                                                               |
+===========================================================================+
| Uso       # AP                                                            |
+===========================================================================+
*/
Static Function MontaColunas(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal, ldetalle)
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
	aColumn := {cTitulo,bData,  ,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,ldetalle, {}}
Return {aColumn}

