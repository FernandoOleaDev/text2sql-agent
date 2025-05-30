# 🐳 Guía de Despliegue en Synology NAS

Esta guía te ayudará a desplegar tu aplicación Text2SQL Agent en tu NAS Synology usando Docker.

## 📋 Prerrequisitos

### En tu Synology NAS:

1. **Instalar Docker** desde Package Center
2. **Instalar Docker Compose** (viene incluido con Docker en DSM 7.0+)
3. **Acceso SSH** habilitado (Control Panel > Terminal & SNMP > SSH)

### Herramientas necesarias:
- Cliente SSH (Terminal en Mac/Linux o PuTTY en Windows)
- Tu **API Key de OpenAI** ([obtener aquí](https://platform.openai.com/api-keys))

## 🚀 Proceso de Instalación

### 1. Transferir archivos al NAS

Puedes usar varias opciones:

**Opción A: Git (recomendado)**
```bash
# Conectar por SSH al NAS
ssh admin@IP_DE_TU_NAS

# Navegar a la carpeta compartida
cd /volume1/docker/

# Clonar el repositorio
git clone https://github.com/tu-usuario/text2sql-agent.git
cd text2sql-agent
```

**Opción B: File Station**
- Comprimir toda la carpeta del proyecto
- Subir a `/volume1/docker/` usando File Station
- Extraer los archivos

**Opción C: SCP/SFTP**
```bash
# Desde tu Mac/PC
scp -r /ruta/al/proyecto admin@IP_NAS:/volume1/docker/text2sql-agent
```

### 2. Configurar variables de entorno

```bash
# Conectar por SSH
ssh admin@IP_DE_TU_NAS

# Ir al directorio del proyecto
cd /volume1/docker/text2sql-agent

# Copiar el archivo de configuración
cp .env.docker .env

# Editar el archivo .env
nano .env
```

**Configurar tu API Key y Base de Datos:**
```bash
OPENAI_API_KEY=sk-tu-api-key-real-aqui
URI=mysql+pymysql://usuario:password@servidor:puerto/basededatos
```

Ejemplo para Popau Elements:
```bash
OPENAI_API_KEY=sk-proj-N_NrDLXzibds9i1vTkJy...
URI=mysql+pymysql://agentSQL:password@PMYSQL137.dns-servicio.com:3306/7944483_PopauSQL_IA
```

Guardar con `Ctrl+X`, luego `Y`, luego `Enter`.

### 3. Ejecutar el script de despliegue

```bash
# Hacer ejecutable el script
chmod +x deploy-synology.sh

# Ejecutar el despliegue
./deploy-synology.sh
```

### 4. Verificar la instalación

Una vez completado, tu aplicación estará disponible en:
- `http://IP_DE_TU_NAS:8000`

## 🔧 Comandos Útiles

### Ver logs de la aplicación:
```bash
docker-compose logs -f chainlit-app
```

### Ver logs de MySQL:
```bash
docker-compose logs -f mysql
```

### Reiniciar servicios:
```bash
docker-compose restart
```

### Detener servicios:
```bash
docker-compose down
```

### Actualizar la aplicación:
```bash
git pull
docker-compose build --no-cache
docker-compose up -d
```

## 🌐 Acceso desde Internet (Opcional)

Para acceder desde fuera de tu red local:

1. **Router**: Configurar port forwarding del puerto 8000
2. **Synology**: Control Panel > External Access > Router Configuration
3. **HTTPS**: Considera usar un reverse proxy como nginx para SSL

## 🔒 Seguridad

### Recomendaciones:
- Cambiar las contraseñas por defecto de MySQL
- Usar un dominio y certificado SSL para producción
- Configurar firewall para limitar acceso
- Backup regular de la base de datos

### Backup de la base de datos:
```bash
docker-compose exec mysql mysqldump -u root -p sakila > backup_sakila.sql
```

## 🚨 Solución de Problemas

### Error de permisos:
```bash
sudo chown -R $(whoami):$(whoami) /volume1/docker/text2sql-agent
```

### Puerto ocupado:
Editar `docker-compose.yml` y cambiar `"8000:8000"` por `"8001:8000"`

### Error de memoria:
Verificar recursos disponibles:
```bash
docker system df
docker system prune
```

### Logs de depuración:
```bash
docker-compose logs --tail=50 chainlit-app
```

## 📞 Soporte

Si encuentras problemas:
1. Verificar logs con `docker-compose logs`
2. Revisar que todos los servicios estén corriendo: `docker-compose ps`
3. Verificar conectividad de red: `docker network ls`

¡Tu aplicación Text2SQL Agent ya está lista para usar en tu Synology NAS! 🎉
