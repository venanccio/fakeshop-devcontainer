# Fake Shop

## Descrição
Fake Shop é uma aplicação de e-commerce desenvolvida em Python usando Flask, com suporte a PostgreSQL como banco de dados.

## Ambientes

O projeto suporta dois ambientes:

### Produção (Porta 8080)
- Usa Gunicorn como servidor web
- Configurado para ambiente de produção
- Acessível em http://localhost:8080

### Staging/Desenvolvimento (Porta 8081)
- Usa o servidor de desenvolvimento do Flask
- Modo debug ativado
- Hot-reload para desenvolvimento
- Acessível em http://localhost:8081

## Requisitos
- Docker
- Docker Compose

## Configuração

### Variáveis de Ambiente
- `DB_HOST` => Host do banco de dados PostgreSQL
- `DB_USER` => Nome do usuário do banco de dados PostgreSQL
- `DB_PASSWORD` => Senha do usuário do banco de dados PostgreSQL
- `DB_NAME` => Nome do banco de dados PostgreSQL
- `DB_PORT` => Porta de conexão com o banco de dados PostgreSQL
- `FLASK_APP` => Arquivo de inicialização do Flask (app.py)
- `FLASK_ENV` => Ambiente de execução (production/development)

## Execução

### Ambiente de Produção
Para iniciar apenas o ambiente de produção:
```bash
docker compose up --build
```

### Ambiente de Staging/Desenvolvimento
Para iniciar apenas o ambiente de staging:
```bash
docker compose -f compose.yml -f .devcontainer/docker-compose.override.yml up --build
```

### Ambos os Ambientes
Para iniciar ambos os ambientes simultaneamente:
```bash
# Primeiro, inicie o ambiente de produção
docker compose up -d

# Em outro terminal, inicie o ambiente de staging
docker compose -f compose.yml -f .devcontainer/docker-compose.override.yml up --build
```

## Estrutura do Projeto
```
.
├── src/
│   ├── app.py              # Arquivo principal da aplicação
│   ├── models/             # Modelos do banco de dados
│   ├── static/             # Arquivos estáticos (CSS, JS, imagens)
│   ├── templates/          # Templates HTML
│   └── migrations/         # Migrações do banco de dados
├── compose.yml             # Configuração do ambiente de produção
├── .devcontainer/
│   ├── docker-compose.override.yml  # Configuração do ambiente de staging
│   └── Dockerfile.dev      # Dockerfile para desenvolvimento
└── Dockerfile              # Dockerfile para produção
```

## Comandos Úteis

### Limpar Containers e Imagens
```bash
# Parar e remover containers
docker compose down

# Remover todas as imagens não utilizadas
docker image prune -a
```

### Verificar Logs
```bash
# Logs do ambiente de produção
docker compose logs -f

# Logs do ambiente de staging
docker compose -f compose.yml -f .devcontainer/docker-compose.override.yml logs -f
```

### Acessar o Banco de Dados
```bash
# Conectar ao container do banco de dados
docker compose exec db psql -U postgres
```

## Desenvolvimento

### Hot Reload
O ambiente de staging (porta 8081) suporta hot reload, então as alterações nos arquivos são refletidas automaticamente.

### Volumes
O ambiente de staging monta o código fonte como um volume, permitindo edições em tempo real sem necessidade de reconstruir a imagem.

## Banco de Dados
- PostgreSQL 15
- Dados persistentes armazenados em volume Docker
- Migrações automáticas na inicialização