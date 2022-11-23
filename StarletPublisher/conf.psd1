@{
	Name          = "StarletPublisher"
	StarletPublisher = @{
		ConnectionString = "data source=..\StarletDatabase\Starlet.db ;Version=3;"
		Gateway = @{
			UtiFile = ".\Gateway\Output\UtiFile.csv"
		}
	}
	Logger        = @{
		Path = ".\logs"
	}
}