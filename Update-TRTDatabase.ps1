function Find-LoginPath {
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [String]$loginPath='local'
    )

    $foundLoginPath = $false
    $mysql_check_creds_cmd = "mysql_config_editor print --login-path $loginPath"

    try {
        $result = Invoke-Expression $mysql_check_creds_cmd
        if ($result.length -gt 0){
            $foundLoginPath = $true
        }
    }
    catch {
        Write-Error 'Find-LoginPath threw an exception!'
        Throw $_
    }
    return $foundLoginPath
}

function Set-MySQLCredentials {
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [String]$loginPath='local',

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$serverName,

        # Server Port For The MySQL Instance
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Int]$serverPort=3306,

        # Server Port For The MySQL Instance
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [String]$userName='root'

        # The credentials object to connect to the database
        # [Parameter(Mandatory = $true)]
        # [PSCredential]$credentials
    )

    # $userName = $credentials.GetNetworkCredential().UserName
    # $userPassword = $credentials.GetNetworkCredential().Password

    # used to store the mysql credentials. the app doesn't allow passing the password through, thus the reason
    # we aren't using a pscredential object anymore.  Also the plain mysql cmd used below would through a warning
    # when passing the creds though.
    $mysql_remove_creds_cmd = "mysql_config_editor remove --login-path=$loginPath"
    $mysql_set_creds_cmd = "mysql_config_editor set --login-path=$loginPath --host=$serverName --port=$($serverPort.ToString()) --user=$userName --password"
    
    # Set our credentials
    try {
        Invoke-Expression "$mysql_remove_creds_cmd"
        Invoke-Expression "$mysql_set_creds_cmd"
        # $tmpfile = New-TemporaryFile
        # Set-Content -Value "$userPassword`r`n" -Path $tmpfile
        # Start-Process -FilePath "mysql_config_editor" -ArgumentList "set --login-path=$loginPath --host=$serverName --port=$serverPort --user=$userName --password" -RedirectStandardInput $tmpfile
        # Remove-Item $tmpfile
    }
    catch {
        Write-Error 'Set-MySQLCredentials threw an exception!'
        Throw $_
    }
}

function Update-TRTDatabase {
    # If mysql is missing but the workbench is installed.
    # 1) Then execute this to add the path to ~/.bash_profile:
    #       echo 'export PATH=/usr/local/mysql/bin:$PATH' >> ~/.bash_profile
    #    or  (macOS)
    #       echo 'export PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS' >> ~/.bash_profile
    # 2) Then execute this, to reload the change:
    #       . ~/.bash_profile
    # If mysql_config_editor is missing but mysql server is installed.
    # 1) Then execute this to add the path to ~/.bash_profile:
    #       echo 'export PATH=/usr/local/mysql/bin:$PATH' >> ~/.bash_profile
    # 2) Then execute this, to reload the change:
    #       . ~/.bash_profile
    [CmdletBinding()]
    param (
        # Server Name For The MySQL Instance
        [Parameter(Mandatory = $true)]
        [String]$serverName,

        # Server Port For The MySQL Instance
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [Int]$serverPort=3306,

        # The database to create/update
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]$databaseName,

        # The database to create/update
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [String]$userName='root',

        # The credentials object to connect to the database
        # [Parameter(Mandatory = $false)]
        # [PSCredential]$credentials,

        # The login path to store MySQL credentials at within .mylogin.cnf.
        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [String]$loginPath='local',

        # Drop and recreate database
        [Switch]
        $dropAndRecreateDB,

        [Switch]
        $displayCmd,

        # Controls updating entries within the .mylogin.cnf if they exist.
        [Switch]
        $updateCredentials
    )
        # Determine if we need to build the login-path within the local .mylogin.cnf.
        $loadCreds = Find-LoginPath $loginPath

        # if ($loadCreds -eq $false -and $credentials -eq $null){
        #     throw 'No credentials provided or stored!'
        # }

        if ($loadCreds -ne $true -or $updateCredentials -eq $true){
            $credObj = @{
                loginPath = $loginPath
                serverName = $serverName
                serverPort = $serverPort
                userName = $userName
            }
            Set-MySQLCredentials @credObj
        }

        # Build the begining of the sql cmds to execute.
        $databaseName = "$databaseName"
        $mysql_cmd = "mysql --login-path=$loginPath --database $databaseName"   


        if ($dropAndRecreateDB){
            Write-Output 'Droppping database..'
            $database_delete_statement = """DROP DATABASE IF EXISTS ````$databaseName````;"""
            $full_drop_cmd = "mysql --login-path=$loginPath --execute=$database_delete_statement"
            if ($displayCmd) { Write-Output $full_drop_cmd }
            Invoke-Expression $full_drop_cmd
        }

        # Create the database
        Write-Output 'Creating database..'
        $database_create_statement = """CREATE DATABASE IF NOT EXISTS ````$databaseName```` /*!40100 DEFAULT CHARACTER SET latin1 */;"""
        $full_create = "mysql --login-path=$loginPath --execute=$database_create_statement"
        if ($displayCmd) { Write-Output $full_create }
        Invoke-Expression $full_create

        Write-Output "Creating Tables.."
        Get-ChildItem -Path ./tables | ForEach-Object -Process {
            $final_cmd = "$mysql_cmd -e ""source $($_.FullName)"" "
            if ($displayCmd) { Write-Output $final_cmd }
            Invoke-Expression $final_cmd
        }

        Write-Output('Creating Stored Procedures..')
        Get-ChildItem -Path ./stored_procs | ForEach-Object -Process {
            $final_cmd = "$mysql_cmd -e ""source $($_.FullName)"" "
            if ($displayCmd) { Write-Output $final_cmd }
            Invoke-Expression $final_cmd
        }

        Write-Output('Adding seed data..')
        Get-ChildItem -Path './the dawn chant' -Filter *.sql | ForEach-Object -Process {
            $final_cmd = "$mysql_cmd -e ""source $($_.FullName)"" "
            if ($displayCmd) { Write-Output $final_cmd }
            Invoke-Expression $final_cmd
        }
}
