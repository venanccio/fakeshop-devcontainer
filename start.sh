#!/bin/bash

# Definir variáveis de ambiente
export PYTHONPATH="/app/src:$PYTHONPATH"
cd /app/src

# Aguardar o banco de dados estar disponível
echo "Aguardando banco de dados..."
until python3 -c "
import psycopg
import os
try:
    conn = psycopg.connect(
        host=os.getenv('DB_HOST', 'db'),
        port=os.getenv('DB_PORT', '5432'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', 'password'),
        dbname='postgres'  # Conectar ao banco padrão primeiro
    )
    conn.close()
    print('Servidor PostgreSQL conectado!')
except Exception as e:
    print(f'Erro na conexão: {e}')
    exit(1)
"; do
  echo "Aguardando PostgreSQL..."
  sleep 2
done

# Verificar se o banco de dados existe e criar se necessário
echo "Verificando se o banco ${DB_NAME} existe..."
DB_EXISTS=$(python3 -c "
import psycopg
import os
try:
    conn = psycopg.connect(
        host=os.getenv('DB_HOST', 'db'),
        port=os.getenv('DB_PORT', '5432'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', 'password'),
        dbname='postgres'
    )
    cur = conn.cursor()
    cur.execute('SELECT 1 FROM pg_database WHERE datname = %s', (os.getenv('DB_NAME', 'fakeshop'),))
    result = cur.fetchone()
    cur.close()
    conn.close()
    print('1' if result else '0')
except Exception as e:
    print('0')
")

if [ "$DB_EXISTS" = "0" ]; then
    echo "Criando banco de dados ${DB_NAME}..."
    python3 -c "
import psycopg
import os
try:
    conn = psycopg.connect(
        host=os.getenv('DB_HOST', 'db'),
        port=os.getenv('DB_PORT', '5432'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', 'password'),
        dbname='postgres',
        autocommit=True
    )
    cur = conn.cursor()
    cur.execute(f'CREATE DATABASE {os.getenv(\"DB_NAME\", \"fakeshop\")}')
    cur.close()
    conn.close()
    print('Banco criado com sucesso!')
except Exception as e:
    print(f'Erro ao criar banco: {e}')
    exit(1)
"
else
    echo "Banco ${DB_NAME} já existe."
fi

# Aplicar migrations
echo "Aplicando migrations..."
python3 -c "
try:
    from app import app, apply_migrations
    with app.app_context():
        apply_migrations()
    print('Migrations aplicadas com sucesso!')
except Exception as e:
    print(f'Erro ao aplicar migrations: {e}')
    exit(1)
"

# Iniciar aplicação
if [ "$FLASK_ENV" = "production" ]; then
    echo "Iniciando aplicação em modo PRODUÇÃO..."
    exec gunicorn --bind 0.0.0.0:5000 --workers 4 --worker-class sync app:app
else
    echo "Iniciando aplicação em modo STAGING..."
    exec gunicorn --bind 0.0.0.0:5000 --workers 1 --worker-class sync app:app
fi
