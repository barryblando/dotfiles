if type -q eza
    function ls
        eza --icons $argv
    end

    function la
        eza --icons --long --all --group $argv
    end
end

