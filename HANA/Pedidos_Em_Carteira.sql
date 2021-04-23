SELECT
	T1."DocNum" AS "Num. Pedido",
	T5."CardName" AS "Cliente",
	T1."CardCode" AS "Cod. Cliente",
	
	CASE T1."CardCode"
		WHEN 'C00001' THEN T0."ShipDate"
		WHEN 'C00002' THEN T0."ShipDate"
		ELSE T1."DocDueDate"
	END AS "Data Entrega",
	
	--Campo de Usuário de Data de Liberação do Pedido,
	T1."DocDate" AS "Data Lançamento",
	T0."ItemCode" AS "Cod. Item",
	T0."Dscription" AS "Descricao",
	T0."Quantity" AS "Qtd.",
	T0."Quantity" - T0."DelivrdQty" AS "Qtd. - Fornec.",
	T0."OpenCreQty" AS "Qtd. em Aberto",
	T1."VatSum" + (T1."VatSum" * (T0."DiscPrcnt"/100)) AS "Valor Total",
	T0."Price" AS "Preco Item Unit.",
	
	CASE SUBSTRING (T0."ItemCode", '1', '1')
		WHEN '1' THEN T0."LineTotal" - (T0."LineTotal" * (T0."DiscPrcnt"/100))
		WHEN '9' THEN (T0."LineTotal" - (T0."LineTotal" * (T0."DiscPrcnt"/100)))/70*100
	END AS "Preco Item Total",
	
	T0."LineTotal" AS "LineTotal",
	T1."DocTotal" AS "ValorPedido",
    MONTH(T1."DocDate") AS "MesL",
    YEAR(T1."DocDate") AS "AnoL",
    EXTRACT (DAY FROM (T1."DocDate")) AS "DiaL",						--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
    MONTH(T1."DocDueDate") AS "MesE",
    YEAR(T1."DocDueDate") AS "AnoE",
    EXTRACT (DAY FROM (T1."DocDueDate")) AS "DiaE",
    T1."DocStatus" AS "StatusPedido",
    T0."LineStatus" AS "StatusLinha",									
	T9."SlpName" AS "Vendedor",											
	( T0."Weight1"/1000 ) AS "Peso",		
	
	((T0."Weight1"/1000 )/T0."Quantity") 			/* Peso do Pacote*/
								*T0."OpenCreQty" 	/*qtd em aberto*/
	AS "Peso em aberto",													
	
	/*T2."U_MARCA" AS "Marca",
	T2."U_TIPO" AS "Tipo",
	T2."U_MODELOUTILIZADO" AS "Modelo",
	T2."U_CORBALAO" AS "Cor",
	T2."U_APRESENTACAOEMB" AS "Embalagem",
	T2."U_IMPRESSAO" AS "Impressao",
	T2."U_CORIMPRESSAO" AS "Cor Impressao",
	T2."U_COMPLEMENTO" AS "Complemento",*/	
	T1."Confirmed" AS "Ped. Confirmado",
	T1."Comments" AS "Observacoes",
	T0."LineNum" AS "Num. Linha",
	--T3."Descr" AS "Situacao do Pedido"
	
FROM
	RDR1 T0																--Tabela dos Itens dentro de um Pedido
	LEFT JOIN ORDR T1 ON T1."DocEntry" = T0."DocEntry"					--Tabela dos Pedidos
	LEFT JOIN OITM T2 ON T0."ItemCode" = T2."ItemCode"					--Tabela dos Cadastros dos Itens
	--LEFT JOIN UFD1 T3 ON T1."U_RB_StatusPed" = T3."FldValue"			--Tabela dos Cadastros de Situacoes do Pedido
	LEFT JOIN OSLP T9 ON T1."SlpCode" = T9."SlpCode"					--Tabela dos Cadastros de Vendedores (Representantes)
	LEFT JOIN OCRD T5 ON T1."CardCode" = T5."CardCode"					--Tabela dos Cadastros de Parceiros de Negócios
	
WHERE
	T1."DocDate" >= ADD_YEARS (TO_DATE(CURRENT_DATE, 'YYYY-MM-DD'),-1)	--Como não encontrei função para SUBRTRAIR 1 ano no HANA, adicionei 1 ano negativo
	AND T1."CANCELED" = 'N'