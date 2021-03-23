/*

Selecionar Ticket Mínimo, Ticket Máximo, Ticket Médio de cada cliente, no Período do ano passado



CardCode = Codigo do Cliente
CardName = Nome do Cliente
DocTotal = Total da Nota
DocDate = Data da Geração da Nota Fiscal
DocNum = Numero de Documento de Nota Fiscal

*/

/*SQL Server*/

SELECT DISTINCT
	CardCode AS 'Codigo do Cliente',
	CardName AS 'Nome do Cliente',
	MIN(DocTotal) OVER (PARTITION BY CardCode) AS 'Valor Mínimo Nota',
	MAX(DocTotal) OVER (PARTITION BY CardCode) AS 'Valor Maximo Nota',
	AVG(DocTotal) OVER (PARTITION BY CardCode) AS 'Média Nota',
	COUNT(DocNum) OVER (PARTITION BY CardCode) AS 'Qtde. de Notas'
FROM
	OINV
WHERE
	DocDate >= dateadd(month, datediff(month, 0, current_timestamp) - 11, 0) AND 
	DocDate < dateadd(month, datediff(month, 0, current_timestamp) + 1, 0)
ORDER BY
	CardCode;