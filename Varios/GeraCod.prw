#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraCod   ºAutor  ³Lucas Riva Tsuda    ºFecha ³  19/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Genera el codigo del producto de acuerdo con la regla de    º±±
±±º          ³Stefanini (TIPO + NNNNN)                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Stefanini                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function GeraCod(cTipo)

Local cQuery  := ""      
Local cAlias  := "" 
Local aArea   := GetArea()  
Local cRet    := ""
    
	cAlias := GetNextAlias()
								
	cQuery := "SELECT B1_COD, B1_TIPO "
	cQuery += "FROM " + RetSqlName("SB1") + " "
	cQuery += "WHERE D_E_L_E_T_ = ' ' AND "
	cQuery += "B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "B1_TIPO = '" + cTipo + "' "
	cQuery += "ORDER BY B1_COD DESC
								
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  	
		
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())
	If (cAlias)->(!EOF())
	
	    //cRet := Soma1(Alltrim((cAlias)->B1_COD),,,.F.)
	    cRet := Substr((cAlias)->B1_COD,1,2) + Alltrim(Str(Val(Substr(Alltrim((cAlias)->B1_COD),3,Len((cAlias)->B1_COD)))+1)) 
			
	EndIf	
					
	(cAlias)->(DbCloseArea())
	RestArea(aArea)

Return cRet