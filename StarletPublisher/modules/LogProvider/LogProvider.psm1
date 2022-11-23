using namespace system.IO

class LogProvider {

    [string]$Directory

    LogProvider([hashtable]$conf){
        $this.Directory = $conf.Path
    }

    Info([string]$Message){
        $this.Write("Info :", $Message)
    }

    Error($Message){
        $this.Write("Error:", $Message)
    }

    Fatal ($Message){
        $this.Write("Fatal:", $Message)
        exit 1
    }

    Write ([string]$Level, [string]$Message){

        $filename = "{0:yyyy-MM-dd}.log" -f [datetime]::Now
        $filepath = [Path]::Join($this.Directory, $filename)
        $Message = [string]::Concat(
            [datetime]::Now.ToString("yyyy-MM-dd hh:mm:ss.fff"),
            " ",
            $Level,
            " ",
            $Message,
            [System.Environment]::NewLine

        )
        Write-Host $Message -NoNewline
        [File]::AppendAllText($filepath, $Message)
    }
}