mysql -e 'show slave status\G' | egrep 'Slave_IO_State:|Slave_IO_Running:|Slave_SQL_Running:|Seconds_Behind_Master:';    
