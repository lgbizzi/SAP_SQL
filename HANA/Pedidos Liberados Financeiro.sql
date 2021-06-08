SELECT
	DISTINCT												--Usei o Distinct para mostrar o n�mero de pedidos apenas 1 vez
	T0."DocNum" AS "N� do Pedido",
	T0."CardName" AS "Nome do Cliente",
	
	CASE
		WHEN T0."DocStatus" ='O' THEN 'Abrir'				--O Case � usado para trazer os Status 'O' como "Abrir", assim como no SAP
		ELSE 'N�o Autorizado'
	END
	AS "Status",
	
	CASE
		WHEN T0."Confirmed" ='Y' THEN 'Sim'					--O Case � usado para trazer quando a caixinha "Autorizado" estiver marcada, trazer como "Sim" na consulta
		ELSE 'N�o Autorizado'
	END
	AS "Autorizado",

FROM
	ORDR T0
WHERE
	"DocStatus" = 'O'
	AND "Confirmed" = 'Y'