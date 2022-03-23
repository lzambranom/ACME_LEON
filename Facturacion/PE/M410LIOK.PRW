/*
Descricao : Ponto de entrada para validação da linha (item) da rotina de
pedido de venda. Executado no momento em que sai da linha e
antes da confirmação do pedido.
————————————————————————————————-
Partida : MATA410 (Pedidos de Venda)
=============================================================
*/
#include 'Protheus.ch'
/*/{Protheus.doc} M410LIOK
description
@type function
@version 
@author Axel Diaz
@since 3/6/2020
@return return_type, return_description
/*/
/*
User Function M410LIOK()

Local lOk := .T.
//Local aArea      := GetArea()
Local nPosCant   := AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_QTDVEN' })
Local nPos2Cant  := AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_UNSVEN' })
Local nPosLBCant := AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_QTDLIB' })
Local nPosLB2Cant:= AScan(aHeader,{|x| AllTrim(x[2]) == 'C6_QTDLIB2' })

aCols[N][nPosLBCant]:=aCols[N][nPosCant]
aCols[N][nPosLB2Cant]:=aCols[N][nPos2Cant]

Return (lOk)
*/