SELECT
	T0."DocNum" AS "Nº Pedido",
	T0."CardCode" AS "Cód. Cliente",
	T0."CardName" AS "Cliente",
	COUNT(T1."ItemCode") AS "Qtde. Itens no Pedido",
	SUM(T1."Quantity") AS "Qtde. Pacotes no Pedido",
	(T0."DocTotal" - T0."VatSum") AS "Total Pedido s/ Imposto"
FROM
	ORDR T0
	JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
WHERE
	T0."DocStatus" = 'O'													--Onde o Documento estiver em aberto
	AND T0."Confirmed" = 'Y'												--E a caixinha Autorizado (em Logística) estiver marcada
	AND "DocDueDate" <= CURRENT_DATE										--E a Data de entrega for da data atual para trás
	--AND "DocDueDate" = CURRENT_DATE										--Se quiser saber apenas os pedidos com data de entrega para a data atual, comentar a linha de cima e habilitar essa
	--AND "DocDueDate" >= CURRENT_DATE										--Se quiser saber apenas os pedidos com data de entrega para a data atual em diante, comentar as duas linhas de cima e habilitar essa
GROUP BY
	T0."DocNum",
	T0."CardCode",
	T0."CardName",
	(T0."DocTotal" - T0."VatSum")