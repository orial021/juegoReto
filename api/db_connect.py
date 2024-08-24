import psycopg2
from psycopg2 import sql

# Conexión a PostgreSQL
conn = psycopg2.connect(
    dbname="juegoReto",
    user="postgres",
    password="2354",
    host="localhost",
    port="5432"
)
conn.autocommit = True

# Crear un cursor
cursor = conn.cursor()

# Crear la base de datos
db_name = "juegoReto"
db_password = "2354"
cursor.execute(sql.SQL("CREATE DATABASE {}").format(sql.Identifier(db_name)))

# Cerrar la conexión
cursor.close()
conn.close()

print(f"Base de datos '{db_name}' creada exitosamente.")
