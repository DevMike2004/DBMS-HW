/*
countries          

    CountryCode        CHAR(3)          Primary Key 
    CountryName        VARCHAR       
    Continent          VARCHAR       
 
  organizations     

    OrgID              INT              Primary Key 
    OrgName            VARCHAR       
    HeadquartersCountry CHAR(3)      
    OrgType            VARCHAR       
 
  launch_sites       

    SiteID             INT              Primary Key
    SiteName           VARCHAR       
    CountryCode        CHAR(3)          Foreign Key 
    Status             VARCHAR       
 
  rockets             

    RocketID           INT              Primary Key 
    RocketName         VARCHAR       
    OrgID              INT              Foreign Key 
    PayloadCapacityKg  INT           
    OperationalStatus  VARCHAR       
 
  missions             

    MissionID          INT              Primary Key
    MissionName        VARCHAR       
    RocketID           INT              Foreign Key 
    SiteID             INT              Foreign Key 
    Destination        VARCHAR       
    LaunchYear         INT           
    Outcome            VARCHAR       
 
  payloads             

    PayloadID          INT              Primary Key 
    MissionID          INT              Foreign Key
    PayloadName        VARCHAR       
    PayloadType        VARCHAR       
    MassKg             DECIMAL(10,2) 
*/

-- Query 1
select missions.MissionName,
       rockets.RocketName,
       organizations.OrgName,
       launch_sites.SiteName,
       missions.Destination,
       missions.LaunchYear,
       missions.Outcome
from missions
join rockets       on missions.RocketID = rockets.RocketID
join organizations on rockets.OrgID     = organizations.OrgID
join launch_sites  on missions.SiteID   = launch_sites.SiteID
order by missions.LaunchYear desc,
         missions.MissionName asc;




-- Query 2
select missions.MissionName,
       rockets.RocketName,
       payloads.PayloadName,
       payloads.PayloadType,
       payloads.MassKg
from payloads
join missions on payloads.MissionID = missions.MissionID
join rockets  on missions.RocketID  = rockets.RocketID
where missions.LaunchYear = 2024
order by payloads.MassKg desc;



-- Query 3
select launch_sites.SiteName,
       missions.MissionName,
       rockets.RocketName,
       missions.LaunchYear
from launch_sites
left join missions on launch_sites.SiteID = missions.SiteID
                  and missions.LaunchYear = 2024
left join rockets  on missions.RocketID   = rockets.RocketID
order by launch_sites.SiteName asc;



-- Query 4
with org_payload_totals as (
    select rockets.OrgID,
           sum(payloads.MassKg) as TotalPayloadMassKg
    from payloads
    join missions on payloads.MissionID = missions.MissionID
    join rockets  on missions.RocketID  = rockets.RocketID
    group by rockets.OrgID
)
select organizations.OrgName,
       organizations.HeadquartersCountry,
       organizations.OrgType,
       org_payload_totals.TotalPayloadMassKg
from organizations
join org_payload_totals on organizations.OrgID = org_payload_totals.OrgID
order by org_payload_totals.TotalPayloadMassKg desc;


-- Query 5
with missions_by_country as (
    select launch_sites.CountryCode,
           count(missions.MissionID) as TotalMissions
    from missions
    join launch_sites on missions.SiteID = launch_sites.SiteID
    group by launch_sites.CountryCode
),
payload_mass_by_country as (
    select launch_sites.CountryCode,
           sum(payloads.MassKg) as TotalPayloadMassKg
    from payloads
    join missions     on payloads.MissionID = missions.MissionID
    join launch_sites on missions.SiteID    = launch_sites.SiteID
    group by launch_sites.CountryCode
)
select countries.CountryName,
       missions_by_country.TotalMissions,
       payload_mass_by_country.TotalPayloadMassKg
from countries
join missions_by_country     on countries.CountryCode = missions_by_country.CountryCode
join payload_mass_by_country on countries.CountryCode = payload_mass_by_country.CountryCode
order by payload_mass_by_country.TotalPayloadMassKg desc;
