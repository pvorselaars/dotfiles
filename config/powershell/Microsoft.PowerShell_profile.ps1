Set-PSReadlineOption -EditMode vi
Set-PSReadlineKeyHandler -Chord "End" -Function AcceptNextSuggestionWord

$PSStyle.FileInfo.Directory = "`e[34;1m"

$env:EDITOR="nvim"

function prompt { "> " }

function Set-Namespace {
	kubectl config set-context --current --namespace $args
}

function Get-Resources {
	kubectl get all,cm,secret,ing
}

function Get-Context {
	kubectl config get-contexts
}

function Set-Context {
	kubectl config use-context $args
}

function Git-Status {
	git status
}

function Git-Commit {
	git commit -am "$args"
}

function Git-Pull {
	git pull
}

function Git-Diff {
	git diff
}

Set-Alias -Name k -Value kubectl
Set-Alias -Name kns -Value Set-Namespace
Set-Alias -Name kctx -Value Set-Context
Set-Alias -Name kctxs -Value Get-Context
Set-Alias -Name kgr -Value Get-Resources

Set-Alias -Name gs -Value Git-Status
Set-Alias -Name gca -Value Git-Commit
Set-Alias -Name g -Value Git-Pull
Set-Alias -Name gd -Value Git-Diff


$vcvarsPath = "C:\Program Files\Microsoft Visual Studio\2022\Preview\VC\Auxiliary\Build\vcvars64.bat"

cmd /c "`"$vcvarsPath`" && set" | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
    }
}

