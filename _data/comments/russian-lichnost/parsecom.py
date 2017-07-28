#!/usr/bin/env python3
from bs4 import BeautifulSoup
from datetime import datetime
from datetime import timezone
import sys


inFile = "lfb+gray+ru.html"
outFolder = "comments"

if len(sys.argv) < 3:
	print("parsecom.py inFile outFolder")
	print("   'inFile' must be Gray Text")
	quit()	
else:
	inFile = sys.argv[1]
	outFolder = sys.argv[2]


def parseClass(resList, className):
	for el in soup.find_all('div', {'class' : className}):
		h = el.get_text(separator=u"\n")
		if h.startswith('.: '):
			h = h[3:]
		if h.endswith(' :.'):
			h = h[:-3]
		h = h.replace("\r", "")
		h = h.replace("\n", '\\r\\n\\r\\n')
		h = h.replace("\"", "\\\"")
		resList.append(h)

symbols = (u"абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ@$",
           u"abvgdeejzijklmnoprstufhzcss_y_euaABVGDEEJZIJKLMNOPRSTUFHZCSS_Y_EUAas")
tr = {ord(a):ord(b) for a, b in zip(*symbols)}

pep = {
'DeXPeriX': 'a713c94ab63e4e5184f87dcd7f0f2471', 
'IMDagger': '92214af72f4ee634f72cef5897eb5d43',
'Tati': '56651a04c8eddabfe5b6d129e8e968ce',
'ХВЕ': 'e30eca916e1416feab9ddbe8528cb462'
}


soup = BeautifulSoup(open(inFile))

hh = []
ht = []
hc = []

hd = []
hn = []
hu = []
he = []

parseClass(hh, 'hh')
parseClass(ht, 'ht')
parseClass(hc, 'cont')

al = 5;
for curdate in ht:
	dt = datetime.strptime(curdate, '%d.%m.%Y')
	timestamp = int( dt.replace(tzinfo=timezone.utc).timestamp() ) + al
	hd.append(timestamp)
	al = al + 5

for curname in hh:
	url = ''
	email = ''
	if curname.endswith(') '):
		url = curname[curname.find("(")+2:curname.find(")")-1]
		curname = curname[:curname.find("(")-1]
	if curname == 'DeXPeriX':
		url = 'https://dexp.in'
	if curname in pep:
		email = pep[curname]
	hn.append(curname)
	hu.append(url)
	he.append(email)



for i in range(1,len(hh)-1):
	#print(hh[i], ht[i], d[i], hc[i])
	enNick = hn[i].translate(tr)
	nick = ''.join(e for e in enNick if e.isalnum()) 
	f = open(outFolder + '/' + str(hd[i]) + '-' + nick  + '.yml', 'w')
	f.write('name: "'+ hn[i] +'"\n')
	f.write('email: "'+ he[i] +'"\n')
	f.write('url: "'+ hu[i] +'"\n')
	f.write('address: ""\n')
	f.write('date: ' + str(hd[i]) + '\n')
	f.write('message: "'+hc[i]+'"')
	f.close()
	print(i, hn[i])

print("Done!")
