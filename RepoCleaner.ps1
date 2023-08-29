param (
    [string]$GitHubUser,
    [string]$Repo,
    [string]$Url,
    [switch]$Help
)

function Display-Help
{
    Write-Host "Usage: RepoCleaner.ps1 [options]"
    Write-Host ""
    Write-Host "This script clones a GitHub repository, wipes sensitive info from commits,"
    Write-Host "and then pushes the changes back."
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -GitHubUser <user>    GitHub username"
    Write-Host "  -Repo <repo>          GitHub repository name"
    Write-Host "  -Url <url>            GitHub repository URL"
    Write-Host "  -Help                 Display this help menu"
    Write-Host ""
    Write-Host "Example URL: https://github.com/user/repo.git"
    Write-Host ""
}

function Delete-OldRepo
{
    if (Test-Path "$Repo.git")
    {
        Write-Host "Deleting Stale Repo..."
        Remove-Item -Recurse -Force "$Repo.git" -ErrorAction Stop
    }
}

function Clone-Repo
{
    Write-Host "Downloading Fresh Repo..."
    git clone --mirror ("https://github.com/" + $GitHubUser + "/" + $Repo + ".git") -ErrorAction Stop
}

function Wipe-Info
{
    java -jar .\bfg-1.14.0.jar --replace-text .\passwords.txt $Repo -ErrorAction Stop
    Set-Location -Path "$Repo.git" -ErrorAction Stop
    git reflog expire --expire=now --all -ErrorAction Stop
    git gc --prune=now --aggressive -ErrorAction Stop
}

function Update-Repo
{
    git push -ErrorAction Stop
    Set-Location -Path ".." -ErrorAction Stop
    Remove-Item -Recurse -Force "$Repo.git" -ErrorAction Stop
}

# Main script logic
if ($Help)
{
    Display-Help
}

# Append .git to URL if not present and extract GitHub user and repo
if ($Url)
{
    if (-not $Url.EndsWith(".git"))
    {
        $Url = "$Url.git"
    }
    $splitUrl = $Url -split '/'
    $GitHubUser = $splitUrl[-2]
    $Repo = ($splitUrl[-1] -replace '.git$', '')
}

if (-not $GitHubUser -or -not $Repo)
{
    Write-Host "Both GitHubUser and Repo are required."
    Display-Help
    exit 1
}

try
{
    Delete-OldRepo
    Clone-Repo
    Wipe-Info
    Update-Repo
} catch
{
    Write-Host "An error occurred: $_"
    exit 1
}

