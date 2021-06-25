SELECT
	MONTH(T0."DocDueDate") AS "Mês",
	COUNT(T0."DocNum") AS "Qtde. Pedidos",
	SUM(T0."DocTotal" - T0."VatSum") AS "Total dos Pedidos s/ Imposto"
FROM
	ORDR T0
WHERE
	T0."DocStatus" = 'O'													--Onde o Documento estiver em aberto
	AND T0."Confirmed" = 'Y'												--E a caixinha Autorizado (em Logística) estiver marcada
GROUP BY
	MONTH(T0."DocDueDate")