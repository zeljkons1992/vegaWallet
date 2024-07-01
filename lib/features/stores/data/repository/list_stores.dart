import '../model/store.dart';

final List<Store> listStores = [
  const Store(
    id: 1,
    addressCities: [
      AddressCities(address: "Bul Mihajla Pupina", city: "Novi Sad"),
      AddressCities(address: "Bul Vudroa Vilsona 12, TC Galerija", city: "Beograd"),
    ],
    category: "Kafići i Restorani",
    conditions: ["Dine In", "Za obrok rezervacija", "za min 4 osobe", "Obavezna rezervacija"],
    discounts: ["20% na piće", "10% na hranu"],
    name: "Pupin Lounge",
  ),
  const Store(
    id: 2,
    addressCities: [
      AddressCities(address: "Fruškogorska 16", city: "Novi Sad"),
    ],
    category: "Usluge",
    conditions: ["Porudzbina preko telefona 0606500925", "dostava se naplaćuje", "naglasiti Vega IT popust"],
    discounts: ["10% na ketering"],
    name: "Čarolija ketering",
  ),
  const Store(
    id: 3,
    addressCities: [
      AddressCities(address: "Dunavska 17", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: ["Dine In"],
    discounts: ["10% na piće i hranu"],
    name: "Kuća Mala",
  ),
  const Store(
    id: 4,
    addressCities: [
      AddressCities(address: "Maksima Gorkog 17a", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: ["Dine In"],
    discounts: ["20% na piće i hranu"],
    name: "Concept Relax",
  ),
  const Store(
    id: 5,
    addressCities: [
      AddressCities(address: "TC Promenada", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: ["Dine in"],
    discounts: ["10% na piće i hranu"],
    name: "Loft Rooftop",
  ),
  const Store(
    id: 6,
    addressCities: [
      AddressCities(address: "Njegoševa 2", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: [],
    discounts: [],
    name: "Loft Downtown",
  ),
  const Store(
    id: 7,
    addressCities: [
      AddressCities(address: "Futoški put 93b", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: [],
    discounts: [],
    name: "Loft Factory",
  ),
  const Store(
    id: 8,
    addressCities: [
      AddressCities(address: "Štrand", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: [],
    discounts: [],
    name: "Loft River",
  ),
  const Store(
    id: 9,
    addressCities: [
      AddressCities(address: "Fruškogorska 30", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: [],
    discounts: [],
    name: "Loft Biciklana",
  ),
  const Store(
    id: 10,
    addressCities: [
      AddressCities(address: "Bul Oslobođenja 63a", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: [],
    discounts: ["15% na piće i hranu"],
    name: "Loft Boulevard",
  ),
  const Store(
    id: 11,
    addressCities: [
      AddressCities(address: "Njegoševa 8", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: [],
    discounts: ["10% na piće i hranu"],
    name: "Loft and craft bar",
  ),
  const Store(
    id: 12,
    addressCities: [
      AddressCities(address: "Trg slobode 4", city: "Novi Sad"),
    ],
    category: "Kafići i Restorani",
    conditions: ["Dine in"],
    discounts: ["10% na piće i hranu"],
    name: "Modena",
  ),
  const Store(
    id: 13,
    addressCities: [
      AddressCities(address: "Sremska 9", city: "Novi Sad"),
      AddressCities(address: "Vila Gorica, pored hotela Grand", city: "Kopaonik"),
    ],
    category: "Kafići i Restorani",
    conditions: ["Dine in", "Plaćanje isključivo kešom"],
    discounts: ["15%"],
    name: "Camelot",
  ),
  const Store(
    id: 14,
    addressCities: [
      AddressCities(address: "Pupinova 5", city: "Zrenjanin"),
    ],
    category: "Kafići i Restorani",
    conditions: ["Nema ograničenja na broj osoba", "bitno je identifikovati se karticom pre izdavanja računa i ukupan iznos se umanjuje za 10%", "u specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"],
    discounts: ["10% popusta na svu hranu iz ponude i piće koje se poručuje uz hranu"],
    name: "Walter",
  ),
  const Store(
    id: 15,
    addressCities: [
      AddressCities(address: "Koče Kolarova 30", city: "Zrenjanin"),
    ],
    category: "Kafići i Restorani",
    conditions: ["Nema ograničenja na broj osoba", "bitno je identifikovati se karticom pre izdavanja računa i ukupan iznos se umanjuje za 10%", "u specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"],
    discounts: ["10% popusta na svu hranu iz ponude i piće koje se poručuje uz hranu"],
    name: "Bistro Funk",
  ),
  const Store(
    id: 16,
    addressCities: [
      AddressCities(address: "Bulevar Milutina Milankovića bb", city: "Zrenjanin"),
    ],
    category: "Kafići i Restorani",
    conditions: ["Nema ograničenja na broj osoba", "bitno je identifikovati se karticom pre izdavanja računa i ukupan iznos se umanjuje za 10%", "u specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"],
    discounts: ["10% popusta i na hranu i na piće (zejedno/nezavisno) - kompletna ponuda"],
    name: "Lion Pub",
  ),
  const Store(
    id: 17,
    addressCities: [
      AddressCities(address: "Kralja Aleksandra I Karađorđevića 18", city: "Zrenjanin"),
    ],
    category: "Usluge",
    conditions: ["Nema ograničenja na broj osoba", "bitno je identifikovati se karticom pre izdavanja računa i ukupan iznos se umanjuje za 10%", "u specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"],
    discounts: ["10% popusta na kompletnu ponudu"],
    name: "Venera Sweet",
  ),
  const Store(
    id: 18,
    addressCities: [
      AddressCities(address: "Novosadska 7, Ečka 23203", city: "Zrenjanin"),
    ],
    category: "Putovanja",
    conditions: ["Nema ograničenja na broj osoba bilo da su u pitanju restoranske ili usluge smeštaja", "U restoranu: vlasnici Privilege kartice pre nego što traže račun moraju konobaru pokazati Privilege card kako bi ostvarili navedeni popust", "Za smeštaj: vlasnici Privilege kartice pri pravljenju rezervacije treba da naglase da imaju Privilege card koju je potrebno i da pokažu na prijavi na recepciji", "u specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"],
    discounts: ["10% popusta na usluge smeštaja", "10% popusta na restoranske usluge - (piće/hrana, zajedno/nezavisno) - kompletna ponuda bez ograničenja"],
    name: "Kaštel Ečka",
  ),
  const Store(
    id: 19,
    addressCities: [
      AddressCities(address: "Veselina Masleše 16, Novi Sad", city: "Novi Sad"),
      AddressCities(address: "Gavrila Principa 52, Beograd", city: "Beograd"),
      AddressCities(address: "Hum BB", city: "Foča"),
    ],
    category: "Putovanja",
    conditions: [
      "Pokazati karticu prilikom check in, kada se vrši plaćanje.",
      "https://rafting-tarom.com",
      "Rezervacija preko tel",
      "Depozit 100e",
      "Prilikom rez naglasiti da ima popust zaposlenog Vega IT"
    ],
    discounts: ["10% na smeštaj (comfort i superior) i aktivnosti"],
    name: "Rafting centar RT - Foča",
  ),
  const Store(
    id: 20,
    addressCities: [
      AddressCities(address: "Veselina Masleše 16, Novi Sad", city: "Novi Sad"),
      AddressCities(address: "Gavrila Principa 52, Beograd", city: "Beograd"),
      AddressCities(address: "Jahorina", city: "Jahorina"),
    ],
    category: "Putovanja",
    conditions: [
      "Pokazati karticu prilikom plaćanja na check in-u",
      "http://www.rtapartmani-jahorina.com",
      "Depozit 100e",
      "Naglasiti da ima popust zaposlenog Vega IT"
    ],
    discounts: ["10% na smeštaj i aktivnosti"],
    name: "RT apartmani Jahorina",
  ),
  const Store(
    id: 21,
    addressCities: [
      AddressCities(address: "Matej BB, Sremski Karlovci 21205", city: "Karlovci"),
    ],
    category: "Putovanja",
    conditions: [
      "Mora da se napravi nalog sa vegati maila",
      "Prilikom rezervacije ukucati kod KORP23",
      "Rezervacija putem web stranice https://lalavineyard.com",
      "Obavezno na check inu pokazati karticu"
    ],
    discounts: ["10% na smeštaj", "20% na hranu i piće"],
    name: "Lala Vineyard Resort",
  ),
  const Store(
    id: 22,
    addressCities: [
      AddressCities(address: "Veselina Masleše 16, Novi Sad", city: "Novi Sad"),
      AddressCities(address: "Gavrila Principa 52, Beograd", city: "Beograd"),
      AddressCities(address: "Grčka", city: "Grčka"),
    ],
    category: "Putovanja",
    conditions: [
      "Pokazati karticu prilikom bookiranja u agenciji",
      "https://www.hedonictravel.rs"
    ],
    discounts: ["10% na apartmane", "5% na hotele"],
    name: "Hedonic Travel",
  ),
  const Store(
    id: 23,
    addressCities: [
      AddressCities(address: "Divčibare", city: "Divčibare"),
    ],
    category: "Putovanja",
    conditions: ["Rezervacija putem maila events@hotelcrnivrh.rs"],
    discounts: [
      "15% na aktuelne cene (odnosno u trenutku rezervacije) boravka (smeštaj i polupansion)",
      "10% popusta na usluge u kafiću i lounge baru hotela",
      "10% popusta na usluge a la carte Restorana '4' koji je ukviru našeg rizorta",
      "15% na masaže i tretmane lica"
    ],
    name: "Crni vrh",
  ),
  const Store(
    id: 24,
    addressCities: [
      AddressCities(address: "Svetog Save 2", city: "Vrnjačka Banja"),
    ],
    category: "Putovanja",
    conditions: [],
    discounts: ["15% na aktuelne hotelske cene"],
    name: "Tonanti",
  ),
  const Store(
    id: 25,
    addressCities: [
      AddressCities(address: "Kopaonik", city: "Kopaonik"),
    ],
    category: "Putovanja",
    conditions: [
      "Popust se odnosi na redovne cene iz cenovnika i ne može se popust primeniti na neku akciju koja je u određenom terminu aktuelna (kao što je Rani booking, ski openig itd).",
      "Nosioci popusta mogu da budu samo zaposleni Vega IT, i taj popust bi se odnosio na celu rezervaciju( za koliko god da je ljudi rezervisano, samo je potrebno da ta osoba bude korisnik rezervacije i bude prijavljena u hotelu).",
      "Sama procedura je jednostavna dovoljno je da prilikom slanja zahteva za rezervaciju uputi mail preko službenog maila- gde se vidi u potpisu da je zaposlen u toj firmi, a po samom domenu maila, ukoliko u okviru vaše firme zaposleni ne koriste mail naloge možemo da dogovorimo da nam pošalju sliku njihove benefit kartice kako bi mogli da primenimo popust.",
      "Pokazivanje kartice na c/i mozemo da ostavimo, ali kako sve rezervacije moraju biti avansirane pre dolaska 100%, a samim tim i popust mora pre uplate da se obračuna, možemo onda staviti da. Prilikom zahteva rezervacije u prilog ostave i sliku Privilege kartice."
    ],
    discounts: ["7% na cene smeštaja i polupansiona 01.12.2023.-06.04.2024."],
    name: "Hotel Putnik",
  ),
  const Store(
    id: 26,
    addressCities: [
      AddressCities(address: "Andrije Jevremovića 132 a", city: "Zlatibor"),
    ],
    category: "Putovanja",
    conditions: [
      "Apartman je vlasništvo našeg kolege Kusturić Dragoslava",
      "https://www.instagram.com/apartman_22?igshid=ODA1NTc5OTg5Nw==",
      "Kontakt telefon: 065/88-46-295 i/ili 063/74-04-524"
    ],
    discounts: ["10% na cenu smeštaja do 4 noćenja", "15% popusta preko 4 noćenja"],
    name: "Apartman 22",
  ),
  const Store(
    id: 27,
    addressCities: [
      AddressCities(address: "Takovska 49, Beograd 11000", city: "Beograd"),
    ],
    category: "Putovanja",
    conditions: [],
    discounts: [
      "Standard soba - cena jednokrevetne sobe iznosi 90€, po sobi, po noći + boravišna taksa 160 rsd, po osobi, po noći.",
      "Superior soba – cena jednokrevetne sobe iznosi 110€, po sobi, po noći + boravišna taksa 160 rsd rsd, po osobi, po noći",
      "Doplata za drugu osobu, u dvokrevetnoj sobi iznosi 15€, po noći + boravišna taksa 160 rsd, po osobi, po noći",
      "U navedene cene je uključen doručak i PDV"
    ],
    name: "Radisson RED Belgrade",
  ),
  const Store(
    id: 28,
    addressCities: [
      AddressCities(address: "Bulevar oslobođenja 27", city: "Novi Sad"),
      AddressCities(address: "Gradski park 2", city: "Zemun"),
      AddressCities(address: "Batajnički drum 1", city: "Beograd"),
      AddressCities(address: "Partijarha Joanikija 2a", city: "Beograd"),
      AddressCities(address: "Palmira Toljatija 7", city: "Novi Beograd"),
    ],
    category: "Zabava",
    conditions: ["zakup staze min 2h", "Rezervacija staze potrebna unapred"],
    discounts: ["10%"],
    name: "Kuglana Žabac",
  ),
  const Store(
    id: 29,
    addressCities: [
      AddressCities(address: "edu2wine.com", city: "Novi Sad"),
      AddressCities(address: "edu2wine.com", city: "Beograd"),
    ],
    category: "Zabava",
    conditions: ["Rezervacija putem mail-a office@tvojavinoteka.rs"],
    discounts: ["20% na obuke, degustacije i vinske ture"],
    name: "Edu2Wine",
  ),
  const Store(
    id: 30,
    addressCities: [
      AddressCities(address: "Bulevar Mihajla Pupina 3", city: "Novi Sad"),
    ],
    category: "Zabava",
    conditions: [
      "Popust važi od ponedeljka do četvrtka, ne važi za premijere",
      "Popust važi za max 2 kupljene karte",
      "Važi od 03.07.2023."
    ],
    discounts: ["300rsd za 2D i 400rsd za 3D projekcije"],
    name: "Arena Bioskop",
  ),
  const Store(
    id: 31,
    addressCities: [
      AddressCities(address: "Bulevar Mihajla Pupina 3", city: "Novi Sad"),
    ],
    category: "Zabava",
    conditions: ["Kontakt: Tamara 062228169"],
    discounts: [
      "Besplatna rođendaonica",
      "50rs popust po karti",
      "20% popusta na piće"
    ],
    name: "Rođendaonica Arena Bioskop",
  ),
  const Store(
    id: 32,
    addressCities: [
      AddressCities(address: "Rođendaonica", city: "Novi Sad"),
    ],
    category: "Zabava",
    conditions: [
      "Instagram stranica: woody_playandlearn",
      "Kontakt telefon: 0642544579"
    ],
    discounts: ["10%"],
    name: "Woody play and learn",
  ), const Store(
    id: 33,
    addressCities: [
      AddressCities(address: "Šajkaška 15a", city: "Novi Sad"),
      AddressCities(address: "Rumenački put 2", city: "Novi Sad"),
      AddressCities(address: "Karađorđeva 27", city: "Sr Kamenica"),
    ],
    category: "Usluge",
    conditions: ["Besplatno dovoženje i odvoženje kola na tehnički pregled"],
    discounts: ["15% na tehnički pregled"],
    name: "Triumf 021",
  ),
  const Store(
    id: 34,
    addressCities: [
      AddressCities(address: "Augusta Cesarca 18", city: "Novi Sad"),
    ],
    category: "Usluge",
    conditions: ["https://epicstranijezici.rs/"],
    discounts: ["10% na kurseve", "15% na online kurseve"],
    name: "Epic Centar stranih jezika",
  ),
  const Store(
    id: 35,
    addressCities: [
      AddressCities(address: "Trg republike 16", city: "Novi Sad"),
    ],
    category: "Usluge",
    conditions: [
      "Prioritetan pristup novo-dodatim nekretninama, obezbeđujući im priliku da istraže i obezbede željene domove",
      "Dodeljenog agenta za nekretnine koji će pružati personalizovanu pomoć tokom celog procesa sa nekretninama",
      "info.familynekretnine@gmail.com",
      "0691410207"
    ],
    discounts: ["10-20%, u zavisnosti od cene iznajmljivanja nekretnine"],
    name: "Family nekretnine",
  ),
  const Store(
    id: 36,
    addressCities: [
      AddressCities(address: "Radoja Dakića 47", city: "Niš"),
    ],
    category: "Usluge",
    conditions: [],
    discounts: ["5% na individualne i grupne časove"],
    name: "Škola stranih jezika Star",
  ),
  const Store(
    id: 37,
    addressCities: [
      AddressCities(address: "Miće Popovića 27", city: "Novi Sad"),
    ],
    category: "Usluge",
    conditions: ["061-632-11-88", "www.logopednovisad.rs"],
    discounts: ["25% popusta na prvi pregled i svaki 10. tretman je besplatan"],
    name: "LogoVox",
  ),
  const Store(
    id: 38,
    addressCities: [
      AddressCities(address: "Gornje Sajlovo 2V", city: "Novi Sad"),
    ],
    category: "Usluge",
    conditions: ["tp.sajlovo.damir@gmail.com", "0658066866"],
    discounts: [
      "Uz kompletnu registraciju vozila, popust od 1500 rsd na tehnički pregled",
      "Svaki deseti klijent koji ih poseti, dobija tehnički pregled potpuno besplatno"
    ],
    name: "Tehnički pregled Adriatic",
  ),
  const Store(
    id: 39,
    addressCities: [
      AddressCities(address: "Šajkaška 15a", city: "Novi Sad"),
    ],
    category: "Usluge",
    conditions: ["065 53 666 77"],
    discounts: ["20% na sve usluge"],
    name: "Auto Detailing Trijumf",
  ),
  const Store(
    id: 40,
    addressCities: [
      AddressCities(address: "Nušićeva 31", city: "Zrenjanin"),
    ],
    category: "Usluge",
    conditions: [
      "Prilikom pozivanja dispečerskog centra 023/611-111, sve što treba da iskomunicirate da je u pitanju VIP vožnja. U tom slučaju vozač dobija vožnju uz informaciju o popustu te nije neophodno bilo šta drugo komunicirati niti se identifikovati Privilege karticom",
      "Ukoliko vozilo zaustavite u pokretu, takođe je potrebno naglasiti da je u pitanju VIP vožnja ali identifikovanje Privilege karticom pre plaćanja",
      "Dispečerski centar: 023/611-111",
      "Viber: 060/521-5111 (besplatan poziv ili poruka)",
      "U specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac",
      "Instagram"
    ],
    discounts: ["10% popusta na gradsku vožnju", "10% popusta na međugradsku vožnju"],
    name: "AS taxi",
  ),
  const Store(
    id: 41,
    addressCities: [
      AddressCities(address: "Trg mladenaca 6", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["Kontakt telefon: 638041065"],
    discounts: ["10% na usluge"],
    name: "Ćetković Stomatološka ordinacija",
  ),
  const Store(
    id: 42,
    addressCities: [
      AddressCities(address: "Heroja Pinkija 21", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: [],
    discounts: ["30% na specijalistički pregled", "20% na fizikalne terapije"],
    name: "ArtFizio by Dr Karmela",
  ),
  const Store(
    id: 43,
    addressCities: [
      AddressCities(address: "Resavska 2", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: [],
    discounts: ["1500 rsd terapija (Redovna cena 2500)"],
    name: "Oxybaric Hiperbarične komore",
  ),
  const Store(
    id: 44,
    addressCities: [
      AddressCities(address: "Danila Kiša 14", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: [],
    discounts: ["15% na usluge"],
    name: "Lotos Spa",
  ),
  const Store(
    id: 45,
    addressCities: [
      AddressCities(address: "Đorđa Servickog 14", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: [
      "Instaliranjem njihove aplikacije i pored popusta možete skupljati poene za cash back",
      "Hiperbarična komora 10 tretmana 20.000"
    ],
    discounts: ["15% na usluge"],
    name: "Jadore Kozmetički salon",
  ),
  const Store(
    id: 46,
    addressCities: [
      AddressCities(address: "Bulevar Oslobođenja 70", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["Zakazivanje na 064 1617181"],
    discounts: ["10% na usluge"],
    name: "VivaDent Stomatološka ordinacija",
  ),
  const Store(
    id: 47,
    addressCities: [
      AddressCities(address: "Slovačka 13", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["Zakazivanje online na www.sonrisa.rs"],
    discounts: ["10% na usluge", "Prvo zakazivanje besplatan pregled, skidanje kamenca i poliranje"],
    name: "Sonrisa Stomatološka ordinacija",
  ),
  const Store(
    id: 48,
    addressCities: [
      AddressCities(address: "Balzakova 31", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: [],
    discounts: ["10% na privatne treninge i spa usluge"],
    name: "Fit Spa Fitness & Spa",
  ),
  const Store(
    id: 49,
    addressCities: [
      AddressCities(address: "Grčkoškolska 10", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["Zakazivanje Bane Hair 0612270907; Modni frizer Vojkan 0638657643"],
    discounts: ["10% na preparate", "20% na usluge"],
    name: "Bane Hair, Modni frizer Vojkan",
  ),
  const Store(
    id: 50,
    addressCities: [
      AddressCities(address: "Gundulićeva 5", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["Zakazivanje na 0216553040"],
    discounts: ["10% na usluge, plaćanje kešom"],
    name: "Goga Nikolić Stomatološka ordinacija",
  ),
  const Store(
    id: 51,
    addressCities: [
      AddressCities(address: "Trg Slobode 3, hotel Vojvodina", city: "Zrenjanin"),
    ],
    category: "Zdravlje i wellness",
    conditions: [
      "Zakazivanje online",
      "Code: Vega IT",
      "Facebook",
      "U specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"
    ],
    discounts: [
      "10% popusta na usluge Relax i sportske masaže",
      "10% popusta na usluge saune",
      "Ukoliko dođete sa partnerom - popust za naznačene usluge biće uvažen na ukupan račun",
      "Popust se ne može ostvariti na tretmane oblikovanja tela i usluge fizikalne terapije",
      "Popust se ne može ostvariti na kupovinu poklon vaučera"
    ],
    name: "Fizio spa Wellness centar",
  ),
  const Store(
    id: 52,
    addressCities: [
      AddressCities(address: "Trg Fehera Ferenca 7", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["Zakazivanje na 0658814401"],
    discounts: ["10% na usluge za zaposlene Vega IT", "5% na usluge za porodicu, otac, majka, supruga, suprug, deca"],
    name: "Stomatološka ordinacija Plešta",
  ),
  const Store(
    id: 53,
    addressCities: [
      AddressCities(address: "Kosovska 7", city: "Novi Sad"),
      AddressCities(address: "Milovana Marinkovića 23", city: "Beograd"),
      AddressCities(address: "TC Galerija", city: "Beograd"),
    ],
    category: "Zdravlje i wellness",
    conditions: [],
    discounts: ["10% na tretmane"],
    name: "Rea Medika Poliklinika za plastičnu hirurgiju, internu medicinu i radiologiju",
  ),
  const Store(
    id: 54,
    addressCities: [
      AddressCities(address: "https://www.healthandfit.shop", city: "Indjija"),
    ],
    category: "Zdravlje i wellness",
    conditions: [
      "Besplatna dostava u Novosadskog sajma 2, Stražilovska 2, utorkom i četvrtkom",
      "Plaćanje uplata na račun ili keš prilikom dostave",
      "U napomenu upisati VEGA IT kako bi znali gde da dostave i da obračunaju popust"
    ],
    discounts: [
      "20% na PURE NUTRITION USA brand",
      "20% na HS Labs brand",
      "10% na ostale brendove"
    ],
    name: "Health and Fit",
  ),
  const Store(
    id: 55,
    addressCities: [
      AddressCities(address: "Mornarska 32", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["Rezervišite termin putem mejla wellnshts@gmail.com ili telefona +381654555514"],
    discounts: [
      "10% zakup spa zone",
      "15% individualne treninge",
      "15% grupne treninge"
    ],
    name: "WellNS Trening i spa centar",
  ),
  const Store(
    id: 56,
    addressCities: [
      AddressCities(address: "Đorđa Rajkovića 7", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: [
      "Za nutrigenetski test možete poslati upit na mail nutrigenrs@gmail.com ili se javiti na broj telefona 063 88 23 755",
      "Može se plaćati na rate karticom Banka Intese bez kamate"
    ],
    discounts: ["20% na sve", "20% na nutrigenetski test, važi i za uže članove porodice"],
    name: "Sport Medica Poliklinika",
  ),
  const Store(
    id: 57,
    addressCities: [
      AddressCities(address: "Park Novi Residence, Đorđa Nikšića Johana 29", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["Zakazivanje na 065 8320977"],
    discounts: ["15% na usluge za zaposlene Vega IT i članove najuže porodice"],
    name: "Stomatološka ordinacija 'Jelena'",
  ),
  const Store(
    id: 58,
    addressCities: [
      AddressCities(address: "Sedmi Juli", city: "Niš"),
    ],
    category: "Zdravlje i wellness",
    conditions: [],
    discounts: ["10% na masaže i treninge"],
    name: "Top Form Trening i spa centar",
  ),
  const Store(
    id: 59,
    addressCities: [
      AddressCities(address: "Strahinjića Bana bb", city: "Niš"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["https://docs.google.com/document/d/1TzArS4cTRlS9C6dzGMMitH20qCtfq0Z0I8VWkto8FGM/edit"],
    discounts: ["Cenovnik u dokumentu"],
    name: "Duodent Stomatološka ordinacija",
  ),
  const Store(
    id: 60,
    addressCities: [
      AddressCities(address: "Bulevar Nikole Tesle 7", city: "Niš"),
    ],
    category: "Zdravlje i wellness",
    conditions: [],
    discounts: ["10% na osnovne intervencije i 5% za protetske radove"],
    name: "Ordinacija Milica Milutinović - Ćirić",
  ),
  const Store(
    id: 61,
    addressCities: [
      AddressCities(address: "Bulevar Jovana Dučića 17", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["www.zonakomfora.rs"],
    discounts: ["10% na masaže i manuelne terapije"],
    name: "Centar 'Zona Komfora'",
  ),
  const Store(
    id: 62,
    addressCities: [
      AddressCities(address: "Teodora Pavlovića 36", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: [
      "Prilikom dolaska bitno je identifikovati se Privilege karticom",
      "Termini se mogu zakazati putem mobilnog telefona 0653019930 ili 0212704950",
      "Instagram",
      "Facebook",
      "Ovu pogodnost mogu koristiti i partneri naših zaposlenih i članovi šire porodice (sem dece - ne bave se dečijom rehabilitacijom) uz prisustvo zaposlenog koji će se identifikovati Privilege karticom",
      "U specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"
    ],
    discounts: [
      "BESPLATNE konsultacije iz oblasti fizikalne medicine i rehabilitacije (zaposleni u Vega IT će dobijati stručne preporuke, eventualno predlog koje dijagnostičke procedure je potrebno uraditi, kom lekaru se obratiti, plan rehabilitacije zdravstvenog programa, po potrebi terapeutske testove i sl.) Zaposleni će nakon toga moći da se odluče gde se lečiti i da li će koristiti polisu osiguranja ili ne."
    ],
    name: "Fiziokinetix Ambulanta za medicinsku rehabilitaciju",
  ),
  const Store(
    id: 63,
    addressCities: [
      AddressCities(address: "Splitska 2", city: "Zrenjanin"),
    ],
    category: "Zdravlje i wellness",
    conditions: [
      "Prilikom zakazivanja napomenuti da ste iz komapnije Vega IT kako bi se uvažile povlastice uz Privilege card i identifikovati se karticom pri dolasku",
      "Samsara Wellbeing studio - sajt",
      "LinkedIn",
      "Instagram",
      "U specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"
    ],
    discounts: [
      "10% popust na individualne i grupne koučing sesije - online ili uživo",
      "10% popust na joga radionice i joga putovanja",
      "10% popust na online joga programe",
      "članovi porodice mogu ostvariti popust od 5% na gore navedeno, u prisustvu zaposlenog kao korisnika Privilege kartice"
    ],
    name: "Samsara Wellbeing Studio",
  ),
  const Store(
    id: 64,
    addressCities: [
      AddressCities(address: "Novosadskog sajma 23", city: "Novi Sad"),
      AddressCities(address: "Futoška 1", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: [
      "Zakazivanje se vrši putem kontakta: Dusanka Miloševic +381631585227",
      "Instagram: studio_belo_ns"
    ],
    discounts: [
      "30% popust na sve",
      "Estetski i medicinski pedikir",
      "Depilacija medom",
      "Terapeutska masaža",
      "Švedska masaža",
      "Anticelulit",
      "Relax",
      "Slim paketi",
      "Tretmani lica",
      "Nokti"
    ],
    name: "Studio Belo Kozmetički salon",
  ),
  const Store(
    id: 65,
    addressCities: [
      AddressCities(address: "Svi veći gradovi u Srbiji", city: "Svi veći gradovi u Srbiji"),
    ],
    category: "Zdravlje i wellness",
    conditions: [
      "Za sva dodatna pitanja i podršku, zaposleni se mogu javiti na mejl: katarina.milincic@geneplanet.rs ili kontakt telefon: 065 45 44 322 i ostvariti ove pogodnosti."
    ],
    discounts: [
      "20% popusta na cenu testa prilikom plaćanja u celosti",
      "Basic Test: 330 EUR (regularna cena 410e)",
      "Advanced Test: 430 EUR (regularna cena 530e)",
      "Premium Test: 480 EUR (regularna cena 600e)"
    ],
    name: "GenePlanet Prenatalni test Lumipeek",
  ),
  const Store(
    id: 66,
    addressCities: [
      AddressCities(address: "Novi Sad, opcija dolaska na kućnu adresu", city: "Novi Sad"),
    ],
    category: "Zdravlje i wellness",
    conditions: ["Instagram stranica: https://www.instagram.com/pt_petar_vrzic?igsh=MXY3NXkyaGlveXd1bQ=="],
    discounts: [
      "Celo telo 3000 din - 90 min (umesto 3500din)",
      "Ledja-noge 2000 din - 60 min (umesto 2500din)",
      "Ledja 1500 din - 45 min (umesto 2000din)",
      "Noge 1500 din - 45 min (umesto 2000din)",
      "Trup 1500 din - 45 min (umesto 2000din)",
      "Lice 1000 din - 30 min (umesto 1500din)",
      "Stopala 1000 din - 45 min (umesto 1500din)"
    ],
    name: "Petar Vržić Masaže",
  ),  const Store(
    id: 67,
    addressCities: [
      AddressCities(address: "https://knjigaprica.com/pocetna", city: "Online"),
    ],
    category: "Kupovina",
    conditions: ["Pri checkout ukucati kod VEGAIT"],
    discounts: ["20% na kupovinu audio knjige"],
    name: "Knjiga Priča-audio knjige",
  ),
  const Store(
    id: 68,
    addressCities: [
      AddressCities(address: "Svi gradovi", city: "Svi gradovi"),
    ],
    category: "Kupovina",
    conditions: [
      "*Popust se obračunava na maloprodajnu cenu.",
      "*Popust važi za plaćanje gotovinom, platnim karticama (dospeće odmah) i čekovima.",
      "*Popust se ne može kombinovati sa drugim ponudama, akcijama i popustima.",
      "*Popust se ne odnosi na artikle sa oznakom ŠOK cena ili TOP artikal.",
      "*Popust važi sam za kupovinu u objektu, ne za online.",
      "20% svakog 30og u mesecu"
    ],
    discounts: ["15% na sve"],
    name: "Gigatron",
  ),
  const Store(
    id: 69,
    addressCities: [
      AddressCities(address: "Zmaj Jovina 26", city: "Novi Sad"),
      AddressCities(address: "Železnička 34", city: "Novi Sad"),
      AddressCities(address: "Bul Oslobođenja 73", city: "Novi Sad"),
      AddressCities(address: "Bul Oslobođenja 34", city: "Novi Sad"),
      AddressCities(address: "Hadži Ruvimova 63", city: "Novi Sad"),
      AddressCities(address: "Prote Mateje 62", city: "Beograd"),
    ],
    category: "Kupovina",
    conditions: ["na artikle koji nisu na popustu"],
    discounts: ["10%"],
    name: "Yason Optika, sunčane naočare",
  ),
  const Store(
    id: 70,
    addressCities: [
      AddressCities(address: "Mite Ružića 2", city: "Novi Sad"),
    ],
    category: "Kupovina",
    conditions: ["plaćanje kešom"],
    discounts: ["10% na zlato", "15% na srebro"],
    name: "Zlatara Žika i Sin",
  ),
  const Store(
    id: 71,
    addressCities: [
      AddressCities(address: "Narodnog fronta 21", city: "Novi Sad"),
      AddressCities(address: "Bulevar Oslobođenja 79", city: "Novi Sad"),
      AddressCities(address: "TC BIG", city: "Novi Sad"),
      AddressCities(address: "TC Ušće,Bosch-Concept store", city: "Novi Beograd"),
      AddressCities(address: "K-District, Dunavska 2b", city: "Beograd"),
    ],
    category: "Kupovina",
    conditions: [
      "Na artikle koji nisu na akciji",
      "Plaćanje kešom ili karticom",
      "Važi samo za kupovinu u prodajnom objektu",
      "Daju mogućnost Savetnik pri kupovini i Individualne kupovine",
      "Individualna kupovina je za veću kupovinu, opremanje stana, gde je jedan prodavac posvećen samo vama",
      "Najava za individualne kupovine na mail borivoje.ilic@drtechno.rs"
    ],
    discounts: ["15%"],
    name: "Dr Tehno",
  ),
  const Store(
    id: 72,
    addressCities: [
      AddressCities(address: "Sinđelićeva 6, Vračar", city: "Beograd"),
    ],
    category: "Kupovina",
    conditions: [],
    discounts: ["15% na celokupan asortiman"],
    name: "Lupo Optika",
  ),
  const Store(
    id: 73,
    addressCities: [
      AddressCities(address: "Sutjeska 1", city: "Novi Sad"),
      AddressCities(address: "Bul Cara Lazara 49", city: "Novi Sad"),
    ],
    category: "Kupovina",
    conditions: [],
    discounts: ["15% na sve"],
    name: "Pašćan Optika",
  ),
  const Store(
    id: 74,
    addressCities: [
      AddressCities(address: "Trg Republike 25", city: "Novi Sad"),
    ],
    category: "Kupovina",
    conditions: [
      "Popust od 20% na BlueGlide i Multi+ Antireflex stakla",
      "Pre izdavanja fiskalnog računa neophodno je da se identifikujete karticom"
    ],
    discounts: ["20% na odabrana stakla", "Besplatan optometrijski pregled"],
    name: "Optika Ginter",
  ),
  const Store(
    id: 75,
    addressCities: [
      AddressCities(address: "tvojavinoteka.rs", city: "Online prodavnica pića"),
    ],
    category: "Kupovina",
    conditions: ["Popust na ceo asortiman sa kodom VEGAIT7"],
    discounts: ["7%"],
    name: "Tvoja vinoteka",
  ),
  const Store(
    id: 76,
    addressCities: [
      AddressCities(address: "Jevrejska 34", city: "Novi Sad"),
    ],
    category: "Kupovina",
    conditions: ["Plaćanje kešom"],
    discounts: ["10%"],
    name: "Juvelir Mojse 1938",
  ),
  const Store(
    id: 77,
    addressCities: [
      AddressCities(address: "Kralja Petra I 76", city: "Novi Sad"),
      AddressCities(address: "Hadži Ruvimova 33", city: "Novi Sad"),
    ],
    category: "Kupovina",
    conditions: [],
    discounts: ["15%"],
    name: "Cvećara Flamingo",
  ),
  const Store(
    id: 78,
    addressCities: [
      AddressCities(address: "Drage Spasić 2", city: "Novi Sad"),
    ],
    category: "Kupovina",
    conditions: [],
    discounts: ["10% na kolače i torte"],
    name: "Oki's Cake",
  ),
  const Store(
    id: 79,
    addressCities: [
      AddressCities(address: "Trg Zorana Đinđića bb", city: "Zrenjanin"),
    ],
    category: "Kupovina",
    conditions: [
      "Pre izdavanja fiskalnog računa neophodno je da se identifikujete karticom",
      "Popust važi za sve članove porodice",
      "FB stranica Optika Gabi",
      "Sajt Optika Gabi",
      "U specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"
    ],
    discounts: [
      "20% popusta na komplet naočare (okviri svih cenovnih kategorija u kombinaciji sa staklima sa plavom zaštitom-zaštita od kompjutera)",
      "10% popusta na kompletni asortiman koji nije snižen ili na akciji (okviri i sve vrste dioptrijskih stakala osim sa zaštitom od kompjutera)",
      "15% na sunčane naočare"
    ],
    name: "Optika Gabi",
  ),
  const Store(
    id: 80,
    addressCities: [
      AddressCities(address: "Zrenjaninski put bb, Kać", city: "Novi Sad"),
      AddressCities(address: "Vladimira Tomanovića, Konjarnik", city: "Beograd"),
      AddressCities(address: "Višnjićka ulica 45b", city: "Beograd"),
      AddressCities(address: "Autoput za Novi Sad, Zemun", city: "Beograd"),
      AddressCities(address: "Novosadski put 86, Veternik", city: "Beograd"),
      AddressCities(address: "Železnička 2", city: "Temerin"),
      AddressCities(address: "Autoput Kragujevac, Batočina bb", city: "Kragujevac"),
      AddressCities(address: "Negotinski put bb", city: "Zaječar"),
      AddressCities(address: "Despota Stefana Lazarevića bb", city: "Šabac"),
      AddressCities(address: "Arsenija Čarnojevića 23", city: "Sremska Mitrovica"),
      AddressCities(address: "Miloša Velikog 22", city: "Kikinda"),
      AddressCities(address: "Filipa Kljajića bb", city: "Sombor"),
      AddressCities(address: "Matije Grupca 6", city: "Subotica"),
    ],
    category: "Kupovina",
    conditions: [
      "Popust se ne odnosi na artikle koji su na mesečnoj akciji i ne može se kombinovati sa drugim akcijama i popustima.",
      "Obračunava se na kasi, na maloprodajne cene, uz priloženu identifikacionu karticu i ličnu kartu preduzeća Vega i važi za sve načine plaćanja.",
      "U specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"
    ],
    discounts: [
      "5% za kupovinu u vrednosti do 100.000,00 dinara",
      "10% za kupovinu u vrednosti preko 100.000,00 dinara"
    ],
    name: "Keramika Jovanović doo",
  ),
  const Store(
    id: 81,
    addressCities: [
      AddressCities(address: "Emila Gavrila 14", city: "Zrenjanin"),
    ],
    category: "Kupovina",
    conditions: [
      "Pre izdavanja fiskalnog računa neophodno je da se identifikujete karticom",
      "Popust ne važi za online kupovinu",
      "FB stranica",
      "U specijalnim slučajevima kontaktirati Draganu Momčilović Tupanjac"
    ],
    discounts: ["10% popusta na kupovinu iz kompletnog asortimana"],
    name: "Cvećara Evergreen",
  ),
  const Store(
    id: 82,
    addressCities: [
      AddressCities(address: "Bulevar Oslobođenja 83", city: "Novi Sad"),
      AddressCities(address: "Branka Bajića 11", city: "Novi Sad"),
      AddressCities(address: "Alekse Šantića 68", city: "Novi Sad"),
      AddressCities(address: "Arsenija Čarnojevića 42", city: "Subotica"),
      AddressCities(address: "Beogradski put 118", city: "Subotica"),
    ],
    category: "Kupovina",
    conditions: [],
    discounts: ["10% na kolače i torte"],
    name: "Cecina Poslastičarnica",
  ),
  const Store(
    id: 83,
    addressCities: [
      AddressCities(address: "Knjaževačka bb", city: "Niš"),
      AddressCities(address: "Bulevar Svetog Pantelejmona 47A", city: "Niš"),
      AddressCities(address: "Prvomajska 1", city: "Niš"),
      AddressCities(address: "Čarnojevića 10", city: "Niš"),
      AddressCities(address: "Hilandarska 27Obilićeva 27 (Gornji Matejevac)", city: "Niš"),
      AddressCities(address: "Sime Dinića 3 (naselje 9. Maj)", city: "Niš"),
      AddressCities(address: "Prvokutinska 66", city: "Niš"),
      AddressCities(address: "Boško Buha 5", city: "Niš"),
    ],
    category: "Kupovina",
    conditions: [],
    discounts: ["Popust od 5% na celokupan iznos računa"],
    name: "As Trgovina",
  ),
  const Store(
    id: 84,
    addressCities: [
      AddressCities(address: "Cela Srbija", city: "Više gradova"),
    ],
    category: "Kupovina",
    conditions: [
      "Svako ko želi popust, potrebno je da se javi koleginici Jeleni Perišić.",
      "Popust ide preko njihove aplikacije.",
      "Jelena na kraju svakog meseca šalje spisak zaposlenih koji žele popust i svakog meseca sami generišete taj popust, nakon toga se šalju kuponi na vaše mail adrese."
    ],
    discounts: [],
    name: "Pet Shop Centar",
  ),
];
