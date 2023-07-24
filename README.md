# Formula1-Data-Engineering-Project-Using-Azure-Databricks

This Project showcases the purpose of building a Cloud data platform for reporting and analysis of Formula1 Motor Sport data using Azure Databricks.

## Architecture diagram
![Untitled drawio (1)](https://user-images.githubusercontent.com/107358349/173245389-06a3bed0-573c-4139-b451-0966055d464b.png)

# ER Diagram

The structure of the database is shown in the following ER Diagram and explained in the [Database User Guide](http://ergast.com/docs/f1db_user_guide.txt)
![ERDiagram](http://ergast.com/images/ergast_db.png)

## How it works

#### Overview

- Azure Data Factory (ADF) is responsible for the execution of Azure Datarbicks notebooks as well as monitoring them. We import data from Ergast API to Azure Data Lake Storage Gen2 (ADLS). The raw data is stored in the container at **Bronze zone** (landing zone).
- Data in Bronze zone is ingested using Azure Databricks notebook. The data is transformed into delta tables using upsert functionality. ADF then uploads the data to ADLS **Silver zone** (standardization zone). 
- Ingested data in **Silver zone** is transformed using Azure Databricks SQL notebook. Tables are joined and aggregated for analytical and visualization purposes. The output is loaded to **Gold zone** (analytical zone).

#### ETL pipeline

ETL flow comprises two parts:
- Ingestion: Process data from **Bronze zone** to **Silver zone**
- Transformation: Process data from **Silver zone** to **Gold zone**

In the first pipeline, data stored in json and csv format is read using Apache Spark with minimal transformation saved into delta table. The transformation includes dropping columns, renaming headers, applying schema and adding audited columns (```ingestion_date``` and ```file_source```) and ```file_date``` as the notebook parameter. This serves as a dynamic expression in ADF.

In the second pipeline, Databricks SQL reads preprocessed delta files and transforms them into the final dimensional model tables in delta format. Transformations performed include dropping duplicates, joining tables using join, and aggregating using window.

ADF is scheduled to run every Sunday at 10 PM and is designed to skip the execution if there is no race that week. We have another pipeline to execute the ingestion pipeline and transformation pipeline using file_date as the parameter for the tumbling window trigger.

![Screen Shot 2022-06-12 at 4 42 18 PM](https://user-images.githubusercontent.com/107358349/173252855-6a50be95-d7a7-481c-9438-8ae9fdc7df28.png)

#### Example runtime

- Creating a dimensional model from scratch using data from Mar 22 to Mar 28, 2021.
- Driver: Single node Standard_D4d_v4.
- Configuration: managed by Databricks.

| Step| Runtime|
|--|--|
|Execute Ingestion		|~10 min|	
|Execute Transformation		|~5 min|

## How to run the project

#### Prerequisites
1. Download the source data from [Ergast API](http://ergast.com/mrd/).
3. Create ADLS account and connect to Azure Databricks by Service Principal.
4. Install Azure Storage Explorer. Create new containers in Azure Blob Storage for bronze, silver and gold layers.
5. Set up Azure Data Factory account and create Linked Service to ADLS and Azure Databricks.

ETL is run by Azure Databricks and executed by Data Factory.
1. Import notebooks to Databricks and run interactively [`etl_notebooks`](https://github.com/fionangq/databricks-Formula1-project/tree/main/etl_notebooks/).
2. Import existing Data Factory resources to repository.
3. Debug ADF pipelines.

### Azure Resources Used for this Project
* Azure Data Lake Storage
* Azure Data Factory
* Azure Databricks
* Azure Key Vault

### Project Requirements
The requirements for this project is broken down into six different parts which are;

#### 1. Data Ingestion Requirements
* Ingest all 8 files into Azure data lake. 
* Ingested data must have the same schema applied.
* Ingested data must have audit columns.
* Ingested data must be stored in  columnar format (i.e parquet).
* We must be able to analyze the ingested data via SQL.
* Ingestion Logic must be able to handle incremental load.

#### 2. Data Transformation Requirements
* Join the key information required for reporting to create a new table.
* Join the key information required for analysis to create a new table.
* Transformed tables must have audit columns.
* We must be able to analyze the transformed data via SQL.
* Transformed data must be stored in columnar format (i.e parquet).
* Transformation logic must be able to handle incremental load.

#### 3. Data Reporting Requirements
* We want to be able to know Driver Standings.
* We should be able to know Constructor Standings as well.

#### 4. Data Analysis Requirements
* We want to know the Dominant drivers.
* Dominant Teams. 
* Visualize the Outputs.
* Create Databricks dashboards.

#### 5. Scheduling Requirements
* Scheduled to run every sunday at 10pm.
* Ability to monitor pipelines.
* Ability to rerun failed pipelines.
* Ability to set up alerts on failures

#### 6. Other Non-Functional Requirements
* Ability to delete individual records
* Ability to see history and time travel
* Ability to roll back to a previous version
