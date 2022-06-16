This repository contains a T-SQL (Microsoft SQL Server) script file
template.

Does *its best* to catch errors, record them in the messages, and rollback
all the work. Also rolls back by default, and gives you easy control with
a script variable. A pretty good place to test SQL as you are developing
it. The script is also UTF-8 encoded with a BOM. This is much nicer for
version control systems like Git which cannot diff UTF-16 out of the box.

**NOT SAFE** with data definition language (DDL) statements or other
server manipulations. Data manipulations only. DDL statements will still
execute within this script (obviously :), but **cannot be rolled back.**

Use at own risk. :)

Find SqlFile.sql on your system by searching installation folders and with
Administrative privileges replace it with this. Then when you click "New
Query" in SQL Server Management Studio this script will automatically be
loaded.

This cmd.exe command line will help with that if you like (powershell must
be in your PATH to help with drive letters, otherwise replace with an
absolute path to powershell). All it does is list the file system drive
letters, and then search each file system for a file named "SqlFile.sql".

    for /f "tokens=1,*" %f in ('powershell -c "get-psdrive -psprovider filesystem"') do @if not "%f" == "Name" if not "%f" == "----" dir /a /b /s "%f:\SqlFile.sql"
