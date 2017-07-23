/*
* dxPlanner - The operating system processes planner modeling utility
*
* Copyright (C) 2008 Hrabrov Dmitry a.k.a. DeXPeriX
* Web: http://dexperix.net
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*
* In addition, as a special exception, the copyright holders give
* permission to link the code of portions of this program with the
* OpenSSL library under certain conditions as described in each
* individual source file, and distribute linked combinations
* including the two.
* You must obey the GNU General Public License in all respects
* for all of the code used other than OpenSSL.  If you modify
* file(s) with this exception, you may extend this exception to your
* version of the file(s), but you are not obligated to do so.  If you
* do not wish to do so, delete this exception statement from your
* version.  If you delete this exception statement from all source
* files in the program, then also delete it here.
*/

# if defined(__GNUC__)
//Linux GCC compilation

#include <iostream>
#include <iomanip>
#include <string>

#define cin std::cin
#define cout std::cout
#define setw std::setw
#define endl std::endl

#else
//Windows compilation

#include <iostream.h>
#include <iomanip.h>
#include <string.h>

#endif

#define NAME "dxPlanner"
#define VERSION "2.0"

const int MaxN = 200; //Processes count
const int MaxNameLen = 40;
const int DefTimeQuant = 4;
const int MaxTimeQuant = 32766;

int config_show_splash = 1;

struct process{
  int need;  // How much time does it need?
  int live;  // How long does it "live" undonned?
  int does;  // Time alreadey used by this process
  char sost; // (R)eady, (A)ctive, (E)nded, (D)eleted
  // (C)ritical Section Running, (*) CS Ready for run
  int CSneed; //Critical Section length is steps
  int CSdone;   // How much steps alreadey doned?
  int CSready;  //Is process ready for CS?
  char name[MaxNameLen];
};

struct semaphore{
  int value;
  int ownerID; // ID of owner process
};


process a[MaxN];
semaphore s[MaxN];
int n = 0;

void br(){
  cout << endl;
  cout << "-----------------------" << endl;
}

void about_prg(){
  cout << "\t        * * * * * * * * * * * * * * * * * * * * * * * * * * *" << endl;
  cout << "\t       *                                                   *" << endl;
  cout << "\t      *         dx  Processes planner  " << setw(4) << VERSION <<"               *" << endl;
  cout << "\t     *    Author   :  Hrabrov Dmitry  a.k.a. DeXPeriX    *" << endl;
  cout << "\t    *   - Web     :  http://dexperix.net                *" << endl;
  cout << "\t   *   -- Jabber :  dexperix@jabber.ru                 *" << endl;
  cout << "\t  *   --- ICQ   :  606986                             *" << endl;
  cout << "\t *                                                   *" << endl;
  cout << "\t* * * * * * * * * * * * * * * * * * * * * * * * * * *" << endl;
  cout << endl;
}

void about_text(){
  cout << endl;
  cout << NAME << " is a software, that simulates the operation system processes planner." << endl;
  cout << "It was initially created as laboratory work at Gomel State Technical University" << endl;
  cout << "named after aircraft designer Pavel Sukhoi." << endl;
  cout << endl;
  cout << "Released algorithms:" << endl;
  cout << "- First Come First Serve" << endl;
  cout << "- Priority Round Robbin" << endl;
  cout << "- Non priority Round Robbin" << endl;
  cout << "- Shortest Job First" << endl;
  cout << endl;
  cout << "This programm is licensed under the GNU Public License version 2" << endl;
  cout << endl;
}
void DeXPeriX(){
  cout << endl;
  cout << "" << endl;
  cout << "      8888888b.        Y88b   d88P8888888b.                d8 Y88b   d88P" << endl;
  cout << "      888  \"Y88b        Y88b d88P 888   Y88b               Y8P Y88b d88P" << endl;
  cout << "      888    888         Y88o88P  888    888                    Y88o88P" << endl;
  cout << "      888    888 .d88b.   Y888P   888   d88P .d88b. 888d888888   Y888P" << endl;
  cout << "      888    888d8P  Y8b  d888b   8888888P\" d8P  Y8b888P\"  888   d888b" << endl;
  cout << "      888    88888888888 d88888b  888       88888888888    888  d88888b" << endl;
  cout << "      888  .d88PY8b.    d88P Y88b 888       Y8b.    888    888 d88P Y88b" << endl;
  cout << "      8888888P\"  \"Y8888d88P   Y88b888        \"Y8888 888    888d88P   Y88b" << endl;
  cout << "" << endl;
}

void dxPlanner(){
  cout << endl;
  cout << "       888          8888888b.  888" << endl;
  cout << "       888          888   Y88b 888" << endl;
  cout << "       888          888    888 888" << endl;
  cout << "   .d88888 888  888 888   d88P 888  8888b.  88888b.  88888b.   .d88b.  888d888" << endl;
  cout << "  d88\" 888 `Y8bd8P' 8888888P\"  888     \"88b 888 \"88b 888 \"88b d8P  Y8b 888P\"" << endl;
  cout << "  888  888   X88K   888        888 .d888888 888  888 888  888 88888888 888" << endl;
  cout << "  Y88b 888 .d8\"\"8b. 888        888 888  888 888  888 888  888 Y8b.     888" << endl;
  cout << "   \"Y88888 888  888 888        888 \"Y888888 888  888 888  888  \"Y8888  888" << endl;
  cout << "" << endl;
}

void banner(){
  if( config_show_splash ){
    dxPlanner();
    about_prg();
  }
}

void show_about(){
  DeXPeriX();
  about_prg();
  about_text();
}

void show_help(int argc, char **argv){
  if( config_show_splash ) dxPlanner();
  about_text();
  cout << "Usage: " << argv[0] << " [-nosplash] [-help]" << endl;
  cout << endl;
  cout << "\t-nosplash [-ns] - do no show starup banner" << endl;
  cout << "\t--help [-h] [/?] - show this help screen" << endl;
  cout << "\t-alg [-a] - choose algorithm:" << endl;
  cout << "\t\tfirst-serve-first-come [fcfs]" << endl;
  cout << "\t\tnon-priority-round-robin [nprr]" << endl;
  cout << "\t\tpriority-round-robin [prr]" << endl;
  cout << "\t\tshortest-job-first [sjf]" << endl;
  cout << endl;
  cout << "Example:" << endl;
  cout << argv[0] << " -ns -alg prr" << endl;
  cout << endl;
  if(argc>1) cout << "Now you used next parameters:" << endl;
  int i;
  for(i=1; i<argc; i++) cout << argv[i] << endl;
}

int P(semaphore &sem, int owner){
  if(!sem.value) return 0;
  sem.ownerID = owner;
  sem.value--;
  return 1;
}

void V(semaphore &sem){
  sem.value++;
}

char get_menu_item(){
  br();
  cout << "What do you want to do?" << endl;
  cout << "0. (Q)uit" << endl;
  cout << "1. (A)dd new process to queue" << endl;
  cout << "2. (D)elete process from queue" << endl;
  cout << "3. (N)ext time quant" << endl;
  cout << "4. (J)ump N quants" << endl;
  cout << "5. (P)rint processes table" << endl;
  cout << "6. (G)o into critical section" << endl;
  cout << "7. (R)un progamm in silent mode and wait for N's process implementation" << endl;
  cout << "8. (H)elp"<< endl;
  cout << "9. About" << endl;
  cout << "Give number or character, please: ";
  char menu;
  cin >> menu;
  return menu;
}

void add_process(){
  br();
  cout << "Insert process name: ";
  cin >> a[n].name;
  cout << "How musch time it need to run? : ";
  cin >> a[n].need;
  a[n].does = 0;
  a[n].live = 0;
  a[n].sost = 'R';
  a[n].CSready = 0;
  n++;
  cout << "\nProcess successfully added" << endl;
}
void delete_process(){
  br();
  cout << "Insert process number to delete: ";
  int numb;
  cin >> numb;
  numb--; // Because in table ID > 0
  if( (numb>=n) || (numb<0) ) cout << "Wrong number!" << endl;
  else
    if(a[numb].sost=='D') cout << "Process already deleted!" << endl;
	else{
	  a[numb].sost='D';
	  cout << "\nProcess successfully deleted" << endl;
	}

}

//Get active process ID
int getAPid(){
    int APNum=-1;
    int i;
    for(i=0; i<n; i++)
	//Active or Critical section running
	if( (a[i].sost=='A') || (a[i].sost=='C') ) APNum = i;
    return APNum;
}

//Is critical section running?
//If YES then return CS  process ID
int getCSid(){
    int cnum=-1;
    int i;
    for(i=0; i<n; i++)
      if( a[i].sost=='C' ) cnum = i;
    return cnum;
}

void go_CS(){
  int csnum, i;
  csnum=-1;
  for(i=0; i<n; i++)
    if( a[i].CSready ) csnum = i;
  br();
if( csnum >= 0  ) cout << "We already have a process, ready to CS" << endl;
else{
  cout << "Insert process ID: ";
  int numb;
  cin >> numb;
  numb--;
  if( (numb>=n) || (numb<0) ||
      (a[numb].sost=='D') || (a[numb].sost=='E') ) cout << "Wrong process ID!" << endl;
  else
    if( a[numb].CSready != 0 ) cout << "Process is already ready fo CS" << endl;
    else{
      cout << "Insert steps, that CS need to run: ";
      cin >> a[numb].CSneed;
      a[numb].CSready = 1;
      if( a[numb].sost == 'R' ) a[numb].sost = '*';
    }
  }
}


void print_table(int quant){
  br();
  cout << "Current time quant is: " << quant << endl;

  int i,k;
  k=0;
  for(i=0; i<n; i++)
    if(a[i].sost!='D') k++;
  if(k<=0)
    cout << "There are no processes" << endl;
  else{
    cout << "Processes list:" << endl;
    cout << "-------------------------------------------" << endl;
    cout << " ID | State | Runned | Need | Live | Name" << endl;
    cout << "-------------------------------------------" << endl;
    for(i=0; i<n; i++){
      if(a[i].sost != 'D'){
	cout << setw(3) << (i+1) << " | ";  //ID
	cout << setw(5) << a[i].sost << " | "; //State
	cout << setw(6) << a[i].does << " | "; //Runned
	cout << setw(4) << a[i].need << " | "; //Need
	cout << setw(4) << a[i].live << " | "; //Live
	cout << a[i].name << endl; //Name
      }
    }
    cout << "-------------------------------------------" << endl;
  }
}

int getReadyNum(){
    int num=0;
    int i;
    for(i=0; i<n; i++)
	if(a[i].sost=='R') num++;
    return num;
}

int main(int argc, char **argv){
  int time = 0;
  int TimeQuant = DefTimeQuant;
  int APNum = -1; // Active Process number
  int CSNum = -1; // Running Critical Section process id
  int APRunTime = 0;
  char menu = ' ';
  int i, j, NextNum, dlit;

  char AlgNum = '*'; // 2 - Priority RR, other - RR

  //Check for command line arguments
  for(i=1; i< argc; i++){
    // -n(osplash)
    if( (argv[i][0]=='-') && (argv[i][1]=='n') ) config_show_splash=0;
    // -h(elp) or --h(elp) or /?
    if( ((argv[i][0]=='-') && (argv[i][1]=='h')) ||
	((argv[i][0]=='-') && (argv[i][1]=='-') && (argv[i][2]=='h') ) ||
	((argv[i][0]=='/') && (argv[i][1]=='?')) ){
	show_help(argc, argv);
	return 0;
    }
    // -a(lg)
    if( (argv[i][0]=='-') && (argv[i][1]=='a') && (argc > i+1) )
      if( (argv[i+1][0]=='n') || (argv[i+1][0]=='N')
	||(argv[i+1][0]=='p') || (argv[i+1][0]=='P')
	||(argv[i+1][0]=='f') || (argv[i+1][0]=='F')
	||(argv[i+1][0]=='s') || (argv[i+1][0]=='S') )
	   AlgNum = argv[i+1][0];
  }

  banner();

  if(AlgNum=='*'){
    cout << "What algorithm do you prefer?" << endl;
    cout << "0. (F)irst Come First Serve (FCFS). Non priority. Non displacing" << endl;
    cout << "1. (N)on priority Round Robin. Displacing" << endl;
    cout << "2. (P)riority Round Robin. Displacing" << endl;
    cout << "3. (S)hortest Job First (SJF). Priority, displacing" << endl;
    cout << "Insert number or character, please: ";
    cin >> AlgNum;
  }

  if( (AlgNum=='0') || (AlgNum=='f') || (AlgNum=='F') ) TimeQuant = MaxTimeQuant;
  if( (AlgNum=='3') || (AlgNum=='s') || (AlgNum=='S') ) TimeQuant = 1;

  int force = 0; // Jump N quants
  int silent = -1; // Wait for process, with `silent` num

  do{
    //Action menu
    do{
      if(force) force--;

      if( (!force) && (silent<0) ) menu = get_menu_item();

      if( (menu == '1') || (menu == 'a') || (menu == 'A') )
	add_process();
      if( (menu == '2') || (menu == 'd') || (menu == 'D') )
	delete_process();
      if( (menu == '4') || (menu == 'j') || (menu == 'J') ){
	cout << "How much time quats do you want to admit? : ";
	cin >> force;
	menu = '3';
      }
      if( (menu == '6') || (menu == 'g') || (menu == 'G') )
	go_CS();
      if( (menu == '7') || (menu == 'r') || (menu == 'R') ){
	cout << "Whitch process do you want to wait? ID: ";
	cin >> silent;
	silent--;
	if( (silent<0) || (silent>n) ||
	 ( (a[silent].sost != 'R') && (a[silent].sost!='*') )  ){
	   cout << "Process with this ID does not exist or not ready to run" << endl;
	}else{
	  menu='3';
	}
      }
      if( (menu == '5') || (menu == 'p') || (menu == 'P') )
	print_table(time);
      if( (menu == 's') ){
	config_show_splash = 0; //hint
	cout << "'No splash' mode on" << endl;
      }
      if( (menu == '9') ) show_about();
      if( (menu == '8') || (menu == 'h') || (menu == 'H') )
	show_help(argc, argv);

    }while( (menu != '0') && (menu != 'q') && (menu != 'Q') &&
	    (menu != '3') && (menu != 'n') && (menu != 'N') );

    //Main Planner algorithm

    APNum = getAPid();
    CSNum = getCSid();

    time++;

    //Change active process
    if( (APNum == -1) || ( a[APNum].does >= a[APNum].need)
	|| ( (APRunTime >= TimeQuant) && ( CSNum== -1 ) )
	|| ( (CSNum>=0) && ( a[CSNum].CSdone >= a[CSNum].CSneed )
	|| ( a[APNum].CSready ) )
      ){

       if( (a[APNum].CSready) && (a[APNum].sost!='C') ){
	 //CS
	 a[APNum].sost = 'C';
	 CSNum = getCSid();
       }

       if( (a[APNum].sost=='C') && (a[APNum].CSdone >= a[APNum].CSneed) ){
	 a[APNum].sost = 'R';
	 a[APNum].CSready = 0;
       }

	if(APNum != -1){
	    if( a[APNum].does >= a[APNum].need ){
		a[APNum].sost = 'E';
		APNum = -1;
	    }else
	      if(a[APNum].sost != 'C') a[APNum].sost = 'R';
		else a[APNum].sost = '*';
	}
	APRunTime = 0;

	j = APNum+1;
	NextNum = -1;
	dlit = -1;
	int csblock = 0;
	//Next process search
	for(i=0; i<n; i++){
	    if(j>=n) j=0;

	    if( (AlgNum=='2') || (AlgNum=='p') || (AlgNum=='P') ||
		(AlgNum=='3') || (AlgNum=='s') || (AlgNum=='S') ){
		//Priority RR or SJF
		if( (a[j].CSready) || ( (!csblock) && ( a[j].sost=='R' ) && ( (dlit == -1) || (a[j].need < dlit) )  ) ){
			NextNum = j;
			dlit = a[j].need;
			if(a[j].CSready) csblock = 1;
		};
	    }else{
		//Non priority RR or FCFS
		if( ( (a[j].sost=='R') || (a[j].sost=='*') ) && (NextNum == -1) ) NextNum = j;
	    }

	    j++;
	}

	if(NextNum == -1) APRunTime=-1;
	else{
	    if(a[NextNum].sost=='R') a[NextNum].sost='A';
	    if(a[NextNum].sost=='*'){
	      a[NextNum].sost='C';
	      CSNum = NextNum;
	    }
	    APNum = NextNum;
	}

    }

    //succesfully "runs" current active process

    if( APNum != -1 ) a[APNum].does++;

    if( APNum == silent ) silent = -1;

    APRunTime++;

    if( CSNum >= 0 ){
	a[CSNum].CSdone++;
    }

    for(i=0; i<n; i++) if( (a[i].sost != 'D') && (a[i].sost != 'E') ) a[i].live++;

    if( (!force) && (silent<0) ) print_table(time);


  }while( (menu != '0') && (menu!= 'q') && (menu!='Q') );

  return 0;
}
