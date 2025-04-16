function gc
    git checkout $argv
end

function gcm
    git checkout master
end

function gs
    git status
end

function gpull
    git pull
end

function gf
    git fetch $argv
end

function gfa
    git fetch --all
end

function gpush
    git push $argv
end

function gpushf
    git push -f $argv
end

function gd
    git diff $argv
end

function ga
    git add . $argv
end

function glog
    git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --branches $argv
end

function gb
    git branch $argv
end

function gbr
    git branch -r $argv
end

function gfr
    git remote update $argv
end

function gbn
    git checkout -B $argv
end

function grf
    git reflog $argv
end

function grh
    git reset HEAD~ $argv
end

function gac
    git add . && git commit -a -m $argv
end

function gsu
    git push --set-upstream origin $argv
end

