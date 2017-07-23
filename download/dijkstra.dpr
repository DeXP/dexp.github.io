const
  MaxV=20002;
  MaxE=200002;
  free=0;
  Great=999999999;
type

  list=record
    x, {now element}
    n, {link to next element}
    w  {weight}
    : longint;
  end;

  gr=record
    n, {next (first)}
    e  {end (last)}
    : longint;
  end;

var
  v: array [1..MaxV] of gr; {������ � �������� �� ������}
  adj: array [1..MaxE] of list; {���� ������}
  d: array [1..MaxV] of longint; {������ ���. ����}
{--  p: array [1..MaxV] of longint; ����� ����� ��� �������������� ����}
  n,m,last,x,y,i,w,l,r,tmp,nheap, u: longint;
  heap: array [1..MaxV] of longint; {����. � ��� �������� ������ ������. ���� - d c ����� �������}
  uk: array [1..MaxV] of longint; {���������. ����������, ����� ������ � ����, ��� �������� i �������}

  {���������, ����������� � ����}

  procedure Initialize_Heap(x,n: longint);
  var
    i,ind: longint;
  begin
    nheap:=n;
    ind:=1;
    heap[ind]:=x;
    uk[x]:=ind;
    i:=0;
    while i<>nheap do
    begin
      inc(i);
      if i<>x Then
      begin
        inc(ind);
        heap[ind]:=i;
        uk[i]:=ind;
      end;
    end;
  end;

  procedure MoveUp(ind: longint);
  var
    k: longint;
  begin
    k:= ind div 2;
    If ind>1 Then
    begin
      if d[heap[ind]]<d[heap[k]] Then
      begin
        tmp:=uk[heap[ind]];
        uk[heap[ind]]:=uk[heap[k]];
        uk[heap[k]]:=tmp;
        tmp:=heap[ind];
        heap[ind]:=heap[k];
        heap[k]:=tmp;
        MoveUp(k);
      end;
    end;
  end;

  procedure MoveDown(ind: longint);
  var
    k: longint;
  begin
    k:=ind*2;
    if k<=nheap Then
    begin
      if (k+1<=nheap)and(d[heap[k]]>d[heap[k+1]]) then
        k:=k+1;
      if d[heap[ind]]>d[heap[k]] then
      begin
        tmp:=heap[ind];
        heap[ind]:=heap[k];
        heap[k]:=tmp;
        tmp:=uk[heap[ind]];
        uk[heap[ind]]:=uk[heap[k]];
        uk[heap[k]]:=tmp;
        MoveDown(k);
      end;
    end;
  end;

  Function ExtractMin: longint;
  begin
    ExtractMin:=heap[1];
    uk[heap[1]]:=free;
    heap[1]:=heap[nheap];
    uk[heap[1]]:=1;
    heap[nheap]:=free;
    dec(nheap);
    MoveDown(1); {��������� ����}
  end;

  {���������, ���������� ��� ��������}

  procedure Initialize_Single_Source(s: longint);
  var
    i: longint;
  begin
    For i:=1 to n do
    begin
      d[i]:=Great;
      {--p[i]:=free;}
    end;
    d[s]:=0; {�� ��� ����� � ������� s. ��� �� ����� �� �� ���� ������� ������}
  end;

  function Relax(u,v,w: longint): boolean;
  begin
    Relax:=False;
    If d[v]>d[u]+w Then
    begin
      d[v]:=d[u]+w;
      {--p[v]:=u;}
      Relax:=true;
    end;
  end;

  {��������� ���������� ����� � ������ ���������}

  procedure AddEdge(l,r,w: longint);
  begin
    inc(last); { � adj[last] ����� �������� ������� ����}
    adj[last].x:=r; { c��� �������� }
    adj[last].w:=w; { �������� ��� }
    adj[last].n:=free; { ��� ���� ��������� �� ������� ������, ������ ������ ���}
    If v[l].n=free Then  {���� ����, ���. �� ������� l, ������}
    begin
      v[l].n:=last;  {�� ������ � ������� v �� �� ��� �� ���� - ������}
      v[l].e:=last;
    end else
      begin
        adj[v[l].e].n:=last; { ����� ��������� �� ������ ��������� �� ������}
        v[l].e:=last; {...��������� ������ ������� ����}
      end;
  end;

begin
  Assign(input,'input.txt'); Reset(input);
  Assign(output,'output.txt'); ReWrite(output);
  ReadLn(n,m); {n - ���-�� ������; m - ���-�� �����}
  For i:=1 to n do
  begin
    v[i].n:=free;
    v[i].e:=free;
  end;
  last:=0;
  For i:=1 to m do
  begin
    ReadLn(l,r,w); {��������� ������� ������ � ����� �����, ����� ��� ���}
    AddEdge(l,r,w); {��������� ���� ����� w � ������� � l � ������ � r}
    AddEdge(r,l,w); {��������� ���� ����� w � ������� � r � ������ � l}
  end;
  Read(x,y); {��������� ��������� � �������� �������}
  Initialize_Single_Source(x); {�������������� ��������}
  Initialize_Heap(x,n); {�������������� ����}
  while nheap<>0 do {���� ���� �� ����� ...}
  begin
    u:=ExtractMin; {������� �������, ���� ����� ������ ������� �����}
    i:=v[u].n; {���� �� ���� ������}
    if i<>free Then {���� i - �� ��������� �������, �� ...}
    repeat
      If Relax(u,adj[i].x,adj[i].w) Then {���� ����� �������� ���� - �������� ...}
        MoveUp(uk[adj[i].x]);         {... � ���������� ����}
      i:=adj[i].n; {��������� � ��������� ����}
    until i=free; {������ �� ���� �������� ��������, ������� � ������?}
  end;
  WriteLn(d[y]); {������� ����� ����������� ���� �� � � �}
  Close(input);
  Close(output);
end.
 ______________   _________________________________________________________   ______________
/              \ /  ______________________________________________________ \ /              \
|    |\___/|    |  /                                                      \ |    |\___/|    |
|    / _ _ \    | |                                                       | |    / _ _ \    |
|    \  |  /    | |                    Created by                         | |    \  |  /    |
|   __|\_/|__   | |                                                       | |   __|\_/|__   |
|  /         \  | |   ___    ___   __    __    __   _   _   _  _   __     | |  /         \  |
| / /\     /\ \ | |  |   \  | _ | |  \  /  |  /  \ | \ | | | \/ | |   \   | | / /\     /\ \ |
| \ \|     |/ / | |  | |\ | |  _| |   \/   | | /\| |  \| |  \  /  | |  |  | | \ \|     |/ / |
|  \ \_____/ /  | |  | |/ | | |_  | |\  /| | | \/\ | |\  |  /  \  |   /   | |  \ \_____/ /  |
|   \/     \/   | |  |__ /  |___| |_| \/ |_|  \__/ |_| \_| |_/\_| |_|     | |   \/     \/   |
|    |  |  |    | |                                                       | |    |  |  |    |
|    |  |  |    | |  +-------------------------------------------------+  | |    |  |  |    |
|    |__|__|    | |                                                       | |    |__|__|    |
|  __|  |  |__  | |                http://demanxp.net.ru                  | |  __|  |  |__  |
| |_____|_____| |  \_____________________________________________________/  | |_____|_____| |
\______________/ \_________________________________________________________/ \______________/ 
