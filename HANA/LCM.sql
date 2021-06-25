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