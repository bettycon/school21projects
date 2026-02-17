-- day00_ex04.sql
-- Задание 04: Погружение в мир SQL
-- Вычисляемое поле person_information

SELECT 
    CONCAT(
        name, 
        ' (age:', 
        age, 
        ',gender:''', 
        gender, 
        ''',address:''', 
        address, 
        ''')'
    ) AS person_information
FROM 
    person
ORDER BY 
    person_information;