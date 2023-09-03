# Rik's dotfiles
Quickly configure your Mac.

## CAUTION
**Use these scripts at your risk**

These scripts will modify several configurations of your Mac, and will override existing files also. Before proceeding further, review the code and choose what configurations best suit you, removing what you don't need.

## Installation

Clone the repository wherever you want and then choose what installation execute. You'll find details for each installation in the following sections.

```bash
git clone https://github.com/zankyr/dotfiles.git && cd dotfiles
```

### Homebrew formulae

I like to install some common [Homebrew](https://brew.sh/) formulae (after installing Homebrew, of course):

```bash
./brew/brew.sh
```

Some of the functionality of following dotfiles depends on formulae installed by `brew.sh`. If you don’t plan to run `brew.sh`, you should look carefully through the script and manually install any particularly important ones. A good example is Bash/Git completion: the dotfiles use a special version from Homebrew.

#### Extras
If you want useful CLI tools or apps, look into `./brew/brew-extras.sh` and select what you like.

### MacOs settings

This script will configure several MacOS settings (like screensaver and password request after a stop). Just execute it. Be careful that after the execution, several applications will be closed to update their configurations.

```bash
./.macos
```

### Dotfiles

To install the provided dotfiles in your system, execute the bootstrapper script with the `install` option.

```bash
source bootstrap.sh --install
```
or

```bash
source bootstrap.sh -i
```

This command will pull in the latest version and copy the files to your home folder.

To synchronize your current configurations to the repository (e.g. you added new aliases or functions and you don't want to search what files you modified), execute the script using the `update` option:
```bash
source bootstrap.sh --update
```
or

```bash
source bootstrap.sh -u
```
This task will read the `from-file.txt` in order to keep track of which files to update, and then will sync them from your home directory to the repository folder.


## Content
* brew.sh -> install several [Homebrew](https://brew.sh/) formulae. Should be executed standalone.
* .macos -> configure MacOs settings like TimeMachine, Dock and several others.
* bootstrap.sh -> install all the dotfiles described below or update them (see section).
* .aliases -> define useful aliases for the terminal.
* .bash_profile -> compile all the dotfiles and define several other comodities (like bash completion and pyenv).
* .bash_prompt -> configure the aspect (i.e. colors) for the terminal (and git also).
* .exports -> define common exports variables.
* .functions -> shortcuts that cannot be defined as simple aliases (like the extract command).
* .gitconfig -> define colors for git statuses and other git configurations.
* .gitignore_global -> global git ignore file
* .hushlogin -> disable several messages in the terminale during the login phase.
* .vimrc -> configurations for the vi text editor.
* .vim -> folder that contains working direcotries for vim (like backup and swap) and the theme configuration.
* init -> contain the Solarized Theme for the Terminal app.
* bin -> contain the [setleds](https://github.com/damieng/setledsmac) script.
* from-file -> list all the files and folders to syncronize (required for the bootstrap update command)

## Thanks to…

* [Mathias Bynens](https://mathiasbynens.be/) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
* [Damien Guard](https://damieng.com/) for the [backlight script repository](https://github.com/damieng/setledsmac)
