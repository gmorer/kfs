#include "kfs.h"

#define BUFFER_ADDR 0xb8000
#define LINE_LENGTH 80
#define LINES_PER_SCREEN 24
#define BUFFER_SIZE LINE_LENGTH * LINES_PER_SCREEN

int print(char *buf, size_t buffer_len, char color)
{
	static size_t	offset = 0;
	size_t			index;
	char			*vga_buffer;

	if (!buf || !buffer_len) return 0;
	if (!color) color = 0xb;
	vga_buffer = (char*)BUFFER_ADDR;
	index = 0;
	while (index < buffer_len &&
			index + offset < BUFFER_SIZE)
	{
		vga_buffer[offset * 2 ] = buf[index];
		vga_buffer[offset * 2 + 1] = color;
		index += 1;
		offset += 1;
	}
	return (index);
}
