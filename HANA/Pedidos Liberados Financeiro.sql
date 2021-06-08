SELECT
	DISTINCT												--Usei o Distinct para mostrar o número de pedidos apenas 1 vez
	T0."DocNum" AS "Nº do Pedido",
	T0."CardName" AS "Nome do Cliente",
	
	CASE
		WHEN T0."DocStatus" ='O' THEN 'Abrir'				--O Case é usado para trazer os Status 'O' como "Abrir", assim como no SAP
		ELSE 'Não Autorizado'
	END
	AS "Status",
	
	CASE
		WHEN T0."Confirmed" ='Y' THEN 'Sim'					--O Case é usado para trazer quando a caixinha "Autorizado" estiver marcada, trazer como "Sim" na consulta
		ELSE 'Não Autorizado'
	END
	AS "Autorizado",

FROM
	ORDR T0
WHERE
	"DocStatus" = 'O'
	AND "Confirmed" = 'Y'