SELECT 
	T0."OnHand" AS "EmEstoque",
	T1."ItemCode" AS "ItemCode",
	T1."ItemName" AS "ItemName",
	T1."U_ITEM" AS "Item",
	COALESCE(T1."U_MARCA", 'S/ Marca Definida') AS "Marca",									--Como a Marca é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	T1."U_TIPO" AS "Tipo",
	T1."U_MODELOUTILIZADO" AS "Modelo Utilizado",
	T1."U_CORBALAO" AS "Cor Balão",
	COALESCE(T1."U_IMPRESSAO", 'S/ Impressao') AS "Impressao",								--Como a Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_CORIMPRESSAO", 'S/ Impressao') AS "Cor Impressao",						--Como a Cor da Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_APRESENTACAOEMB", 'S/ Embalagem Definida') AS "Apresentacao Embalagem",	--Como a Apresentação da Embalagem é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	COALESCE(T1."U_COMPLEMENTO", 'S/ Complemento') AS "Complemento",
	T0."IsCommited" AS "Confirmado",
	T0."OnOrder" AS "Pedido",
	T0."OnHand" + T0."OnOrder" - T0."IsCommited" AS "Disponivel",							--Na consulta original, no SQL SERVER, está definido que como Disponível irá mostrar o que está no estoque físico + o que está em Produção - o que está reservado nos Pedidos de Venda
	T0."WhsCode" AS "Deposito",
	T1."CodeBars" AS "Codigo de barras",
	
	'0' AS "PedidoDeVendaNumero",
	'0' AS "PedidoDeVendaQtd",
	'0' AS "PedidoDeVendaTotalLinha",
	'0' AS "PedidoDeVendaAnoEntrega",
	'0' AS "PedidoDeVendaMesEntrega",
    '0' AS "PedidoDeVendaDiaEntrega",														--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVendaEntrega",
	'0' AS "PedidoDeVendaAno",
	'0' AS "PedidoDeVendaMes",
    '0' AS "PedidoDeVendaDia",																--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVenda",
	
	(T1."SWeight1"/1000)*T0."OnHand" AS "Pts em Kg",
	T1."SWeight1"/1000 AS "Pt em Kg",
	'0' AS "Pts em Kg Ped",
	'0' AS "Pt em Kg Ped"
	
FROM OITW AS T0
	LEFT JOIN OITM AS T1 ON T0."ItemCode" = T1."ItemCode"
WHERE T0."ItemCode" LIKE  '1%'
	AND T1."frozenFor" = 'N'

	
UNION

/*PEDIDOS*/

SELECT 
	'0' AS "EmEstoque",
	T1."ItemCode" AS "ItemCode",
	T1."ItemName" AS "ItemName",
	T1."U_ITEM" AS "Item",
	COALESCE(T1."U_MARCA", 'S/ Marca Definida') AS "Marca",									--Como a Marca é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	T1."U_TIPO" AS "Tipo",
	T1."U_MODELOUTILIZADO" AS "Modelo Utilizado",
	T1."U_CORBALAO" AS "Cor Balão",
	COALESCE(T1."U_IMPRESSAO", 'S/ Impressao') AS "Impressao",								--Como a Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_CORIMPRESSAO", 'S/ Impressao') AS "Cor Impressao",						--Como a Cor da Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_APRESENTACAOEMB", 'S/ Embalagem Definida') AS "Apresentacao Embalagem",	--Como a Apresentação da Embalagem é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	COALESCE(T1."U_COMPLEMENTO", 'S/ Complemento') AS "Complemento",
	'0' AS "Confirmado",
	'0' AS "Pedido",
	'0' AS "Disponivel",
	T0."WhsCode" AS "Deposito",
	T1."CodeBars" AS "Codigo de barras",
	T0."DocEntry" AS "PedidoDeVendaNumero",
	T0."Quantity" AS "PedidoDeVendaQtd",
	T0."LineTotal" AS "PedidoDeVendaTotalLinha",
	YEAR(T2."DocDueDate") AS "PedidoDeVendaAnoEntrega",
	MONTH(T2."DocDueDate") AS "PedidoDeVendaMesEntrega",
    EXTRACT (DAY FROM (T2."DocDueDate")) AS "PedidoDeVendaDiaEntrega",						--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	T2."DocDueDate" AS "PedidoDeVendaEntrega",
	YEAR(T2."DocDate") AS "PedidoDeVendaAno",
	MONTH(T2."DocDate") AS "PedidoDeVendaMes",
    EXTRACT (DAY FROM (T2."DocDate")) AS "PedidoDeVendaDia",								--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	T2."DocDate" AS "PedidoDeVenda",
	(T1."SWeight1"/1000)*T0."Quantity" AS "Pts em Kg",
	T1."SWeight1"/1000 AS "Pt em Kg",
	(T0."Weight1"/1000) AS "Pts em Kg Ped",
	(T0."Weight1"/1000)/T0."Quantity" AS "Pt em Kg Ped"

FROM RDR1 AS T0
	LEFT JOIN OITM AS T1 ON T0."ItemCode" = T1."ItemCode"
	LEFT JOIN ORDR AS T2 ON T2."DocEntry" = T0."DocEntry"
WHERE T0."ItemCode" LIKE  '1%'   
	AND T1."frozenFor" = 'N'
	AND T2."CANCELED" = 'N'
	AND T0."LineStatus" = 'O'
		
UNION

/*ESTOQUE MP*/

SELECT 
	
	T0."OnHand" AS "EmEstoque",
	T1."ItemCode" AS "ItemCode",
	T1."ItemName" AS "ItemName",
	T1."U_ITEM" AS "Item",
	COALESCE(T1."U_MARCA", 'S/ Marca Definida') AS "Marca",									--Como a Marca é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	T1."U_TIPO" AS "Tipo",
	T1."U_MODELOUTILIZADO" AS "Modelo Utilizado",
	T1."U_CORBALAO" AS "Cor Balão",
	COALESCE(T1."U_IMPRESSAO", 'S/ Impressao') AS "Impressao",								--Como a Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_CORIMPRESSAO", 'S/ Impressao') AS "Cor Impressao",						--Como a Cor da Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_APRESENTACAOEMB", 'S/ Embalagem Definida') AS "Apresentacao Embalagem",	--Como a Apresentação da Embalagem é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	COALESCE(T1."U_COMPLEMENTO", 'S/ Complemento') AS "Complemento",
	T0."IsCommited" AS "Confirmado",
	T0."OnOrder" AS "Pedido",
	T0."OnHand" + T0."OnOrder" - T0."IsCommited" AS "Disponivel",							--Na consulta original, no SQL SERVER, está definido que como Disponível irá mostrar o que está no estoque físico + o que está em Produção - o que está reservado nos Pedidos de Venda
	T0."WhsCode" AS "Deposito",
	T1."CodeBars" AS "Codigo de barras",

	'0' AS "PedidoDeVendaNumero",
	'0' AS "PedidoDeVendaQtd",
	'0' AS "PedidoDeVendaTotalLinha",
	'0' AS "PedidoDeVendaAnoEntrega",
	'0' AS "PedidoDeVendaMesEntrega",
    '0' AS "PedidoDeVendaDiaEntrega",														--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVendaEntrega",
	'0' AS "PedidoDeVendaAno",
	'0' AS "PedidoDeVendaMes",
    '0' AS "PedidoDeVendaDia",																--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVenda",
	
	'0' AS "Pts em Kg",
	'0' AS "Pt em Kg",
	'0' AS "Pts em Kg Ped",
	'0' AS "Pt em Kg Ped"

FROM OITW AS T0
	LEFT JOIN OITM AS T1 ON T0."ItemCode" = T1."ItemCode"
WHERE T0."ItemCode" LIKE  'MP%'   
	AND T1."frozenFor" = 'N'
		
/*
UNION

Na Consulta original seria o Estoque do Mix, mas lá também estava só o comentário
*/	
	
UNION

/*Estoque EMB*/

SELECT 
	T0."OnHand" AS "EmEstoque",
	T1."ItemCode" AS "ItemCode",
	T1."ItemName" AS "ItemName",
	T1."U_ITEM" AS "Item",
	COALESCE(T1."U_MARCA", 'S/ Marca Definida') AS "Marca",									--Como a Marca é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	T1."U_TIPO" AS "Tipo",
	T1."U_MODELOUTILIZADO" AS "Modelo Utilizado",
	T1."U_CORBALAO" AS "Cor Balão",
	COALESCE(T1."U_IMPRESSAO", 'S/ Impressao') AS "Impressao",								--Como a Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_CORIMPRESSAO", 'S/ Impressao') AS "Cor Impressao",						--Como a Cor da Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_APRESENTACAOEMB", 'S/ Embalagem Definida') AS "Apresentacao Embalagem",	--Como a Apresentação da Embalagem é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	COALESCE(T1."U_COMPLEMENTO", 'S/ Complemento') AS "Complemento",
	T0."IsCommited" AS "Confirmado",
	T0."OnOrder" AS "Pedido",
	T0."OnHand" + T0."OnOrder" - T0."IsCommited" AS "Disponivel",							--Na consulta original, no SQL SERVER, está definido que como Disponível irá mostrar o que está no estoque físico + o que está em Produção - o que está reservado nos Pedidos de Venda
	T0."WhsCode" AS "Deposito",
	T1."CodeBars" AS "Codigo de barras",

	'0' AS "PedidoDeVendaNumero",
	'0' AS "PedidoDeVendaQtd",
	'0' AS "PedidoDeVendaTotalLinha",
	'0' AS "PedidoDeVendaAnoEntrega",
	'0' AS "PedidoDeVendaMesEntrega",
    '0' AS "PedidoDeVendaDiaEntrega",														--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVendaEntrega",
	'0' AS "PedidoDeVendaAno",
	'0' AS "PedidoDeVendaMes",
    '0' AS "PedidoDeVendaDia",																--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVenda",
	
	'0' AS "Pts em Kg",
	'0' AS "Pt em Kg",
	'0' AS "Pts em Kg Ped",
	'0' AS "Pt em Kg Ped"

FROM OITW AS T0
	LEFT JOIN OITM AS T1 ON T0."ItemCode" = T1."ItemCode"
WHERE T0."ItemCode" LIKE  'ME%'   
	AND T1."frozenFor" = 'N'
		
UNION

/*ESTOQUE SL*/

SELECT 
	T0."OnHand" AS "EmEstoque",
	T1."ItemCode" AS "ItemCode",
	T1."ItemName" AS "ItemName",
	T1."U_ITEM" AS "Item",
	COALESCE(T1."U_MARCA", 'S/ Marca Definida') AS "Marca",									--Como a Marca é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	T1."U_TIPO" AS "Tipo",
	T1."U_MODELOUTILIZADO" AS "Modelo Utilizado",
	T1."U_CORBALAO" AS "Cor Balão",
	COALESCE(T1."U_IMPRESSAO", 'S/ Impressao') AS "Impressao",								--Como a Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_CORIMPRESSAO", 'S/ Impressao') AS "Cor Impressao",						--Como a Cor da Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_APRESENTACAOEMB", 'S/ Embalagem Definida') AS "Apresentacao Embalagem",	--Como a Apresentação da Embalagem é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	COALESCE(T1."U_COMPLEMENTO", 'S/ Complemento') AS "Complemento",
	T0."IsCommited" AS "Confirmado",
	T0."OnOrder" AS "Pedido",
	T0."OnHand" + T0."OnOrder" - T0."IsCommited" AS "Disponivel",							--Na consulta original, no SQL SERVER, está definido que como Disponível irá mostrar o que está no estoque físico + o que está em Produção - o que está reservado nos Pedidos de Venda
	T0."WhsCode" AS "Deposito",
	T1."CodeBars" AS "Codigo de barras",

	'0' AS "PedidoDeVendaNumero",
	'0' AS "PedidoDeVendaQtd",
	'0' AS "PedidoDeVendaTotalLinha",
	'0' AS "PedidoDeVendaAnoEntrega",
	'0' AS "PedidoDeVendaMesEntrega",
    '0' AS "PedidoDeVendaDiaEntrega",														--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVendaEntrega",
	'0' AS "PedidoDeVendaAno",
	'0' AS "PedidoDeVendaMes",
    '0' AS "PedidoDeVendaDia",																--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVenda",
	
	'0' AS "Pts em Kg",
	'0' AS "Pt em Kg",
	'0' AS "Pts em Kg Ped",
	'0' AS "Pt em Kg Ped"

FROM OITW AS T0
	LEFT JOIN OITM AS T1 ON T0."ItemCode" = T1."ItemCode"
WHERE T0."ItemCode" LIKE  'SL%'   
	AND T1."frozenFor" = 'N'
	
UNION

/*ESTOQUE MS*/

SELECT 
	T0."OnHand" AS "EmEstoque",
	T1."ItemCode" AS "ItemCode",
	T1."ItemName" AS "ItemName",
	T1."U_ITEM" AS "Item",
	COALESCE(T1."U_MARCA", 'S/ Marca Definida') AS "Marca",									--Como a Marca é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	T1."U_TIPO" AS "Tipo",
	T1."U_MODELOUTILIZADO" AS "Modelo Utilizado",
	T1."U_CORBALAO" AS "Cor Balão",
	COALESCE(T1."U_IMPRESSAO", 'S/ Impressao') AS "Impressao",								--Como a Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_CORIMPRESSAO", 'S/ Impressao') AS "Cor Impressao",						--Como a Cor da Impressão é definida no Processo de Estampa, este campo ficará vazio nos Graneis
	COALESCE(T1."U_APRESENTACAOEMB", 'S/ Embalagem Definida') AS "Apresentacao Embalagem",	--Como a Apresentação da Embalagem é definida no Processo de Embalagem, este campo ficará vazio nos Graneis
	COALESCE(T1."U_COMPLEMENTO", 'S/ Complemento') AS "Complemento",
	T0."IsCommited" AS "Confirmado",
	T0."OnOrder" AS "Pedido",
	T0."OnHand" + T0."OnOrder" - T0."IsCommited" AS "Disponivel",							--Na consulta original, no SQL SERVER, está definido que como Disponível irá mostrar o que está no estoque físico + o que está em Produção - o que está reservado nos Pedidos de Venda
	T0."WhsCode" AS "Deposito",
	T1."CodeBars" AS "Codigo de barras",

	'0' AS "PedidoDeVendaNumero",
	'0' AS "PedidoDeVendaQtd",
	'0' AS "PedidoDeVendaTotalLinha",
	'0' AS "PedidoDeVendaAnoEntrega",
	'0' AS "PedidoDeVendaMesEntrega",
    '0' AS "PedidoDeVendaDiaEntrega",														--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVendaEntrega",
	'0' AS "PedidoDeVendaAno",
	'0' AS "PedidoDeVendaMes",
    '0' AS "PedidoDeVendaDia",																--Como não encontrei função "DAY" para extrair o dia, tive que usar a EXTRACT e selecionar DAY
	'0' AS "PedidoDeVenda",
	
	'0' AS "Pts em Kg",
	'0' AS "Pt em Kg",
	'0' AS "Pts em Kg Ped",
	'0' AS "Pt em Kg Ped"

FROM OITW AS T0
	LEFT JOIN OITM AS T1 ON T0."ItemCode" = T1."ItemCode"
WHERE T0."ItemCode" LIKE  'MS%'   
	AND T1."frozenFor" = 'N'