function dc
    docker container $argv
end

function di
    docker image $argv
end

function dv
    docker volume $argv
end

function dn
    docker network $argv
end

function dps
    docker ps $argv
end

function dcstop
    docker-compose stop $argv
end

function dcrst
    docker-compose restart $argv
end

function dcup
    docker-compose up -d $argv
end

function dcrm
    docker-compose rm --all $argv
end

