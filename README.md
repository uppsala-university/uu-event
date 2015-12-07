Du behöver Vagrant och Virtual Box på din dator.

Starta miljön
=============

Starta maskinen med vagrant

    vagrant up

Efter en stunds tuggande bör maskinen komma igång med följande komponenter installerade

* servicemix
* httpd (för att simulera Ladok Feeds via statiska filer)

Starta servicemix
=================

Starta servicmix i den virtuella miljön

    vagrant ssh

Kontrollera att tjänsten servicemix är startad

    sudo service apache-servicemix status

Håll sedan koll på filen /var/lib/servicemix/log/servicemix.log.

Konsoll för servicemix
======================
Kör ssh mot servicemix. Lösenordet är "smx"

    ssh -p 8101 smx@localhost

I konsollen kan du t.ex. titta på inkommande kön:

    activemq:browse --amqurl tcp://localhost:61616 ladok3-event-distribution

eller följa loggen:

    log:tail


Installera webbkonsoll för ActiveMQ samt Hawtio
===============================================
*Den här punkten är inte längre nödvändig eftersom Hawtio installeras via provissioneringen.*

Om du vill, se följande adresser:

* <http://marcelojabali.blogspot.se/2011/08/how-to-enable-activemq-web-console-on.html>
* <http://hawt.io/getstarted/index.html>

(Hawtio i korthet...)

	`features:chooseurl hawtio 1.4.51`
	`features:install hawtio`

Alternativ om hawtio krånglar:

    features:install hawtio-offline

Gå sedan till <http://localhost:8181/hawtio> oc använd smx/smx för inloggning.

Installera klientcertifikat för Ladok3
======================================
Klienten som används för att hämta händelser från Ladok's ATOM-gränssnitt finns i biblioteket <https://github.com/uppsala-university/ladok>.

Kopiera klientcertifikat för Ladok3 till katalogen `ladok3atom-client/src/main/resources/`. Certifikatet ska vara på PKCS 12-format.

I `ladok3atom-client/src/main/resources` finns en exempelfil för fordrade egenskaper. Använd den genom att döpa om den

    mv atomclient.properties.sample atomclient.properties

Redigera sedan filen `ladok3atom-client/src/main/resources/atomclient.properties` för att innehålla rätt namn på certifikatfil och lösenord.

Driftsätt händelsehanteraren i vagrant-miljö
============================================
Check ut projekten `ladok`, `ladok-integration` samt `uu-integration` 

    git clone git@github.com/uppsala-university/ladok
    git clone git@github.com/uppsala-university/ladok-integration
    git clone git@github.com/uppsala-university/uu-integration

Bygg källkoden i resp projekt, genom

    mvn clean package

Detta bygger ett s.k. "maven multi module project".

Förutsatt att projketen är tillgängliga parallellt med det här projektet kan man även bygga projekten genom

    mvn -f ../ladok clean package -Dmaven.test.skip=true
    mvn -f ../ladok-integration clean package -Dmaven.test.skip=true
    mvn -f ../uu-integration clean package -Dmaven.test.skip=true

(I det här exemplet hoppar vi över att köra testerna)

Nu går det att deploya till servicemix. Det görs genom att kopiera filer till deploy-katalogen som
ligger under "smx/deploy" relativt denna fil. Detta är en specialare för vagrant-miljöerna. En närmare
titt i filen provision/manifests/default.pp indikerar att puppet kommer länka om deploy-katalogen så
att den hamnar på den delade disken mellan vagrant-maskinen och värd-maskinen. Detta gör det smidigare
att utveckla. Noterbart är att "hotdeploy" inte fungerar eftersom att inotify inte kan hantera vboxfs.
Det innebär att varje fil som driftsätts till deploy-katalogen måste touchas inifrån gästsystemet.


I värdsystemet, kopiera artifakterna till `smx/deploy`:
    cp ../uu-integration/esb-amq/target/esb-amq-1.0-SNAPSHOT.jar smx/deploy
    cp ../uu-integration/esb-datasource-logdb/target/esb-datasource-logdb-1.0-SNAPSHOT.jar smx/deploy
    cp ../uu-integration/esb-model/target/esb-model-1.1.0-SNAPSHOT.jar smx/deploy
    cp ../ladok/ladok3atom-dto/target/ladok3atom-dto-0.0.1-SNAPSHOT.jar smx/deploy
    cp ../ladok/ladok3atom-client/target/ladok3atom-client-0.0.1-SNAPSHOT.jar smx/deploy
    cp ../ladok-integration/ladok-atom-adapter/target/ladok-atom-adapter-0.0.1-SNAPSHOT.jar smx/deploy

I gästsystemet, kopiera artifakterna från `smx/deploy` till servicemix `deploy`:

	cp /vagrant/smx/deploy/esb-amq-1.0-SNAPSHOT.jar /opt/servicemix/apache-servicemix-*/deploy
    cp /vagrant/smx/deploy/esb-datasource-logdb-1.0-SNAPSHOT.jar /opt/servicemix/apache-servicemix-*/deploy
    cp /vagrant/smx/deploy/esb-model-1.1.0-SNAPSHOT.jar /opt/servicemix/apache-servicemix-*/deploy
    cp /vagrant/smx/deploy/ladok3atom-dto-0.0.1-SNAPSHOT.jar /opt/servicemix/apache-servicemix-*/deploy
    cp /vagrant/smx/deploy/ladok3atom-client-0.0.1-SNAPSHOT.jar /opt/servicemix/apache-servicemix-*/deploy
    cp /vagrant/smx/deploy/ladok-atom-adapter-0.0.1-SNAPSHOT.jar /opt/servicemix/apache-servicemix-*/deploy

Vid redeploy bör artifakter först av-deployas (via `rm  /opt/servicemix/apache-servicemix-*/deploy/<artifakt>.jar`)

Deploy-katalog på den delade disken kommer överleva omstarter och ominstallationer (vagrant destroy) av den virtuella maskinen.

Driftsättning i ICKE-vagrant-miljö
========================================

Samma jar-filer som ovan men de ska kopieras in i `/opt/servicemix/apache-servicemix-5.1.2/deploy`
