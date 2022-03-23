#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBNFE    บAutor  ณEDUAR ANDIA          บ Data ณ  02/04/2015บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE - Para filtrar a contabiliza็ใo LP Off-Line emm Compras บฑฑ
ฑฑบ          ณ na rotina Reg.Ctb.doc (CTBANFE)                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 							                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTBNFE()
Local aOptimize := ParamIXB
Local cPerg    := "CTBNFE"
/*
Onde: 
aOptimize[1] :=  '' // Clausula SELECT feita pelo Usuario
aOptimize[2] :=  '' // Clausula FROM feita pelo Usuario
aOptimize[3] :=  '' // Clausula WHERE feita pelo Usuario
*/

/*
Aviso("aOptimize[1] - SELECT : ",aOptimize[1],{"OK"}) 
Aviso("aOptimize[2] - FROM :   ",aOptimize[2],{"OK"})
Aviso("aOptimize[3] - WHERE :  ",aOptimize[3],{"OK"})
*/

If Type("mv_par09")<> 'U'
	If !Empty(AllTrim(mv_par09))
		aOptimize[3] += " AND SD1.D1_DOC = '" + mv_par09 +"'"
	Endif
Endif

Return (aOptimize)