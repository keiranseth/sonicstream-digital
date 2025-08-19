# Documentation of Data Preparation

> Download `Chinook_PostgreSql.sql` from the [dataset source](https://github.com/lerocha/chinook-database).

The overwhelming majority of the work is already done by the Database Administration team, and thus the data preparation on our end as the analytics team is super brief.

## Preparing Data for pgAdmin 4 (PostgreSQL 17)

1. Download the database (as a `.sql` script) emailed to us from the Database Administration team.
2. In pgAdmin 4, create a database entitled `chinook` on the `PostgreSQL 17` server.
3. Import all data from `.sql` script with the `Restore...` command. Make sure that the `Format` is set to `Plain`.

## Preparing Data for Power BI

In pgAdmin 4, export each table in the `chinook` database as a `.csv` file and save in a folder.

1. Open the PostgreSQL 17 server in pgAdmin 4
2. Right-click on each table and select `Import/Export Data...`.
3. Make sure that the `Export` option is selected.
4. In the General tab, set Format to `csv` and Encoding to `UTF-8`.
5. In the Options tab, select Header.
6. Title the `.csv` file with the same name as the database table.

In Power BI, create a blank report and, one by one, import each `.csv` file.

1. Open Power BI Deskptop.
2. Click `Text/CSV` in Get Data.
3. To make sure that the database table is imported smoothly, check the automatic data transformation process in Power Query by clicking Transform.
4. Power BI should automatically join the tables with the correct keys. If it does not work, refer to the ERD to manually join the tables.
5. Name the report `chinook` and save the report.
