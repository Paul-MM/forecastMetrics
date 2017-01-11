Select
Snpsht_dt 
, SUM(Pd_Full_Tm_Eqvlnt_Pct) As Measure
From epgnrldmv.fact_sap_snpsht_dmgs
Where Emple_Grp_Prmncy_Sts_Nm = 'Casual'
AND Snpsht_dt > '2014-02-28'
Order by 1
Group by 1; 