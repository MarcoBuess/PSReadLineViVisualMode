$ModuleName = $MyInvocation.MyCommand.Name.Split('.')[0]
$ModulePath = "$((Get-Item -Path $MyInvocation.MyCommand.Path).Directory.parent.FullName)\src\"
$Module = $ModulePath + $ModuleName

Get-Module -Name $Module -ListAvailable -All | Remove-Module -Force -ErrorAction Ignore

Import-Module -Name $Module -Force -ErrorAction Stop

InModuleScope $ModuleName {
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
        It "When a multi motion <UserInput> is entered <Expected> is returned." -TestCases @(
            @{ UserInput = '2w'; Expected = [PSCustomObject]@{motionCount = 2; motion = 'w'} }
            @{ UserInput = '201v'; Expected = [PSCustomObject]@{motionCount = 201; motion = 'v'} }
            @{ UserInput = '17e'; Expected = [PSCustomObject]@{motionCount = 17; motion = 'e'} }
            @{ UserInput = '99999l'; Expected = [PSCustomObject]@{motionCount = 99999; motion = 'l'} }
        ) {
            param ($UserInput, $Expected)

            (Compare-Object -ReferenceObject $Expected `
                           -DifferenceObject $(Test-Input -UserInput $UserInput) `
                           -IncludeEqual).SideIndicator
            | Should -Be "=="
        }
    }
}

Get-Module -Name $Module -ListAvailable -All `
| Remove-Module -Force -ErrorAction Ignore