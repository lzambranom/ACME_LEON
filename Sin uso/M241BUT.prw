#include 'protheus.ch'
//#include 'parmtype.ch'
#include "rwmake.ch"
#include "TbiConn.ch"
#include "AcmeDef.ch"

User Function M241BUT()
Local aButtons:={}
Aadd(aButtons , {'CODBARMV',{||U_CodBarMV()},'Pistoleo'})
Return(aButtons)
/*
User Function A241BUT()
Local nOpcao  := PARAMIXB[1]  // Opção escolhida
Local aBotoes := PARAMIXB[2]  // Array com botões padrão
// Customizações do cliente
Return aBotoes
*/
//User Function MT241SE()
//Local aCols := ParamIxb
//-- Rotina para adicionar itens do usuário no aCols
//Return aCols

//User Function Axel()
//Local aItems:=	aCols
//CodBarrMV()
//Return Nil

/*
+---------------------------------------------------------------------------+
| Programa  # CodBarrLee |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     #  Ventana tipo MEMO que captura las entradas del lector del    |
|           #  codigo de barras                                             |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
USER Function CodBarMV()
	Local cTexto
	Local oDlg
	Local oMemo
	Local Retorno
	
	DEFINE MSDIALOG oDlg TITLE "Lectura de Codigos de Barra" FROM 0,0 TO 555,650 PIXEL
	     @ 005, 005 GET oMemo VAR cTexto MEMO SIZE 315, 250 OF oDlg PIXEL
	     @ 260, 280 Button "PROCESAR" Size 035, 015 PIXEL OF oDlg Action(processa( {|| U_CodProMV(oDlg,cTexto) }, "Procesando los Códigos", "Leyendo los registros y sumando, espere...", .f.))
	     @ 260, 230 Button "CANCELAR" Size 035, 015 PIXEL OF oDlg Action oDlg:End()	     
	ACTIVATE MSDIALOG oDlg CENTERED
Return


/*
+---------------------------------------------------------------------------+
| Programa  # CodBarProc |Autor  | Axel Diaz        |Fecha |  10/12/2019    |
+---------------------------------------------------------------------------+
| Desc.     # encargado de procesar los codigos de barra leidos             |
|           # y agruparlos y sumarlos para rellenar el grid                 |
+---------------------------------------------------------------------------+
| Uso       # AP                                                            |
+---------------------------------------------------------------------------+
*/
User Function CodProMV(oDlg,cTexto)
	Local aLineas		:= {}
	Local aLinTmp		:= {}
	Local aProduct		:= {}
	Local aCodBar		:= {}
	Local nI 			:= 0
	Local nJ 			:= 0
	Local nX 			:= 0
	Local lInsert		:= .T.
	Local nTamCod		:= 0
	Local nTamBar		:= 0
	Local nD3_COD		:= Ascan(aHeader, {|X| Alltrim(X[2]) ==  "D3_COD"  		})
	Local nD3_CONTA		:= Ascan(aHeader, {|X| Alltrim(X[2]) ==  "D3_CONTA"  	})
	Local nD3_QUANT		:= Ascan(aHeader, {|X| Alltrim(X[2]) ==  "D3_QUANT"  	})
	Local nD3_QTSEGUM   := Ascan(aHeader, {|X| Alltrim(X[2]) ==  "D3_QTSEGUM"  	})
	Local nD3_GRUPO		:= Ascan(aHeader, {|X| Alltrim(X[2]) ==  "D3_GRUPO"  	})
	Local nD3_SEGUM		:= Ascan(aHeader, {|X| Alltrim(X[2]) ==  "D3_SEGUM"  	})
	Local nD3_DESCRI	:= Ascan(aHeader, {|X| Alltrim(X[2]) ==  "D3_DESCRI"  	}) 
	Local nD3_UM		:= Ascan(aHeader, {|X| Alltrim(X[2]) ==  "D3_UM"  		}) 
	Local nD3_LOCAL		:= Ascan(aHeader, {|X| Alltrim(X[2]) ==  "D3_LOCAL"  	})
	
	dbSeek("B1_COD")
	nTamCod:=SX3->X3_TAMANHO
	dbSeek("B1_CODBAR")
	nTamBar:=SX3->X3_TAMANHO
	
	cTexto:=ALLTRIM(StrTran(cTexto, CRLF, LF ))
	If !EMPTY(cTexto)
		aLinTmp:=StrTokArr(cTexto,LF)  // trae el texto y pasa a un arreglo el codBarra
		procregua(Len(aLinTmp))
		// Limpia arreglo de ENTERs
		
		For nI:=1 to Len(aLinTmp)
			If !Empty(Alltrim(aLinTmp[nI]))
				AAdd( aLineas,ALLTRIM(aLinTmp[nI]))
			EndIf
		Next nI
		
		AAdd( aCodBar,{aLineas[1],1})  // Agrega el Cod Bar del Producto con  cantidad 1
		AAdd( aProduct,{".",1})  // Agrega el Cod del Producto con  cantidad 1
		
		// Cuenta las repeticiones de los productos
		For nI:=2 to Len(aLineas)
			lAdd:= .T.
			incproc("Sumando...")
			For nJ:=1 to Len(aCodBar)     
				If aLineas[nI]==aCodBar[nJ][1]   // Si encuentra el codigo de barra nuevamente Suma 1   
					aCodBar[nJ][2]:=aCodBar[nJ][2]+1
					aProduct[nJ][2]:=aProduct[nJ][2]+1
					lAdd := .F.
				EndIf
			Next nJ
			If lAdd
				AAdd( aCodBar,{aLineas[nI],1})
				AAdd( aProduct,{aLineas[nI],1})
			EndIf
		Next nI
	
		// Se muestra la lectura 
		cTexto:="<table style='color: #000;' border='0' cellspacing='2' cellpadding='2'><tbody><tr style='background-color: #e0e0e0; text-align: center; color: black;'><td>#</td><td>Cod Producto</td><td>Cod Barra</td><td>Cantidad</td></tr>"
		For nI:=1 to len(aCodBar)
			aProduct[nI][1]:=POSICIONE('SB1',5,xFilial("SB1")+SUBSTR(aCodBar[nI][1]+SPACE(nTamBar),1,nTamBar),"B1_COD")
			IF Empty(aProduct[nI][1])
				aProduct[nI][2]:=0
				aProduct[nI][1]:="<font color=RED>NO EXITE</font>"
			EndIf
		Next nI	
		
		For nI:=1 to len(aCodBar)
			cTexto:=cTexto+"<tr><td>"+cValToChar(nI)+"</td><td>"+aProduct[nI][1]+"</td><td>"+aCodBar[nI][1]+"</td><td>"+cValToChar(aCodBar[nI][2])+"</td></tr>"
		Next nI
		cTexto+="</tbody></table>"

		// Se espera por la aceptacion de los datos
		If MsgYesNo("¿Subir los códigos al sistema?..."+CRLF+cTexto)
	     	lInsert:=.T.
	     	For nI:=1 to len(aProduct)
	     		incproc("Cotejando...")
	     		If aProduct[nI][2]>0
	     		
	     			If Len(aCols)>0
			     		For nJ:=1 to Len(aCols)
			     			If ALLTRIM(aCols[nj][nD3_COD])==ALLTRIM(aProduct[nI][1]) .OR. EMPTY(ALLTRIM(aCols[nj][nD3_COD])) 
			     				lInsert:=.F.
			     				nX:=nJ
			     			EndIf
			     		Next // nJ
		     		EndIf
		     		//lInsert:=.F.
		     		//nX:=1
					If lInsert
						aAdd(aCols,Array(Len(aHeader)+1))
						nX:=Len(aCols)
					EndIF	
					If (nD3_DESCRI > 0)		;aCOLS[nX][nD3_DESCRI ]		:= POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduct[nI][1]),'B1_DESC')	;EndIf 
					If (nD3_COD > 0)		;aCOLS[nX][nD3_COD ]		:= ALLTRIM(aProduct[nI][1])												;EndIf
					If (nD3_QUANT > 0)		;aCOLS[nX][nD3_QUANT ]		:= aProduct[nI][2] 														;EndIf
					If (nD3_QTSEGUM > 0)	;aCOLS[nX][nD3_QTSEGUM ]	:= POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduct[nI][1]),'B1_SEGUM') ;EndIf
					If (nD3_UM > 0)			;aCOLS[nX][nD3_UM ]			:= POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduct[nI][1]),'B1_UM') 	;EndIf
					If (nD3_GRUPO > 0)		;aCOLS[nX][nD3_GRUPO ]		:= POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduct[nI][1]),'B1_GRUPO') ;EndIf
					If (nD3_CONTA > 0)		;aCOLS[nX][nD3_CONTA]		:= POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduct[nI][1]),'B1_CONTA')	;EndIf
					If (nD3_SEGUM > 0)		;aCOLS[nX][nD3_SEGUM ]		:= POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduct[nI][1]),'B1_SEGUM')	;EndIf
					If (nD3_LOCAL > 0)		;aCOLS[nX][nD3_LOCAL ]		:= POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduct[nI][1]),'B1_LOCPAD')	;EndIf
					If (nD3_SEGUM > 0)		;aCOLS[nX][nD3_SEGUM ]		:= POSICIONE('SB1',1,xfilial('SB1')+ALLTRIM(aProduct[nI][1]),'B1_SEGUM')	;EndIf
					
					//axTrigger("D3_COD")
			     	lInsert:=.T.
		     	EndIf
	     	Next
		Else
			 MsgAlert("No se Transfirió")
		EndIf
	Else
		MsgAlert("No se encontraron datos")
	EndIF

Return (oDlg:End())



Static Function axTrigger(cCampo)
cCampoAux := cCampo
nLinBkp := n
For n := 1 To Len(aCols)
    //Se tiver gatilhos no campo
    If ExistTrigger(cCampoAux)
        //Posiciona no gatilho
        DbSelectArea("SX7")
        SX7->(DbSetOrder(1)) //Campo + Sequencia
        SX7->(DbGoTop())
        If SX7->(DbSeek(cCampoAux))
            //Percorrendo todos os gatilhos
            While ! SX7->(EoF()) .And. Alltrim(SX7->X7_CAMPO) == Alltrim(cCampoAux)
                //Dispara o Gatilho
                cCpoTrigger := SX7->X7_CAMPO
                RunTrigger(    2,;           //nTipo (1=Enchoice; 2=GetDados; 3=F3)
                            n,;           //Linha atual da Grid quando for tipo 2
                            Nil,;         //Não utilizado
                            ,;            //Objeto quando for tipo 1
                            cCpoTrigger)  //Campo que dispara o gatilho
                             
                SX7->(DbSkip())
            EndDo
        EndIf
    EndIf
Next
n := nLinBkp
Return nil

 

