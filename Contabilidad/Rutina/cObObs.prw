
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?NOVO6     ?Autor  ?Microsiga           ?Fecha ?  09/06/18   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User function ObObs()
Local cObs :=""
Local aArea:= getarea()       
Local cMemo:= POSICIONE("SD1",4,xFilial("SD1")+SD1->D1_NUMSEQ,"D1_XOBS")

If MLCount(cMemo,5)>0  
	cObs:=MemoLine(cMemo,35) 
else
	cObs:=""
Endif

restarea(aArea)
 
Return (cObs)