SELECT
Snpsht_Dt AS HC_Mth
, COUNT(Tax_Ofc_Prsn_Hd_Cnt) AS HC
FROM epgnrldmv.fact_sap_snpsht_dmgs
WHERE Pblc_Srvc_Clsn_Cd NOT IN ('COMM', 'COM2')
AND Tax_Ofc_Posn_Descn <> 'EXT Child Support Agency'
AND Snpsht_Dt >= '2013-07-31'
GROUP BY 1
ORDER BY 1;