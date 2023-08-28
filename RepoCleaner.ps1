param (
    [string]$GitHubUser,
    [string]$Repo,
    [switch]$Help
)

function Display-Help {
    Write-Host "Usage: RepoCleaner.ps1 [options]"
    Write-Host ""
    Write-Host "This script clones a GitHub repository, wipes sensitive info from commits,"
    Write-Host "and then pushes the changes back."
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -GitHubUser <user>    GitHub username"
    Write-Host "  -Repo <repo>          GitHub repository name"
    Write-Host "  -Help                 Display this help menu"
    exit 0
}

function Delete-OldRepo {
    if (Test-Path $Repo) {
        Write-Host "Deleting Stale Repo..."
        Remove-Item -Recurse -Force $Repo -ErrorAction Stop
    }
}

function Clone-Repo {
    Write-Host "Downloading Fresh Repo..."
    git clone --mirror ("https://github.com/" + $GitHubUser + "/" + $Repo + ".git") -ErrorAction Stop
}

function Wipe-Info {
    java -jar .\bfg-1.14.0.jar --replace-text .\passwords.txt $Repo -ErrorAction Stop
    Set-Location -Path $Repo -ErrorAction Stop
    git reflog expire --expire=now --all -ErrorAction Stop
    git gc --prune=now --aggressive -ErrorAction Stop
}

function Update-Repo {
    git push -ErrorAction Stop
}

# Main script logic
if ($Help) {
    Display-Help
}

if (-not $GitHubUser -or -not $Repo) {
    Write-Host "Both GitHubUser and Repo are required."
    Display-Help
    exit 1
}

try {
    Delete-OldRepo
    Clone-Repo
    Wipe-Info
    Update-Repo
} catch {
    Write-Host "An error occurred: $_"
    exit 1
}

