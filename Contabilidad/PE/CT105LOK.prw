 #include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT105LOK    �Autor  �TOTVS             �Fecha �  03/21/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inserta la descripcion de las cuentas contables al         ���
���          � avanzar entre renglones.                                   ���
���          � Valida existencia de NIT en comprobantes contables         ���
�������������������������������������������������������������������������͹��
���Uso       � - SIGACTB                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CT105LOK

Local cArea := GetArea()
Local lRet	:= .T.
	  
TMP->CT2_XDESCA := Posicione("CT1",1,xFilial("CT1")+TMP->CT2_DEBITO,"CT1_DESC01")                         
TMP->CT2_XDESAB := Posicione("CT1",1,xFilial("CT1")+TMP->CT2_CREDIT,"CT1_DESC01") 
	
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
		
RestArea(cArea)

Return(lRet)
