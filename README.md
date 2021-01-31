# MakesLifeEasier
Scripts to help me in my daily life.

![Alt text](powershell.png?raw=true "Title")

## Features  
• Save : Allows you to save all files modified after a date written in "update.txt".  
• CompareSave : Compares the source and destination tree structure, deletes missing files and backs up present files.

## Documentation  
• Save script doesn't needs any arguments, replace $Src and $Dst by your path.  

```ps1
./Save.ps1  
```

• CompareSave script needs 2 args, source and destination to compare.

```ps1
./CompareSave.ps1 FolderSrc FolderDst  
```
