# Enable-PSReadLineViVisualMode

Tries to mimic VIM's visual mode.

## Quick Start

Clone the module to a local folder.

```powershell
git clone https://github.com/MarcoBuess/PSReadLineViVisualMode.git .
```

Import the module using `Import-Module`.

```powershell
Import-Module -Name .\src\PSReadLineViVisualMode
```

> **HINT**: The module automatically enables Vi EditMode.

Keep in mind that the changes are only applied until your current powershell session ends.
For a more permantent application, consider adding the code to your powershell `$profile`.
