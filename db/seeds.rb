# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

path=File.join(Rails.root, "/app/assets/images/")

#OBJECT Branchen 1..28
mcategories = Mcategory.create({ctype:"Branche", name:"Bau- und Erdarbeiten"})
mcategories = Mcategory.create({ctype:"Branche", name:"Dachdeckerarbeiten"})
mcategories = Mcategory.create({ctype:"Branche", name:"EDV Telekommunikation"})
mcategories = Mcategory.create({ctype:"Branche", name:"Elektrikarbeiten"})
mcategories = Mcategory.create({ctype:"Branche", name:"Entsorgung"})
mcategories = Mcategory.create({ctype:"Branche", name:"Fenster, Türen, Glas"})
mcategories = Mcategory.create({ctype:"Branche", name:"Fliesen und Platten"})
mcategories = Mcategory.create({ctype:"Branche", name:"Garten und Landschaft"})
mcategories = Mcategory.create({ctype:"Branche", name:"KFZ, Motorrad, Boote"})
mcategories = Mcategory.create({ctype:"Branche", name:"Maler & Lackierer"})
mcategories = Mcategory.create({ctype:"Branche", name:"Maurer, Beton, Estrich"})
mcategories = Mcategory.create({ctype:"Branche", name:"Metallbau, Verarbeitung"})
mcategories = Mcategory.create({ctype:"Branche", name:"Parkettböden, Teppichböden"})
mcategories = Mcategory.create({ctype:"Branche", name:"Planung & Beratung"})
mcategories = Mcategory.create({ctype:"Branche", name:"Putz & Stuck"})
mcategories = Mcategory.create({ctype:"Branche", name:"Raumausstatter"})
mcategories = Mcategory.create({ctype:"Branche", name:"Sonstige Dienstleistungen"})
mcategories = Mcategory.create({ctype:"Branche", name:"Sonstige Handwerkerleistungen"})
mcategories = Mcategory.create({ctype:"Branche", name:"Treppen- & Innenausbau"})
mcategories = Mcategory.create({ctype:"Branche", name:"Umzüge, Transporte"})
mcategories = Mcategory.create({ctype:"Branche", name:"Wege- & Pflasterarbeiten"})
mcategories = Mcategory.create({ctype:"Branche", name:"Werbung, Druck, Schilder"})
mcategories = Mcategory.create({ctype:"Branche", name:"Zimmer, Holz, Tischler"})
mcategories = Mcategory.create({ctype:"Branche", name:"Essen Catering Lebensmittel"})
mcategories = Mcategory.create({ctype:"Branche", name:"Bund Kanton Gemeinden"})
mcategories = Mcategory.create({ctype:"Branche", name:"Vereine"})
mcategories = Mcategory.create({ctype:"Branche", name:"Einzelhandel"})
mcategories = Mcategory.create({ctype:"Branche", name:"Finanzdienstleistungen"})
    
#create Aktionen & Angebote 29 30
mcategories = Mcategory.create({ctype:"Angebote", name:"Standard"})
mcategories = Mcategory.create({ctype:"Angebote", name:"Aktion"})

#OBJECT Vermietungen 31..41
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Personentransport"})
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Gütertransport"})
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Werkzeuge"})
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Gartengeräte"})
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Elektronik"})
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Sportgeräte"})
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Event-Attraktionen"})
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Computer"})
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Catering"})
mcategories = Mcategory.create({ctype:"Vermietungen", name:"Tiere"})

#OBJECT Veranstaltung 42..49
mcategories = Mcategory.create({ctype:"Veranstaltungen", name:"Ausstellung"})
mcategories = Mcategory.create({ctype:"Veranstaltungen", name:"Sportanlass"})
mcategories = Mcategory.create({ctype:"Veranstaltungen", name:"Konzert"})
mcategories = Mcategory.create({ctype:"Veranstaltungen", name:"Vortrag"})
mcategories = Mcategory.create({ctype:"Veranstaltungen", name:"Festwirtschaft"})
mcategories = Mcategory.create({ctype:"Veranstaltungen", name:"Informationsveranstaltung"})
mcategories = Mcategory.create({ctype:"Veranstaltungen", name:"Jubiläum"})
mcategories = Mcategory.create({ctype:"Veranstaltungen", name:"Flohmarkt"})

#OBJECT Ausflugsziele 50..56
mcategories = Mcategory.create({ctype:"Ausflugsziele", name:"Ausstellung"})
mcategories = Mcategory.create({ctype:"Ausflugsziele", name:"Landschaften"})
mcategories = Mcategory.create({ctype:"Ausflugsziele", name:"Historische Gebäude"})
mcategories = Mcategory.create({ctype:"Ausflugsziele", name:"Sportstätten"})
mcategories = Mcategory.create({ctype:"Ausflugsziele", name:"Freizeitparks"})
mcategories = Mcategory.create({ctype:"Ausflugsziele", name:"Bäder und Spa"})
mcategories = Mcategory.create({ctype:"Ausflugsziele", name:"Seen und Gewässer"})
    
#OBJECT Kleinanzeigen 57..66
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"Sportgeräte"})
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"Antiquitäten"})
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"Spielzeuge"})
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"Musikinstrumente"})
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"Unterhaltungselektronik"})
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"Haushaltsgeräte"})
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"Gartengeräte"})
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"KFZ und Motorrad"})
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"Tiere"})
mcategories = Mcategory.create({ctype:"Kleinanzeigen", name:"Dienstleistungen"})

mcategories = Mcategory.create({ctype:"Crowdfunding", name:"Crowdfunding"})

#create ticket categories 68..70
mcategories = Mcategory.create({ctype:"Ticket", name:"Eintritt"})
mcategories = Mcategory.create({ctype:"Ticket", name:"Gutschein"})
mcategories = Mcategory.create({ctype:"Ticket", name:"Rabatt"})

#create some users...
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"09.05.1963", anonymous:false, status:"OK", active:true, email:"horst.wurm@bluewin.ch", password:"password", name:"Horst", lastname:"Wurm", address1:"Hörnliblick 11", address2:"Zezikon", address3:"Thurgau", superuser:true, webmaster:true, avatar:File.open(path+'horst.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"11.2.1970", anonymous:false, status:"OK", active:true, email:"t.oschewsky@bluewin.ch", password:"password", name:"Tanja", lastname:"Oschewsky", address1:"Hörnliblick 11", address2:"Zezikon", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'ma_3.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.12.1954", anonymous:false, status:"OK", active:true, email:"hans.wurst@gmx.com", password:"password", name:"Hans", lastname:"Wurst", address1:"Bahnhofstrasse 11", address2:"Frauenfeld", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_2.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"2.10.1960", anonymous:false, status:"OK", active:true, email:"anton.meier@outlook.com", password:"password", name:"Anton", lastname:"Meier", address1:"Im Roos", address2:"Weinfelden", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_4.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"30.5.1970", anonymous:false, status:"OK", active:true, email:"e.oschewsky@bluewin.ch", password:"password", name:"Emelie", lastname:"Oschewsky", address1:"Hörnliblick 11", address2:"Zezikon", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_8.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"11.5.1966", anonymous:false, status:"OK", active:true, email:"henning.gebert@outlook.com", password:"password", name:"Henning", lastname:"Gebert", address1:"Kanalweg", address2:"Pfäffikon SZ", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_7.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"1.5.1970", anonymous:false, status:"OK", active:true, email:"heidi.hirsch@outlook.ch", password:"password", name:"Heidi", lastname:"Hirsch", address1:"Schindegg", address2:"Amlikon", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_9.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"14.4.1961", anonymous:false, status:"OK", active:true, email:"fred.gautschi@bluewin.ch", password:"password", name:"Fred", lastname:"Gautschi", address1:"Dorfplatz 1", address2:"Matzingen", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_6.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"6.3.1966", anonymous:false, status:"OK", active:true, email:"christian.meier@gmx.com", password:"password", name:"Christian", lastname:"Meier", address1:"Alte Wilderenstrasse 4", address2:"Zezikon", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_2.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.12.1958", anonymous:false, status:"OK", active:true, email:"barak@outlook.com", password:"password", name:"Barak", lastname:"Obama", address1:"Marktplatz", address2:"Frauenfeld", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_10.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"26.4.1954", anonymous:false, status:"OK", active:true, email:"trump@bluewin.ch", password:"password", name:"Donald", lastname:"Trump", address1:"Hauptstrasse 1", address2:"Buch", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'ma_11.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.7.1965", anonymous:false, status:"OK", active:true, email:"angela@outlook.com", password:"password", name:"Angela", lastname:"Merkel", address1:"Bahnhof", address2:"Wil SG", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_12.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.8.1960", anonymous:false, status:"OK", active:true, email:"kurt.felix@outlook.com", password:"password", name:"Kurt", lastname:"Felix", address1:"Vadianstrasse 8", address2:"St Gallen", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_5.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"15.7.1959", anonymous:false, status:"OK", active:true, email:"pierin.claglüna@outlook.com", password:"password", name:"Pierin", lastname:"Claglüna", address1:"Bahnhof", address2:"Chur", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'ma_13.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"22.7.1955", anonymous:false, status:"OK", active:true, email:"gregor.stuecheli@outlook.com", password:"password", name:"Gregor", lastname:"Stücheli", address1:"Bahnhof", address2:"Münchwilen", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'stuecheli.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.5.1969", anonymous:false, status:"OK", active:true, email:"hans.nagel@outlook.com", password:"password", name:"Hans", lastname:"Nagel", address1:"Amriswil", address2:"Hauptstrasse 2", address3:"", superuser:false, webmaster:false, avatar:File.open(path+'nagel.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.7.1969", anonymous:false, status:"OK", active:true, email:"corinne@outlook.com", password:"password", name:"Corinne", lastname:"Iaonnidis-Sondereggert", address1:"Marktstrasse 26", address2:"Weinfelden", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'Corinne-Ioannidis-Sonderegger.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"11.5.1967", anonymous:false, status:"OK", active:true, email:"christoph@outlook.com", password:"password", name:"Christoph", lastname:"Sprenger", address1:"Marktstrasse 26", address2:"Bisseg", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'Christoph-Sprenger.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.5.1961", anonymous:false, status:"OK", active:true, email:"aron@outlook.com", password:"password", name:"Aron", lastname:"Gamba", address1:"Marktstrasse 26", address2:"Amlikon", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'Aron_Gamba.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"13.5.1962", anonymous:false, status:"OK", active:true, email:"fabio@outlook.com", password:"password", name:"Fabio", lastname:"Tauro", address1:"Marktstrasse 26", address2:"Busnang", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'FabioTauro.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"14.5.1963", anonymous:false, status:"OK", active:true, email:"isabelle@outlook.com", password:"password", name:"Isabelle", lastname:"Hugentobler", address1:"Schnellerstrasse", address2:"Weinfelden", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'IsabelleHugentobler.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"16.5.1964", anonymous:false, status:"OK", active:true, email:"marco@outlook.com", password:"password", name:"Marco", lastname:"Sonderegger", address1:"Marktstrasse 26", address2:"Kreuzlingen", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'Marco-Sonderegger.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"17.5.1965", anonymous:false, status:"OK", active:true, email:"melanie@outlook.com", password:"password", name:"Melanie", lastname:"Forster", address1:"Ringstrasse", address2:"Frauenfeld", address3:"Thurgau", superuser:false,avatar:File.open(path+'MelanieForster2015.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"18.5.1966", anonymous:false, status:"OK", active:true, email:"nunzia@outlook.com", password:"password", name:"Nunzia", lastname:"Seiler", address1:"Kirchstrasse", address2:"Matzingen", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'NunziaSeiler.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"19.5.1967", anonymous:false, status:"OK", active:true, email:"oliverp@outlook.com", password:"password", name:"Oliver", lastname:"Paulin", address1:"Scheidweg", address2:"Wängi", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'Oliver_Paulin.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"22.5.1968", anonymous:false, status:"OK", active:true, email:"petrak@outlook.com", password:"password", name:"Petra", lastname:"Koch", address1:"Marktsgasse", address2:"Wil", address3:"St.Gallen", superuser:false, webmaster:false, avatar:File.open(path+'PetraKoch.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"22.4.1969", anonymous:false, status:"OK", active:true, email:"rschaelchi@outlook.com", password:"password", name:"Raymond", lastname:"Schaelchli", address1:"Grundstrasse", address2:"Effretikon", address3:"Zürich", superuser:false, webmaster:false, avatar:File.open(path+'RaymondSchaelchli.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"15.5.1970", anonymous:false, status:"OK", active:true, email:"rschoch@outlook.com", password:"password", name:"Remo", lastname:"Schoch", address1:"Eggrainstrasse", address2:"Wigoltingen", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'RemoSchoch.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"22.5.1971", anonymous:false, status:"OK", active:true, email:"sherzog@outlook.com", password:"password", name:"Stefanie", lastname:"Herzog", address1:"Badistrasse", address2:"Stettfurt", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'StefanieHerzog.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"23.5.1972", anonymous:false, status:"OK", active:true, email:"vkirli@outlook.com", password:"password", name:"Vesile", lastname:"Kirli", address1:"Flugplatzstrasse 26", address2:"Lommis", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'VesileKirli.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"25.5.1973", anonymous:false, status:"OK", active:true, email:"mbueschl@outlook.com", password:"password", name:"Manuela", lastname:"Bueschl", address1:"Talstrasse", address2:"Bronschhofen", address3:"St.Gallen", superuser:false, webmaster:false, avatar:File.open(path+'ManuelaBueschl.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"27.5.1974", anonymous:false, status:"OK", active:true, email:"ppreite@outlook.com", password:"password", name:"Patric", lastname:"Preite", address1:"Marktstrasse 26", address2:"Weinfelden", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'PatricPreite.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.5.1974", anonymous:false, status:"OK", active:true, email:"rruckstuhl@outlook.com", password:"password", name:"Ramona", lastname:"Ruckstuhl", address1:"Dufourstrasse", address2:"Weinfelden", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'RamonaRuckstuhl.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.5.1969", anonymous:false, status:"OK", active:true, email:"dwessner@outlook.com", password:"password", name:"Daniel", lastname:"Wessner", address1:"Marktplatz", address2:"Frauenfeld", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'dwessner.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.8.1963", anonymous:false, status:"OK", active:true, email:"rolf.brunner@tkb.ch", password:"password", name:"Rolf", lastname:"Brunner", address1:"", address2:"Wigoltingen", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'rolfbrunner.jpg', 'rb')})
users = User.create({calendar:true, time_from:8, time_to:20, dateofbirth:"12.8.1970", anonymous:false, status:"OK", active:true, email:"tobias.hipert@tkb.ch", password:"password", name:"Tobias", lastname:"Hilpert", address1:"", address2:"Bürglen", address3:"Thurgau", superuser:false, webmaster:false, avatar:File.open(path+'tobiashilpert.jpg', 'rb')})

#create some appointments
usanz = User.all.count-1
random = Random.new(Time.new.to_i)
for i in 0..300
    random = Random.new(Time.new.to_i)
    ura1 = rand(usanz)+1
    random = Random.new(Time.new.to_i)
    ura2 = rand(usanz)+1
    random = Random.new(Time.new.to_i)
    tira1 = random.rand(24)+1
    tira2 = tira1 + 1
    appointments = Appointment.create({user_id1: ura1, user_id2: ura2, subject:"Termin "+Date.today.to_s, active:true, status:"angefragt", app_date:Date.today, time_from: tira1, time_to: tira2, channel:"Geschäftsstelle", channel_detail:""})
end

#create some favorits
usanz = User.all.count-1
random = Random.new(Time.new.to_i)
for i in 0..100
    ura1 = rand(usanz)+1
    ura2 = rand(usanz)+1
    favourits = Favourit.create({user_id: ura1, object_name:"User", object_id: ura2})
end

#create some queries Userfind
usanz = User.all.count-1
random = Random.new(Time.new.to_i)
for i in 0..60
    ura1 = rand(usanz)+1
    user = User.find(ura1)
    dis = rand(20)+1.to_i
    searches = Search.create({date_from: Date.today, date_to: Date.today, user_id: ura1, customer:false, status: "OK", keywords:"", age_from:0, age_to:0, social: false, controller: "user", search_domain: "Privatpersonen", mtype: "Privatpersonen", name: "Privatpersonen im Umkreis von "+dis.to_s + "km (mein Wohnort)", address1: user.address1, address2: user.address2, address3: user.address3, distance: dis})
end

#create some queries Branche
searches = Search.create({date_from: Date.today, date_to: Date.today, user_id: 1, customer:false, status: "OK", keywords:"", age_from:0, age_to:0, social: false, address1: user.address1, address2: user.address2, address3: user.address3, distance: dis, controller: "company", mtype: "Institutionen", search_domain: "Institutionen", name: "Suche nach Banken", mcategory_id:28})
usanz = User.all.count-1
random = Random.new(Time.new.to_i)
for i in 0..60
    ura1 = rand(usanz)+1
    cat = rand(28)+1
    catname = Mcategory.find(cat).name
    user = User.find(ura1)
    dis = rand(20)+1.to_i
    searches = Search.create({date_from: Date.today, date_to: Date.today, user_id: ura1, customer:false, status: "OK", keywords:"", age_from:0, age_to:0, social: false, address1: user.address1, address2: user.address2, address3: user.address3, distance: dis, controller: "company", search_domain: "Institutionen", name: "Suche nach "+ catname, mcategory_id: cat})
end

#create some companies...
companies = Company.create({status:"OK", active:true, user_id:1, name:"Fischzucht Hecht", mcategory_id:24 ,stichworte: "Fische, Zierfische, Angelbedarf", address1:"Bahnhof", address2:"Frauenfeld", address3:"Thurgau", avatar:File.open(path+'fischhaendler.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:2, name:"Alder Entsorgung", mcategory_id:5 ,stichworte: "Hocbau, Tiefbau Müll Abfall Recycling", address1:"Hauptstrasse 1", address2:"Affeltrangen", address3:"Thurgau", avatar:File.open(path+'alder.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:3, name:"Nessensohn Eisenwaren", mcategory_id:27 ,stichworte: "Eisenwaren Geräte Baumaschinen Werkzeuge", address1:"Haupstrasse 37", address2:"Tobel", address3:"Thurgau", avatar:File.open(path+'eisenmueller.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:1, name:"Thurgauer Kantonalbank", partner:true, mcategory_id:28 ,stichworte: "Banken", address1:"Bahnhof", address2:"Weinfelden", address3:"Thurgau", avatar:File.open(path+'tkblogo.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:4, name:"Prematic", mcategory_id:24 ,stichworte: "Luftdruck Kompressoren Druckluft", address1:"Märwilerstrasse 43", address2:"Affeltrangen", address3:"Thurgau", avatar:File.open(path+'prematic.png', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:5, name:"Baufirma Meier", mcategory_id:1 ,stichworte: "Hocbau, Tiefbau", address1:"Rebhaldenstrasse 4", address2:"Zezikon", address3:"Thurgau", avatar:File.open(path+'meier.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:5, name:"Lackierwerkstatt Manser", mcategory_id:10 ,stichworte: "Karosserie KFZ Auto Werkstatt", address1:"Affeltrangen", address2:"Haupstrasse 1", address3:"Thurgau", avatar:File.open(path+'mazda-mx-5-cabriolet-2006-occasion.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:6, name:"Malermeister gökcolor", mcategory_id:10 ,stichworte: "Malerarbeiten Renovation Neubauten Abrieb", address1:"Reuttistrase 13", address2:"Wil", address3:"Thurgau", avatar:File.open(path+'maler.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:7, name:"Tierschutzbund Weinfelden", mcategory_id:26 ,stichworte: "Tiere", address1:"Im Roos", address2:"Weinfelden", address3:"Thurgau", social:true, avatar:File.open(path+'tierschutz.png', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:8, name:"Blindenverein Wängi", mcategory_id:26 ,stichworte: "Verein", address1:"Wängi", address2:"Haupstrasse", address3:"Thurgau", avatar:File.open(path+'blindenverein.jpg', 'rb'), social:true}) 
companies = Company.create({status:"OK", active:true, user_id:9, name:"Kosmetikstudio Jasmine", mcategory_id:10 ,stichworte: "Kosmetik", address1:"Gartenstrasse 2", address2:"Bürglen", address3:"Thurgau", avatar:File.open(path+'kosmetik.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:10, name:"Autohaus Bissegg", mcategory_id:9 ,stichworte: "Auto KFZ Werkstatt", address1:"Wilerstrasse 80", address2:"Bissegg", address3:"Thurgau", avatar:File.open(path+'autobissegg.png', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:11, name:"Valiant Bank", mcategory_id:28 ,stichworte: "Bank Finanz Geld", address1:"Bahnhof", address2:"Bern", address3:"Bern", avatar:File.open(path+'valiantlogo.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:12, name:"St.Galler Kantonalbank", partner:false, mcategory_id:28 ,stichworte: "Banken", address1:"Bahnhof", address2:"St.Gallen", address3:"St.gallen", avatar:File.open(path+'sgkblogo.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:14, name:"Graubündner Kantonalbank", partner:false, mcategory_id:28 ,stichworte: "Banken", address1:"Bahnhof", address2:"Chur", address3:"Graubünden", avatar:File.open(path+'grkblogo.jpg', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:14, name:"Sonderegger publish", partner:false, mcategory_id:22 ,stichworte: "Copyshop Drucken Druckerei Publish Webdesign", address1:"Marktstrasse 26", address2:"8570 Weinfelden", address3:"Thurgau", avatar:File.open(path+'sonderegger.tiff', 'rb')}) 
companies = Company.create({status:"OK", active:true, user_id:34, name:"Amt für Wirtschaft und Arbeit", partner:false, mcategory_id:25 ,stichworte: "Wirtschaft Arbeit Amt Kanton", address1:"Promenadenstrasse", address2:"8510 Frauenfeld", address3:"Thurgau", avatar:File.open(path+'awalogo.jpg', 'rb')}) 

signage_camps = SignageCamp.create({name:"Kampagne Fit", description:"Beschreibung", owner_type:"Company", owner_id:11})
signages = Signage.create({signage_camp_id:1, header:"Fit halten durch Sport", description:"rufen Sie uns an", avatar:File.open(path+'fit1.jpg', 'rb')})
signages = Signage.create({signage_camp_id:1, header:"Individuelle Programme", description:"lassen Sie sich beraten", avatar:File.open(path+'fit2.jpg', 'rb')})
signages = Signage.create({signage_camp_id:1, header:"modernste Geräte", description:"probieren Sie es aus", avatar:File.open(path+'fit3.jpg', 'rb')})
signages = Signage.create({signage_camp_id:1, header:"Gruppentraining", description:"der Spass kommt nicht zu kurz", avatar:File.open(path+'fit4.jpg', 'rb')})

signage_camps = SignageCamp.create({name:"Kampagne Finanzieren", description:"Beschreibung", owner_type:"Company", owner_id:4})
signages = Signage.create({signage_camp_id:2, header:"gemeinsam an's Ziel", description:"rufen Sie uns an", avatar:File.open(path+'TKB_Finanzieren1.jpg', 'rb')})
signages = Signage.create({signage_camp_id:2, header:"wir unterstützen Sie", description:"rufen Sie uns an", avatar:File.open(path+'TKB_Finanzieren2.jpg', 'rb')})
signages = Signage.create({signage_camp_id:2, header:"wir freuen uns auf Sie", description:"rufen Sie uns an", avatar:File.open(path+'TKB_Finanzieren3.jpg', 'rb')})

signage_camps = SignageCamp.create({name:"Kampagne Anlegen", description:"Beschreibung", owner_type:"Company", owner_id:4})
signages = Signage.create({signage_camp_id:3, header:"Anlegen ist Vertrauenssache", description:"rufen Sie uns an", avatar:File.open(path+'anlegen1.jpg', 'rb')})
signages = Signage.create({signage_camp_id:3, header:"Anlegen leicht gemacht", description:"lassen Sie sich beraten", avatar:File.open(path+'anlegen2.jpg', 'rb')})
signages = Signage.create({signage_camp_id:3, header:"Anlegen jetzt oder nie", description:"probieren Sie es aus", avatar:File.open(path+'anlegen3.jpg', 'rb')})
signages = Signage.create({signage_camp_id:3, header:"Anlegen die Alternative", description:"kommen Sie zu uns", avatar:File.open(path+'anlegen4.jpg', 'rb')})

signage_locs = SignageLoc.create({name: "Bahnhof Weinfelden", privateonly: true, owner_type:"Company", owner_id:16, address1:"Bahnhof", address2:"Weinfelden", address3:"Thurgau", res_h:800, res_v:600, avatar:File.open(path+'signage_bahnhof.jpg', 'rb')})
signage_locs = SignageLoc.create({name: "Bistro Frauenfeld", privateonly: true, owner_type:"Company", owner_id:16, address1:"Marktplatz", address2:"Frauenfeld", address3:"Thurgau", res_h:800, res_v:600, avatar:File.open(path+'signage_bistro.jpg', 'rb')})
signage_locs = SignageLoc.create({name: "TKB Geschäftsstelle Weinfelden", privateonly: true, owner_type:"Company", owner_id:4, address1:"Bankplatz 1", address2:"Weinfelden", address3:"Thurgau", res_h:800, res_v:600, avatar:File.open(path+'signage_tkb.jpg', 'rb')})
signage_locs = SignageLoc.create({name: "TKB Geschäftsstelle Frauenfeld", privateonly: true, owner_type:"Company", owner_id:4, address1:"Bahnhof", address2:"Frauenfeld", address3:"Thurgau", res_h:800, res_v:600, avatar:File.open(path+'signage_tkb.jpg', 'rb')})
signage_locs = SignageLoc.create({name: "Kosmetikstudio", privateonly: true, owner_type:"Company", owner_id:11, address1:"Gartenstrasse 2", address2:"Bürglen", address3:"Thurgau", res_h:800, res_v:600, avatar:File.open(path+'signage_tkb.jpg', 'rb')})

signage_cals = SignageCal.create({signage_loc_id:1, signage_camp_id:1, date_from: Date.today, date_to: Date.today + 20, confirmed:true})
signage_cals = SignageCal.create({signage_loc_id:1, signage_camp_id:2, date_from: Date.today, date_to: Date.today + 20, confirmed:true})
signage_cals = SignageCal.create({signage_loc_id:2, signage_camp_id:1, date_from: Date.today, date_to: Date.today + 20, confirmed:true})
signage_cals = SignageCal.create({signage_loc_id:3, signage_camp_id:1, date_from: Date.today+5, date_to: Date.today + 20, confirmed:true})
signage_cals = SignageCal.create({signage_loc_id:4, signage_camp_id:1, date_from: Date.today, date_to: Date.today + 20, confirmed:true})
signage_cals = SignageCal.create({signage_loc_id:4, signage_camp_id:2, date_from: Date.today + 10, date_to: Date.today + 20, confirmed:true})

signage_hits = SignageHit.create({signage_loc_id:3, signage_camp_id:2, created_at: Date.today - 1.days})
signage_hits = SignageHit.create({signage_loc_id:3, signage_camp_id:2, created_at: Date.today - 2.days})
signage_hits = SignageHit.create({signage_loc_id:3, signage_camp_id:2, created_at: Date.today - 2.days})
signage_hits = SignageHit.create({signage_loc_id:3, signage_camp_id:2, created_at: Date.today - 3.days})
signage_hits = SignageHit.create({signage_loc_id:3, signage_camp_id:2, created_at: Date.today - 3.days})
signage_hits = SignageHit.create({signage_loc_id:3, signage_camp_id:2, created_at: Date.today - 4.days})
signage_hits = SignageHit.create({signage_loc_id:3, signage_camp_id:2, created_at: Date.today - 1.days})
signage_hits = SignageHit.create({signage_loc_id:3, signage_camp_id:2, created_at: Date.today - 1.days})
signage_hits = SignageHit.create({signage_loc_id:1, signage_camp_id:2, created_at: Date.today - 2.days})
signage_hits = SignageHit.create({signage_loc_id:1, signage_camp_id:2, created_at: Date.today - 2.days})
signage_hits = SignageHit.create({signage_loc_id:2, signage_camp_id:2, created_at: Date.today - 3.days})
signage_hits = SignageHit.create({signage_loc_id:2, signage_camp_id:2, created_at: Date.today - 3.days})
signage_hits = SignageHit.create({signage_loc_id:4, signage_camp_id:2, created_at: Date.today - 4.days})
signage_hits = SignageHit.create({signage_loc_id:4, signage_camp_id:2, created_at: Date.today - 1.days})

#create Links for TKB
@comp = Company.where('name=?',"Thurgauer Kantonalbank").first
if @comp
    for i in 1..6
        partnerlinks = PartnerLink.create({active:true, company_id: @comp.id, name:"eBanking", link:"www.tkb.ch/ebanking", avatar: File.open(path+'tkb0'+i.to_s+'.jpg', 'rb')})
    end
end

#create some customer relationships und accounts
usanz = User.all.count-1
capanz = Company.all.count-1
@partners = Company.where('active=? and partner=?', true, true).all
random = Random.new(Time.new.to_i)
@partners.each do |p|
    for i in 0..20
        ura1 = rand(usanz)+1
        cra1 = rand(capanz)+1

        #User
        @customer = Customer.where('owner_type=? and owner_id=? and partner_id=?', "User", ura1,p.id)
        if @customer.count == 0
            customers = Customer.create({owner_type:"User", owner_id:ura1, partner_id: p.id, customer_number:"Kunden-Nr PK5962356326"+i.to_s})
            @cac = Customer.where('customer_number=? and partner_id=?',"Kunden-Nr PK5962356326"+i.to_s, p.id).first
            if @cac.accounts.count == 0
                for k in 1..2
                    if k == 2
                        gk = true
                    else
                        gk = false
                    end
                    accounts = Account.create({customer_id:  @cac.id, name:"Konto-Nr."+k.to_s, iban:"IBANPK1234567890"+k.to_s, is_account_ver: gk})
                end
            end
        end 

        # Companies
        @customer = Customer.where('owner_type=? and owner_id=? and partner_id=?', "Company", cra1,p.id)
        if @customer.count == 0
            customers = Customer.create({owner_type:"Company", owner_id:cra1, partner_id: p.id, customer_number:"Kunden-Nr FK5962356326"+i.to_s})
            @cac = Customer.where('customer_number=? and partner_id=?',"Kunden-Nr FK5962356326"+i.to_s, p.id).first
            if @cac.accounts.count == 0
                for k in 1..2
                    if k == 2
                        gk = true
                    else
                        gk = false
                    end
                    accounts = Account.create({customer_id:  @cac.id, name:"Konto-Nr."+k.to_s, iban:"IBANFK1234567890"+k.to_s, is_account_ver: gk})
                end
            end
        end 

    end
end

#create some transactions
accanz = Account.count-1
random = Random.new(Time.new.to_i)
for i in 1..100
    acc_ver = rand(accanz)+1
    acc_bel = rand(accanz)+1
    cust = Account.find(acc_bel).customer
    transactions = Transaction.create({ttype:"Payment", owner_id: cust.owner_id, owner_type: cust.owner_type, account_ver: acc_ver, account_bel: acc_bel, trx_date:Date.today, valuta:Date.today+1, status:"erfasst", ref: "Transaktion 0815", object_name:"User", object_id:1, amount:100+acc_bel})
end

#create Services for Fischzucht
comp = Company.where('name=?', "Fischzucht Hecht").first
mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Standard", name:"Fischbuffet", date_from:Date.today, date_to:Date.today+5, owner_type:"Company", owner_id: comp.id, mcategory_id:29, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Fischbuffet").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'fischbuffet.jpg', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'fische.jpg', 'rb')})

a= rand(5)
b= rand(5)+5
mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Aktion", name:"Sonderverkauf", date_from:Date.today+a, date_to:Date.today+b, owner_type:"Company", owner_id: comp.id, mcategory_id:30, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Sonderverkauf").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'fischtheke.jpg', 'rb'), document:File.open(path+'std.pdf', 'rb')})

#create Services for Autohaus
comp = Company.where('name=?', "Autohaus Bissegg").first
mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Standard", name:"Direktimporte zu günstigen Preisen", date_from:Date.today, date_to:Date.today+5, owner_type:"Company", owner_id: comp.id, mcategory_id:29, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Direktimporte zu günstigen Preisen").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"An- & Verkauf", description:"", avatar:File.open(path+'bissegg.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"Service in eigener Werkstatt", description:"", avatar:File.open(path+'kfzservice.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

a= rand(5)
b= rand(5)+5
mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Aktion", name:"Superangebot", date_from:Date.today+a, date_to:Date.today+b, owner_type:"Company", owner_id: comp.id, mcategory_id:30, address1: comp.address1, address2: comp.address2, address3: comp.address3, price_reg:12900, price_new:9999})
@mob = Mobject.where('name=?', "Superangebot").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"Fiat Spider absoluter Topzustand", description:"", avatar:File.open(path+'fiat1.jpg', 'rb'), document:File.open(path+'std.pdf', 'rb')})

#create Services for TKB
comp = Company.where('name=?', "Thurgauer Kantonalbank").first
mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Standard", name:"Steuerberatung", date_from:Date.today, date_to:Date.today+5, owner_type:"Company", owner_id: comp.id, mcategory_id:29, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Steuerberatung").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'steuern.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Standard", name:"Anlegen", date_from:Date.today, date_to:Date.today+5, owner_type:"Company", owner_id: comp.id, mcategory_id:29, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Anlegen").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'anlegen.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Standard", name:"Erben", date_from:Date.today, date_to:Date.today+5, owner_type:"Company", owner_id: comp.id, mcategory_id:29, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Erben").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'erben.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Standard", name:"Crowdfunding", date_from:Date.today, date_to:Date.today+5, owner_type:"Company", owner_id: comp.id, mcategory_id:29, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Crowdfunding").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'crowdfunding.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

#create Services for AWA
comp = Company.where('name=?', "Amt für Wirtschaft und Arbeit").first

mobjects = Mobject.create({active:true, mtype:"Angebote", msubtype:"Standard", name:"AWA Service 1", date_from:Date.today, date_to:Date.today+30, owner_type:"Company", owner_id: 17, mcategory_id:29, address1:"Marktstrasse 26", address2:"8570 Weinfelden", address3:"Thurgau"})
@mob = Mobject.where('name=?', "AWA Service 1").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"Kurzbezeichnung Detail... ", description:"dies ist die Beschreibung Detail... ", avatar:File.open(path+'awas1.jpg', 'rb')})

mobjects = Mobject.create({active:true, mtype:"Angebote", msubtype:"Standard", name:"AWA Service 2", date_from:Date.today, date_to:Date.today+30, owner_type:"Company", owner_id: 17, mcategory_id:29, address1:"Marktstrasse 26", address2:"8570 Weinfelden", address3:"Thurgau"})
@mob = Mobject.where('name=?', "AWA Service 2").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"Kurzbezeichnung Detail... ", description:"dies ist die Beschreibung Detail... ", avatar:File.open(path+'awas2.jpg', 'rb')})

mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Standard", name:"AWA Service 3", date_from:Date.today, date_to:Date.today+30, owner_type:"Company", owner_id: 17, mcategory_id:29, address1:"Marktstrasse 26", address2:"8570 Weinfelden", address3:"Thurgau"})
@mob = Mobject.where('name=?', "AWA Service 3").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"Kurzbezeichnung Detail... ", description:"dies ist die Beschreibung Detail... ", avatar:File.open(path+'awas3.jpg', 'rb')})

mobjects = Mobject.create({status:"OK", active:true, mtype:"Angebote", msubtype:"Standard", name:"AWA Service 4", date_from:Date.today, date_to:Date.today+30, owner_type:"Company", owner_id: 17, mcategory_id:29, address1:"Marktstrasse 26", address2:"8570 Weinfelden", address3:"Thurgau"})
@mob = Mobject.where('name=?', "AWA Service 4").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"Kurzbezeichnung Detail... ", description:"dies ist die Beschreibung Detail... ", avatar:File.open(path+'awas4.jpg', 'rb')})

#createVermietungen 
usanz = User.count-1
random = Random.new(Time.new.to_i)

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Vermietungen", msubtype:nil, name:"Wohnmobil", date_from:Date.today, date_to:Date.today+30, owner_type:"User", owner_id: @user.id, mcategory_id:31, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Wohnmobil").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'womo.jpg', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Vermietungen", msubtype:nil, name:"Gartenhake", date_from:Date.today, date_to:Date.today+30, owner_type:"User", owner_id: @user.id, mcategory_id:34, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Gartenhake").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'gartenpflug.jpg', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Vermietungen", msubtype:nil, name:"Anhänger", date_from:Date.today, date_to:Date.today+30, owner_type:"User", owner_id: @user.id, mcategory_id:34, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Anhänger").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'anhaenger600.jpg', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Vermietungen", msubtype:nil, name:"Mountain-Bike HighTech", date_from:Date.today, date_to:Date.today+30, owner_type:"User", owner_id: @user.id, mcategory_id:36, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Mountain-Bike HighTech").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'bike2.jpg', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Vermietungen", msubtype:nil, name:"Drohne für Höhenaufnahmen", date_from:Date.today, date_to:Date.today+30, owner_type:"User", owner_id: @user.id, mcategory_id:35, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Drohne für Höhenaufnahmen").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'drohn1.jpg', 'rb')})

#create Ausschreibungen 
usanz = User.count-1
random = Random.new(Time.new.to_i)

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Ausschreibungen", msubtype:nil, name:"Ausbau Dachboden", date_from:Date.today+1, date_to:Date.today+10, owner_type:"User", owner_id: @user.id, mcategory_id:1, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Ausbau Dachboden").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'dach1.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
us = rand(usanz)+1
@user = User.find(us)
mdetails = Mdetail.create({mtype: "Ausschreibungsangebote", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'alder.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Ausschreibungen", msubtype:nil, name:"Holzterassse erneuern", date_from:Date.today+20, date_to:Date.today+30, owner_type:"User", owner_id: @user.id, mcategory_id:1, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Holzterassse erneuern").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'garten.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
us = rand(usanz)+1
@user = User.find(us)
mdetails = Mdetail.create({mtype: "Ausschreibungsangebote", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'alder.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Ausschreibungen", msubtype:nil, name:"Kellerausbau", date_from:Date.today, date_to:Date.today+3, owner_type:"User", owner_id: @user.id, mcategory_id:1, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Kellerausbau").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'keller1.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'keller2.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
us = rand(usanz)+1
@user = User.find(us)
mdetails = Mdetail.create({mtype: "Ausschreibungsangebote", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'alder.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Ausschreibungen", msubtype:nil, name:"Pallisaden setzen 10m", date_from:Date.today+5, date_to:Date.today+15, owner_type:"User", owner_id: @user.id, mcategory_id:1, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Pallisaden setzen 10m").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'mauern.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
us = rand(usanz)+1
@user = User.find(us)
mdetails = Mdetail.create({mtype: "Ausschreibungsangebote", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'alder.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

#create Stellenanzeigen
comp = Company.where('name=?', "Thurgauer Kantonalbank").first
mobjects = Mobject.create({status:"OK", active:true, mtype:"Stellenanzeigen", msubtype:"Anbieten", name:"Kundenberater", date_from:Date.today, date_to:Date.today+5, owner_type:"Company", owner_id: comp.id, mcategory_id:29, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Kundenberater").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'tkblogo.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

comp = Company.where('name=?', "Baufirma Meier").first
mobjects = Mobject.create({status:"OK", active:true, mtype:"Stellenanzeigen", msubtype:"Anbieten", name:"Maurer", date_from:Date.today, date_to:Date.today+5, owner_type:"Company", owner_id: comp.id, mcategory_id:29, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Maurer").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'meier.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

comp = Company.where('name=?', "Sonderegger publish").first
mobjects = Mobject.create({status:"OK", active:true, mtype:"Stellenanzeigen", msubtype:"Anbieten", name:"Drucker", date_from:Date.today, date_to:Date.today+5, owner_type:"Company", owner_id: comp.id, mcategory_id:29, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Drucker").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'sonderegger.tiff', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Stellenanzeigen", msubtype: "Suchen", name:"Diplom Informatiker", date_from:Date.today+1, date_to:Date.today+10, owner_type:"User", owner_id: @user.id, mcategory_id:3, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Diplom Informatiker").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"Lebenslauf", description:"", avatar:File.open(path+'it.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Stellenanzeigen", msubtype: "Suchen", name:"Musiker", date_from:Date.today+1, date_to:Date.today+10, owner_type:"User", owner_id: @user.id, mcategory_id:3, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Musiker").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"Lebenslauf", description:"", avatar:File.open(path+'cd2.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

# Veranstaltungen
co = rand(capanz)+1
comp = Company.find(co)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Veranstaltungen", msubtype:nil, name:"Tag der offenen Tür", date_from:Date.today, date_to:Date.today+1, owner_type:"Company", owner_id: comp.id, mcategory_id:48, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Tag der offenen Tür").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'esel3.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

co = rand(capanz)+1
comp = Company.find(co)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Veranstaltungen", msubtype:nil, name:"Versammlung", date_from:Date.today, date_to:Date.today+1, owner_type:"Company", owner_id: comp.id, mcategory_id:48, address1: comp.address1, address2: comp.address2, address3: comp.address3})
@mob = Mobject.where('name=?', "Versammlung").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'social.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Veranstaltungen", msubtype: "Suchen", name:"Bandabend", date_from:Date.today+5, date_to:Date.today+5, owner_type:"User", owner_id: @user.id, mcategory_id:62, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Bandabend").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'band1.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'band2.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'band3.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

# Sponsor
capanz = Company.all.count-1
usanz = User.all.count-1
co = rand(capanz)+1
@mob = Mobject.where('name=?', "Bandabend").first
msponsor = Msponsor.create({slevel: 1, active: true, status: "OK", company_id: co, mobject_id: @mob.id})
# Tickets
ticket = Ticket.create({active: true, msponsor_id: Msponsor.last.id, mcategory_id:68, name: "Eintritt", amount:0, contingent:30})
# UserIickets
for i in 1..20
    us = rand(usanz)+1
    @user = User.find(us)
    usertickets = UserTicket.create({status:"persönlich", user_id: @user.id, ticket_id: Ticket.last.id})
    ut = UserTicket.last
        content = "http://tkbmarkt.herokuapp.com/home/index1?me="+ut.id.to_s
        qr = RQRCode::QRCode.new(content, size: 12, :level => :h)
        qr_img = qr.to_img
        qr_img.resize(200, 200).save("ticketqrcode.png")
        img = File.open("ticketqrcode.png")
        ut.avatar = File.open('ticketqrcode.png', 'rb')
    ut.save    
end

# Sponsor
@mob = Mobject.where('name=?', "Versammlung").first
co = rand(capanz)+1
msponsor = Msponsor.create({slevel: 1, active: true, status: "OK", company_id: co, mobject_id: @mob.id})
# Tickets
ticket = Ticket.create({active: true, msponsor_id: Msponsor.last.id, mcategory_id:69, name: "Essen & Getränk", amount:0, contingent:100})
# UserIickets
for i in 1..30
    us = rand(usanz)+1
    @user = User.find(us)
    usertickets = UserTicket.create({status:"persönlich", user_id: @user.id, ticket_id: Ticket.last.id})
    ut = UserTicket.last
        content = "http://tkbmarkt.herokuapp.com/home/index1?me="+ut.id.to_s
        qr = RQRCode::QRCode.new(content, size: 12, :level => :h)
        qr_img = qr.to_img
        qr_img.resize(200, 200).save("ticketqrcode.png")
        img = File.open("ticketqrcode.png")
        ut.avatar = File.open('ticketqrcode.png', 'rb')
    ut.save    
end

#Ausflugsziele
usanz = User.all.count-1
us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Ausflugsziele", msubtype: "Suchen", name:"Koster Fischingen", date_from:Date.today+5, date_to:Date.today+5, owner_type:"User", owner_id: @user.id, mcategory_id:62, address1: "Fischingen", address2: "Kloster Fischingen", address3: @user.address3})
@mob = Mobject.where('name=?', "Koster Fischingen").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'fischingen1.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'fischingen2.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'fischingen3.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Ausflugsziele", msubtype: "Suchen", name:"Stählibuck", date_from:Date.today+5, date_to:Date.today+5, owner_type:"User", owner_id: @user.id, mcategory_id:62, address1: "Thundorf", address2: "", address3: ""})
@mob = Mobject.where('name=?', "Stählibuck").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'staehli.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Ausflugsziele", msubtype: "Suchen", name:"Gütsch", date_from:Date.today+5, date_to:Date.today+5, owner_type:"User", owner_id: @user.id, mcategory_id:62, address1: "Luzern", address2: "", address3: ""})
@mob = Mobject.where('name=?', "Gütsch").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'guetsch.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

# Kleinanzeigen
usanz = User.all.count-1
us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Kleinanzeigen", msubtype: "Anbieten", name:"Commodore", date_from:Date.today+5, date_to:Date.today+5, owner_type:"User", owner_id: @user.id, mcategory_id:62, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Commodore").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'computer1.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'computer2.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'computer3.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Kleinanzeigen", msubtype: "Anbieten", name:"Briefmarkensammlung", date_from:Date.today+5, date_to:Date.today+5, owner_type:"User", owner_id: @user.id, mcategory_id:62, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Briefmarkensammlung").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'stamp1.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'stamp2.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'stamp3.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'stamp4.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Kleinanzeigen", msubtype: "Anbieten", name:"Tennislektionen", date_from:Date.today+5, date_to:Date.today+5, owner_type:"User", owner_id: @user.id, mcategory_id:62, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Tennislektionen").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'tennis.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Kleinanzeigen", msubtype: "Suchen", name:"Mitfahrgelegenheit nach Berlin am 22.1.2017", date_from:Date.today+5, date_to:Date.today+5, owner_type:"User", owner_id: @user.id, mcategory_id:60, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Mitfahrgelegenheit nach Berlin am 22.1.2017").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'ausflug.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({status:"OK", active:true, mtype:"Kleinanzeigen", msubtype: "Suchen", name:"Harry Potter Edition", date_from:Date.today+5, date_to:Date.today+5, owner_type:"User", owner_id: @user.id, mcategory_id:60, address1: @user.address1, address2: @user.address2, address3: @user.address3})
@mob = Mobject.where('name=?', "Harry Potter Edition").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'englisch.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})

#Crowdfunding Spenden
co = rand(capanz)+1
comp = Company.where('name=?',"Tierschutzbund Weinfelden").first
mobjects = Mobject.create({status:"OK", active:true, mtype:"Crowdfunding", msubtype:"Spenden", name:"Neue Hundezwinger", date_from:Date.today, date_to:Date.today+30, owner_type:"Company", owner_id: comp.id, mcategory_id:66, address1: comp.address1, address2: comp.address2, address3: comp.address3, amount:10000})
@mob = Mobject.where('name=?', "Neue Hundezwinger").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'hund1.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'hund2.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'hund3.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
for i in 1..30 
    us = rand(usanz)+1
    @user = User.find(us)
    mstats = Mstat.create({anonymous:false, status:"OK", mobject_id:@mob.id, owner_type:"User", owner_id:@user.id, amount: 250+us, created_at:Date.today-us})
end

#Crowdfunding Donation
us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({price: 100, status:"OK", active:true, mtype:"Crowdfunding", msubtype:"Belohnungen", reward:"Signierte CD und freier Eintritt am Konzert", name:"CD Produktion", date_from:Date.today, date_to:Date.today+30, owner_type:"User", owner_id: @user.id, mcategory_id:66, address1: @user.address1, address2: @user.address2, address3: @user.address3, amount:25000})
@mob = Mobject.where('name=?', "CD Produktion").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'cd1.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'cd2.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'cd3.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
for i in 1..50 
    us = rand(usanz)+1
    @user = User.find(us)
    mstats = Mstat.create({anonymous:false, status:"OK", mobject_id:@mob.id, owner_type:"User", owner_id:@user.id, amount: 100, created_at:Date.today-us})
end

#Crowdfunding Kredit
us = rand(usanz)+1
@user = User.find(us)
mobjects = Mobject.create({due_date: Date.today + 365, interest_rate: 3.5, status:"OK", active:true, mtype:"Crowdfunding", msubtype:"Zinsen", reward:"", name:"Finanzierung Truck", date_from:Date.today, date_to:Date.today+30, owner_type:"User", owner_id: @user.id, mcategory_id:66, address1: @user.address1, address2: @user.address2, address3: @user.address3, amount:150000})
@mob = Mobject.where('name=?', "Finanzierung Truck").first
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'truck1.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
mdetails = Mdetail.create({mtype: "Details", mobject_id: @mob.id, name:"", description:"", avatar:File.open(path+'truck2.jpg', 'rb'),document:File.open(path+'std.pdf', 'rb')})
for i in 1..50 
    us = rand(usanz)+1
    @user = User.find(us)
    mstats = Mstat.create({anonymous:false, status:"OK", mobject_id:@mob.id, owner_type:"User", owner_id:@user.id, amount: 1000, created_at:Date.today-us})
end

#Bewertungen
obanz = Mobject.count-1
obj = rand(obanz)+1
@object = Mobject.find(obj)
usanz = User.count-1
us = rand(usanz)+1
@user = User.find(us)
for i in 1..200 
    obj = rand(obanz)+1
    @object = Mobject.find(obj)
    us = rand(usanz)+1
    rat = rand(4)+1
    @user = User.find(us)
    mratings = Mrating.create({status:"OK", mobject_id:@object.id, user_id: @user.id, comment: "ok", rating: rat})
end
