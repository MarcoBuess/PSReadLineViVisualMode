# Movements for w, b, l, h
Set-PSReadLineKeyHandler -ViMode Command -Key v -ScriptBlock {
    :loop while ($true) {
        switch ([Console]::ReadKey($true).Key) {
            W {[Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardWord()}
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