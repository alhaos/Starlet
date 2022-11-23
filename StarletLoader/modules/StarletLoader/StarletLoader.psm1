using namespace System.Data
using namespace System.Data.SQLite
using module ..\LogProvider\LogProvider.psm1

Set-StrictMode -Version 'latest'

class StarletLoader {
    
    [hashtable]$conf
    [LogProvider]$Logger
    [SQLiteConnection]$Connection

    StarletLoader ([hashtable]$conf, [LogProvider]$logger) {
        $this.conf = $conf
        $this.Logger = $logger

        $this.Connection = [SQLiteConnection]::new()
        $this.Connection.ConnectionString = $this.conf.ConnectionString
        $this.Connection.Open()
    }

    Load() {
        $command = $this.Connection.CreateCommand()
        $command.CommandText = "insert into TEST (DT, ACCESSION, TEST_NAME, PATIENT_NAME) values (@DT, @ACCESSION, @TEST_NAME, @PATIENT_NAME)"
        $command.Parameters.Add(
            [SQLiteParameter]::new("@DT", [DbType]::String)
        )
        $command.Parameters.Add(
            [SQLiteParameter]::new("@ACCESSION", [DbType]::String)
        )
        $command.Parameters.Add(
            [SQLiteParameter]::new("@TEST_NAME", [DbType]::String)
        )
        $command.Parameters.Add(
            [SQLiteParameter]::new("@PATIENT_NAME", [DbType]::String)
        )
        
        foreach ($file in Get-ChildItem $this.conf.Gateway.Input -File) {
            $this.Logger.Info('found file {0}' -f $file.Name)
   
            foreach ($line in $file | Import-Csv) {
                $accession = $line.Barcode
                $patientName = $line.Name
                $this.Logger.Info("  Accession: $accession")
                
                foreach ($test in $line.PsObject.Properties.Name.Where{$_ -in $this.conf.TestNameCollection}) {
                    if ($line.$test -IN @("TRUE", "TURE")){
                        $command.Parameters["@DT"].Value = [datetime]::Now.ToString("yyyy-MM-dd HH:mm:ss")
                        $command.Parameters["@ACCESSION"].Value = $accession
                        $command.Parameters["@TEST_NAME"].Value = $test
                        $command.Parameters["@PATIENT_NAME"].Value = $patientName
                        $command.ExecuteNonQuery()
                        $this.Logger.Info("    Test: $test")
                    }
                }
            }
            $this.ArchFile($file)
        }
    } 

    ArchFile ([System.IO.FileInfo]$File) {
        $archFileName = Join-Path $this.conf.Gateway.Arch $file.Name
        $this.Logger.Info("File $File archived to $archFileName")
        Move-Item $File $archFileName
    } 
}