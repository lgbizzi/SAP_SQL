/*

Selecionar Ticket Mínimo, Ticket Máximo, Ticket Médio de cada cliente, no Período do ano passado



CardCode = Codigo do Cliente
CardName = Nome do Cliente
DocTotal = Total da Nota
DocDate = Data da Geração da Nota Fiscal
DocNum = Numero de Documento de Nota Fiscal

*/

/*SAP HANA DB*/

SELECT DISTINCT													
	"CardCode" AS "Codigo do Cliente",										/*A diferença aqui é que as colunas tem que estar dentro de "" (aspas duplas)*/
	"CardName" AS "Nome do Cliente",										/*assim como as strings que quisermos exibir nos cabeçalhos*/
	MIN("DocTotal") OVER (PARTITION BY "CardCode") AS "Valor Mínimo Nota",	/*As aspas simples são somente para comparações de valores*/
	MAX("DocTotal") OVER (PARTITION BY "CardCode") AS "Valor Maximo Nota",	
	AVG("DocTotal") OVER (PARTITION BY "CardCode") AS "Média Nota",
	COUNT("DocNum") OVER (PARTITION BY "CardCode") AS "Qtde. de Notas"
FROM
	OINV
WHERE
	"DocDate" >= ADD_MONTHS (CURRENT_DATE, -11) AND							/*No HANA, como equivalente a função DATEADD do SQL temos ADD_DAYS, ADD_MONTHS, ADD_SECONDS, ADD_WORKDAYS*/
	"DocDate" < CURRENT_DATE												/*Assim como para a CURRENT_TIMESTAMP, em que temos a CURRENT_DATE*/
ORDER BY
	"CardCode"