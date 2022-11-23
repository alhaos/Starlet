using assembly .\modules\StarletPublisher\System.Data.SQLite.dll

using module .\modules\LogProvider\LogProvider.psm1
using module .\modules\StarletPublisher\StarletPublisher.psm1

#region init
Set-StrictMode -Version 'latest'
$DebugPreference = 'continue'
$ErrorActionPreference = 'stop'
$conf = Import-PowerShellDataFile .\conf.psd1
$Logger = [LogProvider]::new($conf.Logger)
#endregion init

$logger.Info('{0} session started' -f $conf.Name)
$StarletPublisher = [StarletPublisher]::new($conf.StarletPublisher, $Logger)
$StarletPublisher.PublishUtiFile()
$logger.Info('{0} session finished' -f $conf.Name)


