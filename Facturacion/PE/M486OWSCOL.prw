#include 'protheus.ch'

User Function M486OWSCOL
    Local cSerieDoc  := PARAMIXB[1] //Serie
    Local cNumDoc    := PARAMIXB[2] //Número de Documento
    Local cCodCli    := PARAMIXB[3] //Código de Cliente
    Local cCodLoj    := PARAMIXB[4] //Código de la Tienda
    Local oXML       := PARAMIXB[5] //Objeto del XML
    Local nOpc       := PARAMIXB[6] //1=Nivel documento 2=Nivel detalle
    Local oWS        := PARAMIXB[7] //Objeto de web services
    Local nX         := 0
    Local cnumOrden  := ""
    Local cnumPedido := ""
	Local cAmbiente  := SuperGetMV("MV_CFDIAMB" ,.F. , "2" )
	Local cAcmeNF2   := SuperGetMV("MV_XACMENF" ,.F. , "2" )
    Local c443       := ""
    Local c5170001   := " "
    Local c5170003   := " "
    Local c5170004   := " "
    Local c5170005   := " "
    Local c5170006   := " "
    Local cCodEmp    := FWCodEmp()
    //Local c3Qry      := ""
    nValBrut         := 0

    If cCodEmp=='01'
        //F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE+F2_TIPO+F2_ESPECIE 
        If nOpc == 1 //Encabezado
            // Posicionar cliente
            If cAmbiente<>'2' .and.  cAcmeNF2<>'2' // No es Demo
                SA1->(dbSetOrder(1))
                If SA1->(msSeek(xFilial("SA1")+cCodCli+cCodLoj)) 
                    If !Empty(SA1->A1_EMAIL) // Como ejemplo se usa el campo A1_EMAIL (Comentarios de perfil)
                        aEmail := StrTokArr(alltrim(SA1->A1_EMAIL), ",") // Las cuentas de correo están separadas por coma
                        oWS:oWSCliente:cnotificar := "SI" // Indicar Sí notificar
                        oWSDest := Service_Destinatario():NEW() // Crea objeto destinatario, el medio de entrega es 0=email
                        oWSDest:ccanalDeEntrega := "0"
                        oWSDest:oWSemail := Service_ArrayOfstring():NEW() // Crea arreglo de las cuentas de correo
                        For nX := 1 to Len(aEmail)
                            aAdd(oWSDest:oWSEmail:cstring, aEmail[nX])
                        Next nX
                        If !EMPTY(cNFcc) 
                            aAdd(oWSDest:oWSEmail:cstring,cNFcc)
                        EndIf
                        aAdd(oWS:oWSCliente:oWSDestinatario:oWSDestinatario, oWSDest) // Agrega destinatario al objeto principal
                    EndIf
                EndIf
            EndIf
            oWS:oWSextras:=Service_ArrayOfExtras():new()
            oWSextra:=Service_Extras():new()
            oWSextra:ccontrolInterno1     := "TEMPLATE" 
            oWSextra:ccontrolInterno2     := ""
            oWSextra:cnombre              := "333221"
            oWSextra:cpdf                 := "1"
            //oWSextra:cvalor               := "co-acmeleon-69"
            //oWSextra:cvalor               := "co-acmeleon-74"
            oWSextra:cvalor               := "co-acmeleon-88"
            oWSextra:cxml                 := "0"
            aAdd(oWS:oWSextras:oWSextras,oWSextra) 
    

            IF (ALLTRIM(cEspecie)<>'NCC') 
                c443    := POSICIONE("SA3",1,XFILIAL("SA3")+POSICIONE("SF2",2, XFILIAL("SF2")+cCodCli+cCodLoj+cNumDoc+cSerieDoc+"N"+"NF   ","F2_VEND1"),"A3_NOME")
                IF !EMPTY(c443)
                    oWSextra:=Service_Extras():new()
                    oWSextra:ccontrolInterno1     := "Vendedor" 
                    oWSextra:ccontrolInterno2     := ""
                    oWSextra:cnombre              := "443"
                    oWSextra:cpdf                 := "1"
                    oWSextra:cvalor               := c443
                    oWSextra:cxml                 := "0"
                    aAdd(oWS:oWSextras:oWSextras,oWSextra) 
                EndIf
            else
                c443    := POSICIONE("SA3",1,XFILIAL("SA3")+POSICIONE("SF1",1, XFILIAL("SF1")+cNumDoc+cSerieDoc+cCodCli+cCodLoj+"D","F1_VEND1"),"A3_NOME")
                IF !EMPTY(c443)
                    oWSextra:=Service_Extras():new()
                    oWSextra:ccontrolInterno1     := "Vendedor" 
                    oWSextra:ccontrolInterno2     := ""
                    oWSextra:cnombre              := "443"
                    oWSextra:cpdf                 := "1"
                    oWSextra:cvalor               := c443
                    oWSextra:cxml                 := "0"
                    aAdd(oWS:oWSextras:oWSextras,oWSextra)
                EndIf
            EndIf
    
            c5170001   := "<![CDATA[<div style='font-size: 10px'>IVA REGIMEN COMUN RAD. No. 03-5187-18<br>CODIGO ICA 2229 TARIFA 6.5X1000 FAVOR NO HACER RETENCION DE ICA CONTRIBUYENTE FUNZA CUNDINAMARCA<p>SEGUN RESOLUCION 00041 DEL 30 DE ENERO DE 2014. <b>YA NO SOMOS<br>GRANDES CONTRIBUYENTES, SOMOS AUTORRETENEDORES</b><br>RES. No. 003137 DE ABRIL 08 DE 2010</p>]]>"
            c5170003   := "<![CDATA[WWW.ACMELEON.COM]]>"
            c5170004   := "<![CDATA[<div style='font-size: 10px'><br>PLANTA FUNZA CUNDINAMARCA</br><br>CALLE 27 No. 7A 01<br>TELS. 8258066/67 <br>FAX 8258069</div>]]>"
            c5170005   := "<![CDATA[<div style='font-size: 10px'><br>SEDE ADMINISTRATIVA BOGOTA</br><br>CARRERA 42B No. 12B 45<br>PBX 3688838 FAX 2686905 <br>APARTADO AEREO 50680</div>]]>"
            c5170006   := "<![CDATA[<div style='font-size: 10px'><br>ESTA FACTURA GENERA INTERESES DE MORA A LA TASA MAXIMA PERMITIDA POR LEY </br>Autorizo a Acme Leon Plasticos SAS en forma permanente e irrevocable para que con fines de informacion bancaria o comercial consulte, informe o reporte a las centrales de riesgo toda la informacion referente para conocer mi desempeno como deudor, mi capacidad de pago o para validar el riesgo futuro de concederme un credito. AL MOMENTO DE CANCELAR FAVOR EXIGIR EL RECIBO DE CAJA</div>]]>"		
                     
            nValBrut := 0
      
            nValBrut:=POSICIONE("SF2",2, XFILIAL("SF2")+cCodCli+cCodLoj+cNumDoc+cSerieDoc+"N"+"NF   ","F2_VALBRUT")            
                
            oWSextra:=Service_Extras():new()
            oWSextra:ccontrolInterno1     := "extra" 
            oWSextra:ccontrolInterno2     := ""
            oWSextra:cnombre              := "5170001"
            oWSextra:cpdf                 := "1"
            oWSextra:cvalor               := c5170001
            oWSextra:cxml                 := "0"
            aAdd(oWS:oWSextras:oWSextras,oWSextra) 

            oWSextra:=Service_Extras():new()
            oWSextra:ccontrolInterno1     := "extra" 
            oWSextra:ccontrolInterno2     := ""
            oWSextra:cnombre              := "5170002"
            oWSextra:cpdf                 := "1"
            oWSextra:cvalor               := TRANSFORM(nValBrut,"@E 999,999,999.99")
            oWSextra:cxml                 := "0"
            aAdd(oWS:oWSextras:oWSextras,oWSextra) 

            oWSextra:=Service_Extras():new()
            oWSextra:ccontrolInterno1     := "extra" 
            oWSextra:ccontrolInterno2     := ""
            oWSextra:cnombre              := "5170003"
            oWSextra:cpdf                 := "1"
            oWSextra:cvalor               :=  c5170003
            oWSextra:cxml                 := "0"
            aAdd(oWS:oWSextras:oWSextras,oWSextra) 

            oWSextra:=Service_Extras():new()
            oWSextra:ccontrolInterno1     := "extra" 
            oWSextra:ccontrolInterno2     := ""
            oWSextra:cnombre              := "5170004"
            oWSextra:cpdf                 := "1"
            oWSextra:cvalor               := c5170004
            oWSextra:cxml                 := "0"
            aAdd(oWS:oWSextras:oWSextras,oWSextra) 

            oWSextra:=Service_Extras():new()
            oWSextra:ccontrolInterno1     := "extra" 
            oWSextra:ccontrolInterno2     := ""
            oWSextra:cnombre              := "5170005"
            oWSextra:cpdf                 := "1"
            oWSextra:cvalor               := c5170005
            oWSextra:cxml                 := "0"
            aAdd(oWS:oWSextras:oWSextras,oWSextra)

            //oWS:oWSextras:=Service_ArrayOfExtras():new()
           
            oWSextra:=Service_Extras():new()
            oWSextra:ccontrolInterno1     := "extra" 
            oWSextra:ccontrolInterno2     := ""
            oWSextra:cnombre              := "5170006"
            oWSextra:cpdf                 := "1"
            oWSextra:cvalor               := c5170006
            oWSextra:cxml                 := "0"
            aAdd(oWS:oWSextras:oWSextras,oWSextra)
        

            IF (ALLTRIM(cEspecie)<>'NCC') 
                cBuscaSE1:=xFilial("SE1")+ cCodCli + cCodLoj + cSerieDoc + cNumDoc+SPACE(TamSX3("E1_PARCELA")[1])+cEspecie             
                dVence:=POSICIONE("SE1",2,cBuscaSE1,"E1_VENCTO")
                cVence:=dtos(dVence)

                lContado:= IF(ALLTRIM(POSICIONE("SE4",1,XFILIAL("SE4")+POSICIONE("SF2",2, XFILIAL("SF2")+cCodCli+cCodLoj+cNumDoc+cSerieDoc+"N"+"NF   ","F2_COND"),"E4_COND"))=='0',.T.,.F.)
                //cVence := '20220409'
                
                If !EMPTY(cVence)
                    oWS:oWSMediosDePago:=Service_ArrayOfMediosDePago():New()
                    oWSMediosPago:=Service_MediosDePago():New()
                    oWSMediosPago:cfechaDeVencimiento:=LEFT(cVence,4)+"-"+SUBSTR(cVence,5,2)+"-"+RIGHT(cVence,2)
                    oWSMediosPago:cmedioPago:="ZZZ"
                    oWSMediosPago:cmetodoDePago:=IF(lContado ,'1','2') // "2"=Credito
                    oWSMediosPago:cnumeroDeReferencia:='01' //alltrim(cSerieDoc)+"-"+ cValToChar(val(cNumDoc))//"01"
                    aAdd(oWS:oWSMediosDePago:oWSMediosDePago,oWSMediosPago)
                else
                    oWS:oWSMediosDePago:=Service_ArrayOfMediosDePago():New()
                    oWSMediosPago:=Service_MediosDePago():New()
                    //oWSMediosPago:cfechaDeVencimiento:=LEFT(cVence,4)+"-"+SUBSTR(cVence,5,2)+"-"+RIGHT(cVence,2)
                    oWSMediosPago:cmedioPago:="ZZZ"
                    oWSMediosPago:cmetodoDePago:=IF(lContado ,'1','2') // "2"=Credito
                    oWSMediosPago:cnumeroDeReferencia:='01' //alltrim(cSerieDoc)+"-"+ cValToChar(val(cNumDoc))//"01"
                    aAdd(oWS:oWSMediosDePago:oWSMediosDePago,oWSMediosPago)
                ENDIF
                cnumOrden:=POSICIONE("SF2",2, XFILIAL("SF2")+cCodCli+cCodLoj+cNumDoc+cSerieDoc+"N"+"NF   ","F2_XORDCOM")            
                cnumOrden:=IF(EMPTY(cnumOrden),"S/N",cnumOrden)
                cnumPedido:=POSICIONE("SD2",3, XFILIAL("SF2")+cNumDoc+cSerieDoc+cCodCli+cCodLoj,"D2_PEDIDO")
                cnumPedido:=IF(EMPTY(Alltrim(cnumPedido)),"NF Directa",cnumPedido)
                oWS:oWSordenDeCompra:=Service_ArrayOfOrdenDeCompra():New()
                oWSOrdenDeCompra:=Service_OrdenDeCompra():New()
                oWSOrdenDeCompra:cnumeroOrden:=cnumOrden
                oWSOrdenDeCompra:cnumeroPedido:=cnumPedido
                oWSOrdenDeCompra:ccodigoCliente:=ALLTRIM(cCodCli)+"-"+ALLTRIM(cCodLoj)
                aAdd(oWS:oWSordenDeCompra:oWSordenDeCompra,oWSOrdenDeCompra) 

            EndIf
        Endif
    EndIf
Return

// Campo para cajas  :  PONERLO EN EL CAMPO 5171 LA LINEA DE INFORMACIO ADICIONAL / FACTURADETALLE 
