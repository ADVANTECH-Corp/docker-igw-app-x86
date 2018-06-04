THIS=${0%/*}

LIBE_NAME="libEApi"
LIB3_NAME="libSUSI-3.02"
LIB4_NAME="libSUSI-4.00"
JNI4_NAME="libJNISUSI-4.00"

LINUX_LIB_DIR="/usr/lib"
LINUX_ADV_DIR="/usr/lib/Advantech"
LINUX_SUSI_INI_DIR=${LINUX_ADV_DIR}"/Susi/ini"

usage()
{
	cat >&2 <<-eof
	Usage: $0 [u]
	  (Null) : install SUSI 4.0
	  u      : uninstall SUSI 4.0
	
	eof
}

installlibrary()
{
	mkdir -p ${LINUX_SUSI_INI_DIR}/
	cp -af ${THIS}/ini/*.ini ${LINUX_SUSI_INI_DIR}/
	cp -a ${THIS}/lib*.* ${LINUX_LIB_DIR}/
	ldconfig
}

uninstalllibrary()
{
	rm -f ${LINUX_LIB_DIR}/${LIB4_NAME}.*
	rm -f ${LINUX_LIB_DIR}/${LIB3_NAME}.*
	rm -f ${LINUX_LIB_DIR}/${LIBE_NAME}.*
	rm -f ${LINUX_LIB_DIR}/${JNI4_NAME}.*
	ldconfig
	
	rm -rf ${LINUX_ADV_DIR}
}

case ${1} in
	"")
		uninstalllibrary
		echo "Install SUSI library."
		installlibrary
		ldconfig -p | grep "${LIB4_NAME}\|${LIB3_NAME}\|${LIBE_NAME}\|${JNI4_NAME}"
		;;
	"u")
		echo "Uninstall SUSI."
		uninstalllibrary
		;;
	*)
		echo "ERROR: \"${1}\" is an invalid input parameter!"
		usage
		;;
esac
