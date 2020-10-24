---
title: Bygg ut vårt nät
---

Man förstärker vår signal genom att placera ut en WiFi-router med
speciell mjukvara i sig. Routern behöver inte vara ansluten till
internet.

Ta [kontakt med styrelsen](styrelsen.html) om du vill hjälpa till att
bygga ut vårt nät.

#### Rent praktiskt

Pjodd är ett s.k. [MESH-nätverk](https://sv.wikipedia.org/wiki/Meshnät).

Routers kan placeras utan att koppla en internetsladd till dem. Då
kommer de enbart prata med andra routers i dess närhet. Signalen studsar
från router till router tills dess att den når en som har en
internetsladd kopplad till sig. En ny router i ett område där det inte
finns någon annan måste därför ha en internetsladd i sig för att
fungera.

De routers som har en internetsladd kopplade till sig tunnlar trafiken
vidare till en av våra s.k. gateways, en server på internet där all
trafik går vidare ut till sin slutdestination. Om man väljer att koppla
en internetsladd till routern så finns det ingen möjlighet att spåra att
trafiken kom till vår gateway via den. Tekniskt sett är det alltid
Pjodds gateway som tillhandahåller uppkopplingen ut på själva internet,
inte de som kopplar en internetsladd i sin router.

Problemet med att bara studsa trafik från router till router tills man
når en internetanslutning är att den maximala hastigheten kan halveras
för varje hopp mellan två routers. Om routerna har en snittuppkoppling
på 50Mbps mellan varandra och det tar 5 hopp att komma fram till en
internetuppkoppling blir den maximala hastigheten ut på internet 1Mbps.
Det är nog för att se en film. Är det i stället 10 hopp blir farten
50Kbps. Det är lika långsamt som den sista generationens telefonmodem.
10 hopp representerar några hundra meter på gatunivå. Det är därför
viktigt att man antingen har routers med internetsladd inkopplade på så
många ställen som möjligt, alternativt att man har routers på tak med
fri sikt för att trafiken skall kunna färdas flera kilometer med ett
enda hopp till en internetuppkoppling.

#### Den ekonomiska aspekten

Föreningen kan många gånger tänka sig att betala för routern om du vill
installera en, speciellt om du befinner dig i gränslandet av vårt
täckningsområde eller om du kan tänka dig att koppla upp routern mot en
existerande internetuppkoppling, men då vi har begränsade finanser blir
vi glada om du kan tänka dig att själv betala.

Du kan själv köpa en router eller ta en gammal och programmera om med
vår mjukvara, eller så kan du köpa en genom oss. Vi tar lite betalt för
tiden vi lägger ner på det jobbet, vilket bidrar till att vi kan köpa in
fler routers och gratis placera ut i områden där vi anser det behövs.

#### Routers

Nästan alla routers som klarar av att köra [OpenWRT](https://openwrt.org/)
klarar också av att vara en Pjodd-router. Det handlar om hundratals
olika modeller.

###### TL-MR3020 {#TL-MR3020}

Den minsta modellen av inomhusrouter vi använder, TP-Link TL-MR3020. Den
är extremt liten, har inbygd antenn, drar nästan ingen som helst ström
men klarar bara 150Mbps och har en kort räckvidd. 50cm vit strömkabel
ingår, längre kan ordnas.

![](images/tl-mr3020_in_window_with_coffee_cup.jpg)

###### TL-MR3020 Blandtenna

Pjodd har utvecklat en riktverkande antenn med namnet
[Blandtenna](blandtenna.html) genom att placera en TL-MR3020 i en IKEA
Blanda-skål. Denna kan vädersäkras och ställas utomhus och kan då nå
många hundra meter i stadsmiljö.

![](images/blandtenna_16.jpg)

###### TL-MR3020 i trälåda

MR3020 kan enkelt byggas in i en trälåda som vi drar flätad strömkabel
till i valfri längd, samt installerar batteridrift för en timme om
strömmen skulle gå eller om någon drar ut sladden ur kontaktuttaget.
Dessa installationer gör vi för de där estetik är ett krav.

![](images/wooden_box_in_window_with_coffee_cup.jpg)

![](images/wooden_box_prototype_electronics_on_black_floor.jpg){width=50%}![](images/wooden_box_in_window_with_selection_of_cables.jpg){width=50%}

###### TL-WR841N

En lite större och bättre modell, TP-Link TL-WR841N. Den har externa
antenner och klarar 300Mbps. Räckvidden är god men den ser lite
klumpigare ut. 1,5m svart strömkabel ingår. Det går i skrivande stund
inte att få kortare eller längre.

![](images/tl-wr841n_in_window_with_coffe_cup.jpg)

###### TL-WR741ND

Snarlik TL-WR841N på alla sätt och vis, men har bara en antenn som
dessutom är avtagbar vilket tillåter att man har routern inomhus och
antennen utomhus. Vi har ungefär 50st av denna modell.

###### Övriga inomhusrouters

Det finns många modeller av routers som klarar av mycket mer fart och
som går mycket längre. Dessa är ofta flera gånger större, har antenner
som sticker ut och stora blinkande lysdioder. Det kommer nya modeller
hela tiden och skall vi välja en så tar vi det beslutet när vi behöver
göra det. Dessa modeller kostar ofta 1000 kronor eller mer i butiken.

##### Vår soldrivna takinstallation

Vi har även väderskyddade utomhusinstallationer med batteridrift,
solceller och extern antenn. Om du har tillgång till ett tak med fri
sikt över exempelvis ett torg eller höghusbostadsområde så är vi mycket
intresserade av att få placera ut en sådan där. Priset för dessa routers
är mycket varierande beroende på vad vi har kommit över för material,
men räkna med 4000-6000 kronor per installation inkl fackman för
installation. Pjodd befogar för närvarande över två sådana
installationer som används för att förstärka upp områden innan vi fått
ut tillräckligt med mindre routers för att täcka hela närområdet.

Finns det el tillgängligt på taket eller möjlighet att dra dit
lågspänning så finns det mycket bättre alternativ än vår hemmasnickrade
solcellsdrivna låda.

![](images/open_outdoor_router_on_black_floor.jpg)

![](images/outdoors_router_with_solar_panel_on_height,_back,_on_black_floor.jpg){width=50%}![](images/outdoors_router_with_solar_panel_on_width,_front,_on_black_floor.jpg){width=50%}

##### Mobila

För att temporärt koppla ihop områden där nätet nära på men ännu inte
vuxit samman har vi ett antal cyklar som preparerats med router och
batterier som kan placeras ut och låsas fast. Tyvärr kräver det en del
arbete med att byta och ladda batterierna som dessutom är ganska dyra om
de skall hålla flera dygn.
