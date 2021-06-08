SELECT
	COUNT(T0."DocNum") AS "Qtde. Notas Fiscais",
	SUM(T0."DocTotal" - T0."VatSum") AS "Total das Notas Fiscais s/ Imposto"
FROM
	OINV T0
WHERE
	T0."DocStatus" = 'O'													--Onde o Documento estiver em aberto
	AND T0."Confirmed" = 'Y'												--E a caixinha Autorizado (em Logística) estiver marcada
	--AND "CreateDate" <= CURRENT_DATE										--E a Data de Criação da NF for da data atual para trás
	AND "CreateDate" = CURRENT_DATE											--Se quiser saber apenas NFs criadas para a data atual, comentar a linha de cima e habilitar essa
