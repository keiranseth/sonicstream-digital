# Documentation of Data Preparation

> Download `Chinook_PostgreSql.sql` from the [dataset source](https://github.com/lerocha/chinook-database).

The overwhelming majority of the work is already done by the Database Administration team, and thus the data preparation on our part is super brief.

1. Download the database emailed to us from the Database Administration team.
2. In pgAdmin 4, create a database entitled `chinook` on the `PostgreSQL 17` server.
3. Import all data from `Chinook_PostgreSql.sql` with the `Restore...` command. Make sure that the `Format` is set to `Plain`.
