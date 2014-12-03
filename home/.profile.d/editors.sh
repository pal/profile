#editors
if which mvim 2>&1 >/dev/null; then
  alias vi="mvim -v"
  alias vim='mvim -v'
fi

export EDITOR=subl
