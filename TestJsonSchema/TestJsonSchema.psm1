# .EXTERNALHELP TestJsonSchema.psm1-Help.xml
Function Test-JsonSchema {
  [CmdLetBinding()]
  Param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'ProduceOutputFile', HelpMessage = 'Specify the file paths for the Json files.')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'NoOutputFile', HelpMessage = 'Specify the file paths for the Json files.')]
    [ValidateScript({ test-path $_ })][string]$JsonPath,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'ProduceOutputFile', HelpMessage = 'Specify the Json Schema file path.')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'NoOutputFile', HelpMessage = 'Specify the Json Schema file path.')]
    [ValidateScript({ test-path $_ -PathType Leaf -Filter *.json })][string]$SchemaPath,

    [Parameter(ParameterSetName = 'ProduceOutputFile', Mandatory = $true)][ValidateNotNullOrEmpty()][string]$OutputFile,
    [Parameter(ParameterSetName = 'ProduceOutputFile', Mandatory = $false)][ValidateSet('NUnitXml', 'LegacyNUnitXML')][string]$OutputFormat = 'NUnitXml'
  )

  $JsonSchemaTestFilePath = join-path $PSScriptRoot 'JsonSchema.tests.ps1'
  Write-Verbose "Testing '$JsonSchemaTestFilePath'..."
  $container = New-PesterContainer -Path $JsonSchemaTestFilePath -Data @{JsonPath = $JsonPath; SchemaPath = $SchemaPath }
  $config = New-PesterConfiguration
  $config.Run.Container = $container
  $config.Run.PassThru = $true
  $config.Output.verbosity = 'Detailed'
  #File Content tests
  If ($PSCmdlet.ParameterSetName -eq 'ProduceOutputFile') {
    #Common - File content tests
    $config.TestResult.Enabled = $true
    $config.TestResult.OutputFormat = $OutputFormat
    $config.TestResult.OutputPath = $OutputFile
  }
  $JsonSchemaTestResult = Invoke-Pester -Configuration $config
  if ($JsonSchemaTestResult.TestResult.Result -ieq 'failed') {
    Write-Error "Json Schema test failed."
  }
}