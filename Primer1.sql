SELECT * FROM test.sleep_health;

.................................................................
-- There are 374 rows in the table
  
select count(*) from sleep_health; 
.................................................................
  -- There are 13 columns.  

select count(*) from information_schema.columns where table_name='sleep_health'; 
..................................................................
-- all data types are correct.
  
describe sleep_health;
..................................................................
-- change column names into proper understandable names with underscore connecetion, because l am working in mysql workbench
  
alter table sleep_health change column Physical Activity Level Daily phisical level(minutes) int;
..................................................................
-- checking if there are null values
select Sleep_Duration from sleep_health;
..................................................................
-- l found 242 duplicate rows, with all the same values except the Person_ID column. But this is a sinthetic dataset
-- dowloaded from Kaggle's datasets, it is for ilustrative purposes. So l will not delete duplicate rows because this dataset
-- is not a reflection of real data but it serves for technical purposes

select count(*)from sleep_health where Gender is null or Person_ID is null or Age is null or Occupation is null or Sleep_Duration is null
or Quality_of_Sleep is null or Daily_phisical_activity is null or Stress_Level is null or BMI_Category is null or Blood_Pressure is null
or Heart_Rate is null or Daily_Steps is null or Sleep_Disorder is null;
SELECT *, ROW_NUMBER () Over (PARTITION BY Person_ID ORDER BY Person_ID) as row_ from sleep_health;
#checking for duplicate rows
select count(*) FROM sleep_health#delete from
WHERE
  Person_ID IN (SELECT Person_ID FROM
      (
        SELECT
          Person_ID,  ROW_NUMBER() OVER ( PARTITION BY Age, Occupation, Sleep_Duration,Quality_of_Sleep,
          Daily_phisical_activity,Stress_Level, BMI_Category, Blood_Pressure, Heart_Rate,
          Daily_Steps, Sleep_Disorder ORDER BY Person_ID) AS row_num
        FROM sleep_health
      ) t
    WHERE
      row_num > 1
  );
  select distinct(Occupation) from sleep_health;
  select distinct(Occupation), count(*) as counts from sleep_health group by Occupation order by counts desc;
.............................................................................................................
  -- creating new columns based of the existing ones
  
  alter table sleep_health add Sleep_Duration_time varchar(10);
  set sql_safe_updates=0;
  update sleep_health set Sleep_Duration_time=
   case
  when Sleep_Duration between 5.5 and 5.9 then '5-6 hours'
  when Sleep_Duration between 6.0 and 6.9 then '6-7 hours'
  when Sleep_Duration between 7.0 and 7.9 then '7-8 hours'
  else '8+ hours' end;
................................................................................................
  -- deleting column
  
  alter table sleep_health drop column Quality_of_Sleep;
  ...............................................................................................
 -- renaming column value, after seeing there is a Normal and Normal Weight column value in BMI_Category
  
 update sleep_health set BMI_Category='Normal' where BMI_Category='Normal Weight';
....................................................................................................
-- making Blood_Pressure column into u textual one
  
 SELECT Blood_Pressure,
SUBSTRING(Blood_Pressure, 1, locate('/', Blood_Pressure) -1 ) as Address1
, SUBSTRING(Blood_Pressure, locate('/', Blood_Pressure) + 1 , length(Blood_Pressure)) as Address2
from sleep_health;
alter table sleep_health add column systolic int;
update sleep_health set systolic= SUBSTRING(Blood_Pressure, 1, locate('/', Blood_Pressure) -1 );
alter table sleep_health add column diastolic int;
update sleep_health set diastolic=SUBSTRING(Blood_Pressure, locate('/', Blood_Pressure) + 1 , length(Blood_Pressure));
select Blood_Pressure, case
when systolic<120 and diastolic<80 then 'optimal'
when systolic between 120 and 129 and diastolic between 80 and 84 then 'normal'
when systolic between 130 and 139 and diastolic between 85 and 89 then 'elevated'
when systolic between 140 and 159 and diastolic between 90 and 99 then 'high hypertension 1'
when systolic between 160 and 179 and diastolic between 100 and 109 then 'high hypertension 2'
when systolic>=180 and diastolic>=110 then 'hypertension crisis'
else 'unknown' end as new
from sleep_health;
alter table sleep_health add column Blood_Pressure_text text;
update sleep_health set Blood_Pressure_text=
case
when systolic<120 and diastolic<80 then 'optimal'
when systolic between 120 and 129 and diastolic between 80 and 85 then 'normal'
when systolic between 130 and 139 and diastolic between 85 and 92 then 'elevated'
when systolic between 140 and 159 and diastolic between 90 and 99 then 'high hypertension 1'
when systolic between 160 and 179 and diastolic between 100 and 109 then 'high hypertension 2'
when systolic>=180 and diastolic>=110 then 'hypertension crisis'
else 'unknown' end;
.....................................................................................................
-- checking if some values fall out of range
select Blood_Pressure, Blood_Pressure_text from sleep_health where Blood_Pressure_text='unknown';














