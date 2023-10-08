create table sprint( date1 int,
quantity_sold_sprint int,cumilative_sales_sum_7days_sprint bigint);


INSERT INTO sprint (date1,quantity_sold_sprint,cumilative_sales_sum_7days_sprint)
SELECT
    DATEDIFF(date(sales_date),'2016-10-09') as date1,
    sum(count(*)) over (partition by DATEDIFF(date(sales_date),'2016-10-09') order by DATEDIFF(date(sales_date),'2016-10-09')) ,
    sum(count(*)) over ( ROWS BETWEEN 6 Preceding AND Current Row)
FROM
    Sales
WHERE
    product_id=7 and
    date(sales_date) between '2016-10-10' and '2016-10-30'
GROUP BY 
    DATEDIFF(date(sales_date),'2016-10-09')
ORDER BY 
    DATEDIFF(date(sales_date),'2016-10-09');
    

Create table sprintLE like sprint;

ALTER TABLE sprintle
CHANGE COLUMN quantity_sold_sprint quantity_sold_sprintle int,
CHANGE COLUMN cumilative_sales_sum_7days_sprint cumilative_sales_sum_7days_sprintle bigint;

INSERT INTO sprintle (date1,quantity_sold_sprintle,cumilative_sales_sum_7days_sprintle)
SELECT
	DATEDIFF(date(sales_date),'2017-02-14'),
    sum(count(*)) over (partition by DATEDIFF(date(sales_date),'2017-02-14') order by DATEDIFF(date(sales_date),'2017-02-14')),
    sum(count(*)) over ( ROWS BETWEEN 6 Preceding AND Current Row)
FROM
	Sales
WHERE
	product_id=8 and 
    date(sales_date) between '2017-02-15' and '2017-03-07'
GROUP BY 
	DATEDIFF(date(sales_date),'2017-02-14')
ORDER BY 
	DATEDIFF(date(sales_date),'2017-02-14');
    
Select * from sprint;
Select * from sprintle;


Select s.date1,quantity_sold_sprint as sprint,quantity_sold_sprintle as sprintle,
cumilative_sales_sum_7days_sprint as csprint,cumilative_sales_sum_7days_sprintle as csprintle from sprint s natural join sprintle sl
order by s.date1;

Select * from emails;
Select * from email_subject;

create table email_main like emails;

Insert into email_main (email_id,customer_id,opened,clicked,bounced,sent_date,opened_date,clicked_date,email_subject_id) 
(Select * from emails where email_subject_id in (1,3,7,8,9,11,13,15) and 
date(sent_date) between '2016-08-09' and '2016-10-09');

Select * from email_main;




alter table email_main
add column clicked_date_m datetime;

alter table email_main
add column opened_date_m datetime;


UPDATE email_main
SET clicked_date_m =
    CASE
        WHEN clicked_date IS NOT NULL AND clicked_date != '' THEN
            CASE
                WHEN clicked_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$' THEN clicked_date
                WHEN STR_TO_DATE(clicked_date, '%d-%m-%Y %H:%i') IS NOT NULL THEN STR_TO_DATE(clicked_date, '%d-%m-%Y %H:%i')
                ELSE NULL
            END
        ELSE NULL
    END;
    
    
UPDATE email_main
SET opened_date_m =
    CASE
        WHEN opened_date IS NOT NULL AND opened_date != '' THEN
            CASE
                WHEN opened_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$' THEN opened_date
                WHEN STR_TO_DATE(opened_date, '%d-%m-%Y %H:%i') IS NOT NULL THEN STR_TO_DATE(opened_date, '%d-%m-%Y %H:%i')
                ELSE NULL
            END
        ELSE NULL
    END;

Alter table email_main
drop column clicked_date,
drop column opened_date;




describe email_main;

Select * from email_main;


Select count(date(sent_date)) as email_sent,
count(date(clicked_date_m)) as clicked,
count(date(opened_date_m)) as opened from email_main;

Select count(*) as bounced from email_main where bounced='t';












