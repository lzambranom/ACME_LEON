//#Include "Ctbr040.Ch"
#Include "PROTHEUS.Ch"

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA 			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT    	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_DEBITO   	8
#DEFINE 	COL_SEPARA5			9
#DEFINE 	COL_VLR_CREDITO  	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15

                                      
STATIC __aTmpTCFil	:= {}
STATIC lFWCodFil 	:= FindFunction("FWCodFil")

STATIC aCubsCTB
Static lCtbIsCube 	:= FindFunction("CtbIsCube")
Static __cArqEnt


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr048	³ Autor ³ Acacio Egas       	³ Data ³ 01/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Analitico localizado.       			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr048()                               			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±                 

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROR048()
PRIVATE titulo		:= ""
Private nomeprog	:= "CTBR048"
Private oReport		:= Nil
Private cPlano		:= "01" // Usado pela consulta padrao CV01
Private cCodigo		:= ""   // Usado pela consulta padrao CV01

u_PROR48R4()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ PROR48R4 ³ Autor³ Daniel Sakavicius		³ Data ³ 01/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Analitico Sintetico Modelo 1 - R4                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR048R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROR48R4()


//CtbCarTxt()

oReport := ReportDef()

If Valtype( oReport ) == 'O'
	If ! Empty( oReport:uParam )
		//Pergunte( oReport:uParam, .F. )
	EndIf	
	
	oReport:PrintDialog()      
Endif
	
oReport := Nil

Return                                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 28/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
local aArea	   		:= GetArea()   
Local CREPORT		:= "PROR048"
Local CTITULO		:= "Emision del Relat. Conf. Dig. "
Local CDESC			:= "Este programa ira imprimir o Relatorio para Conferencia"			// "Este programa ira imprimir o Relatorio para Conferencia"
Local CCOLBAR		:= "|"                   
Local aTamConta		:= TAMSX3("CT1_CONTA")    

Local aTamVal		:= TAMSX3("CT2_VALOR")
Local aTamDesc		:= TAMSX3("CT1_CONTA")
Local cPictVal 		:= PesqPict("CT2","CT2_VALOR")
Local nDecimais
Local cMascara		:= ""
Local cSeparador	:= ""
Local nTamConta		:= TAMSX3("CT1_CONTA")[1]
Local nTamEC05		:= TAMSX3("CV0_CODIGO")[1]
Local aSetOfBook
Local nMaskFator 	:= 1
Local aParam		:= {}
Local cPerg	   		:= "PRO048" 
aPergs              := {}

aAdd(aPergs,{"Fecha inicial ?            ","¿Fecha inicial ?"          ,"Fecha inicial ?  "          ,"mv_ch1","D",8,0,0,"G","" ,"mv_par01","" ,"" ,""  ,"01/01/2009","","","","","","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aPergs,{"Fecha Final ?              ","¿Fecha Final ?  "          ,"Fecha Final ?    "          ,"mv_ch2","D",8,0,0,"G","" ,"mv_par02","" ,"" ,""  ,"31/12/2009","","","","","","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aPergs,{"Cuenta Inicial ?           ","¿Cuenta Inicial ?"         ,"Cuenta Inicial ?"           ,"MV_CH3","C",20,0,0,"G","","mv_par03",""	,""	,""	 ,"","","","","","","","","","","","","","","","","","","","","","CT1"	,"003"	,"S"})
aAdd(aPergs,{"Cuenta Final ?             ","¿Cuenta Final ?  "         ,"Cuenta Final ?  "           ,"MV_CH4","C",20,0,0,"G","","mv_par04",""	,""	,""	 ,"","","","","","","","","","","","","","","","","","","","","","CT1"	,"003"	,"S"})
aAdd(aPergs,{"Saldo en Zero ?            ","¿Saldo en Zero ? "         ,"Saldo en Zero ?  "          ,"mv_ch5","N",1,0,0,"C","" ,"mv_par05","Sim","Si"           ,"Yes"           ,""          ,""        ,"Nao"            ,"No"             ,"No"            ,"","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aPergs,{"Moeda  ?                   ","¿Moneda  ?"                ,"Currency ?"                 ,"mv_ch6","C",2,0,0,"G","" ,"mv_par06",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","CTO","","S"})
aAdd(aPergs,{"Tipo de Saldo ?            ","¿Tipo de Saldo ?"          ,"Balance Type              ?","mv_ch7","C",1,0,0,"G","VldTpSald( MV_PAR07 , .T. )","mv_par07",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","SLD","","S"})
aAdd(aPergs,{"Imprime Coluna Mov. ?      ","Imprime Coluna Mov. ?"     ,"Imprime Coluna Mov.       ?","mv_ch8","N",1,0,0,"C","","mv_par08","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aPergs,{"Salta Linha Sintet. ?      ","Salta Linea Sintet. ?"     ,"Salta Linha Sintet.       ?","mv_ch9","N",1,0,0,"C","","mv_par09","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aPergs,{"Imprime Valor 0.00 ?       ","Imprime Valor 0.00 ?"      ,"Imprime Valor 0.00        ?","mv_cha","N",1,0,0,"C","","mv_par10","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","   ","","S"})
aAdd(aPergs,{"Num.linhas p/ o Balancete ?","Nº.lineas p/ o Balancete ?","Num.linhas p/ o Balancete ?","mv_chb","N",2,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","S"})
aAdd(aPergs,{"Descricao na moeda?        ","¿Descrip. en moneda ?"     ,"Descricao na moeda        ?","mv_chc","C",2,0,0,"G","","mv_par12",""            ,""             ,""              ,""          ,""        ,""               ,""               ,""              ,"","","","","","","","","","","","","","","","","CTO","","S"})
aAdd(aPergs,{"N.I.T. Inicial ?           ","N.I.T. Inicial ?"          ,"N.I.T. Inicial            ?","MV_CHd","C",20,0,0,"G","","mv_par13",""	,""	,""	 ,"","","","","","","","","","","","","","","","","","","","","","CV01"	,"003"	,"S"})
aAdd(aPergs,{"N.I.T. Final ?             ","N.I.T. Final ?"            ,"N.I.T. Final              ?","MV_CHe","C",20,0,0,"G","","mv_par14",""	,""	,""	 ,"","","","","","","","","","","","","","","","","","","","","","CV01"	,"003"	,"S"})
aAdd(aPergs,{"Total por cuenta?          ","Total por cuenta?"         ,"Total por cuenta?   "       ,"MV_CHf","N",01,0,0,"C","","mv_par15","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","   ","","S"})

DbSelectArea("SX1")
DbSetOrder(1)
IF !DbSeek(Padr(CPERG,Len(X1_GRUPO))+"18")
	AjustaSX1(CPERG,aPergs)
Endif

Pergunte(CPERG,.T.)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)	    	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSetOfBook := CTBSetOf( "" )
cMascara := RetMasCtb( aSetOfBook[2], @cSeparador )

If ! Empty( cMascara )
	nTamConta := aTamConta[1] + ( Len( Alltrim( cMascara ) ) / 2 )
Else
	nTamConta := aTamConta[1]
EndIf

cPicture := aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//"Este programa tem o objetivo de emitir o Cadastro de Itens Classe de Valor "
//"Sera impresso de acordo com os parametros solicitados pelo"
//"usuario"
oReport	:= TReport():New( cReport,Capital(CTITULO),CPERG, { |oReport| /*Pergunte(cPerg , .F. ),*/ If(! ReportPrint( oReport ), oReport:CancelPrint(), .T. ) }, CDESC ) 


oReport:SetEdit(.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// oSection1                        
oSection1:= TRSection():New(oReport,"Conta",{"cArqTmp"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/)	//"Conta"
oSection1:SetHeaderPage(.T.)
oSection1:SetReadOnly() 

TRCell():New( oSection1, "ECX"	,,"CUENTA"/*Titulo*/	,/*Picture*/, nTamConta /*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "ECXDESC"  ,,"DESCRIPCION"/*Titulo*/	,/*Picture*/, aTamDesc[1]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
// Entidade 05
TRCell():New( oSection1, "ECY"	,,"NIT"/*Titulo*/	,/*Picture*/, nTamEC05 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "ECYDESC"  ,,"DESCRI"/*Titulo*/	,/*Picture*/, 20/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )

TRCell():New( oSection1, "SALDOANT" ,,"SALDO ANTERIOR"/*Titulo*/	,/*Picture*/, aTamVal[1] + 2/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection1, "SALDODEB" ,,"DEBITO"/*Titulo*/	,/*Picture*/, aTamVal[1] /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection1, "SALDOCRD" ,,"CREDITO"/*Titulo*/	,/*Picture*/, aTamVal[1] /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection1, "MOVIMENTO",,"MOVIMENTO"/*Titulo*/	,/*Picture*/, aTamVal[1] + 2/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection1, "SALDOATU" ,,"SALDO ATUAL"/*Titulo*/	,/*Picture*/, aTamVal[1] + 2/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")

//TRCell():New(oSection1,"DESCCC"	,"cArqTmp","DESCRIPCION",/*Picture*/,nTamConta+20,/*lPixel*/,/*{|| }*/)		//"DESCRICAO"
oSection1:SetReadOnly()

oSection1:Cell("ECX"):Hide()
oSection1:Cell("ECXDESC"):Hide()
oSection1:Cell("ECY"):Hide()
oSection1:Cell("ECYDESC"):Hide()
oSection1:Cell("SALDOANT"):Hide()
oSection1:Cell("SALDODEB"):Hide()
oSection1:Cell("SALDOCRD"):Hide()
oSection1:Cell("MOVIMENTO"):Hide()
oSection1:Cell("SALDOATU"):Hide()
//oSection1:Cell("CONTA"):HideHeader() 
oSection1:SetTotalInLine(.T.)                                              
oSection1:SetTotalText('T O T A L  G E N E R A L ==>>') //STR0011) //"T O T A I S  D O  P E R I O D O: "



// oSection2
oSection2:= TRSection():New( oReport,"Plano de contas", {"cArqTmp","CT1"},, .F., .F. ) //"Plano de contas"
oSection2:SetHeaderSection(.F.)  
oSection2:SetReadOnly()  

// Conta
TRCell():New( oSection2, "ECX"	,,"CUENTA"/*Titulo*/	,/*Picture*/, nTamConta /*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection2, "ECXDESC"  ,,"DESCRIPCION"/*Titulo*/	,/*Picture*/, aTamDesc[1]/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
// Entidade 05
TRCell():New( oSection2, "ECY"	,,"NIT"/*Titulo*/	,/*Picture*/, nTamEC05 /*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection2, "ECYDESC"  ,,"DESCRI"/*Titulo*/	,/*Picture*/, 20/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )

TRCell():New( oSection2, "SALDOANT" ,,"SALDO ANTERIOR"/*Titulo*/	,/*Picture*/, aTamVal[1] + 2/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection2, "SALDODEB" ,,"DEBITO"/*Titulo*/	,/*Picture*/, aTamVal[1] /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection2, "SALDOCRD" ,,"CREDITO"/*Titulo*/	,/*Picture*/, aTamVal[1] /*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection2, "MOVIMENTO",,"MOVIMENTO"/*Titulo*/	,/*Picture*/, aTamVal[1] + 2/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection2, "SALDOATU" ,,"SALDO ATUAL"/*Titulo*/	,/*Picture*/, aTamVal[1] + 2/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
                                                                                                                                                     
                                                                                 
TRPosition():New( oSection2, "CT1", 1, {|| xFilial( "CT1" ) + cArqTMP->ECX })

oSection2:SetTotalInLine(.T.)          
oSection2:SetTotalText('') //STR0011) //"T O T A I S  D O  P E R I O D O: "

oSection2:Cell("ECX"):HideHeader()                                     
oSection2:Cell("ECXDESC"):HideHeader()                                     
oSection2:Cell("ECY"):HideHeader()                                     
oSection2:Cell("ECYDESC"):HideHeader()                                     
oSection2:Cell("SALDOANT"):HideHeader()                                     
oSection2:Cell("SALDODEB"):HideHeader()                                     
oSection2:Cell("SALDOCRD"):HideHeader()                                     
oSection2:Cell("MOVIMENTO"):HideHeader() 
oSection2:Cell("SALDOATU"):HideHeader() 

If MV_PAR08=2
	oSection2:Cell("MOVIMENTO"):HideHeader()
EndIf


Return( oReport )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 28/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )  
Local oSection1 	:= oReport:Section(1) 
Local oSection2 	:= oReport:Section(2) 
Local lExterno		:= .F.   
Local aSetOfBook
Local dDataFim 		:= MV_PAR02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lRet			:= .T.
Local lPrintZero	:=  IIF(MV_PAR10=1,.T.,.F.) 
Local lPula			:=  IIF(MV_PAR09=1,.T.,.F.) 
Local lNormal		:= .T. 
Local lVlrZerado	:=  IIF(MV_PAR05==1,.T.,.F.)
Local lQbGrupo		:= .T. 
Local lQbConta		:= .T.
Local l132			:= .T.
Local nDecimais
Local nDivide		:= 1
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0                     
Local cSegAte   	:= "" 
Local nDigitAte		:= 0
Local lImpSint		:= .T.
Local lImpMov		:= IIF(MV_PAR08=1,.T.,.F.)
Local n
Local oMeter
Local oText
Local oDlg
Local oBreak
Local lImpPaisgm	:= .F.	
Local nMaxLin   	:=  MV_PAR11                                                                  
Local cMoedaDsc		:=  MV_PAR12 
Local aCtbMoeda		:= {}
Local aCtbMoedadsc	:= {}
Local CCOLBAR		:= "|"                   
Local cTipoAnt		:= ""
Local cGrupoAnt		:= ""
Local cArqTmp		:= ""
Local Tamanho		:= "M"
Local cSeparador	:= ""
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local oTotDeb		
Local oTotCrd
Local oTotGerDeb		              
Local oTotGerCrd                      
Local nTotSldAtu := 0
Local nTotSldAnt := 0
Local nTotDeb	:= 0
Local nTotCrd	:= 0
Local nSldAtu := 0
Local nSldAnt := 0
Local cPicture
Local cContaSint
Local cBreak		:= "2"
Local cGrupo		:= ""
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nTotGerMov	:= 0
Local nCont			:= 0
Local cFilUser		:= ""
Local cRngFil		:= "" 
Local nMasc			:= 0
Local cMasc			:= ""
Local dDtCorte      := Stod(cValtoChar(year(mv_par01))+"0101")  // Data de corte pora virada de saldo anual

Private nLinReport    := 9


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)	    	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSetOfBook := CTBSetOf( "" )



If lRet
	aCtbMoeda := CtbMoeda(  MV_PAR06 , nDivide )

	If Empty(aCtbMoeda[1])                       
		Help(" ",1,"NOMOEDA")
		lRet := .F.
		Return lRet
	Endif

    // validação da descrição da moeda
	if lRet .And. ! Empty(  MV_PAR12 ) .and.  MV_PAR12 <> nil
		aCtbMoedadsc := CtbMoeda(  MV_PAR12 , nDivide )

		If Empty( aCtbMoedadsc[1] )                       
    		Help( " " , 1 , "NOMOEDA")
	        lRet := .F.
    	    Return lRet
	    Endif
	Endif
Endif

If lRet
/*	If (mv_par25 == 1) .and. ( Empty(mv_par26) .or. Empty(mv_par27) )
		cMensagem	:= STR0025	//"Favor preencher os parametros Grupos Receitas/Despesas e "
		cMensagem	+= STR0026	//"Data Sld Ant. Receitas/Desp. "
		MsgAlert(cMensagem,STR0035)	 //"Ignora Sl Ant.Rec/Des"
		lRet    	:= .F.	
	    Return lRet
    EndIf*/
EndIf

aCtbMoeda  	:= CtbMoeda( MV_PAR06,nDivide)                

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,MV_PAR06)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture1	:= aSetOfBook[4]
cPicture    := aSetOfBook[4] //"@E 9,999,999,999,999.99" //aSetOfBook[4]
                            
//Alert(aSetOfBook[4])

lPrintZero	:= Iif( MV_PAR10==1,.T.,.F.)

Titulo:=	OemToAnsi("BALANCE DE VERIFICACION DE ")	//"BALANCETE DE VERIFICACAO DE "
Titulo += 	DTOC(MV_PAR01) + OemToAnsi(" HASTA ") + Dtoc(MV_PAR02) + ;
			OemToAnsi(" MONEDA ") + cDescMoeda + CtbTitSaldo(MV_PAR07)           


oReport:SetCustomText( {|| nCtCGCCabTR(dDataFim, MV_PAR01,titulo,oReport)})

cFilUser := oSection2:GetAdvplExpr("CT1")
If Empty(cFilUser)
	cFilUser := ".T."
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao			  		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lExterno  .or. IsBlind()
	U_XCTGerPla(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				 MV_PAR01, MV_PAR02,"CVY","", MV_PAR03, MV_PAR04, MV_PAR13, MV_PAR14,,,,, MV_PAR06,;
				 MV_PAR07,aSetOfBook,,,,,;
				.F.,.F.,,.F.,,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,,;
				,,,,,,,,cMoedaDsc,,cRngFil,dDtCorte)
Else
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
					U_XCTGerPla(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
					 MV_PAR01, MV_PAR02,"CVY","", MV_PAR03, MV_PAR04, MV_PAR13, MV_PAR14,,,,, MV_PAR06,;
					MV_PAR07,aSetOfBook,,,,,;
					.F.,.F.,,,.F.,,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,,;
					,,,,,,,,cMoedaDsc,,cRngFil,dDtCorte)},;              
					OemToAnsi(OemToAnsi("Criando Archivo Temporario...")),;  //"Criando Arquivo Tempor rio..."
					OemToAnsi("Balancete Verificacao"))  				//"Balancete Verificacao"
EndIf                                                          
                
nCount := cArqTmp->(RecCount())

oReport:SetMeter(nCont)

lRet := !(nCount == 0 .And. !Empty(aSetOfBook[5]))

If lRet
	
	
	cArqTmp->(dbGoTop())
	
	If lNormal
		oSection2:Cell("ECX"):SetBlock( {|| EntidadeCTB(cArqTmp->ECX,000,000,030,.F.,cMascara,cSeparador,,,.F.,,.F.)} )
	Else
		oSection2:Cell("ECX"):SetBlock( {|| cArqTmp->ECXRES } )
	EndIf
	oSection2:Cell("ECXDESC"):SetBlock( { || cArqTMp->ECXDESC } )
	
	oSection2:Cell("ECY"):SetBlock( {|| cArqTmp->ECY } )
	oSection2:Cell("ECYDESC"):SetBlock( { || cArqTMp->ECYDESC } )
	
	oSection2:Cell("SALDOANT"):SetBlock( { || ValorCTB(cArqTmp->SALDOANT,,,aTamVal[1],nDecimais,.T.,cPicture,cArqTmp->ECXNORMAL,,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SALDODEB"):SetBlock( { || ValorCTB(cArqTmp->SALDODEB,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SALDOCRD"):SetBlock( { || ValorCTB(cArqTmp->SALDOCRD,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection2:Cell("SALDOATU"):SetBlock( { || ValorCTB(cArqTmp->SALDOATU,,,aTamVal[1],nDecimais,.T.,cPicture,cArqTmp->ECXNORMAL,,,,,,lPrintZero,.F.) } )

  oSection1:Cell("SALDODEB"):SetBlock( { || ValorCTB(cArqTmp->SALDODEB,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
  oSection1:Cell("SALDOCRD"):SetBlock( { || ValorCTB(cArqTmp->SALDOCRD,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )


	
	// Imprime Movimento
	If !lImpMov
		oSection2:Cell("MOVIMENTO"):Disable()
		oSection1:Cell("MOVIMENTO"):Disable()
	Else
		oSection2:Cell("MOVIMENTO"):SetBlock( { || ValorCTB(cArqTmp->MOVIMENTO,,,aTamVal[1],nDecimais,.T.,cPicture,cArqTmp->ECXNORMAL,,,,,, lPrintZero,.F.) } )
	EndIf
	
	//******************************
	// Total Geral do relatorio    *
	//******************************
	
	If mv_par15 = 1
		
		oBreak1 := TRBreak():New( oSection2, {|| cArqTmp->ECX }, OemToAnsi("Total Cuenta") ) // "Total da Conta"
		  
		
			TRFunction():New(oSection2:Cell("SALDOANT"),,"ONPRINT",oBreak1/*oBreak*/,/*Titulo*/,cPicture,;
		{ || ValorCTB(nSldAnt,,,aTamVal[1],nDecimais,.T.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2 )

		
		TRFunction():New(oSection2:Cell("SALDODEB"),,"ONPRINT",oBreak1/*oBreak*/,""/*Titulo*/,cPicture,;
		{ || ValorCTB(nTotDeb,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2 )
		
		TRFunction():New(oSection2:Cell("SALDOCRD"),,"ONPRINT",oBreak1/*oBreak*/,""/*Titulo*/,cPicture,;
		{ || ValorCTB(nTotCrd,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2 )
		
		TRFunction():New(oSection2:Cell("SALDOATU"),,"ONPRINT",oBreak1/*oBreak*/,/*Titulo*/,cPicture,;
		{ || ValorCTB(nSldAtu,,,aTamVal[1],nDecimais,.T.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2 )

		
		
				
		oBrkGeral := TRBreak():New(oSection1, { || /*cArqTmp->(!Eof())*/ },{|| " T O T A L  G E N E R A L  ==> " },,,.F.)	//	" T O T A I S "
			

	   oTotGerAnt 	:= TRFunction():New( oSection1:Cell("SALDOANT")	, ,"ONPRINT", oBrkGeral,"" /*Titulo*/,cPicture,;
				{ || ValorCTB(nTotSldAnt  ,,,aTamVal[1],nDecimais,.T.,cPicture1,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1)
				
	   oTotGerDeb 	:= TRFunction():New( oSection1:Cell("SALDODEB")	, ,"ONPRINT", oBrkGeral,"" /*Titulo*/,cPicture,;
				{ || ValorCTB(nTotGerDeb  ,,,aTamVal[1],nDecimais,.F.,cPicture1,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1)
				
	   oTotGerCrd 	:= TRFunction():New( oSection1:Cell("SALDOCRD")	, ,"ONPRINT", oBrkGeral,"" /*Titulo*/,cPicture,;
				{ || ValorCTB(nTotGerCrd  ,,,aTamVal[1],nDecimais,.F.,cPicture1,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1)
	 
		oTotTpSld 	:= TRFunction():New( oSection2:Cell("SALDOATU")	, ,"ONPRINT", oBrkGeral,""/*Titulo*/,cPicture,;	 
						{ || ValorCTB(nTotSldAtu,,,aTamVal[1],nDecimais,.T.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection1)
			
				
		
	Else
		
		oBrkGeral := TRBreak():New(oSection2, { || cArqTmp->(!Eof()) },{|| " T O T A I S " },,,.F.)	//	" T O T A I S "
		
		// Totaliza
		oTotGerDeb := TRFunction():New(oSection2:Cell("SALDODEB"),,"SUM",oBrkGeral /*oBreak*/,""/*Titulo*/,/*cPicture*/,;
		{ || Iif(cArqTmp->TIPOECX="1",0,cArqTmp->SALDODEB) },.F.,.F.,.F.,oSection2)
		oTotGerDeb:Disable()
		
		oTotGerCrd := TRFunction():New(oSection2:Cell("SALDOCRD"),,"SUM", oBrkGeral/*oBreak*/,""/*Titulo*/,/*cPicture*/,;
		{ || Iif(cArqTmp->TIPOECX="1",0,cArqTmp->SALDOCRD) },.F.,.F.,.F.,oSection2)
		oTotGerCrd:Disable()
		
		TRFunction():New(oSection2:Cell("SALDODEB"),,"ONPRINT",oBrkGeral/*oBreak*/,""/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGerDeb:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2 )
		
		// Imprime
		TRFunction():New(oSection2:Cell("SALDOCRD"),,"ONPRINT",oBrkGeral/*oBreak*/,""/*Titulo*/,/*cPicture*/,;
		{ || ValorCTB(oTotGerCrd:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },.F.,.F.,.F.,oSection2 )
		
	EndIf
	
	//	oSection2:OnPrintLine( {|| 	U_PRO048On( lPula, lQbConta, nMaxLin, @cTipoAnt, @nLinReport, @cGrupoAnt ) } )
	
	//oSection2:Print()
	
	
	If cArqTmp->(EoF())
		// Atencao ### "Nao existem dados para os parâmetros especificados."
		Aviso("Atencion","No existem datos para los parametros especificados.",{"Ok"})
		oReport:CancelPrint()
		Return
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³INICIO DA IMPRESSAO DA 1A SECAO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     	oSection1:Init() 
     	nLin := 3

	   	oSection1:PrintLine() 

		
		
		
		While !cArqTmp->(Eof()) .And. !oReport:Cancel()
			
			If oReport:Cancel()
				Exit
			EndIf
			// Verifica salto de linha para conta sintetica (MV_PAR09)
			If lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOECX == "1" .And. cTipoAnt == "2"))
				oReport:SkipLine()
			EndIf
			
						
			// Verifica numero maximo de linhas por pagina (MV_PAR11)
			If !Empty(nMaxLin)
				CTR048MaxL(nMaxLin,@nLinReport)
			EndIf
			       
			
					  
			cTipoAnt := cArqTmp->TIPOECX
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³INICIO DA IMPRESSAO DA 1A SECAO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    	// 	oSection1:Init() 
    	// 	nLin := 3

	    // 	oSection1:PrintLine() 
		  //  oSection1:Finish()  
			
			
			oSection2:Init()
			nLin := 3
			
			cContaAnt:= cArqTmp->ECX
			
			cCondic := "ECX"
			
			
			Do While cArqTmp->(!Eof() .And. &cCondic = cContaAnt ) .And. !oReport:Cancel()
					
				
				If oReport:Cancel()
					Exit
				EndIf
				
					// Verifica quebra de pagina por conta (mv_par11)
				If lQbConta .And. cArqTmp->NIVEL1
					oReport:EndPage()
					nLinReport := 9
					Return
				EndIf
				
				
								
				nTotDeb	+= if(cArqTmp->TIPOECX="1",0,cArqTmp->SALDODEB)
				nTotCrd	+= if(cArqTmp->TIPOECX="1",0,cArqTmp->SALDOCRD)			 
				nSldAtu += cArqTmp->SALDOANT - cArqTmp->SALDODEB + cArqTmp->SALDOCRD
				nSldAnt += cArqTmp->SALDOANT
				
				nTotGerDeb	+= if(cArqTmp->TIPOECX="1",0,cArqTmp->SALDODEB)
				nTotGerCrd	+= if(cArqTmp->TIPOECX="1",0,cArqTmp->SALDOCRD)			 
				nTotSldAtu  += cArqTmp->SALDOANT - cArqTmp->SALDODEB + cArqTmp->SALDOCRD
				nTotSldAnt  += cArqTmp->SALDOANT
				
							// Verifica numero maximo de linhas por pagina (MV_PAR11)
				If !Empty(nMaxLin)
					CTR048MaxL(nMaxLin,@nLinReport)
				EndIf
				
				nLin := 1
				oSection2:PrintLine()
				oReport:IncMeter()
				
				
				//If mv_par05 == 1		// Apenas sinteticas
				//	lRet := (cArqTmp->TIPOECX == "1")
				//ElseIf mv_par05 == 2	// Apenas analiticas
				//	lRet := (cArqTmp->TIPOECX == "2")
				//EndIf
				
				
				DbSelectArea("cArqTmp")
				DbSkip()
			EndDo                   
			
 			oSection2:SetTotalText('Total Cuenta '+cContaAnt) //STR0011) //"T O T A I S  D O  P E R I O D O: "
					
			oSection2:Finish()
			
			nTotDeb	:= 0
			nTotCrd	:= 0
			nSldAtu := 0
			nSldAnt := 0
			
			oReport:SkipLine()
			nLinReport++			
		EndDo
		
		oSection1:Finish()  
		  
	EndIf
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	

Return .T.

  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTR048OnPrint ºAutor ³ Gustavo Henrique º Data ³ 07/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa acoes especificadas nos parametros do relatorio,   º±±
±±º          ³ antes de imprimir cada linha.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Indicar se deve saltar linha entre conta sintetica º±±
±±º          ³ EXPL2 - Indicar se deve quebrar pagina por conta           º±±
±±º          ³ EXPN3 - Informar o total de linhas por pagina do balancete º±±
±±º          ³ EXPC4 - Guardar o tipo da conta impressa (sint./analitica) º±±
±±º          ³ EXPN5 - Guardar linha atual do relatorio para validacao    º±±
±±º          ³         com o valor do parametro EXPN3.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ EXPL1 - Indicar se deve imprimir a linha (.T.)             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contabilidade Gerencial                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PRO048On( lPula, lQbConta, nMaxLin, cTipoAnt, nLinReport )
                                                                        
Local lRet := .T.           

// Verifica salto de linha para conta sintetica (MV_PAR09)
If lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOECX == "1" .And. cTipoAnt == "2"))
	oReport:SkipLine()
EndIf	

// Verifica quebra de pagina por conta (mv_par11)
If lQbConta .And. cArqTmp->NIVEL1
	oReport:EndPage()
	nLinReport := 9
	Return
EndIf	

// Verifica numero maximo de linhas por pagina (MV_PAR11)
If ! Empty(nMaxLin)
	CTR048MaxL(nMaxLin,@nLinReport)
EndIf	

cTipoAnt := cArqTmp->TIPOECX

//If mv_par05 == 1		// Apenas sinteticas
//	lRet := (cArqTmp->TIPOECX == "1")
//ElseIf mv_par05 == 2	// Apenas analiticas
//	lRet := (cArqTmp->TIPOECX == "2")
//EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CT048Valid³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida Perguntas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct048Valid(cSetOfBook)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Config. Relatorio                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PRO048Va(cSetOfBook)

Local aSaveArea:= GetArea()
Local lRet		:= .T.	

If !Empty(cSetOfBook)
	dbSelectArea("CTN")
	dbSetOrder(1)
	If !dbSeek(xfilial()+cSetOfBook)
		aSetOfBook := ("","",0,"","")
		Help(" ",1,"NOSETOF")
		lRet := .F.
	EndIf
EndIf
	
RestArea(aSaveArea)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTR048MAXL ºAutor ³ Eduardo Nunes Cirqueira º Data ³  31/01/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Baseado no parametro MV_PAR11 ("Num.linhas p/ o Balancete      º±±
±±º          ³ Modelo 1"), cujo conteudo esta na variavel "nMaxLin", controla º±±
±±º          ³ a quebra de pagina no TReport                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTR048MaxL(nMaxLin,nLinReport)

nLinReport++

If nLinReport > nMaxLin
	oReport:EndPage()
	nLinReport := 10
EndIf

Return Nil
                                                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ nCtCGCCabTR  º Autor ³ Fabio Jadao Caires      º Data ³ 31/01/07º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Chama a funcao padrao CtCGCCabTR reiniciando o contador de      º±±
±±º          ³ linhas para o controle do relatorio.                            º±±
±±º          ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION nCtCGCCabTR(dDataFim,dDataIni,titulo,oReport)

nLinReport := 10

RETURN CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport,,,,,,,,,,dDataIni)





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtGerPlan ³ Autor ³ Simone Mie Sato       ³ Data ³ 25.08.01          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Balancetes.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 01-oMeter      = Controle da regua                                  ³±±
±±³          ³ 02-oText       = Controle da regua                                  ³±±
±±³          ³ 03-oDlg        = Janela                                             ³±±
±±³          ³ 04-lEnd        = Controle da regua -> finalizar                     ³±±
±±³          ³ 05-cArqTmp     = Arquivo temporario                                 ³±±
±±³          ³ 06-dDataIni    = Data Inicial de Processamento                      ³±±
±±³          ³ 07-dDataFim    = Data Final de Processamento                        ³±±
±±³          ³ 08-cAlias      = Alias do Arquivo                                   ³±±
±±³          ³ 09-cIdent      = Identificador do arquivo a ser processado          ³±±
±±³          ³ 10-cContaIni   = Conta Inicial                                      ³±±
±±³          ³ 11-cContaFim	= Conta Final                                          ³±±
±±³          ³ 12-cCCIni      = Centro de Custo Inicial                            ³±±
±±³          ³ 13-cCCFim      = Centro de Custo Final                              ³±±
±±³          ³ 14-cItemIni    = Item Inicial                                       ³±±
±±³          ³ 15-cItemFim    = Item Final                                         ³±±
±±³          ³ 16-cClvlIni    = Classe de Valor Inicial                            ³±±
±±³          ³ 17-cClvlFim    = Classe de Valor Final                              ³±±
±±³          ³ 18-cMoeda      = Moeda	                                            ³±±
±±³          ³ 19-cSaldos     = Tipos de Saldo a serem processados                 ³±±
±±³          ³ 20-aSetOfBook  = Matriz de configuracao de livros                   ³±±
±±³          ³ 21-cSegmento   = Indica qual o segmento sera filtrado               ³±±
±±³          ³ 22-cSegIni     = Conteudo Inicial do segmento                       ³±±
±±³          ³ 23-cSegFim     = Conteudo Final do segmento                         ³±±
±±³          ³ 24-cFiltSegm   = Filtra por Segmento   		                       ³±±
±±³          ³ 25-lNImpMov    = Se Imprime Entidade sem movimento                  ³±±
±±³          ³ 26-lImpConta   = Se Imprime Conta                                   ³±±
±±³          ³ 27-nGrupo      = Grupo                                              ³±±
±±³          ³ 28-cHeader     = Identifica qual a Entidade Principal               ³±±
±±³          ³ 29-lImpAntLP   = Se imprime lancamentos Lucros e Perdas             ³±±
±±³          ³ 30-dDataLP     = Data da ultima Apuracao de Lucros e Perdas         ³±±
±±³          ³ 31-nDivide     = Divide valores por (100,1000,1000000)              ³±±
±±³          ³ 32-lVlrZerado  = Grava ou nao valores zerados no arq temporario     ³±±
±±³          ³ 33-cFiltroEnt  = Entidade Gerencial que servira de filtro dentro    ³±±
±±³          ³                  de outra Entidade Gerencial. Ex.: Centro de Custo  ³±±
±±³          ³                  sendo filtrado por Item Contabil (CTH)             ³±±
±±³          ³ 34-cCodFilEnt  = Codigo da Entidade Gerencial utilizada como filtro ³±±
±±³          ³ 35-cSegmentoG  = Filtra por Segmento Gerencial (CC/Item ou ClVl)    ³±±
±±³          ³ 36-cSegIniG    = Segmento Gerencial Inicial                         ³±±
±±³          ³ 37-cSegFimG    = Segmento Gerencial Final                           ³±±
±±³          ³ 38-cFiltSegmG  = Segmento Gerencial Contido em                      ³±±
±±³          ³ 39-lUsGaap     = Se e Balancete de Conversao de moeda               ³±±
±±³          ³ 40-cMoedConv   = Moeda para a qual buscara o criterio de conversao  ³±±
±±³          ³                  no Pl.Contas                                       ³±±
±±³          ³ 41-cConsCrit   = Criterio de conversao utilizado: 1-Diario, 2-Medio,³±±
±±³          ³                  3-Mensal, 4-Informada, 5-Plano de Contas           ³±±
±±³          ³ 42-dDataConv   = Data de Conversao                                  ³±±
±±³          ³ 43-nTaxaConv   = Taxa de Conversao                                  ³±±
±±³          ³ 44-aGeren      = Matriz que armazena os compositores do Pl. Ger.    ³±±
±±³          ³ 			        para efetuar o filtro de relatorio.                ³±±
±±³          ³ 45-lImpMov     = Nao utilizado                                      ³±±
±±³          ³ 46-lImpSint    = Se atualiza sinteticas                             ³±±
±±³          ³ 47-cFilUSU     = Filtro informado pelo usuario                      ³±±
±±³          ³ 48-lRecDesp0   = Se imprime saldo anterior do periodo anterior      ³±±
±±³          ³                  zerado                                             ³±±
±±³          ³ 49-cRecDesp    = Grupo de receitas e despesas                       ³±±
±±³          ³ 50-dDtZeraRD   = Data de zeramento de receitas e despesas           ³±±
±±³          ³ 51-lImp3Ent    = Se e Balancete C.Custo / Conta / Item              ³±±
±±³          ³ 52-lImp4Ent    = Se e Balancete por CC x Cta x Item x Cl.Valor      ³±±
±±³          ³ 53-lImpEntGer  = Se e Balancete de Entidade (C.Custo/Item/Cl.Vlr    ³±±
±±³          ³                  por Entid. Gerencial)                              ³±±
±±³          ³ 54-lFiltraCC   = Se considera o filtro das perguntas para C.Custo   ³±±
±±³          ³ 55-lFiltraIt   = Se considera o filtro das perguntas para Item      ³±±
±±³          ³ 56-lFiltraCV   = Se considera o filtro das perguntas para Cl.Valor  ³±±
±±³          ³ 57-cMoedaDsc   = Codigo da moeda para descricao das entidades       ³±±
±±³          ³ 58-lMovPeriodo = Se imprime movimento do periodo anterior           ³±±
±±³          ³ 59-aSelFil     = Array de filiais                                   ³±±
±±³          ³ 60-dDtCorte    = Data de Corte para calculo do saldo anterior       ³±±
±±³          ³ 61-lPlGerSint  = Imprime visao gerencial sintetica? Padrao .F.      ³±±
±±³          ³ 62-lConsSaldo  = Consolida saldo ? Padrao .F.                       ³±±
±±³          ³ 63-lCompEnt    = Consolida saldo entre entidades? Padrao .F.        ³±±
±±³          ³ 64-cArqAux     = Arquivo auxiliar permitindo a recursividade        ³±±
±±³          ³ 65-lUsaNmVis   = Usa nome da visao gerencial ? Padrao .F.           ³±±
±±³          ³ 66-cNomeVis    = Nome da visao gerencial (retorno, passar por ref.) ³±±
±±³          ³ 67-lCttSint    = Indica se imprime ou não C.Custo Sintéticos	       ³±±
±±³          ³ 68-cQuadroCTB  = CODIGO DO QUADRO CONTABIL                          ³±±
±±³          ³ 69-aEntidades  = Array com as entidades de inicio e fim   	       ³±±
±±³          ³            Ex. {'Cta Ent. 05 Inicio','Cta. Ent. 05 Final'}  	       ³±±  
±±³          ³ 70-cCodEntidade= Codigo da Entidade                      	       ³±±  
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XCTGerPla(	oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim,cAlias,cIdent,cContaIni,cContaFim,;
					cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,cSegmento,;
					cSegIni,cSegFim,cFiltSegm,lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,;
					nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,;
					lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,aGeren,lImpMov,lImpSint,cFilUSU,lRecDesp0,;
					cRecDesp,dDtZeraRD,lImp3Ent,lImp4Ent,lImpEntGer,lFiltraCC,lFiltraIt,lFiltraCV,cMoedaDsc,;
					lMovPeriodo,aSelFil,dDtCorte,lPlGerSint,lConsSaldo,lCompEnt,cArqAux,lUsaNmVis,cNomeVis,lCttSint,;
					lTodasFil,cQuadroCTB,aEntidades,cCodEntidade)

Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
Local aTamCC        := TAMSX3("CTT_CUSTO")
Local aTamCCRes 	:= TAMSX3("CTT_RES")
Local aTamItem  	:= TAMSX3("CTD_ITEM")
Local aTamItRes 	:= TAMSX3("CTD_RES")    
Local aTamClVl  	:= TAMSX3("CTH_CLVL")
Local aTamCvRes 	:= TAMSX3("CTH_RES")
Local aTamVal		:= TAMSX3("CT2_VALOR")

Local aCtbMoeda		:= {}
Local aSaveArea 	:= GetArea()
Local aCampos
Local cChave
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+cMoeda))
Local nTamItem		:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
Local nTamClVl		:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
Local nDecimais		:= 0
Local cCodigo		:= ""
Local cCodGer		:= ""
Local cEntidIni		:= ""
Local cEntidFim		:= ""           
Local cEntidIni1	:= ""
Local cEntidFim1	:= ""
Local cEntidIni2	:= ""
Local cEntidFim2	:= ""
Local cArqTmp1		:= ""
Local cMascaraG 	:= ""
Local lCusto		:= CtbMovSaldo("CTT")//Define se utiliza C.Custo
Local lItem 		:= CtbMovSaldo("CTD")//Define se utiliza Item
Local lClVl			:= CtbMovSaldo("CTH")//Define se utiliza Cl.Valor 
Local lAtSldBase	:= Iif(GetMV("MV_ATUSAL")== "S",.T.,.F.) 
Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
Local nInicio		:= Val(cMoeda)
Local nFinal		:= Val(cMoeda)
Local nCampoLP		:= 0
Local cFilDe		:= xFilial(cAlias)
Local cFilAte		:= xFilial(cAlias), nOrdem := 1
Local cCodMasc		:= ""
Local cMensagem		:= OemToAnsi("O plano gerencial ainda nao esta disponivel nesse relatorio.")// O plano gerencial ainda nao esta disponivel nesse relatorio. 
Local nPos			:= 0
Local nCont			:= 0 
Local lTemQuery		:= .F.
Local nX
Local lCriaInd		:= .F.
Local nTamFilial 	:= IIf( lFWCodFil, FWGETTAMFILIAL, 2 ) 
Local lCT1EXDTFIM	:= CtbExDtFim("CT1")
Local lCTTEXDTFIM	:= CtbExDtFim("CTT")
Local lCTDEXDTFIM	:= CtbExDtFim("CTD")
Local lCTHEXDTFIM	:= CtbExDtFim("CTH")

Local nSlAntGap		:= 0	// Saldo Anterior
Local nSlAntGapD	:= 0	// Saldo anterior debito
Local nSlAntGapC	:= 0	// Saldo anterior credito	
Local nSlAtuGap		:= 0	// Saldo Atual           
Local nSlAtuGapD	:= 0	// Saldo Atual debito
Local nSlAtuGapC	:= 0	// Saldo Atual credito
Local nSlDebGap		:= 0	// Saldo Debito
Local nSlCrdGap		:= 0	// Saldo Credito

Local aEntidIni		:= {}
Local aEntidFim		:= {}

#IFDEF TOP
	Local aStruTmp		:= {}
	Local lTemQry		:= .F.
	Local nTrb			:= 0	                              
#ENDIF

Local nDigitos		:= 0
Local nMeter		:= 0
Local nPosG			:= 0
Local nDigitosG		:= 0 
Local aAreaAnt		:= Nil  

Local _lCtbIsCube	:= FindFunction( "CtbIsCube" ) .And. CtbIsCube()
Local aTmpFil		:= {}

//Variaveis para atualizar a regua desde as rotinas de geracao do arquivo temporario
Private oMeter1 		:= oMeter
Private oText1 		:= oText

DEFAULT lConsSaldo   := .F.
DEFAULT lPlGerSint   := .F.
DEFAULT cSegmentoG 	:= ""
DEFAULT lUsGaap		:=.F.
DEFAULT cMoedConv	:= ""
DEFAULT	cConsCrit	:= ""
DEFAULT dDataConv	:= CTOD("  /  /  ")
DEFAULT nTaxaConv	:= 0
DEFAULT lImpSint	:= .T.                                              
DEFAULT lImpMov		:= .T.
DEFAULT cSegmento	:= ""
DEFAULT cFilUsu		:= ".T."
DEFAULT lRecDesp0	:= .F.
DEFAULT cRecDesp 	:= ""                
DEFAULT dDtZeraRD	:= CTOD("  /  /  ")
DEFAULT lImp3Ent	:= .F.
DEFAULT lImp4Ent	:= .F.
DEFAULT lImpEntGer	:= .F.
DEFAULT lImpConta	:= .T.
DEFAULT lFiltraCC	:= .F.
DEFAULT lFiltraIt	:= .F.
DEFAULT lFiltraCV	:= .F.
DEFAULT cMoedaDsc	:= '01'
DEFAULT lMovPeriodo := .F.
DEFAULT aSelFil 	:= {}
DEFAULT dDtCorte 	:= CTOD("  /  /  ")
DEFAULT lCompEnt	:= .F.
DEFAULT cArqAux		:= "cArqTmp"
DEFAULT cArqTmp 	:= Nil
DEFAULT lUsaNmVis	:= .F. 
DEFAULT lCttSint	:= .F.
DEFAULT cQuadroCTB:= ""
DEFAULT lTodasFil   := .F.
DEFAULT aEntidades  := {}
DEFAULT cCodEntidade:= ""
  
If FunName() == "CTBR561" .Or. FunName() == "CTBR502"  
	nTamCta := 100
Endif

__aTmpTCFil	:=	{}

If lRecDesp0 .And. ( Empty(cRecDesp) .Or. Empty(dDtZeraRD) )
	lRecDesp0 := .F.
EndIf

If FindFunction( "IsCtbJob" ) .And. IsCtbJob()
	DbSelectArea("CVO")
	CTBJobsStart()
	CheckCVO()
Endif

cIdent		:=	Iif(cIdent == Nil,'',cIdent)
nGrupo		:=	Iif(nGrupo == Nil,2,nGrupo)                                                 
cHeader		:= Iif(cHeader == Nil,'',cHeader)
cFiltroEnt	:= Iif(cFiltroEnt == Nil,"",cFiltroEnt)
cCodFilEnt	:= Iif(cCodFilEnt == Nil,"",cCodFilEnt)
Private nMin			:= 0
Private nMax			:= 0 

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
dMinData := CTOD("")

If ExistBlock("ESPGERPLAN")
	ExecBlock("ESPGERPLAN",.F.,.F.,{oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim,cAlias,cIdent,cContaIni,cContaFim,;
									cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,;
									cSegFim,cFiltSegm,lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,nDivide,lVlrZerado,;
									cFiltroEnt,cCodFilEnt,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,lUsGaap,cMoedConv,;
									cConsCrit,dDataConv,nTaxaConv,aGeren,lImpMov,lImpSint,cFilUSU,lRecDesp0,;
									cRecDesp,dDtZeraRD,lImp3Ent,lImp4Ent,lImpEntGer,lFiltraCC,lFiltraIt,lFiltraCV,aSelFil,dDtCorte,cQuadroCTB })

	Return(cArqTmp)
EndIf

If cAlias == 'CTY'	//Se for Balancete de 2 Entidades filtrando pela 3a Entidade.
	aCampos := {{ "ENTID1"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "ENTRES1"	, "C", aTamCtaRes[1],0 },;  			// Codigo Reduzido da Conta
				 { "DESCENT1"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
	 			 { "TIPOENT1"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico				 
 				 { "ENTSUP1"	, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
	   	         { "ENTID2"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "ENTRES2"	, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "DESCENT2"	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
				 { "TIPOENT2"	, "C", 01			, 0 },;				// Item Analitica / Sintetica			 
				 { "ENTSUP2"	, "C", aTamItem[1]	, 0 },; 			// Codigo do Item Superior
		 		 { "NORMAL"		, "C", 01			, 0 },;				// Situacao
				 { "SALDOANT"	, "N", aTamVal[1]+2, nDecimais},; 		// Saldo Anterior
	 		 	 { "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
			 	 { "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
			 	 { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", aTamVal[1]+2, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
			     { "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
		    	 { "IDENTIFI"	, "C", 01			, 0 },;			 
			     { "TOTVIS"		, "C", 01			, 0 },;			 
			     { "SLDENT"		, "C", 01			, 0 },;			 
			     { "FATSLD"		, "C", 01			, 0 },;			 
			     { "VISENT"		, "C", 01			, 0 },;			 
			  	 { "NIVEL1"		, "L", 01			, 0 }}				// Logico para identificar se eh de nivel 1 -> usado como totalizador do relatorio

ElseIf cAlias == 'CVY'	//Se for Balancete por cubo contabil

	aCampos := { { "ECX"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "ECXSUP"		, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "ECXNORMAL"	, "C", 01			, 0 },;				// Situacao
				 { "ECXRES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
				 { "ECXDESC"	, "C", nTamCta		, 0 },;  			// Descricao da Conta
				 { "ECY"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "ECYSUP"		, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "ECYNORMAL"	, "C", 01			, 0 },;				// Situacao
				 { "ECYRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "ECYDESC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
				 { "SALDOANT"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior
	   		 	 { "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
 				 { "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
				 { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", aTamVal[1]+1	, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
				 { "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
				 { "TIPOECX"	, "C", 01			, 0 },;				// Conta Analitica / Sintetica           
 				 { "TIPOECY"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
			     { "IDENTIFI"	, "C", 01			, 0 },;			 
			     { "TOTVIS"		, "C", 01			, 0 },;			 
			     { "SLDENT"		, "C", 01			, 0 },;			 
			     { "FATSLD"		, "C", 01			, 0 },;			 
			     { "VISENT"		, "C", 01			, 0 },;			 
   			     { "ESTOUR" 	, "C", 01			, 0 },;			 	//Define se a conta esta estourada ou nao
				 { "NIVEL1"		, "L", 01			, 0 },; 
			 	 { "NATCTA"     , "C", 02           , 0 }}             //NATCTA -campo de natureza da conta para relatorio CTBR047					 

																		// totalizador do relatorio
Else
	aCampos := { { "CONTA"		, "C", aTamConta[1], 0 },;  			// Codigo da Conta
				 { "SUPERIOR"	, "C", aTamConta[1], 0 },;				// Conta Superior
		 		 { "NORMAL"		, "C", 01			, 0 },;				// Situacao
				 { "CTARES"		, "C", aTamCtaRes[1], 0 },;  			// Codigo Reduzido da Conta
				 { "DESCCTA"	, "C", nTamCta		, 0 },;  			// Descricao da Conta        
				 { "CUSTO"		, "C", aTamCC[1]	, 0 },; 	 		// Codigo do Centro de Custo
				 { "CCRES"		, "C", aTamCCRes[1], 0 },;  			// Codigo Reduzido do Centro de Custo
				 { "DESCCC" 	, "C", nTamCC		, 0 },;  			// Descricao do Centro de Custo
		         { "ITEM"		, "C", aTamItem[1]	, 0 },; 	 		// Codigo do Item          
				 { "ITEMRES" 	, "C", aTamItRes[1], 0 },;  			// Codigo Reduzido do Item
				 { "DESCITEM" 	, "C", nTamItem		, 0 },;  			// Descricao do Item
	             { "CLVL"		, "C", aTamClVl[1]	, 0 },; 	 		// Codigo da Classe de Valor
    	         { "CLVLRES"	, "C", aTamCVRes[1], 0 },; 		 	// Cod. Red. Classe de Valor
				 { "DESCCLVL"   , "C", nTamClVl		, 0 },;  			// Descricao da Classe de Valor
				 { "SALDOANT"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior
	   		 	 { "SALDOANTDB"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Debito
 				 { "SALDOANTCR"	, "N", aTamVal[1]+2	, nDecimais},; 		// Saldo Anterior Credito
				 { "SALDODEB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Debito
				 { "SALDOCRD"	, "N", aTamVal[1]+2	, nDecimais },;  	// Credito
				 { "SALDOATU"	, "N", aTamVal[1]+1	, nDecimais },;  	// Saldo Atual               
				 { "SALDOATUDB"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Debito
				 { "SALDOATUCR"	, "N", aTamVal[1]+2	, nDecimais },;  	// Saldo Atual Credito
				 { "MOVIMENTO"	, "N", aTamVal[1]+2	, nDecimais },;  	// Movimento do Periodo
				 { "TIPOCONTA"	, "C", 01			, 0 },;				// Conta Analitica / Sintetica           
 				 { "TIPOCC"  	, "C", 01			, 0 },;				// Centro de Custo Analitico / Sintetico
	 			 { "TIPOITEM"	, "C", 01			, 0 },;				// Item Analitica / Sintetica			 
 				 { "TIPOCLVL"	, "C", 01			, 0 },;				// Classe de Valor Analitica / Sintetica			 
	 			 { "CCSUP"		, "C", aTamCC[1]	, 0 },;				// Codigo do Centro de Custo Superior
				 { "ITSUP"		, "C", aTamItem[1]	, 0 },;				// Codigo do Item Superior
	 			 { "CLSUP"	    , "C", aTamClVl[1] , 0 },;				// Codigo da Classe de Valor Superior
				 { "ORDEM"		, "C", 10			, 0 },;				// Ordem
				 { "GRUPO"		, "C", nTamGrupo	, 0 },;				// Grupo Contabil
			     { "IDENTIFI"	, "C", 01			, 0 },;			 
			     { "TOTVIS"		, "C", 01			, 0 },;			 
			     { "SLDENT"		, "C", 01			, 0 },;			 
			     { "FATSLD"		, "C", 01			, 0 },;			 
			     { "VISENT"		, "C", 01			, 0 },;			 
   			     { "ESTOUR" 	, "C", 01			, 0 },;			 	//Define se a conta esta estourada ou nao
				 { "NIVEL1"		, "L", 01			, 0 },; 
			 	 { "NATCTA"     , "C", 02           , 0 }}             //NATCTA -campo de natureza da conta para relatorio CTBR047					 
					                                                 	// Logico para identificar se 
																		// eh de nivel 1 -> usado como
	   		                                                           // totalizador do relatorio]
	   		                                                           
	If _lCtbIsCube	 
		aAreaAnt := GetArea() 
			DbSelectArea('CT0')
			DbSetOrder(1)
			If DbSeek( xFilial('CT0') + '05' )
				While CT0->(!Eof()) .And. CT0->CT0_FILIAL == xFilial('CT0') 
			   		                                                         
			      	AADD( aCampos,{ "CODENT"+CT0->CT0_ID	, "C", TamSx3(CT0->CT0_CPOCHV)[1]	, 0 } )
			      	AADD( aCampos,{ "DESCENT"+CT0->CT0_ID  	, "C", TamSx3(CT0->CT0_CPODSC)[1]	, 0 } )
			      	AADD( aCampos,{ "TIPOENT"+CT0->CT0_ID  	, "C", 01	, 0 } )    
			      	
					CT0->(DbSkip())			   		 	                                                        
				EndDo			   		                                                           
	   		EndIf                                                           
		RestArea(aAreaAnt)	   		      
	EndIf	   		                                                           

// Usado no mutacoes de patrimonio liquido inclui campo que alem da descricao da entidade
// Que esta no DESCCTA tem tambem a descricao da conta inicial CTS_CT1INI
	If 	Type("lTRegCts") # "U" .And. ValType(lTRegCts) = "L" .And. lTRegCts
		Aadd(aCampos, { "DESCORIG"	, "C", nTamCta		, 0 } )	// Descricao da Origem do Valor
	Endif
EndIf

Aadd(aCampos, { "FILIAL"	, "C", nTamFilial, 0 } )	// Cria Filial do Sistema

If CTS->(FieldPos("CTS_COLUNA")) > 0
	Aadd(aCampos, { "COLUNA"   	, "N", 01			, 0 })
EndIf

If 	Type("dSemestre") # "U" .And. ValType(dSemestre) = "D"
	Aadd(aCampos, { "SALDOSEM"	, "N", 17		, nDecimais }) 	// Saldo semestre
Endif

If Type("dPeriodo0") # "U" .And. ValType(dPeriodo0) = "D"
	Aadd(aCampos, { "SALDOPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
	Aadd(aCampos, { "MOVIMPER"	, "N", 17		, nDecimais }) 	// Saldo Periodo determinado
Endif

If Type("lComNivel") # "U" .And. ValType(lComNivel) = "L"
	Aadd(aCampos, { "NIVEL"   	, "N", 02			, 0 })		// Nivel hieraquirco - Quanto maior mais analitico
Endif	

If ( cAlias = "CT7" .And. SuperGetMv("MV_CTASUP") = "S" ) .Or. ;
	( cAlias = "CT3" .And. SuperGetMv("MV_CTASUP") = "S" ) .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTT" .And. GetNewPar("MV_CCSUP","")  == "S")  .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTD" .And. GetNewPar("MV_ITSUP","") == "S") .Or. ;
	(cAlias == "CTU" .And. cIdent == "CTH" .And. GetNewPar("MV_CLSUP","") == "S") 
	Aadd(aCampos, { "ORDEMPRN" 	, "N", 06			, 0 })		// Ordem para impressao
Endif

If lMovPeriodo
	Aadd(aCampos, { "MOVPERANT"		, "N" , 17			, nDecimais }) 	// Saldo Periodo Anterior
EndIf
     
///// TRATAMENTO PARA ATUALIZAÇÃO DE SALDO BASE
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
	dIniRep := ctod("")
  	If Need2Reproc(dDataFim,cMoeda,cSaldos,@dIniRep) 
		//Chama Rotina de Atualizacao de Saldos Basicos.
		oProcess := MsNewProcess():New({|lEnd|	CTBA190(.T.,dIniRep,dDataFim,cFilAnt,cFilAnt,cSaldos,.T.,cMoeda) },"","",.F.)
		oProcess:Activate()						
	EndIf
Endif	

//// TRATAMENTO PARA ATUALIZAÇÃO DE SALDOS COMPOSTOS ANTES DE EXECUTAR A QUERY DE FILTRAGEM
Do Case
Case cAlias == 'CTU'
	//Verificar se tem algum saldo a ser atualizado por entidade
	If cIdent == "CTT"
		cOrigem := 	'CT3'
	ElseIf cIdent == "CTD"
		cOrigem := 	'CT4'
	ElseIf cIdent == "CTH"
		cOrigem := 	'CTI'		
	Else
		cOrigem := 	'CTI'		
	Endif
Case cAlias == 'CTV'
	cOrigem := "CT4"
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTW'			
	cOrigem		:= 'CTI'	/// HEADER POR CLASSE DE VALORES
	//Verificar se tem algum saldo a ser atualizado
Case cAlias == 'CTX'			
	cOrigem		:= 'CTI'		
EndCase	
              
IF cAlias$("CTU/CTV/CTW/CTX")                                                                                                        

	Ct360Data(cOrigem,cAlias,@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,dDataFim,,,,,,,cFilAnt,,aSelFil,lTodasFil)

	If lAtSldCmp .And. !Empty(dMinData)	//Se atualiza saldos compostos
		oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt,aSelFil,lTodasFil,aTmpFil)},"","",.F.)
		oProcess:Activate()	
	Else		//Se nao atualiza os saldos compostos, somente da mensagem
		If !Empty(dMinData)
			cMensagem	:= "Os saldos compostos estao desatualizados...Favor atualiza-los "
			cMensagem	+= "atraves da rotina de saldos compostos	"		
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
			Return							//atraves da rotina de saldos compostos	
		EndIf    
	EndIf	
Endif

Do Case
 /************************************
   Consulta saldo pelo cubo contabil 
//************************************/
Case cAlias  == "CVY"
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	cCodMasc		:= aSetOfBook[2]
	cChave := "ECX+ECY"

	#IFDEF TOP   
		If TcSrvType() != "AS/400"                     			
			//Se nao tiver plano gerencial. 
			If Empty(aSetOfBook[5])
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				If cFilUsu == ".T."
					cFilUsu := ""
				EndIf
				U_XCtbRunC(dDataIni,dDataFim,cAlias,cEntidIni,cEntidFim,cCCIni,cCCFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUsu,cMoedaDsc,aSelFil,dDtCorte,lTodasFil,aTmpFil)
							
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif						
				lTemQuery := .T.
			Endif
		EndIf
	#ENDIF

Case cAlias  == "CT7"            
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	cCodMasc		:= aSetOfBook[2]
	If nGrupo == 2
		cChave := "CONTA"
	Else									// Indice por Grupo -> Totaliza por grupo
		cChave := "CONTA+GRUPO"
	EndIf

	#IFDEF TOP   
		If TcSrvType() != "AS/400"                     			
			//Se nao tiver plano gerencial. 
			If Empty(aSetOfBook[5])
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				If cFilUsu == ".T."
					cFilUsu := ""
				EndIf
				CT7BlnQry(dDataIni,dDataFim,cAlias,cEntidIni,cEntidFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUsu,cMoedaDsc,aSelFil,dDtCorte,lTodasFil,aTmpFil)
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif						
				lTemQuery := .T.
			Endif
		EndIf
	#ENDIF

Case cAlias == 'CT3'    
	cEntidIni	:= cCCIni
	cEntidFim	:= cCCFim

	If lImpConta	
		If cHeader == "CT1"
			cChave		:= "CONTA+CUSTO"
			cCodMasc	:= aSetOfBook[2]				
		Else
			If nGrupo == 2
				cChave   := "CUSTO+CONTA"                      
			Else									// Indice por Grupo -> Totaliza por grupo
				cChave := "CUSTO+CONTA+GRUPO"
			EndIf	
			cCodMasc	:= aSetOfBook[2]					
			cMascaraG	:= aSetOfBook[6]			
		Endif
	Else		//Balancete de Centro de Custo (filtrando por conta) 
		cChave	:= "CUSTO"
		cCodMasc:= aSetOfBook[6]
	EndIf

	#IFDEF TOP
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			If cFilUsu == ".T."
				cFilUsu := ""
			EndIf
			If lImpConta
				IF !lCompEnt
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT3BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,lTodasFil,aTmpFil)						
				Else
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT3BlnQryC(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,,aTmpFil)
				Endif
			Else
				Ct3Bln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cMoeda,;
					cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
							lRecDesp0,cRecDesp,dDtZeraRD,aSelFil,lTodasFil,aTmpFil)	
			EndIf						
			lTemQuery := .T.
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif												
		EndIf
	#ENDIF		

Case cAlias =='CT4' 
	If lImp3Ent	//Balancete CC / Conta / Item
		If cHeader == "CTT"
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CT4Bln3Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,lTodasFil,aTmpFil)
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif	
				EndIf
			#ENDIF		
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cChave		:= "CUSTO+CONTA+ITEM"
			cCodMasc	:= aSetOfBook[2]
		EndIf	
	Else
		cEntidIni	:= cItemIni
		cEntidFim	:= cItemFim
		If lImpConta
			If cHeader == "CT1"	//Se for for Balancete Conta x Item
				cChave	:= "CONTA+ITEM"
				cCodMasc		:= aSetOfBook[4]			
			Else
				cChave   := "ITEM+CONTA"	
				cCodMasc		:= aSetOfBook[2]					
			EndIf	
		Else	//Balancete de Item filtrando por conta
			cChave		:= "ITEM"
			cCodMasc	:= aSetOfBook[7]
		EndIf
		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			If cFilUsu == ".T."
				cFilUsu := ""
			EndIf
			If lImpConta
				/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
				CT4BlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cItemIni,cItemFim,cMoeda,;
							cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,lTodasFil,aTmpFil)
			Else
				Ct4Bln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
							cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
							lRecDesp0,cRecDesp,dDtZeraRD,aSelFil,lTodasFil,aTmpFil)	
			EndIf
			lTemQuery := .T.
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif												
			EndIf
		#ENDIF	
	EndIf
Case cAlias == 'CTI'     
	If lImp4Ent	//Balancete CC x Cta x Item x Cl.Valor
		If cHeader == "CTT"             
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5]) .and. !lImpAntLP
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CTIBln4Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
								cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,aSelFil,lTodasFil,aTmpFil)
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF				
			cChave		:= "CUSTO+CONTA+ITEM+CLVL"
			cEntidIni	:= cCCIni
			cEntidFim	:= cCCFim
			cCodMasc	:= aSetOfBook[2]			
		EndIf	
	Else
		cEntidIni	:= cClVlIni
		cEntidFim	:= cClvlFim
	
		If lImpConta
			If cHeader == "CT1"
				cChave		:= "CONTA+CLVL"
				cCodMasc	:= aSetOfBook[2]				
			Else		
				cChave   := "CLVL+CONTA"
			EndIf     
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])							
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
					CTIBlnQry(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cClVlIni,cClVlFim,cMoeda,;
								cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLp,dDataLP,cFilUSU,aSelFil,lTodasFil,aTmpFil)
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF							
		Else	//Balancete de Cl.Valor filtrando por conta
			cChave   := "CLVL"
			cCodMasc := aSetOfBook[8]	
			#IFDEF TOP
				If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])			
					If cFilUsu == ".T."
						cFilUsu := ""
					EndIf
					CtIBln1Ent(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,;
								cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,;
								lRecDesp0,cRecDesp,dDtZeraRD,aSelFil,lTodasFil,aTmpFil)	
					lTemQuery := .T.
					If Empty(cFilUSU)
						cFILUSU := ".T."
					Endif															
				EndIf
			#ENDIF							
		EndIf
	EndIf
Case cAlias == 'CTU'
	If cIdent == 'CTT'
		cEntidIni	:= cCCIni
		cEntidFim	:= cCCFim	
		cChave		:= "CUSTO"
		cCodMasc		:= aSetOfBook[6]		
	ElseIf cIdent == 'CTD'
		cEntidIni	:= cItemIni
		cEntidFim	:= cItemFim		
		cChave   := "ITEM"
		cCodMasc		:= aSetOfBook[7]		
	ElseIf cIdent == 'CTH'
		cEntidIni	:= cClVlIni
		cEntidFim	:= cClvlFim		
		cChave   := "CLVL"
		cCodMasc		:= aSetOfBook[8]		
	Endif
	#IFDEF TOP  
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])
			/// EXECUTA QUERY RETORNANDO A ESTRUTURA E SALDOS NO ALIAS TRBTMP
			If cFilUsu == ".T."
				cFilUsu := ""
			EndIf
			CTUBlnQry(dDataIni,dDataFim,cAlias,cIdent,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,aSelFil,lTodasFil,aTmpFil)
			lTEmQuery := .T.
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif								
		EndIf
	#ENDIF	
Case cAlias == 'CTV'           
	If cHeader == 'CTT'
		cChave   := "CUSTO+ITEM"	
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim
	ElseIf cHeader == 'CTD'
		cChave   := "ITEM+CUSTO"	
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim
	EndIf
Case cAlias == 'CTW'
	If cHeader	== 'CTT'
		cChave   := "CUSTO+CLVL"			
		cEntidIni1	:=	cCCIni
		cEntidFim1	:=	cCCFim 	            		
		cEntidIni2	:=	cClVlIni
		cEntidFim2	:=	cClVlFim		
	ElseIf cHeader == 'CTH'                
		cChave   := "CLVL+CUSTO"			
		cEntidIni1	:=	cClVlIni
		cEntidFim1	:=	cClVlFim
		cEntidIni2	:=	cCCIni
		cEntidFim2	:=	cCCFim 	
	EndIf	
Case cAlias == 'CTX'
	If cHeader == 'CTD'
		cChave  	 := "ITEM+CLVL"			
		cEntidIni1	:= 	cItemIni
		cEntidFim1	:= 	cItemFim
		cEntidIni2	:= 	cClVlIni
		cEntidFim2	:= 	cClVlFim		
	ElseIf cHeader == 'CTH'
		cChave  	 := "CLVL+ITEM"			
		cEntidIni1	:= 	cClVlIni
		cEntidFim1	:= 	cClVlFim			
		cEntidIni2	:= 	cItemIni 	
		cEntidFim2	:= 	cItemFim 	
	EndIf                                
Case cAlias	== 'CTY'
	cChave			:="ENTID1+ENTID2"
	If cHeader == 'CTT' .And. cFiltroEnt == 'CTD'	
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cClVlIni
		cEntidFim2	:= cClvlFim
	ElseIf cHeader == 'CTT' .And. cFiltroEnt == 'CTH'
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTT'
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cClVlIni
		cEntidFim2	:= cClVlFim	
	ElseIf cHeader == 'CTD' .And. cFiltroEnt == 'CTH'
		cEntidIni1	:= cItemIni
		cEntidFim1	:= cItemFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTT'
		cEntidIni1	:= cClVlIni
		cEntidFim1	:= cClVlFim	
		cEntidIni2	:= cItemIni
		cEntidFim2	:= cItemFim		
	ElseIf cHeader == 'CTH' .And. cFiltroEnt == 'CTD'
		cEntidIni1	:= cClVlIni
		cEntidFim1	:= cClVlFim	
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim					
	EndIf		
EndCase

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	If cAlias $ "CT3/CT4/CTI"		//Se for Balancete Entidade/Entidade Gerencial
		Do Case
		Case cAlias == "CT3"
			cChave	:= "CUSTO+CONTA"			
		Case cAlias == "CT4"
			cChave	:= "ITEM+CONTA"						
		Case cAlias == "CTI"
			cChave	:= "CLVL+CONTA"						
		EndCase		
	ElseIf cAlias = 'CTU'
		Do Case
		Case cIdent = 'CTT'
			cChave	:= "CUSTO"		
		Case cIdent = 'CTD'
			cChave	:= "ITEM"		
		Case cIdent = 'CTH'
			cChave	:= "CLVL"		
		EndCase	
	ElseIf cAlias  == "CVY"
		cChave := "ECX+ECY"	
	Else 
		If _lCtbIsCube        
			If !Empty(cCodEntidade)
			   cChave	:= "CODENT"+cCodEntidade
			Else
			   cChave	:= "CONTA"			
			EndIf			   
		Else
		   cChave	:= "CONTA"		
		EndIF		   
	EndIf  
Endif


If Empty( aCampos )
	ConOut("Erro na criacao da tabela temporaria")
	Return .F.
EndIf

cArqTmp := CriaTrab(aCampos, .T.)
dbUseArea( .T.,, cArqTmp, cArqAux, .F., .F. )
lCriaInd := .T.

DbSelectarea(cArqAux)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCriaInd
	cArqInd	:= CriaTrab(Nil, .F.)
	IndRegua(cArqAux,cArqInd,cChave,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

	If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
		cArqTmp1 := CriaTrab(, .F.)
		IndRegua(cArqAux,cArqTmp1,"ORDEM",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
	Endif	
	
	dbSelectArea(cArqAux)
	DbClearIndex()
	dbSetIndex(cArqInd+OrdBagExt())
	
	If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
		dbSetIndex(cArqTmp1+OrdBagExt())
	Endif
Endif
#IFDEF TOP
	If FunName() <> "CTBR195" .or. (FunName() == "CTBR195" .and. !lImpAntLP)
		//// SE FOR DEFINIÇÃO TOP 
		If TcSrvType() != "AS/400" .and. lTemQuery .and. Select("TRBTMP") > 0 	/// E O ALIAS TRBTMP ESTIVER ABERTO (INDICANDO QUE A QUERY FOI EXECUTADA)							
			If !Empty(cSegmento)
				If Len(aSetOfBook) == 0 .or. Empty(aSetOfBook[1])
					Help("CTN_CODIGO")
					Return(cArqTmp)
				Endif
				dbSelectArea("CTM")
				dbSetOrder(1)
				If MsSeek(xFilial()+cCodMasc)
					While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cCodMasc
						nPos += Val(CTM->CTM_DIGITO)
						If CTM->CTM_SEGMEN == strzero(val(cSegmento),2)
							nPos -= Val(CTM->CTM_DIGITO)
							nPos ++
							nDigitos := Val(CTM->CTM_DIGITO)      
							Exit
						EndIf	
						dbSkip()
					EndDo	
				Else
					Help("CTM_CODIGO")
					Return(cArqTmp)
				EndIf	
			EndIf	
			
			If cAlias == "CT3" .And. cHeader == "CTT" .And. !Empty(cMascaraG)
				If !Empty(cSegmentoG)
					dbSelectArea("CTM")
					dbSetOrder(1)
					If MsSeek(xFilial()+cMascaraG)
						While !Eof() .And. CTM->CTM_FILIAL == xFilial() .And. CTM->CTM_CODIGO == cMascaraG
							nPosG += Val(CTM->CTM_DIGITO)
							If CTM->CTM_SEGMEN == cSegmentoG
								nPosG -= Val(CTM->CTM_DIGITO)
								nPosG ++
								nDigitosG := Val(CTM->CTM_DIGITO)      
								Exit
							EndIf	
							dbSkip()
						EndDo	
					EndIf	
				EndIf		
			EndIf	
			
  			dbSelectArea("TRBTMP")
			aStruTMP := dbStruct()			/// OBTEM A ESTRUTURA DO TMP

			nCampoLP	 := Ascan(aStruTMP,{|x| x[1]=="SLDLPANTDB"})
			dbSelectArea("TRBTMP")
			If ValType(oMeter) == "O"				
				oMeter:SetTotal(TRBTMP->(RecCount()))
				oMeter:Set(0)
			EndIf

			dbGoTop()						/// POSICIONA NO 1º REGISTRO DO TMP
			While TRBTMP->(!Eof())			/// REPLICA OS DADOS DA QUERY (TRBTMP) PARA P/ O TEMPORARIO EM DISCO
		
				//Se nao considera apuracao de L/P sera verificado na propria query
				dbSelectArea("TRBTMP")								
				If !lVlrZerado .And. lImpAntLP
					If TRBTMP->((SALDOANTDB - SLDLPANTDB) - (SALDOANTCR - SLDLPANTCR)) == 0 .And. ;
						TRBTMP->(SALDODEB-MOVLPDEB) == 0 .And. TRBTMP->(SALDOCRD-MOVLPCRD) == 0					
						dbSkip()
						Loop  				
					EndIf				
				ElseIf !lVlrZerado
					If TRBTMP->(SALDOANTDB - SALDOANTCR) == 0 .And. TRBTMP->SALDODEB == 0 .And. TRBTMP->SALDOCRD == 0
						dbSkip()
						Loop				
					EndIf								
				EndIf					

				//Verificacao da  Data Final de Existencia da Entidade somente se imprime saldo zerado 
				// e se realemten nao tiver saldo e movimento para a entidade. Caso tenha algum movimento
				//ou saldo devera imprimir.  												
				If lVlrZerado 
					If lImpAntLP 					
						If ((SALDOANTDB - SLDLPANTDB) == 0 .And. (SALDOANTCR - SLDLPANTCR) == 0 .And. ;
							(SALDODEB-MOVLPDEB) == 0 .And. (SALDOCRD-MOVLPCRD) == 0)
							//Se a data de existencia final  da entidade estiver preenchida e a data inicial do
							//relatorio for maior, nao ira imprimir a entidade. 
							If  cAlias $ "CT7/CT3/CT4/CTI" 
								If lCT1EXDTFIM .AND. type( 'TRBTMP->CT1DTEXSF' ) # 'U'
									IF !Empty(TRBTMP->CT1DTEXSF) .And. (dDataIni > TRBTMP->CT1DTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf
								EndIf
							Endif
							
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTTEXDTFIM .and. type( 'TRBTMP->CTTDTEXSF' ) # 'U'
									If !Empty(TRBTMP->CTTDTEXSF) .And. (dDataIni > TRBTMP->CTTDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf                     
								Endif
							EndIf                               
					
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTDEXDTFIM .AND. type( 'TRBTMP->CTDDTEXSF' ) # 'U'
									IF !Empty(TRBTMP->CTDDTEXSF) .And. (dDataIni > TRBTMP->CTDDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf
			                    EndIf                           
			      			Endif

							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
								If lCTHEXDTFIM .AND. type( 'TRBTMP->CTHDTEXSF' ) # 'U'
									If !Empty(TRBTMP->CTHDTEXSF) .And. (dDataIni > TRBTMP->CTHDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									Endif
								EndIf
							EndIf 										
						EndIf
					Else                            
						If (SALDOANTDB  == 0 .And. SALDOANTCR  == 0 .And. SALDODEB == 0 .And. SALDOCRD == 0) 
							If cAlias $ "CT7/CT3/CT4/CTI" .AND. type( 'TRBTMP->CT1DTEXSF' ) # 'U'
				 				If lCT1EXDTFIM .AND. !Empty(TRBTMP->CT1DTEXSF) .And. (dDataIni > TRBTMP->CT1DTEXSF)  
									dbSelectArea("TRBTMP")
									dbSkip()
									Loop													
								EndIf																								
							EndIf                                                               																
							
							If cAlias == "CT3" .Or. ( cAlias == "CTU" .And. cIdent == "CTT") .Or. ( cAlias == "CTI" .And. lImp4Ent)
								If lCTTEXDTFIM .AND. type( 'TRBTMP->CTTDTEXSF' ) # 'U'
									IF !Empty(TRBTMP->CTTDTEXSF) .And. (dDataIni > TRBTMP->CTTDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									Endif
								EndIf							
							EndIf														
						
							If cAlias == "CT4" .Or. ( cAlias == "CTU" .And. cIdent == "CTD")  .Or. ( cAlias == "CTI" .And. lImp4Ent)
					 			If lCTDEXDTFIM .AND. type( 'TRBTMP->CTDDTEXSF' ) # 'U'
					 				IF !Empty(TRBTMP->CTDDTEXSF) .And. (dDataIni > TRBTMP->CTDDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop
									EndIf   
								Endif
		                    EndIf                           
		
							If cAlias == "CTI"	.Or. ( cAlias == "CTU" .And. cIdent == "CTH")
					 			If lCTHEXDTFIM .AND. type( 'TRBTMP->CTHDTEXSF' ) # 'U' 
					 				IF !Empty(TRBTMP->CTHDTEXSF) .And. (dDataIni > TRBTMP->CTHDTEXSF)  
										dbSelectArea("TRBTMP")
										dbSkip()
										Loop													
									EndIf
								Endif
							EndIf	                    								
						EndIf
					EndIf
				EndIf
			
				If cAlias == "CTU"              
					Do Case
					Case cIdent	== "CTT"
						cCodigo	:= TRBTMP->CUSTO
					Case cIdent	== "CTD"
						cCodigo	:= TRBTMP->ITEM
					Case cIdent	== "CTH"
						cCodigo	:= TRBTMP->CLVL					
					EndCase                   
				Else
					If lImpConta .Or. cAlias == "CT7"
						cCodigo	:= TRBTMP->CONTA
					Else
						If cAlias == "CT3"
							cCodigo	:= TRBTMP->CUSTO							
						ElseIf cAlias == "CT4"
							cCodigo	:= TRBTMP->ITEM							
						ElseIf cAlias == "CTI"
							cCodigo	:= TRBTMP->CLVL												
						EndIf
					EndIf
					If cAlias == "CT3" .And. cHeader == "CTT"
						cCodGer	:= TRBTMP->CUSTO						
					EndIf
				EndIf
			
				If !Empty(cSegmento)
					If Empty(cSegIni) .And. Empty(cSegFim) .And. !Empty(cFiltSegm)
						If  !(Substr(cCodigo,nPos,nDigitos) $ (cFiltSegm) ) 
							dbSkip()
							Loop
						EndIf	
					Else
						If Substr(cCodigo,nPos,nDigitos) < Alltrim(cSegIni) .Or. ;
							Substr(cCodigo,nPos,nDigitos) > Alltrim(cSegFim)
							dbSkip()
							Loop
						EndIf	
					Endif
				EndIf		

				//Caso faca filtragem por segmento gerencial,verifico se esta dentro 
				//da solicitacao feita pelo usuario. 
				If cAlias == "CT3" .And. cHeader == "CTT"
					If !Empty(cSegmentoG)
						If Empty(cSegIniG) .And. Empty(cSegFimG) .And. !Empty(cFiltSegmG)
							If  !(Substr(cCodGer,nPosG,nDigitosG) $ (cFiltSegmG) ) 
								dbSkip()
								Loop
							EndIf	
						Else
		 					If Substr(cCodGer,nPosG,nDigitosG) < Alltrim(cSegIniG) .Or. ;
								Substr(cCodGer,nPosG,nDigitosG) > Alltrim(cSegFimG)
								dbSkip()
								Loop
							EndIf	
						Endif
					EndIf						
				EndIf
									
				If &("TRBTMP->("+cFILUSU+")")				
					RecLock(cArqAux,.T.)   
					
					For nTRB := 1 to Len(aStruTMP)
						Field->&(aStruTMP[nTRB,1]) := TRBTMP->&(aStruTMP[nTRB,1])			
						If Subs(aStruTmp[nTRB][1],1,6) $ "SALDODEB/SALDOCRD/SALDOANTDB/SALDOANTCR/SLDLPANTCR/SLDLPANTDB/MOVLPDEB/MOVLPCRD" .And. nDivide > 0 
							Field->&(aStruTMP[nTRB,1])	:=((TRBTMP->&(aStruTMP[nTRB,1])))/ndivide                   
						EndIf										
					Next                    
					(cArqAux)->FILIAL	:= cFilAnt 
			
					If cAlias	== "CTU"            
						Do Case
						Case cIdent	== "CTT"
						    If Empty(TRBTMP->DESCCC)
								(cArqAux)->DESCCC		:= TRBTMP->DESCCC01
						    EndIf						    
						Case cIdent == "CTD"
							If Empty(TRBTMP->DESCITEM)
								(cArqAux)->DESCITEM	:= TRBTMP->DESCIT01							
							EndIf						
						Case cIdent == "CTH"
							If Empty(TRBTMP->DESCCLVL)							
								(cArqAux)->DESCCLVL	:= TRBTMP->DESCCV01							
							EndIf						
						EndCase					
					Else
						If lImpConta .or. cAlias == "CT7"
							If Empty(TRBTMP->DESCCTA) .AND. TRBTMP->(FieldPos( "DESCCTA01" )) > 0 .AND. !Empty(TRBTMP->DESCCTA01)
								(cArqAux)->DESCCTA	:= TRBTMP->DESCCTA01
							EndIf
						EndIf
			             
						If cAlias == "CT4"            
							If !lImp3Ent 
								If cMoeda <> '01' .And. Empty(TRBTMP->DESCITEM)
									(cArqAux)->DESCITEM	:= TRBTMP->DESCIT01
								EndIf    
							EndIf    
								
							If lImp3Ent	//Balancete CC / Conta / Item								             
								If Empty(TRBTMP->DESCCC)
									(cArqAux)->DESCCC	:= TRBTMP->DESCCC01
								EndIf        								
								
								If TRBTMP->ALIAS == 'CT4'
									If Empty(TRBTMP->DESCITEM)
										(cArqAux)->DESCITEM	:= TRBTMP->DESCIT01																			
								    EndIf
								EndIf
							EndIf
						EndIf
						
						If cAlias == "CTI" .And. lImp4Ent
							If !Empty(CLVL)
								If Empty(TRBTMP->DESCCLVL)							
									(cArqAux)->DESCCLVL	:= TRBTMP->DESCCV01							
								EndIf						
							EndiF
							
						    If !Empty(ITEM)
								If Empty(TRBTMP->DESCITEM)
									(cArqAux)->DESCITEM	:= TRBTMP->DESCIT01
								EndIf
							Endif
							                           
							If !Empty(CUSTO)
							    If Empty(TRBTMP->DESCCC)
									(cArqAux)->DESCCC		:= TRBTMP->DESCCC01													    
							    EndIf						    
							EndIf					
						EndIf
					EndIf
					
							//Se for Relatorio US Gaap
					If lUsGaap
					
						nSlAntGap	:= TRBTMP->(SALDOANTDB - SALDOANTCR)	// Saldo Anterior
						nSlAntGapD	:= TRBTMP->(SALDOANTDB)					// Saldo anterior debito
						nSlAntGapC	:= TRBTMP->(SALDOANTCR)					// Saldo anterior credito	
						nSlAtuGap	:= TRBTMP->((SALDOANTDB+SALDODEB)- (SALDOANTCR+SALDOCRD))	// Saldo Atual           
						nSlAtuGapD	:= TRBTMP->(SALDOANTDB+SALDODEB)					// Saldo Atual debito
						nSlAtuGapC	:= TRBTMP->(SALDOANTCR+SALDOCRD)					// Saldo Atual credito
						
			            nSlDebGap	:= TRBTMP->((SALDOANTDB+SALDODEB) - SALDOANTDB)		// Saldo Debito
			            nSlCrdGap	:= TRBTMP->((SALDOANTCR+SALDOCRD) - SALDOANTCR)		// Saldo Credito
					
						If cConsCrit == "5"	//Se for Criterio do Plano de Contas
							cCritPlCta	:= Ctr045Med(cMoedConv)
						EndIf
			
						If cConsCrit $ "123" .Or. (cConsCrit == "5" .And. cCritPlCta $ "123")
							If cConsCrit == "5"					
								(cArqAux)->SALDOANT	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGap)					
								(cArqAux)->SALDOANTDB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapD)										
								(cArqAux)->SALDOANTCR	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)					
								(cArqAux)->SALDOATU	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGap)					
								(cArqAux)->SALDOATUDB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAtuGapD)					
								(cArqAux)->SALDOATUCR	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlAntGapC)									
								(cArqAux)->SALDODEB	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlDebGap)									
								(cArqAux)->SALDOCRD	:= CtbConv(cCritPlCta,dDataConv,cMoedConv,nSlCrdGap)														
							Else
								(cArqAux)->SALDOANT	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGap)					
								(cArqAux)->SALDOANTDB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapD)										
								(cArqAux)->SALDOANTCR	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)					
								(cArqAux)->SALDOATU	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGap)					
								(cArqAux)->SALDOATUDB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAtuGapD)					
								(cArqAux)->SALDOATUCR	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlAntGapC)									
								(cArqAux)->SALDODEB	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlDebGap)									
								(cArqAux)->SALDOCRD	:= CtbConv(cConsCrit,dDataConv,cMoedConv,nSlCrdGap)													
							EndIf        
						ElseIf cConsCrit == "4" .Or. (cConsCrit == "5" .And. cCritPlCta == "4")	
							(cArqAux)->SALDOANT	:= nSlAntGap/nTaxaConv
							(cArqAux)->SALDOANTDB	:= nSlAntGapD/nTaxaConv 
							(cArqAux)->SALDOANTCR	:= nSlAntGapC/nTaxaConv 
							(cArqAux)->SALDOATU	:= nSlAtuGap/nTaxaConv 
							(cArqAux)->SALDOATUDB	:= nSlAtuGapD/nTaxaConv 
							(cArqAux)->SALDOATUCR	:= nSlAtuGapC/nTaxaConv  
							(cArqAux)->SALDODEB	:= nSlDebGap/nTaxaConv
							(cArqAux)->SALDOCRD	:= nSlCrdGap/nTaxaConv			
						EndIf			
					EndIf		        		
				
					If !(!Empty( dDtCorte) .and. Substr((cArqAux)->ECX,1,1)>="4")
						If nCampoLP > 0 
							(cArqAux)->SALDOANTDB	:= SALDOANTDB - SLDLPANTDB
							(cArqAux)->SALDOANTCR	:= SALDOANTCR - SLDLPANTCR
							(cArqAux)->SALDODEB	:= SALDODEB - MOVLPDEB
							(cArqAux)->SALDOCRD	:= SALDOCRD - MOVLPCRD
						EndIf					
				 		
				 		(cArqAux)->SALDOANT	:= SALDOANTCR - SALDOANTDB
						(cArqAux)->SALDOATUDB	:= SALDOANTDB + SALDODEB
						(cArqAux)->SALDOATUCR	:= SALDOANTCR + SALDOCRD 				 	
						(cArqAux)->SALDOATU	:= SALDOATUCR - SALDOATUDB			
						(cArqAux)->MOVIMENTO	:= SALDOCRD   - SALDODEB			
					Else 
						nSaldoCrt := 0

						If lImpAntLP .And. nCampoLP > 0  
							IF Type( "(cArqAux)->SLLPATCTDB" ) # "U" .AND.Type( "(cArqAux)->SLLPATCTCR" ) # "U" 
								nSaldoCrt := ((cArqAux)->SLLPATCTDB - (cArqAux)->SLLPATCTCR)
							Endif

							(cArqAux)->SALDOANTDB	:= (SALDOANTDB - SLDLPANTDB ) + iif( nSaldoCrt > 0 , Abs( nSaldoCrt ) , 0 ) 
							(cArqAux)->SALDOANTCR	:= (SALDOANTCR - SLDLPANTCR ) + iif( nSaldoCrt < 0 , Abs( nSaldoCrt ) , 0 ) 
							(cArqAux)->SALDODEB	:= SALDODEB - MOVLPDEB
							(cArqAux)->SALDOCRD	:= SALDOCRD - MOVLPCRD
						Else
							IF Type( "(cArqAux)->SLDANTCTDB" ) # "U" .AND.Type( "(cArqAux)->SLDANTCTCR" ) # "U" 
								nSaldoCrt := ((cArqAux)->SLDANTCTDB - (cArqAux)->SLDANTCTCR)
							Endif

							(cArqAux)->SALDOANTDB	:= SALDOANTDB + iif( nSaldoCrt > 0 , Abs( nSaldoCrt ) , 0 ) 
							(cArqAux)->SALDOANTCR	:= SALDOANTCR + iif( nSaldoCrt < 0 , Abs( nSaldoCrt ) , 0 ) 
						EndIf					
				 		
				 		(cArqAux)->SALDOANT	:= SALDOANTCR - SALDOANTDB
						(cArqAux)->SALDOATUDB	:= SALDOANTDB + SALDODEB
						(cArqAux)->SALDOATUCR	:= SALDOANTCR + SALDOCRD 				 	
						(cArqAux)->SALDOATU	:= SALDOATUCR - SALDOATUDB			
						(cArqAux)->MOVIMENTO	:= SALDOCRD   - SALDODEB			    
					
					Endif
					
					
				    //Se imprime saldo anterior do periodo anterior zerado, verificar o saldo atual da data de zeramento.                
					If ( lImpConta .Or. cAlias == "CT7") .And. lRecDesp0 .And. Subs(TRBTMP->CONTA,1,1) $ cRecDesp		
					
						If cAlias == "CT7" .Or. ( cAlias == "CT3" .And. cHeader == "CT1" )
							aSldRecDes	:= SaldoCT7Fil(TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.,nil,aSelFil,nil,lTodasFil)		
						ElseIf cAlias == "CT3" .And. cHeader == "CTT"
							aSldRecDes	:= SaldoCT3Fil(TRBTMP->CONTA,TRBTMP->CUSTO,dDtZeraRD,cMoeda,cSaldos,'CTBXFUN',.F.,Nil,aSelFil,lTodasFil)									
						ElseIf cAlias == "CT4" .And. cHeader == "CTD"
							cCusIni		:= ""
							cCusFim		:= Repl("Z",aTamCC[1])
							aSldRecDes	:= SaldTotCT4(TRBTMP->ITEM,TRBTMP->ITEM,cCusIni,cCusFim,TRBTMP->CONTA,TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,aSelFil,,,,,,,,lTodasFil)
						Elseif cAlias == "CTI" .And. cHeader == "CTH"
							cCusIni		:= ""
							cCusFim		:= Repl("Z",aTamCC[1])
							
							cItIni  	:= ""
							cItFim   	:= Repl("z",aTamItem[1])
					
							aSldRecDes := SaldTotCTI(TRBTMP->CLVL,TRBTMP->CLVL,cItIni,cItFim,cCusIni,cCusFim,;
							TRBTMP->CONTA,TRBTMP->CONTA,dDtZeraRD,cMoeda,cSaldos,aSelFil,,,,,,,,lTodasFil)
						EndIf                        

						If nDivide > 1
							For nCont := 1 To Len(aSldRecDes)
								aSldRecDes[nCont] := Round(NoRound((aSldRecDes[nCont]/nDivide),3),2)
							Next nCont		
						EndIf								

						nSldRDAtuD	:=	aSldRecDes[4] 
						nSldRDAtuC	:=	aSldRecDes[5]
						nSldAtuRD	:= nSldRDAtuC - nSldRDAtuD			
                                                
						(cArqAux)->SALDOANT		-= nSldAtuRD
						(cArqAux)->SALDOANTDB	-= nSldRDAtuD
						(cArqAux)->SALDOANTCR	-= nSldRDAtuC 	
						(cArqAux)->SALDOATU		-= nSldAtuRD
						(cArqAux)->SALDOATUDB	-= nSldRDAtuD
						(cArqAux)->SALDOATUCR	-= nSldRdAtuC			
					EndIf                        

					IF (cArqAux)->( FieldPos( "NATCTA" ) ) > 0
						(cArqAux)->NATCTA := NATCTA   // Faz retorno do campo CT1_NATCTA
					Endif

					(cArqAux)->(MsUnlock())
				EndIf					
				TRBTMP->(dbSkip())     
				nMeter++
				if nMeter%1000 = 0           // AQUI
					If ValType(oMeter) == "O"
				    	oMeter:Set(nMeter)				
				  	EndIf
			  	Endif
			Enddo

			dbSelectArea("TRBTMP")
			dbCloseArea()					/// FECHA O TRBTMP (RETORNADO DA QUERY)
			lTemQry := .T.
		Endif
	EndIf
#ENDIF


dbSelectArea(cArqAux)
dbSetOrder(1)

If cAlias $ 'CT3/CT4/CTI' //Se imprime CONTA+ ENTIDADE
	If !Empty(aSetOfBook[5])
		If !lImpConta	//Se for balancete de 1 entidade filtrada por conta
			If cAlias == "CT3"
				cIdent	:= "CTT"
			ElseIf cAlias == "CT4"
				cIdent	:= "CTD"			
			ElseIf cAlias == "CTI"
				cIdent 	:= "CTH"
			EndIf
			// Monta Arquivo Lendo Plano Gerencial                                   
			// Neste caso a filtragem de entidades contabeis é desprezada!
			CtbPlGeren(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,"CTU",;
						cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,aGeren,lImpSint,lRecDesp0,cRecDesp,dDtZeraRD,,cSaldos,lPlGerSint,lConsSaldo,,lUsaNmVis,@cNomeVis)
			dbSetOrder(2)
		Else	
			If lImpEntGer	//Se for balancete de Entidade (C.Custo/Item/Cl.Vlr por Entid. Gerencial)
			 	CtPlEntGer(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,cHeader,;
						lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,cContaIni,cContaFim,;         
						cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim,lImpSint,;
						lRecDesp0,cRecDesp,dDtZeraRD,nDivide,lFiltraCC,lFiltraIt,lFiltraCV, cSaldos )
			Else		
				MsgAlert(cMensagem)	
				Return
			EndIf
		EndIf
	Else
		If cHeader == "CT1"	//Se for Balancete Conta/Entidade
			#IFNDEF TOP	//Se for top connect, atualiza sinteticas
				// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
				CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
							cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,lNImpMov)	                       
			#ELSE
				If TcSrvType() == "AS/400"                     					
					// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE
					CtEntConta(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
							cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,;
							cAlias,lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,lImpAntLP,dDataLP,;
							nDivide,lVlrZerado,lNImpMov)	                       
				
				EndIf
			#ENDIF
			//Atualizacao de sinteticas para codebase e topconnect			
			If lImpSint	//Se atualiza sinteticas
		 		CtCtEntSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda)							
		    EndIf			
		Else
			If !lImp3Ent	.And. !lImp4Ent //Se não for Balancete CC / Conta / Item
				If lImpConta
					#IFNDEF TOP			    
						// Monta Arquivo Lendo Plano Padrao - especifico para conta/ENTIDADE				
						CtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
									cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
									lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
>									nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
									lRecDesp0,cRecDesp,dDtZeraRD)     
					#ELSE														
						If TcSrvType() == "AS/400"
							CtContaEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cEntidIni,cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
									cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
									lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
									lRecDesp0,cRecDesp,dDtZeraRD)     					
						EndIf
					#ENDIF					
					
					If lImpSint	//Se atualiza sinteticas
				 		CtEntCtSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,,cEntidIni,cEntidFim,lCttSint)
				 	EndIf
					
				Else
					#IFNDEF TOP				
						CtbSo1Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
								cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cEntidIni,;
								cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
								cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
								lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
								nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
								lRecDesp0,cRecDesp,dDtZeraRD)          							     										
					#ELSE
						If TcSrvType() == "AS/400"                     														
							CtbSo1Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cEntidIni,;
									cEntidFim,cMoeda,cSaldos,aSetOfBook,nTamCta,;
									cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,lCusto,;
									lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,cFilUSU,;
									lRecDesp0,cRecDesp,dDtZeraRD)          							     																
						EndIf					
					#ENDIF		 
					
					If lImpSint                                               
						If cAlias == "CT3"
							cIdent := "CTT"
						ElseIf cAlias == "CT4"
							cIdent := "CTD"						
						ElseIf cAlias == "CTI"
							cIdent := "CTH"						
						EndIf					
						CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)				
					EndIf						
							
				EndIf
			Else	//Se for Balancete CC / Conta / Item				
				If lImp3Ent
					#IFNDEF TOP
						CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
									cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
									lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado)				
					#ELSE
						If TcSrvType() == "AS/400"                     									
							CtbCta2Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
										cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
										cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
										lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
										nDivide,lVlrZerado)
					    EndIf
					#ENDIF
					If lImpSint
				 		Ctb3CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)							
				    Endif			
				 ElseIf cAlias == "CTI" .And. lImp4Ent .And. cHeader == "CTT"
					#IFNDEF TOP
						CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
									cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
									cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
									lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
									nDivide,lVlrZerado)				
					#ELSE
						If TcSrvType() == "AS/400" .or. lImpAntLP
							CtbCta3Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,;
										cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,cClVlFim,cMoeda,;
										cSaldos,aSetOfBook,nTamCta,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cHeader,;
										lCusto,lItem,lClvl,lAtSldBase,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,dDataLP,;
										nDivide,lVlrZerado)
					    EndIf
					#ENDIF	
					If lImpSint
				 		Ctb4CtaSup(oMeter,oText,oDlg,cAlias,lNImpMov,cMoeda,cHeader)							
				    Endif						
				 EndIf				 
			EndIf
		EndIf
	EndIf
Else	
	If cAlias $ 'CTU/CT7' .Or. (!Empty(aSetOfBook[5]) .And. Empty(cAlias))		//So Imprime Entidade ou demonstrativos
		If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
			// Monta Arquivo Lendo Plano Gerencial                                   
			// Neste caso a filtragem de entidades contabeis é desprezada!
			CtbPlGeren(	oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,cAlias,;
						cIdent,lImpAntLP,dDataLP,lVlrZerado,cEntidIni,cEntidFim,aGeren,lImpSint,lRecDesp0,cRecDesp,dDtZeraRD,;
						lMovPeriodo,cSaldos,lPlGerSint,lConsSaldo, cArqAux, lUsaNmVis,@cNomeVis,aSelfil,cQuadroCTB)
			dbSetOrder(2)
		Else
			//Se nao for for Top Connect
			#IFNDEF TOP 			
				CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
					cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
					lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
					dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,;
					cRecDesp,dDtZeraRD,cMoedaDsc,aSelFil,lTodasFil)					
			#ELSE
				If TcSrvType() == "AS/400"                     								
					CtSoEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
						cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
						lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,cFilDe,cFilAte,lImpAntLP,;
						dDataLP,nDivide,lVlrZerado,lUsGaap,cMoedConv,cConsCrit,dDataConv,nTaxaConv,lRecDesp0,;
						cRecDesp,dDtZeraRD,cMoedaDsc,aSelFil,lTodasFil)
				EndIf				
			#ENDIF			  
			     
			If lImpSint	//Se atualiza sinteticas			
				Do Case
				Case cAlias =="CT7"
					//Atualizacao de sinteticas para codebase e topconnect			        	
			 		CtContaSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cMoedaDsc)									 									
				Case cAlias == "CTU"			    		
					CtbCTUSup(oMeter,oText,oDlg,lNImpMov,cMoeda,cIdent)
				EndCase
			EndIf
		EndIf
	Else    	//Imprime Relatorios com 2 Entidades 
		If !Empty(aSetOfBook[5])
			MsgAlert(cMensagem)			
			Return
		Else
			If cAlias == 'CTY'		//Se for Relatorio de 2 Entidades filtrado pela 3a Entidade
				Ct2EntFil(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,aSelFil,lTodasFil)			
        	ElseIf  cAlias <> 'CVY'
				CtEntComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,lVlrZerado,cFiltroEnt,cCodFilEnt,cFilUsu,aSelFil,lTodasFil,aTmpFil)
			EndIf
		EndIf
	Endif
EndIf


dbSelectArea(cArqAux)

If FieldPos("ORDEMPRN") > 0
	If lCriaInd
		dbSelectArea(cArqAux)
		IndRegua(cArqAux,Left(cArqInd, 7) + "A","ORDEMPRN",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
		If cAlias == "CT7" .OR. cAlias == "CT3"
			IndRegua(cArqAux,Left(cArqInd, 7) + "B","SUPERIOR+CONTA",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
		ElseIf cAlias == "CTU"
			If cIdent == "CTT"
				IndRegua(cArqAux,Left(cArqInd, 7) + "B","CCSUP+CUSTO",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."					
			ElseIf cIdent == "CTD"
				IndRegua(cArqAux,Left(cArqInd, 7) + "B","ITSUP+ITEM",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."					
			ElseIf cIdent == "CTH"
				IndRegua(cArqAux,Left(cArqInd, 7) + "B","CLSUP+CLVL",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."					
			EndIf				
		EndIf
		DbClearIndex()
		dbSetIndex(cArqInd+OrdBagExt())
		dbSetIndex(Left(cArqInd,7)+"A"+OrdBagExt())
		dbSetIndex(Left(cArqInd,7)+"B"+OrdBagExt())
	Endif	
	
	DbSetOrder(1)
	DbGoTop()
	While ! Eof()
		If cAlias == "CT7" .OR. cAlias == "CT3"
			If Empty(SUPERIOR)					
				CtGerSup(CONTA, @nOrdem, cAlias)
			EndIf
		ElseIf cAlias == "CTU"						
			If cIdent == "CTT"
				If Empty(CCSUP)								
					CtGerSup(CUSTO, @nOrdem,"CTU","CTT")						
				EndIf
			ElseIf cIdent == "CTD"
				If Empty(ITSUP)
					CtGerSup(ITEM, @nOrdem,"CTU","CTD")						
				EndIf
			ElseIf cIdent == "CTH"
				If Empty(CLSUP)
					CtGerSup(CLVL, @nOrdem,"CTU","CTH")						
				Endif
			EndIf						
		EndIf
		DbSkip()
	Enddo
	DbSetOrder(2)
Endif

#IFDEF TOP                           
  	CTDelTmpFil()
  	For nX := 1 TO Len(aTmpFil)
		CtbTmpErase(aTmpFil[nX])
    Next
#ENDIF

RestArea(aSaveArea)

Return cArqTmp



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT7BlnQry ºAutor  ³Simone Mie Sato     º Data ³  26/06/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna alias TRBTMP com a composição dos saldos Conta x    º±±
±±º          ³Item Cotnabil                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XCtbRunC(dDataIni,dDataFim,cAlias,cContaIni,cContaFim,cEC05Ini,cEC05Fim,cMoeda,cTpSald,aSetOfBook,lImpMov,lVlrZerado,lImpAntLP,dDataLP,cFilUsu,cMoedaDsc,aSelFil,dDtCorte,lTodasFil,aTmpFil)

Local cQuery		:= ""
Local aAreaQry		:= GetArea()		/// array com a posição no arquivo original
Local aTamVlr		:= TAMSX3("CT4_DEBITO")
Local cCampUSU		:= ""
Local aStrSTRU		:= {}
Local nStruLen		:= 0
Local nStr			:= 1
Local lCT1EXDTFIM	:= CtbExDtFim("CT1") 
Local cQryFil		:= ""
Local nPosCT1
Local nPosE05
Local cAliasE05
Local cTmpCVXFil
Local cCpoChv
Local cCpoNormal
Local cCpoEntSup
Local cCpoDsc
Local cEntPrf

DEFAULT lImpAntLP := .F.
DEFAULT dDataLP	  := CTOD("  /  /  ")
DEFAULT cMoedaDsc := '01'
DEFAULT aSelFil	:= {}
DEFAULT dDtCorte  := CTOD("  /  /  ")
DEFAULT lTodasFil := .F.
DEFAULT aTmpFil	:= {}

If aCubsCTB == NIL
	aCubsCTB := CTB_ChvCube()
EndIf

DbSelectArea('CT0')
DbSetOrder(1)
If DbSeek( xFilial('CT0') + '05' )
	cAliasE05 := CT0->CT0_ALIAS
	cCpoChv := CT0->CT0_CPOCHV
	cCpoDsc := CT0->CT0_CPODSC
	If !Empty(CT0->CT0_CPOSUP)
		cCpoEntSup := "ECY."+CT0->CT0_CPOSUP
	Else
		cCpoEntSup := "' '"
	EndIf
Else
	cAliasE05 := "CV0"
	cCpoChv := "CV0_CODIGO"
	cCpoDsc := "CV0_DESC"
	cCpoEntSup := "ECY.CV0_ENTSUP"
EndIf
If cAliasE05 == "CV0"
	cCpoNormal := "ECY.CV0_NORMAL"
Else
	cCpoNormal := "'1'"
EndIf
If left(cAliasE05,1)=='S'
	cEntPrf := substr(cAliaE05,2,2)
Else
	cEntPrf := cAliasE05
EndIf


nPosCT1 := aScan( aCubsCTB[1,2] , {|x| x[1]=="CT1" })
nPosE05 := aScan( aCubsCTB[1,2] , {|x| x[1]==cAliasE05 })

If Empty(nPosCT1) .or. Empty(nPosE05)

	Return

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratativa para o filtro de filiais           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lTodasFil
	cQryFil := " CVX_FILIAL " + GetRngFil( aSelFil, "CVX", .T., @cTmpCVXFil )
	aAdd(aTmpFil, cTmpCVXFil)
Endif

cQuery := " SELECT ECX.CT1_CONTA ECX,ECX.CT1_NORMAL ECXNORMAL, ECX.CT1_RES ECXRES, ECX.CT1_CTASUP ECXSUP,ECX.CT1_DESC01 ECXDESC, "

cQuery += " ECY."+cCpoChv+" ECY,"+cCpoNormal+" ECYNORMAL, "+cCpoEntSup+" ECYSUP,ECY."+cCpoDsc+" ECYDESC, "

// TRATAR DATA DE EXISTENTCIA
//If lCT1EXDTFIM
//	cQuery += "     CT1_DTEXSF CT1DTEXSF, "
//EndIf

//***************************
// Calculo o saldo anterior *
//***************************
cQuery += " 		(SELECT SUM(CVX_SLDDEB) "
cQuery += "			 	FROM "+RetSqlName("CVX")+" CVX "
cQuery += " 			WHERE  CVX_FILIAL ='" + xFilial("CVX") + "' "
cQuery += " 			AND ECX.CT1_CONTA	= CVX_NIV" + StrZero(nPosCT1,2) + " AND ECY."+cCpoChv+" = CVX_NIV" + StrZero(nPosE05,2)

If lCtbIsCube .And. CtbIsCube()
	cQuery += " 			AND CVX_CONFIG = '05' "
Else
	cQuery += " 			AND CVX_CONFIG = '01' "
EndIf

cQuery += " 			AND CVX_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CVX_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CVX_DATA <  '"+DTOS(dDataIni)+"' "
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³data de corte para calculo do saldo anterior - Usado em Portugal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! Empty( dDtCorte ) .And. Valtype( dDtCorte ) == 'D'
	cQuery += " 			AND ((CVX_DATA >=  '"+DTOS(dDtCorte)+"'  AND  SUBSTRING(ECX.CT1_CONTA,1,1)>='4' ) OR (SUBSTRING(ECX.CT1_CONTA,1,1)<'4') )"
Endif
cQuery += " 			AND CVX.D_E_L_E_T_ = '') "
cQuery += "  SALDOANTDB, "  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³data de corte para calculo do saldo anterior - Usado em Portugal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If ! Empty( dDtCorte ) .And. Valtype( dDtCorte ) == 'D'
	cQuery += " 		(SELECT SUM(CVX_SLDDEB) "
	cQuery += "			 	FROM "+RetSqlName("CVX")+" CVX "
	cQuery += " 			WHERE  CVX_FILIAL ='" + xFilial("CVX") + "' "
	cQuery += " 			AND ECX.CT1_CONTA	= CVX_NIV" + StrZero(nPosCT1,2) + " AND ECY."+cCpoChv+" = CVX_NIV" + StrZero(nPosE05,2)

	If lCtbIsCube .And. CtbIsCube()
		cQuery += " 			AND CVX_CONFIG = '05' "
	Else
		cQuery += " 			AND CVX_CONFIG = '01' "
	EndIf
	
	cQuery += " 			AND CVX_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CVX_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CVX_DATA <  '"+DTOS(dDtCorte)+"' "
	cQuery += " 			AND CVX.D_E_L_E_T_ = '') "
	cQuery += "  SLDANTCTDB, "  
EndIf*/


cQuery += " 	  	(SELECT SUM(CVX_SLDCRD) "
cQuery += " 			FROM "+RetSqlName("CVX")+" CVX "
cQuery += " 			WHERE  CVX_FILIAL ='" + xFilial("CVX") + "' "
cQuery += " 			AND ECX.CT1_CONTA	= CVX_NIV" + StrZero(nPosCT1,2) + " AND ECY."+cCpoChv+" = CVX_NIV" + StrZero(nPosE05,2)

If lCtbIsCube .And. CtbIsCube()
	cQuery += " 			AND CVX_CONFIG = '05' "
Else
	cQuery += " 			AND CVX_CONFIG = '01' "
EndIf

cQuery += " 			AND CVX_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CVX_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CVX_DATA <  '"+DTOS(dDataIni)+"' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³data de corte para calculo do saldo anterior - Usado em Portugal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! Empty( dDtCorte ) .And. Valtype( dDtCorte ) == 'D'  .And. dDtCorte <> Nil
	cQuery += " 			AND ((CVX_DATA >=  '"+DTOS(dDtCorte)+"'  AND  SUBSTRING(ECX.CT1_CONTA,1,1)>='4' ) OR (SUBSTRING(ECX.CT1_CONTA,1,1)<'4') )"
Endif

cQuery += " 			AND CVX.D_E_L_E_T_ = '') "
cQuery += "  SALDOANTCR, "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³data de corte para calculo do saldo anterior - Usado em Portugal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If ! Empty( dDtCorte ) .And. Valtype( dDtCorte ) == 'D'  .And. dDtCorte <> Nil
	cQuery += " 		(SELECT SUM(CVX_SLDCRD) "
	cQuery += "			 	FROM "+RetSqlName("CVX")+" CVX "
	cQuery += " 			WHERE  CVX_FILIAL ='" + xFilial("CVX") + "' "
	cQuery += " 			AND ECX.CT1_CONTA	= CVX_NIV" + StrZero(nPosCT1,2) + " AND ECY."+cCpoChv+" = CVX_NIV" + StrZero(nPosE05,2)

	If lCtbIsCube .And. CtbIsCube()
		cQuery += " 			AND CVX_CONFIG = '05' "
	Else
		cQuery += " 			AND CVX_CONFIG = '01' "
	EndIf

	cQuery += " 			AND CVX_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CVX_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CVX_DATA <  '"+DTOS(dDtCorte)+"' "
	cQuery += " 			AND CVX.D_E_L_E_T_ = '') "
	cQuery += "  SLDANTCTCR, "
Endif*/
          
//************************
// Calculo o saldo Atual *
//************************

cQuery += " 		(SELECT SUM(CVX_SLDDEB) "
cQuery += "			 	FROM "+RetSqlName("CVX")+" CVX "
cQuery += " 			WHERE  CVX_FILIAL ='" + xFilial("CVX") + "' "
cQuery += " 			AND ECX.CT1_CONTA	= CVX_NIV" + StrZero(nPosCT1,2) + " AND ECY."+cCpoChv+" = CVX_NIV" + StrZero(nPosE05,2)

If lCtbIsCube .And. CtbIsCube()
	cQuery += " 			AND CVX_CONFIG = '05' "
Else
	cQuery += " 			AND CVX_CONFIG = '01' "
EndIf

cQuery += " 			AND CVX_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CVX_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CVX_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND CVX.D_E_L_E_T_ = '') "
cQuery += "  SALDODEB, " 

cQuery += " 		(SELECT SUM(CVX_SLDCRD) "
cQuery += " 			FROM "+RetSqlName("CVX")+" CVX "
cQuery += " 			WHERE  CVX_FILIAL ='" + xFilial("CVX") + "' "
cQuery += " 			AND ECX.CT1_CONTA	= CVX_NIV" + StrZero(nPosCT1,2) + " AND ECY."+cCpoChv+" = CVX_NIV" + StrZero(nPosE05,2)

If lCtbIsCube .And. CtbIsCube()
	cQuery += " 			AND CVX_CONFIG = '05' "
Else
	cQuery += " 			AND CVX_CONFIG = '01' "
EndIf

cQuery += " 			AND CVX_MOEDA = '"+cMoeda+"' "
cQuery += " 			AND CVX_TPSALD = '"+cTpSald+"' "
cQuery += " 			AND CVX_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
cQuery += " 			AND CVX.D_E_L_E_T_ = '') "
cQuery += "  SALDOCRD "


cQuery += " 	FROM "+RetSqlName("CT1")+" ECX," +RetSqlName(cAliasE05)+" ECY "
cQuery += " 	WHERE ECX.CT1_FILIAL = '" + xFilial("CT1") + "' AND ECY."+cEntPrf+"_FILIAL = '" + xFilial(cAliasE05) + "'"
cQuery += " 	AND ECX.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
//cEC05Ini := "      "
//cEC06Fim := "ZZZZZZ"
If cPaisLoc <> "COL" .and. cAliasE05 == "CV0"
	cQuery += " 	AND ECY.CV0_PLANO='05' "
EndIf
//cQuery += " 	AND ECX.CT1_CONTA BETWEEN '"+cEC05Ini+"' AND '"+cEC05Fim+"' "

/************Alterado por Luiz Otavio 15/07/2014**************/
cQuery += " 	AND ECY.CV0_CODIGO BETWEEN '"+cEC05Ini+"' AND '"+cEC05Fim+"' "
/*************************************************************/

cQuery += " 	AND ECX.CT1_CLASSE = '2' "
If cAliasE05 == "CV0"
	cQuery += " 	AND ECY.CV0_CLASSE = '2' "
EndIf

If !Empty(aSetOfBook[1])										// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND ECX.CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif
cQuery += " 	AND ECX.D_E_L_E_T_ = ' ' AND ECY.D_E_L_E_T_ = ' '"

    
If !lVlrZerado //.And. !lImpAntLP	//Se considerar posicao anterior LP sera verificado na gravacao do arquivo de trabalho
	cQuery += " 	AND	((SELECT ROUND(SUM(CVX_SLDDEB),2)- ROUND(SUM(CVX_SLDCRD),2) "		
	cQuery += "			 	FROM "+RetSqlName("CVX")+" CVX "
	cQuery += " 			WHERE  CVX_FILIAL ='" + xFilial("CVX") + "' "
	cQuery += " 			AND ECX.CT1_CONTA	= CVX_NIV" + StrZero(nPosCT1,2) + " AND ECY."+cCpoChv+" = CVX_NIV" + StrZero(nPosE05,2)

	If lCtbIsCube .And. CtbIsCube()
		cQuery += " 			AND CVX_CONFIG = '05' "
	Else
		cQuery += " 			AND CVX_CONFIG = '01' "
	EndIf

	cQuery += " 			AND CVX_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CVX_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CVX_DATA <  '"+DTOS(dDataIni)+"' "
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³data de corte para calculo do saldo anterior - Usado em Portugal³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! Empty( dDtCorte ) .And. Valtype( dDtCorte ) == 'D'  .And. dDtCorte <> Nil
		cQuery += " 			AND ((CVX_DATA >=  '"+DTOS(dDtCorte)+"'  AND  SUBSTRING(ECX.CT1_CONTA,1,1)>='4' ) OR (SUBSTRING(ECX.CT1_CONTA,1,1)<'4') )"
	Endif

	cQuery += " 			AND CVX.D_E_L_E_T_ = '') <> 0 "
	cQuery += " 	OR "	
	cQuery += " 			(SELECT SUM(CVX_SLDDEB)  "
	cQuery += "			 	FROM "+RetSqlName("CVX")+" CVX "
	cQuery += " 			WHERE  CVX_FILIAL ='" + xFilial("CVX") + "' "
	cQuery += " 			AND ECX.CT1_CONTA	= CVX_NIV" + StrZero(nPosCT1,2) + " AND ECY."+cCpoChv+" = CVX_NIV" + StrZero(nPosE05,2)

	If lCtbIsCube .And. CtbIsCube()
		cQuery += " 			AND CVX_CONFIG = '05' "
	Else
		cQuery += " 			AND CVX_CONFIG = '01' "
	EndIf

	cQuery += " 			AND CVX_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CVX_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CVX_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND CVX.D_E_L_E_T_ = '')<> 0 "
	cQuery += " 	OR "	
	cQuery += " 			(SELECT SUM(CVX_SLDCRD)  "
	cQuery += "			 	FROM "+RetSqlName("CVX")+" CVX "
	cQuery += " 			WHERE  CVX_FILIAL ='" + xFilial("CVX") + "' "
	cQuery += " 			AND ECX.CT1_CONTA	= CVX_NIV" + StrZero(nPosCT1,2) + " AND ECY."+cCpoChv+" = CVX_NIV" + StrZero(nPosE05,2)

	If lCtbIsCube .And. CtbIsCube()
		cQuery += " 			AND CVX_CONFIG = '05' "
	Else
		cQuery += " 			AND CVX_CONFIG = '01' "
	EndIf

	cQuery += " 			AND CVX_MOEDA = '"+cMoeda+"' "
	cQuery += " 			AND CVX_TPSALD = '"+cTpSald+"' "
	cQuery += " 			AND CVX_DATA BETWEEN '" + DTOS(dDataIni) + "' AND '"+ DTOS(dDataFim) + "' "		
	cQuery += " 			AND CVX.D_E_L_E_T_ = '')<> 0) "	
Endif
	
cQuery:= ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)

TcSetField("TRBTMP","SALDOANTDB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOANTCR","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDODEB","N",aTamVlr[1],aTamVlr[2])	
TcSetField("TRBTMP","SALDOCRD","N",aTamVlr[1],aTamVlr[2])	

/*
If lCT1EXDTFIM
	TCSetField("TRBTMP","CT1DTEXSF","D",8,0)	
	TCSetField("TRBTMP","CT1_DTEXSF","D",8,0)	
	TCSetField("TRBTMP","CT1_DTEXIS","D",8,0)
	TCSetField("TRBTMP","CT1_DTBLIN","D",8,0)
	TCSetField("TRBTMP","CT1_DTBLFI","D",8,0)
EndIf 
*/
If lImpAntLP
/*
	TcSetField("TRBTMP","SLDLPANTDB","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","SLDLPANTCR","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","MOVLPDEB","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","MOVLPCRD","N",aTamVlr[1],aTamVlr[2])	    
*/
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³data de corte para calculo do saldo anterior - Usado em Portugal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If ! Empty( dDtCorte )
	TcSetField("TRBTMP","SLDANTCTDB","N",aTamVlr[1],aTamVlr[2])	
	TcSetField("TRBTMP","SLDANTCTCR","N",aTamVlr[1],aTamVlr[2])	

	If lImpAntLP
		TcSetField("TRBTMP","SLLPATCTDB","N",aTamVlr[1],aTamVlr[2])	
		TcSetField("TRBTMP","SLLPATCTCR","N",aTamVlr[1],aTamVlr[2])	
	Endif
Endif*/
RestArea(aAreaQry)
