DROP TABLE LINT05_ROUTE_DETAIL;

CREATE TABLE LINT05_ROUTE_DETAIL(
RUTE_ID CHAR(10) ,
RUTE_GROUP_ID CHAR(2),
EXCH_STAT_ID CHAR(8) ,
EXCH_LINE_ID CHAR(6) ,
EXCH_DEST_ID CHAR(8) ,
EXCH_TYPE CHAR(1),
EXCH_SEQ INTEGER(4),
MOVE_TIME INTEGER(4),
WAIT_TIME INTEGER(4)
);