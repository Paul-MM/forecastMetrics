Select
Snpsht_dt 
, COUNT(Tax_Ofc_Prsn_User_Id) As Headcount
From epgnrldmv.fact_sap_snpsht_dmgs
Where Emple_Grp_Prmncy_Sts_Nm = 'Ongoing'
AND Pblc_Srvc_Clsn_Cd NOT IN ('COMM', 'COM2')
AND Snpsht_dt > '2007-06-30'
Order by 1
Group by 1; 
