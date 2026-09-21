/*=======================================================

        **Table Descriptions**


Baristas (Entity):

    - Primary Key: BaristaID

Shops (Entity):

    - Primary Key: ShopID

Pastries (Entity):

    - Primary Key: PastryID

Employs (Relationship between Shops and Baristas): 

    - Composite Primary Key: BaristasID & ShopID 

        * This is because there is no way to uniquely identify
        the employ row without having both foreign keys involved

    - Foreign Keys: BaristaId & ShopID

Offers (Relationship between Shops and Pastries)

    - Composite Primary Key: PastryID & ShopID
        
        * This is used for the same reason we have a composite pk
        in the employs tables. We could not uniquely identify
        the offer without both foreign keys

    - Foreign Keys: ShopID and PastryID

========================================================*/

-- This is finding the average of one of the categories 
select round(avg(Price), 2) AS avg_price from Pastries where Category = "pastry";

-- average price of each category
select Category, round(avg(Price), 2) from pastries
-- casting round on average price to ensure it follows basic price formatting
group by Category;

-- get the amount of baristas at each experience level
select Experience_Level, count(BaristaID) as Amount from baristas
group by Experience_Level;

-- get the amount of shops per city
select City, count(ShopID) as Amount from shops
group by City;
  
-- max price of each pastry category
SELECT Category, MAX(Price) as "Max Cost" -- alias for human readbility
from pastries
group by Category;

-- how many pastries have been added to each shop
select ShopID, count(PastryID) as "# of Pastries" -- aliasing
from offers
group by ShopID;

-- name of pastries whose price is equal to the max price of their category
select Name, Category, Price from pastries p
where price = 
-- using subquery to send back the max price of each category
(select max(price) from pastries where category = p.category);

/* show the unique id's of the shops who sold pastries greater 
than the avg price of all pastries */ 
select distinct ShopID from offers where PastryID in (
    select PastryID from pastries where price > (
        select avg(price) from pastries
    )
    -- double subquery because each can only return one column
);

-- pastry and shop id of the oldest offer made
-- aliasing makes it easier to understand
select ShopID as "Shop w/ Oldest Order", PastryID as "Oldest Pastry Order" 
from offers where Date_Added = (
    -- subquery sends back the earliest date of all offers
    select min(Date_Added) from offers
);

-- get the shops that sell the most pastries
select ShopID as "Shops w/ Most Pastries" from offers 
group by ShopID
having count(*) = ( -- count(*) to get the count of each shop in offers
    select max(n) from (
        -- subquery to find the count of each pastry in each shop
        select count(*) as n from offers group by ShopID
        -- group by ensures the count of each pastry is taken per shop
    ) as t -- sql client requires alias for a derived table
);

-- get the baristas that work in seattle
select BaristaID as "Baristas in Seattle" from employs where ShopID = (
    select ShopID from shops where City = "Seattle"
    -- subquery to return all shops in seattle
);


