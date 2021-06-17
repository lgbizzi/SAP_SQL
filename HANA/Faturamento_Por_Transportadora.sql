SELECT	
	T0."DocNum" AS "Nº Doc. da NF",
	T0."Serial" AS "Nº da NF",
	(T0."DocTotal" - T0."VatSum") AS "Total Nota s/ Imposto",
	T2."QoP" AS "Qtd. Embalagens",
	T3."CardName" AS "Transportadora",
	T2."State" AS "Estado",
	EXTRACT (DAY FROM (T0."DocDate")) AS "Dia",
	MONTH(T0."DocDate") AS "Mes",
	YEAR(T0."DocDate") AS "Ano"
FROM
	OINV T0															--Tabela de Notas Fiscais
	JOIN INV12 T2 ON T0."DocEntry" = T2."DocEntry"					--Vínculo entre Estado atribuído na Nota com tabela de cadastro de Endereços
	JOIN OCRD T3 ON T3."CardCode" = T2."Carrier"					--Vínculo entre Transportadora atribuída na Nota com Cadastro de PNs
WHERE
	T0."Serial" >= '[%0]'											--Filtro de Numeração de NF
	AND T0."Serial" >= '[%1]'
	AND T0."DocDate" >= '[%2]'										--Filtro de Data
	AND T0."DocDate" >= '[%3]'
GROUP BY															--Agrupando pelas Cláusulas abaixo
	YEAR(T0."DocDate"),												--Primeiro por ano
	MONTH(T0."DocDate"),											--Depois por mês
	EXTRACT (DAY FROM (T0."DocDate")),								--Em seguida por dia
	T0."DocNum",
	T0."Serial",
	(T0."DocTotal" - T0."VatSum"),
	T2."QoP",
	T3."CardName",
	T2."State"
ORDER BY															--Ordenando pelas Cláusulas abaixo
	T3."CardName",													--Nome da Transportadora
	T0."DocNum"														--Nº do Documento de NF