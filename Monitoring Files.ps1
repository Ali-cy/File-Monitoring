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
    # Load file|hash from baseline.txt and store them in a dictionary 
    $filePathsAndHashes = Get-Content -Path .\baseline.txt
    foreach ($file in $filePathsAndHashes){  # <-- Changed $f to $file
        $fileHashDictionary.add($file.Split("|")[0], $file.Split("|")[1])
    }     
    
    # Begin (Continuously) monitoring files with saved Baseline
    while($true){
        Start-Sleep -Seconds 2 
        
        $file = Get-ChildItem -Path .\Files

        foreach ($f in $filehash) {
            $hash = CalculateFileHash $f.FullName
            
            if ($fileHashDictionary.ContainsKey($hash.Path) -eq $null){
                # A new file has been created!
                Write-Host "$($hash.Path) has been created!" -ForegroundColor Green
                $fileHashDictionary[$hash.Path] = $hash.Hash
            }
            else {
                # Notify if a new file has been changed
                if ($fileHashDictionary[$hash.Path] -eq $hash.Hash) {
                    # The file has not changed
                }
                else {
                    # File has been compromised!, notify the user
                    Write-Host "$($hash.Path) has changed!!!" -ForegroundColor Yellow
                }
            }
        }

        foreach ($key in $fileHashDictionary.Keys) {
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineFileStillExists) {
                # One of the baseline files must have been deleted, notify the user
                Write-Host "$($key) has been deleted!" -ForegroundColor DarkRed -BackgroundColor Gray
            }
        }
    }
}
