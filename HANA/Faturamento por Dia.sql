SELECT
	EXTRACT (DAY FROM (T0."DocDate")) AS "Dia",
	MONTH(T0."DocDate") AS "Mes",
	YEAR(T0."DocDate") AS "Ano",
	SUM((T0."DocTotal" - T0."VatSum")) AS "Total Nota s/ Imposto"
FROM
	OINV T0
WHERE
	MONTH(T0."DocDate") = MONTH(CURRENT_DATE)							--Aqui estou filtrando somente o mês atual, mas se quiser que mostre TODO o histórico, basta comentar o WHERE
GROUP BY
	YEAR(T0."DocDate"),
	MONTH(T0."DocDate"),
	EXTRACT (DAY FROM (T0."DocDate"))
ORDER BY
	YEAR(T0."DocDate"),
	MONTH(T0."DocDate"),
	EXTRACT (DAY FROM (T0."DocDate"))