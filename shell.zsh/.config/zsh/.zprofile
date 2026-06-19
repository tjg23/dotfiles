
eval "$(/opt/homebrew/bin/brew shellenv)"
source <(fzf --zsh)

source <(COMPLETE=zsh jj)

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"

export ANTHROPIC_API_KEY=$(security find-generic-password -gs "ANTHROPIC_API_KEY" -w)

# Setting PATH for Python 3.13
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
export PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

path+=(~/.local/bin)
path+=(~/.bun/bin)
path+=(/Library/TeX)
path+=(/opt/apache-maven-3.9.9/bin)
path+=(/Library/NuSMV-2.6.0-Darwin/bin)
path+=$JAVA_HOME/bin
export PATH

# Added by Toolbox App
export PATH="$PATH:/Users/tjgorton/Library/Application Support/JetBrains/Toolbox/scripts"

