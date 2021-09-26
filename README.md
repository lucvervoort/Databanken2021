# Databanken 2021 - Aanvullend (Aalst)

### 1. Agenda Les 1

- **Studiewijzer**: punten voor Oracle certificaat staan rechtstreeks in verhouding tot aantal keer dat je quiz oefende.
- [Excel "bib"](./Les1/Bib/bib-excel.xlsx): "flat file" databank; onhandig: een databank is nodig (geen dubbele informatie, tabellen die naar elkaar wijzen)
  - [MS Access](./Les1/Bib/bib-access.accdb)
  - [SQL](./Les1/Bib/bib-mysql.sql) voor MySQL

- ["bib"](./Les1/Bib/bib-opgaven.pdf): oefeningen 1 tot en met 5
- Client/Server, [TCP/IP](./TCP.md): server draait bij ons lokaal voorlopig, nog niet "in the cloud"
  - Client stuurt sql, server berekent tweedimensionaal tabulair resultaat
  - Een client communiceert "over de draad" met de server en kan eender welke app zijn (C# .NET, workbench, ...)
  - n gebruikers in parallel
- Installeer MySQL (zie hieronder)
- Een databank is nog veel meer: backup/restore, disaster/recovery, ... .
- Practicum

### 2. Installatieprocedures

### 2.1. Installeer SQLServer op Windows

* [Ouder document voor lokale installatie](./InstallSqlServer.md)

### 2.2. Installeer MySQL op Windows

* [Procedure](./Les1/00-install-MySQL.pdf)

### 2.3. Installeer WSL2, Docker, MySQL en SQLServer

* [Procedure](./SQLServer2019ViaDocker.md)

### 2.4.Installeer SSMS

* [Procedure](./SSMSinstalleren.md)

### 2.5. Maak de databanken aan

* [Procedure voor MySQL](./Les1/01-importeer-databanken.pdf)

* [Northwind](./northwind-erd.png)

* [Procedure voor Microsoft](./MicrosoftTestDatabases.md)

* Scripts:

  | Database  | SQLServer                                                    | MySQL                                                        |
  | --------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
  | Northwind | [instnwnd.sql](./scripts/instnwnd.sql)                       | [instmynwnd.sql](./scripts/instmywnd.sql), [instmynwnddata.sql](./scripts/instmywnddata.sql) |
  | Pubs      | [instpubs.sql](./scripts/instpubs.sql)                       | [instmypubs.sql](./scripts/instmypubs.sql)                   |
  | Andere    | create-databases.sql, create-db-hr.sql, create-db-inventory.sql, create-db-invoicing.sql, create-db-store.sql | create-ss-databases.sql, create-ss-db-hr.sql, create-ss-db-inventory.sql, create-ss-db-invoicing.sql, create-ss-db-store.sql |


### 3. Optioneel: set operaties

* [Youtube](./SetOperations.md)
