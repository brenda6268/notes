# ncurses library

<!--
ID: b3891bbe-1338-41c0-9373-5155bf360b10
Status: publish
Date: 2017-05-30T08:08:00
Modified: 2017-05-30T08:08:00
wp_id: 619
-->

ncurses is a lib for building command line user interface(TUI)


Hello World

#include <ncurses.h> 
int main() { 
	initscr();
	printw("Hello World !!!"); refresh();
	getch();
	endwin();
	return 0; 
} 

初始化控制函数