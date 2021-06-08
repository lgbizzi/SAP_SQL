SELECT
	T0."DocNum",									--Código da Solicitação de Compras		
	T0."Requester",									--Usuário do requisitante
	T0."ReqName",									--Nome do Requisitante
	T3."Name",										--Nome dos Departamentos
	T0."DocDate",									--Data de criação da Solicitação
	T0."ReqDate",									--Data necessária para a Solicitação
	T1."ItemCode",									--Código do Item
	T1."Dscription",								--Descrição do Item
	T1."Quantity",									--Quantidade do Produto
	T1."LineVendor"									--Fornecedor
FROM
	OPRQ T0											--Tabela das Solicitações de Compra
	JOIN PRQ1 T1 ON T0."DocEntry" = T1."DocEntry"	--Junção da tabela dos Itens de Solicitação de Compra com as Solicitações de Compra
	JOIN OUDP T3 ON T0."Department" = T3."Code"		--Junção da tabela dos Departamentos com as Solicitações de Compra
WHERE
	T0."DocStatus" = 'O'							--Onde a Solicitação de Compra esteja em aberto
	AND T0."DocDate" BETWEEN '[%0]' AND '[%1]'		--Filtro para usuário inserir a Data
