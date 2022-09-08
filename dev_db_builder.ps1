Import-Module ./Update-TRTDatabase.ps1 -Force
$server = '0.0.0.0'
$database = 'trt.auth.db'
$userName = 'root'
$loginPath = 'trt.auth.db'
Update-TRTDatabase -loginPath $loginPath -serverName $server -databaseName $database -userName $userName -updateCredentials
