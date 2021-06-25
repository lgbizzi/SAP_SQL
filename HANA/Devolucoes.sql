/*        
--------------------------------------------------------------------------------          
  Devoluções          
--------------------------------------------------------------------------------          
*/          
SELECT 
	'NF. Devolução' AS "Tipo Doc.",
	T0."ObjType" AS "ObjType",
	T0."Serial" AS "Nota",
	T0."DocNum" AS "Nº Doc",
	T0."DocEntry" AS "NotaDoc",
	'' AS "Nº Boleto",
	CAST(T1."InstlmntID" AS VARCHAR(2)) AS "Parcela",
	TO_DATE(T0."DocDate") AS "Emissão",
	TO_DATE(T1."DueDate") AS "Vencto.",
	'0' AS "Prorrogação",
	'' AS "Data Pagto.",
	DAYS_BETWEEN(TO_DATE(T1."DueDate"), TO_DATE(CURRENT_DATE, 'YYYY-MM-DD')) AS "DiasAVencer",
	'' AS "Dias Pagto.",
	T0."SlpCode" AS "Vendedor",
	REP."SlpName" AS "Representante",
	T0."CardCode" AS "Cód. Cliente",
	T0."CardName" AS "Nome Cliente",
	(T1."InsTotal" * -1) AS "Valor Doc.",
	'0' AS "Valor Pago",
	'0' AS "Desconto",
	
	CASE
		T1."PaidToDate"
		WHEN '0'
		THEN (T1."InsTotal")*-1
		ELSE (T1."InsTotal"-T1."PaidToDate") * -1
	END AS "Saldo",
	      
	CASE
		T0."PeyMethod"
		WHEN ''
		THEN 'Carteira'
		ELSE T0."PeyMethod"
	END AS "Portador",
	
	'' AS "Nº Bancario",
	'Aberto' AS "Situacao",
	'' AS "Status",
	T2."PaymBlock" AS "Classif. Cliente",
	T2."CreditLine" AS "Limite Créd.",
	'' AS "Obs.:",
	T2."City" AS "Cidade",
	T3."County" AS "Cód. Município",
	
	COALESCE(T0."BPLId", '-1') AS "BPLId",
	
	T0."DocCur" AS "Currency",
	T4."TransId" AS "InstLCMTrans",
	T4."Line_ID" AS "LCMLineID",
	T2."Phone1" AS "Fone1",
	T2."Phone2" AS "Fone2"      
 FROM ORIN T0          
    JOIN RIN6 T1 on T1."DocEntry" = T0."DocEntry" /* Parcelas */          
                AND T1."Status"   = 'O'          
    JOIN OCRD T2 on T2."CardCode" = T0."CardCode" /* Informações do cliente (para pegar o país) */      
    JOIN CRD1 T3 on T3."CardCode" = T2."CardCode" 
				AND T3."Address" = T2."BillToDef" 
				AND T3."AdresType" = 'B'            
	LEFT JOIN JDT1 T4 ON T1."ObjType" = T4."TransType"  
				AND T1."DocEntry" = T4."SourceID"  
				AND T1."InstlmntID" = T4."SourceLine"
	LEFT JOIN OSLP AS REP ON T2."SlpCode" = REP."SlpCode"