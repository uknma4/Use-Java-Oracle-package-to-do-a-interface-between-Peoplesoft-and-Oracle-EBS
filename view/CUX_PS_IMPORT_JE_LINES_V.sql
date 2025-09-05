CREATE OR REPLACE VIEW CUX_PS_IMPORT_JE_LINES_V AS
SELECT gcc.code_combination_id ccid,
       (t.ccid_segment1 || '.' || t.ccid_segment2 || '.' || t.ccid_segment3 || '.' ||
       t.ccid_segment4 || '.' || t.ccid_segment5 || '.' || t.ccid_segment6 || '.' ||
       t.ccid_segment7 || '.' || t.ccid_segment8 || '.' || t.ccid_segment9 || '.' ||
       t.ccid_segment10) subject_combination,
       t."REQ_ID",
       t."PERIOD_NAME",
       t."ORG_ID",
       t.city_no,
       t."USER_JE_CATEGORY_NAME",
       t."CCID_SEGMENT1",
       t."CCID_SEGMENT2",
       t."PS_SEGMENT2",
       t."CCID_SEGMENT3",
       t."CCID_SEGMENT4",
       t."CCID_SEGMENT5",
       t."CCID_SEGMENT6",
       t."CCID_SEGMENT7",
       t."CCID_SEGMENT8",
       t."CCID_SEGMENT9",
       t."CCID_SEGMENT10",
       t."ENTERED_DR",
       t."ENTERED_CR"
  FROM (SELECT req_id,
               period_name,
               org_id,
               city_no,
               user_je_category_name,
               ccid_segment1,
               ccid_segment2,
               ps_segment2,
               ccid_segment3,
               ccid_segment4,
               ccid_segment5,
               ccid_segment6,
               ccid_segment7,
               ccid_segment8,
               ccid_segment9,
               ccid_segment10,
               SUM(trunc(entered_dr, 2)) entered_dr,
               SUM(trunc(entered_cr, 2)) entered_cr
          FROM (SELECT a.req_id,
                       a.period_name,
                       a.org_id,
                       a.city_no,
                       a.user_je_category_name,
                       a.ccid_segment1,
                       a.ccid_segment2,
                       a.ps_segment2,
                       a.ccid_segment3,
                       a.ccid_segment4,
                       a.ccid_segment5,
                       a.ccid_segment6,
                       a.ccid_segment7,
                       a.ccid_segment8,
                       a.ccid_segment9,
                       a.ccid_segment10,
                       SUM(trunc(a.entered_dr, 2)) entered_dr,
                       SUM(trunc(a.entered_cr, 2)) entered_cr
                  FROM cux.cux_gl_import_lines_all a
                --WHERE a.req_id = p_req_id
                -- AND a.org_id = p_org_id
                --   AND a.period_name =p_period_name
                --  AND a.user_je_category_name
                 WHERE  a.status IN ('V') and a.reverse_process = 0
                 GROUP BY a.req_id,
                          a.period_name,
                          a.org_id,
                          a.city_no,
                          a.user_je_category_name,
                          a.ccid_segment1,
                          a.ccid_segment2,
                          a.ps_segment2,
                          a.ccid_segment3,
                          a.ccid_segment4,
                          a.ccid_segment5,
                          a.ccid_segment6,
                          a.ccid_segment7,
                          a.ccid_segment8,
                          a.ccid_segment9,
                          a.ccid_segment10
               UNION ALL
                SELECT a.req_id,
                       a.period_name,
                       a.org_id,
                       a.city_no,
                       a.user_je_category_name,
                       a.ccid_segment1,
                       a.ccid_segment2,
                       a.ps_segment2,
                       a.ccid_segment3,
                       a.ccid_segment4,
                       a.ccid_segment5,
                       a.ccid_segment6,
                       a.ccid_segment7,
                       a.ccid_segment8,
                       a.ccid_segment9,
                       a.ccid_segment10,
          ( sum(trunc(entered_cr,2)))entered_dr,--      (0 - sum( trunc((case when (a.entered_cr)<>0  then (entered_dr) else 0 end),2) ))entered_dr,
           ( sum(trunc(entered_dr,2)))entered_cr  -- (0 - sum( trunc((case when (a.entered_dr)<>0  then (entered_cr) else 0 end ),2) ))entered_cr
                  FROM cux.cux_gl_import_lines_all a
                --WHERE a.req_id = p_req_id
                -- AND a.org_id = p_org_id
                --   AND a.period_name =p_period_name
                --  AND a.user_je_category_name
                 WHERE a.status IN ('V') AND
                    a.reverse_process = 1

                 GROUP BY a.req_id,
                          a.period_name,
                          a.org_id,
                          a.city_no,
                          a.user_je_category_name,
                          a.ccid_segment1,
                          a.ccid_segment2,
                          a.ps_segment2,
                          a.ccid_segment3,
                          a.ccid_segment4,
                          a.ccid_segment5,
                          a.ccid_segment6,
                          a.ccid_segment7,
                          a.ccid_segment8,
                          a.ccid_segment9,
                          a.ccid_segment10)
         GROUP BY req_id,
                  period_name,
                  org_id,
                  city_no,
                  user_je_category_name,
                  ccid_segment1,
                  ccid_segment2,
                  ps_segment2,
                  ccid_segment3,
                  ccid_segment4,
                  ccid_segment5,
                  ccid_segment6,
                  ccid_segment7,
                  ccid_segment8,
                  ccid_segment9,
                  ccid_segment10) t,
       gl_code_combinations_kfv gcc
 WHERE gcc.concatenated_segments =
       t.ccid_segment1 || '.' || t.ccid_segment2 || '.' || t.ccid_segment3 || '.' ||
       t.ccid_segment4 || '.' || t.ccid_segment5 || '.' || t.ccid_segment6 || '.' ||
       t.ccid_segment7 || '.' || t.ccid_segment8 || '.' || t.ccid_segment9 || '.' ||
       t.ccid_segment10 and (nvl(t.entered_dr,0)!=0 or nvl(t.entered_cr,0)!=0)
;
