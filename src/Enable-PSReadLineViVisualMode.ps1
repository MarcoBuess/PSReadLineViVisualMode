# Movements for w, b, l, h
Set-PSReadLineKeyHandler -ViMode Command -Key v -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()

    :loop while ($true) {
        # Loop input until char aka. command or escape is hit
        $userInput = New-Object -TypeName System.Text.StringBuilder
        while ($true) {
            $currentInput = [Console]::ReadKey($true)

            if ($currentInput.Key -eq [ConsoleKey]::Escape) {
                break loop
            }

            if (-not [char]::IsDigit($currentInput.KeyChar)) {
                $userInput.Append($currentInput.KeyChar)
                break;
            }

            $userInput.Append($currentInput.KeyChar)
        }

        # Parse input into motionCount and motion
        $parsedInput =
            $userInput |
            sls "^(\D)|(\d+)(\D)$" | % {
                if ($_.Matches.Groups[1].Success -eq $true) {
                    [PSCustomObject]@{
                        motionCount = 1
                        motion      = $_.Matches.Groups[1].Value
                    }
                } else {
                    [PSCustomObject]@{
                        motionCount = $_.Matches.Groups[2].Value
                        motion      = $_.Matches.Groups[3].Value
                    }
                }
            }

        for ($i = 0; $i -lt $parsedInput.motionCount; $i++) {
            switch -CaseSensitive ($parsedInput.motion) {
                'w' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectNextWord()}
                'e' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardWord()}
                '$' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectLine()}
                'b' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardWord()}
                {($_ -eq 'x') -or ($_ -eq 'd')} {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Copy()
                    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteChar()
                    break loop
                }
                'l' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()}
                'h' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardChar()}
                'y' {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Copy()
                    break loop
                }
                'p' {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Paste()
                    break loop
                }
                '^' {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardsLine()}
            }
        }
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