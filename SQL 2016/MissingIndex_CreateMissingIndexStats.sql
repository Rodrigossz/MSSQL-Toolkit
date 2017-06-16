/**********************
This is a demo script from http://brentozar.com
Scripts provided for testing/demo purposes only.
This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
http://creativecommons.org/licenses/by-nc-sa/3.0/
***********************/

/*****************************
This set of queries generates sample missing index information
for the Contoso Retail DW database.
This uses queries that cause conversion errors on purpose:
missing index recommendations will be generated, 
but this will still run very fast.
******************************/

--***IMPORTANT****
--Set Query Options for this connection to 'discard results'.


use ContosoRetailDW
GO

--Queries to build stats

select top 50 OnlineSalesKey, DateKey, StoreKey, PromotionKey
from dbo.FactOnlineSales
where DateKey > '2009-11-11'
and ProductKey = 'abc'
go 200

select top 50 OnlineSalesKey, DateKey, StoreKey, PromotionKey
from dbo.FactOnlineSales
where DateKey > '2010-01-10'
and ProductKey = 'abc'
go 201


select top 50 OnlineSalesKey, DateKey, StoreKey
from dbo.FactOnlineSales
where DateKey > '2010-01-10'
and ProductKey = 'abc'
go 202


select OnlineSalesKey, StoreKey
from dbo.FactOnlineSales
where DateKey > 'a'
go 413



--Other indexes (just for color)
select CurrencyKey, OnlineSalesKey, StoreKey, ProductKey
from dbo.FactOnlineSales
where currencyKey ='a'
and storekey='a'
go 2

select ProductKey, StoreKey, PromotionKey
from factsales
where StoreKey='a'
go 4

select *
from FactSalesQuota
where StoreKey = 'a'
GO 2

select DateKey, Amount
from FactStrategyPlan
where Amount > 'a'
go



/****************
--Optional commands to clear all missing index recommendations
for the ContosoRetailDW database without restarting the instance.

use master
alter database ContosoRetailDW set offline with rollback immediate
alter database ContosoRetailDW set online
use ContosoRetailDW
go
****************/
