-- Create table
create table CUX.CUX_AE_LINES_ALL
(
  AE_LINE_ID               NUMBER(15) not null,
  AE_HEADER_ID             NUMBER(15) not null,
  AE_LINE_NUMBER           NUMBER(15) not null,
  AE_LINE_TYPE_CODE        VARCHAR2(30) not null,
  AE_LINE_EVENT_TYPE       VARCHAR2(30) not null,
  CODE_COMBINATION_ID      NUMBER(15),
  CURRENCY_CODE            VARCHAR2(15) not null,
  CURRENCY_CONVERSION_TYPE VARCHAR2(30),
  CURRENCY_CONVERSION_DATE DATE,
  CURRENCY_CONVERSION_RATE NUMBER,
  ENTERED_DR               NUMBER,
  ENTERED_CR               NUMBER,
  ACCOUNTED_DR             NUMBER,
  ACCOUNTED_CR             NUMBER,
  SOURCE_TABLE             VARCHAR2(30) not null,
  SOURCE_ID                NUMBER not null,
  DESCRIPTION              VARCHAR2(240),
  ACCOUNTING_ERROR_CODE    VARCHAR2(30),
  TRANSFER_ERROR_CODE      VARCHAR2(30),
  TRANSFER_FLAG            VARCHAR2(1),
  VOUCHER_NUMBER           VARCHAR2(30),
  ORG_ID                   NUMBER(15) default to_number(decode(substrb(userenv('CLIENT_INFO'),1,1),' ',null,substrb(userenv('CLIENT_INFO'),1,10))),
  RETURN_SOURCE_TABLE      VARCHAR2(100),
  RETURN_SOURCE_ID         NUMBER,
  RETURN_SOURCE_NUMBER     NUMBER,
  ATTRIBUTE_CATEGORY       VARCHAR2(150),
  ATTRIBUTE1               VARCHAR2(150),
  ATTRIBUTE2               VARCHAR2(150),
  ATTRIBUTE3               VARCHAR2(150),
  ATTRIBUTE4               VARCHAR2(150),
  ATTRIBUTE5               VARCHAR2(150),
  ATTRIBUTE6               VARCHAR2(150),
  ATTRIBUTE7               VARCHAR2(150),
  ATTRIBUTE8               VARCHAR2(150),
  ATTRIBUTE9               VARCHAR2(150),
  ATTRIBUTE10              VARCHAR2(150),
  ATTRIBUTE11              VARCHAR2(150),
  ATTRIBUTE12              VARCHAR2(150),
  ATTRIBUTE13              VARCHAR2(150),
  ATTRIBUTE14              VARCHAR2(150),
  ATTRIBUTE15              VARCHAR2(150),
  LAST_UPDATE_DATE         DATE,
  LAST_UPDATED_BY          NUMBER,
  CREATION_DATE            DATE,
  CREATED_BY               NUMBER,
  LAST_UPDATE_LOGIN        NUMBER,
  REFERENCE1               VARCHAR2(240),
  REFERENCE2               VARCHAR2(240),
  REFERENCE3               VARCHAR2(240),
  REFERENCE4               VARCHAR2(240),
  REFERENCE5               VARCHAR2(240),
  REFERENCE6               VARCHAR2(240),
  REFERENCE7               VARCHAR2(240),
  REFERENCE8               VARCHAR2(240),
  REFERENCE9               VARCHAR2(240),
  REFERENCE10              VARCHAR2(240)
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
create index CUX_AE_LINES_ALL_N1 on CUX.CUX_AE_LINES_ALL (CODE_COMBINATION_ID)
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
create index CUX_AE_LINES_ALL_N2 on CUX.CUX_AE_LINES_ALL (SOURCE_TABLE, SOURCE_ID)
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
create index CUX_AE_LINES_ALL_N3 on CUX.CUX_AE_LINES_ALL (RETURN_SOURCE_TABLE, RETURN_SOURCE_ID, RETURN_SOURCE_NUMBER)
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
create unique index CUX_AE_LINES_ALL_U1 on CUX.CUX_AE_LINES_ALL (AE_LINE_ID)
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
create unique index CUX_AE_LINES_ALL_U2 on CUX.CUX_AE_LINES_ALL (AE_HEADER_ID, AE_LINE_NUMBER)
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

  grant select, insert, update, delete, references, alter, index on CUX.CUX_AE_LINES_ALL to appsro with grant option;