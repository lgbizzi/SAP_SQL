SELECT 
	T0."DocEntry" AS "Documento",
	T0."CardCode" AS "Cód. Fornecedor",
	T0."CardName" AS "Nome Fornecedor",
	T1."ItemCode" AS "Cód. do Item",
	T1."Dscription" AS "Item",
	T1."Quantity" AS "Quantidade",
	T1."Price" AS "Preco Unitario",
	T1."LineTotal" AS "Total do Item",
	T0."DocTotal" AS "Valor do Pedido",
	T0."TaxDate" AS "Data do Documento"
	
FROM 
	OPOR T0												--Tabela dos Pedidos
	JOIN POR1 T1 ON T1."DocEntry" = T0."DocNum"			--Tabela dos Itens em um Pedido
WHERE	
	T0."DocDate" BETWEEN '[%0]' AND '[%1]'				--Entre Data Inicial e Dada Final