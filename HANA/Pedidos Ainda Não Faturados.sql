SELECT
	--EXTRACT (DAY FROM (T0."DocDate")) AS "Dia",							--Se quiser selecionar o dia, basta descomentar essa linha e as cláusulas do Group By e Order By
	YEAR(T0."DocDate") AS "Ano",
	MONTH(T0."DocDate") AS "Mes",
	SUM((T0."DocTotal" - T0."VatSum")) AS "Total Pedido s/ Imposto"
FROM
	ORDR T0
WHERE
	T0."DocStatus" = 'O'													--Onde o Documento estiver em aberto
	AND T0."Confirmed" = 'Y'												--E a caixinha Autorizado (em Logística) estiver marcada
	--AND MONTH(T0."DocDate") = MONTH(CURRENT_DATE)							--Aqui estou filtrando somente o mês atual, mas se quiser que mostre TODO o histórico, basta comentar o WHERE
GROUP BY
	YEAR(T0."DocDate"),
	MONTH(T0."DocDate")/*,
	EXTRACT (DAY FROM (T0."DocDate"))*/
ORDER BY
	YEAR(T0."DocDate"),
	MONTH(T0."DocDate")/*,
	EXTRACT (DAY FROM (T0."DocDate"))*/