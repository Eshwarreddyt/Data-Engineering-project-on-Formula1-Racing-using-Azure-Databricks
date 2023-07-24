-- Databricks notebook source
CREATE DATABASE IF NOT EXISTS f1_processed
LOCATION "abfss://processed@erformula1dl.dfs.core.windows.net/"

-- COMMAND ----------

DESC DATABASE f1_processed;

-- COMMAND ----------

