#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "topconn.ch"
#Include "mata486.ch"

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �M486NFXML   � Autor � Luis Enriquez         � Data � 31.05.17 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Generacion de XML de Factura - Boleta de Venta  para factura- ���
���          �cion electronica de Peru, de acuerdo a estandar UBL 2.0, para ���
���          �ser enviado a TSS para su envio a la SUNAT. (PERU)            ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � M486NFXML(cFil, cSerie, cCliente, cLoja, cNumDoc, cEspDoc)   ���
���������������������������������������������������������������������������Ĵ��
���Parametros� cFil .- Sucursal que emitio el documento.                    ���
���          � cSerie .- Numero o Serie del Documento.                      ���
���          � cCliente .- Codigo del cliente.                              ���
���          � cLoja .- Codigo de la tienda del cliente.                    ���
���          � cNumDoc .- Numero de documento.                              ���
���          � cEspDoc .- Especie del documento.                            ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � MATA486                                                      ���
���������������������������������������������������������������������������Ĵ��
���Programador   � Data   � BOPS/FNC  �  Motivo da Alteracao                ���
���������������������������������������������������������������������������Ĵ��
���Luis Enriquez �31/07/18�DMINA-3376 �Correcci�n para agregar imptos a XML ���
���(PERU)        �        �           �s�lo si existen en arreglo y as� evi-���
���              �        �           �tar error.log.                       ���
���M.Camargo     �26/10/18�DMINA-4575 �Implementacion UBL2.1                ���
���M.Camargo     �14/03/19�DMINA-4575 �uso de funcion strZero supliendo el  ���
���              �        �           �uso de substr para generar correlati-���
���              �        �           �vo a 8 caracter�s.                   ���
���M.Camargo     �14/03/19�DMINA-6471 �Si la NF es gratuita, aparecer� leyen���
���              �        �           �da que indicar� muestrasg ratuitas   ���
���M.Camargo     �14/03/19�DMINA-6777 �Si la NF es gratuita, aparecer� el   ���
���              �        �           �monto y pricetype en 02              ���
���M.Camargo     �26/07/19�DMINA-7000 �Si la NF tiene descuentos de agrega  ���
���              �        �           �tag MultiplierFactorNumeric          ���
���              �        �           �y BaseAmount                         ���
���M.Camargo     �14/08/19�DMINA-7289 �Se agrega alltrim en                 ���
���              �        �           �tag MultiplierFactorNumeric          ���
���V. Flores     �06/09/19�DMINA-7628 �Modificaci�n de XML , agregando los  ��� 
��               �        �           �nuevos nodos del impuesto ICBPER     ���
���M.Camargo     �24/09/19�DMINA-7417 �Modificaci�n de XML uso de EXTENSO   ��� 
���M.Camargo     �27/09/19�DMINA-7501 |Ajustes operaciones gratuitas        ���
���M.Camargo     �11/10/19�DMINA-7508 |Apertuna PE M486ENF                  ���
���Luis Enr�quez �06/09/20�DMINA-9655 |Se activan nodos para transmisi�n de ���
��               �        �           �Factura/Boleta con detracci�n.       ��� 
���Luis Enriquez �03/02/21�DMINA-10845�Se activa funcionalidad de Forma de  ���
���              �        �           �Pago para NF Fact. Electr�nica. (PER)���   
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Function M486NFXML(cFil, cSerie, cCliente, cLoja, cNumDoc, cEspDoc) 
	Local cXMLNF   := ""	
	Local cMoneda  := ""
	Local aEncab 	:= {}		
	Local aValAdic 	:= {}
	Local cLetraVB 	:= ""
	Local aArea 	:= getArea()
	Local aImpFact 	:= {} //Impuestos
	Local aDetFact 	:= {} //Items	
	Local cTpDocA1 	:= ""
	Local nTotalFac	:= 0
	Local lFacGra 	:= .F.
	Local lDocExp 	:= .F.		
	Local aGastos 	:= {}
	Local cValBrut 	:= 0
	Local cFecha 	:= ""
	Local cFolio 	:= ""
	Local cTpDoc01 := ""
	Local aGRNF		:= {}    
	Local nDescont	:= 0
	Local nGastos	:= 0
	Local nTotImp	:= 0
	Local cSF1Hrs  := time()	
	Local lIvap 	:= .F.		
	Local cOpeExp   := ""	
    Local cTipoPag  := ""
	Local cFilSE4   := xFilial("SE4")
	Local aParc     := {}
	Local nSalPago  := 0

	Private lTipoPago := SE4->(ColumnPos("E4_MPAGSAT")) > 0

	dbSelectArea("SF2")
	SF2->(dbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
	If SF2->(dbSeek(cFil + cNumDoc + cSerie + cCliente + cLoja)) 	
		cFolio := RTRIM(SF2->F2_SERIE2) + "-" + STRZERO(VAL(SF2->F2_DOC),8)
		cFecha := Alltrim(Str(YEAR(SF2->F2_EMISSAO))) + "-" + Padl(Alltrim(Str(MONTH(SF2->F2_EMISSAO))),2,'0') + "-" +;
		Padl(Alltrim(Str(DAY(SF2->F2_EMISSAO))),2,'0')		
		cMoneda   := ALLTRIM(Posicione("CTO",1,xFilial("CTO")+Strzero(SF2->F2_MOEDA,2),"CTO_MOESAT"))
		cSF1Hrs := SF2->F2_HORA
		
		If alltrim(cEspDoc) == "NF" .AND. 'F' $ Substr(SF2->F2_SERIE2,1,1) // Factura
			cTpDoc01 := '01'
			cOpeExp  := "0200|0201|0202|0203|0204|0205|0206|0207|0208"
			If lTipoPago
				cTipoPag := M486TPPAG(cFilSE4, SF2->F2_COND)
				If cTipoPag == "2" //Cr�dito
					M486CUOTA(F2_FILIAL,F2_CLIENTE,F2_LOJA,F2_SERIE,F2_DOC,F2_ESPECIE,@aParc,@nSalPago)
				EndIf
			EndIf
		ElseIf alltrim(cEspDoc) == "NF" .AND. 'B' $ Substr(SF2->F2_SERIE2,1,1) .AND. cTpDocA1 # "06" // Boleta de Venta
			cTpDoc01 := '03'
			cOpeExp  := "0200|0201|0203|0204|0206|0207|0208"
		EndIf	

		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))//A1_FILIAL+A1_COD+A1_LOJA
		
		If dbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)
			cTpDocA1 := SA1->A1_TIPDOC
			lDocExp := IIf(SA1->A1_EST == "EX" .And. SF2->F2_TIPONF $ cOpeExp,.T.,.F.)
		Else
			cTpDocA1 := ""
		EndIf	
	
		//Impuestos				
		M486XMLIMP(SF2->F2_ESPECIE,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA, lDocExp, @aImpFact, @aDetFact, @aValAdic, @nTotalFac, @lFacGra,@aGRNF, @nTotImp,@lIvap)		
		
		If !lFacGra
			cLetraVB := Extenso(SF2->F2_VALBRUT,.f.,SF2->F2_MOEDA,,"2",.t.,.t.) 
		Else
			cLetraVB :=  fCero2Text(SF2->F2_MOEDA)
		EndIf		
		
		If SF2->F2_DESCONTO > 0
			aAdd(aGastos,{"00",SF2->F2_DESCONTO}) // Descuentos
			nDescont := SF2->F2_DESCONTO
		EndIf
		If SF2->F2_DESPESA+SF2->F2_FRETE + SF2->F2_SEGURO > 0
			aAdd(aGastos,{"50",SF2->F2_DESPESA+SF2->F2_FRETE + SF2->F2_SEGURO}) // Otros gastos
			nGastos := SF2->F2_DESPESA+SF2->F2_FRETE + SF2->F2_SEGURO
		EndIf
		//Encabezado
		cValBrut  := IIF(lFacGra,0, SF2->F2_VALBRUT)//nTotalFac		
		/*
			01. Documento
			02. Fecha
			03. Serie
			04. Tipo de documento Sunat
			05. Moneda
			06. Total de venta documento
			07. Monto Total en letras
			08. Indicador Factura gratuita
			09. Indicador Factura Exportaci�n
			10. N�mero de Orden
			11. Valor de la Mercanci� sin impuestos ni gastos 
			12. Valor Total Descuentos
			13. Valor Total de Gatos (Flete, seguro, otros gastos)	
			14. Total Monto Impuestos
			15.	Tipo de Factura Segun Cat. No 51
			16. Si es de exportacion 	
			17. hr	
			18. Indica si afecat ivap		 			
		*/	
		If nTotalFac == SF2->F2_VALMERC .AND. lDocExp
			aEncab := {cFolio,cFecha,cTpDoc01,cMoneda,cValBrut,cLetraVB, cValBrut, lFacGra, lDocExp,SF2->F2_NUMORC,SF2->F2_VALMERC-nTotImp,nDescont,nGastos, nTotImp, SF2->F2_TIPONF,lDocExp,cSF1Hrs,lIvap,cTipoPag,nSalPago}
		Else
			aEncab := {cFolio,cFecha,cTpDoc01,cMoneda,cValBrut,cLetraVB, cValBrut, lFacGra, lDocExp,SF2->F2_NUMORC,SF2->F2_VALMERC,nDescont,nGastos, nTotImp, SF2->F2_TIPONF,lDocExp,cSF1Hrs,lIvap,cTipoPag,nSalPago}				
		EndIf
		// Se genera XML de Factura/Boleta de Venta		
		cXMLNF := fGenXMLNF(cCliente, cLoja, aValAdic, aEncab, aImpFact, aDetFact,aGRNF,aGastos,lDocExp,aParc)
	EndIf
	RestArea(aArea)	
Return cXMLNF 

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � fGenXMLNF  � Autor � Luis Enriquez         � Data � 01.06.17 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Genera estructura de XML para factura/boleta de venta de     ���
���          � acuerdo a esquema UBL 2.0. (PERU).                           ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � fGenXMLNF(cClie, cTienda, aValAd, aEnc, aImpXML, aDetImp)    ���
���������������������������������������������������������������������������Ĵ��
���Parametros� cClie .- Codigo de cliente.                                  ���
���          � cTienda .- Codigo de tienda de cliente.                      ���
���          � aValAd .- Arreglo con datos para area de adicionales.        ���
���          � aEnc .- Arreglo con datos para encabezado de XML.            ���
���          � aImpXML .- Arreglo con datos impuestos generales de XML.     ���
���          � aDetImp .- Arreglo con datos de detalle de nota de debito pa-���
���          �            ra XML.                                           ���
���������������������������������������������������������������������������Ĵ��
���Retorno   � cXML .- String con estructrura de XML para factura/boleta de ���
���          � venta.                                                       ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � M486XMLPDF                                                   ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function fGenXMLNF(cClie, cTienda, aValAd, aEnc, aImpXML, aDetImp,aGRNF,aGastos,lDocExp,aParc)
	Local cXML  := ""
	Local nX    := 0
	Local cCRLF	:= (chr(13)+chr(10))
	Local nC    := 0
	Local nI    := 0
	Local cTexto := (OemToAnsi(STR0078)) //"TRANSFERENCIA GRATUITA DE UN BIEN Y/O SERVICIO PRESTADO GRATUITAMENTE"
	Local cPicAmount := "999999999999.9999999999"
	Local lRSM   := ALLTRIM(SuperGetMV("MV_PROVFE",,"")) == "RSM"
	Local lProc  := .T.
	Local nDetra := 0
	Local cCtaDetra := ALLTRIM(SuperGetMV("MV_TKN_EMP",.F.,""))
	
	cXML := '<?xml version="1.0" encoding="UTF-8"?>' + cCRLF
	cXML += '<Invoice' + cCRLF 
	cXML += '	xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"' + cCRLF 
	cXML += '	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"' + cCRLF
	cXML += '	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"' + cCRLF 
	cXML += '	xmlns:ccts="urn:un:unece:uncefact:documentation:2"' + cCRLF 
	cXML += '	xmlns:ds="http://www.w3.org/2000/09/xmldsig#"' + cCRLF 
	cXML += '	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"' + cCRLF 
	cXML += '	xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2"' + cCRLF
	cXML += '	xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"' + cCRLF 
	cXML += '	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' + cCRLF
	
	cXML += '	<ext:UBLExtensions>' + cCRLF
	If lRSM
		// Puntos de Entrada que son habiles solamente cuando se usa RSM
		If ExistBlock("M486ENF") .AND. !aEnc[16] .and. "F" $ Substr(aEnc[1],1,1)
			cXML += ExecBlock("M486ENF",.F.,.F.,{SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_ESPECIE,cClie,cTienda})
		ElseIf ExistBlock("M486ENFE") .AND. aEnc[16] .and. "F" $ Substr(aEnc[1],1,1)
			cXML += ExecBlock("M486ENFE",.F.,.F.,{SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_ESPECIE,cClie,cTienda})
		ElseIf ExistBlock("M486EBV") .AND. !aEnc[16] .and. "B" $ Substr(aEnc[1],1,1)
			cXML += ExecBlock("M486EBV",.F.,.F.,{SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_ESPECIE,cClie,cTienda})
		EndIf
	EndIf
   	cXML += '		<ext:UBLExtension>' + cCRLF 
	cXML += '			<ext:ExtensionContent></ext:ExtensionContent>' + cCRLF 
  	cXML += '		</ext:UBLExtension>' + cCRLF    
	cXML += '	</ext:UBLExtensions>' + cCRLF	
	cXML += '	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>' + cCRLF
	cXML += '	<cbc:CustomizationID>2.0</cbc:CustomizationID>' + cCRLF	
	cXML += '	<cbc:ID>' + aEnc[1] + '</cbc:ID>' + cCRLF  
	cXML += '	<cbc:IssueDate>' + aEnc[2] + '</cbc:IssueDate>' + cCRLF
	cXML += '	<cbc:IssueTime>' + aEnc[17] + '</cbc:IssueTime>' + cCRLF  
	If ExistBlock("M486FECVEN") .And. !aEnc[16]
		cXML += ExecBlock("M486FECVEN",.F.,.F.)
	EndIf
	cXML += '	<cbc:InvoiceTypeCode listID="' + aEnc[15]+ '" '
	cXML += 						'name="Tipo de Operacion" '
	cXML += 						'listAgencyName="PE:SUNAT" '
	cXML += 						'listName="Tipo de Documento" '
	cXML += 						'listSchemeURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo51" '
	cXML += 						'listURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo01">' + aEnc[3] + '</cbc:InvoiceTypeCode>' + cCRLF
	cXML += '	<cbc:Note languageLocaleID="1000">' + alltrim(aEnc[6]) + '</cbc:Note>' + cCRLF
	If aEnc[18]
		cXML += '	<cbc:Note languageLocaleID="2007">' + ObtColSAT("S052", '2007', 1, 4,5,250) + '</cbc:Note>' + cCRLF 
	EndIf   
	If aEnc[8] //Gratuitos
		cXML += '	<cbc:Note>' + cTexto + '</cbc:Note>' + cCRLF  
	EndIf
	//Nota requerida para las Detracciones
	AEval(aImpXML, {|x,y| If(aImpXML[y][3] == "D", nDetra++,.T.)})  //Qtd de impuestos de detracci�n
	If nDetra > 0
		cXML += '	<cbc:Note languageLocaleID="2006">' + EncodeUtf8(ObtColSAT("S052", '2006', 1, 4,5,250)) + '</cbc:Note>' + cCRLF
	EndIf
	// Punto de Entrada para agregar campos personalizados Factura.
	If ExistBlock("M486NF") .AND. !aEnc[16]
		cXML += ExecBlock("M486NF",.F.,.F.,{SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_ESPECIE,cClie,cTienda})
	ElseIf ExistBlock("M486NFE") .AND. aEnc[16]
		cXML += ExecBlock("M486NFE",.F.,.F.,{SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_ESPECIE,cClie,cTienda})
	EndIf
	
	cXML += '	<cbc:DocumentCurrencyCode listID="ISO 4217 Alpha" '
	cXML += 					'listName="Currency" '
	cXML += 					'listAgencyName="United Nations Economic Commission for Europe">' + aEnc[4] + '</cbc:DocumentCurrencyCode>' + cCRLF    
	cXML += '	<cbc:LineCountNumeric>' + ALLTRIM(TRANSFORM(Len(aDetImp),"999999.99")) + '</cbc:LineCountNumeric>' + cCRLF
	
	If !Empty(aEnc[10])
		cXML += '	<cac:OrderReference>' + cCRLF
		cXML += '		<cbc:ID>' + Alltrim(aEnc[10]) + '</cbc:ID>' + cCRLF //-->PENDIENTE
		cXML += '	</cac:OrderReference>' + cCRLF
	EndIf
	// -------------------Gu�as de Remisi�n relacionadas a la NF ------------------------
	For nI := 1 to len(aGRNF)
		cXML += '	<cac:DespatchDocumentReference>' + cCRLF
		cXML += '	<cbc:ID>' + aGRNF[nI,3]+"-"+aGRNF[nI,2]+ '</cbc:ID>'+ cCRLF
		cXML += '	<cbc:DocumentTypeCode>09</cbc:DocumentTypeCode>'+ cCRLF
		cXML += '	</cac:DespatchDocumentReference>'	 + cCRLF
	Next nI

	cXML += M486XmlFE() 	// Firma Electr�nica	
	cXML += M486XmlEmi() 	// Emisor	
	cXML += M486XmlRec(cClie,cTienda) // Receptor

	//Detracci�n
	If Len(aImpXML) > 0
		For nX :=1 To Len(aImpXML)
			If aImpXML[nX,3] == "D"
				cXML += '	<cac:PaymentMeans>' + cCRLF
				cXML += '	<cbc:ID>Detraccion</cbc:ID>' + cCRLF
				If SF2->(FieldPos("F2_MODCONS")) > 0
					cXML += '		<cbc:PaymentMeansCode>' + Alltrim(SF2->F2_MODCONS) + '</cbc:PaymentMeansCode>' + cCRLF //Medio de Pago (Cat�logo 59)
				EndIf
				cXML += '		<cac:PayeeFinancialAccount>' + cCRLF
	            cXML += '			<cbc:ID>' + Alltrim(cCtaDetra) + '</cbc:ID>' + cCRLF //N�mero de cuenta en el Banco de la Naci�n 0004-3342343243
				cXML += '		</cac:PayeeFinancialAccount>' + cCRLF
	      		cXML += '	</cac:PaymentMeans>' + cCRLF
	      		
				cXML += '	<cac:PaymentTerms>' + cCRLF
				cXML += '	<cbc:ID>Detraccion</cbc:ID>' + cCRLF
				If SF2->(FieldPos("F2_CODDOC")) > 0
					cXML += '		<cbc:PaymentMeansID>' + Alltrim(SF2->F2_CODDOC) + '</cbc:PaymentMeansID>' + cCRLF //C�digo del bien o servicio sujeto a detracci�n (Cat�logo 59)
				EndIf
				cXML += '		<cbc:PaymentPercent>4</cbc:PaymentPercent>' + cCRLF //Porcentaje de la detracci�n
	            cXML += '		<cbc:Amount currencyID="PEN">' + alltrim(TRANSFORM(aImpXML[nX,6],"999999999999.99")) + '</cbc:Amount>' + cCRLF //Monto de la Detracci�n
	      		cXML += '	</cac:PaymentTerms>' + cCRLF	      		
			EndIf
		Next nX
	EndIf

	//Nodo para Forma de Pago
	If lTipoPago
		cXML += M486FOPAGO(aEnc[4],aEnc[19],aEnc[20],aParc)
	EndIf
	
	//---------------------------------CARGOS Y DESCUENTOS-------------------------------------------------//	
	For nX := 1 to len(aGastos)
		cXML += '	<cac:AllowanceCharge>'	 + cCRLF
		cXML += '		<cbc:ChargeIndicator>' + IIF(aGastos[nX,1] == "00", 'false','true') + '</cbc:ChargeIndicator>'	 + cCRLF
		cXML += '		<cbc:AllowanceChargeReasonCode>' + aGastos[nX,1] + '</cbc:AllowanceChargeReasonCode>'	 + cCRLF
		cXML += '		<cbc:MultiplierFactorNumeric>' + Alltrim(Transform(((aGastos[nX,2]*100)/(aGastos[nX,2]+ aEnc[5]))/100,"999.99999")) + '</cbc:MultiplierFactorNumeric>'	 + cCRLF
		cXML += '		<cbc:Amount currencyID="' + aEnc[4] + '">' + alltrim(STR(aGastos[nX,2],10,2))  + '</cbc:Amount>'	 + cCRLF
		cXML += '		<cbc:BaseAmount currencyID="' + aEnc[4] + '">' + alltrim(STR(aGastos[nX,2]+ aEnc[5],10,2))  + '</cbc:BaseAmount>'	 + cCRLF
		cXML += '	</cac:AllowanceCharge>'	 + cCRLF	
	Next nX
	
	// Impuestos totales
	If Len(aImpXML) > 0
		For nX :=1 To Len(aImpXML)
			If !(aImpXML[nX,3] == "D")
				If lProc
					cXML += '	<cac:TaxTotal>' + cCRLF
					cXML += '		<cbc:TaxAmount currencyID="' + aEnc[4] + '">' + alltrim(TRANSFORM(iIf(aEnc[8],0,aEnc[14]),"999999999999.99")) + '</cbc:TaxAmount>' + cCRLF
					lProc := .F.					
				EndIf
				If !lDocExp
					cXML += '		<cac:TaxSubtotal>' + cCRLF
					If aImpXML[nX,4] <>"ICB"
						cXML += '			<cbc:TaxableAmount currencyID="' + aEnc[4] + '">' + alltrim(TRANSFORM(aImpXML[nX,10],"999999999999.99")) + '</cbc:TaxableAmount>' + cCRLF
					EndIf
					cXML += '			<cbc:TaxAmount currencyID="' + aEnc[4] + '">' + alltrim(TRANSFORM(aImpXML[nX,6],"999999999999.99")) + '</cbc:TaxAmount>' + cCRLF
					cXML += '			<cac:TaxCategory>' + cCRLF
					cXML += '				<cac:TaxScheme>' + cCRLF
					cXML += '					<cbc:ID schemeID="UN/ECE 5153" schemeAgencyID="6">' + aImpXML[nX,2] + '</cbc:ID>' + cCRLF
					cXML += '					<cbc:Name>' + IIF(aImpXML[nX,4] == "ICB", 'ICBPER',aImpXML[nX,4]) + '</cbc:Name>' + cCRLF
					cXML += '					<cbc:TaxTypeCode>' + aImpXML[nX,5] + '</cbc:TaxTypeCode>' + cCRLF
					cXML += '				</cac:TaxScheme>' + cCRLF
					cXML += '			</cac:TaxCategory>' + cCRLF
					cXML += '		</cac:TaxSubtotal>' + cCRLF
				EndIF
				If nX == len(aImpXML)
					// Se procesan los Valores de las Operaciones del IGV
					For nI:=2 to len(aValAd)
						If aValAd[nI,2]> 0
							cXML += '		<cac:TaxSubtotal>' + cCRLF
							cXML += '			<cbc:TaxableAmount currencyID="'+ aEnc[4] + '">' + alltrim(TRANSFORM(aValAd[nI,2],"999999999999.99")) + '</cbc:TaxableAmount>' + cCRLF
							cXML += '			<cbc:TaxAmount currencyID="' + aEnc[4] + '">' + alltrim(TRANSFORM(aValAd[nI,3],"999999999999.99")) + '</cbc:TaxAmount>' + cCRLF
							cXML += '			<cac:TaxCategory>' + cCRLF
							cXML += '				<cac:TaxScheme>' + cCRLF
							cXML += '					<cbc:ID schemeID="UN/ECE 5153" schemeAgencyID="6">' + aValAd[nI,1] + '</cbc:ID>' + cCRLF
							cXML += '					<cbc:Name>' + aValAd[nI,4] + '</cbc:Name>' + cCRLF
							cXML += '					<cbc:TaxTypeCode>' + aValAd[nI,5] + '</cbc:TaxTypeCode>' + cCRLF
							cXML += '				</cac:TaxScheme>' + cCRLF
							cXML += '			</cac:TaxCategory>' + cCRLF
							cXML += '		</cac:TaxSubtotal>' + cCRLF							
						EndIf	
					Next nI							
					cXML += '	</cac:TaxTotal>' + cCRLF	
				EndIf
			EndIf
		Next nX
	EndIf
	
	cXML += '	<cac:LegalMonetaryTotal>' + cCRLF
	If aEnc[8]
		cXML += '		<cbc:LineExtensionAmount currencyID="' + aEnc[4] + '">'	+ alltrim(TRANSFORM(0,"999999999999.99")) + '</cbc:LineExtensionAmount>' + cCRLF		
	Else
		cXML += '		<cbc:LineExtensionAmount currencyID="' + aEnc[4] + '">'	+ alltrim(TRANSFORM(aEnc[11] + aEnc[12],"999999999999.99")) + '</cbc:LineExtensionAmount>' + cCRLF
	EndIf
	cXML += '		<cbc:TaxInclusiveAmount currencyID="' + aEnc[4] + '">' 	+ alltrim(TRANSFORM(aEnc[5],"999999999999.99"))+ '</cbc:TaxInclusiveAmount>' + cCRLF
	cXML += '		<cbc:AllowanceTotalAmount currencyID="' + aEnc[4] + '">'+ alltrim(TRANSFORM(aEnc[12],"999999999999.99"))+'</cbc:AllowanceTotalAmount>' + cCRLF
	cXML += '		<cbc:ChargeTotalAmount currencyID="' + aEnc[4] + '">' + alltrim(TRANSFORM(aEnc[13],"999999999999.99")) + '</cbc:ChargeTotalAmount>' + cCRLF
	cXML += '		<cbc:PayableAmount currencyID="' + aEnc[4] + '">' + alltrim(TRANSFORM(aEnc[5],"999999999999.99")) + '</cbc:PayableAmount>' + cCRLF
	cXML += '	</cac:LegalMonetaryTotal>' + cCRLF
 
	aSort(aDetImp,,,{|X,Y| x[1] < y[1]}) 
	// Detalle por �tem de la factura
	If Len(aDetImp) > 0		
		For nX := 1 To Len(aDetImp)
			cXML += '	<cac:InvoiceLine>' + cCRLF
			
			cXML += '		<cbc:ID>' + alltrim(str(aDetImp[nX][1])) + '</cbc:ID>' + cCRLF
			cXML += '		<cbc:InvoicedQuantity unitCode="' + alltrim(aDetImp[nX][2]) + '" '
			cXML += 							'unitCodeListID="UN/ECE rec 20" ' 
			cXML += 							'unitCodeListAgencyName="United Nations Economic Commission for Europe">' + alltrim(TRANSFORM(aDetImp[nX][3],"999999999999.9999999999")) + '</cbc:InvoicedQuantity>' + cCRLF
     	    cXML += '		<cbc:LineExtensionAmount currencyID="' + aEnc[4] + '">' + alltrim(Transform(aDetImp[nX][4],"9999999999999.99")) + '</cbc:LineExtensionAmount>' + cCRLF
			cXML += '		<cac:PricingReference>' + cCRLF
			If aDetImp[nX][12] 
				cXML += '			<cac:AlternativeConditionPrice>' + cCRLF  //Precio de venta unitario
				cXML += '				<cbc:PriceAmount currencyID="' + aEnc[4] + '">' +  alltrim(TRANSFORM(aDetImp[nX][09],cPicAmount)) + '</cbc:PriceAmount>' + cCRLF
				cXML += '				<cbc:PriceTypeCode listName="Tipo de Precio" '
				cXML += 								'listAgencyName= "PE:SUNAT" ' 
				cXML += 								'listURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo16">02</cbc:PriceTypeCode>' + cCRLF
				cXML += '			</cac:AlternativeConditionPrice>' + cCRLF						
			Else
				cXML += '			<cac:AlternativeConditionPrice>' + cCRLF  //Precio de venta unitario
        		cXML += '				<cbc:PriceAmount currencyID="' + aEnc[4] + '">' + IIf(!aDetImp[nX][12],alltrim(TRANSFORM(aDetImp[nX][11],cPicAmount)),"0.00") + '</cbc:PriceAmount>' + cCRLF
				cXML += '				<cbc:PriceTypeCode listName="Tipo de Precio" '
				cXML += 								'listAgencyName= "PE:SUNAT" ' 
				cXML += 								'listURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo16">01</cbc:PriceTypeCode>' + cCRLF
				cXML += '			</cac:AlternativeConditionPrice>' + cCRLF
			EndIf
			cXML += '		</cac:PricingReference>' + cCRLF
			cXML += '		<cac:AllowanceCharge>' + cCRLF
			cXML += '			<cbc:ChargeIndicator>false</cbc:ChargeIndicator>' + cCRLF
			cXML += '			<cbc:AllowanceChargeReasonCode>00</cbc:AllowanceChargeReasonCode>' + cCRLF			
			cXML += '			<cbc:MultiplierFactorNumeric>' + alltrim(TRANSFORM(aDetImp[nX,14]/100,"999.99999"))+ '</cbc:MultiplierFactorNumeric>' + cCRLF
			cXML += '			<cbc:Amount currencyID="' + aEnc[4] + '">' + IIf(!aDetImp[nX][12],alltrim(TRANSFORM(aDetImp[nX][6],"999999.99")),"0.00") + '</cbc:Amount>' + cCRLF
			cXML += '			<cbc:BaseAmount currencyID="' + aEnc[4] + '">' + IIf(!aDetImp[nX][12],alltrim(TRANSFORM(aDetImp[nX,4]+ aDetImp[nX,6],"9999999999.99") ),"0.00") + '</cbc:BaseAmount>'+ cCRLF
			cXML += '		</cac:AllowanceCharge>' + cCRLF  

			If Len(aDetImp[nX][13]) > 0
				cXML += '		<cac:TaxTotal>' + cCRLF
				cXML += '			<cbc:TaxAmount currencyID="' + aEnc[4] + '">' + alltrim(TRANSFORM(aDetImp[nX,5],"9999999999999.99"))/*alltrim(aDetImp[nX][13][nC][1])*/ + '</cbc:TaxAmount>' + cCRLF 				
				For nC := 1 To Len(aDetImp[nX][13]) //Impuestos por �tem
					If Len(aDetImp[nX][13][nC]) > 0
						If !(aDetImp[nX][13][nC][10] == "D")
							cXML += '			<cac:TaxSubtotal>' + cCRLF
							If aDetImp[nX][13][nC,5] <> "ICB"
								cXML += '				<cbc:TaxableAmount currencyID="'+ aEnc[4] + '">' + alltrim(TRANSFORM(aDetImp[nX,4],"9999999999999.99"))+ '</cbc:TaxableAmount>' + cCRLF
							EndIf
							cXML += '				<cbc:TaxAmount currencyID="' + aEnc[4] + '">' + alltrim(TRANSFORM(aDetImp[nX][13][nC][1],"9999999999999.99")) + '</cbc:TaxAmount>' + cCRLF 
							If aDetImp[nX][13][nC,5] == "ICB"
							cXML += '				<cbc:BaseUnitMeasure unitCode="NIU">' + alltrim(TRANSFORM(aDetImp[nX][3],"9999999999999")) + '</cbc:BaseUnitMeasure>' + cCRLF 
							EndIf
							cXML += '				<cac:TaxCategory>' + cCRLF
							If aDetImp[nX][13][nC,5] == "ICB"
							cXML += '					<cbc:PerUnitAmount currencyID="' + aEnc[4] + '">' + alltrim(TRANSFORM(aDetImp[nX][16],"9999999999999.99")) + '</cbc:PerUnitAmount>' + cCRLF 
							Else
								cXML += '					<cbc:Percent>' + alltrim(TRANSFORM(aDetImp[nX][13][nC][8],"999.99"))+ '</cbc:Percent> '  + cCRLF
							EndIf
							If aDetImp[nX][13][nC][5] <> "ISC" .And. aDetImp[nX][13][nC,5] <> "ICB"
								cXML += '					<cbc:TaxExemptionReasonCode listAgencyName="PE:SUNAT" listName="Afectacion del IGV" '
								cXML += 						'listURI="urn:pe:gob:sunat:cpe:see:gem:catalogos:catalogo07">' + alltrim(aDetImp[nX][13][nC][2]) + '</cbc:TaxExemptionReasonCode>' + cCRLF
							ElseIf aDetImp[nX][13][nC][5] == "ISC" 
								cXML += '					<cbc:TierRange >' + alltrim(aDetImp[nX][13][nC][3]) + '</cbc:TierRange >' + cCRLF
							EndIf
							cXML += '					<cac:TaxScheme>' + cCRLF
							cXML += '						<cbc:ID >' + aDetImp[nX][13][nC,4] + '</cbc:ID>' + cCRLF
							cXML += '						<cbc:Name>' + IIF(aDetImp[nX][13][nC,5] == "ICB", 'ICBPER',aDetImp[nX][13][nC,5])  + '</cbc:Name>' + cCRLF
							cXML += '						<cbc:TaxTypeCode>' + aDetImp[nX][13][nC,6] + '</cbc:TaxTypeCode>' + cCRLF
							cXML += '					</cac:TaxScheme>' + cCRLF
							cXML += '				</cac:TaxCategory>' + cCRLF
							cXML += '			</cac:TaxSubtotal>' + cCRLF
						EndIf
					EndIf
				Next nC
				cXML += '		</cac:TaxTotal>' + cCRLF
			EndIf

			cXML += '		<cac:Item>' + cCRLF
			cXML += '			<cbc:Description><![CDATA[' + IIF(lRSM,EncodeUtf8(aDetImp[nX][7]),aDetImp[nX][7]) + ']]></cbc:Description>' + cCRLF
			cXML += '			<cac:SellersItemIdentification>' + cCRLF
			cXML += '				<cbc:ID>' + aDetImp[nX][8] + '</cbc:ID>' + cCRLF
			cXML += '			</cac:SellersItemIdentification>' + cCRLF		
			cXML += '			<cac:CommodityClassification>' + cCRLF
			cXML += '				<cbc:ItemClassificationCode listID="UNSPSC" ' 
			cXML += 			'listAgencyName="GS1 US" '
			cXML += 			'listName="Item Classification">' +  aDetImp[nX,15]+ '</cbc:ItemClassificationCode>' + cCRLF
			cXML += '			</cac:CommodityClassification>' + cCRLF
			cXML += '		</cac:Item>' + cCRLF
    		cXML += '		<cac:Price>' + cCRLF  //Valor unitario
    		cXML += '			<cbc:PriceAmount currencyID="' + aEnc[4] + '">' + IIf(!aDetImp[nX][12],alltrim(TRANSFORM(aDetImp[nX][10],cPicAmount)),"0.00") + '</cbc:PriceAmount>' + cCRLF
			cXML += '		</cac:Price>' + cCRLF			
			cXML += '	</cac:InvoiceLine>' + cCRLF			
		Next nX		
	EndIf
	cXML += '</Invoice>' + cCRLF	
Return cXML
