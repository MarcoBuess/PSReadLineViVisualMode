. $PSScriptRoot/Get-Generators.ps1

BeforeAll {
    $ModuleName = $([System.IO.Path]::GetFileName($PSCommandPath)).Split('.')[0]
    $ModulePath = "$((Get-Item -Path $PSCommandPath).Directory.parent.FullName)\src\"
    $Module = $ModulePath + $ModuleName

    Get-Module -Name $Module -ListAvailable -All | Remove-Module -Force -ErrorAction Ignore
    Import-Module -Name $Module -Force -ErrorAction Stop
}

Describe "Test-Input" {
    It "When a single motion <UserInput> is entered <Expected> is returned." -TestCases @(
        @{ UserInput = 'w'; Expected = [PSCustomObject]@{motionCount = 1; motion = 'w'} }
        @{ UserInput = 'v'; Expected = [PSCustomObject]@{motionCount = 1; motion = 'v'} }
        @{ UserInput = 'e'; Expected = [PSCustomObject]@{motionCount = 1; motion = 'e'} }
        @{ UserInput = 'l'; Expected = [PSCustomObject]@{motionCount = 1; motion = 'l'} }
    ) {
        param ($UserInput, $Expected)

        (Compare-Object -ReferenceObject $Expected `
                        -DifferenceObject $(Test-Input -UserInput $UserInput) `
                        -IncludeEqual).SideIndicator
        | Should -Be "=="
    }

    It "When a multi motion <UserInput> is entered <Expected> is returned." -TestCases $(Invoke-UserInputGenerator -Samples 100) {
        param ($UserInput, $Expected)

        (Compare-Object -ReferenceObject $Expected `
                        -DifferenceObject $(Test-Input -UserInput $UserInput) `
                        -IncludeEqual).SideIndicator
        | Should -Be "=="
    }
}

AfterAll {
    Get-Module -Name $ModuleName -ListAvailable -All | Remove-Module -Force -ErrorAction Ignore
}