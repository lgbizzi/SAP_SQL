----/*        
----------------------------------------------------------------------------------          
--  --Duplicatas          
----------------------------------------------------------------------------------          
--*/          
SELECT 
	'NF' AS "Tipo Doc.",
	T0."ObjType" AS "ObjType",
	T0."Serial" AS "Nota",
	T0."DocNum" AS "Nº Doc",
	T0."DocEntry" AS "NotaDoc",
	'' AS "Nº Boleto",
	T1."InstlmntID" AS "Parcela",
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
	T1."InsTotal" AS "Valor Doc.",
	T1."PaidToDate" AS "Valor Pago",
	'' AS "Desconto",
	
	CASE 
		T1."PaidToDate"
		WHEN '0'
		THEN (T1."InsTotal" - T1."PaidToDate")
		ELSE T1."InsTotal"
	END AS "Saldo",   
	
	CASE 
		T0."PeyMethod"
		WHEN ''
		THEN 'Carteira'
		ELSE T0."PeyMethod"
	END AS "Portador",
	
	'' AS "Nº Bancario",
	
	CASE
		T1."Status"
		WHEN 'O'
		THEN 'Aberto'
		ELSE 'Cancelado/Devolvido'
	END AS "Situacao",
	
	T1."Status" AS "Status",
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
FROM OINV T0
	JOIN INV6 T1 ON T1."DocEntry" = T0."DocEntry" /* Parcelas */          
					AND T1."Status"   = 'O'          
    JOIN OCRD T2 ON T2."CardCode" = T0."CardCode" /* Informações do cliente (para pegar o país) */    
    JOIN CRD1 T3 ON T3."CardCode" = T2."CardCode" 
					AND T3."Address" = T2."BillToDef" 
					AND T3."AdresType" = 'B'    
	LEFT JOIN JDT1 T4 ON T1."ObjType" = T4."TransType"  
						AND T1."DocEntry" = T4."SourceID"  
						AND T1."InstlmntID" = T4."SourceLine"  
	LEFT JOIN OSLP AS REP ON T2."SlpCode" = Rep."SlpCode"
      
    WHERE NOT EXISTS (SELECT * FROM ORIN T6   
									JOIN RIN1 T7 ON T6."DocEntry" = T7."DocEntry"   
													AND T7."BaseType" = '13'   
								WHERE T7."BaseEntry" = T0."DocEntry"  
													AND T0."DocStatus" = 'C')      
	AND T1."InsTotal" <> '0'              
  
   -- Desconsidera as Notas que tiveram boleto depositado quando o flag  
   -- "utilizar método de lançamento alternativo" está marcado   
   AND NOT EXISTS (SELECT * FROM OBOE A0          
								JOIN ORCT A1 ON A1."DocEntry" = A0."PmntNum"   /* Contas a receber */          
								JOIN RCT2 A4 ON A4."DocNum"   = A0."PmntNum"          
												AND A4."InvType"  = '13'         /* Somente Contas a receber originadas de Notas fiscais */          
												AND A4."DocEntry" = T0."DocEntry"  
												AND A4."InstId" = T1."InstlmntID"         
WHERE A0."BoeStatus" in ('D', 'G')        
		AND A0."BoeType" = 'I')