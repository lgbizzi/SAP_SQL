----/*        
----------------------------------------------------------------------------------          
--  --Duplicatas          
----------------------------------------------------------------------------------          
--*/          
SELECT 
	'NF' AS "Tipo Doc.",
	T0."ObjType" AS "ObjType",
	TO_VARCHAR(T0."Serial") AS "Nota",
	T0."DocNum" AS "Nº Doc",
	T0."DocEntry" AS "NotaDoc",
	'' AS "Nº Boleto",
	T1."InstlmntID" AS "Parcela",
	TO_DATE(T0."DocDate") AS "Emissão",
	TO_DATE(T1."DueDate") AS "Vencto.",
	'0' AS "Prorrogação",
	'' AS "Data Pagto.",
	DAYS_BETWEEN(TO_DATE(T1."DueDate"), TO_DATE(CURRENT_DATE, 'YYYY-MM-DD')) AS "DiasAVencer",
	'' AS "DiasPagto",
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
	
	COALESCE(T0."BPLId", '-1'),
	
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
        
UNION          
     
        
/*        
--------------------------------------------------------------------------------          
  Devoluções          
--------------------------------------------------------------------------------          
*/          
SELECT 
	'NF. Devolução' AS "Tipo Doc.",
	T0."ObjType" AS "ObjType",
	TO_VARCHAR(T0."Serial") AS "Nota",
	T0."DocNum" AS "Nº Doc",
	T0."DocEntry" AS "NotaDoc",
	'' AS "Nº Boleto",
	CAST(T1."InstlmntID" AS VARCHAR(2)) AS "Parcela",
	TO_DATE(T0."DocDate") AS "Emissão",
	TO_DATE(T1."DueDate") AS "Vencto.",
	'0' AS "Prorrogação",
	'' AS "Data Pagto.",
	DAYS_BETWEEN(TO_DATE(T1."DueDate"), TO_DATE(CURRENT_DATE, 'YYYY-MM-DD')) AS "DiasAVencer",
	'' AS "DiasPagto",
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
	
	'' AS "NºBancario",
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
    
        
UNION          
          
/*          
--------------------------------------------------------------------------------       
  Boletos          
--------------------------------------------------------------------------------          
*/  
SELECT
	'Boleto' AS "Tipo Doc.",
	T4."ObjType" AS "ObjType",   
	TO_VARCHAR(IFNULL(T5."Serial",T6."Ref2")) AS "Nota",
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
		
UNION

/*          
--------------------------------------------------------------------------------          
  LCM        
--------------------------------------------------------------------------------          
*/          
        
SELECT  
	'LCM' AS "Tipo Doc.",
	T1."ObjType" AS "ObjType",
	REPLACE(T1."Ref2", '/', '') AS "Nota",
	T1."Number" AS "Nº Doc",
	NULL AS "NotaDoc",
	NULL AS "Nº Boleto",
	'1' AS "Parcela",
	TO_DATE(T1."RefDate") AS "Emissao",
	TO_DATE(T0."DueDate") AS "Vencto.",
	'' AS "Prorrogação",
	'' AS "Data Pagto.",
	DAYS_BETWEEN(TO_DATE(T0."DueDate"), TO_DATE(CURRENT_DATE, 'YYYY-MM-DD')) AS "DiasAVencer",
	'' AS "Dias Pagto.",
	NULL AS "Vendedor",
	REP."SlpName" AS "Representante",
	T2."CardCode" AS "Cód. Cliente",
	T2."CardName" AS "Nome Cliente",
	(T0."Debit"-T0."Credit") AS "Valor Doc.",
	'0' AS "Valor Pago",
	'0' AS "Desconto",
	(T0."BalDueDeb" - T0."BalDueCred") AS "Saldo",
	'Carteira' AS "Portador",
	'' AS "Nº Bancario",
	'' AS "Situacao",
	'' AS "Status",
	T2."PaymBlock" AS "Classif. Cliente",
	T2."CreditLine" AS "Limite Créd.",
	IFNULL(T0."LineMemo",'') AS "Obs.:",
	T2."City" AS "Cidade",
	T3."County" AS "Cód. Município",
	
	COALESCE(T0."BPLId", '-1') AS "BPLId",
	
	'R$' AS "Currency",
	
	T0."TransId" AS "InstLCMTrans",
	T0."Line_ID" AS "LCMLineID",
	T2."Phone1" AS "Fone1",
	T2."Phone2" AS "Fone2"  
    
 FROM JDT1 T0          
    JOIN OJDT T1 ON T0."TransId" = T1."TransId"        
    JOIN OCRD T2 ON T0."ShortName" = T2."CardCode"        
					AND T2."CardType" = 'C'    
    JOIN CRD1 T3 ON T3."CardCode" = T2."CardCode"
					AND T3."Address" = T2."BillToDef" 
					AND T3."AdresType" = 'B'      
	LEFT JOIN OSLP AS REP ON T2."SlpCode" = REP."SlpCode"
         
WHERE 	(	(T0."TransType" <> '13'    
			AND T0."TransType" <> '203'    
			AND T0."TransType" <> '132'    
			AND T0."TransType" <> '-2'    
			AND T0."TransType" <> '24'  
			AND T0."TransType" <> '46'     
			AND T0."TransType" <> '14'   
			AND T0."TransType" <> '182'   
			)   
		OR  T0."BatchNum" > '0'   
		)   
    AND T0."ShortName" LIKE '%'   
    AND T0."Closed" = 'N'   
    AND T0."IntrnMatch" = '0'   
    AND (T0."Debit" <> '0' OR T0."Credit" <> '0')   
    AND (T0."SourceLine" <> '-14' OR T0."SourceLine" IS NULL)   
    AND (T0."BalDueCred" <> 0 OR  T0."BalDueDeb" <> 0)
    AND NOT EXISTS
		(SELECT 
			* 
		FROM OBOE A0          
			JOIN ORCT A1 ON A1."DocEntry" = A0."PmntNum"   /* Contas a receber */          
			JOIN RCT2 A4 ON A4."DocNum"   = A0."PmntNum"          
							AND A4."InvType"  = '30'         /* Somente contas a receber originadas de notas fiscais */          
							AND A4."DocEntry" = T0."TransId"  
							AND A4."DocLine" = T0."Line_ID"         
		WHERE A0."BoeStatus" IN ('D', 'G')        
				AND A0."BoeType" = 'I')
				
UNION

/*        
----------------------------------------------------------        
Pagamento por conta        
----------------------------------------------------------        
*/        
        
SELECT
	'Adiant' AS "TipoDoc",   
	T0."ObjType" AS "ObjType",
	NULL AS "Nota",
	T0."DocEntry" AS "Nº Doc",
	NULL AS "NotaDoc",
	NULL AS "Nº Boleto",        
	NULL AS "Parcela",
	T0."TaxDate" AS "Emissao",
	T0."DocDueDate" AS "Vencto.",
	NULL  AS "Prorrogação",
	T0."DocDate" AS "Data Pagto.",
	NULL AS "DiasAVencer",
	NULL AS "Dias Pagto.",	
	NULL AS "Vendedor",
	REP."SlpName" AS "Representante",
	T0."CardCode" AS "Cód. Cliente",          
	T0."CardName" AS "Nome Cliente",          
	(T0."NoDocSum"* -1) AS "Valor Doc.",          
	(T0."NoDocSum"* -1 + T0."OpenBal") AS "Valor Pago",
	NULL AS "Desconto",        
	(T0."OpenBal"*-1) AS "Saldo",
	
	CASE 
		WHEN T0."BoeSum"> '0' 
		THEN T0."PayMth"
     
		WHEN (T0."TrsfrSum")> '0' 
		THEN CONCAT('Transferencia -',TO_VARCHAR(T0."TrsfrAcct"))
     
		WHEN (T0."CashSum")>0 
		THEN 'Dinheiro'        
		
		WHEN (T0."CheckSum")>0 
		THEN 'Cheque'        
    END AS "Portador",
         
    NULL AS "Nº Bancario",
    'Pago' AS "Situacao",
    NULL AS "Status",
	
	T1."PaymBlock" AS "Classif. Cliente",
	T1."CreditLine" AS "Limite Créd.",
	IFNULL(T0."Comments" ,'') AS "Obs.:",
	T1."City" AS "Cidade",
	T2."County" AS "Cód. Município",
	
	COALESCE(T0."BPLId", '-1') AS "BPLId",
	
    T0."DocCurr" AS "Currency",  
    T3."TransId" AS "InstLCMTrans",  
    T3."Line_ID" AS "LCMLineID",  
	T1."Phone1" AS "Fone1",
	T1."Phone2" AS "Fone2"
     
 FROM ORCT T0          
	JOIN OCRD T1 ON T1."CardCode" = T0."CardCode" /* Informações do cliente (para pegar o país) */    
	JOIN CRD1 T2 on T2."CardCode" = T1."CardCode" 
		AND T2."Address" = T1."BillToDef"
		AND T2."AdresType" = 'B'            
    JOIN JDT1 T3 ON T3."TransId"  = T0."TransId"        
		AND T3."IntrnMatch" = '0'
		AND T3."Closed" = 'N' 
		AND IFNULL(T3."SourceLine",'-99') = '-99'      
	LEFT JOIN OSLP AS REP ON T1."SlpCode" = Rep."SlpCode"
WHERE T0."Canceled" = 'N'        
		AND T0."BoeStatus" IS NULL        
		AND T0."PayNoDoc" = 'Y'        
		AND T0."OpenBal" <> 0  
		AND T0."DocNum" NOT IN 
			(SELECT 
				"DocNum" 
			FROM RCT2 s0 
			WHERE 
				s0."DocNum" = T0."DocNum")
				
UNION

/*        
----------------------------------------------------------        
Pagamento por conta        
----------------------------------------------------------        
*/        
        
SELECT
	'Adiant' AS "TipoDoc",   
	T0."ObjType" AS "ObjType",
	NULL AS "Nota",
	T0."DocEntry" AS "Nº Doc",
	NULL AS "NotaDoc",
	NULL AS "Nº Boleto",        
	NULL AS "Parcela",
	T0."TaxDate" AS "Emissao",
	T0."DocDueDate" AS "Vencto.",
	NULL  AS "Prorrogação",
	T0."DocDate" AS "Data Pagto.",
	NULL AS "DiasAVencer",
	NULL AS "Dias Pagto.",	
	NULL AS "Vendedor",
	REP."SlpName" AS "Representante",
	T0."CardCode" AS "Cód. Cliente",          
	T0."CardName" AS "Nome Cliente",          
	(T0."NoDocSum"* -1) AS "Valor Doc.",          
	(T0."NoDocSum"* -1 + T0."OpenBal") AS "Valor Pago",
	NULL AS "Desconto",        
	(T0."OpenBal"*-1) AS "Saldo",
	
	CASE 
		WHEN T0."BoeSum"> '0' 
		THEN T0."PayMth"
     
		WHEN (T0."TrsfrSum")> '0' 
		THEN CONCAT('Transferencia -',TO_VARCHAR(T0."TrsfrAcct"))
     
		WHEN (T0."CashSum")>0 
		THEN 'Dinheiro'        
		
		WHEN (T0."CheckSum")>0 
		THEN 'Cheque'        
    END AS "Portador",
         
    NULL AS "Nº Bancario",
    'Pago' AS "Situacao",
    NULL AS "Status",
	
	T1."PaymBlock" AS "Classif. Cliente",
	T1."CreditLine" AS "Limite Créd.",
	IFNULL(T0."Comments" ,'') AS "Obs.:",
	T1."City" AS "Cidade",
	T2."County" AS "Cód. Município",
	
	COALESCE(T0."BPLId", '-1') AS "BPLId",
	
    T0."DocCurr" AS "Currency",  
    T3."TransId" AS "InstLCMTrans",  
    T3."Line_ID" AS "LCMLineID",  
	T1."Phone1" AS "Fone1",
	T1."Phone2" AS "Fone2"
     
 FROM ORCT T0          
	JOIN OCRD T1 ON T1."CardCode" = T0."CardCode" /* Informações do cliente (para pegar o país) */    
	JOIN CRD1 T2 on T2."CardCode" = T1."CardCode" 
		AND T2."Address" = T1."BillToDef"
		AND T2."AdresType" = 'B'            
    JOIN JDT1 T3 ON T3."TransId"  = T0."TransId"        
		AND T3."IntrnMatch" = '0'
		AND T3."Closed" = 'N' 
		AND IFNULL(T3."SourceLine",'-99') = '-99'      
	LEFT JOIN OSLP AS REP ON T1."SlpCode" = Rep."SlpCode"
WHERE T0."Canceled" = 'N'        
		AND T0."BoeStatus" IS NULL        
		AND T0."PayNoDoc" = 'Y'        
		AND T0."OpenBal" <> 0  
		AND T0."DocNum" NOT IN 
			(SELECT 
				"DocNum" 
			FROM RCT2 s0 
			WHERE 
				s0."DocNum" = T0."DocNum")
				
UNION

/*        
----------------------------------------------------------        
Cheques não depositados  
----------------------------------------------------------        
*/   
SELECT  
	'Cheque' AS "TipoDoc",
	T2."ObjType" AS "ObjType",
	REPLACE(T4."Serial", '/', '') AS "Nota",
	T0."CheckNum" AS "Nº Doc",
	T4."DocEntry" AS "NotaDoc",
	NULL AS "Nº Boleto",
	CAST(T3."InstId" AS VARCHAR(2)) AS "Parcela",
    TO_DATE(T0."RcptDate") AS "Emissão",                          
	TO_DATE(T0."CheckDate") AS "Vencto.",              
    NULL AS "Prorrogação",   
	TO_DATE(T0."RcptDate") AS "Data Pagto.",
	DAYS_BETWEEN(TO_DATE(T0."RcptDate"), TO_DATE(CURRENT_DATE, 'YYYY-MM-DD')) AS "DiasAVencer",    
	NULL AS "DiasPagto", 
	NULL AS "Vendedor",
	REP."SlpName" AS "Representante",
	T0."CardCode" AS "Cód. Cliente",
	T1."CardName" AS "Nome Cliente",
	IFNULL(T3."SumApplied",T0."CheckSum") AS "Valor Doc.",
	NULL AS "Valor Pago",
	NULL AS "Desconto",
	
	IFNULL(T3."SumApplied" + 
				(T3."SumApplied" / 
				(SELECT 
					SUM(A0X."SumApplied") 
				FROM RCT2 A0X
				WHERE A0X."DocNum" = T4."DocNum")
				* T2."NoDocSum")
			,T0."CheckSum") AS "Saldo",
	
	'Cheque' AS "Portador",
	NULL AS "Nº Bancario",
	'Não depositado' AS "Situacao",
	NULL AS "Status",
	T1."PaymBlock" AS "Classif. Cliente",
    T1."CreditLine" AS "Limite Créd.",
	T2."Comments" AS "Obs.:",
	T1."City" AS "Cidade",
	T5."County" AS "Cód. Município",
	
	COALESCE(T2."BPLId", '-1') AS "BPLId",
	
	T0."Currency" AS "Currency",
	T6."TransId" AS "InstLCMTrans",
	T6."Line_ID" AS "LCMLineID",
	T1."Phone1" AS "Fone1",
	T1."Phone2" AS "Fone2"
FROM OCHH T0   
	JOIN OCRD T1 ON T0."CardCode" = T1."CardCode"    
	JOIN ORCT T2 ON T0."RcptNum" = T2."DocNum"
	JOIN RCT2 T3 ON T2."DocNum" = T3."DocNum"
					AND T3."InvType" = '13'    /* Somente contas a receber originadas de notas fiscais */          
	LEFT JOIN OINV T4 ON T3."DocEntry" = T4."DocEntry"   
	JOIN CRD1 T5 ON T1."CardCode" = T5."CardCode"
					AND T5."Address" = T1."BillToDef"
					AND T5."AdresType" = 'B'    
	LEFT JOIN JDT1 T6 ON T3."InvType" = T6."TransType"  
					AND T3."DocEntry" = T6."SourceID"
					AND T3."InstId" = T6."SourceLine"
	LEFT JOIN OSLP as REP ON T1."SlpCode" = Rep."SlpCode"
WHERE T0."Deposited" <> 'C'        
	AND   T0."Canceled" = 'N'
	
UNION

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
