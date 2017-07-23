///////////////////////////////////////////////////
//  WinApiCalc - пример WinAPI программирования. //
//  Автор - Dem@nXP                              //
//  E-mail: demanxp@mail.ru                      //
//  ICQ - 606986                                 //
//  Команда - HH-Team (http://hh-team.net.ru)    //
///////////////////////////////////////////////////
// Внимание!!! Данная программа предоставляется  //
// лишь как пример WinAPI программирования. Эта  //
// программа далеко не отлажена и не конкуренто- //
// способна. Однако, основы API программирования //
// на её примере понять можно. Вопросы задавать  //
// на HH-Team форуме http://forum.hh-team.net.ru //
// Желаю удачи и приятно провести время! :)      //
///////////////////////////////////////////////////


program WinApiCalc;
uses
  Windows, Messages;
  {Этих юнитов нам вполне хватит. Однако, не будет многих
  привычных функций, например, FloatToStr (SysUtil). Сейчас
  для нас самый важный фактор - размер. Будем стараться всё
  сделать руками}

{$R *.RES}  //В ресурсе лежит главная иконка


const
  ClientWidth = 223; //ширина нашей формы
  ClientHeight = 233; //высота главной формы
  WndClass = 'TWinApiCalc';
  //имя класса приложения (оно будет использоваться системой)

  WndCaption = 'Калькулятор на Win API'; //Заголовок формы

  Credits = 'WinAPI Calc by Dem@nXP'; //текст метки внизу окна
  

  //Дальше будут константы, соответсвующие чему-либо.

  // Нельзя начинать нумерацию с 1, т.к. этим константам уже
  // что-то соответстует. Начнём нумерацию со 100

  // Кнопки. У каждой должно быть своё уникальное значение.
  BTN_0 = 100;
  BTN_1 = 101;
  BTN_2 = 102;
  BTN_3 = 103;
  BTN_4 = 104;
  BTN_5 = 105;
  BTN_6 = 106;
  BTN_7 = 107;
  BTN_8 = 108;
  BTN_9 = 109;
  BTN_RESULT = 110;      // =
  BTN_Plus = 111;        // +
  BTN_Minus = 112;       // -
  BTN_Add = 113;         // *
  BTN_Divide = 114;      // /
  BTN_RESET = 115;       // эта кнопка взята для примера
  BTN_BACKSPACE = 116;   // Backspace
  BTN_SQRT = 117;        // квадратный корень
  BTN_1divx = 118;       // 1/х
  BTN_PlusMinus = 119;   // +/-
  BTN_Zap = 120;         // Запятая (.)

  //Edit
  Ed_1 = 311;

  //Menu
  mFile = 600;  //Пункт в гл. меню
  mAbout = 700; //Пункт в гл. меню
  sBeep = 601; //Пункт Beep
  sExit = 602;  //Подпункт меню File
  sAbout = 701; //Подпункт меню About
  SEPARATOR = 161; //Сепаратор (прочерк) в гл. меню

  id_Timer = 666; // идентификатор таймера

var
  Wc: TWndClassEx; //класс окна
  Wnd: HWND; //Дескриптор нашей формы
  Msg: TMsg; //Сообщение, которое будем "перехватывать"
  MainMenu: HMENU; //Само главное меню
  SubMenuFile: HMENU; //Пункт File гл. меню (подменю)
  SubMenuAbout: HMENU; //Пункт About гл. меню (подменю)
  Buttons: array[0..20] of HWND; //Дескрипторы кнопок
  Font: HFONT; //Шрифт. Будет применён, для изменения шрифта кнопок
  Edit1 ,Label1: HWND; //Дескриптор поля ввода
  //переменные, нужные для вычисления
  x,y: extended;
  c: char; //хранит действие, которое нужно сделать
  i: integer; //счётчик (для работы с массивом дескрипторов кнопок)


Function GetText: string; //возвращает текст Edit'a
var
  count, //размер буфера
   i: integer;
  buf : array [1..100] of char;  //буфер
  s: string;  //временная переменная, для обработки буфера
begin
  s:='';
  count:=GetWindowTextLength(Edit1); //Узнаём длину текста Edit'a
  SendMessage(Edit1, WM_GetText, SizeOf(buf), integer(@buf));
  //В функцию SendMessage передаются 4 параметра:
  //  1: дескриптор окна
  //  2: Сообщение. В нашем случае - WM_GetText (получить текст)
  //  3: в нашем случае, это размер буфера, куда будет передан текст
  //  4: Указатель на буфер. Т.к. lParam равносилен integer, то
  //  буфер тоже нужно привести к надлежащему виду 

  For i:=1 to Count do
    s:=s+buf[i]; //приписываем этот символ к буферу
 
  //В цикле ниже убираются ведущие нули. Столь сложная проверка
  //связана с тем, что после нуля может стоять запятая
  While (Length(s)>0) //если строка пустая, то мы не сможем
                      //просмотреть первый символ
        and(s[1]='0') do //нужно удалить ведущие (первые) нули
    If Length(s)>1 Then  //Если длина строки больше либо равна двум
                         //т.е. возможна комбинация "0.*****"
      begin
        If s[2]<>'.' Then Delete(s,1,1) //то проверяем второй символ
                     Else Break; // если второй симаол - запятая,
                                 // выходим из цикла
      end
    else Delete(s,1,1); //если длина единична, и нуль присутствует
                        //- удаляем его, иначе будет зацикливание
  GetText:=s; //s - исправленная строка, она и есть результат
end;

//Добавить один символ в текст Edit'a. Функция для удобства
procedure EditAdd(c: char);
var
  s: string;
begin
  s:=GetText; //получаем исправленный текст
  If (s='') and (c='.') Then s:='0'; //если символ - запятая,
                           //то перед ней должен стоять нуль
  s:=s+c; //к исправленному тексту добавляем нужный символ
  SendMessage(Edit1, WM_SetText, Length(s), LParam(s));
  //Посылаем нужный текст в Edit. 
end;

//Для удобства - получить текст Edit'a в виде числа
Procedure Get(var x: extended);
var
  s: string;
  code: integer; //переменная, нужная  для процедуры val
begin
  s:=GetText; //получаем текст Edit'a
  If s='' Then s:='0'; //Если он пустой, то "обнуляем" его
  val(s,x,code); //переводим строку в число
  If code<>0 Then //Если code не равно нулю, то произошла ошибка
     MessageBox( Wnd, 'Входные данные некорректны!', 'Error:', MB_OK or MB_ICONERROR);
end;

//Для удобства - вывод результата-числа в Edit
Procedure WriteIm(x: extended);
var s: string;
begin
  Str(x:0:16,s); //Переводим число в строку с точностью до 16 символов
  While s[Length(s)]='0' do Delete(s,Length(s),1); //удаляем конечные нули
  If s[Length(s)]='.' Then Delete(s,Length(s),1); //если после удаления нулей
                                    //последней осталась запятая - удаляем её
  SendMessage(Edit1, WM_SetText, Length(s), LParam(s)); //Посылаем текст Edit'y
end;

//Основная процедура вычисления :)
Procedure Calculate;
begin
  Get(y); //получаем число, находящееся в Edit'e
  Case c of //смотрим, какое действие нужно выполнить
  '+': x:=x+y; //выполняем
  '-': x:=x-y; // нужное
  '*': x:=x*y; //  действие
  '/': If y<>0 Then x:=x/y
    Else MessageBox(Wnd,'На нуль делить нельзя!','Error', MB_OK or MB_ICONERROR);
  end;
  WriteIm(x); //Выводим число-результат в Edit
  c:=' '; //Обнуляем действие
end;

//В этой процедуре мы "узнаём" первое число и нужное действие
Procedure Process(ch: char);
var
  s: string;
begin
  c:=ch; //запоминаем действие
  Get(x); //получаем первое число
  s:='0'; //обнуляем текст Edit'a
  SendMessage(Edit1, WM_SetText, Length(s), LParam(s));
end;

//Реализует стирание последнего символа в Edit'e
Procedure BACKSPACE;
var
  s: string;
begin
  s:=GetText; //Получаем текст EDit'a
  Delete(s,Length(s),1); //Удаляем последний символ :)
  If s='' Then s:='0'; //Если строка пустая, то "обнуляем" её
  SendMessage(Edit1, WM_SetText, Length(s), LParam(s)); //посылаем текст Edit'y
end;

//Квадратный корень из Edit'a в Edit
Procedure SQRTnow;
begin
  Get(x); //Получаем текст Edit'a ввиде числа
  x:=Sqrt(x); //Получаем кв. корень этого числа
  WriteIm(x); //Выводим число в Edit
end;

Procedure ChangeLabelFont;
var
  x: integer;
begin
   Randomize; //Инициализирует Random, чтобы его числа были более "случайными"
   Font:=CreateFont( //Создаём шрифт со случайными параметрами
    -12,                           // Height
    Random(3)+4,                   // Width
    0,                             // Angle of Rotation
    0,                             // Orientation
    Random(1000),                  // Weight
    Random(2),                     // Italic
    Random(2),                     // Underline
    0,                             // Strike Out
    DEFAULT_CHARSET,               // Char Set
    OUT_DEFAULT_PRECIS,            // Precision
    CLIP_DEFAULT_PRECIS,           // Clipping
    DEFAULT_QUALITY,               // Render Quality
    DEFAULT_PITCH or FF_DONTCARE,  // Pitch & Family
    'Times New Roman');            // Font Name

   SendMessage( Label1, WM_SETFONT, Font, 0 ); //посылаем шрифт
   InvalidateRect (Wnd, nil, False);
end;

//Основная процедура, обрабатывающая сообщения
function WindowProc( Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM ): LRESULT; stdcall;
begin
   //Msg - полученное сообщение
   case Msg of
      //Если програма хочет закрыться
      WM_DESTROY: begin
         PostQuitMessage( 0 );  //Закрываем её
         Result := 0; 
         Exit;  //дальнеёшие сообщения обрабатывать нету смысла - мы закрываемся
      end;
      WM_TIMER: ChangeLabelFont; //Изменяем шрифт метки
      WM_COMMAND: // WM_COMMAND посылается при нажатии кнопок и пунктов меню
         case LoWord( wParam ) of //Интересуящая нас информация лежит в wParam
            //Обрабатываем нажатие пунктов меню
            sExit: PostMessage( Wnd, WM_QUIT, 0, 0 );
            sAbout: MessageBox( Wnd, 'Калькулятор на Win API -'+#10#13+
                                     'OpenSource пример WinAPI'+#10#13+
                                     'программирования от'+#10#13+
                                     '      ..::  Dem@nXP  ::..'+#10#13+
                                     'E-Mail: demanxp@mail.ru'+#10#13+
                                     'ICQ: 606986'+#10#13+
                                     'Team: HH-Team'+#10#13+
                                     'Web: http://hh-team.net.ru'
                                       , 'About', 0 );
            sBeep: MessageBeep( MB_ICONWARNING ); //пикаем :) Ещё одни из
                 // возможных звуков - MB_ICONERROR. Полный список флагов
                 // можно посмотреть в описании функции MessageBox
            //Обрабатываем нажатия кнопок
            BTN_0: EditAdd('0'); //Добавляем один нужный символ
            BTN_1: EditAdd('1');
            BTN_2: EditAdd('2');
            BTN_3: EditAdd('3');
            BTN_4: EditAdd('4');
            BTN_5: EditAdd('5');
            BTN_6: EditAdd('6');
            BTN_7: EditAdd('7');
            BTN_8: EditAdd('8');
            BTN_9: EditAdd('9');
            BTN_ZAP: EditAdd('.');
            BTN_RESULT: Calculate; //при нажатии на "=" делаем вычисления
            BTN_Plus: Process('+'); //запоминаем первое число и действие(+)
            BTN_Minus: Process('-'); //запоминаем первое число и действие(-)
            BTN_ADD: Process('*'); //запоминаем первое число и действие(*)
            BTN_DIVIDE: Process('/'); //запоминаем первое число и действие(/)
            BTN_BACKSPACE: BACKSPACE; //стираем один символ с конца
            BTN_SQRT: SQRTnow; //выисляем кв. корень
            BTN_1divx:
              begin
                //y возьмёт процедура Calculate.
                x:=1; //Eдиницу
                c:='/'; //делим
                Calculate; //на у
              end;
            BTN_PLUSMINUS:
              begin
                Get(x); //получаем х
                WriteIm(-x); //инвертируем знак
              end;
         end;
      else
         Result := DefWindowProc( Wnd, Msg, wParam, lParam );
      // DefWindowProc обеспечивает обработку тех сообщений окна,
      // которые не обрабатывает прикладная программа.
   end;
end;


//Функция, создающая пункты меню
function CreateMenuItem( hMenu, SubMenu: HMENU; Cap: PChar;
                         _uID, _wID: UINT; Sep: boolean ): boolean;
// hMenu - меню, в которое добавляется новый пункт
// SubMenu - связанное с этим пунктом подменю (если оно есть)
// Cap - заголовок нового пункта
// _uID - всегда 0 (этот параметр используется в функции InsertMenuItem)
// _wID - идентификатор, связанный с данным пунктом
// Sep - признак, является ли новый пункт разделителем или нет
var
  Mi: MENUITEMINFO; //эту структуру нужно инициализировать для создания меню
begin
   with Mi do //заполняем структуру
   begin
      cbSize := SizeOf( Mi );
      fMask := MIIM_STATE or MIIM_TYPE or MIIM_SUBMENU or MIIM_ID;
      if not Sep then //если то, что мы создаём, не разделитель
         fType := MFT_STRING //то это обычный текстовый пункт меню
      else
         fType := MFT_SEPARATOR; //иначе - сеператор (разделитель)
      fState := MFS_ENABLED;
      wID := _wID; //идентификатор
      hSubMenu := SubMenu; //подменю (если оно есть)
      dwItemData := 0;
      dwTypeData := Cap; //заголовок нашего пункта меню
      cch := SizeOf( Cap );
   end;
   Result := InsertMenuItem( hMenu, _uID, false, Mi ); //создаём пункт меню
end;

BEGIN
   MainMenu := CreateMenu; //Инициализируем главное меню
   // Заполняем структуру TWndClassEx
   with Wc do
   begin
      cbSize := SizeOf( Wc );
      style := CS_HREDRAW or CS_VREDRAW; //окно должно перерисовываться при
                        //изменении вертикального или горизонтального размера
      lpfnWndProc := @WindowProc; //указатель на оконную процедуру
      cbClsExtra := 0; //Выделенная память, используемая программой по своему усмотрению.
      cbWndExtra := 0; //Выделенная память, используемая программой по своему усмотрению.
      hInstance := hInstance; //описатель экземпляра приложения
      hIcon := LoadIcon(Wnd,'MAINICON'); //иконка приложения
      hCursor := LoadCursor( 0, IDC_ARROW ); //курсор приложения (стрелка)
      hbrBackground := COLOR_BTNFACE+1; //цвет фона формы. Константы цветов можно
                                   //посмотреть в описании функции GETSYSCOLOR
      lpszMenuName := @MainMenu; //указатель на главное меню
      lpszClassName := WndClass; //имя класса создаваемого объекта
   end;
   RegisterClassEx( Wc ); // Регистрируем класс в системе
   SubMenuFile := CreatePopupMenu; //Создаём подменю File
   SubMenuAbout := CreatePopupMenu; //Создаём подменю About
   //Создаём окно
  Wnd := CreateWindowEx ( 0, WndClass, WndCaption, WS_SYSMENU or WS_MINIMIZEBOX,
                          200, 200, ClientWidth, ClientHeight, 0, MainMenu, hInstance, nil);
  //Не буду переписывать то, что уже было написано. Подробнее про эту функцию можно почитать
  //на страничке http://www.firststeps.ru/mfc/winapi/win/r.php?58

  // Создаем пункты главного меню
  CreateMenuItem( MainMenu, SubMenuFile, 'Файл', 0, mFile, false );
  CreateMenuItem( MainMenu, SubMenuAbout, 'Помощь', 0, mAbout, false );

  // Подменю для пункта File
  CreateMenuItem( SubMenuFile, 0, 'Пикнуть', 0, sBeep, false );
  CreateMenuItem( SubMenuFile, 0, '', 0, SEPARATOR, true );
  CreateMenuItem( SubMenuFile, 0, 'Выход', 0, sExit, false );

  // Подменю для пункта About
  CreateMenuItem( SubMenuAbout, 0, 'О программе', 0, sAbout, false );

  // Перерисовываем меню
   DrawMenuBar( Wnd );
   
  // Показываем окно
  ShowWindow( Wnd, SW_SHOWNORMAL );

  // Эту метку создавать совсем необязательно! Я лишь показал однуиз возможностей
  // изменения цвета формы. 

  // Создаём кнопки
   Buttons[0] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '0',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 11, 131, 36, 29, Wnd, BTN_0, hInstance, nil );
   Buttons[1] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '1',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 11, 97, 36, 29, Wnd, BTN_1, hInstance, nil );
   Buttons[2] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '2',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 51, 97, 36, 29, Wnd, BTN_2, hInstance, nil );
   Buttons[3] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '3',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 91, 97, 36, 29, Wnd, BTN_3, hInstance, nil );
   Buttons[4] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '4',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 11, 65, 36, 29, Wnd, BTN_4, hInstance, nil );
   Buttons[5] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '5',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 51, 65, 36, 29, Wnd, BTN_5, hInstance, nil );
   Buttons[6] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '6',
                                 BS_DEFPUSHBUTTON or  WS_VISIBLE or WS_CHILD,
                                 91, 65, 36, 29, Wnd, BTN_6, hInstance, nil );
   Buttons[7] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '7',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 11, 33, 36, 29, Wnd, BTN_7, hInstance, nil );
   Buttons[8] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '8',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 51, 33, 36, 29, Wnd, BTN_8, hInstance, nil );
   Buttons[9] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '9',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 91, 33, 36, 29, Wnd, BTN_9, hInstance, nil );
   Buttons[10] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '=',
                                 BS_DEFPUSHBUTTON or WS_VISIBLE or WS_CHILD,
                                 170, 131, 36, 29, Wnd, BTN_RESULT, hInstance, nil );
   Buttons[11] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '+',
                                 WS_VISIBLE or WS_CHILD,
                                 131, 131, 36, 29, Wnd, BTN_PLUS, hInstance, nil );
   Buttons[12] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '-',
                                 WS_VISIBLE or WS_CHILD,
                                 131, 98, 36, 29, Wnd, BTN_MINUS, hInstance, nil );
   Buttons[13] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '*',
                                 WS_VISIBLE or WS_CHILD,
                                 131, 66, 36, 29, Wnd, BTN_ADD, hInstance, nil );
   Buttons[14] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '/',
                                 WS_VISIBLE or WS_CHILD,
                                 131, 33, 36, 29, Wnd, BTN_DIVIDE, hInstance, nil );
   //Reset is not need :)
   Buttons[16] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', 'BkSp',
                                 WS_VISIBLE or WS_CHILD,
                                 170, 33, 36, 29, Wnd, BTN_BACKSPACE, hInstance, nil );
   Buttons[17] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', 'sqrt',
                                 WS_VISIBLE or WS_CHILD,
                                 170, 66, 36, 29, Wnd, BTN_SQRT, hInstance, nil );
   Buttons[18] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '1/x',
                                 WS_VISIBLE or WS_CHILD,
                                 170, 98, 36, 29, Wnd, BTN_1divx, hInstance, nil );
   Buttons[19] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', '+/-',
                                 WS_VISIBLE or WS_CHILD,
                                 51, 131, 36, 29, Wnd, BTN_PLUSMINUS, hInstance, nil );
   Buttons[20] := CreateWindowEx( WS_EX_STATICEDGE, 'Button', ',',
                                 WS_VISIBLE or WS_CHILD,
                                 91, 131, 36, 29, Wnd, BTN_ZAP, hInstance, nil );
   //Создание кнопок можно было сделать намного проше - циклом. Но это уже задача
   //для самостоятельного решения ;) В этом случае константы кнопок лучше подставлять
   //как число (параметр цикла). А координаты/размер хранить в массиве/ах .

   //Создание окна метки
    Label1:= CreateWindow('Static', Credits, WS_VISIBLE or WS_CHILD or SS_LEFT,
    20, 163, ClientWidth, 20, Wnd, 0, hInstance, nil);

   // Создаём поле ввода (Edit)
   Edit1 := CreateWindowEx( WS_EX_STATICEDGE, 'Edit', '0',
                                  WS_VISIBLE or WS_CHILD,
                                 11, 3, 195, 20, Wnd, Ed_1, hInstance, nil );
   //Создание Edit'a и Label'a не сильно отличается от создания кнопки
   //Как создавать другие контроллы можно почитать на страничке
   // http://www.firststeps.ru/mfc/winapi/win/r.php?58

   //Изменяем шрифт всех кнопок, кроме кнопок с цифрами
   Font := GetStockObject( ANSI_VAR_FONT  ); //на какой шрифт менять
   For i:=10 to 20 do
     SendMessage( Buttons[i], WM_SETFONT, Font, 0 ); //посылаем шрифт

   //Изменяем шрифт нижнего Label'a
   SendMessage(Wnd, WM_TIMER,0, 0); //Как будто у нас сработал таймер

   SetTimer (Wnd, id_Timer, 1000, nil); //вешаем таймер

  // Цикл обработки сообщений
  while GetMessage( Msg, 0, 0, 0 ) do
  begin
    TranslateMessage( Msg );
    DispatchMessage( Msg );
  end;
  Halt( Msg.wParam );
END.
