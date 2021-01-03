$src = "F:\"
$dst = "D:\USB"
$file_updates = "F:\Developpement\Powershell\MakesLifeEasier\ToSave\update.txt"

if (test-Path $file_updates) 
{
    $last_update = Get-Content $file_updates
}
else
{
    $last_update = (Get-Date).AddDays(-1)
}

$nb_copy = 0
$nb_new_folder = 0

# update file with last update
Set-Content -Path $file_updates -Value (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")

$updated_files = Get-ChildItem -Path $src -Recurse | Where { $_.LastWriteTime -gt $last_update -and $_.Mode -notlike "d*"}

Write-Host "`nModified : $($updated_files.Count)"
Write-Host "`n"

foreach ($file in $updated_files) 
{
    Write-Host $file.FullName -ForegroundColor Yellow
}

Write-Host "`n"

foreach ($file in $updated_files) 
{
    $file_full_name = $file.FullName                                                                # file full name           
    $elts = $file_full_name -split "\\"
    $without_file_name = $file_full_name.Substring(0, $file_full_name.Length - $elts[-1].Length)    # remove file name to get only folders
    $dst_folder = $dst + $without_file_name.Substring(2)                                            # folder to create if don't exist

    if (-Not(Test-Path $dst_folder)) 
    {
        New-Item -Path $dst_folder -ItemType "directory"
        Write-Host "Added folder : $dst_folder" -ForegroundColor Green
        $nb_new_folder++
    }

    $build_dst = $($dst + $file_full_name.Substring(2))    # remove F:

    Copy-Item $file_full_name -Destination $build_dst
    Write-Host "Copied file : $build_dst" -ForegroundColor Green
    $nb_copy++
}

Write-Host "`nCreated folder(s) : $nb_new_folder"
Write-Host "Copied file(s) : $nb_copy"