#include <sys/types.h>
#include <sys/stat.h>

main(int argc, char ** argv)
{
	mkdir(argv[1], 0777);
}
