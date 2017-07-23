#include <fstream.h>
#include <iostream.h>

const int MaxV = 1000;
const int MaxE = 2000;

const int free = 0;
const int bisy = 1;
const long int Great = 2000000000;

long int v[MaxV], l[MaxV];
long int adj[MaxE], next[MaxE], c[MaxE], f[MaxE];
long int n,m,last,i,s,t,x,y,z,MaxPotok;
short int found;
//Need for queue
long int prev[MaxV];
short int Marked[MaxV];
long int que[MaxE],poz[MaxE];
long int qb,qe;

void Init(long int n, long int m){
  for(i=1;i<=n;i++){
    v[i]=free;
    l[i]=free;
  }
  for(i=1;i<=2*m; i++){
    adj[i]=free;
    c[i]=free;
    next[i]=free;
    f[i]=free;
  }
  last=0;
  found=0;
}

void AddEdge(long int x, long int y, long int z){
  last++;
  adj[last]=y;
  c[last]=z;
  if(v[x]==free){
    v[x]=last;
  } else{
      next[l[x]]=last;
    };
  l[x]=last;
}


//Queue procedures
void  Put(long int x){
  qe++;
  que[qe]=x;
  Marked[x]=bisy;
  prev[x]=que[qb];
}


void InitQue(long int x){
  long int i;
  for(i=1; i<=2*m; i++){
    Marked[i]=free;
    poz[i]=0;
  }
  qb=1;
  qe=1;
  que[qe]=x;
  Marked[x]=bisy;
}

void FindWay(void){
  long int x,Min,cf;
  InitQue(s);
  while((qb<=qe)&&(Marked[t]!=bisy)){
    x=v[que[qb]];
    while(adj[x]!=free){
      if((Marked[adj[x]]!=bisy)&&(c[x]-f[x]>0)){
	Put(adj[x]);
	poz[adj[x]]=x;
      };
      x=next[x];
    }
    qb++;
  }
  if(Marked[t]==free){
    found=1;
  } else{
      Min=Great;
      x=t;
      while(prev[x]!=free){
	cf=c[poz[x]]-f[poz[x]];
	if(cf<Min) Min=cf;
	x=prev[x];
      };
      x=t;
      while(prev[x]!=free){
	f[poz[x]]=f[poz[x]]+Min;
	if(c[poz[x]]!=free){
	  f[poz[x]+1]=-f[poz[x]];
	} else {
	    f[poz[x]-1]=-f[poz[x]];
	  };
	x=prev[x];
      };
    };
}



int main(void){
  ifstream input_file("input.txt");
  input_file >> n >> m;
  Init(n,m);
  for(i=1;i<=m; i++){
    input_file >> x >> y >> z;
    AddEdge(x,y,z);
    AddEdge(y,x,0);
  }
  input_file >> s >> t;
  input_file.close();
  while(found==0) FindWay();
  MaxPotok=0;
  x=v[s];
  while(x!=free){
    if(f[x]>0) MaxPotok=MaxPotok+f[x];
    x=next[x];
  }
  ofstream output_file("output.txt");
  output_file << MaxPotok;
  output_file.close();
  return 0;
}