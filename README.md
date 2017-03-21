Test tools for EIS x86_64 Linux OS Platform.

# How To
./log.sh     => To log process in system and docker containers in period 120 sec.
./log.sh 30  => pass parameter to change logging period to 30 sec


# log.sh
Period to log memory, cpu, pid of each monitored process in system. ( Default period is 120 sec )

You can modify the "services" in log.sh for monitored process.


# dockerlog.sh
Period to log container name, id, memory, and cpu usage in Docker Container. ( Default period is 120 sec )
 
You can modify the "CONTAINERS" in dockerlog.sh for monitored Docker Containers.

