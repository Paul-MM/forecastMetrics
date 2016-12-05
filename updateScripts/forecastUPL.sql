SEL A.snpsht_dt
,A.R12
FROM
(
  SEL A.snpsht_dt
  ,ZEROIFNULL(SUM(A.ab_cat_cnt_UPL)) AS UPL
  ,ZEROIFNULL(SUM(A.full_tm_Eqvlnt_pct)) AS FTE
  ,CAST(CAST( UPL AS DECIMAL(14,6))/CAST(FTE AS DECIMAL(14,6)) AS DECIMAL (14,6)) AS UPL_RATE
  ,SUM(UPL_RATE) OVER(ORDER BY A.snpsht_dt DESC ROWS BETWEEN CURRENT ROW AND 11 FOLLOWING) AS R12
  ,CASE WHEN RANK() OVER(
  ORDER BY a.snpsht_dt
  RESET WHEN MIN(a.snpsht_dt) OVER(ORDER BY a.snpsht_dt DESC ROWS BETWEEN CURRENT ROW AND 11 FOLLOWING)
  = ADD_MONTHS((CAST(A.snpsht_dt AS DATE) - EXTRACT(DAY FROM A.snpsht_dt) +1),-10)-1
  ) = 1 AND 
  ADD_MONTHS((CAST(A.snpsht_dt AS DATE) - EXTRACT(DAY FROM A.snpsht_dt) +1),-10)-1 
  = MIN(a.snpsht_dt) OVER(ORDER BY a.snpsht_dt DESC ROWS BETWEEN CURRENT ROW AND 11 FOLLOWING)
  THEN 1 ELSE 0
  END AS R12_INCL
  FROM
  (
  SEL A.AGS
  , A.YEAR_DISP
  ,A.Month_End_Dt
  ,A.ab_cat_cnt_UPL
  ,b.Tax_Ofc_Org_Unt_SAP_BSL_Cd
  ,b.Tax_Ofc_SubPln_Cd
  ,b.Emple_Grp_Prmncy_Sts_Nm
  ,b.Full_Tm_Eqvlnt_Pct
  ,b.Tax_Ofc_Prsn_Hd_Cnt
  ,CASE WHEN b.Posn_Locn_Cd IS NULL THEN 'UNK'
  WHEN b.Posn_Locn_Cd IN ('WA/SA', 'VIC/TAS', 'ACT/NSW') THEN 'UNK' 
  WHEN b.Posn_Locn_Cd = 'MAR' THEN 'MRO'
  --WHEN b.Posn_Locn_Cd IN ('CAS', 'LAT', 'MEL', 'QUE', 'WTC') THEN 'MEL'
  WHEN b.Ausn_Stt_Cd = 'WA' THEN 'PER'
  ELSE b.Posn_Locn_Cd END AS Posn_Locn_Cd
  ,CASE WHEN b.Ausn_Stt_Cd IS NULL THEN 'UNK' 
  WHEN b.Ausn_Stt_Cd IN ('WA/SA', 'VIC/TAS', 'ACT/NSW') THEN 'UNK' 
  WHEN B.Ausn_Stt_Cd = 'NSW' AND b.Posn_Locn_Cd = 'MKY' THEN 'QLD'
  ELSE b.Ausn_Stt_Cd END AS Ausn_Stt_Cd
  ,B.SNPSHT_DT
  FROM eadppert.UBNKP_leave a
  INNER JOIN EPGnrlDMV.Fact_SAP_Snpsht_Dmgs B
  ON A.AGS = B.Tax_Ofc_Prsn_Pers_Num
  AND A.Month_End_Dt = B.Snpsht_dt
  WHERE B.Emple_grp_prmncy_sts_nm IN ('ongoing')
  
  ) A
  GROUP BY 1
) A
  WHERE R12_INCL = 1
  ORDER BY 1
  ;
  