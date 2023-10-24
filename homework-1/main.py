import csv
import psycopg2


def import_data_to_table(table_name, csv_file):
    """
    Импортирует данные из CSV-файла в указанную таблицу базы данных PostgreSQL.

    Args:
        table_name (str): Имя таблицы, в которую необходимо импортировать данные.
        csv_file (str): Путь к CSV-файлу, содержащему данные для импорта.

    Returns:
        None
    """
    try:
        # Устанавливаем соединение с базой данных
        conn = psycopg2.connect(
            host='localhost',
            database='north',
            user='postgres',
            password='12345',
            port='5433'
        )

        # Создаем курсор для выполнения SQL-запросов
        cur = conn.cursor()

        # Открываем CSV-файл для чтения
        with open(csv_file, 'r') as file:
            # Создаем CSV-ридер
            reader = csv.reader(file)
            # Считываем заголовок, который содержит названия столбцов
            header = next(reader)
            # Создаем строку для подстановки параметров
            placeholders = ', '.join(['%s' for _ in header])
            # Формируем SQL-запрос
            query = f"INSERT INTO {table_name} ({', '.join(header)}) VALUES ({placeholders})"

            # Импортируем данные из CSV-файла в таблицу
            for row in reader:
                cur.execute(query, row)

        # Фиксируем изменения
        conn.commit()
        # Закрываем курсор
        cur.close()
        # Закрываем соединение
        conn.close()
    except Exception as e:
        print(f"An error occurred: {e}")


# Пример использования
import_data_to_table("customers", "north_data/customers_data.csv")
import_data_to_table("employees", "north_data/employees_data.csv")
import_data_to_table("orders", "north_data/orders_data.csv")
