/*
Michael Allen
Assignment 3

drop table if exists emission_metrics;
drop table if exists generation_records;
drop table if exists power_plants;
drop table if exists fuel_types;
drop table if exists countries;
drop table if exists operators;

create table countries (
    countrycode varchar(5) primary key,
    countryname varchar(56),
    continent varchar(13)
);


create table operators (
    operatorid int unsigned primary key,
    operatorname varchar(40),
    HQCountry varchar(56)
);

create table fuel_types (
    fuelid int unsigned primary key,
    category varchar(30),
    fuelname varchar(40)
);

create table power_plants(
    powerplantid int unsigned primary key,
    powerplantname varchar(40),
    countrycode varchar(5),
    operatorid int unsigned,
    fuelid int unsigned,
    CapacityMW decimal(10,2),
    CommissionYear smallint unsigned,
    foreign key (countrycode) references  countries(countrycode),
    foreign key (operatorid) references operators(operatorid),
    foreign key (fuelid) references fuel_types(fuelid)
);

create table generation_records (
    powerplantid int unsigned,
    Year smallint unsigned,
    GenGWh decimal(10, 2),
    primary key (powerplantid, Year),
    foreign key (powerplantid) references power_plants(powerplantid)
);

create table emission_metrics (
    powerplantid int unsigned,
    Year smallint unsigned,
    C02EmissionsTonnes int,
    primary key (powerplantid, Year),
    foreign key (powerplantid) references power_plants(powerplantid)
);
*/






-- Problem 1
select power_plants.powerplantname as 'Plant Name',
countries.countryname as "Country", operators.operatorname as 'Op Name', 
fuel_types.Category, fuel_types.fuelname,
power_plants.CapacityMW, power_plants.CommissionYear 
from power_plants 
join countries on countries.countrycode = power_plants.countrycode 
join operators on operators.operatorid = power_plants.operatorid
join fuel_types on fuel_types.fuelid = power_plants.fuelid
order by CapacityMW desc;


-- Problem 2 
select power_plants.powerplantname as 'Plant Name', power_plants.countrycode, 
generation_records.Year, generation_records.GenGWh from power_plants 
join generation_records on generation_records.powerplantid = power_plants.powerplantid
where generation_records.year = 2024
order by GenGWh desc;


-- Problem 3
select power_plants.powerplantname as 'Plant Name', countries.countrycode, generation_records.Year,
GenGWh, C02EmissionsTonnes from power_plants 
join countries on countries.countrycode = power_plants.countrycode
join generation_records on generation_records.powerplantid = power_plants.powerplantid
join emission_metrics on emission_metrics.powerplantid = power_plants.powerplantid
        and emission_metrics.Year = generation_records.Year
where generation_records.Year = 2024
order by C02EmissionsTonnes asc;


-- Problem 4
with total_cum_power_gen as (
    select operators.operatorname, HQCountry, sum(GenGWh) as Gen
    from operators
    left join power_plants on power_plants.Operatorid = operators.operatorid 
    left join generation_records on generation_records.powerplantid = power_plants.powerplantid
    group by operators.operatorname, operators.HQCountry
)
select * from total_cum_power_gen
order by gen desc; -- only seven rows because one Operator isn't in power_plants


-- Problem 5
with total_gen as (
    Select countries.countrycode, sum(GenGWh) as Generation
    from countries 
    join power_plants on countries.countrycode = power_plants.countrycode
    join generation_records on generation_records.powerplantid = power_plants.powerplantid
    group by countries.countrycode
),
total_emissions as (
    select countries.countrycode, sum(C02EmissionsTonnes) as Emissions
    from countries
    join power_plants on countries.countrycode = power_plants.countrycode 
    join emission_metrics on emission_metrics.powerplantid = power_plants.powerplantid
    group by countries.countrycode
)
select countries.countryname, total_gen.generation, total_emissions.emissions
from countries
join total_emissions on total_emissions.countrycode = countries.countrycode
join total_gen on total_gen.countrycode = countries.countrycode
order by generation desc;
