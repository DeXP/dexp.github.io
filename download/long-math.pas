const
  MaxN   =  2000;

  {Bigger?}
  No = 11;
  Yes = 22;

  {a[0] - '-' or '+'}
  Plus = 0;
  Minus = 1;

  { , }
  Zap=99;
  symv='.';


type
  byte   =  shortint;
  tdigit =  array [0..MaxN] of byte;
  pdigit =  ^tdigit;
  int    =  longint;
  pint   =  ^int;
var
  a,b,c     :   tdigit;
  pa,pb,pc :   pdigit;
  na,nb,nc :   int;
  pna,pnb,pnc :   pint;

  Procedure LongRead(a: pdigit; n: pint);
  var
    c: char;
    code: integer;
    x: byte;
  begin
    fillchar(a^,SizeOf(a^),0);
    n^:=0;
    while not eoln do
    begin
      Read(c);
      If (n^=0)and(c='-')Then
      a^[0]:=1 Else
      begin
        inc(n^);
        If c=symv Then x:=zap
                  Else val(c,x,code);
        If (n^=2)and(x<>zap)and(a^[1]=0) Then dec(n^);
        a^[n^]:=x;
      end;
    end;
    If a^[n^]=Zap Then dec(n^);
  end;

  Procedure LongWrite(a: pdigit; n: pint);
  var
    i: integer;
  begin
    If a^[0]=Minus Then Write('-');
    For i:=1 to n^ do
    If a^[i]<>Zap Then Write(a^[i])
                 Else Write(symv);
  end;

  Procedure Invert(a: pdigit; n: pint);
  var
    i: integer;
    x: byte;
  begin
    For i:=1 to n^ div 2 do
    begin
      x:=a^[i];
      a^[i]:=a^[n^-i+1];
      a^[n^-i+1]:=x;
    end;
  end;

  function HYLb(pa: pdigit; pna: pint): boolean;
  var
    i: integer;
  begin
    HYLb:=True;
    For i:=1 to pna^ do
      if pa^[i]<>0 Then HYLb:=False;
  end;

  Procedure Change(pa,pb: pdigit; pna,pnb: pint);
  var
    i: integer;
    n: int;
    x: byte;
  begin
    n:=pna^;
    pna^:=pnb^;
    pnb^:=n;
    If pna^>pnb^ then n:=pna^
                 else n:=pnb^;
    For i:=1 to n do
    begin
      x:=pa^[i];
      pa^[i]:=pb^[i];
      pb^[i]:=x;
    end;
  end;

  Function Maximum(pa,pb: pdigit; pna,pnb: pint): byte;
  var
    i: integer;
  begin
    Maximum:=Yes;
    If pna^>pnb^ Then Exit;
    If pna^<pnb^ Then
    begin
      Maximum:=No;
      Exit;
    end;
    i:=1;
    While (i<=pna^)and(pa^[i]=pb^[i]) do inc(i);
    {If i>pna^ Then Maximum:=PABHO;}
    If pb^[i]>pa^[i] Then Maximum:=No
  end;

  Function FindZap(pa: pdigit; pna: pint): boolean;
  var
   i: integer;
  begin
    FindZap:=False;
    i:=1;
    While (i<=pna^)and(pa^[i]<>Zap)do inc(i);
    if i<=pna^ Then FindZap:=True;
  end;

  Procedure DelFirst (pa: pdigit; pna: pint);
  var
    i: integer;
    x: int;
  begin
    If HYLb(pa,pna) Then
    begin
      pa^[1]:=0;
      pna^:=1;
      exit;
    end;
    x:=1;
    while (x<=pna^)and(pa^[x]=0) do inc(x);
    if pa^[i]=Zap Then dec(i);
    If i<=0 Then Exit;
    For i:=1 to pna^ do
      pa^[i]:=pa^[i+x-1];
    pna^:=pna^-x+1;
  end;

  Procedure DelLast (pa: pdigit; pna: pint);
  begin
    If not FindZap(pa,pna) Then Exit;
    While pa^[pna^]=0 do dec(pna^);
    If pa^[pna^]=Zap then dec(pna^);
  end;

  Function lCorrect (pa,pb: pdigit; pna,pnb: pint): int;
  var
    x,y,w: int;
    i: integer;
  begin
    x:=pna^;
    while (x>=1)and(pa^[x]<>Zap)do dec(x);
    If x>=1 Then
      x:=pna^-x+1;
    y:=pnb^;
    while (y>=1)and(pb^[y]<>Zap)do dec(y);
    If y>=1 Then
      y:=pnb^-y+1;
    If x>y Then w:=x
           Else w:=y;
    lCorrect:=w-1;
    If (FindZap(pa,pna)=False)and(FindZap(pb,pnb)=False)Then Exit;
    For i:=pna^-x+1 to pna^ do
      pa^[i]:=pa^[i+1];
    For i:=pnb^-y+1 to pnb^ do
      pb^[i]:=pb^[i+1];
    If x>y Then pnb^:=pnb^+x-y
           Else pna^:=pna^+y-x;
    dec(pna^);
    dec(pnb^);
  end;

  Procedure RestZap(a: pdigit; na: pint; t: int);
  var
    x: int;
    i: integer;
  begin
    x:=na^-t;
    If x<1 Then
    begin
      For i:=na^-x+1 downto -x+1 do
        a^[i]:=a^[i+x-1];
      For i:=1 to -x+1 do a^[i]:=0;
      a^[-x+1]:=Zap;
      inc(na^);
      DelLast(a,na);
      exit;
    end;
    For i:=na^+1 downto na^-t+2 do
      a^[i]:=a^[i-1];
    a^[na^-t+1]:=Zap;
    inc(na^);
    DelLast(a,na);
  end;

  Procedure lSub(pa,pb,pc: pdigit; pna,pnb,pnc: pint); forward;
  Procedure lAdd(pa,pb,pc: pdigit; pna,pnb,pnc: pint);
  var
    i: integer;
    x,sm: byte;
    h: int;
  begin
    { (-a)+(-b)=-(a+b) }
    If (pa^[0]=1)and(pb^[0]=1) Then pc^[0]:=1;
    { (-a)+(b)=b-a }
    If (pa^[0]=minus)and(pb^[0]=plus) Then
    begin
      pa^[0]:=plus;
      lSub(pb,pa,pc,pnb,pna,pnc);
      exit;
    end;
    { a+(-b)=a-b}
    If (pa^[0]=plus)and(pb^[0]=minus) Then
    begin
      pb^[0]:=plus;
      lSub(pa,pb,pc,pna,pnb,pnc);
      exit;
    end;
    h:=lCorrect(pa,pb,pna,pnb);
    If pna^>pnb^ Then pnc^:=pna^
                 Else pnc^:=pnb^;
    sm:=0;
    Invert(pa,pna);
    Invert(pb,pnb);
    For i:=1 to pnc^ do
    begin
      x:=pa^[i]+pb^[i]+sm;
      sm:=0;
      If x>=10 Then
      begin
        sm:=1;
        x:=x-10;
      end;
      pc^[i]:=x;
    end;
    If sm<>0 Then
    begin
      inc(pnc^);
      pc^[pnc^]:=1;
    end;
    Invert(pc,pnc);
    Invert(pa,pna);
    Invert(pb,pnb);
    RestZap(pa,pna,h);
    RestZap(pb,pnb,h);
    RestZap(pc,pnc,h);
  end;

  Procedure lSub(pa,pb,pc: pdigit; pna,pnb,pnc: pint);
  var
    i,j,l: integer;
    x: byte;
    h: int;
  begin
    { (-a) - (-b) = b - a}
    If (pa^[0]=Minus)and(pb^[0]=Minus) Then
    begin
      pa^[0]:=Plus;
      pb^[0]:=Plus;
      lsub(pb,pa,pc,pnb,pna,pnc);
      exit;
    end;
    { (-a) - b = -(a + b) }
    If (pa^[0]=minus)and(pb^[0]=plus) Then
    begin
      pa^[0]:=plus;
      pb^[0]:=plus;
      lAdd(pa,pb,pc,pna,pnb,pnc);
      pc^[0]:=Minus;
      exit;
    end;
    { (a) - (-b) = a+b }
    If (pa^[0]=plus)and(pb^[0]=minus) Then
    begin
      pb^[0]:=plus;
      lAdd(pa,pb,pc,pna,pnb,pnc);
      exit;
    end;
    If Maximum(pa,pb,pna,pnb)=No Then
    begin
      pc^[0]:=Minus;
      Change(pa,pb,pna,pnb);
    end;
    For i:=1 to pna^ do
      pc^[i]:=0;
    h:=lCorrect(pa,pb,pna,pnb);
    Invert(pa,pna);
    Invert(pb,pnb);
    For i:=1 to pna^ do
    begin
      x:=pa^[i]-pb^[i]+pc^[i];
      If x<0 Then
      begin
        x:=x+10;
        j:=i+1;
        while pa^[j]=0 do inc(j);
        pc^[j]:=pc^[j]-1;
        For l:=i+1 to j-1 do
          pc^[l]:=pc^[l]+9;
      end;
      pc^[i]:=x;
    end;
    i:=pna^;
    While (i>=1)and(pc^[i]=0) do dec(i);
    If i=0 Then inc(i);
    pnc^:=i;
    Invert(pa,pna);
    Invert(pb,pnb);
    Invert(pc,pnc);
    RestZap(pc,pnc,h);
    RestZap(pb,pnb,h);
    RestZap(pa,pna,h);
  end;

  Procedure lMult(pa,pb,pc: pdigit; pna,pnb,pnc: pint);
  var
    i,j: integer;
    x: byte;
    h: int;
  begin
    pc^[0]:=pa^[0]*pb^[0];
    h:=lCorrect(pa,pb,pna,pnb);
    DelFirst(pa,pna);
    DelFirst(pb,pnb);
    Invert(pa,pna);
    Invert(pb,pnb);
    For j:=1 to pnb^ do
      For i:=1 to pna^ do
      begin
        x:=pa^[i]*pb^[j];
        If x>=10 Then
        begin
          pc^[i+j]:=pc^[i+j]+(x div 10);
          x:=x mod 10;
        end;
        pc^[i+j-1]:=pc^[i+j-1]+x;
        If pc^[i+j-1]>=10 Then
        begin
          pc^[i+j]:=pc^[i+j]+(pc^[i+j-1] div 10);
          pc^[i+j-1]:=pc^[i+j-1] mod 10;
        end;
      end;
    i:=pnb^+pna^;
    While (i>=1)and(pc^[i]=0) do dec(i);
    If i<1 Then i:=1;
    pnc^:=i;
    Invert(pc,pnc);
    Invert(pa,pna);
    Invert(pb,pnb);
    RestZap(pc,pnc,h+h);
    RestZap(pa,pna,h);
    RestZap(pb,pnb,h);
  end;

  Procedure lMod (pa,pb,pc,pd: pdigit; var pna,pnb,pnc,pnd: pint);
  var
   i,j: integer;
   tmp, g: tdigit;
   ptmp    : pdigit;
   k, ntmp, ng, zu: int;
   pntmp     : pint;
   s: byte;
  begin
    If HYLb(pa,pna) then
    begin
      pnc^:=1;
      pc^[1]:=0;
      exit;
    end;
    { (-a)/(b)=-(a/b) and (a)/(-b)=-(a/b) }
    If (((pa^[0]=minus)and(pb^[0]=plus))
      or((pa^[0]=plus)and(pb^[0]=minus))) Then
        begin
          pa^[0]:=plus;
          pb^[0]:=plus;
          pc^[0]:=minus;
        end;
    zu:=pnb^;
    k:=0;
    While Maximum(pa,pb,pna,pnb)=yes do
    begin
      inc(pnb^);
      inc(k);
    end;
    pnc^:=k;
    dec(pnb^);
    ptmp:=@tmp;
    pntmp:=@ntmp;
    pd^:=pa^;
    pnd^:=pna^;
    For i:=1 to k do
    begin
      s:=0;
      While Maximum(pd,pb,pnd,pnb)=yes do
      begin
        For j:=1 to pnd^+1 do
          ptmp^[j]:=0;
        lSub(pd,pb,ptmp,pnd,pnb,pntmp);
        inc(s);
        Change(pd,ptmp,pnd,pntmp)
      end;
      pc^[i]:=s;
      dec(pnb^);
    end;
    pnb^:=zu;
    if k=0 Then
    begin
      inc(pnc^);
      pc^[1]:=0;
    end;
  end;

  Procedure lDivide(pa,pb,pc: pdigit; pna,pnb,pnc: pint; t: int);
  var
   u,z,w: tdigit;
   pu,pz,pw: pdigit;
   nu,nz,nw,h: int;
   pnu,pnz,pnw: pint;
   i: integer;
  begin
    nu:=0;
    nz:=0;
    nw:=0;
    Fillchar(u,sizeof(u),0);
    FillChar(z,SizeOf(z),0);
    pu:=@u;
    pz:=@z;
    pw:=@w;
    pnu:=@nu;
    pnz:=@nz;
    pnw:=@nw;
    h:=lCorrect(pa,pb,pna,pnb);
    DelFirst(pa,pna);
    DelFirst(pb,pnb);
    lMod(pa,pb,pc,pu,pna,pnb,pnc,pnu);
    nw:=pnu^;
    inc(nw);
    pc^[pnc^+1]:=zap;
    If ((pnb^-pnu^)>1) Then
    begin
      For i:=1 to pnb^-pnu^-1 do
        pc^[i+pnc^+1]:=0;
      pnc^:=pnc^+pnb^-pnu^-1;
    end;
    If ((pnb^-pnu^)=1)and(Maximum(pu,pb,pnu,pnu)=No) Then
    begin
      pnc^:=pnc^+1;
    end;
    inc(pnc^);
    pnu^:=pnu^+t+1;
    LMod(pu,pb,pz,pw,pnu,pnb,pnz,pnw);
    nu:=pnc^;
    pnc^:=pnc^+pnz^;
    For i:=nu+1 to pnc^ do
      pc^[i]:=pz^[i-nu];
    If (pc^[pnc^]>=5)and(pc^[pnc^-1]<9)
      Then inc(pc^[pnc^-1]);
    pc^[pnc^]:=0;
    dec(pnc^);
    RestZap(pa,pna,h);
    RestZap(pb,pnb,h);
  end;

begin
  Assign(input,'input.txt'); Reset(input);
  Assign(output,'output.txt'); ReWrite(output);
  pa:=@a;
  pna:=@na;
  pb:=@b;
  pnb:=@nb;
  pc:=@c;
  pnc:=@nc;
  LongRead(pa,pna);
  ReadLn;
  LongRead(pb,pnb);
  fillchar(c,sizeof(c),0);
  {Mult}{Add}{Sub}{lMod}{lDivide}
   lAdd(pa,pb,pc,pna,pnb,pnc);
  LongWrite(pc,pnc);
  Close(input);
  Close(output);
end.