Import-Module ./Update-TRTDatabase.ps1 -Force
$server = 'sandbox.cl42mo4qxees.us-west-2.rds.amazonaws.com'
$database = 'trt.auth.db'
$userName = 'deployment'
$loginPath = 'trt.auth.db'
Update-TRTDatabase -loginPath $loginPath -serverName $server -databaseName $database -userName $userName -updateCredentials
