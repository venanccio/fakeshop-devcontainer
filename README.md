# Fake Shop - DevContainer Implementation

Este projeto implementa um ambiente de desenvolvimento completo usando **DevContainers** para o Fake Shop, uma aplicação Flask com PostgreSQL. A implementação garante consistência entre ambientes de desenvolvimento, staging e produção.

## 🚀 Visão Geral

O Fake Shop utiliza DevContainers para criar um ambiente de desenvolvimento isolado e reproduzível, eliminando problemas de configuração manual e garantindo que todos os desenvolvedores trabalhem no mesmo ambiente.

### Tecnologias Utilizadas

- **Python 3.11** com Flask
- **PostgreSQL 15** como banco de dados
- **Docker** e **Docker Compose** para containerização
- **DevContainers** para ambiente de desenvolvimento
- **Gunicorn** como servidor WSGI
- **Alembic** para migrations de banco de dados

## 📁 Estrutura do Projeto

fake-shop/
├── .devcontainer/
│ ├── devcontainer.json # Configuração do DevContainer
│ ├── Dockerfile.dev # Dockerfile para desenvolvimento
│ └── docker-compose.override.yml # Override para DevContainer
├── src/
│ ├── app.py # Aplicação Flask principal
│ ├── models/ # Modelos do banco de dados
│ ├── templates/ # Templates HTML
│ └── static/ # Arquivos estáticos
├── compose.yml # Docker Compose base
├── compose.staging.yml # Configuração para staging
├── compose.production.yml # Configuração para produção
├── Dockerfile # Dockerfile de produção
├── start.sh # Script de inicialização
├── requirements.txt # Dependências Python
└── README.md # Este arquivo


## 🛠 Configuração dos Ambientes

### Ambiente de Desenvolvimento (DevContainer)

O DevContainer está configurado para fornecer um ambiente completo de desenvolvimento:

- **Extensões VS Code**: Python, Docker, REST Client, Black formatter
- **Ferramentas de desenvolvimento**: pytest, black, flake8
- **Hot reload**: Código sincronizado com volume
- **Debug habilitado**: Flask em modo debug

### Ambiente de Staging (Porta 8081)

- **Finalidade**: Testes de integração e validação
- **Configuração**: Similar à produção, mas com debug habilitado
- **Banco**: PostgreSQL isolado (`fakeshop_staging`)
- **Workers**: 1 worker Gunicorn para facilitar debug

### Ambiente de Produção (Porta 8080)

- **Finalidade**: Ambiente otimizado para performance
- **Configuração**: Multi-stage build otimizado
- **Banco**: PostgreSQL isolado (`fakeshop_prod`)
- **Workers**: 4 workers Gunicorn para alta performance
- **Segurança**: Usuário não-root, health checks

## 🚀 Como Usar

### Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Extensão Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Desenvolvimento com DevContainer

1. **Clone o repositório**:
git clone <url-do-repositorio>
cd fake-shop


2. **Abra no VS Code**:
code .


3. **Reabra no Container**:
- Pressione `Ctrl+Shift+P` (ou `Cmd+Shift+P` no Mac)
- Digite "Dev Containers: Reopen in Container"
- Aguarde a construção do ambiente

4. **Acesse a aplicação**:
- A aplicação estará disponível em `http://localhost:5000`
- O VS Code automaticamente encaminhará a porta

### Ambiente de Staging

Subir ambiente de staging
docker compose -f compose.yml -f compose.staging.yml up -d

Verificar logs
docker logs fakeshop-devcontainer-app-1 --follow

Acessar aplicação
curl http://localhost:8081


### Ambiente de Produção

Subir ambiente de produção
docker compose -f compose.yml -f compose.production.yml up -d

Verificar status
docker compose -f compose.yml -f compose.production.yml ps

Acessar aplicação
curl http://localhost:8080


## 🔧 Scripts de Gerenciamento

### Script de Gerenciamento Automático

Crie um arquivo `manage-envs.sh` para facilitar o gerenciamento:

#!/bin/bash

case "$1" in
start-staging)
docker compose -f compose.yml -f compose.staging.yml up -d
echo "✅ Staging iniciado em http://localhost:8081"
;;
start-production)
docker compose -f compose.yml -f compose.production.yml up -d
echo "✅ Produção iniciada em http://localhost:8080"
;;
stop-staging)
docker compose -f compose.yml -f compose.staging.yml down
echo "🛑 Staging parado"
;;
stop-production)
docker compose -f compose.yml -f compose.production.yml down
echo "🛑 Produção parada"
;;
status)
echo "=== STATUS DOS AMBIENTES ==="
docker ps | grep -E "(staging|production|devcontainer)"
;;
logs-staging)
docker logs fakeshop-devcontainer-app-1 --follow
;;
logs-production)
docker logs fakeshop-devcontainer-app-1 --follow
;;
*)
echo "Uso: $0 {start-staging|start-production|stop-staging|stop-production|status|logs-staging|logs-production}"
exit 1
;;
esac


Tornar executável:
chmod +x manage-envs.sh


## 🗃 Gerenciamento de Banco de Dados

### Migrations

As migrations são aplicadas automaticamente na inicialização dos containers através do script `start.sh`:

Aplicar migrations manualmente (se necessário)
docker exec -it <container-name> python3 -c "from app import app, apply_migrations; apply_migrations()"


### Backup e Restore

Backup do banco de produção
docker exec fakeshop-devcontainer-db-1 pg_dump -U postgres fakeshop_prod > backup_prod_$(date +%Y%m%d).sql

Backup do banco de staging
docker exec fakeshop-devcontainer-db-1 pg_dump -U postgres fakeshop_staging > backup_staging_$(date +%Y%m%d).sql

Restore (exemplo)
docker exec -i fakeshop-devcontainer-db-1 psql -U postgres -d fakeshop_staging < backup_staging_20250608.sql


## 🔍 Monitoramento e Logs

### Verificar Status dos Containers

Listar todos os containers
docker ps

Verificar redes Docker
docker network ls

Inspecionar container específico
docker inspect <container-name>


### Logs Detalhados

Logs em tempo real
docker logs <container-name> --follow

Logs das últimas 50 linhas
docker logs <container-name> --tail 50

Logs com timestamp
docker logs <container-name> --timestamps


### Health Checks

Os containers de produção incluem health checks automáticos:

Verificar health status
docker inspect <container-name> | grep Health -A 10


## 🔒 Segurança

### Boas Práticas Implementadas

- **Usuário não-root**: Containers executam como `appuser` (UID 1000)
- **Redes isoladas**: Cada ambiente tem sua própria rede Docker
- **Secrets management**: Variáveis de ambiente para configurações sensíveis
- **Multi-stage builds**: Imagens de produção otimizadas e seguras
- **Health checks**: Monitoramento automático da saúde dos containers

### Variáveis de Ambiente

Crie arquivos `.env` para cada ambiente (não commitados no git):

**.env.staging**:
FLASK_ENV=staging
FLASK_DEBUG=1
DB_HOST=db
DB_USER=postgres
DB_PASSWORD=your-staging-password
DB_NAME=fakeshop_staging


**.env.production**:
FLASK_ENV=production
FLASK_DEBUG=0
DB_HOST=db
DB_USER=postgres
DB_PASSWORD=your-production-password
DB_NAME=fakeshop_prod
SECRET_KEY=your-super-secret-production-key


## 🚨 Troubleshooting

### Problemas Comuns

**Container não inicia**:
Verificar logs de erro
docker logs <container-name>

Rebuild forçado
docker compose up --build --force-recreate


**Erro de conexão com banco**:
Verificar se o banco está rodando
docker ps | grep postgres

Testar conectividade
docker exec -it <app-container> python3 -c "import psycopg; print('OK')"


**Migrations não aplicadas**:
Aplicar migrations manualmente
docker exec -it <app-container> /bin/bash
cd /app/src
python3 -c "from app import app, apply_migrations; apply_migrations()"


**Conflitos de porta**:
Verificar portas em uso
netstat -tulpn | grep -E "(8080|8081|5432)"

Parar containers conflitantes
docker stop $(docker ps -q)


## 📊 Resumo dos Ambientes

| Ambiente | Porta | Banco | Debug | Workers | Health Check |
|----------|-------|-------|-------|---------|--------------|
| **DevContainer** | 5000 | Automático | ✅ | 1 | ❌ |
| **Staging** | 8081 | fakeshop_staging | ✅ | 1 | ✅ |
| **Produção** | 8080 | fakeshop_prod | ❌ | 4 | ✅ |

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🙏 Agradecimentos

- Equipe da Rota42 pelo desafio
- Comunidade DevContainers pela especificação
- Documentação oficial do Docker e Docker Compose

---

**Desenvolvido com ❤️ usando DevContainers**