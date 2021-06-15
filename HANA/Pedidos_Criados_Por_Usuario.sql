SELECT
	T0."DocEntry" AS "Pedido",
	T0."CardCode" AS "Cod. Cliente",
	T0."CardName" AS "Nome Cliente",
	T1."U_NAME" AS "Usuário"						--Campo de Nome de Usuário, na tabela de Usuários
FROM
	ORDR T0											--Tabela de Pedidos
	JOIN OUSR T1 ON T0."UserSign" = T1."USERID"		--Vínculo entre o campo de código de usuário criador na tabela do Pedido com a tabela de cadastro de usuários
WHERE
	T0."CreateDate" = CURRENT_DATE					--Em que a Data de criação seja a Data Atual
ORDER BY 
	T1."U_NAME"										--Ordene por nome