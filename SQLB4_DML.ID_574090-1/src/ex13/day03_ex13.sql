-- 1. Удаляем все заказы от 25 февраля 2022 года
DELETE FROM person_order
WHERE order_date = '2022-02-25';

-- 2. Удаляем пиццу "greek pizza" из меню
DELETE FROM menu
WHERE pizza_name = 'greek pizza';