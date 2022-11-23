using namespace System.Data
using namespace System.Data.SQLite
using module ..\LogProvider\LogProvider.psm1

Set-StrictMode -Version 'latest'

class StarletPublisher {
    
    [hashtable]$conf
    [LogProvider]$Logger
    [SQLiteConnection]$Connection

    StarletPublisher  ([hashtable]$conf, [LogProvider]$logger) {
        $this.conf = $conf
        $this.Logger = $logger

        $this.Connection = [SQLiteConnection]::new()
        $this.Connection.ConnectionString = $this.conf.ConnectionString
        $this.Connection.Open()
    }

    PublishUtiFile() {
        $dataTable = [DataTable]::new()
        $command = $this.Connection.CreateCommand()
        $command.CommandText = @"
    select ROW_NUMBER () OVER (ORDER BY ACCESSION) [No.],
           ACCESSION `Barcode`,
           PATIENT_NAME `Name`,
           ifnull((select 'TRUE' from TEST where ACCESSION = t.ACCESSION and TEST_NAME = 'UTI1'), '-') UTI1,
           ifnull((select 'TRUE' from TEST where ACCESSION = t.ACCESSION and TEST_NAME = 'UTI2'), '-') UTI2,
           ifnull((select 'TRUE' from TEST where ACCESSION = t.ACCESSION and TEST_NAME = 'UTI3'), '-') UTI3,
           'TRUE' [1.5ml Tube],
           '-' [12ml Tube]
      from TEST t
     where TEST_NAME in ('UTI1', 'UTI2', 'UTI2')
       and datetime(DT) > datetime(datetime(), '-12 days')
     group by ACCESSION, PATIENT_NAME
"@
        $dataTable.Load($command.ExecuteReader())
        $dataTable | Export-Csv $this.conf.Gateway.UtiFile -UseQuotes AsNeeded
    }
}