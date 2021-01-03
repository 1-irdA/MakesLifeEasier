$src = "F:\"
$dst = "D:\USB"
$file_updates = "F:\Developpement\Powershell\MakesLifeEasier\ToSave\update.txt"
$last_update = Get-Content $file_updates

$nb_copy = 0
$nb_new_folder = 0

# update file with last update
Set-Content -Path $file_updates -Value (Get-Date).ToString("MM/dd/yyyy HH:mm:ss")

$updated_folders = Get-ChildItem -Path $src -Recurse | Where { $_.LastWriteTime -gt $last_update } | Where { $_.Mode -like "d*" }
$updated_files = Get-ChildItem -Path $src -Recurse | Where { $_.LastWriteTime -gt $last_update } | Where { $_.Mode -notlike "d*" }

foreach ($folder in $updated_folders) 
{
    $folder_full_name = $folder.FullName                    # folder full name
    $build_dst = $dst + $folder_full_name.Substring(2)      # remove F: and add dst in front

    Write-Host $build_dst -ForegroundColor Yellow

    if (-Not(Test-Path $build_dst))
    {
        New-Item -Path $build_dst -ItemType "directory"
        Write-Host "Added folder : $build_dst" -ForegroundColor Green
        $nb_new_folder++
    }  
}

foreach ($file in $updated_files) 
{
    $file_full_name = $file.FullName                       # file full name
    $build_dst = $($dst + $file_full_name.Substring(2))    # remove F:

    Write-Host $build_dst -ForegroundColor Yellow
    
    Copy-Item $file_full_name $build_dst
    Write-Host "Copied file : $build_dst" -ForegroundColor Green
    $nb_copy++
}

Write-Host "`nCreated folder(s) : $nb_new_folder"
Write-Host "Copied file(s) : $nb_copy"