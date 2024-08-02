#!/bin/sh
# Bash script for download , create resource that can't add as git submodules
# [ Resource list ]
#  - vMenu 3.5.0 ( as in 28 December v3.6.0 is lastest relase and from release not it's require latest game build (2944) but I'm still using 2802 )
#  - oxmysql ( doesn't seem to require any game build native )

#* TODO: implement vMenu and oxmysql auto update

# ln -s $(readlink -f 'vendor/cfx-server-data/resources') 'resources/[base]'
# ln -s $(readlink -f 'vendor/esx_core/[core]') 'resources/[core]'
# docker path type stuff

log_file='build_res.log'

log() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $*"
    echo "[$timestamp] $*" >> "$log_file"
}

create_dir() {
    local folder_name="$1"

    if [ -d "$folder_name" ]; then
        log "[mkdir] '$folder_name' already exists."
    else
        mkdir "$folder_name"
        log "[mkdir] Created folder: $folder_name"
    fi
}

link_dir() {
    local folder_name="$2"

    if [ -h "$folder_name" ]; then
        log "[ln] '$folder_name' already exists."
    else
        ln -s "$1" "$2"
        log "[ln] link folder: $folder_name"
    fi
}

log "build_res Aug 2024. install vMenu and oxmyqsl"

res_dir='resources'
tmp_dir="$res_dir/temp"
lib_dir="$res_dir/[lib]"

create_dir "$res_dir"
create_dir "$tmp_dir"
create_dir "$lib_dir"

link_dir "../vendor/cfx-server-data/$res_dir" "$res_dir/[base]"
link_dir "../vendor/esx_core/[core]" "$res_dir/[core]"

if [ -d "$res_dir/vMenu" ]; then
    log "[vMenu] Found vMenu folder skip"
else
    log "[vMenu] vMenu not found download vMenu-v3.5.0"
    mkdir "$res_dir/vMenu"
    wget --progress=bar:force -O "$res_dir/temp/vMenu-v3.5.0.zip" "https://github.com/TomGrobbe/vMenu/releases/download/v3.5.0/vMenu-v3.5.0.zip" | log
    unzip -o "$tmp_dir/vMenu-v3.5.0.zip" -d "$res_dir/vMenu" >> "$tmp_dir/vMenu-v3.5.0.zip_log"
    log $(cat "$tmp_dir/vMenu-v3.5.0.zip_log")
fi

if [ -d "$res_dir/[lib]/oxmysql" ]; then
    log "[oxmysql] Found oxmysql folder skip"
else
    log "[oxmysql] oxmysql not found download oxmysql-latest"
    mkdir "$lib_dir/oxmysql"
    wget --progress=bar:force -O "$tmp_dir/oxmysql.zip" "https://github.com/overextended/oxmysql/releases/latest/download/oxmysql.zip" | log
    unzip -o "$tmp_dir/oxmysql.zip" -d "$lib_dir" >> "$tmp_dir/oxmysql.zip_log"
    log $(cat "$tmp_dir/oxmysql.zip_log")
fi

rm -rf "$tmp_dir"

log "Finished"
