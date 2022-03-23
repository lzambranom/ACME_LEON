User function M465DORIFE()

        Local lRet := .F.
        Local cCRLF := (chr(13) + chr(10) )
        Local cFilDoc := PARAMIXB[1]      // Sucursal
        Local cNumDoc := PARAMIXB[2] // Número de Documento
        Local cSerieDoc := PARAMIXB[3] // Serie
        Local cCodCli := PARAMIXB[4]    // Código de Cliente
        Local cCodLoj := PARAMIXB[5]   // Código de Tienda
// Crear parametro CO_SERTRFE y agregar series de factura electronica que requieren validación de transmisión en NCC/NCD.
If Alltrim(cSerieDoc) $ AllTrim(GetNewPar("CO_SERTRFE",""))//"NCE|NDE|FVE"   Serie de factura seleccionada o relacionada.
	lRet := .T.
EndIf  

If Alltrim(M->F1_SERIE) $ AllTrim(GetNewPar("CO_SERTRFE",""))//  Serie de nota credito/debito seleccionada.
	lRet := .T.
EndIf

Return lRet