SELECT 
Snpsht_dt AS Sepn_Mth
, CASE
WHEN Action_Reason LIKE ANY ('%redundanc%','VR %','IVR %','Involuntary %','VR (Bona Fide)','VR (Non Bona Fide)', 'Inv Redundancy (Non Bona Fide)', 'Inv Redundancy (Bona Fide)') 
THEN 'Redundancy'
ELSE 'NaturalAttrition'
END AS Sepn_Reason
, COUNT(Tax_Ofc_Prsn_Hd_Cnt) AS HC
FROM eadppert.ubnkp_db_seps
WHERE Emple_Grp_Prmncy_Sts_Nm = 'Ongoing'
AND Pblc_Srvc_Clsn_Cd NOT IN ('COMM', 'COM', 'EXT')
AND Snpsht_dt >= '2007-08-31'
GROUP BY 1,2
ORDER BY 1,2;
