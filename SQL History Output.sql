sudo -u postgres psql
psql (16.8 (Ubuntu 16.8-0ubuntu0.24.04.1))
Type "help" for help.

postgres=# CREATE DATABASE todo_db;
CREATE DATABASE
postgres=# CREATE USER vmadmin WITH PASSWORD 'sqlpasswd@123';
CREATE ROLE
postgres=# GRANT ALL PRIVILEGES ON DATABASE todo_db TO vmadmin;
GRANT
postgres=# \c todo_db

todo_db=# CREATE TABLE todo (
    id SERIAL PRIMARY KEY,
    task TEXT NOT NULL
);
CREATE TABLE


INSERT INTO todo (id, task)
VALUES (1, 'test task 001');


vmadmin@VM2:~$ sudo ufw allow 5432/tcp
vmadmin@VM2:~$ sudo systemctl restart postgresql
vmadmin@VM2:~$ sudo systemctl status ufw


vmadmin@VM2:~$ sudo -u postgres psql
psql (16.8 (Ubuntu 16.8-0ubuntu0.24.04.1))
Type "help" for help.

postgres=# SELECT version();
postgres=# \l


postgres=# \l
                                                   List of databases
   Name    |  Owner   | Encoding | Locale Provider | Collate |  Ctype  | ICU Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+---------+---------+------------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           |
 template0 | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =c/postgres          +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres
 todo_db   | postgres | UTF8     | libc            | C.UTF-8 | C.UTF-8 |            |           | =Tc/postgres         +
           |          |          |                 |         |         |            |           | postgres=CTc/postgres+
           |          |          |                 |         |         |            |           | vmadmin=CTc/postgres
(4 rows)


postgres=# \c todo_db
You are now connected to database "todo_db" as user "postgres".

todo_db=# \dt
        List of relations
 Schema | Name | Type  |  Owner
--------+------+-------+----------
 public | todo | table | postgres
(1 row)

todo_db=# SELECT * FROM todo ;
 id | task
----+------
(0 rows)

todo_db=# \q


vmadmin@VM2:~$ sudo -u postgres psql
psql (16.8 (Ubuntu 16.8-0ubuntu0.24.04.1))
Type "help" for help.

postgres=# SELECT datname FROM pg_database;
  datname
-----------
 postgres
 template1
 template0
 todo_db
(4 rows)

postgres=# \c todo_db
You are now connected to database "todo_db" as user "postgres".
todo_db=# SELECT table_schema || '.' || table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema');
  ?column?
-------------
 public.todo
(1 row)




