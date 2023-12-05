# File Monitoring and Baseline Generation with PowerShell

This PowerShell script offers functionalities to either collect a new baseline or begin monitoring files with a saved baseline for changes. It uses file hashing to detect modifications and is designed for basic file monitoring and data integrity checks.

## Features:

- **Baseline Creation:** Option to create a new baseline by calculating file hashes.
- **File Monitoring:** Continuous monitoring of files against the saved baseline to detect newly created files.
- **SHA512 Hashing:** Utilizes SHA512 hashing algorithm for file integrity verification.

## Usage:

1. **Run the Script:**
   - Execute the PowerShell script (`file_monitoring.ps1` or similar) in PowerShell environment.

2. **Choose an Action:**
   - The script prompts the user to enter 'A' to collect a new baseline or 'B' to begin monitoring.

3. **Functionality Details:**
   - **Collect New Baseline (A):**
     - Deletes the existing baseline if present.
     - Calculates file hashes for files in the specified folder and writes them to `baseline.txt`.

   - **Begin Monitoring (B):**
     - Loads hashes from `baseline.txt` and starts monitoring files.
     - Detects and displays newly created files.

4. **Important Notes:**
   - Ensure PowerShell script execution policy allows running scripts.
   - Adjust folder paths and file names as needed in the script.

## Code Details:

- **CalculateFileHash:** Function to calculate the SHA512 hash of a file.
- **EraseBaselineIfAlreadyExists:** Function to delete the baseline file if it exists.
- **Monitoring Loop:** Infinite loop for continuous file monitoring.

## Usage Example:

1. Running the script:

    ```powershell
    .\file_monitoring.ps1
    ```

2. User input:

    ```
    What would you like to do?
    A) Collect new Baseline?
    B) Begin monitoring files with saved Baseline?
    ```

    User enters 'A' or 'B' based on the desired action.

## Credits:

- The script utilizes PowerShell's `Get-FileHash`, `Test-Path`, `Remove-Item`, and other built-in cmdlets.
- SHA512 hashing implemented using PowerShell's native functionality.

Feel free to adapt and modify the script according to your specific requirements or folder structures.


