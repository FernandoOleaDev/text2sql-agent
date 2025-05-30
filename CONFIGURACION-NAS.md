# 🚀 Text2SQL Agent - Configuración para Synology NAS

## 📦 Archivos incluidos en este despliegue:

- ✅ `Dockerfile` - Configuración del contenedor
- ✅ `docker-compose.yml` - Orquestación de servicios (base de datos externa)
- ✅ `.env` - Variables de entorno configuradas para Popau Elements
- ✅ `deploy-synology.sh` - Script de despliegue automatizado
- ✅ `DEPLOY-SYNOLOGY.md` - Documentación completa
- ✅ `.dockerignore` - Archivos a excluir del contenedor

## 🎯 Configuración actual:

### Base de Datos:
- **Servidor**: PMYSQL137.dns-servicio.com:3306
- **Base de Datos**: 7944483_PopauSQL_IA (Popau Elements)
- **Usuario**: agentSQL
- **Tipo**: Conexión externa (no se incluye MySQL en Docker)

### Aplicación:
- **Puerto**: 8000
- **Framework**: Chainlit
- **Modelo**: OpenAI GPT (configurado)

## 🔧 Comandos rápidos para el NAS:

### Despliegue inicial:
```bash
./deploy-synology.sh
```

### Ver estado:
```bash
docker-compose ps
```

### Ver logs:
```bash
docker-compose logs -f chainlit-app
```

### Reiniciar:
```bash
docker-compose restart
```

### Detener:
```bash
docker-compose down
```

## 🌐 Acceso:
Una vez desplegado: `http://IP_DE_TU_NAS:8000`

## ⚠️ Nota importante:
Tu base de datos está configurada como externa, por lo que la aplicación necesitará acceso a internet para conectarse a `PMYSQL137.dns-servicio.com`. Asegúrate de que tu NAS tenga acceso a internet.

¡Todo listo para el despliegue! 🎉
