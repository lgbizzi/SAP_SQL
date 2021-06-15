SELECT 
	T0."DocNum" AS "Documento",
	T0."DocEntry" AS "Entrada",
	T0."Serial" AS "Nº Nota Fiscal",
	T0."CardCode" AS "Cód. Fornecedor",
	T0."CardName" AS "Nome Fornecedor",
	T1."ItemCode" AS "Cód. do Item",
	T1."Dscription" AS "Item",
	T1."Quantity" AS "Quantidade",
	T0."DocTotal" AS "Valor da Nota",
	T0."TaxDate" AS "Data do Documento"
	
FROM 
	OPCH T0											--Tabela das Notas Fiscais de Entrada
	JOIN PCH1 T1 ON T1."DocEntry" = T0."DocEntry"		--Tabela dos Itens em Notas Fiscais de Entrada
WHERE	
	T0."DocDate" BETWEEN '[%0]' AND '[%1]'
