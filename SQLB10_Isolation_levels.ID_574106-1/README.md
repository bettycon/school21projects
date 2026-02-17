
## _Isolation is one of ACID properties_

In this project you will gain practical experience with transactions and isolation levels in PostgreSQL: you will reproduce classic data anomalies (Lost Update, Dirty Reads, etc.), analyze deadlock mechanisms, and learn to manage data consistency in concurrent processes.

These skills are critical for designing high-load applications where data integrity must be guaranteed under concurrent access—such as in financial systems, booking platforms, or inventory management.

💡 [Tap here](https://new.oprosso.net/p/4cb31ec3f47a4596bc758ea1861fb624) **to leave your feedback on the project**. It's anonymous and will help our team make your educational experience better. We recommend completing the survey immediately after the project.

## Contents

- [How to learn at «School 21»](#how-to-learn-at-school-21)
- [Chapter I](#chapter-i)
- [Preamble](#preamble)
- [Chapter II](#chapter-ii)
- [Rules of the day](#rules-of-the-day)
- [Chapter III](#chapter-iii)
- [Exercise 00 — Simple transaction](#exercise-00--simple-transaction)
- [Exercise 01 — Lost Update Anomaly](#exercise-01--lost-update-anomaly)
- [Exercise 02 — Lost Update for Repeatable Read](#exercise-02--lost-update-for-repeatable-read)
- [Exercise 03 — Non-Repeatable Reads Anomaly](#exercise-03--non-repeatable-reads-anomaly)
- [Exercise 04 — Non-Repeatable Reads for Serialization](#exercise-04--non-repeatable-reads-for-serialization)
- [Exercise 05 — Phantom Reads Anomaly](#exercise-05--phantom-reads-anomaly)
- [Exercise 06 — Phantom Reads for Repeatable Read](#exercise-06--phantom-reads-for-repeatable-read)
- [Exercise 07 — Deadlock](#exercise-07--deadlock)

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

![D08_01](misc/images/D08_01.png)

The Penrose stairs or Penrose steps, also called the impossible staircase, is an impossible object created by Lionel Penrose and his son Roger Penrose. A variation of the Penrose Triangle, it is a two-dimensional representation of a staircase in which the stairs make four 90-degree turns as they ascend or descend, yet form a continuous loop so that a person could climb them forever and never get higher. This is clearly impossible in three dimensions. The "continuous staircase" was first presented in an article written by the Penroses in 1959, based on the so-called "Penrose Triangle" published by Roger Penrose in the British Journal of Psychology in 1958. 

"Penrose Stairs" is a mathematical anomaly, actually database theory has 4 foundametal data anomalies (physical anomalies).
- Lost Update Anomaly;
- Dirty Reads Anomaly;
- Non-repeatable Reads Anomaly;
- Phantom Read Anomaly.

Therefore, there are different isolation levels in ANSI SQL standard that prevent known anomalies.

![D08_02](misc/images/D08_02.png)

From one point of view, this matrix should be a standard for any Relational Database, but reality... looks a bit different.

|  |  | |
| ------ | ------ | ------ |
| PostgreSQL | ![D08_03](misc/images/D08_03.png) |
| Oracle | ![D08_04](misc/images/D08_04.png) |
| MySQL | ![D08_05](misc/images/D08_05.png) |

Nowadays, IT community found a set of new anomalies based on Database Model (logical view):
- Read Skew Anomaly;
- Write Skew Anomaly;
- Serialization Anomaly;
- Fan Traps Anomaly;
- Chasm Traps Anomaly;
- Data Model Loops Anomaly;
- etc.


## Chapter II
## Rules of the day

- Make sure you are using the latest version of PostgreSQL.
- It is perfectly fine if you use the IDE to write source code (aka SQL script).
- You should not leave any files in your directory other than those explicitly specified by the exercise instructions. It is recommended that you modify your `.gitignore' to avoid accidents. 
- Please make sure you have your own database and access to it on your PostgreSQL cluster.
- Please download a [script](materials/model.sql) with Database Model here and apply the script to your database (you can use command line with psql or just run it through any IDE, for example DataGrip from JetBrains or pgAdmin from PostgreSQL community). **Our knowledge way is incremental and linear therefore please be aware that all changes you made in SQLB4_DML (Day 03) during Exercises 07-13 and in SQLB5_Snapshots (Day 04) during Exercise 07 should be on place (its similar like in real world when we applied a release and need to be consistent with data for new changes).**
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
## Exercise 00 — Simple transaction

| Exercise 00: Simple transaction |                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex00                                                                                                                     |
| Files to turn-in                      | `day08_ex00.sql` with comments for Session #1, Session #2 statements; screenshot of psql output for Session #1; screenshot of psql output for Session #2 |
| **Allowed**                               |                                                                                                                          |
| Language                        |  SQL|

You need to use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users. 

Actually, we need two active sessions (i.e. 2 parallel sessions in the command line). 

You need to provide a proof that your parallel session can’t see your changes until you will make a `COMMIT`;

See the steps below.

**Session #1**
- Update of rating for "Pizza Hut" to 5 points in a transaction mode.
- Check that you can see a changes in session #1.

**Session #2**
- Check that you can’t see a changes in session #2.

**Session #1**
- Publish your changes for all parallel sessions.

**Session #2**
- Check that you can see a changes in session #2.


So, take a look on example of our output for Session #2.

    pizza_db=> select * from pizzeria where name  = 'Pizza Hut';
    id |   name    | rating
    ----+-----------+--------
    1 | Pizza Hut |    4.6
    (1 row)

    pizza_db=> select * from pizzeria where name  = 'Pizza Hut';
    id |   name    | rating
    ----+-----------+--------
    1 | Pizza Hut |      5
    (1 row)

You can see that the same query returns different results because the first query was run before publishing in Session#1 and the second query was run after Session#1 was finished.

## Exercise 01 — Lost Update Anomaly

| Exercise 01: Lost Update Anomaly|                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex01                                                                                                                     |
| Files to turn-in                      | `day08_ex01.sql` with comments for Session #1, Session #2 statements; screenshot of psql output for Session #1; screenshot of psql output for Session #2                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        |  SQL                                                                                              |

You need to use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users. 

Actually, we need two active sessions (i.e. 2 parallel sessions in the command line). 

Before running a task, make sure you are at a standard isolation level in your database. Just run the following statement `SHOW TRANSACTION ISOLATION LEVEL;` and the result should be "read committed".

If not, please set the read committed isolation level explicitly on a session level.

| |
|-|
| Let's examine one of the famous "Lost Update Anomaly" database patterns. You can see a graphical representation of this anomaly on a picture. The horizontal red line represents the final results after all the sequential steps for both Sessions. |
| ![D08_06](misc/images/D08_06.png) |

Please check a rating for "Pizza Hut" in a transaction mode for both sessions and then make an `UPDATE` of the rating to a value of 4 in Session #1 and make an `UPDATE` of the rating to a value of 3.6 in Session #2 (in the same order as in the picture).


## Exercise 02 — Lost Update for Repeatable Read

| Exercise 02: Lost Update for Repeatable Read|                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex02                                                                                                                     |
| Files to turn-in                      | `day08_ex02.sql` with comments for Session #1, Session #2 statements; screenshot of psql output for Session #1; screenshot of psql output for Session #2                                                                                  |
| **Allowed**                               |                                                                                                                          |
| Language                        |  SQL                                                                                              |

You need to use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users. 

Actually, we need two active sessions (i.e. 2 parallel sessions in the command line).

| |
|-|
| Let's examine one of the famous "Lost Update Anomaly" database patterns, but under the `REPEATABLE READ` isolation level. You can see a graphical representation of this anomaly on a picture. Horizontal red line means the final results after all sequential steps for both Sessions. |
| ![D08_07](misc/images/D08_07.png) |

You need to check a rating for "Pizza Hut" in a transaction mode for both sessions and then make an `UPDATE` of the rating to a value of 4 in Session #1 and make an `UPDATE` of the rating to a value of 3.6 in Session #2 (in the same order as in the picture).

## Exercise 03 — Non-Repeatable Reads Anomaly

| Exercise 03: Non-Repeatable Reads Anomaly |                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex03                                                                                                                     |
| Files to turn-in                      | `day08_ex03.sql` with comments for Session #1, Session #2 statements; screenshot of psql output for Session #1; screenshot of psql output for Session #2                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        |  SQL                                                                                              |

You need to use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users. 

Actually, we need two active sessions (i.e. 2 parallel sessions in the command line).

| |
|-|
| Let's check one of the famous "Non-Repeatable Reads" database patterns, but under the `READ COMMITTED` isolation level. You can see a graphical representation of this anomaly on a picture. The horizontal red line represents the final result after all sequential steps for both Sessions. |
| ![D08_08](misc/images/D08_08.png) |

You need to check a rating for "Pizza Hut" in a transaction mode for Session #1 and then make an `UPDATE` of the rating to a value of 3.6 in Session #2 (in the same order as in the picture).


## Exercise 04 — Non-Repeatable Reads for Serialization


| Exercise 04: Non-Repeatable Reads for Serialization |                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex04                                                                                                                     |
| Files to turn-in                      | `day08_ex04.sql` with comments for Session #1, Session #2 statements; screenshot of psql output for Session #1; screenshot of psql output for Session #2                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        |  SQL                                                                                              |

You need to use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users. 

Actually, we need two active sessions (i.e. 2 parallel sessions in the command line).

| |
|-|
| Let's check one of the famous "Non-Repeatable Reads" database patterns, but under the `SERIALIZABLE` isolation level. You can see a graphical representation of this anomaly on a picture. The horizontal red line represents the final results after all sequential steps for both Sessions. |
| ![D08_09](misc/images/D08_09.png) |

You need to check a rating for "Pizza Hut" in a transaction mode for Session #1, and then make an `UPDATE` of the rating to a value of 3.0 in Session #2 (in the same order as in the picture).


## Exercise 05 — Phantom Reads Anomaly


| Exercise 05: Phantom Reads Anomaly|                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex05                                                                                                                     |
| Files to turn-in                      | `day08_ex05.sql`  with comments for Session #1, Session #2 statements; screenshot of psql output for Session #1; screenshot of psql output for Session #2                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        |   SQL                                                                                              |

You need to use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users. 

Actually, we need two active sessions (i.e. 2 parallel sessions in the command line).

| |
|-|
| Let's check one of the famous "phantom reads" database patterns, but under the `READ COMMITTED` isolation level. You can see a graphical representation of this anomaly on a picture. The horizontal red line represents the final results after all sequential steps for both Sessions. |
| ![D08_10](misc/images/D08_10.png) |

PYou need to summarize all ratings for all pizzerias in one transaction mode for Session #1 and then make `INSERT` of the new restaurant 'Kazan Pizza' with rating 5 and ID=10 in Session #2 (in the same order as in the picture).
 

## Exercise 06 — Phantom Reads for Repeatable Read


| Exercise 06: Phantom Reads for Repeatable Read|                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex06                                                                                                                     |
| Files to turn-in                      | `day08_ex06.sql`  with comments for Session #1, Session #2 statements; screenshot of psql output for Session #1; screenshot of psql output for Session #2                                                                                 |
| **Allowed**                               |                                                                                                                          |
| Language                        |  SQL                                                                                              |

You need to use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users. 

Actually, we need two active sessions (i.e. 2 parallel sessions in the command line).

| |
|-|
| Let's check one of the famous "Phantom Reads" database patterns, but under the isolation level `REPEATABLE READ`. You can see a graphical representation of this anomaly on a picture. The horizontal red line represents the final results after all sequential steps for both Sessions. |
| ![D08_11](misc/images/D08_11.png) |

You need to summarize all ratings for all pizzerias in one transaction mode for Session #1 and then make `INSERT` of the new restaurant 'Kazan Pizza 2' with rating 4 and ID=11 in Session #2 (in the same order as in the picture).

## Exercise 07 — Deadlock


| Exercise 07: Deadlock|                                                                                                                          |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| Turn-in directory                     | ex07                                                                                                                     |
| Files to turn-in                      | `day08_ex07.sql`    with comments for Session #1, Session #2 statements; screenshot of psql output for Session #1; screenshot of psql output for Session #2                                                                                |
| **Allowed**                               |                                                                                                                          |
| Language                        |  SQL                                                                                              |

You need to use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users. 

Actually, we need two active sessions (i.e. 2 parallel sessions in the command line).

Let’s reproduce a deadlock situation in our database. 


| |
|-|
| You can see a graphical representation of the deadlock situation in a picture. It looks like a "Christ-lock" between parallel sessions. |
| ![D08_12](misc/images/D08_12.png) |

You need to write any SQL statement with any isolation level (you can use the default setting) on the table `pizzeria` to reproduce this deadlock situation.

