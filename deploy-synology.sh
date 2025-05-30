#!/bin/bash

# Script de despliegue para Synology NAS
# Este script automatiza el proceso de construcción y despliegue

echo "🚀 Iniciando despliegue de Text2SQL Agent en Synology NAS"

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Por favor, instala Docker desde Package Center."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado. Por favor, instala Docker Compose."
    exit 1
fi

# Verificar que el archivo .env existe
if [ ! -f .env ]; then
    echo "⚠️  Archivo .env no encontrado. Copiando desde .env.docker..."
    cp .env.docker .env
    echo "📝 Por favor, edita el archivo .env y agrega tu OPENAI_API_KEY real"
    echo "💡 Usa: nano .env"
    read -p "Presiona Enter cuando hayas configurado tu API Key..."
fi

# Verificar que la API Key está configurada
if grep -q "sk-your-openai-api-key-here" .env; then
    echo "❌ Por favor, configura tu OPENAI_API_KEY real en el archivo .env"
    exit 1
fi

echo "🔧 Construyendo la aplicación..."

# Construir y levantar los servicios
docker-compose down 2>/dev/null
docker-compose build --no-cache

echo "🐳 Iniciando servicios..."
docker-compose up -d

echo "⏳ Esperando que la aplicación esté lista..."
sleep 15

# Verificar que los servicios están funcionando
if docker-compose ps | grep -q "Up"; then
    echo "✅ ¡Despliegue exitoso!"
    echo ""
    echo "🌐 Tu aplicación está disponible en:"
    echo "   http://$(hostname -I | awk '{print $1}'):8000"
    echo "   o"
    echo "   http://localhost:8000"
    echo ""
    echo "📊 Para ver los logs:"
    echo "   docker-compose logs -f chainlit-app"
    echo ""
    echo "🛑 Para detener los servicios:"
    echo "   docker-compose down"
else
    echo "❌ Error en el despliegue. Verificando logs..."
    docker-compose logs
fi
