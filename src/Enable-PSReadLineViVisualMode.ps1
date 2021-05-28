# Movements for w, b, l, h
Set-PSReadLineKeyHandler -ViMode Command -Key v -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()

    :loop while ($true) {
        $input = [Console]::ReadKey($true)

        switch ($input.Key) {
            W {[Microsoft.PowerShell.PSConsoleReadLine]::SelectNextWord()}
            E {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardWord()}
            {($_ -eq [ConsoleKey]::D4) -and ($input.Modifiers -eq [ConsoleModifiers]::Shift)} {
               [Microsoft.PowerShell.PSConsoleReadLine]::SelectLine()
            }
            B {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardWord()}
            L {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()}
            H {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardChar()}
            Y {[Microsoft.PowerShell.PSConsoleReadLine]::Copy()
               break loop}
            Escape { break loop }
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