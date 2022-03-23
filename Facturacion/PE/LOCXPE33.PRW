#INCLUDE 'TOTVS.CH'

/*
// Programa  LOCXPE33  Autor  Microsiga           Fecha   09/02/2020   
// Desc.     Carga campos personalizados en encabezado de documentos  
//              de entrada y salida.   
// ===================================================================================== //
// 1	NF	Nota fiscal de Vendas	Cliente	Faturamento
// 2	NDC	Nota de débito cliente	Cliente	Faturamento                         
// 3	NCE	Nota de crédito externa	Cliente	Faturamento
// 4	NCC	Nota de crédito cliente	Cliente	Faturamento
// 5	NDE	Nota de débito externa	Cliente	Faturamento
// 6	NDI	Nota de débito interna	Fornecedor	Compras
// 7	NCP	Nota de crédito fornecedor	Fornecedor	Compras
// 8	NCI	Nota de crédito Interna	Fornecedor	Compras
// 9	NDP	Nota de débito fornecedor	Fornecedor	Compras
// 10	NF	Nota Fiscal de compras	Fornecedor	Compras
// 11	NF	Nota fiscal de Beneficiamento	Fornecedor	Faturamento
// 12	NF	Nota fiscal de Beneficiamento	Cliente	Compras
// 13	NF	Nota Fiscal de despesas de importação	Fornecedor	Compras
// 14	NF	Nota Fiscal de frete	Fornecedor	Compras
// 15	REC	Recibo	Fornecedor	Compras
// 50	RFN	Remito faturamento normal	Cliente	Faturamento
// 51	RFD	Remito faturamento Devolução (Documento próprio)	Cliente	Faturamento
// 52	RFB	Remito faturamento Beneficiamento	Fornecedor	Faturamento
// 53	RFD	Remito faturamento Devolução (Documento não próprio)	Cliente	Faturamento
// 54	RTS	Envio de remito de transferencia	Fornecedor	Estoques
// 60	RCN	Remito compras normal	Fornecedor	Compras
// 61	RCD	Remito compras Devolução	Fornecedor	Compras
// 62	RCB	Remito compras Beneficiamento	Cliente	Compras
// 63	RET	Retorno Simbólico (consignação)	Cliente	Faturamento
// 64	RTE	Recebemento de remito de transferencia	Fornecedor	Estoques
// ===================================================================================== //
*/
/*
/* -------------------------------------------------------------------
Revisión para Acme por: Axel Diaz
Proposito: Agregar campos personalizados en Remisiones de Salida y Facturas
Control de Cambios
* 15-feb-2022  Se adiciona la linea 72 para que muestre el consecutivo del doc. soporte en el 
			   Encabezado de la Factura de Entrada.  M&H
------------------------------------------------------------------------*/

User function LOCXPE33()
	Local aArea := GetArea()
	Local aCposNF := ParamIxb[1]
	Local nTipo := ParamIxb[2]
	Local aDetalles := {}
	Local nNuevoElem := 0
	Local nPosCpo := 0
	Local nL      := 0
						
	/*

	If nTipo == 7 // NCP nota de credito proveedor
		//Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F1_XNUMINT"  ,  .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F1_XCONMAN"  ,  .T.      ,.F.      ,.F.   })
	Endif
		
		
	If nTipo == 9 	// Nota de debito proveedor
			//   Detalles,      Campo       Usado  Obligatorio  Visual
			AADD(aDetalles,{"F1_XNUMINT" , .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F1_XCONMAN" , .T.      ,.F.      ,.F.   })
	Endif


	*/
	If nTipo == 10  .or. nTipo == 13  .or. nTipo == 60 // Factura de entrada proveedor normal-importacion Remito
		//   Detalles,      Campo       Usado  Obligatorio  Visual
			AADD(aDetalles,{"F1_XNOMPRO" , .T.      ,.F.      ,.T.   })
			AADD(aDetalles,{"F1_XDOC" , .T.      ,.F.      ,.F.   })  //MH - Alvaro Hurtado
			
	Endif

	/*	
	If nTipo == 4 .and. CESPECIE='NCC'  // Nota de Credito de Cliente - NCC
		//   Detalles,      Campo   Usado  Obligatorio  Visual
			AADD(aDetalles,{"F2_XNUMINT" , .T.      ,.F.      ,.F.   })
			AADD(aDetalles,{"F2_XCONMAN" , .T.      ,.F.      ,.F.   })
	Endif
			

	If nTipo == 2 		   // Nota de Debito de Cliente - NDC
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F2_XNUMINT" , .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XCONMAN" , .T.      ,.F.      ,.F.   })
	Endif

	*/
	If nTipo == 1  .OR. nTipo == 50        //Nota fiscal ventas   
		//   Detalles,      Campo       Usado  Obligatorio  Visual
		AADD(aDetalles,{"F2_XOBS" 	, .T.      ,.F.      ,.F.   })
		AADD(aDetalles,{"F2_XORDCOM" 	, .T.      ,.F.      ,.F.   })
		//AADD(aDetalles,{"D2_XDESCR" , .T.      ,.F.      ,.F.   })
	Endif

	//------------------------------------------------------------------
	// No cambiar dentro del Loop For...Next, llamar AC/Localizaciones 
	//------------------------------------------------------------------

	For nL := 1 To Len(aDetalles)
		If (nPosCpo := Ascan(aCposNF,{|x| x[2] == aDetalles[nL][1] })) > 0
			aCposNF[nPosCpo][13] := aDetalles[nL][3] 				   // Obligatorio
			If Len(aCposNF[nPosCpo]) == 16
				SX3->(DbSetOrder(2))
				SX3->(DbSeek(AllTrim(aDetalles[nL][1])))
				cTitulo := X3Titulo()
				aCposNF[nPosCpo] := { cTitulo,X3_CAMPO,,,,,,X3_TIPO,,,,,aDetalles[nL][3],,,,If(aDetalles[nL][4],".F.",".T.") }
			EndIf
			aCposNF[nPosCpo][17] := If(aDetalles[nL][4],".F.",".T.")   // Desabilita el campo
			If !aDetalles[nL][2]
				ADel(aCposNF,nPosCpo) 								   // Quita el campo
				ASize(aCposNF,Len(aCposNF)-1)                          // Ajusta Array
			EndIf
		Else
			DbSelectArea("SX3")
			DbSetOrder(2)
			If DbSeek( aDetalles[nL][1] )
				nNuevoElem := Len(aCposNF)+1
				aCposNF := aSize(aCposNF,nNuevoElem)
				aIns(aCposNF,nNuevoElem)
				cTitulo := X3Titulo()
				aCposNF[nNuevoElem] := { cTitulo ,X3_CAMPO , , , , , , X3_TIPO , , , , , aDetalles[nL][3] , , , , If(aDetalles[nL][4],".F.",".T.") }
			EndIf
		EndIf

	Next nL
	RestArea(aArea)

Return( aCposNF )


