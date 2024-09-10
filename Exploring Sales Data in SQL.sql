-- Inspecting Data 

select * from [dbo].[sales_data_sample]; 

-- Checking Unique Values 

select distinct status from [dbo].[sales_data_sample]; -- Plot in Tableau 
select distinct  year_id from [dbo].[sales_data_sample]; -- 3 years 
select distinct  PRODUCTLINE from [dbo].[sales_data_sample]; -- 7 products - Plot on Tableau
select distinct  COUNTRY from [dbo].[sales_data_sample]; -- Plot on Tableau 
select distinct DEALSIZE from [dbo].[sales_data_sample]; -- Plot on Tableau
select distinct TERRITORY from [dbo].[sales_data_sample];-- Plot on Tableau

-- Analysis 

-- Grouping sales by Productline 
select productline, sum(sales) as Revenue
from [dbo].[sales_data_sample]
group by productline 
order by 2 desc; 

select YEAR_ID, sum(sales) as Revenue
from [dbo].[sales_data_sample]
group by YEAR_ID
order by 2 desc; 

select distinct MONTH_ID from [dbo].[sales_data_sample]
where YEAR_ID = 2005; 

select distinct MONTH_ID from [dbo].[sales_data_sample]
where YEAR_ID = 2004; 

select distinct MONTH_ID from [dbo].[sales_data_sample]
where YEAR_ID = 2003; 

select DEALSIZE, sum(sales) as Revenue
from [dbo].[sales_data_sample]
group by DEALSIZE
order by 2 desc; 

-- Best Month for Sales in a Specific Year 

select MONTH_ID, sum(sales) as Revenue, count(ORDERNUMBER) as Frequency
from [dbo].[sales_data_sample]
where YEAR_ID = 2003
group by MONTH_ID
order by 2 desc; 

select MONTH_ID, sum(sales) as Revenue, count(ORDERNUMBER) as Frequency
from [dbo].[sales_data_sample]
where YEAR_ID = 2004
group by MONTH_ID
order by 2 desc; 

-- November is a great month for the company! What product do they selll in Novemeber? 

select MONTH_ID, PRODUCTLINE, sum(sales) as Revenue, count(ORDERNUMBER) as Frequency from [dbo].[sales_data_sample]
where YEAR_ID = 2003 and MONTH_ID = 11
group by MONTH_ID, PRODUCTLINE 
order by 3 desc; 

select MONTH_ID, PRODUCTLINE, sum(sales) as Revenue, count(ORDERNUMBER) as Frequency from [dbo].[sales_data_sample]
where YEAR_ID = 2004 and MONTH_ID = 11
group by MONTH_ID, PRODUCTLINE 
order by 3 desc; 

-- Classic cars for  the win! Who is out best customer? (Best Answered with RFM - Recency-Frequency Monetary) 

select CUSTOMERNAME,PRODUCTLINE, sum(sales) as Revenue, count(ORDERNUMBER) as Frequency from [dbo].[sales_data_sample]
where YEAR_ID = 2003
group by CUSTOMERNAME, PRODUCTLINE
order by 3 desc; -- Mine

select CUSTOMERNAME,PRODUCTLINE, sum(sales) as Revenue, count(ORDERNUMBER) as Frequency from [dbo].[sales_data_sample]
where YEAR_ID = 2004
group by CUSTOMERNAME, PRODUCTLINE
order by 3 desc; -- Mine 

select 
	CUSTOMERNAME,
	sum(sales) as MonetaryValue,
	avg(sales) as AvgMonetaryValue,
	count(ORDERNUMBER) as Frequency,
	max(ORDERDATE)as last_order_data,
	(select max(ORDERDATE) from [dbo].[sales_data_sample]) as max_order_date,
	DATEDIFF(DD,max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) as Recency 
from [dbo].[sales_data_sample]
group by CUSTOMERNAME; 


DROP TABLE IF EXISTS #rfm
;with rfm as 
(
select 
	CUSTOMERNAME,
	sum(sales) as MonetaryValue,
	avg(sales) as AvgMonetaryValue,
	count(ORDERNUMBER) as Frequency,
	max(ORDERDATE)as last_order_data,
	(select max(ORDERDATE) from [dbo].[sales_data_sample]) as max_order_date,
	DATEDIFF(DD,max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) as Recency 
from [dbo].[sales_data_sample]
group by CUSTOMERNAME
), 
rfm_calc as 
(


select r.*,
	NTILE(4) OVER (order by Recency desc) as rfm_recency, 
	NTILE(4) OVER (order by Frequency) as rfm_frequency, 
	NTILE(4) OVER (order by MonetaryValue) as rfm_monetary
from rfm r
)
select 
	c.*, rfm_recency+ rfm_frequency + rfm_monetary as rfm_cell,
	cast (rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary as varchar)rfm_cell_string
into #rfm
from rfm_calc c; 

select * from #rfm;

select CUSTOMERNAME, rfm_recency, rfm_frequency, rfm_monetary,
	case 
		when rfm_cell_string in (111, 112, 121, 122, 123,132,211, 212,114,141) then 'lost_customer' -- lost customer 
		when rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping_away, cannot_lose' -- Big buyers who have not purchased anything lately
		when rfm_cell_string in (311, 411, 331) then 'new_customers' 
		when rfm_cell_string in (222, 223, 233, 322) then 'potential_churners' 
		when rfm_cell_string in (323, 333, 321, 422, 332, 432) then 'active' --Returning customer, however, purchase low cost items 
		when rfm_cell_string in (323, 333, 321, 443, 444) then 'loyal' 
	end rfm_segment 

FROM #rfm; 

-- What products are most often sold together?

select ORDERNUMBER, count(*) AS RN 
FROM [dbo].[sales_data_sample]
where STATUS = 'Shipped' 
group by ORDERNUMBER;

select * from [dbo].[sales_data_sample] where ORDERNUMBER = 10411; 

select ORDERNUMBER 
FROM ( 
	select ORDERNUMBER, count(*) AS RN 
	FROM [dbo].[sales_data_sample]
	where STATUS = 'Shipped' 
	group by ORDERNUMBER
)  as m 
where rn =2 



select stuff(

	(select ',' + PRODUCTCODE 
	from [dbo].[sales_data_sample]
	where ORDERNUMBER in 
		(

			select ORDERNUMBER 
			FROM ( 
				select ORDERNUMBER, count(*) AS RN 
				FROM [dbo].[sales_data_sample]
				where STATUS = 'Shipped' 
				group by ORDERNUMBER
			)  as m 
			where rn = 3
		)
		for xml path ('')) 
		
		,1, 1, '') as Product_Codes 


select distinct ORDERNUMBER, stuff(

	(select ',' + PRODUCTCODE 
	from [dbo].[sales_data_sample] as P
	where ORDERNUMBER in 
		(

			select ORDERNUMBER 
			FROM ( 
				select ORDERNUMBER, count(*) AS RN 
				FROM [dbo].[sales_data_sample]
				where STATUS = 'Shipped' 
				group by ORDERNUMBER
			)  as m 
			where rn = 3
		)
		and p.ORDERNUMBER = s.ORDERNUMBER
		for xml path ('')) 
		
		,1, 1, '') Product_Codes 

FROM [dbo].[sales_data_sample] AS S
Order by 2 desc; 



-- Sales across the city/country