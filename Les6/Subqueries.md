# Subqueries

## Inleiding

Een subquery is een SELECT statement genest binnen een SELECT, INSERT, UPDATE, of DELETE statement of binnen een andere subquery. Subqueries kunnen genest of gecorreleerd zijn; geneste subqueries worden uitgevoerd wanneer de buitenste query uitgevoerd id, en gecorreleerde subqueries worden eenmaal uitgevoerd voor elke rij die wordt geretourneerd wanneer de buitenste query wordt uitgevoerd.

## Wanneer subqueries gebruiken

Gebruik subqueries om een complexe query op te splitsen in een reeks logische stappen en een probleem op te lossen met een enkel statement. subqueries zijn nuttig wanneer uw query afhankelijk is van de resultaten van een andere query.

## Wanneer joins gebruiken in plaats van subqueries

Vaak kan een query die subqueries bevat worden geschreven als een join. De performance van de query kan vergelijkbaar zijn met beide benaderingen. Het verschil is dat een subquery kan vereisen dat de query optimizer extra stappen uitvoert, zoals sorteren, wat de verwerkingsstrategie kan beïnvloeden.

Door joins te gebruiken, kan de query optimizer gegevens op de meest efficiënte manier ophalen. Gebruik geen subqueries tenzij de query meerdere stappen vereist en u de gewenste resultaten niet kunt bereiken met een join.

## Subqueries gebruiken

Als je besluit om subqueries te gebruiken, houd dan rekening met de volgende feiten en richtlijnen:

- je moet subqueries tussen haakjes plaatsen.

- je kan slechts één uitdrukking of kolomnaam gebruiken in de selectielijst van een subquery die een waarde retourneert.

- je kan subqueries gebruiken in plaats van een expressie, zolang een enkele waarde of lijst van waarden wordt geretourneerd.

- Een subquery kan geen kolom retourneren die van het type tekst of afbeeldingsgegevens is.

- je kan zo veel niveaus van subqueries hebben als je nodig hebt, er is geen limiet.

- De query die de subquery bevat wordt meestal de **outer query** genoemd, en een subquery wordt een **inner query** genoemd.

## Geneste subqueries

Geneste subqueries retourneren ofwel een enkele waarde of een lijst van waarden. SQL Server evalueert een geneste subquery eenmaal en gebruikt dan de waarde of lijst geretourneerd door de subquery in de buiten query.

### Een enkele waarde teruggeven

Gebruik een geneste subquery die een enkele waarde retourneert om te vergelijken met een waarde in de buitenste query.

Wanneer je geneste subqueries gebruikt om een enkele waarde terug te geven, overweeg dan de volgende richtlijnen:

- subqueries met één waarde kunnen worden gebruikt in alle situaties waarin een expressie kan worden gebruikt.
- gebruik in een WHERE-clausule de geneste subquery met een vergelijkingsoperator.
- Als een geneste subquery meer dan één waarde retourneert terwijl de buitenste query slechts één waarde verwacht, geeft SQL Server een foutmelding.
- je kan een aggregatiefunctie gebruiken of een expressie of kolomnaam opgeven om een enkele waarde te retourneren.
- elke geneste subquery wordt slechts eenmaal geëvalueerd.

### Voorbeeld 1

Dit voorbeeld gebruikt een geneste SELECT-instructie met één waarde in de WHERE-clausule om alle klanten uit de tabel met bestellingen terug te geven die op de laatst geregistreerde dag bestellingen hebben geplaatst.

```sql
USE northwind;
SELECT id, Customer_id  
FROM orders  
WHERE order_date = (SELECT MAX(order_date) FROM orders);
```

## Gecorreleerde Subqueries

Voor gecorreleerde subqueries gebruikt de inner query informatie van de outer query en wordt deze eenmaal uitgevoerd voor elke rij in de buitenste query.

Wanneer je gecorreleerde subqueries gebruikt, moet je rekening houden met de volgende feiten en richtlijnen:

- je moet aliassen gebruiken om tabelnamen te onderscheiden.

- gecorreleerde subqueries kunnen meestal worden geherformuleerd als joins. Het gebruik van joins in plaats van gecorreleerde subqueries stelt SQL Server query optimizer in staat om te bepalen hoe de gegevens op de meest efficiënte manier gecorreleerd kunnen worden.

### Voorbeeld 1

Dit voorbeeld geeft een lijst van klanten die meer dan 150 items van product nummer 34 hebben besteld in een enkele order.

```sql
USE northwind;
 
SELECT id, Customer_id 
FROM orders o  
WHERE 150 < (SELECT quantity  
			FROM order_details od
            WHERE o.ID = od.order_id AND od.product_id = 34);
```

1. De outer query geeft een kolomwaarde door aan de innerquery. In dit voorbeeld geeft de outerquery de waarde van de kolom order_id door aan de binnenste query.
2. De inner query gebruikt de waarde die de outer query doorgeeft. De order_id uit de tabel orders wordt gebruikt in de zoekvoorwaarde van de WHERE-clausule van de inner query. De inner query probeert een rij in de tabel order_details te vinden die overeenkomt met de order_id uit de outer query en product_id 34.
3. De inner query stuurt een waarde terug naar de outer query. Als in de inner query een rij is gevonden, wordt de waarde uit de kolom quantity van die rij teruggegeven aan de outer query - anders wordt NULL teruggegeven aan de outer query. De WHERE-clausule van de outer query evalueert vervolgens de zoekvoorwaarde om te bepalen of de hoeveelheid groter is dan 150, in welk geval de bestelling wordt opgenomen in de result set van de outer query.
4. Ga naar de volgende rij in de tabel orders. De outer query gaat verder naar de volgende rij en SQL Server herhaalt het evaluatieproces voor die rij.

### Voorbeeld 2

Dit voorbeeld geeft een lijst van producten en de grootste bestelling ooit geplaatst voor elk product. Merk op dat deze gecorreleerde subquery een tweede alias gebruikt om naar dezelfde tabel te verwijzen als de buitenste query. De Products tabel wordt alleen gebruikt om de productnaam op te zoeken; de tabel is niet betrokken in de subquery.

```sql
USE northwind;

SELECT DISTINCT product_name, quantity  
FROM order_details od1 
JOIN products p  ON od1.product_id = p.id  
WHERE quantity = (SELECT MAX(quantity)                 
                  FROM order_details od2                                 
                  WHERE od1.product_id = od2.product_id);
```

## Gebruik van de EXISTS en NOT EXISTS sleutelwoorden

Je kan de sleutelwoorden EXISTS en NOT EXISTS gebruiken om te bepalen of een subquery rijen teruggeeft.

### Gebruik met gecorreleerde subqueries

Gebruik de EXISTS en NOT EXISTS sleutelwoorden in gecorreleerde subqueries om de resultaat set van een outer query te beperken tot rijen die voldoen aan de subquery. De EXISTS en NOT EXISTS sleutelwoorden geven TRUE of FALSE terug, gebaseerd op of rijen geretourneerd worden door de subquery. De subquery wordt getest om te zien of hij rijen zal teruggeven; hij geeft geen gegevens terug. Gebruik * (asterisk) in de select list van de subquery aangezien er geen reden is om kolomnamen te gebruiken.

#### Voorbeeld 1

Dit voorbeeld gebruikt een gecorreleerde subquery met een EXISTS sleutelwoord in de WHERE clausule om een lijst te retourneren van werknemers die orders ontvingen op 30/1/2006.

```sql
USE northwind;

SELECT last_name, id 
FROM employees e  
WHERE EXISTS (SELECT * FROM orders     
              WHERE e.id = orders.employee_id AND order_date = '2006-01-30');
```

#### Voorbeeld 2

Dit voorbeeld geeft dezelfde resultatenverzameling als *Voorbeeld 1* om te laten zien dat je een join operatie zou kunnen gebruiken in plaats van een gecorreleerde subquery.

```sql
USE northwind;  

SELECT last_name, e.id  
FROM orders 
INNER JOIN employees e ON orders.employee_id = e.id
WHERE order_date = '2006-01-30';
```