#Include "Protheus.ch"
#Include "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtaProdC    ºAutor  ³Microsiga           º Data ³  11/05/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtiene la cuenta contable del producto de acuerdo         º±±
±±º          ³ al centro de costos informado en el detalle del documento  º±±
±±º          ³ de compra/devolucion en compra.              		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CtaProdCC(ccCostos,cCodPro,cCodDep)

Local cCuenta:= ""
Local aArea  := GetArea()      

	DBSelectArea("NNR")
	DBSetOrder(1)
    DBSeek(xFilial("NNR")+cCodDep) 

	DBSelectArea("SB1")
	DBSetOrder(1)
    DBSeek(xFilial("SB1")+cCodPro)  
    
    DBSelectArea("CTT")
	DBSetOrder(1)
	DBSeek(xFilial("CTT")+ccCostos)
 	
	IF "SV"$cCodDep.OR."GG"$cCodDep
		IF CTT->CTT_XTIPOG=='73'        // Centros de costo Costo
			cCuenta:= SB1->B1_CONTA
		ELSEIF CTT->CTT_XTIPOG=='52'    // Centros de costo ventas
			cCuenta:= SB1->B1_XCONCL   
		ELSEIF CTT->CTT_XTIPOG=='51'    // Centros de costo Administrativa
			cCuenta:= SB1->B1_XCONCO
		ENDIF        		
	Else
		cCuenta:=SB1->B1_CONTA
	EndIf 

RestArea(aArea)

Return(cCuenta)

