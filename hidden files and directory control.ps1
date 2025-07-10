# For document and/or music folders only! do not use on system (or software) directories!
# Attenzione: This script will search for hidden files in the specified directory and its subdirectories.
# It will prompt the user to delete each hidden file found. 
# Define the directory to search
# Change this to the directory you want to search
# Example: "C:\Users\thyke\Documenti"
$directory = "C:\Users\tyk\Downloads" # "C:\Users\thyke\Music" #"C:\Users\thyke\Documents\Nuova cartella"

# Check if the directory exists
if (-Not (Test-Path -Path $directory)) {
    Write-Host "The specified directory does not exist." -ForegroundColor Red
    exit
}

# Search for hidden files
Write-Host "Searching for hidden files in $directory and its subdirectories..." -ForegroundColor Green
try {
    $hiddenFiles = Get-ChildItem -Path $directory -Recurse -Force -ErrorAction Stop | Where-Object { $_.Attributes -match "Hidden" }
} catch [System.UnauthorizedAccessException] {
    Write-Host "Access denied to one or more directories. Skipping inaccessible directories..." -ForegroundColor Yellow
    $hiddenFiles = @() # Initialize as an empty array to avoid errors
} catch {
    Write-Host "An unexpected error occurred while accessing directories: $($_.Exception.Message)" -ForegroundColor Red
    exit
}

# Display the results and provide delete option
if ($hiddenFiles) {
    Write-Host "Hidden files found:" -ForegroundColor Yellow
    foreach ($file in $hiddenFiles) {
        # Skip 'desktop.ini' files
        if ($file.Name -ieq "desktop.ini") {
            Write-Host "File skipped (desktop.ini): $($file.FullName)" -ForegroundColor Yellow
            continue
        }
        Write-Host "File: $($file.FullName)" -ForegroundColor Cyan
        $response = Read-Host "Do you want to delete this file? (Y/N)"
        if ($response -eq "Y" -or $response -eq "y") {
            try {
                Remove-Item -Path $file.FullName -Force
                Write-Host "File deleted: $($file.FullName)" -ForegroundColor Green
            } catch [System.UnauthorizedAccessException] {
                Write-Host "Access denied: Unable to delete file $($file.FullName)" -ForegroundColor Red
            } catch {
                Write-Host "Failed to delete file: $($file.FullName)" -ForegroundColor Red
            }
        } else {
            Write-Host "File skipped: $($file.FullName)" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "No hidden files found." -ForegroundColor Cyan
}
