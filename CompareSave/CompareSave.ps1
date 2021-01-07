<#
    .SYNOPSIS
    Compare folders, files and update source and destination.

    .DESCRIPTION
    Compare folders, files and update source and destination.
    The comparison is carried out with the tree structure.
    
#>

function Get-Files 
{
    param(
        $Path
    )

    return Get-ChildItem -Path $Path -Recurse

    <#
        .SYNOPSIS
        Get files and folders from $Path.

        .DESCRIPTION
        Get files and folders from $Path.

        .PARAMETER Path
        Path where files and folders are.

        .OUTPUTS
        Array with files.
    #>
}

function Get-FolderPath 
{
    param(
        $File
    )

    $FileFullName = $File.FullName                                                                         
    $Elts = $FileFullName -split "\\"                                                             
    $WithoutFileName = $FileFullName.Substring(0, $FileFullName.Length - $Elts[-1].Length)     
    $DstFolder = $global:SaveLocation + $WithoutFileName.Substring($global:Location.Length)  

    return $DstFolder

    <#
        .SYNOPSIS
        Transform a file path to a folder path.

        .DESCRIPTION
        Remove the file name to transform a file path to a folder path.

        .PARAMETER File
        File to update.

        .OUTPUTS
        System.String. Folder path.
    #>
}

function CompareSrcDst 
{
    param(
        $SrcFiles,
        $DstFiles
    )

    $files = $null

    if ($SrcFiles.Count -gt 0 -and $DstFiles.Count -gt 0) {

        ## <= In $src but differents in $save
        ## => In $save but differents in $sr
        $files = Compare-Object -ReferenceObject $SrcFiles -DifferenceObject $DstFiles -Property FullName, SideIndicator, LastWriteTime
    }

    return $files

    <#
        .SYNOPSIS
        Compare two arrays of files.

        .DESCRIPTION
        Compare two arrays with files and get differences.

        .PARAMETER SrcFiles
        Files from source.

        .PARAMETER DstFiles
        Files from destination.

        .OUTPUTS
        [Array] of files with differences, full name and side indicator.
    #>
}

function BuildPath 
{
    param(
        $File,
        $Src,
        $Dst
    )

    return $Dst + ($File.FullName).Substring($Src.Length, ($File.FullName).Length - $Src.Length)

    <#
        .SYNOPSIS
        Create a path.

        .DESCRIPTION
        Create a path with source and destination.

        .PARAMETER File
        A file to update path.

        .PARAMETER Src
        Source location.

        .PARAMETER Dst
        Destination location.

        .OUTPUTS
        System.String. A new path.
    #>
}

function UpdateDifferences 
{
    param(
        $Differences
    )

    foreach($Diff in $Differences) {

        if ($Diff.SideIndicator -eq "<=")
        {
            $CheckExistence = BuildPath $Diff $global:Location $global:SaveLocation
        
            if (-Not(Test-Path($CheckExistence))) {
                
                $DstFolder = Get-FolderPath $Diff   

                ## If folder doesn't exist, create it
                if (-Not(Test-Path -Path $DstFolder)) 
                {
                    New-Item -Path $DstFolder -ItemType "directory"
                    Write-Host "Created folder : $DstFolder" -ForegroundColor Green
                }

                $FileDst = $global:SaveLocation + ($Diff.FullName).Substring($global:Location.Length, ($Diff.FullName).Length - $global:Location.Length) 
                Copy-Item $Diff.FullName -Destination $FileDst 
                Write-Host "Copied file : $($Diff.FullName)" -ForegroundColor Green
            }
        } 
        else
        {
            $CheckExistence = BuildPath $Diff $global:SaveLocation $global:Location
        
            if (-Not(Test-Path($CheckExistence))) {
                
                if (Test-Path($Diff.FullName)) {
                    Remove-Item $Diff.FullName
                }
                
                Write-Host "Deleted : $($Diff.FullName)" -ForegroundColor Red
            }  
        } 
    }

    <#
        .SYNOPSIS
        Update all differences.

        .DESCRIPTION
        Check from differences if folder exist, if file exist and update them.

        .PARAMETER Differences
        An array with files.
    #>
}

function UpdateIfNeed 
{
    param(
        $Src,
        $Dst
    )

    $Files = Get-ChildItem -Path $Src -Recurse | Where-Object { $_.Mode -notlike "d*" }

    foreach($File in $Files)
    {
        $DstFolder = Get-FolderPath $File             

        ## If folder doesn't exist, create it
        if (-Not(Test-Path -Path $DstFolder)) 
        {
            New-Item -Path $DstFolder -ItemType "directory"
            Write-Host "Created folder : $DstFolder" -ForegroundColor Green
        }

        $FileDst = $global:SaveLocation + ($File.FullName).Substring($global:Location.Length, ($File.FullName).Length - $global:Location.Length) 
        Copy-Item $File.FullName -Destination $FileDst 
        Write-Host "Copied file : $FileDst" -ForegroundColor Green
    }

       <#
        .SYNOPSIS
        Fill the corresponding folder in the destination with the source folder,
        if destination folder is empty.

        .DESCRIPTION
        Fill the corresponding folder in the destination with the source folder,
        if destination folder is empty.

        .PARAMETER Src
        Source folder.

        .PARAMETER Dst
        Destination folder.
    #>
} 

$global:Location = "F:\"
$global:SaveLocation = "D:\USB\"
$Src = "F:\Developpement\Powershell"
$Dst = "D:\USB\Developpement\Powershell"

## Get files in src
$SrcFiles = Get-Files $Src

## Get files in dest
$DstFiles = Get-Files $Dst

if ($DstFiles.Count -eq 0) 
{
    UpdateIfNeed $Src $Dst
} 
else 
{
    $Differences = CompareSrcDst $SrcFiles $DstFiles
    UpdateDifferences $Differences
}