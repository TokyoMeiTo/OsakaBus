DROP TABLE STAT03_COMERCIAL_INSIDE;

CREATE TABLE STAT03_COMERCIAL_INSIDE(
COME_INSI_ID CHAR(6) PRIMARY KEY,	
COME_INSI_NAME NVARCHAR(50) ,
COME_INSI_TYPE NVARCHAR(50) ,
COME_INSI_TAG NARCHAR(100),
COME_INSI_PRICE NCARCHAR(50),
COME_INSI_LOCA_CH NVARCHAR(200),
COME_INSI_LOCA_JP NVARCHAR(200),
COME_INSI_BISI_HOUR NVARCHAR(100),
COME_INSI_IMAGE CHAR(8),
FAVO_FLAG CHAR(1),
FAVO_TIME CHAR(14)
);