-- Create table
create table CUX.CUX_GL_IMPORT_LINES_ALL
(
  ledger_id             NUMBER,
  currency_code         VARCHAR2(20),
  user_je_category_name VARCHAR2(100),
  user_je_source_name   VARCHAR2(100),
  gl_date               DATE,
  if_expense_subject    VARCHAR2(20),
  expense_desc          VARCHAR2(50),
  collect               VARCHAR2(250),
  ccid_segment1         NUMBER,
  ps_segment1           VARCHAR2(100),
  ccid_segment2         VARCHAR2(100),
  ps_segment2           VARCHAR2(100),
  ccid_segment3         VARCHAR2(100),
  ps_segment3           VARCHAR2(100),
  ccid_segment4         VARCHAR2(100),
  ccid_segment5         VARCHAR2(100),
  ccid_segment6         VARCHAR2(100),
  ccid_segment7         VARCHAR2(100),
  ccid_segment8         VARCHAR2(100),
  ccid_segment9         VARCHAR2(100),
  ccid_segment10        VARCHAR2(100),
  entered_dr            NUMBER,
  entered_cr            NUMBER,
  accounted_dr          NUMBER,
  accounted_cr          NUMBER,
  period_name           VARCHAR2(50),
  reverse_process       VARCHAR2(20),
  city_no               VARCHAR2(80),
  attribute1            VARCHAR2(150),
  attribute2            VARCHAR2(150),
  attribute3            VARCHAR2(150),
  attribute4            VARCHAR2(150),
  attribute5            VARCHAR2(150),
  attribute6            VARCHAR2(150),
  attribute7            VARCHAR2(150),
  attribute8            VARCHAR2(150),
  attribute9            VARCHAR2(150),
  attribute10           VARCHAR2(150),
  attribute11           VARCHAR2(150),
  attribute12           VARCHAR2(150),
  attribute13           VARCHAR2(150),
  attribute14           VARCHAR2(150),
  attribute15           VARCHAR2(150),
  last_update_date      DATE,
  last_updated_by       NUMBER,
  creation_date         DATE,
  created_by            NUMBER,
  last_update_login     NUMBER,
  status                VARCHAR2(50),
  req_id                NUMBER,
  msg                   VARCHAR2(2000),
  request_id            NUMBER,
  org_id                NUMBER,
  source_code           VARCHAR2(60),
  line_id               NUMBER
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
-- Add comments to the columns 
comment on column CUX.CUX_GL_IMPORT_LINES_ALL.req_id
  is '每一批准备要导入的组ID';
comment on column CUX.CUX_GL_IMPORT_LINES_ALL.request_id
  is '导入数据的请求ID';
-- Create/Recreate indexes 
create index CUX_GL_IMPORT_TMP_N1 on CUX.CUX_GL_IMPORT_LINES_ALL (REQUEST_ID)
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
create index CUX_GL_IMPORT_TMP_N2 on CUX.CUX_GL_IMPORT_LINES_ALL (REQ_ID)
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
create index CUX_GL_IMPORT_TMP_N3 on CUX.CUX_GL_IMPORT_LINES_ALL (PERIOD_NAME)
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
create index CUX_GL_IMPORT_TMP_N4 on CUX.CUX_GL_IMPORT_LINES_ALL (ORG_ID)
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
  grant select, insert, update, delete, references, alter, index on CUX.CUX_GL_IMPORT_LINES_ALL to appsro with grant option;
