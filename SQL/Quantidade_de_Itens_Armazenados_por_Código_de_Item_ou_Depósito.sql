SELECT 
	T0.ItemCode AS 'Código do Item',
	T0.ItemName AS 'Descricao do Item',
	T2.WhsName AS 'Depósito',
	T1.OnHand AS 'Quantidade no Estoque'
FROM
	OITM T0										--Tabela dos Cadastros de Itens
	JOIN OITW T1 ON T0.ItemCode = T1.ItemCode	--Tabela das Quantidades de Itens em cada Depósito
	JOIN OWHS T2 ON T1.WhsCode = T2.WhsCode		--Tabela dos Cadastros de Depósitos
WHERE
	T2.WhsCode = '[%0]'							--Caso queira procurar por Código de Depósito
	--T0.ItemCode = '[%0]'						--Caso queira procurar por Código de Item