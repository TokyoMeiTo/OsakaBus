DROP TABLE LINT04_ROUTE;

CREATE TABLE LINT04_ROUTE(
RUTE_ID CHAR(10) PRIMARY KEY,
START_STAT_ID CHAR(6),
START_STAT_NAME NVARCHAR(100),
TERM_STAT_ID CHAR(6),
TERM_STAT_NAME NVARCHAR(100)
);