echo 100 > /proc/acpi/video/VID1/LCD0/brightness

# echo -n interrupt anytime. you are getting brighter.

# ( for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14
#   do
#     echo -n .
# 	echo up > /proc/acpi/ibm/brightness
# 	sleep 2
#    done
# ) 

# echo 

#should really remember this PID and kill it from a trap hander.

#read junk
