#!/bin/sh
# =======
# aim: resolve xsl:include, ...
# =======


# =======
# environement
. ./xinc_env.sh
. ./xinc_env.custom.sh


# =======
# environement dynamique
XINC_BIN=`pwd`


# =======
# main
echo test

XINC_XSL=${XINC_BIN}/xinc_xsl.xsl
XINC_IN=notice.html5.loc.xsl
XINC_OUT=concat.xsl
XINC_RUN_DIR=${XINC_BIN}/../data_xsl/v3/lgpi/main

set -x
cd "${XINC_RUN_DIR}"
"${JAVA_HOME}/bin/java" -jar "${XINC_SAXON}" -s:"${XINC_IN}" -xsl:"${XINC_XSL}" -o:"${XINC_OUT}"
echo $?

ls -l "${XINC_OUT}"

echo fin

