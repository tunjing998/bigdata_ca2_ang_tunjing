
 :loop
 mongodump --db bigdata_ca2_ang_tunjing
 ren bigdata_ca2_ang_tunjing Logs-%date:~10,4%%date:~7,2%%date:~4,2%_%time:~1,1%%time:~3,2%
 timeout /t 86400
 goto loop

 :https://stackoverflow.com/questions/4984391/cmd-line-rename-file-with-date-and-time
 :https://stackoverflow.com/questions/935858/only-do-if-day-batch-file