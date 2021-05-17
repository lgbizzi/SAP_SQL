SELECT
	T0."OnHand" AS "EmEstoque",
	T1."ItemCode" AS "ItemCode",
	T1."ItemName" AS "ItemName",
	T1."U_ITEM" AS "Item",																	--Campo de usuário para definir se o Item é Matéria Prima, Material Secundário, Produto Acabado, etc
	T1."U_TIPO" AS "Tipo",																	--Campo de usuário para definir o tipo do item
	T1."U_MODELOUTILIZADO" AS "Modelo Utilizado",											--Campo de usuário para definir o Modelo Utilizado na fabricação
	T0."IsCommited" AS "Confirmado",
	T0."OnOrder" AS "Pedido",
	T0."OnHand" + T0."OnOrder" - T0."IsCommited" AS "Disponivel",							--Foi definido que, como Disponível, irá mostrar o que está no estoque físico + o que está em Produção - o que está reservado nos Pedidos de Venda
	T0."WhsCode" AS "Deposito",
	T1."CodeBars" AS "Codigo de barras"
FROM OITW AS T0
	LEFT JOIN OITM AS T1 ON T0."ItemCode" = T1."ItemCode"									
WHERE 
	 T1."frozenFor" = 'N'																	--Define que serão buscados apenas os itens ativos