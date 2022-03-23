#include "rwmake.ch"
#include "protheus.ch"
#DEFINE DETAILBOTTOM 2600

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRECIBOA   บAutor  ณMicrosiga           บ Data ณ  01/31/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Impresion de recibo de caja                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


/*-------------------------------------------------------------------------------------------------------*/
USER FUNCTION RCobroB(cNum,cSerie)

PRIVATE lPrinted   := .f.
DEFAULT cNum := ""
DEFAULT cSerie := ""
ValidPerg( "RECCOB" )

IF Empty(cNum)
	IF Pergunte( "RECCOB", .t. )
		RptStatus( { || SelectComp() } )
	ENDIF
ELSE
	Pergunte( "RECCOB", .f. )
	mv_par01 := cNum
	mv_par02	:= cNum
	mv_par03	:= 1 //2
	mv_par04	:= 1
	MV_PAR05	:= SPACE(6)
	MV_PAR06	:= "ZZZZZZ"
	MV_PAR07	:= SPACE(2)
	MV_PAR08	:= "ZZ"   
	MV_PAR09    := cSerie
	RptStatus( { || SelectComp() } )
ENDIF


	Pergunte( "FIN87A", .f. )
RETURN nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION SelectComp()

PRIVATE nLine    := 0, ;
CrECpRO	:= "" ,;
aPedBloq := Array( 0 )

aRets  := {}


PRIVATE oPrn  := TMSPrinter():New(), ;
oFont    := TFont():New( "Arial"            ,, 10,, .f.,,,,    , .f. ), ;
oFont3   := TFont():New( "Arial"            ,, 12,, .t.,,,,    , .f. ), ;
oFont5   := TFont():New( "Arial"            ,, 10,, .t.,,,,    , .f. ), ;
oFont8   := TFont():New( "Arial"            ,,  8,, .f.,,,,    , .f. ), ;
oFont8b  := TFont():New( "Arial"            ,,  8,, .t.,,,, .t., .f. ), ;
oFont12b := TFont():New( "Times New Roman"  ,, 12,, .t.,,,,    , .f. ), ;
oFont12  := TFont():New( "Times New Roman"  ,, 12,, .f.,,,,    , .f. ), ;
oFont14b := TFont():New( "Times New Roman"  ,, 14,, .t.,,,,    , .f. ), ;
oFont14  := TFont():New( "Times New Roman"  ,, 14,, .f.,,,,    , .f. ), ;
oFont20  := TFont():New( "Times New Roman"  ,, 20,, .t.,,,,    , .f. ), ;
oFont18b := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .f. ), ;
oFont18  := TFont():New( "Times New Roman"  ,, 18,, .f.,,,,    , .f. ), ;
oFont18i := TFont():New( "Times New Roman"  ,, 18,, .f.,,,, .t., .f. ), ;
oFont11  := TFont():New( "Times New Roman"  ,, 18,, .t.,,,,    , .t. ), ;
oFont6   := TFont():New( "HAETTENSCHWEILLER",, 10,, .t.,,,,    , .f. ), ;
oFont30  := TFont():New( "Bauhaus Lt Bt"    ,, 10,, .t.,,,,    , .f. ), ;
oFont31  := TFont():New( "Arial"            ,,  8,, .t.,,,,    , .f. )

IF mv_par04 == 2
	oPrn:Setup()
ENDIF                                                                                           

DbSelectArea( "SA1" )
DbSetOrder( 1 )
DbSelectArea( "SE1" )
DbSetOrder( 2 )
DbSelectArea( "SYA" )
DbSetOrder( 1 )
DbSelectArea( "SEL" )
DbSetOrder( 8 )
//DbSetOrder( 1 )

DbSeek( xFilial() + mv_par09 + mv_par01, .t. )
SetRegua( ( Val( mv_par02 ) - Val( mv_par01 ) ) + 1 )

DbEval( { || PrintComp(), IncRegua() },, { || EL_FILIAL == xFilial() .AND. EL_RECIBO <= mv_par02.AND.EL_SERIE==mv_par09 } )

IF mv_par04 == 1
	oPrn:PreView()
ELSE
	oPrn:Print()
ENDIF

Ms_Flush()

RETURN

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintComp()
PRIVATE cTmpSCancel	:= UsrRetName(SubStr(Embaralha(SEL->EL_USERLGA,1),3,6))
PRIVATE cTmpNCancel	:= UsrRetName(SubStr(Embaralha(SEL->EL_USERLGI,1),3,6))
PRIVATE cUsuario    	:= IF(SEL->EL_CANCEL,cTmpSCancel,cTmpNCancel)    
PRIVATE cProvincia := Space( 0 )
PRIVATE cProvCMS   := Space( 0 )
PRIVATE cSitIVA    := Space( 0 )
PRIVATE aDriver    := ReadDriver()
PRIVATE nTotVal    := 0
PRIVATE nTotRet	   := 0
PRIVATE nLine      := 0
PRIVATE nLineori   := 0
PRIVATE nImpComp   := 0 
PRIVATE nSalComp   := 0 
PRIVATE demissao	:= SEL->EL_DTDIGIT
PRIVATE cRecibo		:= SEL->EL_RECIBO
PRIVATE cxObserv	:= ""//SEL->EL_XOBSERV,
PRIVATE cSerie      := SEL->EL_SERIE
   
nVal		:= 0                                 
nSdo		:= 0
nDes		:= 0
nJuros		:= 0

nPagoAnt   := 0

DbSelectArea( "SA1" )
DbSeek( xFilial( "SA1" ) + SEL->EL_CLIENTE + SEL->EL_LOJA )

DbSelectArea( "SYA" )
DbSeek( xFilial( "SYA" ) + SA1->A1_PAIS )

DbSelectArea( "SEL" )
//if empty(SA1->A1_EST)
//cProvincia := Tabela( "12", "13" )  //U_X5Des( "12", SA1->A1_EST ) 
//else
cProvincia := Tabela( "12",  SA1->A1_EST )  //U_X5Des( "12", SA1->A1_EST ) 
//endif  
/*
if empty(SM0->M0_ESTCOB)
cProvCMS   := Tabela( "12","13" )  //U_X5Des( "12", SA1->A1_EST ) 
else
cProvCMS   := Tabela( "12",  SM0->M0_ESTCOB )  //U_X5Des( "12", SA1->A1_EST ) 
endif 
*/
 //U_X5Des( "12", SM0->M0_ESTCOB )
//cSitIVA    := Tabela( "SF", SA1->A1_TIPO )
cDesCli    :=SEL->EL_CLIENTE//rip

IF SEL->EL_CLIENTE >= MV_PAR05 .AND. SEL->EL_CLIENTE <= MV_PAR06 .AND. SEL->EL_LOJA >= MV_PAR07 .AND. SEL->EL_LOJA <= MV_PAR08.AND. SEL->EL_SERIE == MV_PAR09
	_nRecnoS	:= SEL->(RECNO())
	for __nx	:= 1 to MV_PAR03    
	nTotVal    := 0
	nTotRet	:= 0 
	SEL->(DBGOTO(_nRecnoS))
	oPrn:EndPage()
	PrintHead(.t.,__nx)
	PrintItem()
	PrintFoot()
	NEXT  __nx
ENDiF                       

RETURN nil

/*-------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION PrintHead(lStart,nCopies)
Local cCpag :=""         

IF !lPrinted
	lPrinted := .t.
ELSEIf lStart
	oPrn:StartPage()
ENDIF

nLine := 50
IF nCopies==1
	cCopia:="ORIGINAL"
elseif nCopies==2
	cCopia:="DUPLICADO"
elseif nCopies==3
	cCopia:="TRIPLICADO"
eLSE
		cCopia:=" "
ENDIF

oPrn:Say( nLine, 0100, " ", oFont, 100 )
oPrn:Box( nLine, 0050, nLine + 440, 2300 )
nLineori := nLine
nLine += 10
oPrn:SayBitmap( nLine+120, 0090, AllTrim( GetMV( "MV_DIRLOGO" ) ) , 200, 200 )
nLine += 10
//oPrn:Say( nLine +  050, 1155, "X", oFont20, 100 )
oPrn:Say( nLine +  050, 1155, cSerie, oFont20, 100 )
oPrn:Say( nLine + 090, 0300, AllTrim(SM0->M0_NOMECOM), oFont12B, 100 )
oPrn:Say( nLine + 134, 0300, "ADM. Y LUGAR DE PAGO: " + AllTrim(SM0->M0_ENDCOB) + AllTrim(SM0->M0_COMPCOB), oFont8b,100)
IF EMPTY()
	oPrn:Say( nLine + 168, 0300, AllTrim(SM0->M0_CEPCOB) + ' - ' + AllTrim(SM0->M0_CIDCOB) + ' - ' + SM0->M0_ESTCOB/* AllTrim(Tabela("12","13"))*/, oFont8b, 100 )
ELSE
	oPrn:Say( nLine + 168, 0300, AllTrim(SM0->M0_CEPCOB) + ' - ' + AllTrim(SM0->M0_CIDCOB) + ' - ' + SM0->M0_ESTCOB/*AllTrim(Tabela("12",SM0->M0_ESTCOB))*/, oFont8b, 100 )
ENDIF
oPrn:Say( nLine + 202, 0300, "DEPOSITO : " , oFont8b, 100)
oPrn:Say( nLine + 236, 0300, AllTrim(SM0->M0_ENDENT) + AllTrim(SM0->M0_COMPENT), oFont8b, 100)
IF EMPTY()
oPrn:Say( nLine + 270, 0300, AllTrim(SM0->M0_CEPENT) + ' - ' + AllTrim(SM0->M0_CIDENT) + ' - ' +SM0->M0_ESTCOB/* AllTrim(Tabela("12","13"))*/, oFont8b, 100 )
ELSE
	oPrn:Say( nLine + 270, 0300, AllTrim(SM0->M0_CEPENT) + ' - ' + AllTrim(SM0->M0_CIDENT) + ' - ' + SM0->M0_ESTCOB /* AllTrim(Tabela("12",SM0->M0_ESTENT))*/, oFont8b, 100 )
ENDIF
oPrn:Say( nLine + 310, 0300, "TEL.:" +  AllTrim( SM0->M0_TEL_PO ) + " - FAX: " + SM0->M0_FAX_PO, oFont8b, 100 )
oPrn:Say( nLine + 050, 1520, cCopia, oFont12b, 100 )
oPrn:Say( nLine + 100, 1520, "RECIBO NRO: ", oFont12b, 100 )
oPrn:Say( nLine + 150, 1520, "FECHA :", oFont12b, 100 )
//      oPrn:Say( nLine + 250, 1450, "C.U.I.T. " + TRANSFORM(AllTrim( SM0->M0_CGC ), '@R 99-99999999-9') + " - IVA.: Responsable Inscripto" , oFont8B, 100 )
// Elo  oPrn:Say( nLine + 250, 1450, "RFC " + TRANSFORM(AllTrim( SM0->M0_CGC ), '@R 99999999999'), oFont8B, 100 )  
oPrn:Say( nLine + 250, 1520, "RUC: " + AllTrim( SM0->M0_CGC ), oFont8B, 100 )   //CAMBIO
//oPrn:Say( nLine + 300, 1450, "Nฐ INGRESOS BRUTOS : " + TRANSFORM(AllTrim( SM0->M0_INSC ), '@R 999-999999-9') , oFont8B, 100 )
//	oPrn:Say( nLine + 350, 1450, "ING. BRUTOS C.M.: 901-940714-5 - INICIO DE ACTIVIDADES: 8/9/1988" , oFont8B, 100 )
oPrn:Say( nLine + 150, 1860, DToC( EL_DTDIGIT ), oFont14b, 100 )
oPrn:Say( nLine + 100, 1860,  EL_RECIBO, oFont14b, 100 )
CrECpRO	:= 	EL_RECPROV
IF EL_CANCEL
	oPrn:Say( nLine, 1090, "*** A N U L A D O *** ", oFont14b, 100 )
ELSE
	oPrn:Say( nLine, 1100, "RECIBO", oFont14b, 100 )
ENDIF

nLine += 450

//oPrn:Say( nLine, 0100, "Cliente:   " + AllTrim( SA1->A1_NOME ) + " (" + AllTrim( SA1->A1_COD ) + ")", oFont, 100 )
//Elo oPrn:Say( nLine, 0100, "Cliente:   " + AllTrim( SA1->A1_NOME ), oFont, 100 )
oPrn:Say( nLine, 0100, "Cliente:   " + AllTrim( SA1->A1_NOME ) + " (" + AllTrim( SA1->A1_COD ) + "-" + AllTrim( SA1->A1_LOJA ) + ")" , oFont, 100 ) // cambio
nLine += 50
oPrn:Say( nLine, 0100, "Domicilio: " + AllTrim( SA1->A1_END ), oFont, 100 )
nLine += 50
oPrn:Say( nLine, 0100, "Localidad: " + Alltrim( SA1->A1_MUN ) + ;
If( SA1->A1_TIPO != "E", ;
	If( !Empty( cProvincia ), " - " + cProvincia, "" ), ;
		"   Pais: " + AllTrim( SYA->YA_DESCR ) ) )
//		"   C. Postal: " + AllTrim( SA1->A1_CEP ), oFont, 100 )
		nLine += 50
	  //	oPrn:Say( nline, 0100, "C.U.I.T.:  " + TRANSFORM(AllTrim( SA1->A1_CGC ), '@R 99-99999999-9') + " - I.V.A.: " + cSitIVA, oFont31, 100 )
	  //ELo	oPrn:Say( nline, 0100, "RFC:  " + TRANSFORM(IF(!EMPTY(AllTrim( SA1->A1_CGC )),AllTrim( SA1->A1_CGC ),AllTrim( SA1->A1_PFISICA )), '@R 99999999999'), oFont, 100 )
	     oPrn:Say( nLine, 0100, "RUC:  " + IF(!EMPTY(AllTrim( SA1->A1_CGC )),AllTrim( SA1->A1_CGC ),AllTrim( SA1->A1_PFISICA )), oFont, 100 ) //cambio 
	     cCpag:= "" //Posicione("ZZX",1,xFilial("ZZX")+ SEL->EL_CLIORIG+SEL->EL_NATUREZ,"ZZX_CONDPA" )
	   	 oPrn:Say( nLine, 1100, "Condicion de Pago: " + Posicione("SE4",1,Xfilial("SE4")+cCpag,"E4_DESCRI" ) + ;
		If( !Empty( SA1->A1_DESC ), " (" + AllTrim( SA1->A1_DESC ) + ")", "" ), oFont31, 100 )                                                                                                                          
		 	_nLinobs	:= mlcount(cxobserv,70)
		 	nLin1	:= nline
			for nx:= 1 to _nLinObs
					If nx == 1 
					oPrn:Say( nLin1+050, 0100, "Observaciones:  " + memoline(cxObserv,70,nx) , oFont31, 100 )
					Else
					oPrn:Say( nLin1+050, 0100, memoline(cxObserv,70,nx) , oFont31, 100 )
					EndIF
		    nLin1	+= 50                      
		    Next

			If lstart			
			oPrn:Box( nLineori, 0050, nLine + 050, 2300 )
			oPrn:Box( nLine + 50, 0050, nLine + 230, 2300 )
			
			nLineori += 180
			nLine += 230

				oPrn:Say( nLine + 30, 0100, "Detalle de Cobro", oFont12b, 100 )
				nLineori := nLine
				nLine += 100
				
				oPrn:Say( nLine, 0100, "Tipo Comprobante", oFont8b, 100 )
				oPrn:Say( nLine, 0400, "No. Comprobante", oFont8b, 100 )
				oPrn:Say( nLine, 0770, " Fecha", oFont8b, 100 )
				oPrn:Say( nLine, 0900, "Valor del documento", oFont8b, 100 )
				oPrn:Say( nLine, 1300, "Saldo", oFont8b, 100 )
				oPrn:Say( nLine, 1550, "Descto.", oFont8b, 100 )
				oPrn:Say( nLine, 1750, "Inter+Multa", oFont8b, 100 )
				oPrn:Say( nLine, 2000, "Importe Cobrado", oFont8b, 100 )
			EndIf
			nLine += 050
			RETURN NIL
			
			/*-------------------------------------------------------------------------------------------------------*/
			STATIC FUNCTION PrintItem()
			
			LOCAL cNroRec    := EL_FILIAL + EL_RECIBO, ;
			nRecSEL    := RecNo(), ;
			nLeftPanel := nLine, ;               
			cDescBco   := "", ;
			cTipoDoc := "", ;
			nS := 0
			
			WHILE ( EL_FILIAL + EL_RECIBO ) == cNroRec
									IF nLeftPanel >=  2550
						//   		PrintFoot()
						oPrn:Say( 2700, 1700, "Continua en la siguiente pเgina ---> " ,oFont8, 100 )
						oPrn:Box( nLeftPanel, 0050, nLine, 2300 )
						nLeftPanel := nLine
						nLineori := nLine
						oprn:endpage()
						PrintHead(.f.)
						nLine:= 0850
						nLeftPanel := nLine
						//   		PrintItem()
						
					EndIF
				 
				IF EL_TIPODOC == "TB"
					
					cTipoDoc := Tabela( "05",  SEL->EL_TIPO )
					if SEL->EL_TIPO == "NF "
						oPrn:Say( nLeftPanel, 0100, substr(cTipoDoc,1,12) + " " + SEL->EL_PREFIXO , oFont8, 100 )
					else
						oPrn:Say( nLeftPanel, 0100, substr(cTipoDoc,1,12) , oFont8, 100 )
					endif
					
					SE1->( DbSeek( xFilial() + SEL->EL_CLIENTE + SEL->EL_LOJA + SEL->EL_PREFIXO + SEL->EL_NUMERO + ;
					SEL->EL_PARCELA + SEL->EL_TIPO ) )
					
				 //	oPrn:Say( nLeftPanel, 0650, Left( EL_NUMERO, 4 ) + "-" + Right( EL_NUMERO, 8 ), oFont8, 100 )
				 	oPrn:Say( nLeftPanel, 0400, EL_NUMERO, oFont8, 100 )
					oPrn:Say( nLeftPanel, 0770, DToC( EL_EMISSAO ), oFont8, 100 )    
					
					IF SE1->E1_MOEDA==1
					   nVal:= SE1->E1_VALOR
					   nSdo:= SE1->E1_SALDO
					   nDes:= SEL->EL_DESCONT
					   nJuros:= SEL->EL_JUROS+SEL->EL_MULTA  
					elseif SE1->E1_MOEDA==2
					   nVal:= SE1->E1_VALOR * SEL->EL_TXMOE02                    	 // Juan Pablo Astorga 12.07 como estaba SEL->EL_TXMOED02 
					   nSdo:= SE1->E1_SALDO * SEL->EL_TXMOE02						 // Juan Pablo Astorga 12.07 como estaba SEL->EL_TXMOED02 
					   nDes:= SEL->EL_DESCONT * SEL->EL_TXMOE02 					 // Juan Pablo Astorga 12.07 Como estaba SEL->EL_TXMOED02 
					   nJuros:= (SEL->EL_JUROS+SEL->EL_MULTA)*  SEL->EL_TXMOE02      // Juan Pablo Astorga 12.07 comom estaba SEL->EL_TXMOED02 
					
					elseif SE1->E1_MOEDA==3
					   nVal:= SE1->E1_VALOR   * SEL->EL_TXMOE03                            // Juan Pablo Astorga 12.07 como estaba SEL->EL_TXMOED03        
					   nSdo:= SE1->E1_SALDO   * SEL->EL_TXMOE03   // Juan Pablo Astorga 12.07 como estaba SEL->EL_TXMOED03
					   nDes:= SEL->EL_DESCONT * SEL->EL_TXMOE03   // Juan Pablo Astorga 12.07 como estaba SEL->EL_TXMOED03
					   nJuros:= (SEL->EL_JUROS+SEL->EL_MULTA)*  SEL->EL_TXMOE03  // Juan Pablo Astorga 12.07 como estaba SEL->EL_TXMOED03   
					EndIf
					/*
					oPrn:Say( nLeftPanel, 0900, TransForm( SE1->E1_VALOR, PesqPict( "SE1", "E1_VALOR" ) ), oFont8, 100 )					
					oPrn:Say( nLeftPanel, 1200, TransForm( SE1->E1_SALDO, PesqPict( "SE1", "E1_SALDO" ) ), oFont8, 100 )   
					oPrn:Say( nLeftPanel, 1450, TransForm( SEL->EL_DESCONT, PesqPict( "SEL", "EL_DESCONT" ) ), oFont8, 100 )
                    oPrn:Say( nLeftPanel, 1700, TransForm( SEL->EL_JUROS+SEL->EL_MULTA, PesqPict( "SEL", "EL_JUROS" ) ), oFont8, 100 )
					oPrn:Say( nLeftPanel, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
					*/

					oPrn:Say( nLeftPanel, 0900, TransForm( nVal, PesqPict( "SE1", "E1_VALOR" ) ), oFont8, 100 )					
					oPrn:Say( nLeftPanel, 1200, TransForm( nSdo, PesqPict( "SE1", "E1_SALDO" ) ), oFont8, 100 )   
					oPrn:Say( nLeftPanel, 1450, TransForm( nDes, PesqPict( "SEL", "EL_DESCONT" ) ), oFont8, 100 )
                    oPrn:Say( nLeftPanel, 1700, TransForm( nJuros, PesqPict( "SEL", "EL_JUROS" ) ), oFont8, 100 )
					oPrn:Say( nLeftPanel, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
					
					nLeftPanel += 50
					
					nImpComp := nImpComp + SE1->E1_VALOR
					nSalComp := nSalComp + EL_VLMOED1
					
				ELSEIF EL_TIPODOC == "RA"
					
					oPrn:Say( nLeftPanel, 0100, "A CUENTA    ", oFont8, 100 )
				   //	oPrn:Say( nLeftPanel, 0650, Left( EL_NUMERO, 4 ) + "-" + Right( EL_NUMERO, 8 ), oFont8, 100 )
				   	oPrn:Say( nLeftPanel, 0400, EL_NUMERO, oFont8, 100 )
					oPrn:Say( nLeftPanel, 0770, DToC( EL_EMISSAO ), oFont8, 100 )
					oPrn:Say( nLeftPanel, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
					nLeftPanel += 50
					
					
				ENDIF
				
				
				DbSkip()
				
			ENDDO
			oPrn:Box( nLineori, 0050, nLeftPanel, 2300 )
			nLine := nLeftPanel
			nLine += 050
			DbGoTo( nRecSEL )
			
			oPrn:Say( nLine, 0100, "Medio de Cobro", oFont12b, 100 )
			nLine += 100
			oPrn:Say( nLine, 0100, "Tipo Valor", oFont8b, 100 )
			oPrn:Say( nLine, 0450, "Banco", oFont8b, 100 )                              
			oPrn:Say( nLine, 1150, "Fecha", oFont8b, 100 )
			oPrn:Say( nLine, 1350, "Nro Valor", oFont8b, 100 )
			oPrn:Say( nLine, 2000, "Importe", oFont8b, 100 )
			nLine += 050
			
			WHILE ( EL_FILIAL + EL_RECIBO ) == cNroRec
				
				SA6->( dbSeek( xFilial( "SA6" ) + SEL->EL_BANCO + SEL->EL_AGENCIA + SEL->EL_CONTA, .F. ) )
				
				cDescBco := SA6->A6_NREDUZ
				
				
				IF EL_TIPODOC $ "CH-EF-TF-RG-RI-RB-TJ-PG-RS-RA-CP-DB-CR"
					IF nLine >=  2550
						//   		PrintFoot()
						oPrn:Say( 2700, 1700, "Continua en la siguiente pเgina ---> " ,oFont8, 100 )
						oPrn:Box( nLeftPanel, 0050, nLine, 2300 )
						nLeftPanel := nLine
						nLineori := nLine
						oprn:endpage()
						PrintHead(.f.)
						nLine:= 0850
						nLeftPanel := nLine
						//   		PrintItem()
						
					EndIF
					cDescBco := cDescBco
					
					IF EL_TIPODOC == "CH"
						//ZZZ->(DBSETORDER(1))
						//ZZZ->( dbSeek( xFilial( "ZZZ" ) + SEL->EL_BCOCHQ , .F. ) )
						//cDescBco :=  ZZZ->ZZZ_XDESCR
						
						
						oPrn:Say( nLine, 0100, "CHEQUE " ,oFont8, 100 )
						//oPrn:Say( nLine, 0450, cDescBco, oFont8, 100 )
						oPrn:Say( nLine, 1150, DToC( EL_DTVCTO ), oFont8, 100 )
						oPrn:Say( nLine, 1350, EL_NUMERO, oFont8, 100 )
						oPrn:Say( nLine, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
						nLine += 50
						
					ELSEIF EL_TIPODOC == "EF"
						
						oPrn:Say( nLine, 0100, "EFECTIVO", oFont8, 100 )
						oPrn:Say( nLine, 1150, DToC( EL_EMISSAO ), oFont8, 100 )
						oPrn:Say( nLine, 0450, cDescBco, oFont8, 100 )
						oPrn:Say( nLine, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
						nLine += 50
					ELSEIF EL_TIPODOC == "CR"
						
						oPrn:Say( nLine, 0100, "CTA. RECAUD.", oFont8, 100 )
						oPrn:Say( nLine, 1150, DToC( EL_EMISSAO ), oFont8, 100 )
						oPrn:Say( nLine, 0450, cDescBco, oFont8, 100 )
						oPrn:Say( nLine, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
						nLine += 50
					ELSEIF EL_TIPODOC == "TF"
						
						oPrn:Say( nLine, 0100, "TRANSFERENCIA DE: " , oFont8, 100 )
						oPrn:Say( nLine, 0450, cDescBco, oFont8, 100 )
						//            oPrn:Say( nLine, 1150, EL_CONTA, oFont8, 100 )
						oPrn:Say( nLine, 1150, DToC( EL_EMISSAO ), oFont8, 100 )    
						oPrn:Say( nLine, 1350, EL_NUMERO, oFont8, 100 )
						oPrn:Say( nLine, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
						nLine += 50
					ELSEIF EL_TIPODOC == "DB"
						
						oPrn:Say( nLine, 0100, "DEPOSITO BANC. : " , oFont8, 100 )
						oPrn:Say( nLine, 0450, cDescBco, oFont8, 100 )
						//            oPrn:Say( nLine, 1150, EL_CONTA, oFont8, 100 )
						oPrn:Say( nLine, 1150, DToC( EL_EMISSAO ), oFont8, 100 )
						oPrn:Say( nLine, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
						nLine += 50
						
					ELSEIF EL_TIPODOC == "TJ" .and. EL_TIPODOC $ "CC"
						
						oPrn:Say( nLine, 0100, "TARJETA ", oFont8, 100 )
						oPrn:Say( nLine, 0450, cDescBco, oFont8, 100 )
						oPrn:Say( nLine, 2100, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
						oPrn:Say( nLine, 0800, EL_CLIENTE , oFont8, 100 )
						nLine += 50
						
					ELSEIF EL_TIPODOC == "PG"
						
						oPrn:Say( nLine, 0100, "COMISIONES    ", oFont8, 100 )
						oPrn:Say( nLine, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
						nLine += 50
						
					ELSEIF EL_TIPODOC == "RI"
						AADD( aRets, { "RETENCION I.V.A.", TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ) } )
						nTotRet	+= EL_VLMOED1
					ELSEIF EL_TIPODOC == "RG"
						AADD( aRets, { "RETENCION GANANCIAS", TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ) } )
						nTotRet	+= EL_VLMOED1
					ELSEIF EL_TIPODOC == "RB"
						AADD( aRets, { "RETENCION IIBB", TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ) } )
						nTotRet	+= EL_VLMOED1
					ELSEIF EL_TIPODOC == "RS"
						AADD( aRets, { "RETENCION S.U.S.S.", TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ) } )
						nTotRet	+= EL_VLMOED1
						
					ELSEIF Alltrim(EL_TIPODOC) == "CP"
						oPrn:Say( nLine, 0100, "COMPENSACION PROVEEDOR " , oFont11, 100 )
						oPrn:Say( nLine, 0450, cDescBco, oFont8, 100 )
						oPrn:Say( nLine, 2000, TransForm( EL_VLMOED1, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont8, 100 )
						nLine += 50
						
						
						
					ENDIF
					
					IF !EL_TIPODOC $ "RA-RI-RG-RB-RS"
						nTotVal := nTotVal + EL_VLMOED1
						
					ENDIF
					
				ENDif
				
				DbSkip()
				
			ENDDO
			
			oPrn:Box( nLeftPanel, 0050, nLine, 2300 )
			nLeftPanel := nLine
			nLineori := nLine
			DbSkip( -1 )
			nLine += 100
			
			if Len( aRets ) > 0
				
				oPrn:Say( nLine, 0100, "Retenciones Sufridas", oFont12b, 100 )
				nLine += 50
				oPrn:Say( nLine, 0100, "Tipo", oFont8b, 100 )
				oPrn:Say( nLine, 2100, "Importe", oFont8b, 100 )
				nLine += 50
				
			endif

			For nS := 1 To Len( aRets )
				oPrn:Say( nLine, 0100, aRets[nS][1]				, oFont8, 100 )          // RETENCION
				oPrn:Say( nLine, 2100, aRets[nS][2]				, oFont8, 100 )          // NRO COMPROB.
				nLine += 50 

			next nS
			nLine := DETAILBOTTOM
			aRets := {}
			
			oPrn:Box( nLeftPanel, 0050, nLine, 2300 )
			
			nLeftPanel := nLine
			nLineori := nLine
			RETURN NIL
			
			/*-------------------------------------------------------------------------------------------------------*/
			STATIC FUNCTION PrintFoot()
			
			iF !Empty(CrECpRO)
//			oPrn:Say( nLine  , 0100,  "Reemplazo del recibo provisorio numero: "+ CrECpRO, oFont5, 100 )
			oPrn:Say( nLine  , 0100,  "Recibo provisorio n๚mero: "+ CrECpRO, oFont5, 100 )
			EndIf
			oPrn:Say( nLine + 050, 0100, Extenso(nTotVal+nTotRet,.F.,1,'RECIBIMOS LA SUMA DE SOLES : ','Esp',.T.), oFont8, 80 )
  //			oPrn:Say( nLine + 250, 0100, "La cantidad de $ ", oFont12, 100 )
			oPrn:Say( nLine + 150, 0100, "QUE SE APLICARAN A LA CANCELACION DE LOS SIGUIENTES COMPROBANTES UNA VEZ HECHO ", oFont8, 80 )
			oPrn:Say( nLine + 200, 0100, "EFECTIVOS LOS VALORES DETALLADOS EN EL PRESENTE:", oFont8, 80 )
//			oPrn:Say( nLine + 250, 0880, TransForm( nTotVal, PesqPict( "SEL", "EL_VALOR" ) ), oFont5, 100 )
			oPrn:Say( nLine + 050, 1575, "Total de Valores: ($)" +  TransForm( nTotVal, PesqPict( "SEL", "EL_VLMOED1" ) ), oFont12, 100 )
		//	oPrn:Say( nLine + 100, 1575, "Total Retenciones    "+ TransForm( nTotRet, PesqPict( "SEL", "EL_VALOR" ) ) , oFont12, 100 )
			oPrn:Say( nLine + 150, 1575, "Total Recibido:      "+ TransForm( nTotRet + nTotVal , PesqPict( "SEL", "EL_VLMOED1" ) ) , oFont12, 100 )
			//   oPrn:Say( nLine + 250, 2055, TransForm( , PesqPict( "SEL", "EL_VALOR" ) ), oFont5, 100 )
			
		 //	oPrn:Say( nLine + 480, 0500, "Cuando se entreguen cheques o giros este recibo tendrแ carแcter provisorio y el pago reci้n se tendrแ por hecho cuando los valores se ", oFont8b, 100 )
		 //	oPrn:Say( nLine + 510, 0500, " hagan efectivos sin perjuicio de los intereses y/o actualizaciones devengados hasta ese momento desde la fecha de vencimiento ", oFont8b, 100 )
			oPrn:Say( nLine + 540, 0500, " Usuario: "+ cUsuario, oFont8b, 100 )
			oPrn:Box( nLine, 0050, nLineori + 400, 1525 )
			oPrn:Box( nLine, 1525, nLineori + 400, 2300 )
//			oPrn:Box( nLine, 1525, nLineori + 100, 2300 )
			oPrn:Box( nLine, 0050, nLineori + 350, 1525 )
			oPrn:Box( nLine+300, 0500, nLineori + 400, 1525 )
			oPrn:Box( nLine+300, 1000, nLineori + 400, 1525 )
			oPrn:Box( nLine, 0050, nLineori + 300, 1525 )    
			oPrn:Say( nLine + 300, 0100, "Deuda Vencida ($)", oFont12, 100 )
			oPrn:Say( nLine + 350, 0100, TransForm( traevenc(), PesqPict( "SEL", "EL_VLMOED1" ) ), oFont12, 100 )
			oPrn:Say( nLine + 300, 0550, "Deuda a Vencer ($)", oFont12, 100 )
			oPrn:Say( nLine + 350, 0550, TransForm( traeAvnc(), PesqPict( "SEL", "EL_VLMOED1" )), oFont12, 100 )
			oPrn:Say( nLine + 300, 1050, "Dias Atraso Promedio ", oFont12, 100 )
			oPrn:Say( nLine + 350, 1050, Transform(TraeProm(),"@E 9999.99"), oFont12, 100 )
			oPrn:EndPage()
			
			RETURN NIL
			
			/*-------------------------------------------------------------------------------------------------------*/
			STATIC FUNCTION ValidPerg( cPerg )
			
			LOCAL aVldSX1  := GetArea()
			LOCAL aCposSX1 := {}
			LOCAL aPergs   := {}
			LOCAL cPerg    := PADR("RECCOB",10)
			
			aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL	",;
			"X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1",;
			"X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02" ,"X1_VAR03",;
			"X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4",;
			"X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3","X1_GRPSXG"}
			
			aAdd( aPergs,{'Desde Recibo'	,'Desde Recibo'		,'Desde Recibo'	,'mv_ch1'	,'C',  6, 0, 1, 'G', '', 'mv_par01','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
			aAdd( aPergs,{'Hasta Recibo'	,'Hasta Recibo'		,'Hasta Recibo'	,'mv_ch2'	,'C',  6, 0, 1, 'G', '', 'mv_par02','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
			aAdd( aPergs,{'ฟImprimir?'		,'ฟImprimir?'		,'ฟImprimir?'	,'mv_ch3'	,'N',  1, 0, 0, 'C', '', 'mv_par03','Activas','','','Anuladas','', '', 'Ambas', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
			//   AAdd( aPergs, { cPerg, "04", "Previsualizacion", "mv_ch4", "N", 02, 0, 0, "C", "", "mv_par04", "Si", "", "", "No", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
			aAdd( aPergs,{'Previsualizaci๓n','Previsualizaci๓n'	,'Previsualizaci๓n','mv_ch4','N',  1, 0, 0, 'C', '', 'mv_par04','SI','','','NO','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
			aAdd( aPergs,{'Desde Cliente'	,'Desde Cliente'	,'Desde Cliente','mv_ch5'	,'C',  6, 0, 1, 'G', '', 'mv_par05','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','SA1',''})
			aAdd( aPergs,{'Hasta Cliente'	,'Hasta Cliente'	,'Hasta Cliente','mv_ch6'	,'C',  6, 0, 1, 'G', '', 'mv_par06','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','SA1',''})
			aAdd( aPergs,{'Desde Tienda'	,'Desde Tienda'		,'Desde Tienda'	,'mv_ch7'	,'C',  4, 0, 1, 'G', '', 'mv_par07','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
			aAdd( aPergs,{'Hasta Tienda'	,'Hasta Tienda'		,'Hasta Tienda'	,'mv_ch8'	,'C',  4, 0, 1, 'G', '', 'mv_par08','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
			aAdd( aPergs,{'Serie'			,'Serie'			,'Serie'		,'mv_ch9'	,'C',  3, 0, 1, 'G', '', 'mv_par09','','','','','', '', '', '', '',	'',	'',	'',	'',	'',	'',	'', '', '',	'',	'',	'',			'', 		'',				'','',''})
			dbSelectArea("SX1")
			dbSetOrder(1)
			For nX:=1 to Len(aPergs)
				If !(dbSeek(cPerg+StrZero(nx,2)))
					RecLock("SX1",.T.)
					Replace X1_GRUPO with cPerg
					Replace X1_ORDEM with StrZero(nx,2)
					for nj:=1 to Len(aCposSX1)
						FieldPut(FieldPos(ALLTRIM(aCposSX1[nJ])),aPergs[nx][nj])
					next nj
					MsUnlock()
				Endif
			Next
			
			RestArea( aVldSX1 )
			
			RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTraeVenc   บAutor  ณMicrosiga           บ Data ณ  10/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Trae Saldo de titulos vencidos                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TraeVenc
Local nValVenc	:= 0 
lOCAL cQuery2	:= ""
Local cQuery	:= ""
Local nSignop	:= 0 
Local nSignoN	:= 0 
Local cAlias1	:= "Qry1"
Local cAlias2	:= "qRY2"
Local nValm1	:= 0 
Local nValm2	:= 0 
Local nValm3	:= 0 
Local nValm4	:= 0 
Local nValm5	:= 0 
Local aArea		:= Getarea()


cQuery	:= "SELECT SUM(E1_SALDO) AS DEUDA, E1_MOEDA as MONEDA FROM "+RetSqlname("SE1") +" Where "
cQuery	+= " E1_CLIENTE	='"+SA1->A1_COD+"' AND E1_SALDO <> 0 AND E1_VENCTO < '" +DTOS(dEmissao)+"'"
cQuery	+= " AND D_E_L_E_T_ <>'*'  AND E1_TIPO IN ('NF','NDC') GROUP BY E1_MOEDA ORDER BY E1_MOEDA " 
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), calias1, .F., .T.)

dbselectarea(calias1)

While !eof()
   DO	Case                                                                       
		Case (calias1)->MONEDA == 1 // SI ES DOLARES
   			 nValm1	:= (cAlias1)->DEUDA	
   		Case (calias1)->MONEDA == 2 // SI ES DOLARES
   			 nValm2	:= (cAlias1)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA2")
   		Case (calias1)->MONEDA == 3 // SI ES Euros
   			 nValm3	:= (cAlias1)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA3")
   		Case (calias1)->MONEDA == 4 // SI ES DOLARES
   			 nValm4	:= (cAlias1)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA4")   			    			
   		Case (calias1)->MONEDA == 5 // SI ES DOLARES
		 nValm5	:= (cAlias1)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA5")
	EndCase
(calias1)->(dbskip())
EndDo
(calias1)->(dbclosearea())

cQuery2	:= "SELECT SUM(E1_SALDO) AS DEUDA, E1_MOEDA as MONEDA FROM "+RetSqlname("SE1") +" Where "
cQuery2	+= " E1_CLIENTE	='"+SA1->A1_COD+"' AND E1_SALDO <> 0 AND E1_VENCTO < '" +DTOS(dEmissao)+"'"
cQuery2	+= " AND D_E_L_E_T_ <>'*'  AND E1_TIPO IN ('NCC','RA') GROUP BY E1_MOEDA ORDER BY E1_MOEDA " 
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery2), calias2, .F., .T.)

dbselectarea(calias2)

While !eof()
   DO	Case                                                                       
		Case (calias2)->MONEDA == 1 // SI ES DOLARES
   			 nValm1	-= (cAlias2)->DEUDA	
   		Case (calias2)->MONEDA == 2 // SI ES DOLARES
   			 nValm2	-= (cAlias2)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA2")
   		Case (calias2)->MONEDA == 3 // SI ES Euros
   			 nValm3	-= (cAlias2)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA3")
   		Case (calias2)->MONEDA == 4 // SI ES DOLARES
   			 nValm4	-= (cAlias2)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA4")   			    			
   		Case (calias2)->MONEDA == 5 // SI ES DOLARES
		 nValm5	-= (cAlias2)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA5")
	EndCase
(calias2)->(dbskip())
EndDo
(calias2)->(dbclosearea())




nValVenc	:= nValm1	+	nValm2 + nValm3 + nValm4 + nValm5
Restarea(aARea)
Return nValVenc	



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTraeVenc   บAutor  ณMicrosiga           บ Data ณ  10/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Trae Saldo de titulos vencidos                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TraeAVnc
Local nValVenc	:= 0 
lOCAL cQuery2	:= ""
Local cQuery	:= ""
Local nSignop	:= 0 
Local nSignoN	:= 0 
Local cAlias1	:= "Qry1"
Local cAlias2	:= "qRY2"
Local nValm1	:= 0 
Local nValm2	:= 0 
Local nValm3	:= 0 
Local nValm4	:= 0 
Local nValm5	:= 0 
Local aArea		:= Getarea()


cQuery	:= "SELECT SUM(E1_SALDO) AS DEUDA, E1_MOEDA as MONEDA FROM "+RetSqlname("SE1") +" Where "
cQuery	+= " E1_CLIENTE	='"+SA1->A1_COD+"' AND E1_SALDO <> 0 AND E1_VENCTO > '" +DTOS(dEmissao)+"'"
cQuery	+= " AND D_E_L_E_T_ <>'*'  AND E1_TIPO IN ('NF','NDC') GROUP BY E1_MOEDA ORDER BY E1_MOEDA " 
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), calias1, .F., .T.)

dbselectarea(calias1)

While !eof()
   DO	Case                                                                       
		Case (calias1)->MONEDA == 1 // SI ES DOLARES
   			 nValm1	:= (cAlias1)->DEUDA	
   		Case (calias1)->MONEDA == 2 // SI ES DOLARES
   			 nValm2	:= (cAlias1)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA2")
   		Case (calias1)->MONEDA == 3 // SI ES Euros
   			 nValm3	:= (cAlias1)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA3")
   		Case (calias1)->MONEDA == 4 // SI ES DOLARES
   			 nValm4	:= (cAlias1)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA4")   			    			
   		Case (calias1)->MONEDA == 5 // SI ES DOLARES
		 nValm5	:= (cAlias1)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA5")
	EndCase
(calias1)->(dbskip())
EndDo              
(calias1)->(dbclosearea())                                                                       

cQuery2	:= "SELECT SUM(E1_SALDO) AS DEUDA, E1_MOEDA as MONEDA FROM "+RetSqlname("SE1") +" Where "
cQuery2	+= " E1_CLIENTE	='"+SA1->A1_COD+"' AND E1_SALDO <> 0 AND E1_VENCTO > '" +DTOS(dEmissao)+"'"
cQuery2	+= " AND D_E_L_E_T_ <>'*'  AND E1_TIPO IN ('NCC','RA') GROUP BY E1_MOEDA ORDER BY E1_MOEDA " 
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery2), calias2, .F., .T.)

dbselectarea(calias2)

While !eof()
   DO	Case                                                                       
		Case (calias2)->MONEDA == 1 // SI ES DOLARES
   			 nValm1	-= (cAlias2)->DEUDA	
   		Case (calias2)->MONEDA == 2 // SI ES DOLARES
   			 nValm2	-= (cAlias2)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA2")
   		Case (calias2)->MONEDA == 3 // SI ES Euros
   			 nValm3	-= (cAlias2)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA3")
   		Case (calias2)->MONEDA == 4 // SI ES DOLARES
   			 nValm4	-= (cAlias2)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA4")   			    			
   		Case (calias2)->MONEDA == 5 // SI ES DOLARES
		 nValm5	-= (cAlias2)->DEUDA	*	Posicione("SM2",1,dEmissao,"M2_MOEDA5")
	EndCase
(calias2)->(dbskip())
EndDo              
(calias2)->(dbclosearea())

nValVenc	:= nValm1	+	nValm2 + nValm3 + nValm4 + nValm5

RestArea(aArea)
Return nValVenc	


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTraeProm   บAutor  ณMicrosiga           บ Data ณ  10/20/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcion para traer el promedio de dias de atraso           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TraeProm()
Local nDiasAt	:= 0 
lOCAL cQuery2	:= ""
Local cQuery	:= ""
Local nSignop	:= 0 
Local nSignoN	:= 0 
Local cAlias1	:= "Qry1"
Local cAlias2	:= "qRY2"
Local nValm1	:= 0 
Local ntotTit	:= 0 
Local nTotPag	:= 0 
Local aArea		:= Getarea()
Local nSigno	:= 0 
Local aDatTit	:= {}
Local aDatpag	:= {}
Local nDiasAt	:= 0            
Local nDiasAt1	:= 0            
Local nCoef		:= 0
Local nCoef1	:= 0 



cQuery	:= "SELECT * FROM "+RetSqlname("SEL") +" Where "
cQuery	+= " EL_RECIBO	='"+cRecibo+"' AND EL_FILIAL ='"+Xfilial("SEL")+ "' AND EL_SERIE ='"+cSerie+"'"
cQuery	+= " AND D_E_L_E_T_ <>'*'  AND EL_CANCEL <> 'T' " 
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), calias1, .F., .T.)

dbselectarea(calias1)

While !eof()
   DO	Case                                                                       
		Case (calias1)->EL_TIPODOC ='TB'  // SI son titulos Bajados
			nSigno	:= if(aLLTRIM(EL_TIPO) $ GETMV("MV_CRNEG"),-1,1)
   			ntotTit	+= (cAlias1)->EL_VLMOED1 * nSigno
   			 AADD(aDatTit,{sTod((cAlias1)->EL_DTVCTO) , (calias1)->EL_VLMOED1* nSigno})
   		Otherwise                                 
			nSigno	:= if(aLLTRIM(EL_TIPO) $ GETMV("MV_CRNEG"),-1,1)
   			nTotPag	+= (cAlias1)->EL_VLMOED1 * nSigno
 			 AADD(aDatPag,{sTod((cAlias1)->EL_DTVCTO) , (calias1)->EL_VLMOED1 * nSigno}  )                                                          			
	EndCase
(calias1)->(dbskip())
EndDo              
(calias1)->(dbclosearea())
                           
	for nx	:= 1 to len(aDatTit)
       nDiasAt := dEmissao - aDatTit[nx][1]
       nCoef	+=  nDiasAt	* aDatTit[nx][2]
   	Next
nDiasAt	:= nCoef / nTotTit                                    

	for ny	:= 1 to len(aDatPag)
		nDiasAt1	:= dEmissao - aDatPag[ny][1]  
		nCoef1		+= nDiasAt1	* aDatPag[ny][2]
	Next
nDiasat1	:= ncoef1	/	nTotPAg

nDiasAt	:= ndiasAt	+	ndiasAt1

RestArea(aArea)
Return             nDiasAt