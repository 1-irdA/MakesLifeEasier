if ($args.Count -eq 1) 
{
    $File = "$($args[0])"

    if (Test-Path -Path $File) 
    {
        $Content = Get-Content $File
        $Lines = $Content.Split([Environment]::NewLine)
        $CommentRegex = ".*/*\*"
        $OneLineRegex = " *.* *[/]+[/]+ *.* *"
        $NbComments = 0
        $NbLines = 0

        foreach($Line in $Lines) 
        {
            if ($Line -match $CommentRegex -or $Line -match $OneLineRegex) {
                $NbComments++
            }

            $NbLines++
        }

        Write-Host "Number of comments : $($NbComments) / $($NbLines)" -ForegroundColor Blue
        Write-Host "Comments ratio : $(($NbComments / $NbLines) * 100)%" -ForegroundColor Blue
    }
}
else 
{
    Write-Host "Script needs 1 arg, the file path" -ForegroundColor Red
}
