# SonicStream Digital Media Analysis Project

This is an end-to-end portfolio data analysis project demonstrating my proficiency in Excel, SQL, and PowerBI.

## Table of Contents

- [SonicStream Digital Media Analysis Project](#sonicstream-digital-media-analysis-project)
  - [Table of Contents](#table-of-contents)
  - [Workplace Scenario](#workplace-scenario)
  - [Deliverables](#deliverables)
    - [Statement of the Business Task](#statement-of-the-business-task)
    - [Description of Data Sources](#description-of-data-sources)
      - [Dataset Assessment](#dataset-assessment)
    - [Documentation of Data Preparation](#documentation-of-data-preparation)
    - [Documentation of Data Exploration](#documentation-of-data-exploration)
    - [Analysis Report](#analysis-report)
    - [Dashboard (Visualizations)](#dashboard-visualizations)
    - [Summary of Insights](#summary-of-insights)
      - [Sales Performance](#sales-performance)
      - [Time-based Analysis](#time-based-analysis)
      - [Operational Efficiency](#operational-efficiency)
      - [Geographic Insights](#geographic-insights)
      - [Customer Behavior](#customer-behavior)
      - [Employee Performance](#employee-performance)
    - [Recommendations](#recommendations)

## Workplace Scenario

I am Keiran Seth, a junior data analyst in _SonicStream Digital_, a digital music store platform assigned with the task of delivering a detailed analysis report covering sales performance, geographic insights, customer behavior, employee performance, operational efficiency, and time-based analysis. I am given the [in-house database](https://github.com/lerocha/chinook-database) as a basis for my report.

See the [detailed overview](./workplace_scenario_overview/overview.md).

## Deliverables

### Statement of the Business Task

The objective of this report is three-pronged:

1. Help the Marketing and Product Strategy team increase sales finding trends and niches.
2. Help the Human Resources team conduct performance reviews on the current customer representatives.
3. Help the Sales team understand the current customer base.

The goal of the analytics team is to deliver a comprehensive report on:

-   Sales performance,
-   Geographic insights,
-   Customer behavior,
-   Employee performance,
-   Operational efficiency, and
-   Time-based analysis.

### Description of Data Sources

The analytics team will use SonicStream's in-house [database](https://github.com/lerocha/chinook-database), which contains all information in their digital media store. These include not just information about artists, albums, tracks, but also the information on invoices, customers, and employees.

See the entity-relationship diagram below.

![alt text](./images/299867754-cea7a05a-5c36-40cd-84c7-488307a123f4.png)

#### Dataset Assessment

-   **Reliable** - SonicStream benefits from keeping their records correct and secure.
-   **Original** - SonicStream owns this database.
-   **Comprehensive** - The dataset includes information about sales, customers, employees, and information on artists, albums, tracks, genres, and media types.
-   **Current** - The current state of the dataset includes records from 2021 up to the present.
-   **Cited** - This dataset is private property of SonicStream, and thus not publicly cited.

### Documentation of Data Preparation

See [Documentation of Data Preparation](./preparation/documentation_of_data_preparation.md).

### Documentation of Data Exploration

See the exploratory data analysis reports by category:

-   [Sales Performance](./exploration/sales_performance.md)
-   [Time-Based Analysis](./exploration/time-based_analysis.md)
-   [Operation Efficiency](./exploration/operational_efficiency.md)
-   [Customer Behavior](./exploration/customer_behavior.md)
-   [Employee Performance](./exploration/employees_and_operations.md)
-   [Geographic Insights](./exploration/geographic_insights.md)

### Analysis Report

### Dashboard (Visualizations)

See the [interactive visuals](https://app.powerbi.com/view?r=eyJrIjoiMzg1ODc0YjUtNDgwMC00YjY1LWJiOTEtYjNiZTdiNmQ4MTllIiwidCI6ImJkMDNhNzM1LTJhYTMtNGNjYS05NzIyLTJhZTQ5MjlhYjNlYyIsImMiOjEwfQ%3D%3D).

<iframe title="chinook" width="600" height="373.5" src="https://app.powerbi.com/view?r=eyJrIjoiMzg1ODc0YjUtNDgwMC00YjY1LWJiOTEtYjNiZTdiNmQ4MTllIiwidCI6ImJkMDNhNzM1LTJhYTMtNGNjYS05NzIyLTJhZTQ5MjlhYjNlYyIsImMiOjEwfQ%3D%3D" frameborder="0" allowFullScreen="true"></iframe>

### Summary of Insights

These are the insights summarized from the analysis report.

#### Sales Performance

1. SonicStream earned $2,328.60 after making a total of 412 unique invoices and a total of 2,240 sales.
2. In volume of sales and revenue, the top 4 genres are: `Rock`, `Latin`, `Metal`, and `Alternative & Punk`.
3. In volume of sales and revenue, the top-selling albums are more varied in genre, which include the less top-selling genres.
    1. To increase volume of sales and generate more revenue, SonicStream should consider selling IPs under `TV shows`, `Comedy`, `Drama`, and `Sci Fi & Fantasy`, just to name a few.
4. In volume of sales and revenue, the top-selling albums also reflect the top-selling genres. However, in terms of revenue, some entries include `TV shows`.

#### Time-based Analysis

1.  There is no significant variation in volume of sales and revenue yearly.
2.  There is no significant variation in volume of sales and revenue quarterly.

    1.  In terms of the volume of sales, most quarters passed the quarterly average number of sales.
    2.  In terms of the revenue, only five quarters passed the quarterly average revenue.

3.  There is no significant variation in volume of sales.
4.  There are clusters of months where the revenue passed the average monthly revenue. These spikes seem to reflect the quarters where the quarter passed the average quarterly revenue.
5.  According to the monthly forecast over the store’s lifetime, **revenue will continue to settle for the next two years**. To spark revenue growth, changes in sales and marketing strategies and efforts in increasing the current customer base are required.
6.  After finding the seasonality index, we find that the first three quarters (`January` to `September`) yield higher revenues than the average.
7.  After finding the seasonality index, we find that the months `January`, `March`, `April`, `June`, `August`, and `September` yield higher revenues than the average, which support insight 5.

#### Operational Efficiency

1. SonicStream sells 5 tracks per invoice on average. The median is 4 tracks per invoice. This implies that SonicStream has more invoices where they sell at most 5 tracks.
2. The typical invoice contains at least 1 to 3 tracks, with 2 tracks being the most common. However, this range can stretch up to 9 or 15 tracks.
3. SonicStream generates an average revenue of $6.00 per invoice, with a median of $3.96. This implies that SonicStream has more invoices where they generate at most $6.00.
4. The typical invoice generates a revenue ranging from $0.99 to $3.19. However, this range can stretch up to $9.79 or $14.19.
5. A typical week for SonicStream sells 11 to 14 tracks and generates $11.53 to $13.86.
6. A typical month for SonicStream sells 37 to 38 tracks and generates $37.62 to $38.81.
7. A typical quarter for SonicStream sells 112 to 114 tracks and generates $112.86 to $116.86.
8. A typical year for SonicStream sells 447 to 448 tracks and generates $465.72 to $469.58.

#### Geographic Insights

1. There are more countries where the number of sales is at most 93.
2. Across the number of sales, the number of invoices, and the revenue generated, the top 11 countries are:
    1. **USA** is at least 50% ahead of the rest of the countries.
    2. **Canada** follows and is at least 50% ahead of the rest of the countries other than USA.
    3. **Brazil**, **France**, **Germany**, and **United Kingdom** follow after Canada, occupying the middle portion of the top 10 randing.
    4. The rest of the countries are **Portugal**, **Czech Republic**, **India**, **Chile**, and **Belgium**.
3. There is a strong positive correlation between the number of customers and the revenue generated by country. Thus as of now, there are _no countries_ which are _either high-revenue and low-sales-volume or low-revenue and high-sales-volume_.

#### Customer Behavior

1. The average and median tracks sold per customer are equal, which is 38 tracks.
2. The average and median revenue generated per customer are close to each other, which are $39.47 and $37.62, respectively.
3. The typical SonicStream customer has an average order value of $1.04 and typically makes 9 to 10 purchases every year.
4. The typical SonicStream customer has a yearly customer value of $10.04.
5. The average and median lifespan of a typical SonicStream customer is around 3 to 4 years.
6. SonicStream's average customer lifetime value is $38.57.

#### Employee Performance

1. The three representatives have assisted 18 to 21 unique customers. Jane has assisted the most, but Margaret and Steve are not too far behind.
2. The customer coverage ratio is mostly equal across the three representatives, where each of them cover around 33% of the customer base.
3. Jane faciliated the highest number of sales, with Margaret and Steve not falling behind.
4. Jane generated the highest revenue, with Margaret and Steve not falling behind.
5. After viewing the yearly trend of the volume of sales, we find that:
    1. The volume of sales facilitated by Margaret is increasing from starting from 2024.
    2. The volume of sales facilitated by Jane peaked in 2022 but seems to settle lower from 2023 onwards.
    3. The volume of sales facilitated by Steve peaked at the starting year, 2021, and in 2023. However, it settles lower in other years.
6. After viewing the yearly trend of the revenue, we find that:
    1. The revenue generated by Margaret is increasing from starting from 2024.
    2. The revenue generated by Jane peaked in 2022 but seems to settle lower from 2023 onwards.
    3. The revenue generated by Steve peaked at the starting year, 2021, and in 2023. However, it settles lower in other years.

### Recommendations

One crucial insight gained from this analysis report is that **SonicStream, as it is in the present, will observe the revenue stagnate for the next two years**, according to the monthly forecast. Because of this, it is essential for SonicStream to **discuss strategies and plans for increasing sales activity**.

1. Continue stocking up on tracks which fall under the top 10 genres, especially `Rock`, `Latin`, `Metal`, and `Alternative & Punk`.
2. Consider catering to niche genres and perhaps expand on TV and films. To increase volume of sales and generate more revenue, SonicStream should consider selling IPs under `TV shows`, `Comedy`, `Drama`, and `Sci Fi & Fantasy`, just to name a few.
3. Maintain performance for the first 3 quarters. However, address lower sales volume and revenue in the fourth quarter by considering special promotional sales events, especially around Halloween and Christmas.
4. Since our typical invoices contain 1 to 3 tracks, let us consider bundling options to increase the number of tracks sold per invoice.
5. The top-selling countries are in North America, Europe, and South America. We can focus our efforts in increasing our customer base for these continents.
6. The performance review with the representatives should involve asking them their sales strategies during their high-sales-volume and high-revenue months and quarters.
