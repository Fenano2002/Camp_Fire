# Sistema de Gestión de Campamentos y Actividades

Este proyecto consiste en una aplicación web de gestión integral diseñada para administrar bases de datos relacionales orientadas a la organización de campamentos, deportes, actividades y control de clientes. La plataforma permite realizar operaciones completas de Altas, Bajas, Cambios y Consultas (CRUD) de manera segura y dinámica.

## Características Principales

* **Control de Acceso Seguro (Login):** Autenticación basada en usuarios del DBMS que vincula las sesiones directamente con permisos específicos a nivel base de datos.
* **Manejo Dinámico de Formularios:** Carga automática de llaves foráneas en menús desplegables (`<select>`) para facilitar la integridad referencial durante las altas.
* **Arquitectura CRUD Completa:** * **Altas:** Asignación inteligente de identificadores (PK) disponibles mediante escaneo de huecos en la secuencia numérica.
  * **Consultas:** Buscador en tiempo real que aplica filtros dinámicos con operadores `LIKE` sobre múltiples columnas simultáneamente.
  * **Modificaciones:** Restricción selectiva de campos editables en tablas clave para mantener la consistencia del negocio.
  * **Bajas:** Eliminación directa basada en identificadores únicos con validación previa de existencia.

## Tecnologías Utilizadas

* **Backend:** Python, Flask, WSGI (Gunicorn para producción)
* **Base de Datos:** SQL Server (T-SQL)
* **Conectividad:** pyodbc (ODBC Driver para SQL Server)
* **Frontend:** HTML5, CSS Grids / Flexbox (Diseño limpio y estructurado), JavaScript (Fetch API para peticiones asíncronas)
* **Gestión de Entorno:** Python-dotenv

## Arquitectura del Proyecto

├── static/          # Archivos CSS y JavaScript..........................................................................................................................................................................................................
├── templates/       # Vistas HTML (Login, Dashboard, Altas, Consultas, etc.)..........................................................................................................................................................................................................
├── .gitignore       # Exclusiones de Git..........................................................................................................................................................................................................
├── app.py           # Servidor backend y lógica de rutas de Flask..........................................................................................................................................................................................................
├── README.md        # Documentación del proyecto..........................................................................................................................................................................................................
└── requirements.txt # Dependencias del sistema

## Configuración e Instalación

1. Clonar el repositorio:

git clone [https://github.com/Fenano2002/Camp-Fire.git](https://github.com/Fenano2002/Camp-Fire.git)
cd Camp_Fire

2. Crear e iniciar un entorno virtual:

* **En Windows:

python -m venv venv
venv\Scripts\activate

* **En macOS/Linux:

python3 -m venv venv
source venv/bin/activate

3. Instalar las dependencias necesarias:

pip install -r requirements.txt

4. Configurar las variables de entorno:
Crea un archivo llamado .env en la raíz del proyecto y agrega lo siguiente:

Plaintext
FLASK_SECRET_KEY=mi_clave_super_secreta_para_el_proyecto
DB_SERVER=localhost
DB_DATABASE=ProyectoFinal
DB_DRIVER=ODBC Driver 17 for SQL Server
PORT=5000

5. Ejecutar la aplicación en modo desarrollo:

python app.py
