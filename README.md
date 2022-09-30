# Configuring for the first time

If you're starting from scratch, go ahead and create a .dotfiles folder, which we'll use to track your dotfiles

`git init --bare $HOME/.dotfiles`

create an alias `dotfiles` so you don't need to type it all over again

`alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

set git status to hide untracked files

`dotfiles config --local status.showUntrackedFiles no`

add the alias to .bashrc (or .zshrc) so you can use it later

`echo "\nalias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc`

Usage

Now you can use regular git commands such as:

```
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "Add vimrc"
dotfiles add .bashrc
dotfiles commit -m "Add bashrc"
dotfiles push
```

# Setup environment in a new computer

Make sure to have git installed, then clone your github repository:

`git clone --bare https://github.com/USERNAME/dotfiles.git $HOME/.dotfiles`

Define the alias in the current shell scope

`alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

Set git status to hide untracked files

`dotfiles config --local status.showUntrackedFiles no`

Checkout the actual content from the git repository to your $HOME

`dotfiles checkout`

Note that if you already have some of the files you'll get an error message. You can either (1) delete them or (2) back them up somewhere else. It's up to you.

Awesome! You’re done.

Source: https://medium.com/toutsbrasil/how-to-manage-your-dotfiles-with-git-f7aeed8adf8b
