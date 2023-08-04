#!/bin/bash
PORT=8080
health_build_app=false
check_health() {
health=$(curl -s -oo /dev/null -w "%{http_code}" http://localhost:$PORT/health)
if [ "$health" == "000200" ]; then
        echo "Otrzymano kod 200"
	if [ "$health_build_app" == true ]; then
		echo "----------------------------------"
		echo "  Zatrzymanie i usuwanie kontenera"
		echo "----------------------------------"
       		docker stop app-contener
        	docker rm app-contener
		echo "----------------------------------"
        	echo "Skrypt zakonczony"
		echo "----------------------------------"
	fi
else
	echo "----------------------------------"
        echo "Otrzymano kod: $health"
	echo "----------------------------------"
        echo "Czy chcesz uruchomic kontener z aplikacja? (tak/nie)"
	echo "----------------------------------"
        read response
        if [ "$response" == "tak" ]; then
                docker build -t app .
		docker run -d -p "$PORT:$PORT" --name app-contener -e  "BIND_ADDRESS=:$PORT" app
		echo "----------------------------------"
		echo "Konterer zostal uruchomiony  na porcie $PORT"
		echo "----------------------------------"
		health_build_app=true
                check_health
        else
		echo "----------------------------------"
                echo "Kontener nie zostal uruchomiony!"
		echo "----------------------------------"
        fi
fi
}

while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in 
	     --port)
		PORT="$2"
		shift
		shift
		;;
	      --healthcheck)
		check_health
		exit
		;;
		*)
		echo "Nieznana opcja: $key"
		exit 1
		;;
	esac
done
docker build -t app .
docker run -d -p "$PORT:$PORT" --name app-contener -e  "BIND_ADDRESS=:$PORT" app
echo "----------------------------------"
echo " Konterer zostal uruchomiony  na porcie $PORT"
echo "----------------------------------"
exit_contener() {
	echo " Zatrzymanie i usuwanie kontenera"
	docker stop app-contener
	docker rm app-contener
	echo "----------------------------------"
	echo "Skrypt zakonczony"
	echo "----------------------------------"
}

echo "----------------------------------"
echo "Zeby zakonczyc skrypt i usunac kontener wcisnij (CTRL + C)"
echo "----------------------------------"


trap exit_contener EXIT


read -r -d '' _ </dev/tty
