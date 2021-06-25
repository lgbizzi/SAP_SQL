/*          
--------------------------------------------------------------------------------       
  Boletos          
--------------------------------------------------------------------------------          
*/  
SELECT
	'Boleto' AS "Tipo Doc.",
	T4."ObjType" AS "ObjType",   
	IFNULL(T5."Serial",T6."Ref2") AS "Nota",
	T1."DocEntry" AS "Nº Doc",
	T5."DocEntry" AS "NotaDoc",
	TO_VARCHAR(T0."BoeNum") AS "Nº Boleto",
	CAST(T4."InstId" AS VARCHAR(2)) AS "Parcela",
	TO_DATE(IFNULL(T5."DocDate",T6."TaxDate")) AS "Emissão",
	TO_DATE(T0."DueDate") AS "Vencto.",
	'0' AS "Prorrogação",
	'' AS "Data Pagto.",
	DAYS_BETWEEN(TO_DATE(T0."DueDate"), TO_DATE(CURRENT_DATE, 'YYYY-MM-DD')) AS "DiasAVencer",
	'' AS "Dias Pagto.",
	T2."SlpCode" AS "Vendedor",
	REP."SlpName" AS "Representante",
	T0."CardCode" AS "Cód. Cliente",
	T0."CardName" AS "Nome Cliente",
	IFNULL(T4."SumApplied",T0."BoeSum") AS "Valor Doc.",
	'0' AS "Valor Pago",
	'0' AS "Desconto",
	
	IFNULL(T4."SumApplied" + 
				(T4."SumApplied" / 
				(SELECT 
					SUM(A0X."SumApplied") 
				FROM RCT2 A0X 
				WHERE A0X."DocNum" = T4."DocNum")
				* T1."NoDocSum")
			,T0."BoeSum") AS "Saldo",          
	
	IFNULL(T0."PayMethCod", '') AS "Portador",
	'' AS "Nº Bancario",
	
	CASE
		T0."DepositTyp"
		WHEN 'D'
		THEN 'Descontado'
		
		WHEN 'C'
		THEN 'Cobrança'
		
		ELSE ''
	END AS "Situacao",
	
	CASE
		T0."BoeStatus"
		WHEN 'G'
		THEN 'Gerado'
		
		WHEN 'D'
		THEN 'Depositado'
		
		WHEN 'P'
		THEN 'Pago'
		
		WHEN 'C'
		THEN 'Cancelado'
		
		ELSE ''
	END AS "Status",
	
	T2."PaymBlock" AS "Classif. Cliente",
	T2."CreditLine" AS "Limite Créd.",
	T0."Comments" AS "Obs.:",
	T2."City" AS "Cidade",
	T3."County" AS "Cód. Município",
	
	COALESCE(T0."BPLId", '-1') AS "BPLId",
	
	T0."Currency" AS "Currency",
	T6."TransId" AS "InstLCMTrans",
	T6."Line_ID" AS "LCMLineID",
	T2."Phone1" AS "Fone1",
	T2."Phone2" AS "Fone2"  
FROM OBOE T0          
	JOIN ORCT T1 ON T1."DocEntry" = T0."PmntNum"   /* Contas a receber */          
    JOIN OCRD T2 ON T2."CardCode" = T0."CardCode"  /* Informações do cliente (para pegar o país) */     
	JOIN CRD1 T3 ON T3."CardCode" = T2."CardCode"
					AND T3."Address" = T2."BillToDef" 
					AND T3."AdresType" = 'B'        
	LEFT JOIN RCT2 T4 ON T4."DocNum" = T0."PmntNum"
						AND T4."InvType" = '13'
						OR T4."InvType" = '30'         /* Somente contas a receber originadas de notas fiscais e LCM*/          
                 --and T4.InvoiceID = 0        
	LEFT JOIN OINV T5 ON T5."DocEntry" = T4."DocEntry" /* Nota Fiscal */
						AND T4."InvType" = '13' 
	LEFT JOIN JDT1 T6 ON 
						T6."TransType" = T4."InvType"
						AND IFNULL(T6."SourceID",T6."TransId") = T4."DocEntry" 
						AND IFNULL(T6."SourceLine",T6."Line_ID") = CASE 
																	T4."InvType"
																	WHEN '13' 
																	THEN T4."InstId" 
																	ELSE T4."DocLine"
																	END 
	LEFT JOIN OSLP AS REP ON T2."SlpCode" = REP."SlpCode"
WHERE T0."BoeStatus" IN ( 'D','G' )        
		AND T0."BoeType" = 'I'