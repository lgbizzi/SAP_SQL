SELECT
	COUNT(T0."DocNum") AS "Qtde. Notas Fiscais",
	SUM(T0."DocTotal" - T0."VatSum") AS "Total das Notas Fiscais s/ Imposto"
FROM
	OINV T0
WHERE
	T0."DocStatus" = 'O'													--Onde o Documento estiver em aberto
	AND T0."Confirmed" = 'Y'												--E a caixinha Autorizado (em Logística) estiver marcada
	--AND T0."U_RB_StatusPed" = 'Ac'										--E a Situacao da Entrega estiver como "Liberado"
	--AND "CreateDate" <= CURRENT_DATE										--E a Data de Entrega for da data atual para trás
	AND "CreateDate" = CURRENT_DATE											--Se quiser saber apenas as entregas para a data atual, comentar a linha de cima e habilitar essa
	--AND "CreateDate" >= CURRENT_DATE										--Se quiser saber apenas as entregas para a data atual em diante, comentar as duas linhas de cima e habilitar essa
