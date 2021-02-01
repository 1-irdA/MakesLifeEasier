# Request
$HTTP_Request = [System.Net.WebRequest]::Create($($args[0]))
# Response
$Http_Response = $HTTP_Request.GetResponse()
# HTTP code
$Http_Status = [int]$HTTP_Response.StatusCode

If ($Http_Status -eq 200) {

    $Content = (Invoke-WebRequest -URI $args[0]).Content
    $Http_Response.Close()
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
Else 
{
    Write-Host "Cannot get website" -ForegroundColor Red
}
