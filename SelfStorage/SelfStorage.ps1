#region Functions

function Find-Folder{

    <#
        .SYNOPSIS
        Returns true if folder exists.

        .DESCRIPTION
        If a folder with path exists; then return true.

        .PARAMETER Path
        Folder path to find.
    #>

    param(
        $Path
    )

    $IsFolder = $false

    if ((Test-Path -Path $Path) -and (Test-Path -Path $Path -PathType Container))
    {
        $IsFolder = $true
    }

    return $IsFolder
}

#endregion Functions

$ArrayExt = @{
    '.c' = 'C'; '.cpp' = 'C++'; '.go' = 'Go'; 
    '.ts' = 'Typescript'; '.js' = 'Javascript'; '.rb' = 'Ruby'; 
    '.cs' = 'C#'; '.java' = 'Java'; '.php' = 'Php'; 
    '.ps1' = 'Powershell'; '.py' = 'Python'; '.dart' = 'Dart';
    '.txt' = 'Notes'; '.rs' = 'Rust'; '.sh' = 'Shell'; '.bsh' = 'Shell'
}

$DesktopPath = 'C:\Users\garro\OneDrive\Bureau\'
$Files = Get-ChildItem 'C:\Users\garro\OneDrive\Bureau\' | Where-Object { $_.Mode -notlike 'd*' }

foreach($File in $Files)
{
    if ($ArrayExt.Keys.contains($File.Extension))
    {
        if (-Not(Find-Folder(("$($DesktopPath)$($ArrayExt[$File.Extension])"))))
        {
            New-Item -Path "$($DesktopPath)$($ArrayExt[$File.Extension])" -ItemType "directory"
        }

        Move-Item -Path "$($DesktopPath)$File" -Destination "$($DesktopPath)$($ArrayExt[$File.Extension])\$($File)"
    }
}