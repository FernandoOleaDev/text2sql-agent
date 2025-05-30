#!/bin/bash

# Script de monitoreo para Text2SQL Agent en Synology
# Uso: ./monitor.sh [status|logs|restart|stop|update]

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="text2sql-agent"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar el estado
show_status() {
    echo -e "${BLUE}📊 Estado de los servicios:${NC}"
    docker-compose ps
    echo ""
    
    echo -e "${BLUE}💻 Uso de recursos:${NC}"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    echo ""
    
    echo -e "${BLUE}💾 Espacio en disco:${NC}"
    docker system df
}

# Función para mostrar logs
show_logs() {
    echo -e "${BLUE}📋 Logs recientes (últimas 50 líneas):${NC}"
    echo -e "${YELLOW}=== Logs de Chainlit App ===${NC}"
    docker-compose logs --tail=50 chainlit-app
    echo ""
    echo -e "${YELLOW}=== Logs de MySQL ===${NC}"
    docker-compose logs --tail=20 mysql
}

# Función para reiniciar servicios
restart_services() {
    echo -e "${YELLOW}🔄 Reiniciando servicios...${NC}"
    docker-compose restart
    sleep 10
    show_status
}

# Función para detener servicios
stop_services() {
    echo -e "${RED}🛑 Deteniendo servicios...${NC}"
    docker-compose down
    echo -e "${GREEN}✅ Servicios detenidos${NC}"
}

# Función para actualizar
update_app() {
    echo -e "${YELLOW}📦 Actualizando aplicación...${NC}"
    
    # Hacer backup de la configuración
    cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
    
    # Actualizar código (si es un repo git)
    if [ -d ".git" ]; then
        git pull
    else
        echo -e "${YELLOW}⚠️  No es un repositorio git. Actualiza manualmente los archivos.${NC}"
    fi
    
    # Reconstruir y reiniciar
    docker-compose down
    docker-compose build --no-cache
    docker-compose up -d
    
    echo -e "${GREEN}✅ Actualización completada${NC}"
    sleep 10
    show_status
}

# Función de ayuda
show_help() {
    echo -e "${BLUE}🔧 Text2SQL Agent - Script de Monitoreo${NC}"
    echo ""
    echo "Uso: $0 [comando]"
    echo ""
    echo "Comandos disponibles:"
    echo "  status    - Mostrar estado de servicios y recursos"
    echo "  logs      - Mostrar logs recientes"
    echo "  restart   - Reiniciar todos los servicios"
    echo "  stop      - Detener todos los servicios"
    echo "  update    - Actualizar y reiniciar la aplicación"
    echo "  help      - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 status"
    echo "  $0 logs"
    echo "  $0 restart"
}

# Verificar que docker-compose existe
if [ ! -f "$COMPOSE_FILE" ]; then
    echo -e "${RED}❌ Error: $COMPOSE_FILE no encontrado${NC}"
    exit 1
fi

# Procesar argumentos
case "${1:-status}" in
    "status")
        show_status
        ;;
    "logs")
        show_logs
        ;;
    "restart")
        restart_services
        ;;
    "stop")
        stop_services
        ;;
    "update")
        update_app
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo -e "${RED}❌ Comando no reconocido: $1${NC}"
        show_help
        exit 1
        ;;
esac
