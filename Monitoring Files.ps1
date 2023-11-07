Write-Host "What would you like to do?"
Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin monitoring files with saved Baseline?"

$response = Read-Host -Prompt "please enter 'A' or 'B'"

Function CalculateFileHash($filepath){
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

Function EraseBaselineIfAlreadyExists(){
    $baselineExists = Test-Path -Path .\baseline.txt
    if ($baselineExists){
        #Delete it
        Remove-Item -Path .\baseline.txt
    }
}

if ($response -eq "A". ToUpper()) {
    #Delete baseline.txt is it already exists
    EraseBaselineIfAlreadyExists
    
    #Calculate Hash from the target files and store in baseline.txt
    Write-Host "Calculate Hashes, make new baseline.txt" -ForegroundColor Red
    #Collect all files in the target folder
    $filehash = Get-ChildItem -Path .\Files

    #For each file. Calculate the hash, and write to baseline.txt
    foreach ($file in $filehash) {
       $hash = CalculateFileHash $f.FullName
       "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
    }

}
elseif ($response -eq "B".ToUpper()){
    $fileHashDictionary = @{}
    #Load file|hash from basline.txt and store them in a dictionary 
    $filePathsAndHashes = Get-Content -Path .\baseline.txt
    foreach ($f in $filePathsAndHashes){
        $path, $hash = $f -split "\\|"
        $fileHashDictionary[$path] = $hash
    }     
    
    #Begin (Continuously) monitoring files with saved Baseline
    while($true){
        Start-Sleep -Seconds 2 
        
        $file = Get-ChildItem -Path .\Files

        foreach ($f in $filehash) {
            $hash = CalculateFileHash $f.FullName
            
            if ($fileHashDictionary.ContainsKey($hash.Path) -eq $false){
                #A new file has been created!
                Write-Host "$($hash.Path) has been created!" -Foregroundcolor Green
                $fileHashDictionary[$hash.Path] = $hash.Hash
            }
    }
    Write-Host "Read existing baseline.txt, start monitoring files." -ForegroundColor Yellow
}
}