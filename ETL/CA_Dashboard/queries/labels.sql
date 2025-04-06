create or replace table labels as
select * from read_csv('data/labels.csv');
