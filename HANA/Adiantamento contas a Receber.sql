/*
--------------------------------------------------------------------------------      
Adiantamento contas a Receber "ODPI"--    
--------------------------------------------------------------------------------      
*/  
SELECT 
	'Adiantamento' AS "TipoDoc",
    T0."ObjType" AS "ObjType",
    REPLACE(T0."Serial", '/', '') AS "Nota",     
    T0."DocNum" AS "Nº Doc",
	T0."DocEntry" AS "NotaDoc",    
    NULL AS "Nº Boleto",
	CAST(T1."InstlmntID" AS VARCHAR(2)) AS "Parcela",
	TO_DATE(T0."DocDate") AS "Emissão",
	TO_DATE(T1."DueDate") AS "Vencto.",
	'0' AS "Prorrogação",
	NULL AS "Data Pagto.",
	DAYS_BETWEEN(TO_DATE(T1."DueDate"), TO_DATE(CURRENT_DATE, 'YYYY-MM-DD')) AS "DiasAVencer",
    NULL AS "Dias Pagto.",
	T0."SlpCode" AS "Vendedor",
	REP."SlpName" AS "Representante",
	T0."CardCode" AS "Cód. Cliente",
	T0."CardName" AS "Nome Cliente",
	T1."InsTotal" AS "Valor Doc.", 
    T1."PaidToDate" AS "Valor Pago",
	'0' AS "Desconto",
	
	CASE
		T1."PaidToDate"
		WHEN '0'
		THEN T1."InsTotal"
		ELSE (T1."InsTotal" - T1."PaidToDate")
	END AS "Saldo",
	
	CASE
		T0."PeyMethod"
		WHEN '0'
		THEN T0."PeyMethod"
		ELSE 'Carteira'
	END AS "Portador",
	
	NULL AS "Nº Bancario",
	
	CASE
		T1."Status"
		WHEN 'O'
		THEN 'Aberto'
		ELSE 'Cancelado/Devolvido'
	END AS "Situacao",
	
	T1."Status" AS "Status",
	NULL AS "Classif. Cliente",
	'0' AS "Limite Créd.",
	NULL AS "Obs.:",
	NULL AS "Cidade",
	NULL AS "Cód. Município",
	
	COALESCE(T0."BPLId", '-1') AS "BPLId",
	
	T0."DocCur" AS "Currency",
	
	T2."TransId" AS "InstLCMTrans",
	T2."Line_ID" AS "LCMLineID",
	T3."Phone1" AS "Fone1",
	T3."Phone2" AS "Fone2"
FROM ODPI T0      
	JOIN DPI6 T1  ON  T1."DocEntry" = T0."DocEntry"
	LEFT JOIN JDT1 T2 ON T1."ObjType" = T2."TransType"
						AND T1."DocEntry" = T2."SourceID"
						AND T1."InstlmntID" = T2."SourceLine"
	LEFT JOIN OCRD T3 ON T3."CardCode" = T0."CardCode" /* Informações do cliente (para pegar o país) */  
	LEFT JOIN OSLP AS REP ON T3."SlpCode" = REP."SlpCode" 
WHERE T0."CardCode" LIKE '%'   
		AND T1."TotalBlck" != T1."InsTotal"   
		AND T1."Status" = 'O'