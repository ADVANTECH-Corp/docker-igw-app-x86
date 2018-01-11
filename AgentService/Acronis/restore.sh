#!/bin/sh

sqlite3 /usr/lib/Acronis/SystemRecovery.db "CREATE TABLE IF NOT EXISTS Recovery(Source nvarchar(100), Message nvarchar(100),EventID nvarchar(100), DateTime datetime); INSERT INTO Recovery(Source, Message, EventID, DateTime) values(\"Acronis\", \"RestoreStart\", 9, datetime('now','localtime'));"

acrocmd recover disk --loc=/backup --arc=BK_ASZ2 --volume=$1 --target_volume=$2 --reboot

if [ $? -ne 0 ]; then 
	echo "[Restore] an error occurred" 
	sleep 1s
	sqlite3 /usr/lib/Acronis/SystemRecovery.db "INSERT INTO Recovery(Source, Message, EventID, DateTime) values(\"Acronis\", \"RecoveryError\", 5, datetime('now','localtime'));"
else
	echo "[Restore] successful" 
	sleep 1s
	sqlite3 /usr/lib/Acronis/SystemRecovery.db "INSERT INTO Recovery(Source, Message, EventID, DateTime) values(\"Acronis\", \"RecoverySuccess\", 6, datetime('now','localtime'));"
fi
exit
