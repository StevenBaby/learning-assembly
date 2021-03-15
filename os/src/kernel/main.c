#include "config.h"

int main()
{
    char *video = BASE_VIDEO_ADDRESS;
    for (int i = 0; i < 52; i++)
    {
        video[i * VIDEO_CHAR_SIZE] = 'A' + i;
    }
    while (1)
    {

    }
    return 0;
}