#!/bin/env sh

this_dir="$(pwd)"
base_dir_name="$(basename $this_dir)"

if [ "$base_dir_name" != "quiversinapot-mxgraph-dist" ]
then
    echo "It's not safe to run this scripts from a directory other than 'quiersinapot-mxgraph-dist'"
    exit 1
fi

if [ -d ./quiversinapot-mxgraph ]
then
    cd "quiversinapot-mxgraph" &&
        git fetch --all &&
        git checkout -B backup-master &&
        git reset --hard origin/master
    cd "$this_dir" || exit
else
    git clone --depth=1 "https://gitlab.com/spellcard199/quiversinapot-mxgraph.git"
fi

cd quiversinapot-mxgraph &&
    npm install &&
    ./node_modules/webpack-cli/bin/cli.js &&
    cd "$this_dir" &&
    cp quiversinapot-mxgraph/dist/bundle.js ./ &&
    git add . &&
    git commit -am "wip" &&
    git checkout --orphan latest_branch &&
    git add -A &&
    git commit -am "wip" &&
    git branch -D master &&
    git branch -m master &&
    sleep 1 &&
    git gc --aggressive --prune=all &&
    sleep 1 &&
    git push -f origin master
