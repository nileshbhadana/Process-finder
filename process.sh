#! /bin/bash

FetchDetails() {

    # Defining default variable
    RESOURCE=""

    # Getting process with 3rd highest resource usage and sorting according to argument value
    OUTPUT=$(ps -eo pid,%mem,%cpu,cmd --sort=$1 | tail -3 | head -1)

    # Getting individual attributes and assigning variables to them
    PID=$(echo $OUTPUT | awk '{print $1}')
    MEMORY_USAGE=$(echo $OUTPUT | awk '{print $2}')
    CPU_USAGE=$(echo $OUTPUT | awk '{print $3}')
    COMMAND=$(echo $OUTPUT | cut -d" "  -f4-)
    PORT=$(lsof -Pan -i tcp -i udp | grep $PID | cut -d ":" -f2 | cut -d "(" -f1)

    # If condition to get resource name according to argument
    if [ "$1" == "%mem" ]; then
        RESOURCE="Memory"
    else
        RESOURCE="CPU"
    fi

    DATE=$(date)

    # Writing the details to the file
    echo -e "$DATE \n[ Details of process which has 3rd highest $RESOURCE usage ] \nPID - $PID \nMemory Usage - $MEMORY_USAGE \nCPU Usage - $CPU_USAGE \nCommand/Name - $COMMAND \nPort - $PORT \n" >> process-details.txt
    
}

echo "[+] Running script to get PID,Memory Usage, CPU usage, Process Name and port of third most cpu and memory consuming process"
FetchDetails %mem
FetchDetails %cpu
echo "[+] You can check out the output in process-details.txt file"