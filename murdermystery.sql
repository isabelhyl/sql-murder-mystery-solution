-- jan 15 2018
-- SQL City
-- murder

select * from crime_scene_report 
where type="murder"
and date=20180115
and city="SQL City";
-- Security footage shows that there were 2 witnesses. 
-- The first witness lives at the last house on "Northwestern Dr". 
-- The second witness, named Annabel, lives somewhere on "Franklin Ave".

-- first witness: 
select * from person
where address_street_name = "Northwestern Dr"
and address_number = (select max(address_number) from person);
-- name: Morty Schapiro
-- id: 14887

-- second witness:
select * from person
where name like "%Annabel%"
and address_street_name = "Franklin Ave";
-- name: Annabel Miller
-- id: 16371


-- search for these two witness' interviews
select * from interview
where person_id in (16371, 14887);

-- morty's statement:
-- I heard a gunshot and then saw a man run out. 
-- He had a "Get Fit Now Gym" bag. 
-- The membership number on the bag started with "48Z". 
-- Only gold members have those bags. 
-- The man got into a car with a plate that included "H42W".

-- annabel's statement:
-- I saw the murder happen, 
-- and I recognized the killer 
-- from my gym when I was working out last week 
-- on January the 9th.

-- killer data:
-- membership_id = "48Z%" (gold member)
-- check in date = 20180109

-- accomplice data:
-- license plate number like "%H42W%"

-- check everything except for the associated license (later)
select * from get_fit_now_check_in 
where membership_id like "48Z%" 
and check_in_date = 20180109;
-- 2 suspects:
-- gym member id 48Z7A and 48Z55

select * from get_fit_now_member
where id in ("48Z7A", "48Z55");
-- suspects' names:
-- Jeremy Bowers
-- Joe Germuska

-- okay, now let's search for the accomplice first, we'll get right back to the suspects later
select * from person 
where license_id in (
    select id from drivers_license 
    where plate_number like "%H42W%"
);
-- suspected accomplices: 
-- Tushar Chandra (51739)
-- Jeremy Bowers (67318)
-- Maxine Whitely (78193)

-- so the suspect and accomplice have the same person in common, which is Jeremy Bowers.
-- this means that the "killer" that Annabel saw was just a puppet, an accomplice for another person
-- but let's verify and see

-- search for the interviews of the accomplices:
select * from interview
where person_id in (51739, 67318, 78193);
-- accompice: 67318 (Jeremy Bowers)
-- his statement: 
-- I was hired by a woman with a lot of money. 
-- I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
-- She has red hair and she drives a Tesla Model S. 
-- I know that she attended the SQL Symphony Concert 3 times in December 2017.

-- now we have a new suspect who's a woman

-- but first, to prove that the accomplice is indeed the "killer" that Annabel saw, let's check our previous 2 suspects:
select * from interview 
where person_id in (
    select id from person
    where name in ("Jeremy Bowers", "Joe Germuska")
);
-- okay, so it's the same interview as we previously saw before, the person who described that woman, so the accomplice IS Jeremy Bowers

-- now that we got that clear, let's try searching for the woman 

select * from drivers_license 
where car_model = "Model S" 
and car_make = "Tesla"
and gender = "female"
and height = "67";

-- no person has all those characteristics but with the height of 67, so let's try 65

select * from drivers_license 
where car_model = "Model S" 
and car_make = "Tesla"
and gender = "female"
and height = "65";
-- okay, i found a woman with the same exact descriptions as mentioned
-- her license id is 918773	

-- let's search for her data as a person:
select * from person
where license_id = 918773;	
-- okay, her person id is 78881	
-- and her name is Red Korb

-- let's try searching for her interview:
select * from interview
where person_id = 78881;
-- okay, no results
-- which means she hasn't been interviewed yet

-- let's try searching for her facebook event, just to confirm
-- SQL Symphony Concert 3 times in December 2017.

select *
from facebook_event_checkin
where event_name = "SQL Symphony Concert"
and person_id = 78881;
-- okay, i guess they don't have any results with that person id 

select person_id, count(person_id) as count
from facebook_event_checkin
where event_name = "SQL Symphony Concert"
and date between 20171201 and 20171231
group by person_id
having count=3;
-- okay, we found 2 suspects now
-- ids: 24556, 99716

-- let's search for their interviews
select * from interview
where person_id in (24556, 99716);
-- no data damn

-- let's just search for their person data
select * from person 
where id in (24556, 99716);
-- okay, Bryan Pardo (24556) and Miranda Priestly (99716)

select * from drivers_license 
where id = 202298;

-- okay, i guess i misunderstood Jeremy Bower's statement. 
-- when people say 65 or 67, they don't mean "or" in a LITERAL sense
-- they meant it as a range, so what he meant was "between 65 and 67"
-- so i should've also considered the possibility of a person being the height of 66

-- now that I've searched up Miranda Priestly's data, it all matches with Jeremy's description
-- so now I've come to the conclusion that the murderer is Miranda Priestly

-- output: Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!

-- Alright, I have found the murderer



