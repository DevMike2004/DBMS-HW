
select * from pastries;

/* This is finding the average of one of the categories */
select ROUND(AVG(Price), 2) AS avg_price from Pastries where Category = "pastry";

-- average price of each category
select Category, ROUND(AVG(Price), 2) from pastries
group by Category;

-- get the amount of baristas at each experience level
select Experience_Level, COUNT(BaristaID) as Amount from baristas
group by Experience_Level;

-- get the amount of shops per city
select City, COUNT(ShopID) as Amount from shops
group by City;
  
-- max price of each pastry category
SELECT * from pastries;
SELECT category, MAX(Price) as "Max Cost" from pastries
group by Category;

-- how many pastries have been added to each shop
select ShopID, Count(PastryID) as "# of Pastries" from offers
group by ShopID;

-- name of pastries whose price is equal to the max price of their category
select name, category, price from pastries p
where price = (select max(price) from pastries where category = p.category);

-- show the unique id's of the shops who sold pastries greater than the avg price
-- of pastries
select distinct ShopID from offers where PastryID IN (
    select PastryID from pastries where price > (
        select avg(price) from pastries
    )
);

-- pastry and shop id of the oldest offer made
select ShopID, PastryID from offers where Date_Added = (
    select min(Date_Added) from offers
);

-- get the shops that sell the most pastries
select ShopID from offers 
group by ShopID
having count(*) = (
    select max(n) from (
        select count(*) as n from offers group by ShopID
    ) as t
);

-- get the baristas that work in seattle
select BaristaID from employs where ShopID = (
    select ShopID from shops where City = "Seattle"
);


