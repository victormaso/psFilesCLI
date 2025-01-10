param ( $commandName, $parameterName, $wordToComplete, $commandAst, $BoundParameters )  
$basePath = '/' + ($wordtocomplete -replace '^(\/|\\)', '');
$wordToComplete = $wordToComplete -replace '\\','/'
$params=@{}
if($BoundParameters.filescliprofile){$params+=@{"filescliprofile"=$BoundParameters.filescliprofile}}
if($BoundParameters.filesapikey){$params+=@{"filesapikey"=$BoundParameters.filesapikey}}

if ($basePath -notmatch '(\/|\\)$') { $basepath = $basepath | Split-Path } ;

(get-FilesCliChildItem @params -recursive:$false -OnlyFolders:$true -path $basePath -ErrorAction Stop).path | foreach-object { "/$_" } | where-object { $_ -like "*$wordToComplete*" }