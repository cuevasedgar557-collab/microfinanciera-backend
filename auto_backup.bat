@echo off

set FECHA=%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%

"C:\mysql-9.7.1-winx64\bin\mysqldump.exe" --defaults-extra-file=C:\Users\Usuario\Desktop\microfinanciera\backend\.my.cnf --single-transaction --set-gtid-purged=OFF microfinanciera > C:\Users\Usuario\Desktop\microfinanciera\backend\backups\backup_%FECHA%.sql
