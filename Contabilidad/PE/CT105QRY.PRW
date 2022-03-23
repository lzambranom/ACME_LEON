#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  CT105QRY    ºAutor  ³Microsiga           º Data ³  12/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function CT105QRY 

Local _cQuery	:= paramixb[1]
Local _lAgrup	:= paramixb[2]

//If !(cEmpAnt == '02' .and. cFilant == '01')   // si no es cincas nueva sucursal
If _lAgrup	
//_cQuery := paramixb[1]
   // _cQuery:=" SELECT CTK_FILIAL,CTK_SEQUEN,CTK_DC,CTK_DEBITO,CTK_CREDIT,CTK_CCD,CTK_CCC,CTK_ITEMD,CTK_ITEMC,CTK_CLVLDB,CTK_CLVLCR,CTK_TPSALD,CTK_DATA,CTK_LP,  SUM( CTK_VLR01 ) CTK_VLR01,  SUM( CTK_VLR02 ) CTK_VLR02,  SUM( CTK_VLR03 ) CTK_VLR03,  SUM( CTK_VLR04 ) CTK_VLR04, MAX(CTK_LP+CTK_LPSEQ) CTKLPLPSEQ , MIN(CTK_ORIGEM) CTK_ORIGEM , MIN(R_E_C_N_O_) CTKMINRECNO , MAX(R_E_C_N_O_) R_E_C_N_O_ , MIN(CTK_ROTINA) CTK_ROTINA , MIN(CTK_KEY) CTK_KEY , MIN(CTK_ATIVDE) CTK_ATIVDE , MIN(CTK_ATIVCR) CTK_ATIVCR , COUNT(*) CONTAAGLUT , MIN(CTK_DTVENC) CTK_DTVENC, CTK_DIACTB, CTK_XDESCA,CTK_XDESAB,CTK_EC05DB,CTK_EC05CR"
   // _cQuery+= "FROM "+RetSqlname("CTK") + " CTK  WHERE CTK.CTK_FILIAL = '"+Xfilial("CTK")+"' AND    CTK.CTK_SEQUEN = '"+CTK->CTK_SEQUEN+"' AND    CTK.D_E_L_E_T_ = ' ' GROUP BY CTK_FILIAL,CTK_SEQUEN,CTK_DC,CTK_DEBITO,CTK_CREDIT,CTK_CCD,CTK_CCC,CTK_ITEMD,CTK_ITEMC,CTK_CLVLDB,CTK_CLVLCR,CTK_TPSALD,CTK_DATA,CTK_LP,CTK_DIACTB,CTK_XDESCA,CTK_XDESAB,CTK_EC05DB,CTK_EC05CR ORDER BY  CTKMINRECNO"
Endif
//Else 
//_cQuery:=" SELECT CTK_FILIAL,CTK_SEQUEN,CTK_DC,CTK_DEBITO,CTK_CREDIT,CTK_CCD,CTK_CCC,CTK_ITEMD,CTK_ITEMC,  CTK_CLVLDB,CTK_CLVLCR,CTK_TPSALD,CTK_DATA,CTK_LP,  SUM( CTK_VLR01 ) CTK_VLR01,  SUM( CTK_VLR02 ) CTK_VLR02,  SUM( CTK_VLR03 ) CTK_VLR03,  SUM( CTK_VLR04 ) CTK_VLR04, MAX(CTK_LP+CTK_LPSEQ) CTKLPLPSEQ , MIN(CTK_ORIGEM) CTK_ORIGEM , MIN(R_E_C_N_O_) CTKMINRECNO , MAX(R_E_C_N_O_) R_E_C_N_O_ , MIN(CTK_ROTINA) CTK_ROTINA , MIN(CTK_KEY) CTK_KEY , MIN(CTK_ATIVDE) CTK_ATIVDE , MIN(CTK_ATIVCR) CTK_ATIVCR , COUNT(*) CONTAAGLUT , MIN(CTK_DTVENC) CTK_DTVENC ,CTK_XDESCA,CTK_XDESAB"
//_cQuery+= "FROM "+RetSqlname("CTK") + " CTK  WHERE CTK.CTK_FILIAL = 'XX' AND    CTK.CTK_SEQUEN = '"+CTK->CTK_SEQUEN+"' AND    CTK.D_E_L_E_T_ = ' ' GROUP BY CTK_FILIAL,CTK_SEQUEN,CTK_DC,CTK_DEBITO,CTK_CREDIT,CTK_CCD,CTK_CCC,CTK_ITEMD,CTK_ITEMC,CTK_CLVLDB,CTK_CLVLCR,CTK_TPSALD,CTK_DATA,CTK_LP,CTK_XDESCA,CTK_XDESAB  ORDER BY  CTKMINRECNO"
//EndIf
Return _cQuery
