#!/bin/bash
# Script to get pods for Kubernetes/Docker and to calculate the currentHeapMomory, PID and Monitor it
start_time=$(date +%s)
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
filenameSuffix=$(date "+%Y-%m-%d_%H_%M_%S")
command="kubectl get po -n redis"
command2="kubectl get nodes"
interval=30
# time interval to repeat in seconds
log_file="LoadMonitoringLog_$filenameSuffix.log"
# Log file to record the output 
declare -a apps=("ABC" "BCD" "CDE")
# PODS name
namespace= NAMESAPCE
# NAMESAPCE :- replace it with yours
read -p "Enter the duration in seconds: " duration

while true; do
    output=$(eval "$command")
    output2=$(eval "$command2")
    echo -e "[$timestamp] Command: $command" >> "$log_file"
    echo -e "[$timestamp] Command: $command"
    echo -e "[$timestamp] Output: \n$output" >> "$log_file"
    echo -e "[$timestamp] Output: \n$output"
    echo -e "=============================================================================================================" >> "$log_file"
    echo -e "============================================================================================================="

    echo -e "[$timestamp] Command: $command2" >> "$log_file"
    echo -e "[$timestamp] Command: $command2"
    echo -e "[$timestamp] Output: \n$output2" >> "$log_file"
    echo -e "[$timestamp] Output: \n$output2"
    echo -e "=============================================================================================================" >> "$log_file"
    echo -e "============================================================================================================="

    for appname in "${apps[@]}"
    do
        podname=$(kubectl get pods -o name --selector=app=$appname -n $namespace | awk '{split($0,a,"/"); print a[2]}')
        echo "Current occupied heap space in pod: " $podname
        echo "Current occupied heap space in pod: " $podname >> "$log_file"
        PID=$(kubectl exec -it $podname -n $namespace -- jps | awk 'NR==1{print $1}')
        # command3=""
        output3=$(kubectl exec -it $podname -n $namespace -- jstat -gc $PID 2>/dev/null | tail -n 1 | awk '{split($0,a," "); sum=a[3]+a[4]+a[6]+a[8]; print sum/1024}' 2>/dev/null)
        # echo -e "[$timestamp] Command: $command3" >> "$log_file"
        # echo -e "[$timestamp] Command: $command3"
        echo -e "[$timestamp] Occupied heap space: \n$output3 Mb" >> "$log_file"
        echo -e "[$timestamp] Occupied heap space: \n$output3 Mb"
        echo -e "=============================================================================================================" >> "$log_file"
        echo -e "============================================================================================================="
    done

    current_time=$(date +%s)
    elapsed_time=$((current_time - start_time))
    if [[ $elapsed_time -ge $duration ]]; then
        echo -e "Script execution completed. Exiting..."
        break
    fi
    sleep "$interval"
done
