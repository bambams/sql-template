Find SqlFile.sql on your system by searching installation folders and
with Administrative privileges replace it with this. Then when you click
"New Query" in SQL Server Management Studio this script will
automatically be loaded.

Does *its best* to catch errors, record them in the messages, and rollback
all the work. Also rolls back by default, and gives you easy control with
script variables. A pretty good place to test SQL as you are developing
it.

**NOT SAFE** with data definition language (DDL) statements or other server
manipulations. Data manipulations only. DDL statements will still execute
within this script (obviously :), but **cannot be rolled back.**

Use at own risk. :)
