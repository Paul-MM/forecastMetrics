SELECT
Snpsht_Dt
, Sex_Dcd
, AVERAGE(Slry_Amt)
FROM EPGnrldmV.Fact_SAP_Snpsht_Dmgs
WHERE Emple_Grp_Prmncy_Sts_Nm = 'Ongoing'
AND Pblc_Srvc_Clsn_Cd NOT IN ('COMM', 'COM2', 'EXT')
AND Snpsht_Dt > '2007-06-30'
GROUP BY 1,2
ORDER BY 1,2
;