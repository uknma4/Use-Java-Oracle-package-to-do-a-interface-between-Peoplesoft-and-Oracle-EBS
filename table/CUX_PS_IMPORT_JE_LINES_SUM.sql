-- Create table
create table CUX.CUX_PS_IMPORT_JE_LINES_SUM
(
  header_id             NUMBER,
  ccid                  NUMBER(15) not null,
  subject_combination   VARCHAR2(949),
  req_id                NUMBER,
  period_name           VARCHAR2(50),
  org_id                NUMBER,
  city_no               VARCHAR2(80),
  user_je_category_name VARCHAR2(100),
  ccid_segment1         NUMBER,
  ccid_segment2         VARCHAR2(100),
  ps_segment2           VARCHAR2(100),
  ccid_segment3         VARCHAR2(100),
  ccid_segment4         VARCHAR2(100),
  ccid_segment5         VARCHAR2(100),
  ccid_segment6         VARCHAR2(100),
  ccid_segment7         VARCHAR2(100),
  ccid_segment8         VARCHAR2(100),
  ccid_segment9         VARCHAR2(100),
  ccid_segment10        VARCHAR2(100),
  entered_dr            NUMBER,
  entered_cr            NUMBER,
  je_header_id          NUMBER,
  je_lines_id           NUMBER,
  created_by            NUMBER,
  created_date          DATE,
  updated_by            NUMBER,
  updated_date          DATE,
  last_login            NUMBER,
  attribute1            VARCHAR2(150),
  attribute2            VARCHAR2(150),
  attribute3            VARCHAR2(150),
  attribute4            VARCHAR2(150)
)
tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
-- Create/Recreate indexes 
create index CUX.UNIQ1 on CUX.CUX_PS_IMPORT_JE_LINES_SUM (REQ_ID)
  tablespace APPS_TS_TX_DATA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
    pctincrease 0
  );
  grant select, insert, update, delete, references, alter, index on CUX.CUX_PS_IMPORT_JE_LINES_SUM to appsro with grant option;
