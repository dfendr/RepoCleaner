#!/bin/bash

# Initialize variables
GITHUB_USER=""
REPO=""

display_help() {
	echo "Usage: $0 [options]"
	echo
	echo "This script clones a GitHub repository, wipes sensitive info from commits,"
	echo "and then pushes the changes back."
	echo
	echo "Options:"
	echo "  -u <user>    GitHub username"
	echo "  -r <repo>    GitHub repository name"
	echo "  -h           Display this help menu"
	echo
}

parse_options() {
	while getopts "u:r:h" opt; do
		case $opt in
		u) GITHUB_USER="$OPTARG" ;;
		r) REPO="$OPTARG" ;;
		h)
			display_help
			exit 0
			;;
		*)
			echo "Invalid option: -$OPTARG" >&2
			display_help
			exit 1
			;;
		esac
	done
}

delete_old_repo() {
	if test -d "$REPO.git"; then
		echo "Deleting Stale Repo..."
		sudo rm -rf "$REPO.git" || {
			echo "Failed to delete repo"
			exit 1
		}
	fi
}

clone_repo() {
	echo "Downloading Fresh Repo..."
	git clone --mirror https://github.com/"$GITHUB_USER"/"$REPO".git ||
		{
			echo "Failed to clone repo"
			exit 1
		}
}

wipe_info() {
	java -jar bfg-1.14.0.jar --replace-text passwords.txt "$REPO" ||
		{
			echo "Failed to wipe info"
			exit 1
		}
	cd "$REPO.git" || {
		echo "Failed to change directory"
		exit 1
	}
	git reflog expire --expire=now --all ||
		{
			echo "Failed to expire reflog"
			exit 1
		}
	git gc --prune=now --aggressive ||
		{
			echo "Failed to garbage collect"
			exit 1
		}
}

update_repo() {
	git push || {
		echo "Failed to update repo"
		exit 1
	}
	cd .. || {
		echo "Failed to change directory"
		exit 1
	}
	sudo rm -rf "$REPO.git" || {
		echo "Failed to delete repo"
		exit 1
	}
}

main() {
	# Get the directory where the script is located
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
	cd "$SCRIPT_DIR" || {
		echo "Failed to change directory"
		exit 1
	}

	# Call functions
	parse_options "$@"
	delete_old_repo
	clone_repo
	wipe_info
	update_repo
}

# Execute main function with all arguments passed to the script
main "$@"
