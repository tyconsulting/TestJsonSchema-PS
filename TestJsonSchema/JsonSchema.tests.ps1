[CmdLetBinding()]
Param (
  [Parameter(Mandatory = $true)][ValidateScript({ test-path $_ })][string]$JsonPath,
  [Parameter(Mandatory = $true)][ValidateScript({ test-path $_ -PathType Leaf -Filter *.json })][string]$SchemaPath
)
Write-Verbose "Json Path: '$JsonPath'"
Write-Verbose "Schema Path: '$SchemaPath'"

if ((Get-Item $JsonPath).PSIsContainer) {
  Write-Verbose "Specified path '$JsonPath' is a directory"
  $global:files = Get-ChildItem $JsonPath -Include *.json -Recurse
} else {
  Write-Verbose "Specified path '$JsonPath' is a file"
  $global:files = Get-Item $JsonPath -Include *.json
  Write-Verbose "Found $($global:files.Count) files"
}
#Get Schema
$global:Schema = Get-Content -Path $SchemaPath -Raw
Describe "File Existence Test" {
  Context "JSON files Should Exist" {
    It 'File count should be greater than 0' {
      $global:files.count | Should -BeGreaterThan 0
    }
  }
}

Foreach ($file in $global:files) {
  Write-Verbose "Test '$file'"
  $global:filePath = $file.FullName
  Describe "'$($file.name)' JSON File Syntax Test" {
    Context "JSON Syntax Test" {
      It 'Should be a valid JSON file' {
        $fileContent = Get-Content -Path $global:filePath -Raw
        ConvertFrom-Json -InputObject $fileContent -ErrorVariable parseError
        $parseError | Should -Be $Null
      }
    }
    Context "JSON Schema Test" {
      It 'Should be a valid JSON file against Schema' {
        $fileContent = Get-Content -Path $global:filePath -Raw
        Test-Json -Json $fileContent -schema $global:Schema | Should -Be $true
      }
    }
  }
}
