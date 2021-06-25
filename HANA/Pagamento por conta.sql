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