# .EXTERNALHELP TestJsonSchema.psm1-Help.xml
Function Test-JsonSchema
{
    [CmdLetBinding()]
    Param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'ProduceOutputFile', HelpMessage = 'Specify the file paths for the Json files.')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'NoOutputFile', HelpMessage = 'Specify the file paths for the Json files.')]
    [ValidateScript({test-path $_})][string]$JsonPath,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'ProduceOutputFile', HelpMessage = 'Specify the Json Schema file path.')]
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'NoOutputFile', HelpMessage = 'Specify the Json Schema file path.')]
    [ValidateScript({test-path $_ -PathType Leaf -Filter *.json})][string]$SchemaPath,

    [Parameter(ParameterSetName = 'ProduceOutputFile', Mandatory=$true)][ValidateNotNullOrEmpty()][string]$OutputFile,
    [Parameter(ParameterSetName = 'ProduceOutputFile', Mandatory=$false)][ValidateSet('NUnitXml', 'LegacyNUnitXML')][string]$OutputFormat='NUnitXml'
    )

    $JsonSchemaTestFilePath = join-path $PSScriptRoot 'JsonSchema.tests.ps1'
    Write-Verbose "Testing '$definitionFile'..."
    #File Content tests
    If ($PSCmdlet.ParameterSetName -eq 'ProduceOutputFile')
    {
      #Common - File content tests
      $JsonSchemaTestResult = Invoke-Pester -script @{path = $JsonSchemaTestFilePath; Parameters=@{JsonPath = $Jsonpath; SchemaPath = $SchemaPath}} -OutputFile $OutputFile -OutputFormat $OutputFormat -PassThru
    } else {
      $JsonSchemaTestResult = Invoke-Pester -script @{path = $JsonSchemaTestFilePath; Parameters=@{JsonPath = $JsonPath; SchemaPath = $SchemaPath}} -PassThru
    }
    if ($JsonSchemaTestResult.TestResult.Result -ieq 'failed')
    {
      Write-Error "Json Schema test failed."
    }
}