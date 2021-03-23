#region Functions

<#
    .Synopsis
    Detecte last modified files and copy them at the specified destination.

    .Description
    Print all modified files in yellow.
    Get all modified files after the date saved in the file update.txt.
    Foreach file, check if folder exist in the save destination, if not,  create it.
    Then, copy files at the destination. 
    Created folders and copied files are print in green.
#>

function Get-FolderPath 
{
    <#
        .SYNOPSIS
        Returns a path folder.

        .DESCRIPTION
        Get a folder path with a file path.

        .PARAMETER Src
        Specifies the source to search file.

        .PARAMETER Dst
        Specifies the destination to save file.

        .OUTPUTS
        System.String. Get-FolderPath returns a string with the folder path.
    #>

    param(
        $Src,
        $Dst,
        $File
    )

    $FileFullName = $File.FullName                                                                         
    $Elts = $FileFullName -split "\\"                                                             
    $WithoutFileName = $FileFullName.Substring(0, $FileFullName.Length - $Elts[-1].Length)    
    $DstFolder = $Dst + $WithoutFileName.Substring($Src.Length - 1)  

    return $DstFolder
}

function Update-Files 
{
    <#
        .SYNOPSIS
        Detecte last modified files and copy them at the specified destination.

        .DESCRIPTION
        Print all modified files in yellow.
        Get all modified files after the date saved in the file update.txt.
        Foreach file, check if folder exist in the save destination, if not,  create it.
        Then, copy files at the destination. 
        Created folders and copied files are print in green.

        .PARAMETER ToUpdate
        Files to save.

        .PARAMETER Src
        Specifies the source to search file.

        .PARAMETER Dst
        Specifies the destination to save file.
    #>
    
    param(
        $ToUpdate,
        $Src,
        $Dst
    )

    Write-Host "`nModified : $($ToUpdate.Count)"
    Write-Host "`n"

    foreach ($File in $ToUpdate) 
    {
        Write-Host $File.FullName -ForegroundColor Yellow
    }

    Write-Host "`n"

    $NbCopy = 0
    $NbNewFolder = 0

    foreach ($File in $ToUpdate) 
    {
        $DstFolder = Get-FolderPath $Src $Dst $File            

        ## If folder doesn't exist, create it
        if (-Not(Test-Path -Path $DstFolder)) 
        {
            New-Item -Path $DstFolder -ItemType "directory"
            Write-Host "Added folder : $DstFolder" -ForegroundColor Green
            $NbNewFolder++
        }

        $BuildDst = $($Dst + ($File.FullName).Substring($Src.Length - 1))    

        Copy-Item $File.FullName -Destination $BuildDst
        Write-Host "Copied file : $BuildDst" -ForegroundColor Green
        $NbCopy++
    }

    Write-Host "`nCreated folder(s) : $NbNewFolder"
    Write-Host "Copied file(s) : $NbCopy"
}

#endregion Functions 

#region Main

if ($args.Count -eq 2) {

    ## Location of files to be checked
    $Src = $args[0]

    ## Location of files to be saved
    $Dst = $args[1]

    ## File where backup date is written
    $FilesUpdates = (Get-Location).Path + "\update.txt"

    if (Test-Path $FilesUpdates) 
    {
        $LastUpdate = Get-Content $FilesUpdates
    }
    else
    {
        $LastUpdate = (Get-Date).AddDays(-1)
    }

    ## Update file with last update
    Set-Content -Path $FilesUpdates -Value (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")

    ## Get all files where the modification date is greater than the last date in update.txt
    $UpdatedFiles = Get-ChildItem -Path $Src -Recurse | Where-Object { $_.LastWriteTime -gt $LastUpdate -and $_.Mode -notlike "d*"}

    Update-Files $UpdatedFiles $Src $Dst
} else {
    Write-Host "To execute this script, 2 arguments are required, folder source and folder destination" -ForegroundColor Red
}

#endregion Main