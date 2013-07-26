#include<cstdio>
#include<cstring>
#include<cstdlib>
#include<cassert>

int num_links[8][8][4];

void generate_buffer_array(int N)
{
    FILE *fp = fopen("buffer_output.txt", "r");
    if(fp == NULL)
    {
        fprintf(stderr, "Error while opening file.\n");
        exit(1);
    }

    const int num_dirs = 6;
    int num_buffers;

    // Read the file. Add the buffers for each direction in to a single variable.
    for(int i = 0;i < N;++i)
    {
        for(int j = 0;j < N;++j)
        {
            num_buffers = 0;
            for(int k = 0;k < num_dirs;++k)
            {
                int buffers, x, y;
                char dirIn[15];
                fscanf(fp, "%d %d %s %d\n",&x,&y,dirIn,&buffers);
                assert(x == i);
                assert(y == j);

                num_buffers += buffers;
            }
            printf(" %d", num_buffers);
        }
        printf("\n");
    }
}

void generate_link_array(int N)
{
    FILE* fp = fopen("link_output.txt", "r");
    if(fp == NULL)
    {
        fprintf(stderr, "Error while opening file.\n");
        exit(1);
    }

    const int num_dirs = 4;
    int x,y,dir;
    memset(num_links, 0, sizeof(num_links));

    for(int i = 0;i < N;++i) for(int j = 0;j < N;++j) for(int k = 0;k < num_dirs;++k)
    {
        int links, direction;
        char dir[15];
        fscanf(fp, "c%d c%d %s %d\n",&x,&y,dir,&links);
        assert(x == i);
        assert(y == j);

        if(dir[0] == 'N') direction = 0;
        else if(dir[0] == 'W') direction = 1;
        else if(dir[0] == 'E') direction = 2;
        else if(dir[0] == 'S') direction = 3;

        num_links[x][y][direction] = links;
    }

    for(int y = 0; y < N; ++y)
    {
        for(int x = 0; x < N-1 ; ++x) printf("%d,%d, ", num_links[x][y][2] + 1, num_links[x+1][y][1]+1);
        printf("\n");
    }

    for(int x = 0; x < N; ++x)
    {
        for(int y = 0; y < N-1 ; ++y) printf("%d,%d, ", num_links[x][y][3] + 1, num_links[x][y+1][0]+1);
        printf("\n");
    }
    printf("\n");
}

void generate_vc_array(int N)
{
    FILE* fp = fopen("vc_output.txt", "r");
    if(fp == NULL)
    {
        fprintf(stderr, "Error while opening file.\n");
        exit(1);
    }

    const int num_dirs = 6;
    int num_vcs[N][N][num_dirs], x,y,dir;
    memset(num_vcs, 0, sizeof(num_vcs));

    for(int i = 0;i < N;++i) for(int j = 0;j < N;++j) for(int k = 0;k < num_dirs;++k)
    {
        int vc;
        char dirIn[15];
        fscanf(fp, "c%d c%d %s %d\n",&x,&y,dirIn,&vc);
        assert(x == i);
        assert(y == j);

        if(dirIn[0] == 'C') dir = 0;
        else if(dirIn[0] == 'D') dir = 1;
        else if(dirIn[0] == 'N') dir = 2;
        else if(dirIn[0] == 'W') dir = 3;
        else if(dirIn[0] == 'E') dir = 4;
        else if(dirIn[0] == 'S') dir = 5;

        num_vcs[x][y][dir] = vc;
    }

    /* Virtual Channel distribution at the input port (R) -- from the optimization program. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            const int dx[] = {0,0,0,-1,1,0};
            const int dy[] = {0,0,-1,0,0,1};

            printf("[");
            for(int k = 0;k < num_dirs;++k) if(num_vcs[x][y][k] > 0) printf("%d,", num_vcs[x][y][k]);
            printf("], ");
        }
        printf("\n");
    }
    printf("\n");

    /* Virtual Channel distribution at the output port (R) -- from the optimization program. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            printf("[2,");
            if(num_vcs[x][y][1] > 0) printf("2,");

            const int dx[] = {0,0,0,-1,1,0};
            const int dy[] = {0,0,-1,0,0,1};

            for (int k = 2;k < 6; ++k)
            {
                if(x+dx[k] >= 0 && x+dx[k] < N &&
                   y+dy[k] >= 0 && y+dy[k] < N &&
                   num_vcs[x+dx[k]][y+dy[k]][7-k] > 0)
                {
                    printf("%d,", num_vcs[x+dx[k]][y+dy[k]][7-k]);
                }
            }
            printf("], ");
        }
        printf("\n");
    }
    printf("\n");

    /* Virtual Channel distribution at the output port (NI) -- from the optimization program. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x) printf("%d,", num_vcs[x][y][0]);
        printf("\n");
    }
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            if(num_vcs[x][y][1] > 0) printf("%d,", num_vcs[x][y][1]);
            else                     printf("  ");
        }
        printf("\n");
    }
    printf("\n");


    printf("Output for Paper's design\n");
    /* Virtual Channel distribution at the input port (R) -- Paper. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            printf("[");
            for(int k = 0;k < num_dirs;++k)
            {
                if ((k == 0) || (k == 1 && (x == y || x + y == 7)) || (k > 1 && num_vcs[x][y][k] > 0))
                {
                    if (x == y || x+y == 7)
                    {
                        printf("6,");
                        num_vcs[x][y][k] = 6;
                    }
                    else
                    {
                        printf("2,");
                        num_vcs[x][y][k] = 2;
                    }
                }
                else
                {
                    //printf("  ");
                    num_vcs[x][y][k] = 0;
                }
            }
            printf("], ");
        }
        printf("\n");
    }
    printf("\n");


    /* Virtual Channel distribution at the output port (R) -- from the optimization program. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            printf("[2,");
            if(num_vcs[x][y][1] > 0) printf("2,");

            if (x == y || x + y == 7)
            {
                if(y > 0 && num_vcs[x][y-1][5] > 0)
                    printf("%d,", num_vcs[x][y-1][5]);
                if(x > 0 && num_vcs[x-1][y][4] > 0)
                    printf("%d,", num_vcs[x-1][y][4]);
                if(x < N-1 && num_vcs[x+1][y][3] > 0)
                    printf("%d,", num_vcs[x+1][y][3]);
                if(y < N-1 && num_vcs[x][y+1][2] > 0)
                    printf("%d,", num_vcs[x][y+1][2]);
            }
            else
            {
                if(y > 0 && num_vcs[x][y-1][5] > 0)
                {
                    printf("%d,", num_vcs[x][y-1][5]);
                }
                if(x > 0 && num_vcs[x-1][y][4] > 0)
                {
                    printf("%d,", num_vcs[x-1][y][4]);
                }
                if(x < N-1 && num_vcs[x+1][y][3] > 0)
                {
                    printf("%d,", num_vcs[x+1][y][3]);
                }
                if(y < N-1 && num_vcs[x][y+1][2] > 0)
                {
                    printf("%d,", num_vcs[x][y+1][2]);
                }
            }
            printf("], ");
        }
        printf("\n");
    }
    printf("\n");
}

void generate_vc_array_l2(int N)
{
    FILE* fp = fopen("vc_output.txt", "r");
    if(fp == NULL)
    {
        fprintf(stderr, "Error while opening file.\n");
        exit(1);
    }

    const int num_dirs = 6;
    int num_vcs[N][N][num_dirs], x,y,dir;
    memset(num_vcs, 0, sizeof(num_vcs));

    for(int i = 0;i < N;++i) for(int j = 0;j < N;++j) for(int k = 0;k < num_dirs;++k)
    {
        int vc;
        char dirIn[15];
        fscanf(fp, "c%d c%d %s %d\n",&x,&y,dirIn,&vc);
        assert(x == i);
        assert(y == j);

        if(dirIn[0] == 'C') dir = 0;
        else if(dirIn[0] == 'D') dir = 1;
        else if(dirIn[0] == 'N') dir = 2;
        else if(dirIn[0] == 'W') dir = 3;
        else if(dirIn[0] == 'E') dir = 4;
        else if(dirIn[0] == 'S') dir = 5;

        num_vcs[x][y][dir] = vc;
    }

    /* Virtual Channel distribution at the input port (R) -- from the optimization program. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            const int dx[] = {0,0,0,-1,1,0};
            const int dy[] = {0,0,-1,0,0,1};

            printf("[");
            for(int k = 0;k < num_dirs;++k)
            {
                if(num_vcs[x][y][k] > 0)
                {
                    printf("%d,", num_vcs[x][y][k]);
                    if (k > 1 && num_links[x][y][k-2] > 0) printf("%d,", num_vcs[x][y][k]);
                }
            }
            printf("], ");
        }
        printf("\n");
    }
    printf("\n");

    /* Virtual Channel distribution at the output port (R) -- from the optimization program. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            printf("[2,");
            if(num_vcs[x][y][1] > 0) printf("2,");

            const int dx[] = {0,0,0,-1,1,0};
            const int dy[] = {0,0,-1,0,0,1};

            for (int k = 2;k < 6; ++k)
            {
                if(x+dx[k] >= 0 && x+dx[k] < N &&
                   y+dy[k] >= 0 && y+dy[k] < N &&
                   num_vcs[x+dx[k]][y+dy[k]][7-k] > 0)
                {
                    printf("%d,", num_vcs[x+dx[k]][y+dy[k]][7-k]);
                    if (num_links[x][y][k-2] > 0) printf("%d,", num_vcs[x+dx[k]][y+dy[k]][7-k]);
                }
            }
            printf("], ");
        }
        printf("\n");
    }
    printf("\n");

    /* Virtual Channel distribution at the output port (NI) -- from the optimization program. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x) printf("%d,", num_vcs[x][y][0]);
        printf("\n");
    }
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            if(num_vcs[x][y][1] > 0) printf("%d,", num_vcs[x][y][1]);
            else                     printf("  ");
        }
        printf("\n");
    }
    printf("\n");


    /* Virtual Channel distribution at the input port (R) -- Paper. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            printf("[");
            for(int k = 0;k < num_dirs;++k)
            {
                if ((k == 0) || (k == 1 && (x == y || x + y == 7)) || (k > 1 && num_vcs[x][y][k] > 0))
                {
                    if (x == y || x+y == 7)
                    {
                        printf("6,");
                        num_vcs[x][y][k] = 6;
                        if (k > 1) printf("6,");
                        //else printf("  ");
                    }
                    else
                    {
                        printf("2,");
                        num_vcs[x][y][k] = 2;
                        if((k == 2 && (x == y-1 || x + y-1 == 7)) ||
                           (k == 3 && (x-1 == y || x-1 + y == 7)) ||
                           (k == 4 && (x+1 == y || x+1 + y == 7)) ||
                           (k == 5 && (x == y+1 || x + y+1 == 7))) printf("2,");
                        //else printf("  ");
                    }
                }
                else
                {
                    //printf("  ");
                    num_vcs[x][y][k] = 0;
                }
            }
            printf("], ");
        }
        printf("\n");
    }
    printf("\n");


    /* Virtual Channel distribution at the output port (R) -- from the optimization program. */
    for(y = 0; y < N; ++y)
    {
        for(x = 0;x < N;++x)
        {
            printf("[2,");
            if(num_vcs[x][y][1] > 0) printf("2,");

            if (x == y || x + y == 7)
            {
                if(y > 0 && num_vcs[x][y-1][5] > 0)
                    printf("%d,%d,", num_vcs[x][y-1][5], num_vcs[x][y-1][5]);
                if(x > 0 && num_vcs[x-1][y][4] > 0)
                    printf("%d,%d,", num_vcs[x-1][y][4], num_vcs[x-1][y][4]);
                if(x < N-1 && num_vcs[x+1][y][3] > 0)
                    printf("%d,%d,", num_vcs[x+1][y][3], num_vcs[x+1][y][3]);
                if(y < N-1 && num_vcs[x][y+1][2] > 0)
                    printf("%d,%d,", num_vcs[x][y+1][2], num_vcs[x][y+1][2]);
            }
            else
            {
                if(y > 0 && num_vcs[x][y-1][5] > 0)
                {
                    printf("%d,", num_vcs[x][y-1][5]);
                    if (x == y-1 || x + y - 1 == 7)
                        printf("%d,", num_vcs[x][y-1][5]);
                }
                if(x > 0 && num_vcs[x-1][y][4] > 0)
                {
                    printf("%d,", num_vcs[x-1][y][4]);
                    if (x-1 == y || x + y - 1 == 7)
                        printf("%d,", num_vcs[x-1][y][4]);
                }
                if(x < N-1 && num_vcs[x+1][y][3] > 0)
                {
                    printf("%d,", num_vcs[x+1][y][3]);
                    if (x+1 == y || x + y + 1 == 7)
                        printf("%d,", num_vcs[x+1][y][3]);
                }
                if(y < N-1 && num_vcs[x][y+1][2] > 0)
                {
                    printf("%d,", num_vcs[x][y+1][2]);
                    if (x == y+1 || x + y + 1 == 7)
                        printf("%d,", num_vcs[x][y+1][2]);
                }
            }
            printf("], ");
        }
        printf("\n");
    }
    printf("\n");
}

int main(int argc, char** argv)
{
    int N = atoi(argv[1]);
    generate_link_array(N);
    generate_vc_array(N);
    //generate_vc_array_l2(N);
    //generate_buffer_array(N);
    return 0;
}
