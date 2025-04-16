function ni
    npm install $argv
end

function nrs
    npm run start -s -- $argv
end

function nrb
    npm run build -s -- $argv
end

function nrd
    npm run dev -s -- $argv
end

function nrt
    npm run test -s -- $argv
end

function nrtw
    npm run test:watch -s -- $argv
end

function nrv
    npm run validate -s -- $argv
end

function rnm
    rm -rf node_modules $argv
end

function npxctt
    npx create-react-app --template typescript $argv
end

function npxc
    npx create-react-app $argv
end

