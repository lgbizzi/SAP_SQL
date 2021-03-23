SELECT 
	T1.Serial AS 'N� NF',
	T1.CardCode AS 'C�d. do Cliente',
	T1.CardName AS 'Nome do Cliente',
	T0.ItemCode AS 'C�d. do Item',
	T0.Dscription AS 'Descri��o do Item',
	T1.DocDate AS 'Data da Nota',
	T0.Quantity AS 'Quantidade',
	T0.LineTotal AS 'Valor Total do ITEM (R$)'
FROM 
	INV1 T0, OINV T1
WHERE T0.ItemCode = '[%0]' AND
	T0.DocEntry = T1.DocEntry AND
	T1.DocDate >= '[%1]' AND 
	T1.DocDate <= '[%2]'
ORDER BY T1.Serial