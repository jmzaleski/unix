#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

#include <sys/stat.h>

main(int argc, char **argv){
	umask(002);
	system(argv[1]);
}
	
