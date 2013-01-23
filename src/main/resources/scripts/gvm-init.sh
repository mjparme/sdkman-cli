#!/bin/bash

#
#   Copyright 2012 Marco Vermeulen
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

export GVM_VERSION="@GVM_VERSION@"
export GVM_PLATFORM=$(uname)

# OS specific support (must be 'true' or 'false').
cygwin=false;
darwin=false;
case "`uname`" in
    CYGWIN*)
        cygwin=true
        ;;
        
    Darwin*)
        darwin=true
        ;;
esac


if [ -z "${GVM_SERVICE}" ]; then
    export GVM_SERVICE="@GVM_SERVICE@"
fi

if [ -z "${GVM_DIR}" ]; then
	export GVM_DIR="$HOME/.gvm"
fi

GVM_CANDIDATES=($(curl -s "${GVM_SERVICE}/candidates" | sed -e 's/,//g'))
if [[ "${#GVM_CANDIDATES[@]}" == "0" ]]; then
	GVM_CANDIDATES=("groovy" "grails" "griffon" "gradle" "vertx")
fi

OFFLINE_BROADCAST=$( cat << EOF
==== BROADCAST =============================================

AEROPLANE MODE ENABLED! Some functionality is now disabled.

============================================================
EOF
)

ONLINE_BROADCAST=$( cat << EOF
==== BROADCAST =============================================

ONLINE MODE RE-ENABLED! All functionality now restored.

============================================================
EOF
)

OFFLINE_MESSAGE="This command is not available in aeroplane mode."
PATH="${GVM_DIR}/bin:${GVM_DIR}/ext:$PATH"

# Source gvm module scripts.
for f in $(find "${GVM_DIR}/src" -type f -name 'gvm-*'); do
	source "${f}"
done

# Source extension files prefixed with 'gvm-' and found in the ext/ folder
# Use this if extensions are written with the functional approach and want
# to use functions in the main gvm script.
for f in $(find "${GVM_DIR}/ext" -type f -name 'gvm-*'); do
	if [ -r "${f}" ]; then
		source "${f}"
    fi
done
unset f
