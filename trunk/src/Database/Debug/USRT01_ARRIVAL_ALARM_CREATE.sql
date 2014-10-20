DROP TABLE USRT01_ARRIVAL_ALARM;

CREATE TABLE USRT01_ARRIVAL_ALARM(
ARRI_ALAM_ID CHAR(5) PRIMARY KEY,
LINE_FROM_ID CHAR(6) NOT NULL,
STAT_FROM_ID CHAR(8) NOT NULL ,
LINE_TO_ID CHAR(6) NOT NULL,
STAT_TO_ID CHAR(8) NOT NULL,
TRAI_DIRT CHAR(8),
BEEP_FLAG CHAR(1),
VOLE_FLAG CHAR(1),
COST_TIME DECIMAL(6,0),
ALARM_TIME DECIMAL(6,0),
SAVE_TIME CHAR(14),
ONBOARD_TIME CHAR(5),
CANCEL_FLAG CHAR(1),
CANCEL_TIME CHAR(14)
);