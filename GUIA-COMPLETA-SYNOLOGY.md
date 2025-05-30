# 🚀 Guía Completa: Despliegue Text2SQL Agent en Synology NAS

## 📋 Información de tu configuración
- **NAS:** Synology DS218
- **DSM:** 7.2.2-72806 Update 3  
- **IP NAS:** 192.168.1.124
- **Usuario:** LyceumAdmin
- **Método:** File Station + Container Manager (GUI)
- **Acceso:** Red local + Internet

---

## 🎯 Objetivo Final
Al completar esta guía tendrás tu aplicación Text2SQL Agent funcionando en:
- **URL Local:** `http://192.168.1.124:8000`
- **URL Internet:** `http://TU_IP_PUBLICA:8000` (después de configurar router)

---

## 📦 PASO 1: Preparar archivos en tu Mac

### 1.1 Crear archivo ZIP del proyecto
```bash
# Abrir Terminal en Mac y ejecutar:
cd /Users/fernandoolea/Dev/Github\ Repos/
zip -r text2sql-agent.zip text2sql-agent/ -x "text2sql-agent/.git/*" "text2sql-agent/.venv/*" "text2sql-agent/__pycache__/*"
```

### 1.2 Verificar que tienes los archivos esenciales
```bash
# Verificar que estos archivos existen:
ls -la text2sql-agent/
```
**Archivos críticos que deben estar:**
- ✅ `Dockerfile`
- ✅ `docker-compose.yml`
- ✅ `requirements.txt`
- ✅ `.env` (con tus credenciales)
- ✅ `front.py`
- ✅ `chatbot/` (carpeta completa)

---

## 🌐 PASO 2: Acceder a tu Synology NAS

### 2.1 Conectar via web
1. **Abrir navegador** y ir a: `http://192.168.1.124:5000`
2. **Iniciar sesión** con:
   - Usuario: `LyceumAdmin`
   - Contraseña: [tu contraseña]

### 2.2 Verificar Container Manager está instalado
1. Ir a **Package Center**
2. Buscar **"Container Manager"**
3. Si no está instalado:
   - Hacer clic en **"Install"**
   - Esperar a que termine la instalación
   - Reiniciar el NAS si se solicita

---

## 📁 PASO 3: Crear estructura de carpetas

### 3.1 Abrir File Station
1. En DSM, hacer clic en **File Station**
2. Navegar a **`docker`** (carpeta compartida)
3. Si no existe la carpeta `docker`:
   - Hacer clic derecho en el área vacía
   - **Create** → **Folder**
   - Nombre: `docker`

### 3.2 Crear carpeta del proyecto
1. **Entrar** a la carpeta `docker`
2. Hacer clic derecho → **Create** → **Folder**
3. Nombre: `text2sql-agent`
4. **Entrar** a la carpeta `text2sql-agent`

---

## ⬆️ PASO 4: Subir archivos al NAS

### 4.1 Subir archivo ZIP
1. En File Station, **dentro de** `/docker/text2sql-agent/`
2. Hacer clic en **Upload** (botón de flecha hacia arriba)
3. **Seleccionar** el archivo `text2sql-agent.zip` que creaste
4. Esperar a que termine la subida

### 4.2 Extraer archivos
1. Hacer **clic derecho** sobre `text2sql-agent.zip`
2. Seleccionar **Extract** → **Extract Here**
3. Se creará una carpeta `text2sql-agent` dentro
4. **Mover** todos los archivos de esa carpeta al directorio principal:
   - Seleccionar todos los archivos de `text2sql-agent/text2sql-agent/`
   - **Cut** (Ctrl+X)
   - Ir a `/docker/text2sql-agent/`
   - **Paste** (Ctrl+V)
5. **Eliminar** la carpeta vacía `text2sql-agent` y el ZIP

### 4.3 Verificar estructura final
Tu carpeta `/docker/text2sql-agent/` debe contener:
```
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .env
├── front.py
├── chainlit.md
├── chatbot/
│   ├── __init__.py
│   ├── chatclass.py
│   └── prompts.py
├── tools/
│   ├── __init__.py
│   └── tools.py
└── [otros archivos...]
```

---

## 🐳 PASO 5: Configurar Container Manager

### 5.1 Abrir Container Manager
1. En el **Main Menu** de DSM
2. Hacer clic en **Container Manager**
3. Si es la primera vez, aceptar los términos

### 5.2 Método A: Usar docker-compose (Recomendado)

#### 5.2.1 Crear Proyecto
1. Ir a la pestaña **"Project"**
2. Hacer clic en **"Create"**
3. **General Settings:**
   - Project name: `text2sql-agent`
   - Path: `/docker/text2sql-agent`
   
#### 5.2.2 Configurar docker-compose
1. **Source:** seleccionar **"Use existing docker-compose.yml"**
2. Hacer clic en **"Next"**
3. **Revisar** la configuración que aparece
4. Hacer clic en **"Done"**

### 5.3 Método B: Configuración manual (Alternativo)

#### 5.3.1 Crear Container manualmente
1. Ir a **"Container"** tab
2. Hacer clic en **"Create"**
3. **Choose Image:**
   - Buscar: `python:3.11-slim`
   - Seleccionar y **Download**

#### 5.3.2 Configurar Container
**General:**
- Container name: `text2sql-chainlit`
- Auto-restart: ✅ Enabled

**Port Settings:**
- Local Port: `8000`
- Container Port: `8000`
- Type: `TCP`

**Volume Settings:**
- Add Folder:
  - Folder: `/docker/text2sql-agent`
  - Mount path: `/app`
  - Permission: `Read/Write`

**Environment Variables:**
- `OPENAI_API_KEY`: `[tu-api-key]`
- `URI`: `[tu-conexion-mysql]`

---

## ⚡ PASO 6: Construir y ejecutar

### 6.1 Si usaste Método A (docker-compose)
1. En Container Manager → **Project** → `text2sql-agent`
2. Hacer clic en **"Action"** → **"Build"**
3. Esperar a que termine (puede tomar 5-10 minutos)
4. Hacer clic en **"Action"** → **"Up"**

### 6.2 Si usaste Método B (manual)
1. Abrir **Terminal** en Container Manager
2. Conectar al container
3. Ejecutar:
```bash
cd /app
pip install -r requirements.txt
chainlit run front.py --host 0.0.0.0 --port 8000
```

---

## 🌍 PASO 7: Configurar acceso desde Internet

### 7.1 Configurar router (Port Forwarding)
1. **Acceder a tu router** (usualmente `192.168.1.1`)
2. Buscar **"Port Forwarding"** o **"Virtual Server"**
3. **Agregar nueva regla:**
   - Service Name: `Text2SQL-Agent`
   - External Port: `8000`
   - Internal IP: `192.168.1.124`
   - Internal Port: `8000`
   - Protocol: `TCP`
4. **Guardar** y reiniciar router

### 7.2 Obtener IP pública
1. Ir a: https://whatismyipaddress.com/
2. **Anotar** tu IP pública (ejemplo: `85.123.45.67`)

### 7.3 Configurar DDNS (Opcional)
1. En DSM → **Control Panel** → **External Access** → **DDNS**
2. **Enable DDNS**
3. Crear cuenta en servicio como **No-IP** o **DuckDNS**
4. Configurar hostname (ejemplo: `fernandoapp.ddns.net`)

---

## ✅ PASO 8: Verificar funcionamiento

### 8.1 Acceso local
1. Abrir navegador
2. Ir a: `http://192.168.1.124:8000`
3. Debe cargar la interfaz de Chainlit

### 8.2 Acceso desde Internet
1. Ir a: `http://TU_IP_PUBLICA:8000`
2. Debe cargar la misma interfaz

### 8.3 Verificar logs
1. En Container Manager → **Container** → `text2sql-chainlit`
2. Hacer clic en **"Details"** → **"Log"**
3. Verificar que no hay errores

---

## 🔧 PASO 9: Comandos de mantenimiento

### 9.1 Ver logs
Container Manager → Project → text2sql-agent → Action → **View Logs**

### 9.2 Reiniciar aplicación
Container Manager → Project → text2sql-agent → Action → **Restart**

### 9.3 Detener aplicación
Container Manager → Project → text2sql-agent → Action → **Stop**

### 9.4 Actualizar aplicación
1. Subir nuevos archivos via File Station
2. Container Manager → Project → text2sql-agent → Action → **Build**
3. Action → **Up**

---

## 🛡️ PASO 10: Configuración de seguridad (Importante)

### 10.1 Configurar Firewall
1. DSM → **Control Panel** → **Security** → **Firewall**
2. **Enable Firewall**
3. **Create Rules:**
   - Allow port `8000` from `All`
   - Allow SSH port `22` from `Local Network only`

### 10.2 Configurar HTTPS (Recomendado)
1. **Control Panel** → **Security** → **Certificate**
2. **Add Certificate** → **Get a certificate from Let's Encrypt**
3. Domain: tu DDNS hostname
4. Aplicar certificado al puerto 8000

### 10.3 Configurar Reverse Proxy (Avanzado)
1. **Control Panel** → **Application Portal** → **Reverse Proxy**
2. **Create Rule:**
   - Description: `Text2SQL-HTTPS`
   - Source: `HTTPS`, `443`, `tu-hostname.ddns.net`
   - Destination: `HTTP`, `8000`, `localhost`

---

## 🚨 SOLUCIÓN DE PROBLEMAS

### Problema: Container no inicia
**Solución:**
1. Verificar logs en Container Manager
2. Verificar que el archivo `.env` tiene las credenciales correctas
3. Verificar que todos los archivos se subieron correctamente

### Problema: No accesible desde Internet
**Solución:**
1. Verificar Port Forwarding en router
2. Verificar Firewall del NAS
3. Verificar IP pública no ha cambiado

### Problema: Error de base de datos
**Solución:**
1. Verificar credenciales en archivo `.env`
2. Verificar conectividad de red del NAS
3. Verificar que la base de datos esté accesible

### Comando de emergencia (SSH)
Si algo falla, puedes conectar por SSH:
```bash
ssh LyceumAdmin@192.168.1.124
cd /volume1/docker/text2sql-agent
sudo docker-compose logs
```

---

## 📱 URLs de acceso final

**Local (red doméstica):**
- `http://192.168.1.124:8000`

**Internet (después de configurar router):**
- `http://TU_IP_PUBLICA:8000`
- `http://tu-hostname.ddns.net:8000` (si configuraste DDNS)
- `https://tu-hostname.ddns.net` (si configuraste HTTPS + Reverse Proxy)

---

## ✨ ¡Completado!

Tu aplicación Text2SQL Agent ahora está funcionando en tu Synology NAS y es accesible desde cualquier lugar del mundo. 

**Próximos pasos sugeridos:**
1. 🔐 Configurar autenticación adicional
2. 📊 Monitorear recursos del NAS
3. 🔄 Configurar backups automáticos
4. 📈 Configurar alertas de estado

**¿Necesitas ayuda?** Revisa los logs en Container Manager o contacta con soporte técnico.
