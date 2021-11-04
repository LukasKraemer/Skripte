##### add this part to Server instance directory
#!/bin/bash
#SERVER SPECIFIC SETTINGS
SERVERFILE="spigot.jar"
NAME="lobby" #same like dir name
SHUTDOWN=20 #time in sek between stop command and kill process
RAM="1G" #MAX RAM

#source /home/minecraft/baseCode.sh



##################### BaseCode ###############
#### Add this source code to user root dir
#!/bin/bash

SERVERNAME="mc_$NAME"
DIRECTORY="/home/minecraft/$SERVERNAME"
USERID=1000

if [ $(id --user)  !=  1000 ]; then
        echo "run as MINECRAFT user"
        exit
fi

checkIfServerRun (){
	if tmux ls | grep $SERVERNAME >> /dev/null; then
	    RUNNING=true
	else
		RUNNING=false
	fi
}

startServer () {
    checkIfServerRun
  	if ! "$RUNNING" ; then
        tmux new-session -d -s $SERVERNAME >> /dev/null
        sleep 1
        tmux send-keys -t $SERVERNAME:0 "cd $DIRECTORY" C-m
        tmux send-keys -t $SERVERNAME:0 "java -Xms512M -Xmx$RAM -jar $SERVERFILE nogui" C-m
        
        sleep 0.5
		echo "START: $NAME starting..."
	else
		echo "START: $NAME is already running!"
        exit 1
	fi
}

stopServerWithNotification () {
    checkIfServerRun
    if "$RUNNING" ; then
        tmux send-keys -t $SERVERNAME:0 "cmi broadcast Serverneustart" C-m
        for ((i=30; i>=0; i--))
        do
           if (( i % 5 == 0 )) || (( i <= 10 ))
           then
             tmux send-keys -t $SERVERNAME:0 "cmi broadcast &cServer-Neustart in &b$i Sekunden" C-m
             echo -ne "\rWaiting for stop in $i"
           fi
            sleep 1
        done
        stopServer
fi
}


stopServer () {
    checkIfServerRun
    if "$RUNNING" ; then
        tmux send-keys -t $SERVERNAME:0 "kick @a Der Server wird heruntergefahren." C-m
        sleep 5
	tmux send-keys -t $SERVERNAME:0 "stop" C-m
        for ((i=$SHUTDOWN; i>=0; i--))
        do
            echo -ne "\rWaiting for shutdown in $i"
	    sleep 1
        done
        tmux kill-session -t $SERVERNAME
        echo -ne "\rSTOP: $NAME shutdown successful\n"
        echo -n
	else
		echo "STOP: $NAME doesn't run"
        exit 1
	fi
}
killServer () {
    if "$RUNNING"; then
        tmux kill-session -t $SERVERNAME
        echo "KILL: $NAME"
    else
		echo "KILL: $NAME doesn't run"
        exit 1
	fi
}

restartServerWithNotfication () {
    if "$RUNNING" ; then
        stopServerWithNotification
        sleep 2
        startServer
        echo "RESTART: $NAME "
    else
                echo "RESTART: $NAME doesn't run"
        exit 1
        fi

}

restartServer () {
    if "$RUNNING" ; then
        stopServer
        sleep 2
        startServer
        echo "Fast RESTART: $NAME "
    else
		echo "Fast RESTART: $NAME doesn't run"
        exit 1
	fi
}

runCommand (){
        if "$RUNNING" ; then
            tmux send-keys -t $SERVERNAME:0 "$1" C-m
            echo " RUN: $1 on $NAME"
        else
            echo "RUN: $NAME doesn't run"
            exit 1
        fi
}


console (){
    if "$RUNNING" ; then
		    tmux attach-session -t $SERVERNAME:0
	else
		echo "CONSOLE: $NAME not running!"
        exit 1
	fi
}

#handler
checkIfServerRun
case "$1" in 
    start)
        startServer
        ;;
    stop)
        stopServerWithNotification
    	;;
    faststop)
        stopServer
        ;;
    kill)
        killServer
        ;;
    restart)
        restartServerWithNotfication
        ;;
    fastrestart)
	restartServer
	;;
    run)
        runCommand "$2"
        ;;
    console)
        console
        ;;
  *)
    echo "Commands (start - stop - kill - restart - run - console - fastreboot - faststop)"
    ;;
esac
exit 0
