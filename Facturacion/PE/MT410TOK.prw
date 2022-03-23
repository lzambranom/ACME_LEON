#include 'Totvs.ch'
 
/*/
Este ponto de entrada é executado ao clicar no botão OK e pode ser usado para validar 
a confirmação das operações: incluir,  alterar, copiar 
e excluir.Se o ponto de entrada retorna o conteúdo .T., o sistema continua a operação, 
caso contrário, volta para a tela do pedido.
/*/
/*/{Protheus.doc} MT410TOK
description
@type function
@version 
@author Axel Diaz
@since 3/6/2020
@return return_type, return_description
/*/
User Function MT410TOK()
Local lRet          := .T.				// Conteudo de retorno
Local cMsg          := ""				// Mensagem de alerta
Local nOpc          := PARAMIXB[1]	// Opcao de manutencao
Local aRecTiAdt     := PARAMIXB[2]	// Array com registros de adiantamentoc
Local nPosCant   := AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_QTDVEN' })
Local nPos2Cant  := AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_UNSVEN' })
Local nPosLBCant := AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_QTDLIB' })
Local nPosLB2Cant:= AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_QTDLIB2' })
Local nI         :=0

For nI:=1 to len(aCols)
    aCols[nI][nPosLBCant]:=aCols[nI][nPosCant]
    aCols[nI][nPosLB2Cant]:=aCols[nI][nPos2Cant]
Next

Return(lRet)