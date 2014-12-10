export JBOSS4_HOME=$HOME/tools/jboss-4.2.1.GA

jboss() {
    if [ -z "$1" ]; then
        SERVER=".."
    else
        SERVER="$1"
    fi
    cd ${JBOSS4_HOME}/server/${SERVER}
}

deploytest() {
    FILE_LIST=("tests/ear/target/paysol-*.ear" "core/security/target/paysol-*[^sources].jar"  )
    deployInternal $@
}


deploy() {
    FILE_LIST=("core/ear/target/paysol-*.ear" "core/security/target/paysol-*[^sources].jar"  )
    deployInternal $@
}


deployInternal() {
    EXPLODED=""
    if [ -z $2 ]; then
        SERVER="$1"
    fi
    if [ "$1" = "-x" ]; then
        EXPLODED="true"
        SERVER="$2"
    fi

    if [ -z "${JBOSS4_HOME}" ]; then
        echo "Must specify JBOSS4_HOME"
        return
    fi

    if [ -z "${SERVER}" ]; then
        echo "No server specified, using default"
        SERVER="default"
    fi

    if [ ! -e ${JBOSS4_HOME}/server/${SERVER} ]; then
        echo "Server ${SERVER} doesn't exist"
        return
    fi

    SERVER_DEPLOY_PATH=${JBOSS4_HOME}/server/${SERVER}/deploy/
    SERVER_CONFIFG=${JBOSS4_HOME}/server/${SERVER}/conf/

    echo "Deploying to: ${SERVER_DEPLOY_PATH}"

    for element in $(seq 0 $((${#FILE_LIST[@]} - 1))); do
        FILE_NAME=${FILE_LIST[$element]##*\/}
        find ${SERVER_DEPLOY_PATH} -name "${FILE_NAME}" -exec rm -rf {} \;
    done

    BUILD_ROOT=`pwd`
    ORIGINAL_BUILD_ROOT=${BUILD_ROOT}

    while [ ! -e ${BUILD_ROOT}/core  ]; do
        BUILD_ROOT=`dirname ${BUILD_ROOT}`
        if [ "${BUILD_ROOT}" == "/" ]; then
            echo "Build root not found from ${ORIGINAL_BUILD_ROOT}"
            return
        fi
    done
    echo "Using build root: ${BUILD_ROOT}"


    for element in $(seq 0 $((${#FILE_LIST[@]} - 1))); do
        if [ ! -e ${BUILD_ROOT}/${FILE_LIST[$element]} ]; then
            echo "File not found: ${FILE_LIST[$element]}"
            return
        fi
    done

    for element in $(seq 0 $((${#FILE_LIST[@]} - 1))); do
        echo "Copy ${FILE_LIST[$element]} ${SERVER_DEPLOY_PATH}"
        currentFile=`basename ${FILE_LIST[$element]}`
        cp ${BUILD_ROOT}/${FILE_LIST[$element]} ${SERVER_DEPLOY_PATH}
        if [ ! -z ${EXPLODED} ]; then
            if [[ ${currentFile} == *.ear ]]; then
                echo "Unpacking ${currentFile}"
                pushd ${SERVER_DEPLOY_PATH}
                mv ${currentFile} ${currentFile}.tmp
                mkdir ${currentFile}
                mv ${currentFile}.tmp ${currentFile}
                cd ${currentFile}
                jar -xf ${currentFile}.tmp
                cd META-INF
                xsltproc ${SCRIPT_DIR}/rewrite-application-xml.xslt application.xml > application1.xml
                sed -i -r -e 's,<sc/>,<!--\n  ,g' -e 's,<ec/>,\n  -->,g' application1.xml
                mv application1.xml application.xml
                cd ..
                rm ${currentFile}.tmp
                popd
            fi
        fi
    done

}

run() {
    if [ -z "$1" ]; then
        echo "No server specified, using default"
        SERVER="default"
    else
        SERVER="$1"
    fi
    ${JBOSS4_HOME}/bin/run.sh -c ${SERVER}
}

st() {
    BUILD_ROOT=`pwd`
    ORIGINAL_BUILD_ROOT=${BUILD_ROOT}

    while [ ! -e ${BUILD_ROOT}/core  ]; do
        BUILD_ROOT=`dirname ${BUILD_ROOT}`
        if [ "${BUILD_ROOT}" == "/" ]; then
            echo "Build root not found from ${ORIGINAL_BUILD_ROOT}"
            return ;
        fi
    done
    echo "Using build root: ${BUILD_ROOT}"
    pushd ${BUILD_ROOT}
    mvn -Psystemtest -f tests/systemtest/pom.xml
    popd ${BUILD_ROOT}
}

debug() {
    SERVER="default"
    if [ -z "$1" ]; then
        echo "No server specified, using default"
    else
        SERVER="$1"
    fi
    ${JBOSS4_HOME}/bin/debug.sh -c ${SERVER}
}

# COMPLETIONS


_serverlist() {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="$(cd ${JBOSS4_HOME}/server && find -mindepth 1 -maxdepth 1 -type d -printf %f\\n)"

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _serverlist deploy
complete -F _serverlist deploytest
complete -F _serverlist debug
complete -F _serverlist run
complete -F _serverlist jboss
