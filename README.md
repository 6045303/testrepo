# Boekenplatform Database

Dit project bevat een MySQL-database voor een boekenswap/boekverkoopplatform voor studenten.

## Bestanden

- `database.sql` – bevat de volledige database-structuur en tabellen
- `data.sql` – bevat dummy data voor testdoeleinden
- `index.html` – eenvoudige frontend-startpagina

## Database-opzet

1. Open MySQL of MariaDB.
2. Maak verbinding met je database-server.
3. Run het script:

```sql
SOURCE database.sql;
```

4. Vul daarna de dummy data in:

```sql
SOURCE data.sql;
```

## Tabellen

De database bevat onder andere deze tabellen:

- gebruiker
- boek
- advertentie
- transactie
- bericht
- beoordeling
- notificatie

## Dummy data

De gegevens in `data.sql` bevatten voorbeeldgebruikers, boeken, advertenties, transacties, berichten en beoordelingen zodat de app goed getest kan worden.

## Opmerking

Deze setup is bedoeld voor ontwikkeling en testen. Gebruik voor productie altijd veilige wachtwoorden, juiste gebruikersrechten en aanvullende validatie.
