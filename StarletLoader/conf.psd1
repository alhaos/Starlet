@{
	Name          = "StarletLoader"
	StarletLoader = @{
		ConnectionString = "data source=..\StarletDatabase\Starlet.db ;Version=3;"
		Gateway = @{
			Input = ".\Gateway\Input"
			Arch  = ".\Gateway\Arch"
		}
		Exclude = @("DOB", "Gender")
		TestNameCollection = @("UTI1", "UTI2", "UTI3", "RP1", "RP2", "RP3", "PB", "EA", "AV", "BV", "C", "Covid")
	}
	Logger        = @{
		Path = ".\logs"
	}
}