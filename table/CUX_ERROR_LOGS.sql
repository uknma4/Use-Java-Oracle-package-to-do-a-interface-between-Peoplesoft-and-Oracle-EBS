-- Create table
create table CUX.CUX_ERROR_LOGS
(
  LOG_ID             NUMBER,
  FUNCTION_NAME      VARCHAR2(100),
  ERROR_MESSAGE      VARCHAR2(2000),
  ATTRIBUTE_CATEGORY VARCHAR2(150),
  ATTRIBUTE1         VARCHAR2(150),
  ATTRIBUTE2         VARCHAR2(150),
  ATTRIBUTE3         VARCHAR2(150),
  ATTRIBUTE4         VARCHAR2(150),
  ATTRIBUTE5         VARCHAR2(150),
  ATTRIBUTE6         VARCHAR2(150),
  ATTRIBUTE7         VARCHAR2(150),
  ATTRIBUTE8         VARCHAR2(150),
  ATTRIBUTE9         VARCHAR2(150),
  ATTRIBUTE10        VARCHAR2(150),
  ATTRIBUTE11        VARCHAR2(150),
  ATTRIBUTE12        VARCHAR2(150),
  ATTRIBUTE13        VARCHAR2(150),
  ATTRIBUTE14        VARCHAR2(150),
  ATTRIBUTE15        VARCHAR2(150),
  ATTRIBUTE16        VARCHAR2(150),
  ATTRIBUTE17        VARCHAR2(150),
  ATTRIBUTE18        VARCHAR2(150),
  ATTRIBUTE19        VARCHAR2(150),
  ATTRIBUTE20        VARCHAR2(150),
  ATTRIBUTE21        VARCHAR2(150),
  ATTRIBUTE22        VARCHAR2(150),
  ATTRIBUTE23        VARCHAR2(150),
  ATTRIBUTE24        VARCHAR2(150),
  ATTRIBUTE25        VARCHAR2(150),
  ATTRIBUTE26        VARCHAR2(150),
  ATTRIBUTE27        VARCHAR2(150),
  ATTRIBUTE28        VARCHAR2(150),
  ATTRIBUTE29        VARCHAR2(150),
  ATTRIBUTE30        VARCHAR2(150),
  CREATION_DATE      DATE,
  CREATED_BY         NUMBER,
  LAST_UPDATE_DATE   DATE,
  LAST_UPDATED_BY    NUMBER,
  LAST_UPDATE_LOGIN  NUMBER
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
create index CUX_ERROR_LOGS_N1 on CUX.CUX_ERROR_LOGS (FUNCTION_NAME)
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
create unique index CUX_ERROR_LOGS_U1 on CUX.CUX_ERROR_LOGS (LOG_ID)
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

  grant select, insert, update, delete, references, alter, index on CUX.CUX_ERROR_LOGS to appsro with grant option;