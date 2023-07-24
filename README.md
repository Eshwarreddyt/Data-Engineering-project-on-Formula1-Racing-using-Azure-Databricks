# Formula-1-Data-Engineering-Project-Using-Azure-Databricks
<h3>Project Overview:</h3>
This project aims to provide a data analysis solution for Formula-1 race results using Azure Databricks. This is an ETL pipeline to ingest Formula 1 motor racing data, transform and load it into our data warehouse for reporting and analysis purposes. The data is sourced from ergast.com, a website dedicated to Formula 1 statistics, and is stored in Azure Datalake Gen2 storage. Data transformation and analysis were performed using Azure Databricks. The entire process is orchestrated using Azure Data Factory.

<h3>Formula1 Overview</h3>
Formula 1 (F1) is the top tier of single-seater auto racing worldwide, governed by the FIA. It features high-tech, powerful cars with hybrid engines. Every season happens once a year, each race happens over weekends (Friday to Sunday). Each race is conducted in individual circuits. 10 Teams/Constructors will participate. Two Drivers will be assigned in a team. The season includes 20-23 races (Grands Prix) held in various countries. Safety is a priority with strict regulations and constant advancements. Pit stops for tire changes and adjustments are common. There will be a qualifying round conducted on Saturday to decide the grid positions of drivers for the Sunday match. Each race contains 50-70 laps. Pitstops will be available to change tires or cars. Race results include driver standings and constructor standings. The driver that tops the driver's standings becomes the drivers' champion and the team that tops the constructor standings becomes the constructors' champion.

<h3>Architecture diagram</h3>

<img src="https://github.com/jaykay04/Formula1_Big_Data_Project_Using_Azure_Databricks/blob/main/Images/solution%20architecture.png">

# ER Diagram:

The structure of the database is shown in the following ER Diagram and explained in the [Database User Guide](http://ergast.com/docs/f1db_user_guide.txt)
![ERDiagram](http://ergast.com/images/ergast_db.png)

## How it works:
<h3>Source Date Files</h3>
We are referring to open-source data from the website Ergast Developer API. Data was available from 1950 till 2022.

| File Name  | File Type |
| ------------- | ------------- |
| Circuits  | CSV  |
| Races | CSV |
| Constructors  | Single Line JSON  |
| Drivers | Single Line Nested JSON |
| Results  | Single Line JSON  |
| PitStops | Multi Line JSON |
| LapTimes  | Split CSV Files  |
| Qualifying | Split Multi Line JSON Files | 

#### Execution Overview:
- Azure Data Factory (ADF) is responsible for the execution of Azure Datarbicks notebooks as well as monitoring them. We import data from Ergast API to Azure Data Lake Storage Gen2 (ADLS). The raw data is stored in the container at **Bronze zone** (landing zone).
- Data in the Bronze zone is ingested using Azure Databricks notebook. The data is transformed into delta tables using upsert functionality. ADF then uploads the data to ADLS **Silver zone** (standardization zone). 
- Ingested data in **Silver zone** is transformed using Azure Databricks SQL notebook. Tables are joined and aggregated for analytical and visualization purposes. The output is loaded to the **Gold zone** (analytical zone).

#### ETL pipeline:
ETL flow comprises two parts:
- Ingestion: Process data from **Bronze zone** to **Silver zone**
- Transformation: Process data from **Silver zone** to **Gold zone**

In the first pipeline, data stored in JSON and CSV format is read using Apache Spark with minimal transformation saved into a delta table. The transformation includes dropping columns, renaming headers, applying schema, and adding audited columns (```ingestion_date``` and ```file_source```) and ```file_date``` as the notebook parameter. This serves as a dynamic expression in ADF.

In the second pipeline, Databricks SQL reads preprocessed delta files and transforms them into the final dimensional model tables in delta format. Transformations performed include dropping duplicates, joining tables using join, and aggregating using a window.

ADF is scheduled to run every Sunday at 10 PM and is designed to skip the execution if there is no race that week. We have another pipeline to execute the ingestion pipeline and transformation pipeline using file_date as the parameter for the tumbling window trigger.

![Screen Shot 2022-06-12 at 4 42 18 PM](https://user-images.githubusercontent.com/107358349/173252855-6a50be95-d7a7-481c-9438-8ae9fdc7df28.png)

## Azure Resources Used for this Project:
* Azure Data Lake Storage
* Azure Data Factory
* Azure Databricks
* Azure Key Vault

## Project Requirements:
The requirements for this project are broken down into six different parts which are

#### 1. Data Ingestion Requirements
* Ingest all 8 files into Azure data lake. 
* Ingested data must have the same schema applied.
* Ingested data must have audit columns.
* Ingested data must be stored in  columnar format (i.e. parquet).
* We must be able to analyze the ingested data via SQL.
* Ingestion Logic must be able to handle the incremental load.

#### 2. Data Transformation Requirements
* Join the key information required for reporting to create a new table.
* Join the key information required for analysis to create a new table.
* Transformed tables must have audit columns.
* We must be able to analyze the transformed data via SQL.
* Transformed data must be stored in columnar format (i.e. parquet).
* Transformation logic must be able to handle the incremental load.

#### 3. Data Reporting Requirements
* We want to be able to know Driver Standings.
* We should be able to know Constructor Standings as well.

#### 4. Data Analysis Requirements
* Find the Dominant drivers.
* Find the Dominant Teams. 
* Visualize the Outputs.
* Create Databricks dashboards.

#### 5. Scheduling Requirements
* Scheduled to run every Sunday at 10 pm.
* Ability to monitor pipelines.
* Ability to rerun failed pipelines.
* Ability to set up alerts on failures

#### 6. Other Non-Functional Requirements
* Ability to delete individual records
* Ability to see history and time travel
* Ability to roll back to a previous version

## Analysis Result:
![image](https://user-images.githubusercontent.com/64007718/235310453-95b6d253-aaab-454b-87f1-8fb722600014.png)
![image](https://user-images.githubusercontent.com/64007718/235310459-c9141816-2832-4be7-8902-3fce7096c88d.png)
![image](https://user-images.githubusercontent.com/64007718/235310466-4a83e4ce-00c3-444c-b22a-83ad42530321.png)
![image](https://user-images.githubusercontent.com/64007718/235310470-9c966e29-ba76-4c10-9554-f201d72ee636.png)
![image](https://user-images.githubusercontent.com/64007718/235310476-98db1649-0fb4-45f5-bfc4-8892afc8bc80.png)
![image](https://user-images.githubusercontent.com/64007718/235310486-98404d97-ed11-4be2-90c3-535f538cfdc9.png)

## Tasks performed:
•	Built a solution architecture for a data engineering solution using Azure Databricks, Azure Data Lake Gen2, Azure Data Factory, and Power BI.

•	Created and used Azure Databricks service and the architecture of Databricks within Azure.

•	Worked with Databricks notebooks and used Databricks utilities, magic commands, etc.

•	Passed parameters between notebooks as well as created notebook workflows.

•	Created, configured, and monitored Databricks clusters, cluster pools, and jobs.

•	Mounted Azure Storage in Databricks using secrets stored in Azure Key Vault.

•	Worked with Databricks Tables, Databricks File System (DBFS), etc.

•	Used Delta Lake to implement a solution using Lakehouse architecture.

•	Created dashboards to visualize the outputs.

•	Connected to the Azure Databricks tables from PowerBI.

## Spark (Only PySpark and SQL)
•	Spark architecture, Data Sources API, and Dataframe API.

•	PySpark - Ingested CSV, simple, and complex JSON files into the data lake as parquet files/ tables.

•	PySpark - Transformations such as Filter, Join, Simple Aggregations, GroupBy, Window functions etc.

•	PySpark - Created global and temporary views.

•	Spark SQL - Created databases, tables, and views.

•	Spark SQL - Transformations such as Filter, Join, Simple Aggregations, GroupBy, Window functions etc.

•	Spark SQL - Created local and temporary views.

•	Implemented full refresh and incremental load patterns using partitions.

## Delta Lake
•	Performed Read, Write, Update, Delete, and Merge to delta lake using both PySpark as well as SQL.

•	History, Time Travel, and Vacuum.

•	Converted Parquet files to Delta files.

•	Implemented incremental load pattern using delta lake.

## Azure Data Factory
•	Created pipelines to execute Databricks notebooks.

•	Designed robust pipelines to deal with unexpected scenarios such as missing files.

•	Created dependencies between activities as well as pipelines.

•	Scheduled the pipelines using data factory triggers to execute at regular intervals.

•	Monitored the triggers/ pipelines to check for errors/ outputs.

# About the Project:

<h3>Folders:</h3>

- 1-Authentication: The folder contains all notebooks to demonstrate different ways to access Azure Data Lake Gen2 containers into the Databricks file system.

- 2-includes: The folder contains notebooks with common functions and path configurations.

- 3-Data Ingestion: The folder contains all notebooks to ingest the data from raw to processed.

- 4-raw: The folder contains all notebooks to create raw tables in SQL.

- 5-Data Transformation: The folder contains all notebooks that transform the raw data into the processed layer.

- 6-Data Analysis: The folder contains all notebooks which include an analysis of the data.

- 7-demo: The folder contains notebooks with all the pre-requisite demos.

- 8-Power Bi reports: This folder contains all the reports created from the analyzed data.

<h3>Technologies/Tools Used:</h3>
<ul>
  <li>Pyspark</li> 
  <li>Spark SQL</li> 
  <li>Delta Lake</li> 
  <li>Azure Databricks </li> 
  <li>Azure Data Factory</li> 
  <li>Azure Date Lake Storage Gen2</li> 
  <li>Azure Key Fault</li> 
  <li>Power BI</li> 
</ul>  
