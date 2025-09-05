

create table CUX.CUX_AE_HEADERS_ALL
(
  AE_HEADER_ID           NUMBER(15) not null,
  SET_OF_BOOKS_ID        NUMBER(15) not null,
  AE_CATEGORY            VARCHAR2(30) not null,
  AE_EVENT_TYPE          VARCHAR2(30) not null,
  PERIOD_NAME            VARCHAR2(15) not null,
  GL_DATE                DATE not null,
  TRANSFER_ERROR_CODE    VARCHAR2(30),
  TRANSFER_ERROR_MESSAGE VARCHAR2(2000),
  TRANSFER_FLAG          VARCHAR2(1) not null,
  DESCRIPTION            VARCHAR2(240),
  ORG_ID                 NUMBER(15) default to_number(decode(substrb(userenv('CLIENT_INFO'),1,1),' ',null,substrb(userenv('CLIENT_INFO'),1,10))),
  SOURCE_TABLE           VARCHAR2(30),
  SOURCE_ID              NUMBER,
  VALIDATED_BY           NUMBER,
  APPROVED_BY            NUMBER,
  ATTRIBUTE_CATEGORY     VARCHAR2(150),
  ATTRIBUTE1             VARCHAR2(150),
  ATTRIBUTE2             VARCHAR2(150),
  ATTRIBUTE3             VARCHAR2(150),
  ATTRIBUTE4             VARCHAR2(150),
  ATTRIBUTE5             VARCHAR2(150),
  ATTRIBUTE6             VARCHAR2(150),
  ATTRIBUTE7             VARCHAR2(150),
  ATTRIBUTE8             VARCHAR2(150),
  ATTRIBUTE9             VARCHAR2(150),
  ATTRIBUTE10            VARCHAR2(150),
  ATTRIBUTE11            VARCHAR2(150),
  ATTRIBUTE12            VARCHAR2(150),
  ATTRIBUTE13            VARCHAR2(150),
  ATTRIBUTE14            VARCHAR2(150),
  ATTRIBUTE15            VARCHAR2(150),
  LAST_UPDATE_DATE       DATE,
  LAST_UPDATED_BY        NUMBER,
  CREATION_DATE          DATE,
  CREATED_BY             NUMBER,
  LAST_UPDATE_LOGIN      NUMBER
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
comment on column CUX.CUX_AE_HEADERS_ALL.AE_EVENT_TYPE
  is '凭证事件类型';
-- Create/Recreate indexes 
create index CUX_AE_HEADERS_ALL_N1 on CUX.CUX_AE_HEADERS_ALL (PERIOD_NAME)
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
create index CUX_AE_HEADERS_ALL_N2 on CUX.CUX_AE_HEADERS_ALL (GL_DATE)
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
create index CUX_AE_HEADERS_ALL_N3 on CUX.CUX_AE_HEADERS_ALL (SOURCE_TABLE, SOURCE_ID)
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
create index CUX_AE_HEADERS_ALL_N4 on CUX.CUX_AE_HEADERS_ALL (PERIOD_NAME, ORG_ID)
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
create unique index CUX_AE_HEADERS_ALL_U1 on CUX.CUX_AE_HEADERS_ALL (AE_HEADER_ID)
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

  grant select, insert, update, delete, references, alter, index on CUX.CUX_AE_HEADERS_ALL to appsro with grant option;