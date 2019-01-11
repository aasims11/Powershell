#$(
#env vars
$stageDir='E:\Stage'
$sDir='E:\Videos\Series'
$sourceDir='D:\Torrents'
$kidsSDir='E:\Videos\Kids Shows'
#create list of torrents that have been downloaded last day and save the name to a var
$list=Get-ChildItem $sourceDir | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-7)} | Select-Object -ExpandProperty Name


#blocks to wrap around script body to output to log
# 
#



 Function ExtractFiles(){
 #for each filename returned unzip to stage and overwrite if present
    foreach ($l in $list){
    Write-Output "This file is being extracted $l"
    7z.exe x $sourceDir\$l\$l.rar -o"$stageDir\" -aoa
   }

 }#/function

 Function SeriesCheck(){
 #Examine file and try to match against current dir

$files = Get-ChildItem E:\Stage | Select-Object -ExpandProperty Name 
Write-Output "filelist:`n $files"
#for each file check against known shows and move to the correct series folder
foreach ($f in $files){


if ($f -like "*Young*Sheldon*"){
   Write-Output "Found Young Sheldon"
   Write-Output "Copying $f to $sDir\Young Sheldon"
   Copy-Item "$stageDir\$f" "$sDir\Young Sheldon" -Force
   $result= Test-Path "$sDir\Young Sheldon\$f"
    
   if ($result -eq 'true'){
   Write-Output "$f moved to the correct folder`n"
   Write-output "Removing $f from Staging Directory"
   Remove-Item "$stageDir\$f" 
   Test-Path "$stageDir\$f"
   }
   else{
   Write-Output "$f did not copy to $sDir\Young Sheldon`n"
   }
  } 
  elseif ($f -like "*Family*Guy*"){
  Write-Output "Found Family Guy"
  Write-Output "Copying $f to $sDir\Family Guy"
  Copy-Item "$stageDir\$f" "$sDir\Family Guy" -Force
  $result= Test-Path "$sDir\Family Guy\$f"
   
  if ($result -eq 'true'){
  Write-Output "$f moved to the correct folder`n"
  Write-output "Removing $f from Staging Directory"
  Remove-Item "$stageDir\$f" 
  Test-Path "$stageDir\$f"
  }
  else{
  Write-Output "$f did not copy to $sDir\Family Guy`n"
  }
  } 
 elseif ($f -like "*Big*Bang*"){
   Write-Output "Found Big Bang"
   Write-Output "Copying $f to $sDir\Big Bang Theory"
   Copy-Item "$stageDir\$f" "$sDir\Big Bang Theory" -Force
   $result= Test-Path "$sDir\Big Bang Theory\$f"

   if ($result -eq 'true'){
   Write-Output "$f moved to the correct folder`n" 
   Write-output "Removing $f from Staging Directory"
   Remove-Item "$stageDir\$f" 
   Test-Path "$stageDir\$f"
   }
   else{
   Write-Output "$f did not copy to $sDir\Big Bang Theory`n"
   }
 }

   elseif ($f -like "*Goldbergs*"){
   Write-Output "Found Goldbergs"
   Write-Output "Copying $f to $sDir\Goldbergs"
   Copy-Item "$stageDir\$f" "$sDir\Goldbergs" -Force
   $result= Test-Path "$sDir\Goldbergs\$f"

   if ($result -eq 'true'){
   Write-Output "$f moved to the correct folder`n" 
   Write-output "Removing $f from Staging Directory"
   Remove-Item "$stageDir\$f" 
   Test-Path "$stageDir\$f"
   }
   else{
   Write-Output "$f did not copy to $sDir\Goldbergs`n"
   }
   }
   #kids shows
   elseif ($f -like "*Ducktales*"){
   Write-Output "Found Ducktales"
   Write-Output "Copying $f to $kidsSDir\Ducktales"
   Copy-Item "$stageDir\$f" "$kidsSDir\Ducktales 2017" -Force
   $result= Test-Path "$kidsSDir\Ducktales 2017\$f"

   if ($result -eq 'true'){
   Write-Output "$f moved to the correct folder`n" 
   Write-output "Removing $f from Staging Directory"
   Remove-Item "$stageDir\$f" 
   Test-Path "$stageDir\$f"
   }
   else{
   Write-Output "$f did not copy to $sDir\Ducktales`n"
   }
   }
   else {
     Copy-Item "$stageDir\$f" "$stageDir\Undefined" 
     Write-Output "No Match - $f moving to Undefined`n"
     Write-output "Removing $f from Staging Directory"
     Remove-Item "$stageDir\$f" 
     Test-Path "$stageDir\$f"
   }
  }
 }#/function



 ExtractFiles

 SeriesCheck
 #) *>&1 > $stageDir\logs\log.txt