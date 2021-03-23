SELECT 
	'Código do Item' = T1.itemCode
	,'Descrição' = T1.ItemName
	,'Código de Barras' = T1.CodeBars
	,'ItemCOR'  = T5.Name
	,'ItemEmbal' = T6.Name
	,'ItemTaman' = T7.Name
	,'ItemMarca' = T8.Name
	,'ItemTipo'  = T9.Name
	,'ItemImpressao' = ISNULL(T10.Name,'S/Impressao')
	,'Inativo' = T1.frozenFor
FROM  OITM AS T1 
	LEFT JOIN [@RB_CORP] T5 ON T5.[Code] = T1.[U_Cor]
	LEFT JOIN [@RB_EMBP] T6 ON T6.[Code] = T1.[U_Embal]
	LEFT JOIN [@RB_TAMP] T7 ON T7.[Code] = T1.[U_Tamanho]
	LEFT JOIN [@RB_MARCA] T8 ON T8.[Code] = T1.[U_Marca]
	LEFT JOIN [@RB_TIPOP] T9 ON T9.[Code] = T1.[U_Tipo]
	LEFT JOIN [@RB_IMPP] T10 ON T10.Code = T1.U_Impressao
WHERE T1.ItemCode LIKE  '1%'   
	--AND T1.frozenFor = 'N'
	AND T1.ItemCode NOT LIKE '1001'
	AND T1.ItemCode NOT LIKE '100'
	AND T1.ItemCode NOT LIKE '%/%'