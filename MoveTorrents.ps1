#$(
#env vars
$stageDir='E:\Stage'
$sDir='E:\Videos\Series'
$sourceDir='D:\Torrents'
$kidsSDir='E:\Videos\Kids Shows'

#hash table to translate diffs with filenames vs directories using wildcards
$showName= @{'simpsons' = 'simpsons';  'bobs.burgers' = 'bobs burgers';'young.sheldon' = "Young Sheldon"; 'family.guy' = 'Family Guy'; 'big.bang.theory' = 'Big Bang Theory'; 'goldbergs' = 'goldbergs';
 'american.dad' = 'American Dad';'NCIS.New' = 'NCIS_NewOrleans'; 'NCIS.Los' = 'NCIS_LA'; 'NCIS.S' = 'NCIS' }
$seriesList = Get-ChildItem 'E:\videos\Series'
#create list of torrents that have been downloaded last day and save the name to a var
$list=Get-ChildItem $sourceDir | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-7)} | Select-Object -ExpandProperty Name
#check for dirs
Write-Output $seriesList | Select-Object -ExpandProperty Name
#blocks to wrap around script body to output to log
# 
#
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
    Write-Output "This file is being extracted $l"
    7z.exe x $sourceDir\$l\$l.rar -o"$stageDir\Dropzone" -aoa
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
    ##TODO need to wrap movies eval in function
    if ($f -like '*bdrip*'){
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
      write-out "$f did not copy - Breaking operation"
      exit(1)
    }
  }
  }
}
 #Old Logic using if-else for matching
 Function SeriesCheck(){
 #Examine file and try to match against current dir

$files = Get-ChildItem "E:\Stage\Dropzone" | Select-Object -ExpandProperty Name 
Write-Output "filelist:`n $files`n"
#for each file check against known shows and move to the correct series folder
foreach ($f in $files){


if ($f -like "*Young*Sheldon*"){
   Write-Output "Found Young Sheldon"
   Write-Output "Copying $f to $sDir\Young Sheldon"
   Copy-Item "$stageDir\Dropzone\$f" "$sDir\Young Sheldon" -Force
   $result= Test-Path "$sDir\Young Sheldon\$f"
    
   if ($result -eq 'true'){
   Write-Output "$f moved to the correct folder`n"
   Write-output "Removing $f from Staging Directory"
   Remove-Item "$stageDir\Dropzone\$f" 
   Test-Path "$stageDir\Dropzone\$f"
   }
   else{
   Write-Output "$f did not copy to $sDir\Young Sheldon`n"
   }
  } 
  elseif ($f -like "*Family*Guy*"){
  Write-Output "Found Family Guy"
  Write-Output "Copying $f to $sDir\Family Guy"
  Copy-Item "$stageDir\Dropzone\$f" "$sDir\Family Guy" -Force
  $result= Test-Path "$sDir\Family Guy\$f"
   
  if ($result -eq 'true'){
  Write-Output "$f moved to the correct folder`n"
  Write-output "Removing $f from Staging Directory"
  Remove-Item "$stageDir\Dropzone\$f" 
  Test-Path "$stageDir\Dropzone\$f"
  }
  else{
  Write-Output "$f did not copy to $sDir\Family Guy`n"
  }
  } 
 elseif ($f -like "*Big*Bang*"){
   Write-Output "Found Big Bang"
   Write-Output "Copying $f to $sDir\Big Bang Theory"
   Copy-Item "$stageDir\Dropzone\$f" "$sDir\Big Bang Theory" -Force
   $result= Test-Path "$sDir\Big Bang Theory\$f"

   if ($result -eq 'true'){
   Write-Output "$f moved to the correct folder`n" 
   Write-output "Removing $f from Staging Directory"
   Remove-Item "$stageDir\Dropzone\$f" 
   Test-Path "$stageDir\Dropzone\$f"
   }
   else{
   Write-Output "$f did not copy to $sDir\Big Bang Theory`n"
   }
 }

   elseif ($f -like "*Goldbergs*"){
   Write-Output "Found Goldbergs"
   Write-Output "Copying $f to $sDir\Goldbergs"
   Copy-Item "$stageDir\Dropzone\$f" "$sDir\Goldbergs" -Force
   $result= Test-Path "$sDir\Goldbergs\$f"

   if ($result -eq 'true'){
   Write-Output "$f moved to the correct folder`n" 
   Write-output "Removing $f from Staging Directory"
   Remove-Item "$stageDir\Dropzone\$f" 
   Test-Path "$stageDir\Dropzone\$f"
   }
   else{
   Write-Output "$f did not copy to $sDir\Goldbergs`n"
   }
   }
   elseif ($f -like "*simpsons*"){
    Write-Output "Found Simpsons"
    Write-Output "Copying $f to $sDir\simpsons"
    Copy-Item "$stageDir\Dropzone\$f" "$sDir\simpsons" -Force
    $result= Test-Path "$sDir\simpsons\$f"
 
    if ($result -eq 'true'){
    Write-Output "$f moved to the correct folder`n" 
    Write-output "Removing $f from Staging Directory"
    Remove-Item "$stageDir\Dropzone\$f" 
    Test-Path "$stageDir\Dropzone\$f"
    }
    else{
    Write-Output "$f did not copy to $sDir\Simpsons`n"
    }
    }
    elseif ($f -like "*bobs*burgers*"){
      Write-Output "Found Bobs Burgers"
      Write-Output "Copying $f to $sDir\Bobs Burgers"
      Copy-Item "$stageDir\Dropzone\$f" "$sDir\Bobs Burgers" -Force
      $result= Test-Path "$sDir\Bobs Burgers\$f"
   
      if ($result -eq 'true'){
      Write-Output "$f moved to the correct folder`n" 
      Write-output "Removing $f from Staging Directory"
      Remove-Item "$stageDir\Dropzone\$f" 
      Test-Path "$stageDir\Dropzone\$f"
      }
      else{
      Write-Output "$f did not copy to $sDir\Bobs Burgers`n"
      }
      }
   #kids shows
   elseif ($f -like "*Ducktales*"){
   Write-Output "Found Ducktales"
   Write-Output "Copying $f to $kidsSDir\Ducktales"
   Copy-Item "$stageDir\Dropzone\$f" "$kidsSDir\Ducktales 2017" -Force
   $result= Test-Path "$kidsSDir\Ducktales 2017\$f"

   if ($result -eq 'true'){
   Write-Output "$f moved to the correct folder`n" 
   Write-output "Removing $f from Staging Directory"
   Remove-Item "$stageDir\Dropzone\$f" 
   Test-Path "$stageDir\Dropzone\$f"
   }
   else{
   Write-Output "$f did not copy to $sDir\Ducktales`n"
   }
   }
   
   else {
     Copy-Item "$stageDir\Dropzone\$f" "E:\Stage\Undefined" 
     Write-Output "No Match - $f moved to Undefined`n"
     Write-output "Removing $f from Staging Directory"
     Remove-Item "$stageDir\Dropzone\$f" 
     Test-Path "$stageDir\Dropzone\$f"
   }
  }
 }#/function
 
 #SeriesCheck

 
 
 #) *>&1 > $stageDir\logs\log.txt
