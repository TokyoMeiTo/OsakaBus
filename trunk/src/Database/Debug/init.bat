cd .
chcp 65001
del /Q work.db
sqlite3 work.db<init.sql

sqlite3 work.db