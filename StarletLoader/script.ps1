using assembly .\modules\StarletLoader\System.Data.SQLite.dll

using module .\modules\LogProvider\LogProvider.psm1
using module .\modules\StarletLoader\StarletLoader.psm1

#region init
Set-StrictMode -Version 'latest'
$DebugPreference = 'continue'
$ErrorActionPreference = 'stop'
$conf = Import-PowerShellDataFile .\conf.psd1
$Logger = [LogProvider]::new($conf.Logger)
#endregion init

$logger.Info('{0} session started' -f $conf.Name)
$StarletLoader = [StarletLoader]::new($conf.StarletLoader, $Logger)
$StarletLoader.Load()
$StarletLoader.Connection.Close()
$logger.Info('{0} session finished' -f $conf.Name)


