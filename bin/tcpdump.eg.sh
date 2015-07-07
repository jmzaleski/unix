
#I did this to figure out what URL's javascript apps ask for.
sudo tcpdump -A -n -i en0 -s 0 -w /tmp/output.txt src or dst port 80

#this to snoop H's password that only a browser knew.
tcpdump -w /tmp/hfexx -s 1024 -vv -i eth1 port 110
