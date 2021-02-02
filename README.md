# MakesLifeEasier

Scripts to help me in my daily life.

## Features  

• Save : Allows you to save all files modified after a date written in "update.txt".  
• CompareSave : Compares the source and destination tree structure, deletes missing files and backs up present files.  
• AnalyseLocalFile : Analyses the number of lines and comments (//, /**, /*, */, *) in a local code file.  
• AnalyseRemoteFile : Analyzes the number of lines and comments (//, /**, /*, */, *) in a raw code file.  
• SelfStorage : Store all file who corresponds with extensions in folder (ex: exemple.c => Moved in folder named 'C').

## Documentation  

• Save script doesn't needs any arguments, replace $Src and $Dst by your path.  

```ps1
./Save.ps1  
```

• CompareSave script needs 2 args, source and destination to compare.

```ps1
./CompareSave.ps1 FolderSrc FolderDst  
```

• AnalyseLocalCodeFile needs 1 arg, the path of file to analyse

```ps1
./AnalyseLocalFiles.ps1 PathFile 
```

• AnalyseRemoteCode needs 1 arg, the url of file to analyse

```ps1
.\AnalyseRemoteFile.ps1 UrlFile
```

• SelfStoage don't need argument

```ps1
.\SelfStoage.ps1
```

## Exemple

```ps1
.\AnalyseRemoteFile.ps1 "https://raw.githubusercontent.com/1-irdA/BinPacking/main/src/main.cpp" 
Number of comments : 18 / 75
Comments ratio : 24%
```