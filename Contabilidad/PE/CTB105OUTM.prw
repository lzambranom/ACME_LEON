#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTB105OUTM�Autor  �Microsiga           � Data �  09/18/14   ���
�������������������������������������������������������������������������͹��  
���Desc.     �Punto de entrada para llamar a funcion de usuario de        ���
���          � impresion de comprobantes contables en CTBA102, antes de   ���
���          � gravar en ct2						  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CTB105OUTM()
Local aAreactb:= GETAREA()

If FunName() == "CTBA102"            
  If MsgYesNo("Desea Imprimir el comprobante contable?","Impresion de comprobante contable") 
	U_CTBI001(.T.)                                      
  Endif  
Endif        
                   
RestArea(aAreactb)

Return  .T.     
                   

