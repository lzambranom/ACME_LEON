#include 'protheus.ch'
#include 'parmtype.ch'

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  MTA110MNU ?Autor  ?Erick Etcheverry ? Data ?  07/12/2021     ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?Punto de Entrada que adiciona un boton para imprimir        ???
???          ?de acuerdo a una rutina en especifica 					  ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Acme                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function MTA110MNU()
	AADD(AROTINA,{ 'Imp.Solicitud',"U_IMPSOLC()"     , 0 , 5})
return
