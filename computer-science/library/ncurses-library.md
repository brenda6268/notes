# ncurses library


ID: 619
Status: publish
Date: 2017-05-30 08:08:00
Modified: 2017-05-30 08:08:00


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