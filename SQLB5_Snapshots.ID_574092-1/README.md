## _Snapshots, virtual tables… What is going on?_

In this project you will learn how to create and use views to filter data, generate time ranges, identify missing dates, work with set operations, calculate discounts, and manage materialized views—including updating and dropping them.

These skills are essential for data analytics (reporting, period comparisons), financial calculations (price analysis), and database optimization (query caching, schema management).


💡 [Tap here](https://new.oprosso.net/p/4cb31ec3f47a4596bc758ea1861fb624) **to leave your feedback on the project**. It's anonymous and will help our team make your educational experience better. We recommend completing the survey immediately after the project.

## Contents

- [How to learn at «School 21»](#how-to-learn-at-school-21)
- [Chapter I](#chapter-i)
- [Preamble](#preamble)
- [Chapter II](#chapter-ii)
- [Rules of the day](#rules-of-the-day)
- [Chapter III](#chapter-iii)
- [Exercise 00 — Let’s create separate views for persons](#exercise-00--lets-create-separate-views-for-persons)
- [Exercise 01 — From parts to common view](#exercise-01--from-parts-to-common-view)
- [Exercise 02 — "Store" generated dates in one place](#exercise-02--store-generated-dates-in-one-place)
- [Exercise 03 — Find missing visit days with Database View](#exercise-03--find-missing-visit-days-with-database-view)
- [Exercise 04 — Let’s find something from Set Theory](#exercise-04--lets-find-something-from-set-theory)
- [Exercise 05 — Let’s calculate a discount price for each person](#exercise-05--lets-calculate-a-discount-price-for-each-person)
- [Exercise 06 — Materialization from virtualization](#exercise-06--materialization-from-virtualization)
- [Exercise 07 — Refresh our state](#exercise-07--refresh-our-state)
- [Exercise 08 — Just clear our database](#exercise-08--just-clear-our-database)



## How to learn at «School 21»
1. «School 21» might feel different from your previous educational experiences. It emphasizes high autonomy: you’re given a task, and you must complete it. Throughout the course, you are expected to delve deeper into the subject and solve problems. Use all available means to find information—the resources of the internet are limitless. Be mindful of your sources (for example, if you use AI tools): verify, think, analyze, and compare.
2. You will need to present your solution to other students and receive feedback from them. Peer-to-peer (P2P) learning is a process where students exchange knowledge and experience, simultaneously acting as both mentors and learners. This way you can learn not only from materials but also from each other.
3. Don’t hesitate to ask for help: around you are peers who are also navigating this path for the first time. Likewise, don’t be afraid to respond to requests for help—your experience is valuable and useful, so share it openly with others. Join RocketChat to stay updated with the latest community announcements.
4. Your learning will be meaningless if you simply copy others’ solutions. If you receive help, always make sure you fully understand the why, how, and purpose behind it. Don’t be afraid to make mistakes.
5. If you’re stuck on something and feel like you’ve tried everything but still don’t know what to do—just take a break! Believe it or not, this advice has helped many professionals in their work. Step away, clear your mind, and the right solution might just come to you next time!
6. The learning process is just as important as the result. It’s not just about solving the task—it’s about understanding how to solve it.

How to work with the project: 
1. Before starting, clone the project from GitLab into a repository of the same name.
2. All code files must be created in the src/ folder of the cloned repository.
3. After cloning, create a develop branch and push changes to it in GitLab. Push to GitLab in the develop branch as well.

## Chapter I
## Preamble

![D04_02](misc/images/D04_02.png)

Why do we need virtual tables and materialized views in databases? Databases are just tables, aren't they? 
No, not really. Databases are similar to object-oriented languages. Just remember, you have a lot of abstraction in Java (we mean Java interfaces). We need abstraction to achieve "clean architecture" and change objects with minimal impact on dependencies (sometimes it works :-).

Moreover, there is a specific architecture pattern in the Relational Database called ANSI/SPARK.
This pattern divides objects into three levels: 
- external level,
- conceptual level,
- internal level.

Therefore, we can say that Virtual Tables and Materialized Views are physical interfaces between tables with data and user/application.
So, what is the difference between 2 objects? The main difference is the "freshness" of the data. Below you can see the behavior of these objects in graphical representation.

|  |  |
| ------ | ------ |
| View is a continuous object with the same data like in the underlying table(s), that are used to create this view. Other words, if we select data from view, view reroutes our query to underlying objects and then returns results for us. | ![D04_03](misc/images/D04_03.png) |
| ![D04_04](misc/images/D04_04.png) | Materialized View is a discrete object. Other words, we need to wait when the Materialized View will be refreshed based on an “event trigger” (for example, time schedule). This object always is behind actual data in underlying tables. |

There are also "a few" additional differences between View and Materialized View.
- Virtual Table can work with `INSERT/UPDATE/DELETE` traffic, but with some restrictions. 
- Virtual Tables can have “Instead Of” Triggers to make a better control of incoming `INSERT/UPDATE/DELETE` traffic.
- Materialized View is ReadOnly object for `INSERT/UPDATE/DELETE` traffic.
- Materialized Views can have user defined indexes on columns to speed up queries.


## Chapter II
## Rules of the day

- Make sure you are using the latest version of PostgreSQL.
- It is perfectly fine if you use the IDE to write source code (aka SQL script).
- You should not leave any files in your directory other than those explicitly specified by the exercise instructions. It is recommended that you modify your `.gitignore' to avoid accidents. 
- Please download a [script](materials/model.sql) with Database Model here and apply the script to your database (you can use command line with psql or just run it through any IDE, for example DataGrip from JetBrains or pgAdmin from PostgreSQL community). **Our knowledge way is incremental and linear therefore please be aware all changes that you made in SQLB4_DML (Day03) during exercises 07-13 should be on place (its similar like in real world , when we applied a release and need to be consistency with data for new changes).**
- All tasks contain a list of Allowed and Denied sections with listed database options, database types, SQL constructions etc. Please have a look at the section before you start.
- And may the SQL-Force be with you!
- Absolutely anything can be represented in SQL! Let's get started and have fun!

Please take a look at the Logical View of our Database Model. 

![schema](misc/images/schema.png)


1. **pizzeria** table (Dictionary Table with available pizzerias)
- field id — primary key
- field name — name of pizzeria
- field rating — average rating of pizzeria (from 0 to 5 points)
2. **person** table (Dictionary Table with persons who loves pizza)
- field id — primary key
- field name — name of person
- field age — age of person
- field gender — gender of person
- field address — address of person
3. **menu** table (Dictionary Table with available menu and price for concrete pizza)
- field id — primary key
- field pizzeria_id — foreign key to pizzeria
- field pizza_name — name of pizza in pizzeria
- field price — price of concrete pizza
4. **person_visits** table (Operational Table with information about visits of pizzeria)
- field id — primary key
- field person_id — foreign key to person
- field pizzeria_id — foreign key to pizzeria
- field visit_date — date (for example 2022-01-01) of person visit 
5. **person_order** table (Operational Table with information about persons orders)
- field id — primary key
- field person_id — foreign key to person
- field menu_id — foreign key to menu
- field order_date — date (for example 2022-01-01) of person order 

People's visit and people's order are different entities and don't contain any correlation between data. For example, a customer can be in a restaurant (just looking at the menu) and in that time place an order in another restaurant by phone or mobile application. Or another case, just be at home and again make a call with order without any visits.

## Chapter III
## Exercise 00 — Let’s create separate views for persons

| Exercise 00: Let’s create separated views for persons |                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex00                                                                                                                     |
| Files to turn-in                      | `day04_ex00.sql`                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        | ANSI SQL                                                                                              |

Please create 2 Database Views (with similar attributes as the original table) based on a simple filtering by gender of persons. Set the corresponding names for the database views: `v_persons_female` and `v_persons_male`.

## Exercise 01 — From parts to common view

| Exercise 01: From parts to common view|                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex01                                                                                                                     |
| Files to turn-in                      | `day04_ex01.sql`                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        | ANSI SQL                                                                                              |

Please use 2 Database Views from Exercise #00 and write SQL to get female and male person names in one list. Please specify the order by person name. The sample data is shown below.

| name |
| ------ |
| Andrey |
| Anna |
| ... |


## Exercise 02 — "Store" generated dates in one place

| Exercise 02: "Store" generated dates in one place|                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex02                                                                                                                     |
| Files to turn-in                      | `day04_ex02.sql`                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        | ANSI SQL                                                                                              |
| SQL Syntax Construction                        | `generate_series(...)`                                                                                              |

Please create a Database View (with name `v_generated_dates`) which should "store" generated dates from January 1st to January 31st, 2022 in type DATE. Don't forget the order of the generated_date column.

| generated_date |
| ------ |
| 2022-01-01 |
| 2022-01-02 |
| ... |


## Exercise 03 — Find missing visit days with Database View

| Exercise 03: Find missing visit days with Database View |                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex03                                                                                                                     |
| Files to turn-in                      | `day04_ex03.sql`                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        | ANSI SQL                                                                                              |


Write a SQL statement that returns missing days for people's visits in January 2022. Use the `v_generated_dates` view for this task and sort the result by the missing_date column. The sample data is shown below.

| missing_date |
| ------ |
| 2022-01-11 |
| 2022-01-12 |
| ... |

## Exercise 04 — Let’s find something from Set Theory


| Exercise 04: Let’s find something from Set Theory |                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex04                                                                                                                     |
| Files to turn-in                      | `day04_ex04.sql`                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        | ANSI SQL                                                                                              |

Write an SQL statement that satisfies the formula `(R - S)∪(S - R)` .
Where R is the `person_visits` table with a filter on January 2, 2022, S is also the `person_visits` table but with a different filter on January 6, 2022. Please do your calculations with sets under the `person_id` column and this column will be alone in a result. Please sort the result by the `person_id` column and present your final SQL in the `v_symmetric_union` (*) database view.

(*) To be honest, the definition of "symmetric union" doesn't exist in set theory. This is the author's interpretation, the main idea is based on the existing rule of symmetric difference.



## Exercise 05 — Let’s calculate a discount price for each person


| Exercise 05: Let’s calculate a discount price for each person |                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex05                                                                                                                     |
| Files to turn-in                      | `day04_ex05.sql`                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        | ANSI SQL                                                                                              |

Please create a Database View `v_price_with_discount` that returns the orders of a person with person name, pizza name, real price and calculated column `discount_price` (with applied 10% discount and satisfying formula `price - price*0.1`). Please sort the result by person names and pizza names and convert the `discount_price` column to integer type. See a sample result below.


| name |  pizza_name | price | discount_price |
| ------ | ------ | ------ | ------ | 
| Andrey | cheese pizza | 800 | 720 | 
| Andrey | mushroom pizza | 1100 | 990 |
| ... | ... | ... | ... |



## Exercise 06 — Materialization from virtualization


| Exercise 06: Materialization from virtualization |                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex06                                                                                                                     |
| Files to turn-in                      | `day04_ex06.sql`                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        | ANSI SQL                                                                                              |

Please create a Materialized View `mv_dmitriy_visits_and_eats` (with data included) based on the SQL statement that finds the name of the pizzeria where Dmitriy visited on January 8, 2022 and could eat pizzas for less than 800 rubles (this SQL can be found in the Project SQLB3_Retrieving data, Exercise #07). 

To check yourself, you can write SQL to the Materialized View `mv_dmitriy_visits_and_eats` and compare the results with your previous query.


## Exercise 07 — Refresh our state


| Exercise 07: Refresh our state|                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex07                                                                                                                     |
| Files to turn-in                      | `day04_ex07.sql`                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        | ANSI SQL                                                                                              |
| **Denied**                               |                                                                                                                          |
| SQL Syntax Pattern                        | Don’t use direct numbers for identifiers of Primary Key, person and pizzeria                                                                                               |

Let's refresh the data in our Materialized View `mv_dmitriy_visits_and_eats` from Exercise #06. Before this action, please create another Dmitriy visit that satisfies the SQL clause of the Materialized View except pizzeria, which we can see in a result from Exercise #06.
After adding a new visit, please update a data state for `mv_dmitriy_visits_and_eats`.


## Exercise 08 — Just clear our database


| Exercise 08: Just clear our database |                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex08                                                                                                                     |
| Files to turn-in                      | `day04_ex08.sql`                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        | ANSI SQL                                                                                              |           

After all our exercises, we have a couple of Virtual Tables and a Materialized View. Let's drop them!


