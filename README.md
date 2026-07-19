# Olist E-Commerce Power BI Dashboard

## Overview

This project is an end-to-end Business Intelligence analysis built on the **Olist Brazilian E-Commerce Public Dataset**. The objective is to transform raw transactional data into meaningful business insights through SQL analysis, data modeling, DAX measures, and interactive Power BI dashboards.

The project covers the complete BI workflow, from database creation and profiling to dashboard development.

---

## Objectives

The dashboard was designed to answer key business questions regarding:

- Overall business performance
- Customer behavior and loyalty
- Product and category performance
- Delivery efficiency and customer satisfaction

---

## Project Workflow

1. Imported the original Olist CSV files into **SQLite** using DBeaver.
2. Performed **database profiling** through SQL queries.
3. Built a relational data model in **Power BI**.
4. Created custom **DAX measures** for KPIs and business metrics.
5. Developed interactive dashboards to support business analysis.

---

## Dashboard Pages

### Executive Overview
Provides a high-level summary of the business, including:
- Total Revenue
- Total Orders
- Total Customers
- Average Review Score
- Revenue by Month
- Revenue by State
- Payment Type Distribution

### Customer Analysis
Focuses on customer behavior:
- Customers by State
- Repeat Customers
- Repurchase Rate
- Orders per Customer Distribution
- New vs Returning Customers

### Product Performance
Analyzes product and category performance:
- Products Sold
- Average Product Price
- Revenue by Category
- Average Product Price by Category
- Category Performance Matrix (Revenue vs Review Score)

### Logistics Analysis
Evaluates delivery performance:
- Average Delivery Time
- Average Delivery Delay
- Percentage of Delayed Deliveries
- Delivery Time Trend
- Delivery Time by State
- Review Comparison (On-Time vs Delayed Deliveries)

---

## Technologies Used

- Power BI
- DAX
- SQL
- SQLite
- DBeaver

---

## Repository Structure

```text
data/
    Dataset information

images/
    Dashboard screenshots

powerbi/
    Power BI project (.pbix)

sql/
    SQL queries used for database profiling and analysis
```

---

## Dataset

The project uses the **Olist Brazilian E-Commerce Public Dataset**, publicly available on Kaggle.

The original CSV files are **not included** in this repository.

Dataset:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

## Skills Demonstrated

- SQL querying and database profiling
- Relational database modeling
- Data cleaning and preparation
- Power BI data modeling
- DAX measure development
- Business Intelligence dashboard design
- Data visualization and storytelling

---

## Author

**Antonio Saccani**

Master's Degree in Analytics and Data Science for Economics and Management  
University of Brescia
