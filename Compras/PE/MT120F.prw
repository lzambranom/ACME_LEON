//	MT120F() Manipula os dados no pedido de Compras na tabela SC7
// 	Ap�s a grava��o dos itens do pedido de compras, no final da fun��o A120GRAVA, 
//	pode ser usado para manipular os dados gravados do pedido de compras na tabela SC7, 
//	recebe como parametro a filial e numero do pedido.

User Function MT120F()
Local cPedido  	:= PARAMIXB
Local cTemp 	:= ""

dBselectArea('SC7')
dbSetOrder(1)
dbSeek(cPedido)
//Codigo do usuario ...
While cPedido == xfilial("SC7")+SC7->C7_NUM
	If FunName() = "MATA121"
		cTemp := cXObserv
	EndIf
	//RECLOCK("SC7", .F.)
		SC7->C7_XOBSG := cTemp
	  //	ALERT("Altero TES del item " + SC7->C7_ITEM)
	//MSUNLOCK()     // Destraba el registro.
	dbskip()
enddo	
Return 
