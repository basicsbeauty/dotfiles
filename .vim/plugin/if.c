/*
gcc -Wall -std=gnu99 -O3 -o if if.c -DSTANDALONE 
gcc -Wall -std=gnu99 -O3 -shared -fPIC -o if.so if.c 
clang -Wall -std=gnu99 -O3 -dynamiclib -o if.dylib if.c 
*/

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <errno.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#ifndef MAX
#define MAX(a,b) ((a) > (b) ? (a) : (b))
#endif

struct lt {
	enum { lt_no_indent, lt_space_only, lt_tab_only, lt_mixed, lt_begin_space, lt_null } type;
	int tabs;
	int spaces;
};

static void loop(int scores[static 9], int type, struct lt *result_lt) {
	int nb = 0;
	int indent_value = -1;
	for(int i = 8; i >= 1; i--) {
		if(scores[i] > (int) (nb * 1.1)) {
			indent_value = i;
			nb = scores[i];
		}
	}
	if(indent_value != -1) {
		result_lt->type = type;
		result_lt->spaces = indent_value;
	}
}

const char *find_indent(const char *bp) {
#ifdef PROFILE
	struct timespec a;
	clock_gettime(CLOCK_REALTIME, &a);
#endif
	static char ret[128];
	printf("%p\n", bp);
	
	bool skip_next_line = false;
	struct {
		int tabs;
		int spaces[9];
		int mixed[9];
	} score = {0};
	struct lt cur_lt = {lt_null, 0, 0}, prev_lt;
	while(1) {
		prev_lt = cur_lt;
		if(!skip_next_line)
		do {
			if(*bp == '\n' || *bp == '\0') {
				cur_lt.type = lt_null;
				break;
			}
			if(*bp != ' ' && *bp != '\t') {
				cur_lt.type = lt_no_indent;
				break;
			}
			cur_lt.spaces = 0;
			cur_lt.tabs = 0;
			for(; *bp == ' ' || *bp == '\t'; bp++) {
				if(*bp == '\n' || *bp == '\0') break;
				if(*bp == ' ') cur_lt.spaces++;
				if(*bp == '\t') cur_lt.tabs++;
			}
			if(*bp == '*' || (*bp == '/' && bp[1] == '*') || *bp == '#' || *bp == '\n') {
				cur_lt.type = lt_null;
				break;
			}
			if(cur_lt.tabs && cur_lt.spaces) {
				cur_lt.type = cur_lt.spaces >= 8 ? lt_null : lt_mixed;
			} else if(cur_lt.tabs) {
				cur_lt.type = lt_tab_only;
			} else if(cur_lt.spaces) {
				cur_lt.type = cur_lt.spaces < 8 ? lt_begin_space : lt_space_only;
			}
		} while(0);
		for (; *bp != '\n' && *bp != '\0'; bp++);
		if(*bp == '\0') break;
		skip_next_line = bp[-1] == '\\';
		bp++;
		#define pair(a, b) ((a) * 0x10 + (b))
		int spaces;
		switch(pair(prev_lt.type, cur_lt.type)) {
		case pair(lt_tab_only, lt_tab_only):
		case pair(lt_no_indent, lt_tab_only):
			if(cur_lt.tabs - prev_lt.tabs == 1) {
				score.tabs++;
			}
			break;
		case pair(lt_space_only, lt_space_only):
		case pair(lt_begin_space, lt_space_only):
		case pair(lt_no_indent, lt_space_only):
			spaces = cur_lt.spaces - prev_lt.spaces;
			if(spaces > 1 && spaces <= 8) {
				score.spaces[spaces]++;
			}
			break;
		case pair(lt_begin_space, lt_begin_space):
		case pair(lt_no_indent, lt_begin_space):
			spaces = cur_lt.spaces - prev_lt.spaces;
			if(spaces > 1 && spaces <= 8) {
				score.spaces[spaces]++;
				score.mixed[spaces]++;
			}
			break;
		case pair(lt_begin_space, lt_tab_only):
			spaces = 8 * cur_lt.tabs - prev_lt.spaces;
			if(spaces > 1 && spaces <= 8) {
				score.mixed[spaces]++;
			}
			break;
		case pair(lt_tab_only, lt_mixed):
			if(prev_lt.tabs == cur_lt.tabs) {
				spaces = cur_lt.spaces;
				if(spaces > 1 && spaces <= 8) {
					score.mixed[spaces]++;
				}
			}
			break;

		case pair(lt_mixed, lt_tab_only):
			if(prev_lt.tabs + 1 == cur_lt.tabs) {
				spaces = 8 - prev_lt.spaces;
				if(spaces > 1 && spaces <= 8) {
					score.mixed[spaces]++;
				}
			}
			break;
		}

	}

	int max_line_space = 0, max_line_mixed = 0;
	for(int i = 2; i <= 8; i++) {
		max_line_space = MAX(max_line_space, score.spaces[i]);
		max_line_mixed = MAX(max_line_mixed, score.mixed[i]);
	}
	int max_line_tab = score.tabs;

	struct lt result_lt;
	result_lt.type = lt_space_only;
	result_lt.spaces = 4;

	if(max_line_space >= max_line_mixed && max_line_space > max_line_tab) {
		loop(score.spaces, lt_space_only, &result_lt);
	} else if(max_line_tab > max_line_mixed && max_line_tab > max_line_space) {
		result_lt.type = lt_tab_only;
		result_lt.spaces = 4;
	} else if(max_line_mixed >= max_line_tab && max_line_mixed > max_line_space) {
		loop(score.mixed, lt_mixed, &result_lt);
	}

	int n = result_lt.spaces;
	switch(result_lt.type) {
	case lt_space_only:
		snprintf(ret, sizeof(ret), "set sts=%d | set tabstop=%d | set expandtab | set shiftwidth=%d", n, n, n);
		break;
	case lt_tab_only:
		snprintf(ret, sizeof(ret), "set sts=0 | set tabstop=%d | set noexpandtab | set shiftwidth=%d", n, n);
		break;
	case lt_mixed:
		// ???
		snprintf(ret, sizeof(ret), "set sts=4 | set tabstop=%d | set noexpandtab | set shiftwidth=%d", n, n);
		break;
	default:
		break;
	}

#ifdef PROFILE
	struct timespec b;
	clock_gettime(CLOCK_REALTIME, &b);
	printf(">>>%ld<<<\n", (long) (b.tv_nsec - a.tv_nsec));
	abort();
#endif
	return ret;
}

#ifdef STANDALONE
int main(int argc, char **argv) {
	printf("%s\n", find_indent(argv[1]));
	return 0;
}
#endif
