# Movements for w, b, l, h
Set-PSReadLineKeyHandler -ViMode Command -Key v -ScriptBlock {
    :loop while ($true) {
        switch ([Console]::ReadKey($true).Key) {
            W {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardWord()}
            E {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()
               [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardWord()

               $selectionStart = $null
               $selectionLength = $null
               [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
               [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength - 1)}
            B {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardWord()}
            L {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar()}
            H {[Microsoft.PowerShell.PSConsoleReadLine]::SelectBackwardChar()}
            Escape { break loop }
        }
    }
}

# V command to select a complete line
Set-PSReadLineKeyHandler -ViMode Command -Key V -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::SelectLine()
}

# Copy selection to system clipboard
Set-PSReadLineKeyHandler -ViMode Command -Key '*,y' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::Copy()
}

# Paste selection from system clipboard
Set-PSReadLineKeyHandler -ViMode Command -Key '*,p' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::Paste()
}