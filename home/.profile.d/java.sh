export JAVA_HOME6="/System/Library/Frameworks/JavaVM.framework/Home/"
export JAVA_HOME7="/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home/"
export JAVA_HOME8="/Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home/"

export JAVA_HOME=${JAVA_HOME8}

showjarversion() {
  unzip -q -c $1 META-INF/MANIFEST.MF
}

setjava() {

  VERSION=$1
  if [ -z "${VERSION}" ]; then
    echo "Must specify version {6,7}"
    return
  fi
  PARAM="JAVA_HOME${VERSION}"
  export JAVA_HOME=$(eval "echo \$${PARAM}")
  echo "Set JAVA_HOME to:  ${JAVA_HOME}"
}


