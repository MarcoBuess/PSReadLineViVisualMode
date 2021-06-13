# Movements for w, b, l, h
Set-PSReadLineKeyHandler -ViMode Command -Key v -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()

    :loop while ($true) {
        # Loop input until char aka. command is hit
        $userInput = New-Object -TypeName System.Text.StringBuilder
        while ($true) {
            $currentInput = [Console]::ReadKey($true)

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
            # TODO: Casting '$' and other specials not working. Consider switching to just char's instead of [ConsoleKey]
            switch ([ConsoleKey]$parsedInput.motion) {
                W {[Microsoft.PowerShell.PSConsoleReadLine]::SelectNextWord()}
                E {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardWord()}
                {($_ -eq [ConsoleKey]::D4) -and ($userInput.Modifiers -eq [ConsoleModifiers]::Shift)} {
                [Microsoft.PowerShell.PSConsoleReadLine]::SelectLine()
                }
                B {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardWord()}
                {($_ -eq [ConsoleKey]::X) -or ($_ -eq [ConsoleKey]::D)} {
                [Microsoft.PowerShell.PSConsoleReadLine]::Copy()
                [Microsoft.PowerShell.PSConsoleReadLine]::DeleteChar()
                break loop
                }
                L {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()}
                H {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardChar()}
                Y {[Microsoft.PowerShell.PSConsoleReadLine]::Copy()
                break loop}
                P {[Microsoft.PowerShell.PSConsoleReadLine]::Paste()
                break loop}
                Oem5 {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardsLine()}
                Escape { break loop }
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