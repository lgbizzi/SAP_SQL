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