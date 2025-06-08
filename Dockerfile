FROM python:3.11-slim AS builder

WORKDIR /app

# Instalar dependências de build
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Criar virtual environment
RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Estágio de produção
FROM python:3.11-slim

WORKDIR /app

# Instalar apenas dependências runtime
RUN apt-get update && apt-get install -y \
    libpq5 \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Copiar virtual environment do builder
COPY --from=builder /app/venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Copiar código da aplicação
COPY . .

# Criar usuário não-root para segurança
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Script de produção otimizado
RUN echo '#!/bin/bash\ncd /app/src\npython3 -c "from app import app, apply_migrations; apply_migrations()"\nexec gunicorn --bind 0.0.0.0:5000 --workers 4 --worker-class sync --max-requests 1000 --max-requests-jitter 100 --preload app:app' > /app/start.sh && \
    chmod +x /app/start.sh && \
    chown appuser:appuser /app/start.sh

USER appuser

EXPOSE 5000

# Health check para produção
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:5000/ || exit 1

CMD ["/app/start.sh"]
