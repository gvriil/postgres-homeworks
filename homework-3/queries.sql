-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника,
-- работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания
--United Package (company_name в табл shippers)

-- Выбираем название компании заказчика и имя сотрудника,
-- где заказчик и сотрудник находятся в городе Лондон,
-- и заказ доставляется компанией "United Package".

SELECT c.company_name AS customer,
       CONCAT(e.first_name, ' ', e.last_name) AS employee
FROM customers AS c
-- Объединяем таблицу заказчиков с таблицей заказов по идентификатору заказчика
JOIN orders AS o ON c.customer_id = o.customer_id
-- Объединяем таблицу заказов с таблицей сотрудников по идентификатору сотрудника
JOIN employees AS e ON o.employee_id = e.employee_id
-- Объединяем таблицу заказов с таблицей компаний-поставщиков доставки по идентификатору компании
JOIN shippers AS s ON o.ship_via = s.shipper_id
-- Ограничиваем результаты: заказчик и сотрудник должны находиться в Лондоне,
-- и компания доставки должна быть "United Package".
WHERE c.city = 'London' AND e.city = 'London' AND s.company_name = 'United Package';

-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.

-- Выбираем наименование продукта, количество товара, имя поставщика и его телефон,
-- для продуктов, которые не сняты с продажи, имеют меньше 25 единиц в наличии и
-- относятся к категориям Dairy Products и Condiments.

SELECT p.product_name, p.units_in_stock, s.contact_name, s.phone
FROM products AS p
-- Объединяем таблицу продуктов с таблицей поставщиков по идентификатору поставщика
JOIN suppliers AS s USING(supplier_id)
-- Объединяем таблицу продуктов с таблицей категорий по идентификатору категории
JOIN categories AS c USING(category_id)
-- Ограничиваем результаты: продукты должны быть не сняты с продажи, иметь меньше 25 единиц в наличии,
-- и относиться к категориям Dairy Products или Condiments.
WHERE p.discontinued = 0
  AND p.units_in_stock < 25
  AND c.category_name IN ('Dairy Products', 'Condiments')
-- Сортируем результаты по возрастанию количества оставшегося товара.
ORDER BY p.units_in_stock ASC;


-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа

-- Выбираем названия компаний заказчиков, которые не сделали ни одного заказа.

SELECT c.company_name
FROM customers AS c
-- Используем LEFT JOIN, чтобы включить все заказы и их заказчиков,
-- а также проверяем, что заказ не существует (т.е., заказчик не сделал ни одного заказа).
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.

-- Выбираем уникальные названия продуктов, которые были заказаны ровно 10 единиц.

SELECT DISTINCT product_name
FROM products AS p
-- Используем подзапрос, чтобы выбрать product_id продуктов с количеством 10 в order_details.
WHERE p.product_id IN
(
    SELECT product_id
    FROM order_details AS od
    WHERE od.quantity = 10
);
