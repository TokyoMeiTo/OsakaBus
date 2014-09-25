cd .
chcp 65001
del /Q work.db
sqlite3 work.db<init.sql
move work.db ../../TokyoMetro/work.db
pause 