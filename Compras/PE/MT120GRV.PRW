#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"


/*/{Protheus.doc} User Function MT120GRV
    (long_description)
    @type  Function
    @author user
    @since 17/03/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MT120GRV()
Local cInclu :=  ParamIxb[2]
Local cStatus := ParamIxb[3]
Local lRet     := .T.
Local aArea := GetArea()
//Local cObservacion := M->C7_XOBSG


    If !Acols[n][len(aHeader)+1] //nao pega quando a linha esta deletada
        //Grava campos criados no cabeçalho do pedido
        RecLock("SC7",.F.)
        SC7->C7_XOBSG := cXObserv
        MsUnlock("SC7")
        RestArea(aArea)
    Endif

    
Return lRet
