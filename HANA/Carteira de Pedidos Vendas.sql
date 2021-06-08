-- Carteira de Pedidos

SELECT 
	T0."Confirmed",																	--Mostra se o pedido foi confirmado
	T1."SlpName",																	--Nome do Representante
	T1."SlpCode",																	--Código do Representante
	T0."DocNum", 																	--Nº do Pedido
	T0."NumAtCard",																	--Nº de referência do cliente
	T0."ImportEnt" as "Pedido", 
	T2."State",																		--Estado
	T0."DocDate", 																	--Data de Lançamento do Pedido
	T0."DocDueDate", 																--Data de vencimento (entrega prevista)
	T0."CardCode", 																	--Código do cliente
	T0."CardName", 																	--Nome do cliente
	 T0."Comments",																	--Observações
	(T0."DocTotal"-T0."VatSum") -(T0."PaidToDate"-T0."VatPaid") as  "Saldo",		--Cálculo do saldo em aberto do pedido
	T0."DocTotal" -T0."VatSum" as  "TotalDoc"										--Total do pedido
FROM ORDR T0																		--Tabela do pedido
	JOIN OSLP T1 ON T0."SlpCode" =T1."SlpCode" 										--Tabela dos cadastros de Representantes
	JOIN RDR12 T2 ON T0."DocEntry" = T2."DocEntry"									--Tabela da guia de Endereços do pedido
WHERE 
	T0."DocStatus" = 'O'															--Pedido está aberto
  AND T0."DocDueDate" >= '[%0]'														--E Data de Vencimento está entre a data 1
  AND T0."DocDueDate" <= '[%1]'														--E a ata 2
ORDER BY T1."SlpName"																--Ordenar por Representante