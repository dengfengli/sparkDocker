ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}') && echo "My IP is: $ip"

xhost + ${ip}

PROCESS_NUM=$(ps -ef | grep XQuartz | grep -v "grep"| wc -l)

if [ $PROCESS_NUM -gt 0 ]; then
	docker run -e DISPLAY=${ip}:0 --network=sparkdocker_hadoopnet -v /tmp/.X11-unix:/tmp/.X11-unix jess/firefox --disable-save-password-bubble --no-first-run namenode:8088 airflow:8080
else
	echo "Please install and start XQuartz"
fi
