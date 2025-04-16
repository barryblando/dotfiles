function zshrc
    nvim ~/.zshrc
end

function zshhistory
    nvim ~/.zsh_history
end

function md
    mkdir $argv
end

function ..
    cd .. $argv
end

function ...
    cd ../.. $argv
end

function sourceslist
    sudo vi /etc/apt/sources.list $argv
end

function ovim
    vim $argv
end

function v
    nvim $argv
end

function pip
    pip3 $argv
end

function python
    python3 $argv
end

function freecachemem
    sync; echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
end

