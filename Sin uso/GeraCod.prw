#include 'protheus.ch'
#include 'parmtype.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraCod   �Autor  �Lucas Riva Tsuda    �Fecha �  19/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �Genera el codigo del producto de acuerdo con la regla de    ���
���          �Stefanini (TIPO + NNNNN)                                    ���
�������������������������������������������������������������������������͹��
���Uso       �Stefanini                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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