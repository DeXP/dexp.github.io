Const
  MaxN=100000;
var
  x,y,pred, rank: array [1..MaxN] of Longint;
  r: array [1..MaxN] of longint;
  b,e: array [1..MaxN] of longint;
  n,m,k,i,j: longint;
  Answer: longint;

   function Partition(p,rr:longint):longint;
    var
      i,j,z : longint;
      x,t   : longint;
    begin
      x := R[p];
      i:=p-1;
      j:=rr+1;
      while i<j do
        begin
          repeat j:=j-1 until R[j]<=x;
          repeat i:=i+1 until R[i]>=x;
          if i<j
            then
              begin
                t:=R[i]; R[i]:=R[j]; R[j]:=t;
                z:=B[i]; B[i]:=B[j]; B[j]:=z;
                z:=E[i]; E[i]:=E[j]; E[j]:=z;
              end;
        end;
      Partition:=j;
    end;

  procedure QuicksortR(p,rr:longint);
    var
      q : longint;
    begin
      if p<rr
        then
          begin
            q:= Partition(p,rr);
            QuicksortR(p,q);
            QuicksortR(q+1,rr);
          end;
    end;

  Procedure MakeSet(x: longint);
  begin
    Rank[x]:=0;
    Pred[x]:=x;
  end;

  Function FindSet(x: longint): longint;
  begin
    If x<>pred[x] Then pred[x]:=FindSet(Pred[x]);
    FindSet:=Pred[x];
  end;

  Procedure Link(x,y: longint);
  begin
    If rank[x]>rank[y] Then pred[y]:=x
                        Else
    begin
      pred[x]:=y;
      If rank[x]=rank[y] Then inc(rank[y]);
    end;
  end;

  procedure Union(x,y: longint);
  begin
    Link(FindSet(x),FindSet(y));
  end;

  procedure MinTree;
  var
    i: longint;
  begin
    For i:=1 to n do MakeSet(i);
    Answer:=0;
    For i:=1 to m do
      If FindSet(B[i])<>FindSet(E[i]) Then
      begin
        Answer:=Answer+R[i];
        Union(B[i],E[i]);
      end;
  end;

begin
  Assign(input,'input.txt'); Reset(input);
  Assign(output,'output.txt'); ReWrite(output);
  Read(n,m);
  For i:=1 to m do
    ReadLn(B[i],E[i],R[i]);
  If m=1 Then
  begin
    WriteLn(R[1]);
    Close(input);
    Close(output);
    Exit;
  end;
  QuicksortR(1,n);
  MinTree;
  WriteLn(Answer);
  Close(input);
  Close(output);
end.