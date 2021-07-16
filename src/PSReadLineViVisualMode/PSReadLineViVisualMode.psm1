#Get public and private function definition files.
$public  = @( Get-ChildItem -Path $PSScriptRoot\public\*.ps1 -ErrorAction SilentlyContinue )
$private = @( Get-ChildItem -Path $PSScriptRoot\private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
foreach($import in @($public + $private)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Set-PSReadLineOption -EditMode Windows
}
#Export-ModuleMember -Function $public.Basename