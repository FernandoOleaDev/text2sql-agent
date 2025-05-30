# Webinar Text2SQL

Este proyecto consiste en la creación de un aplicación para la consulta a bases de datos relacionales con un agente. Este agente está compuesto de tres procesos:
1. Creación de la query SQL según la consulta del usuario conocida la estructura de la base de datos.
2. Ejecución de query creada.
3. Devolución de la respuesta en lenguaje natural para un uso completamente conversacional con la base de datos.


## Estructura de carpetas

```plaintext
📦 webinar_text2sql
├── 📁 chatbot                                          # Código Text-to-SQL 
│   ├── 📄 __init__.py                                  # Convierte un directorio en un paquete
│   ├── 📄 chatclass.py                                 # Clase del agente text2sql 
│   └── 📄 prompts.py                                   # Prompts del sistema
│
├── 📁 images                                           # Carpeta con las imagenes usadas
│
├── 📁 notebooks                                        # Carpeta de notebooks de prueba
│   ├── 📁 src                                          # Carpeta de codigo del chat
│   │   └── 📄 chat.py                                  # Función del chatbot
│   ├── 📄 Consultor SQL OpenAI y Langchain.ipynb       # Jupyter notebook con el paso a paso
│   └── 📄 practicas.ipynb                              # Jupyter notebook con 10 preguntas de prueba
│
├── 📁 sakila_db                                        # Carpeta con el archivo de la base de datos
│   └── 📄 sakila.sql                                   # Archivo autocontenido de la base de datos
│
├── 📁 tools                                            # Herramientas 
│   ├── 📄 __init__.py                                  # Convierte un directorio en un paquete
│   └── 📄 tools.py                                     # Herramientas (logger)
│
├── 📄 .env.template                                    # Plantilla de archivo .env 
├── 📄 .gitignore                                       # Archivos y carpetas a ignorar en Git
├── 📄 .python-version                                  # Versión de python
├── 📄 front.py                                         # Archivo del frontend con chainlit
├── 📄 pyproject.toml                                   # Dependencias y configuración 
├── 📄 README.md                                        # Documentación principal del proyecto
├── 📄 requirements.txt                                 # Dependencias y configuración 
└── 📄 uv.lock                                          # Dependencias y configuración 
```

## Estructura de la base de datos
Usaremos la base de datos [sakila](https://dev.mysql.com/doc/sakila/en/sakila-installation.html), una base de datos de ejemplo que podemos descargar desde [aquí](https://github.com/YonatanRA/webinar_text2sql/raw/refs/heads/main/sakila_db/sakila.sql). Sus características son las siguientes:

+ Dominio del negocio: Videoclub (alquiler de películas).

+ Tamaño: Mediana complejidad, ideal para practicar consultas SQL reales.

+ Relaciones: Incluye múltiples relaciones entre tablas, ideal para practicar joins, subqueries, views y stored procedures.

+ Diagrama entidad-relación:
![erd](https://raw.githubusercontent.com/YonatanRA/webinar_text2sql/refs/heads/main/images/erd.png)



## Dependencias

1. **Instalación `uv`**:

   El método de instalación recomendado de `uv` es:

   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

   De manera alternativa, podemos instalar `uv` via `pip`:

   ```bash
   pip install uv
   ```

   Para más detalles, revisar los [métodos de instalación](https://docs.astral.sh/uv/getting-started/installation/#installation-methods).



2. **Activación del entorno virtual**

    Activar el entorno virtual usado el siguiente comando:

    ```bash
    source .venv/bin/activate
    ```

    También puede usarse conda y crear un entorno virtual con:
     ```bash
    conda create -n sql python=3.11
    ```

3. **Sincronizar dependencias con uv**:

    ```bash
    uv sync
    ```

    Este comando instala las dependencias definidas en el archivo `pyproject.toml` con las mismas versiones especificadas en el archivo `uv.lock`.

4. **Sincronizar dependencias con pip**:

    ```bash
    pip install -r requirements.txt
    ```

    Este comando instala las dependencias en el entorno virtual definidas en el archivo `requirements.txt`. 

## Variables de entorno

Este proyecto necesita de una base de datos SQL (MySQL, PostGres, SQLServer). La URI debe estar escrita en el archivo `.env`. En la platilla de archivo `.env.template` existe un ejemplo de URI para MySQL. Se recomienda usar un usuario con permisos restringidos por seguridad. Se necesita obtener una API KEY de OpenAI [aqui](https://platform.openai.com/api-keys).

`URI = 'mysql+pymysql://user:password@localhost:3306/sakila'`

`OPENAI_API_KEY = 'sk-WrrN..................'`




## Proceso de instalación y uso

1. Crear la base de datos de MySQL sakila. Puede hacerse desde [Workbench](https://www.mysql.com/products/workbench/):
   ![workbench](https://raw.githubusercontent.com/YonatanRA/webinar_text2sql/refs/heads/main/images/import_db.png)

   O también desde la terminal de sql con los siguientes comandos:
   ```bash
    mysql -u root -p 
    ```

    ```bash
    mysql -u root -p sakila < sakila_sql/sakila.sql
    ```

2. Obtener URI de la base de datos de SQL y colocarla en el archivo `.env` (ejemplo en el archivo `.env.template`).


3. Instalar dependencias. Se puede usar el archivo `uv.lock` con el siguiente comando:
    ```bash
    uv sync
    ```
    También puede usarse el archivo `requirements.txt` usando el siguiente comando:
    ```bash
    pip install -r requirements.txt
    ```


4. Levantar el front de chainlit con el siguiente comando:
    ```bash
    chainlit run front.py -w --port 8001
    ```

## Configuración de la Base de Datos Sakila

### Iniciar MySQL

Puedes iniciar MySQL de varias formas dependiendo de tu configuración:

**Opción 1: Inicio manual (sin auto-inicio al reiniciar)**
```bash
sudo /usr/local/mysql/support-files/mysql.server start
```

**Opción 2: Con Homebrew (configurará auto-inicio)**
```bash
brew services start mysql
```

**Opción 3: Otras alternativas**
```bash
mysql.server start
```

### Cargar la Base de Datos Sakila

Una vez que MySQL esté funcionando, puedes cargar la base de datos Sakila usando cualquiera de estos métodos:

**Método 1: Conexión directa y carga (Recomendado)**
```bash
mysql -u root
```

Dentro del cliente MySQL:
```sql
SOURCE sakila_db/sakila.sql;
```

Para salir:
```sql
exit;
```

**Método 2: Carga directa desde terminal**
```bash
mysql -u root < sakila_db/sakila.sql
```

**Método 3: Crear base de datos específica y cargar**
```bash
mysql -u root -e "CREATE DATABASE IF NOT EXISTS sakila;"
mysql -u root sakila < sakila_db/sakila.sql
```

### Verificar la Instalación

Para confirmar que la base de datos se cargó correctamente:

```bash
mysql -u root -e "USE sakila; SHOW TABLES;"
```

```bash
mysql -u root -e "USE sakila; SELECT COUNT(*) FROM actor;"
```

### Detener MySQL

Para detener MySQL cuando termines de usar la aplicación:

```bash
sudo /usr/local/mysql/support-files/mysql.server stop
```

O si usaste Homebrew:
```bash
brew services stop mysql
```

### Comandos de Verificación

Para verificar que todo está funcionando correctamente:

```bash
# Verificar estado de MySQL
brew services list | grep mysql

# Verificar puerto MySQL (3306)
lsof -i :3306

# Verificar conexión a la base de datos
mysql -u root -e "SHOW DATABASES;"
```

## Ejecución de la Aplicación

### Inicio Completo del Sistema

Para ejecutar la aplicación text2sql, sigue estos pasos en orden:

#### 1. Iniciar MySQL
```bash
brew services start mysql
```

#### 2. Verificar que MySQL está funcionando
```bash
mysql -u root -e "USE sakila; SHOW TABLES;"
```

#### 3. Navegar al directorio del proyecto
```bash
cd "/Users/fernandoolea/Dev/Github Repos/text2sql-agent"
```

#### 4. Activar el entorno virtual
```bash
source .venv/bin/activate
```

#### 5. Ejecutar Chainlit
```bash
chainlit run front.py
```

#### 6. Acceder a la aplicación
La aplicación se abrirá automáticamente en tu navegador en:
- **URL:** `http://localhost:8000`
- **Interfaz:** Chat web interactivo

### Verificación del Sistema

Para confirmar que todo está funcionando:

```bash
# Verificar MySQL
brew services list | grep mysql
lsof -i :3306

# Verificar Chainlit
lsof -i :8000
ps aux | grep chainlit
```

### Cierre Completo del Sistema

Para cerrar todos los servicios correctamente:

#### 1. Detener Chainlit
En la terminal donde está ejecutándose Chainlit, presiona:
```
Ctrl + C
```

#### 2. Detener MySQL
```bash
brew services stop mysql
```

#### 3. Desactivar entorno virtual (opcional)
```bash
deactivate
```

### Verificación de Cierre

Para confirmar que todo se ha cerrado:

```bash
# Verificar que MySQL se detuvo
brew services list | grep mysql
# Debe mostrar "none"

# Verificar que no hay procesos corriendo
lsof -i :8000
lsof -i :3306
# No debe mostrar ningún proceso
```

### Solución de Problemas

#### Error de conexión a MySQL
```bash
# Verificar que sakila existe
mysql -u root -e "USE sakila; SHOW TABLES;"

# Si no existe, cargar la base de datos
mysql -u root
SOURCE sakila_db/sakila.sql;
exit;
```

#### Error de variables de entorno
```bash
# Verificar configuración
cat .env
```

#### Error de dependencias
```bash
# Reinstalar dependencias
pip install -r requirements.txt
```

#### Puerto ocupado
```bash
# Si el puerto 8000 está ocupado, usar otro puerto
chainlit run front.py --port 8001
```
