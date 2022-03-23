#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTBNFE    �Autor  �EDUAR ANDIA          � Data �  02/04/2015���
�������������������������������������������������������������������������͹��
���Desc.     � PE - Para filtrar a contabiliza��o LP Off-Line emm Compras ���
���          � na rotina Reg.Ctb.doc (CTBANFE)                            ���
�������������������������������������������������������������������������͹��
���Uso       � 							                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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