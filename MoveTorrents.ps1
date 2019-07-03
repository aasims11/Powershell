$(
#env vars
$stageDir='E:\Stage'
$sDir='E:\Videos\Series'
$sourceDir='D:\Torrents'
#$kidsSDir='E:\Videos\Kids Shows'


#hash table to translate diffs with filenames vs directories using wildcards
$showName= @{'simpsons' = 'simpsons';  'bobs.burgers' = 'bobs burgers';'young.sheldon' = "Young Sheldon"; 'family.guy' = 'Family Guy'; 'big.bang.theory' = 'Big Bang Theory'; 'goldbergs' = 'goldbergs';
 'american.dad' = 'American Dad';'NCIS.New' = 'NCIS_NewOrleans'; 'NCIS.Los' = 'NCIS_LA'; 'NCIS.S' = 'NCIS' }

#create list of torrents that have been downloaded last day and save the name to a var
$list=Get-ChildItem $sourceDir | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-1)} | Select-Object -ExpandProperty Name
Write-Output "Start Scheduled Move - $(Get-Date -format "MM-dd-yyyy hh:mm:ss")"
#check for dirs for later use in automapping?
#$seriesList = Get-ChildItem 'E:\videos\Series'
#Write-Output $seriesList | Select-Object -ExpandProperty Name

#MatchShow loops through keys in the hashtable from the filelist in dropzone
Function MatchShow($f){
  foreach ($s in $showName.Keys){
   
  if ($f -like "*$s*"){
    Write-Output "Found Match in Series"
    $show = $showName.$s
    Write-Output "Copying $f to $sDir\$show"
    Copy-Item "$stageDir\Dropzone\$f" "$sDir\$show" -Force
    $result= Test-Path "$sDir\$show\$f"
     
    if ($result -eq 'true'){
    Write-Output "$f moved to the correct folder`n"
    Write-output "Removing $f from Staging Directory"
    Remove-Item "$stageDir\Dropzone\$f" 
    Write-output "$f is still present in Dropzone:" 
    Test-Path "$stageDir\Dropzone\$f"
    Write-output "`n"
    }
    else{
    Write-Output "$f did not copy to $sDir\$show`n"
    }
    
}
    
}
}#/function
 Function ExtractFiles(){
 #for each filename returned unzip to stage and overwrite if present
    foreach ($l in $list){
      Write-output $l
      $file = get-childitem "$sourceDir\$l\" | Where-Object {$_.Name -like "*.avi" -or $_.Name -like "*.mkv"} | Select-Object -ExpandProperty Name
      write-output $file
      
      if ( $file -like "*.avi" -or $file -like "*.mkv" -or -$file -like '*.mp4' -and $file.length -gt 100mb){
        Write-output "Moving $file to Stage"
        copy-item -Path "$sourceDir\$l\$file" -destination "$stageDir\Dropzone"
      }
    
      else {
        try {
    Write-Output "This file is being extracted $l"
    7z.exe x $sourceDir\$l\$l.rar -o"$stageDir\Dropzone" -aoa
      }
      catch {
            Write-Output "File did not extract"
      }
    }
   }

 }#/function
#Actions (main)

 ExtractFiles
 #get list of files in dropzone from extract job
$files = Get-ChildItem "E:\Stage\Dropzone" | Select-Object -ExpandProperty Name 
Write-Output "filelist:`n $files"
foreach ($f in $files){
 MatchShow($f)
}

##clean up remaining files in Drop
$files = Get-ChildItem "E:\Stage\Dropzone" | Select-Object -ExpandProperty Name
if ($files.Count -gt 1){
  foreach ($f in $files){
    ##TODO need to wrap movies eval in function with additional types
    if ($f -like '*bdrip*' -or $f -like "*bluray*" -or $f -like '*hdrip*' -or $f -like '*dvdrip*'){
      Write-Output  "Found a Movie $f"
      Copy-Item "$stageDir\Dropzone\$f" "E:\videos\movies"
      Write-Output  "Copy Successful:" 
      Test-Path "E:\videos\movies\$f"
      Write-output "Removing $f from Staging Directory"
      Remove-Item "$stageDir\Dropzone\$f" 
      Write-output "File Present in DropZone: " 
      Test-Path "$stageDir\Dropzone\$f"
    }
    else{
      ##TODO wrap final cleanup in function
    Write-Output "No Match - $f moving to Undefined`n"
    Copy-Item "$stageDir\Dropzone\$f" "E:\Stage\Undefined" 
    $r=Test-Path "E:\Stage\Undefined\$f"
     if ( $r -eq 'True'){
      Write-output "Removing $f from Staging Directory"
      Remove-Item "$stageDir\Dropzone\$f" 
      Write-output "File Present in DropZone:"
      Test-Path "$stageDir\Dropzone\$f"
     }
    else{
      write-output "$f did not copy - Breaking operation"
      exit(1)
    }
  }
  }
}


Write-Output "Stop Scheduled Move - $(Get-Date -format "MM-dd-yyyy hh:mm:ss")"
 #output log to log dir
 ) *>&1 > E:\stage\logs\log.txt
