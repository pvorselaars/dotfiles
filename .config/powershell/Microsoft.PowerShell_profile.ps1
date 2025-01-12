Set-PSReadlineOption -EditMode vi
Set-PSReadlineKeyHandler -Chord "End" -Function AcceptNextSuggestionWord

$PSStyle.FileInfo.Directory = "`e[34;1m"

function prompt {
	$date = Get-Date -Format "M/dd hh:mm"
	$cwd = Get-Location | Split-Path -Leaf
	$branch = git branch --show-current 2> $null
	
	if ($branch) {
		$branch = "$branch "
	}

	"$date $cwd $($PSStyle.Foreground.Magenta)$branch$($PSStyle.Reset)> "
}

Set-Alias -Name k -Value kubectl
Set-Alias -Name kns -Value "kubectl config set-context --current --namespace "
Set-Alias -Name kctx -Value "kubectl config use-context "
Set-Alias -Name kgr -Value "kubectl get all,cm,secret,ing "

Set-Alias -Name gs -Value "git status"
Set-Alias -Name gca -Value "git commit -am "
Set-Alias -Name g -Value "git pull"
Set-Alias -Name gd -Value "git diff"
