# Create custom prompt
function prompt {$((Get-Location).Path -split "\\" | Select-Object -last 1) + " > " }

# Set terminal editing mode to vi
Set-PSReadLineOption -EditMode vi

# Credential helper functions
function Unlock-Vault {
    if(!$env:BW_SESSION){
        $env:BW_SESSION = bw --raw login
    }
}


