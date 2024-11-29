create or replace table labels as
select * from read_csv('labels.csv');
