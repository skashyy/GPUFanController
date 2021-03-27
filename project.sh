declare -A matrix

#reads in data.txt to matrix
while read -r line; do
	index=${line:0:2}
	count=0
	prev=3
	for ((i = 3 ; i < ${#line} ;  i++)); do
		if [[ $i -eq ${#line}-1 ]]; then
			matrix[$count,$index]=${line:prev:${#line}-$prev}
		elif [[ ${line:$i:1} == " " ]]; then
			matrix[$count,$index]=${line:prev:$i-$prev}
			((count=count+1))
			((prev=$i+1))
		fi
			
	done
done <data.txt

#re-enables default fan control on exit
control_c() {
	nvidia-settings -a GPUFanControlState=0>/dev/null  
	echo -e "\nDefault fan control re-enabled!"
	exit
}

trap control_c SIGINT

#requests user to input fan speed mode
reqinput() {
echo -e "Enter quiet, normal, or performance.\n"
read ans
if [[ ${ans,,} == "quiet" ]]; then
	defaultmodes 0
elif [[ ${ans,,} == "normal" ]]; then
	defaultmodes 1
elif [[ ${ans,,} == "performance" ]]; then
	defaultmodes 2
else
	echo "Invalid input"
	reqinput
fi
}

#returns GPU temperature
temperature() {
	nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader --id=0
}

#runs fan controller based on input
defaultmodes() {
	nvidia-settings -a GPUFanControlState=1>/dev/null 
	prev=0
	while true; do
		temp=$(temperature) 
		echo "GPU temp is $temp degrees Celsius"
		if [[ $temp -eq $prev ]]; then
			:
		elif (( $temp <= 51 )); then
			nvidia-settings -a GPUTargetFanSpeed=20>/dev/null
			echo "GPU fan speed set to 20%" 
			
		elif (( $temp >= 85 )); then
			nvidia-settings -a GPUTargetFanSpeed=100>/dev/null
			echo "GPU fan speed set to 100%" 
		else 
			nvidia-settings -a GPUTargetFanSpeed=${matrix[$1,$temp]}>/dev/null 
			echo "GPU fan speed set to ${matrix[$1,$temp]}%"
		fi
		prev=$temp
		sleep 1
	done
	
}

echo -e "Welcome to Sasha's GPU Fan Curve Tool.\nPress ctrl + c anytime to quit.\n"
reqinput





