profile
=======
Set up some nice environment tools.
Install [homeshick](https://github.com/andsens/homeshick) and then clone castle:

    git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"

    homeshick clone pal/profile
    ln -s $HOME/.profile.d/init $HOME/.profile
