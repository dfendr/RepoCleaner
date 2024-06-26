# RepoCleaner

RepoCleaner is a utility script for wiping sensitive data from your git repositories. 
This tool is available for both Linux/Unix (RepoCleaner.sh) and
Windows (RepoCleaner.ps1).

## Prerequisites

- Git
- Java Runtime Environment (for running BFG)

## Repository Contents

- `RepoCleaner.sh`: Bash script for Linux/Unix environments.
- `RepoCleaner.ps1`: PowerShell script for Windows environments.
- `passwords.txt`: A blank text file where you can list sensitive information
  to be wiped from the repository.
- `bfg-1.14.0.jar`: The BFG Repo-Cleaner jar file.

## Usage

> **Note**: This program is designed to wipe sensitive information from **past
> commits**. Make sure the repository is currently free of sensitive data before
> running the script.

### Linux/Unix

1. Make the script executable:

   ```bash
   chmod +x RepoCleaner.sh
   ```

2. Run the script with the required flags:

   ```bash
   ./RepoCleaner.sh -u <GitHub_User> -r <Repo_Name>
   ```

   Or:

   ```bash
   ./RepoCleaner.sh -l https://github.com/<GitHub_User>/<Repo_Name>.git
   ```

#### Flags

- `-u`: GitHub username
- `-r`: GitHub repository name
- `-l`: GitHub repository URL
- `-h`: Display help menu

### Windows

1. Open PowerShell as an administrator.

2. Run the script:

   ```powershell
   .\RepoCleaner.ps1 -GitHubUser <GitHub_User> -Repo <Repo_Name>
   ```

   Or:

   ```powershell
   .\RepoCleaner.ps1 -Url https://github.com/<GitHub_User>/<Repo_Name>.git
   ```

#### Flags

- `-GitHubUser`: GitHub username
- `-Repo`: GitHub repository name
- `-Url`: GitHub repository URL
- `-Help`: Display help menu

## passwords.txt

Add any sensitive information that you want to wipe from the repository to this
file. Each piece of information should be on a new line.



### files.txt

Add the filenames that you want to delete from the repository's history to this
file. Each filename should be on a new line. If the file is located in a
subdirectory, include the relative path from the repository root.

Example:
```
passwords_old.txt
config/secret_config.yaml
scripts/unused_script.sh
```


>Note: Ensure you have backed up any files you intend to remove from history,
as this operation is irreversible.

## Contributing

Feel free to open issues or submit pull requests. Your contributions are welcome!
