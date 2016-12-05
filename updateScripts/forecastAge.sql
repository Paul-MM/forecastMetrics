SELECT
Snpsht_Dt
, AVERAGE(TaxOfcPrsnDcmlAgAtExtrctNum) As Measure
FROM EPGnrldmV.Fact_SAP_Snpsht_Dmgs
WHERE Emple_Grp_Prmncy_Sts_Nm = 'Ongoing'
AND Pblc_Srvc_Clsn_Cd NOT IN ('COM2', 'COMM', 'EXT')
AND Snpsht_Dt > '2007-07-01'
GROUP BY 1
ORDER BY 1
;