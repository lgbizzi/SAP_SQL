SELECT 
	T0.ItemCode AS 'C�digo do Item',
	T0.ItemName AS 'Descricao do Item',
	T2.WhsName AS 'Dep�sito',
	T1.OnHand AS 'Quantidade no Estoque'
FROM
	OITM T0										--Tabela dos Cadastros de Itens
	JOIN OITW T1 ON T0.ItemCode = T1.ItemCode	--Tabela das Quantidades de Itens em cada Dep�sito
	JOIN OWHS T2 ON T1.WhsCode = T2.WhsCode		--Tabela dos Cadastros de Dep�sitos
WHERE
	T2.WhsCode = '[%0]'							--Caso queira procurar por C�digo de Dep�sito
	--T0.ItemCode = '[%0]'						--Caso queira procurar por C�digo de Item