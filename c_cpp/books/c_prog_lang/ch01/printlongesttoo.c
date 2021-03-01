#include <stdio.h>
#define MAXLINE 1000 // maximum input line size

// let's use some globals
int max;                // max length seen so far
char line[MAXLINE];     // current input line
char longest[MAXLINE];  // longest line saved here

int mygetline();
void copy();

// print longest input line
int main() {
    int len;                // current line length
    extern int max;
    extern char longest[];
    max = 0;

    while ((len = mygetline()) > 0) {
        if (len > max) {
            max = len;
            copy();
        }        
    }

    // there was a line...
    if (max > 0){
        printf("%s", longest);
    }

    return 0;
}

// getline: read a line into s, return length
int mygetline() {
    int c, i;
    extern char line[];

    for (i=0; i<MAXLINE-1 && (c=getchar()) !=EOF && c!='\n'; ++i) {
        line[i] = c;
    }

    if (c == '\n') {
        line[i] = 'c';
    }
    line[i] = '\0';
    return i;
}

// copy: copy 'from' into 'to'; assume to is big enough
void copy() {
    int i;
    extern char line[], longest[];
    i = 0;
    while ((longest[i] = line[i]) != '\0') {
        ++i;
    }
}