#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "COLORS.CH"

/*/{Protheus.doc} Kanban
    Classe respons�vel por criar uma barra de status no estilo kanban
    @type class
    @author Felipe Naganava
    @since 29/08/2022
    /*/
Class Kanban
    data cClassName as character hidden
	data cTitulo as character hidden
    data aFases as array hidden
    data nPos as numeric hidden
    data nLin as numeric hidden
    data nCol as numeric hidden
    data nLinFin as numeric hidden
    data nColFin as numeric hidden
    data oDlgKB as object hidden
    data lDisplayName as logical hidden
    data aPanelAux as array hidden
    data bValid as block hidden
    data oCorConcluido as object hidden
    data oCorAberto as object hidden
    data oFont as object hidden

	method New(cTitulo,aFases,nPos,nLin,nCol,nLinFin,nColFin,oDlgKB) constructor
    method ClassName()
	method Destroy()
	method Handle()
    method Display()
    method Seleciona(nPos)
    method getFase()

EndClass

/*/{Protheus.doc} Kanban::New
M�todo respons�vel pela cria��o do objeto kanban
@type method
@author Felipe Naganava
@since 29/08/2022
@param cTitulo, character, T�tulo
@param aFases, array, Array contendo as fases da regua de status
@param nPos, numeric, Posi��o da fase atual
@param nLin, numeric, Cordenada horizontal mais a esquerda em pixels
@param nCol, numeric, Cordenada vertical mais a cima em pixels
@param nLinFin, numeric, Cordenada horizontal mais a direita em pixels
@param nColFin, numeric, Cordenada vertical mais a baixo em pixels
@param oDlgKB, object, Janela onde ser� criado o objeto
@param oCorConcluido, object, Cor do status conclu�do
@param oCorAberto, object, Cor do status aberto
@param oFont, object, objeto do tipo TFont utilizado para definir as caracter�sticas da fonte aplicada na exibi��o do conte�do do controle visual.
/*/
method New(cTitulo,aFases,nPos,nLin,nCol,nLinFin,nColFin,oDlgKB,oCorConcluido,oCorAberto,oFont) class Kanban
    Default cTitulo           := ""
    Default oCorConcluido   := rgb(69, 254, 254)
    Default oCorAberto      := rgb(178, 255, 255)
    Default nPos            := 1

	::cClassName	:= "Kanban"
    ::cTitulo       := cTitulo
    ::aFases        := aFases
    ::nPos          := nPos
    ::nLin          := nLin
    ::nCol          := nCol
    ::nLinFin       := nLinFin
    ::nColFin       := nColFin
    ::oDlgKB        := oDlgKB
    ::oCorConcluido := oCorConcluido
    ::oCorAberto    := oCorAberto
    ::oFont         := oFont

    ::Display()
Return

/*/{Protheus.doc} Kanban::ClassName
M�todo respons�vel por retornar o nome da classe
@type method
@version 1.0
@author Felipe Naganava
@since 29/08/2022
@return character, nome da classe
/*/
method ClassName() class Kanban
Return ::cClassName

/*/{Protheus.doc} Kanban::Destroy
M�todo destrutor do objeto, respons�vel pela desaloca��o da mem�ria
@type method
@version 1.0
@author Felipe Naganava
@since 29/08/2022
/*/
method Destroy() class Kanban    
	local oSelf := ::Handle()
	freeObj(oSelf)
Return

/*/{Protheus.doc} Kanban::Handle
M�todo obter o endre�o de mem�ria do pr�prio objeto
@type method
@version 1.0
@author Felipe Naganava
@since 29/08/2022
/*/
method Handle() class Kanban
Return self

/*/{Protheus.doc} Kanban::Seleciona
M�todo para selecionar a fase atual
@type method
@version 1.0
@author Felipe Naganava
@since 29/08/2022
@param nPos, numeric, Posi��o da fase atual
/*/
method Seleciona(nPos) class Kanban
    Local nX := 0
    
    ::nPos := nPos

    If !Empty(::bValid)
        If !(Eval(::bValid))
            Return
        EndIf
    EndIf

    For nX := 1 To Len(::aPanelAux)
        If nX > nPos
            ::aPanelAux[nX]:SetColor(CLR_BLACK,::oCorAberto)
        Else
            ::aPanelAux[nX]:SetColor(CLR_BLACK,::oCorConcluido)
        EndIf
    Next nX
Return

/*/{Protheus.doc} Kanban::Display
Cria a regua no oDlg
@type method
@version 1.0
@author Felipe Naganava
@since 29/08/2022
/*/
method Display() class Kanban
    Local nX
    Local nLarg
    Local nAlt
    Local nLinAux   := ::nLin + 2
    Local nColAux   := ::nCol + 1
    Local oColor    := ::oCorConcluido

    ::aPanelAux := {}

    nLarg := ((::nColFin - ::nCol)/Len(::aFases)) - 1
    nAlt := (::nLinFin - ::nLin) - 4

    If !Empty(::cTitulo)
        oSay1:= TSay():New(::nLin,::nCol,{||::cTitulo},::oDlgKB,,::oFont,,,,.T.,,,200,20)
        nLinAux += 10
    EndIf

    For nX := 1 To Len(::aFases)
        If nX > ::nPos
            oColor := ::oCorAberto
        EndIf
        aadd(::aPanelAux,tPanel():New(nLinAux,nColAux,::aFases[nX],::oDlgKB,::oFont,.T.,,CLR_BLACK,oColor,nLarg,nAlt))
        ::aPanelAux[nX]:CARGO := nX
		::aPanelAux[nX]:bLClicked := {|oObj| ::Seleciona(oObj:CARGO)}
        nColAux += nLarg + 1
    Next nX
Return

/*/{Protheus.doc} Kanban::getFase
Retorna a fase atual
@type method
@version 1.0
@author Felipe Naganava
@since 29/08/2022
@return character, Fase Atual
/*/
method getFase() class Kanban
    Local cFase := ::aFases[::nPos]
Return cFase

/*/{Protheus.doc} TSTKANBAN
Fun��o de teste da classe kanban
@type function
@version 1.0
@author Felipe Naganava
@since 29/08/2022
@example U_TSTKANBAN()
/*/
User Function TSTKANBAN()
    Local aSize 		:= MsAdvSize(.T.) //Pega o tamanho da tela
	Local oKanban       := NIL
    Local aFases        := {'Fase 1','Fase 2','Fase 3', 'Fase 4','Fase 5'}
    Local oDlg
    Local oCorConcluido   := rgb(238, 232, 170)
    Local oCorAberto      := rgb(169, 169, 169)
    Local oFont           := TFont():New('Courier new',,-40,.T.)
    
	oDlg := MSDialog():New(aSize[7],aSize[1],aSize[6],aSize[5],"Kaban de Teste",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
        oKanban := kanban():New(,aFases,3,20,20,70,820,oDlg,oCorConcluido,oCorAberto,oFont)
        oKanban:bValid := {|| .T.}
    oDlg:Activate(,,,,{|| .T.},)
Return
