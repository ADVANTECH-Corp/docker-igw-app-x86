#!/bin/sh

sqlite3 /usr/lib/Acronis/SystemRecovery.db "CREATE TABLE IF NOT EXISTS Recovery(Source nvarchar(100), Message nvarchar(100),EventID nvarchar(100), DateTime datetime); INSERT INTO Recovery(Source, Message, EventID, DateTime) values(\"Acronis\", \"BackupStart\", 10, datetime('now','localtime'));"

acrocmd backup disk --volume=$1 --loc=/backup --arc=BK_ASZ2 --backuptype=incremental --silent_mode=on --log=/tmp/BackupInfo.txt > $2

if [ $? -ne 0 ]; then 
	echo "[Backup] an error occurred" 
	sleep 1s
	sqlite3 /usr/lib/Acronis/SystemRecovery.db "INSERT INTO Recovery(Source, Message, EventID, DateTime) values(\"Acronis\", \"BackupError\", 3, datetime('now','localtime'));"
else
	echo "[Backup] successful" 
	sleep 1s
	sqlite3 /usr/lib/Acronis/SystemRecovery.db "INSERT INTO Recovery(Source, Message, EventID, DateTime) values(\"Acronis\", \"BackupSuccess\", 4, datetime('now','localtime'));"
fi
exit
