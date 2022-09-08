# rowantree.auth.db
The Rowan Tree Authentication and Authorization Service Database

Overview
--------

This project contains the MySQL Schema, and tools required to deploy and maintain the database for The Rowan Tree Auth Service.

## Project Structure

```
./model
./stored_procs
./tables
./the dawn chant
```
* model - contains the MySQL Workbech model for the project.
* stored_procs - contains the create scripts for the stored procedures.
* tables - contains the create scripts for the tables.
* the dawn chant - contains the seed scripts required to bring the world into being.

Requirements
------------
* MySQL 5.7.1+ Server Instance (* or compatable)
* mysql client line tool (MySQL Workbench)
* mysql_config_editor
* PowerShell Core (6.0+)

Deploying
---------
The scripts to create the database require PowerShell 6.0+ (pwsh) and MySQL command line tool (mysql) to be present on the system.

Example invokcation of the database creation script
```
/$ pwsh 
PS> Import-Module ./Update-TRTDatabase.ps1
PS> $server = 'localhost'
PS> $port = '3306'
PS> $database = 'trt.auth.db'
PS> $user = 'trt_service'
PS> Update-TRTDatabase -serverName $server -serverPort $port -databaseName $database -userName $user
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
MIT License

Copyright (c) 2018-2022 Joshua C. Burt

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.