# !/bin/bash
tar_error() {
	echo " Z powodu bledu rozpakowane pliki zostana usuniete"
	rm -rf logs
	exit 1
}

trap 'tar_error' EXIT 
tar -xjf logs.tar.bz2 
trap - EXIT
help_info() {
	echo " Bledna skladnia "
	rm -rf logs
	exit 1
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		 --user-agent)
			if [ -z "$2" ]; then
				echo "Nie podano wartosci dla opcji agenta"
				help_info
			fi
			USER_AGENT="$2"
			shift 2
			;;
		--method)
			METHOD_FLAG="method"
			shift
			;;
		*)
			echo " Podano nieznana opcje: $1"
			help_info
			;;
	esac
done
if [ -z "$USER_AGENT" ] && [ -z "$METHOD_FLAG" ]; then
	echo " ADDRESS      REQUESTS"
	cat /home/dominik/git_workspace/RecruitmentAssigment/Assigment1/logs/logs.log | grep -oE 'client_ip: "[^"]+"' | cut -d'"' -f2 | sort | uniq -c | sort -nr | awk '{printf "%-20s%d\n",$2,$1}'
elif [ -n "$USER_AGENT" ]; then
	echo " ADDRESS      REQUESTS"
	cat /home/dominik/git_workspace/RecruitmentAssigment/Assigment1/logs/logs.log | grep  "$USER_AGENT" | grep -oE 'client_ip: "[^"]+"' | cut -d'"' -f2 | sort | uniq -c | sort -nr | awk '{printf "%-20s%d\n",$2,$1}' 
elif [ -n "$METHOD_FLAG" ]; then
	echo " ADDRESS      METHOD      REQUESTS"
        cat /home/dominik/git_workspace/RecruitmentAssigment/Assigment1/logs/logs.log | grep -oE 'method: "[^"]+".*client_ip: "[^"]+"' | sed -E 's/(method: "[^"]+").*(client_ip: "[^"]+")/\1  \2/' | sed -E 's/"//g' | sort | uniq -c | sort -nr | awk '{printf "%-20s%s%10d\n" ,$5,$3,$1}'    
fi
rm -rf logs






