
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT105TOK  ºAutor  ³TOTVS               º Data ³   /   /     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDes ³Punto de entrada para validacion de NIT en comprobantes contables º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT105TOK()

Local lRet := .T. 
 
IF TMP->CT2_DC=='1'
	If !empty(TMP->CT2_EC05DB)	
   	DbselectArea("CV0")
   	DbSetOrder(1)
   	DbSeek(xFilial("CV0")+"01"+TMP->CT2_EC05DB)
	   If Found()
          lRet	:= .T.
       Else  
          lRet	:= .F.  
          MsgInfo("El NIT " +TMP->CT2_EC05DB + " en debito de la linea " +TMP->CT2_LINHA +" no existe")
       End If   
    End If	   
 ELSEIF TMP->CT2_DC=='2'   
 	If !empty(TMP->CT2_EC05CR)	
   	DbselectArea("CV0")
   	DbSetOrder(1)
   	DbSeek(xFilial("CV0")+"01"+TMP->CT2_EC05CR)
	   If Found()
          lRet	:= .T.
       Else  
          lRet	:= .F.  
          MsgInfo("El NIT " +TMP->CT2_EC05CR + " en credito de la linea " +TMP->CT2_LINHA +" no existe")
       End If   
    End If
 ELSE
	 lRet	:= .T.
 ENDIF     


Return lRet