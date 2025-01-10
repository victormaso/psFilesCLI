param ( $commandName, $parameterName, $wordToComplete, $commandAst, $BoundParameters )  
$basePath = '/' + ($wordtocomplete -replace '^(\/|\\)', '');
$wordToComplete = $wordToComplete -replace '\\','/'
$params=@{}
if($BoundParameters.filescliprofile){$params+=@{"filescliprofile"=$BoundParameters.filescliprofile}}
if($BoundParameters.filesapikey){$params+=@{"filesapikey"=$BoundParameters.filesapikey}}

if ($basePath -notmatch '(\/|\\)$') { $basepath = $basepath | Split-Path } ;

try{ $job=Invoke-Command -AsJob -ScriptBlock {(get-FilesCliChildItem @params -recursive:$false -OnlyFolders:$true -path $basePath -ErrorAction Stop).path | foreach-object { "/$_" } | where-object { $_ -like "*$wordToComplete*" }}}catch{}
Wait-Job $job -Timeout 4
if ($job.State -eq 'Completed') {
    Receive-Job $job
} else {}