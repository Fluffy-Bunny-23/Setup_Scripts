# Development Environment Setup

Automated script to set up a development environment with tmux sessions for multiple projects. Built specifically for Google Cloud Shell.

## Usage

Run the setup script:

```bash
./setup.sh
```

## What it does

- Installs lazygit, opencode, and btop
- Creates tmux sessions for each project in `proj.json`
- Each project session includes: OCa, OCb, LG, Serv, and Bash windows
- Creates a general session with btop and additional windows
- Authenticates with GitHub

## Configuration

Edit `proj.json` to add or modify projects with the following fields:

- `git_url`: Repository URL
- `name`: Full project name
- `folder_name`: Directory name in `proj/` folder
- `short_name`: tmux session name
- `server_cmd`: Command to run in the Serv window
