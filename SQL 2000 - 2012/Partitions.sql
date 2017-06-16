{\rtf1\ansi\ansicpg1252\cocoartf1038
{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;}
\margl1440\margr1440\vieww9000\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\ql\qnatural

\f0\fs26 \cf0 /* SQL Server Sample of Range partition schema maps all partition to same filegroup */\
CREATE PARTITION FUNCTION myRangePF3 (int) \
AS RANGE LEFT FOR VALUES (6, 11, 16, 21); \
GO \
CREATE PARTITION SCHEME myRangePS3 \
AS PARTITION myRangePF3 \
ALL TO (\'91primary\'92); \
GO \
CREATE TABLE employees ( \
id INT NOT NULL, \
fname VARCHAR(30), \
lname VARCHAR(30), \
hired DATE NOT NULL DEFAULT '1970-01-01', \
separated DATE NOT NULL DEFAULT '9999-12-31', \
job_code INT NOT NULL, \
store_id INT NOT NULL \
) ON myRangePS3(store_id); }