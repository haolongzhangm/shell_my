#include <stdio.h>
#include <stdlib.h>
#include <net/if.h>
#include <sys/socket.h>
#include <ifaddrs.h>
#include <linux/sockios.h>
#include <string.h> //use buildin strcpy
#define MAC_LEN 6

int main(int argc, char *argv[])
{
	int net_fd, i;
	short macaddr[MAC_LEN] = {};
	struct ifreq ifr;
	char *name = "eth0";

	strcpy( ifr.ifr_name, name);
	net_fd = socket(AF_INET, SOCK_DGRAM, 0);
	if (ioctl(net_fd, SIOCGIFHWADDR, &ifr)){
		printf("Err:\n");
		close(net_fd);
		return -1;
	}
	printf("MAC");
	for (i = 0; i < MAC_LEN; i++)
		printf(":%02x", (0x000000ff) & ifr.ifr_hwaddr.sa_data[i]);

	printf("\n");

	close(net_fd);

	return 0;
}
