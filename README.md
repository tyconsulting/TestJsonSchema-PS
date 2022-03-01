# PowerShell Module - TestJsonSchema

## Introduction

This module performs Pester Test for JSON schema validation

## Requirements

This module requires:

1. PowerShell Core
    * To install:

    ``` PowerShell
    iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"
    ```

2. The latest Pester module installed on PowerShell Core
    * To install:

    ``` PowerShell
    Install-module Pester -MinimumVersion 5.3.1 -repository PSGallery -force -SkipPublisherCheck
    ```

## Install This Module

This module is published on [PowerShell Gallery](https://www.powershellgallery.com/packages/TestJsonSchema)

**To install:**

``` PowerShell
Install-module TestJsonSchema -repository PSGallery -force
```
