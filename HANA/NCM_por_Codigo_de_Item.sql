SELECT 
	T0."ItemCode" AS "Cód. Item",
	T0."ItemName" AS "Desc. Item",
	T1."NcmCode" AS "Cód. NCM"
FROM 
	OITM T0
	JOIN ONCM T1 ON T0."NCMCode" = T1."AbsEntry"		--Faz o vínculo do NCM na tabela de Itens com o cadastro na tabela de NCMs
WHERE
	T0."ItemCode" = '[%0]'								--Se quiser descobrir o NCM através do Código do Item
	T1."NcmCode" = '[%0]'								--Se quiser descobrir o Código do Item através do NCM