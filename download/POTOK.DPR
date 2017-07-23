const
  MaxV=1000;
  MaxE=30000;

  free=0;
  bisy=1;
  Great=MaxLongint;
var
  v,l: array [1..MaxV] of longint;
  adj,next,c,f: array [1..MaxE] of longint;
  n,m,last,i,s,t,x,y,z: longint;
  found: boolean;
  MaxPOTOK: longint;
  {Need for queue}
  prev: array [1..MaxV] of longint;
  Marked: array [1..MaxV] of byte;
  que,poz: array [1..MaxE] of longint;
  qb,qe: longint;

  procedure Init(n,m: longint);
  var
    i: longint;
  begin
    for i:=1 to n do
    begin
      v[i]:=free;
      l[i]:=free;
    end;
    for i:=1 to 2*m do
    begin
      adj[i]:=free;
      c[i]:=free;
      next[i]:=free;
      f[i]:=free;
    end;
    last:=0;
  end;

  procedure AddEdge(x,y,z: longint);
  begin
    inc(last);
    adj[last]:=y;
    c[last]:=z;
    if v[x]=free then
    begin
      v[x]:=last;
    end else
      begin
        next[l[x]]:=last;
      end;
    l[x]:=last;
  end;

  {Queue procedures}
  procedure Put(x: longint);
  begin
    inc(qe);
    que[qe]:=x;
    Marked[x]:=bisy;
    prev[x]:=que[qb];
  end;

  procedure InitQue(x: longint);
  var
    i: longint;
  begin
    for i:=1 to 2*m do
    begin
      Marked[i]:=free;
      poz[i]:=0;
    end;
    qb:=1;
    qe:=1;
    que[qe]:=x;
    Marked[x]:=bisy;
  end;

  procedure FindWay;
  var
    x,Min,cf: longint;
  begin
    InitQue(s);
    while (qb<=qe)and(Marked[t]<>bisy) do
    begin
      x:=v[que[qb]];
      while adj[x]<>free do
      begin
        if (Marked[adj[x]]<>bisy)and(c[x]-f[x]>0) then
        begin
          Put(adj[x]);
          poz[adj[x]]:=x;
        end;
        x:=next[x];
      end;
      inc(qb);
    end;
    if Marked[t]=free Then
    begin
      Found:=False;
      Exit;
    end;
    Min:=Great;
    x:=t;
    while prev[x]<>free do
    begin
      cf:=c[poz[x]]-f[poz[x]]{!};
      if cf<Min Then Min:=cf;
      x:=prev[x];
    end;
    x:=t;
    while prev[x]<>free do
    begin
      f[poz[x]]:=f[poz[x]]+Min;
      if c[poz[x]]<>free then
         f[poz[x]+1]:=-f[poz[x]]
           else f[poz[x]-1]:=-f[poz[x]];
      x:=prev[x];
    end;
  end;

begin
  assign(input,'input.txt'); reset(input);
  assign(output,'output.txt'); rewrite(output);
  read(n,m);
  Init(n,m);
  for i:=1 to m do
  begin
    read(x,y,z);
    AddEdge(x,y,z);
    AddEdge(y,x,0);
  end;
  read(s);
  read(t);
  found:=true;
  while found do
    FindWay;
  MaxPOTOK:=0;
  x:=v[s];
  while x<>free do
  begin
    if f[x]>0 then
      MaxPOTOK:=MaxPOTOK+f[x];
    x:=next[x];
  end;
  writeln(MaxPOTOK);
  close(input);
  close(output);
end.