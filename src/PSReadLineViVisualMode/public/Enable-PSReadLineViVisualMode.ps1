# Enable Vi edit mode
Set-PSReadLineOption -EditMode Vi

# Movements for w, b, l, h
Set-PSReadLineKeyHandler -ViMode Command -Key v -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()

    :loop while ($true) {
        # Loop input until char aka. command or escape is hit
        $userInput = Read-Input -UserInput $([Console]::ReadKey($true))
        if (-not $userInput) { break loop }

        # Parse input into motionCount and motion
        $parsedInput = Test-Input -UserInput $userInput

        Invoke-VimCommand -Command $parsedInput
    }
}

# V command to select a complete line
Set-PSReadLineKeyHandler -ViMode Command -Key V -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::SelectLine()
}

# Paste selection from system clipboard
Set-PSReadLineKeyHandler -ViMode Command -Key '*,p' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::Paste()
}