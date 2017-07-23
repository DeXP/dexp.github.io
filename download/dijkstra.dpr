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
  v: array [1..MaxV] of gr; {Массив с ссылками на начало}
  adj: array [1..MaxE] of list; {Сами ссылки}
  d: array [1..MaxV] of longint; {Оценка мин. веса}
{--  p: array [1..MaxV] of longint; Будет нужно для восстановления пути}
  n,m,last,x,y,i,w,l,r,tmp,nheap, u: longint;
  heap: array [1..MaxV] of longint; {Куча. В ней хранятся НОМЕРА вершин. Ключ - d c таким номером}
  uk: array [1..MaxV] of longint; {Указатель. Показывает, номер ячейки в куче, где хранится i вершина}

  {Процедуры, относящиеся к куче}

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
    MoveDown(1); {Исправить кучу}
  end;

  {Процедуры, небходимые для дейкстры}

  procedure Initialize_Single_Source(s: longint);
  var
    i: longint;
  begin
    For i:=1 to n do
    begin
      d[i]:=Great;
      {--p[i]:=free;}
    end;
    d[s]:=0; {Мы уже стоим в вершине s. Нам не нужно до неё идти другими путями}
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

  {Процедура добавления ребра в список смежности}

  procedure AddEdge(l,r,w: longint);
  begin
    inc(last); { в adj[last] будет положена текущая дуга}
    adj[last].x:=r; { cамо значение }
    adj[last].w:=w; { добавяем вес }
    adj[last].n:=free; { эта дуга последняя на текущий момент, дальше ничего нет}
    If v[l].n=free Then  {Если дуга, вых. из вершины l, первая}
    begin
      v[l].n:=last;  {То ссылок в массиве v на неё ещё не было - создаём}
      v[l].e:=last;
    end else
      begin
        adj[v[l].e].n:=last; { Иначе указываем из бывшей последней на текуую}
        v[l].e:=last; {...последней делаем текущую дугу}
      end;
  end;

begin
  Assign(input,'input.txt'); Reset(input);
  Assign(output,'output.txt'); ReWrite(output);
  ReadLn(n,m); {n - кол-во вершин; m - кол-во РЕБЕР}
  For i:=1 to n do
  begin
    v[i].n:=free;
    v[i].e:=free;
  end;
  last:=0;
  For i:=1 to m do
  begin
    ReadLn(l,r,w); {Считываем вершины начала и конца ребра, также его вес}
    AddEdge(l,r,w); {Добавляем дугу весом w с началом в l и концом в r}
    AddEdge(r,l,w); {Добавляем дугу весом w с началом в r и концом в l}
  end;
  Read(x,y); {Считываем начальную и конечную вершину}
  Initialize_Single_Source(x); {Инициализируем дейкстру}
  Initialize_Heap(x,n); {Инициализируем кучу}
  while nheap<>0 do {Пока куча не пуста ...}
  begin
    u:=ExtractMin; {Достать вершину, куда можно прийти быстрее всего}
    i:=v[u].n; {Идем по всем ребрам}
    if i<>free Then {Если i - не последняя вершина, то ...}
    repeat
      If Relax(u,adj[i].x,adj[i].w) Then {Если можно улучшить путь - улучшаем ...}
        MoveUp(uk[adj[i].x]);         {... и исправляем кучу}
      i:=adj[i].n; {Переходим к следующей дуге}
    until i=free; {Прошли по всем соседним вершинам, смежным с данной?}
  end;
  WriteLn(d[y]); {Выводим длину кратчайшего пути из х в у}
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
