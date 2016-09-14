SELECT
Snpsht_Dt AS HC_Mth
, COUNT(Tax_Ofc_Prsn_Hd_Cnt) AS HC
FROM epgnrldmv.fact_sap_snpsht_dmgs
WHERE Emple_Grp_Prmncy_Sts_Nm = 'Ongoing'
AND Pblc_Srvc_Clsn_Cd NOT IN ('COMM', 'COM2', 'EXT')
AND Snpsht_Dt >= '2007-07-31'
GROUP BY 1
ORDER BY 1;
