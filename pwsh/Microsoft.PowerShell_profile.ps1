# Create custom prompt
function prompt {$((Get-Location).Path -split "\\" | Select-Object -last 1) + " > " }

# Set terminal editing mode to vi
Set-PSReadLineOption -EditMode vi

# Set shortcuts
Set-Alias -Name stop -Value Stop-Computer
Set-Alias -Name restart -Value Restart-Computer


