#!/bin/bash

[ $UID -eq 0 ] && echo "Pas besoin des droits root" && exit 2
[ $# -lt 1 ] && echo "USAGE : $0 distribution [rep_destination]" && exit 1

# configuration
bande_passante=1000 # kbps

# declarations
distribution=$1
rep_depot=$2
: ${rep_depot:="~/mirror-$distribution"}
target="${rep_depot}/files"
tmp="${rep_depot}/tmp"
lock='/tmp/mirrorsync.lck'
source="mirrors.kernel.org::$distribution"

# instructions

. ./mir_$distribution 2>/dev/null
[ $? -ne 0 ] && echo "Pas de fichier ./mir_$distribution" && exit 3 

[ ! -d "${target}" ] && mkdir -p "${target}"
[ ! -d "${tmp}" ] && mkdir -p "${tmp}"
[ -f "${lock}" ] && exit 1
touch "${lock}"
trap "rm -f '${lock}'" EXIT INT TERM

mir_$distribution

echo "Last sync was $(date -d @$(cat ${target}/lastsync))"
