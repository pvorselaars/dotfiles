Set-PSReadlineOption -EditMode vi
Set-PSReadlineKeyHandler -Chord "End" -Function AcceptNextSuggestionWord

$PSStyle.FileInfo.Directory = "`e[34;1m"

$env:EDITOR="nvim"

function prompt {
	$date = Get-Date -Format "M/dd HH:mm"
	$cwd = Get-Location | Split-Path -Leaf
	$branch = git branch --show-current 2> $null
	
	if ($branch) {
		$branch = "$branch "
	}

	"$date $cwd $($PSStyle.Foreground.Magenta)$branch$($PSStyle.Reset)> "
}

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
