DROP TABLE LINT01_TRAIN_SCHEDULE;

CREATE TABLE LINT01_TRAIN_SCHEDULE(
LINE_ID	CHAR(6) ,
STAT_ID CHAR(8) ,
DIRT_STAT_ID CHAR(8) ,
DEST_STAT_ID CHAR(8) ,
SCHE_TYPE CHAR(1),
DEPA_TIME CHAR(4),
TRAN_TYPE CHAR(2),
FIRST_TRAIN_FLAG CHAR(1)
);

CREATE INDEX IDX_LINT01_TRAIN_SCHEDULC ON LINT01_TRAIN_SCHEDULE(STAT_ID,DIRT_STAT_ID);
