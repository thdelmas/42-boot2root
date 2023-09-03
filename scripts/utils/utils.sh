source "$(dirname $0)""/termcaps.sh"

smartprint () {

	MODE="$1"
	
	case $MODE in
		ERROR)
			TC_MODE=${TC_ERROR}
			;;
		WARNING)
			TC_MODE=${TC_WARNING}
			;;
		INFO)
			TC_MODE=${TC_INFO}
			;;
		SUCCESS)
			TC_MODE=${TC_SUCCESS}
			;;
		*)
			TC_MODE=""
			;;
	esac

	shift
	printf "${TC_MODE}""$@""${TC_RESET}"
}
