#include "kfs.h"

char message[] = "Hello world";
char message2[] = "from gmorer!";

void kmain()
{
	print(message, sizeof(message), 0);
	print(message2, sizeof(message2), 0);

	while (1);
}
