#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTANIIF   ºAutor  ³EDUAR ANDIA         º Data ³  21/06/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Función que retorna la cuenta equivalente NIIFs registrada º±±
±±º          ³ en el Plan de cuenta (CT1_XNIIFS)                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GAMA\Colombia                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CtaNIIF(cConta)
Local aArea 	:= GetArea()
Local cQry   	:= ""
Local cCtaNiif	:= ""         
Default cConta	:= ""

If !Empty(cConta)

	cQry :="SELECT * FROM " + RetSqlName("CT1") +" WHERE CT1_FILIAL = '"  + xFilial("CT1") + "'"+ " AND CT1_CONTA = '" + cConta + "'"+" AND D_E_L_E_T_ = ''"  
	
	If Select("StrSQL") > 0  //En uso
	   StrSQL->(DbCloseArea())
	Endif
					
	cQry := ChangeQuery(cQry)
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQry),"StrSQL", .F., .T.)
	
	DbSelectArea("StrSQL")
	DbGoTop()
	If !Empty(StrSQL->(CT1_XNIIFS))
		cCtaNiif := StrSQL->(CT1_XNIIFS)
	Endif				
	StrSQL->(dbCloseArea()) 
	
	RestArea(aArea)
Endif
Return(cCtaNiif)
