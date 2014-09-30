DROP TABLE STAT04_FACILITY;

CREATE TABLE STAT04_FACILITY(
FACI_ID CHAR(10) PRIMARY KEY,
STAT_ID CHAR(8) ,
FACI_TYPE CHAR(1),
FACI_NAME NVARCHAR(100),
FACI_DESP NVARCHAR(200),
FACI_LOCL CHAR(1),
ESCA_DIRT CHAR(1),
WHEL_CAIR_ACES CHAR(1),
BABY_CAIR CHAR(1),
BABY_CHGN_TABL CHAR(1),
TOIL_FOR_OSTM CHAR(1),
REMARK NVARCHAR(500),
WHEL_CAIR CHAR(1)
);