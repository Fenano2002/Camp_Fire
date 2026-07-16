import os
import pyodbc
import webbrowser
import threading
import time
import socket
from flask import Flask, render_template, jsonify, request, redirect, url_for, session, make_response

app = Flask(__name__)

app.secret_key = os.getenv('FLASK_SECRET_KEY', 'mi_clave_super_secreta_para_el_proyecto')

SERVER = os.getenv('DB_SERVER', 'localhost')
DATABASE = os.getenv('DB_DATABASE', 'ProyectoFinal')
DB_DRIVER = os.getenv('DB_DRIVER', 'ODBC Driver 17 for SQL Server')

CAMPOS_VISTA = {
    'Clientes': ['Nombre_Clien', 'Correo_Clien', 'Direccion_Clien', 'Telefono_Clien', 'Edad_Clien'],
    'Asociaciones': ['Nombre_Asoc', 'Direccion_Asoc', 'Telefono_Asoc', 'Correo_Asoc'],
    'Colonias': ['Nombre_Col', 'Direccion_Col', 'Telefono_Col', 'Correo_Col'],
    'Actividades': ['Descripcion_Act', 'Duracion_Act', 'Tipo_Act', 'Capacidad_Act'],
    'Líderes': ['Nombre_Lider', 'Edad_Lider', 'Direccion_Lider', 'Correo_Lider', 'Telefono_Lider'],
    'Lideres': ['Nombre_Lider', 'Edad_Lider', 'Direccion_Lider', 'Correo_Lider', 'Telefono_Lider'],
    'Certificaciones': ['Nombre_Cert', 'Grado_Cert', 'Fecha_Cert', 'Descripcion_Cert'],
    'Campamentos': ['Nombre_Camp', 'Ubicacion_Camp', 'Duracion_Camp', 'Telefono_Camp'],
    'Juegos': ['Descripcion_Juego', 'Cantidad_Part_Juego', 'Tipo_Juego', 'Duracion_Juego'],
    'Deportes': ['Descripcion_Deporte', 'Horas_Semanal_Deporte', 'Duracion_Deporte', 'Cantidad_Part_Deporte'],
    'Competencias': ['Nombre_Comp', 'Fecha_Comp', 'Descripcion_Comp', 'Cantidad_Part_Comp'],
    'Accesorios': ['Nombre_Acc', 'Tipo_Acc', 'Existencia_Acc', 'Color_Acc']
}

CAMPOS_MODIFICABLES = {
    'Clientes': ['Correo_Clien', 'Direccion_Clien', 'Telefono_Clien'],
    'Asociaciones': ['Correo_Asoc', 'Direccion_Asoc', 'Telefono_Asoc'],
    'Actividades': ['Duracion_Act', 'Capacidad_Act', 'Tipo_Act']
}

@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        usuario_ingresado = request.form['usuario']
        password_ingresada = request.form['password']
        recordar = request.form.get('remember')
        conexion_intento = f'DRIVER={{{DB_DRIVER}}};SERVER={SERVER};DATABASE={DATABASE};UID={usuario_ingresado};PWD={password_ingresada};TrustServerCertificate=yes'
        try:
            conexion = pyodbc.connect(conexion_intento)
            conexion.close()
            session['usuario_logeado'] = usuario_ingresado
            session['password_logeado'] = password_ingresada
            respuesta = make_response(redirect(url_for('inicio')))
            if recordar:
                respuesta.set_cookie('usuario_guardado', usuario_ingresado, max_age=30*24*60*60)
                respuesta.set_cookie('password_guardada', password_ingresada, max_age=30*24*60*60)
            else:
                respuesta.set_cookie('usuario_guardado', '', expires=0)
                respuesta.set_cookie('password_guardada', '', expires=0)
            return respuesta
        except pyodbc.Error:
            error = "Credenciales incorrectas o el usuario no existe"
    usuario_guardado = request.cookies.get('usuario_guardado', '')
    password_guardada = request.cookies.get('password_guardada', '')
    return render_template('login.html', error=error, usuario_guardado=usuario_guardado, password_guardada=password_guardada)

@app.route('/logout')
def logout():
    session.pop('usuario_logeado', None)
    session.pop('password_logeado', None)
    return redirect(url_for('login'))

@app.route('/')
def inicio():
    if 'usuario_logeado' not in session:
        return redirect(url_for('login'))
    return render_template('dashboard.html', nombre=session['usuario_logeado'])

@app.route('/altas', methods=['GET', 'POST'])
def altas():
    if 'usuario_logeado' not in session:
        return redirect(url_for('login'))
    tabla = request.args.get('tabla', 'Clientes')
    tablas_db = {
        'Clientes': 'FOM_Cliente',
        'Asociaciones': 'FOM_Asociacion',
        'Colonias': 'FOM_Colonia',
        'Actividades': 'FOM_Actividad',
        'Líderes': 'FOM_Lider',
        'Lideres': 'FOM_Lider',
        'Certificaciones': 'FOM_Certificacion',
        'Campamentos': 'FOM_Campamento',
        'Juegos': 'FOM_Juego',
        'Deportes': 'FOM_Deporte',
        'Competencias': 'FOM_Competencia',
        'Accesorios': 'FOM_Accesorio'
    }
    nombre_tabla_db = tablas_db.get(tabla, 'FOM_Cliente')
    registros = []
    columnas = []
    columnas_insert = []
    tipos_input = {}
    fk_options = {}
    error = None
    exito = None
    usuario_actual = session['usuario_logeado']
    password_actual = session['password_logeado']
    conexion_activa = f'DRIVER={{{DB_DRIVER}}};SERVER={SERVER};DATABASE={DATABASE};UID={usuario_actual};PWD={password_actual};TrustServerCertificate=yes'
    
    try:
        conexion = pyodbc.connect(conexion_activa)
        cursor = conexion.cursor()
        
        cursor.execute(f"SELECT TOP 0 * FROM {nombre_tabla_db}")
        columnas_completas = [column[0] for column in cursor.description]
        col_pk = columnas_completas[0]
        columnas_insert = [col for col in columnas_completas if col != col_pk]
        columnas = [col_pk] + columnas_insert

        for col in columnas_insert:
            col_lower = col.lower()
            if 'fk' in col_lower:
                tipos_input[col] = 'select'
                try:
                    if 'asoc' in col_lower:
                        cursor.execute("SELECT CVE_Asoc_PK, Nombre_Asoc FROM FOM_Asociacion")
                    elif 'lider' in col_lower:
                        cursor.execute("SELECT CVE_Lider_PK, Nombre_Lider FROM FOM_Lider")
                    elif 'act' in col_lower:
                        cursor.execute("SELECT CVE_Act_PK, Descripcion_Act FROM FOM_Actividad")
                    elif 'dep' in col_lower:
                        cursor.execute("SELECT CVE_Deporte_PK, Descripcion_Deporte FROM FOM_Deporte")
                    elif 'col' in col_lower:
                        cursor.execute("SELECT CVE_Col_PK, Nombre_Col FROM FOM_Colonia")
                    elif 'clien' in col_lower:
                        cursor.execute("SELECT CVE_Clien_PK, Nombre_Clien FROM FOM_Cliente")
                    
                    fk_options[col] = [{'id': row[0], 'desc': f"{row[0]} - {row[1]}"} for row in cursor.fetchall()]
                except Exception:
                    fk_options[col] = []
            else:
                tipos_input[col] = 'text'

        if request.method == 'POST':
            valores_form = [request.form.get(col, '').strip() for col in columnas_insert]
            errores_validacion = []
            
            for idx, col in enumerate(columnas_insert):
                if valores_form[idx] == '':
                    errores_validacion.append(f"El campo '{col.replace('_', ' ')}' es obligatorio.")

            if errores_validacion:
                error = " | ".join(errores_validacion)
            else:
                try:
                    cursor.execute(f"SELECT COLUMNPROPERTY(OBJECT_ID('{nombre_tabla_db}'), '{col_pk}', 'IsIdentity')")
                    resultado_identity = cursor.fetchone()
                    is_identity = resultado_identity[0] if resultado_identity else 0

                    cursor.execute(f"SELECT {col_pk} FROM {nombre_tabla_db} ORDER BY {col_pk}")
                    existing_ids = [row[0] for row in cursor.fetchall()]
                    nuevo_pk = 1
                    for eid in existing_ids:
                        if eid == nuevo_pk:
                            nuevo_pk += 1
                        else:
                            break

                    if is_identity == 1:
                        try:
                            cursor.execute(f"SET IDENTITY_INSERT {nombre_tabla_db} ON")
                            cols_str = ', '.join([col_pk] + columnas_insert)
                            placeholders = ', '.join(['?' for _ in ([nuevo_pk] + valores_form)])
                            query_insert = f"INSERT INTO {nombre_tabla_db} ({cols_str}) VALUES ({placeholders})"
                            cursor.execute(query_insert, [nuevo_pk] + valores_form)
                            cursor.execute(f"SET IDENTITY_INSERT {nombre_tabla_db} OFF")
                        except Exception as e_inner:
                            cursor.execute(f"SET IDENTITY_INSERT {nombre_tabla_db} OFF")
                            raise e_inner
                    else:
                        cols_str = ', '.join([col_pk] + columnas_insert)
                        placeholders = ', '.join(['?' for _ in ([nuevo_pk] + valores_form)])
                        query_insert = f"INSERT INTO {nombre_tabla_db} ({cols_str}) VALUES ({placeholders})"
                        cursor.execute(query_insert, [nuevo_pk] + valores_form)

                    conexion.commit()
                    
                    cols_str_select = ', '.join(columnas_insert)
                    cursor.execute(f"SELECT {col_pk}, {cols_str_select} FROM {nombre_tabla_db} WHERE {col_pk} = ?", nuevo_pk)
                    fila = cursor.fetchone()
                    if fila:
                        registros = [dict(zip(columnas, fila))]
                        exito = f"El registro se ha guardado exitosamente asignando la PK libre: {nuevo_pk}"
                except pyodbc.Error as e_db:
                    error = f"Error en la base de datos (Verifique Llaves Foráneas o Tipos de Dato): {str(e_db)}"
        conexion.close()
    except Exception as e:
        error = f"Error general: {str(e)}"
    
    return render_template('altas.html', nombre=session['usuario_logeado'], tabla=tabla, registros=registros, columnas=columnas, columnas_insert=columnas_insert, tipos_input=tipos_input, fk_options=fk_options, error=error, exito=exito)

@app.route('/consultas')
def consultas():
    if 'usuario_logeado' not in session:
        return redirect(url_for('login'))
    tabla = request.args.get('tabla', '')
    return render_template('consultas.html', nombre=session['usuario_logeado'], tabla=tabla)

@app.route('/api/buscar', methods=['POST'])
def api_buscar():
    if 'usuario_logeado' not in session:
        return jsonify({'error': 'No autorizado'}), 401
    datos = request.get_json()
    tabla = datos.get('tabla', 'Clientes')
    termino = datos.get('termino', '')
    
    tablas_db = {
        'Clientes': 'FOM_Cliente',
        'Asociaciones': 'FOM_Asociacion',
        'Colonias': 'FOM_Colonia',
        'Actividades': 'FOM_Actividad',
        'Líderes': 'FOM_Lider',
        'Lideres': 'FOM_Lider',
        'Certificaciones': 'FOM_Certificacion',
        'Campamentos': 'FOM_Campamento',
        'Juegos': 'FOM_Juego',
        'Deportes': 'FOM_Deporte',
        'Competencias': 'FOM_Competencia',
        'Accesorios': 'FOM_Accesorio'
    }
    nombre_tabla_db = tablas_db.get(tabla, 'FOM_Cliente')
    columnas_select = CAMPOS_VISTA.get(tabla, [])
    
    usuario_actual = session['usuario_logeado']
    password_actual = session['password_logeado']
    conexion_activa = f'DRIVER={{{DB_DRIVER}}};SERVER={SERVER};DATABASE={DATABASE};UID={usuario_actual};PWD={password_actual};TrustServerCertificate=yes'
    
    try:
        conexion = pyodbc.connect(conexion_activa)
        cursor = conexion.cursor()
        
        if columnas_select:
            cols_str = ', '.join(columnas_select)
            
            if not termino:
                query = f"SELECT {cols_str} FROM {nombre_tabla_db}"
                cursor.execute(query)
            else:
                condiciones = " OR ".join([f"CAST({col} AS VARCHAR(255)) LIKE ?" for col in columnas_select])
                query = f"SELECT {cols_str} FROM {nombre_tabla_db} WHERE {condiciones}"
                params = [f"%{termino}%" for _ in columnas_select]
                cursor.execute(query, params)
                
            registros = []
            for fila in cursor.fetchall():
                row_dict = {}
                for idx, col in enumerate(columnas_select):
                    val = fila[idx]
                    row_dict[col] = str(val) if val is not None else "N/A"
                registros.append(row_dict)
                
        conexion.close()
        return jsonify({'columnas': columnas_select, 'registros': registros})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/modificaciones')
def modificaciones():
    if 'usuario_logeado' not in session:
        return redirect(url_for('login'))
    tabla = request.args.get('tabla', '')
    
    if tabla and tabla not in ['Clientes', 'Asociaciones', 'Actividades']:
        return redirect(url_for('modificaciones'))
        
    columnas_edit = CAMPOS_MODIFICABLES.get(tabla, [])
    return render_template('modificaciones.html', nombre=session['usuario_logeado'], tabla=tabla, columnas_edit=columnas_edit)

@app.route('/api/buscar_pk', methods=['POST'])
def api_buscar_pk():
    if 'usuario_logeado' not in session:
        return jsonify({'error': 'No autorizado'}), 401
    datos = request.get_json()
    tabla = datos.get('tabla', '')
    id_pk = datos.get('id_pk', '')
    
    if tabla not in ['Clientes', 'Asociaciones', 'Actividades']:
        return jsonify({'error': 'Tabla no permitida para modificación'}), 400

    tablas_db = {
        'Clientes': 'FOM_Cliente',
        'Asociaciones': 'FOM_Asociacion',
        'Actividades': 'FOM_Actividad'
    }
    nombre_tabla_db = tablas_db.get(tabla)
    campos_permitidos = CAMPOS_MODIFICABLES.get(tabla, [])
    
    usuario_actual = session['usuario_logeado']
    password_actual = session['password_logeado']
    conexion_activa = f'DRIVER={{{DB_DRIVER}}};SERVER={SERVER};DATABASE={DATABASE};UID={usuario_actual};PWD={password_actual};TrustServerCertificate=yes'
    
    try:
        conexion = pyodbc.connect(conexion_activa)
        cursor = conexion.cursor()
        cursor.execute(f"SELECT TOP 0 * FROM {nombre_tabla_db}")
        col_pk = cursor.description[0][0]
        
        if not campos_permitidos:
            return jsonify({'error': 'No hay campos editables permitidos para esta tabla'}), 400
            
        cols_str = ', '.join(campos_permitidos)
        cursor.execute(f"SELECT {cols_str} FROM {nombre_tabla_db} WHERE {col_pk} = ?", id_pk)
        fila = cursor.fetchone()
        conexion.close()
        
        if fila:
            registro = {}
            for idx, col in enumerate(campos_permitidos):
                val = fila[idx]
                registro[col] = str(val) if val is not None else ""
            return jsonify({'encontrado': True, 'registro': registro})
        else:
            return jsonify({'encontrado': False})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/actualizar', methods=['POST'])
def api_actualizar():
    if 'usuario_logeado' not in session:
        return jsonify({'error': 'No autorizado'}), 401
    datos = request.get_json()
    tabla = datos.get('tabla', '')
    id_pk = datos.get('id_mod', '')
    campo = datos.get('campo', '')
    valor = datos.get('valor', '')
    
    if tabla not in ['Clientes', 'Asociaciones', 'Actividades']:
        return jsonify({'error': 'Operación no permitida en esta tabla'}), 400
        
    campos_permitidos = CAMPOS_MODIFICABLES.get(tabla, [])
    if campo not in campos_permitidos:
        return jsonify({'error': 'Este campo no está expuesto ni permitido para edición'}), 400

    tablas_db = {
        'Clientes': 'FOM_Cliente',
        'Asociaciones': 'FOM_Asociacion',
        'Actividades': 'FOM_Actividad'
    }
    nombre_tabla_db = tablas_db.get(tabla)
    
    usuario_actual = session['usuario_logeado']
    password_actual = session['password_logeado']
    conexion_activa = f'DRIVER={{{DB_DRIVER}}};SERVER={SERVER};DATABASE={DATABASE};UID={usuario_actual};PWD={password_actual};TrustServerCertificate=yes'
    
    try:
        conexion = pyodbc.connect(conexion_activa)
        cursor = conexion.cursor()
        cursor.execute(f"SELECT TOP 0 * FROM {nombre_tabla_db}")
        col_pk = cursor.description[0][0]
        
        query = f"UPDATE {nombre_tabla_db} SET {campo} = ? WHERE {col_pk} = ?"
        cursor.execute(query, (valor, id_pk))
        conexion.commit()
        conexion.close()
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/bajas')
def bajas():
    if 'usuario_logeado' not in session:
        return redirect(url_for('login'))
    tabla = request.args.get('tabla', 'Clientes')
    return render_template('bajas.html', nombre=session['usuario_logeado'], tabla=tabla)

@app.route('/api/buscar_baja_pk', methods=['POST'])
def api_buscar_baja_pk():
    if 'usuario_logeado' not in session:
        return jsonify({'error': 'No autorizado'}), 401
    datos = request.get_json()
    tabla = datos.get('tabla', '')
    id_pk = datos.get('id_pk', '')
    
    tablas_db = {
        'Clientes': 'FOM_Cliente',
        'Asociaciones': 'FOM_Asociacion',
        'Colonias': 'FOM_Colonia',
        'Actividades': 'FOM_Actividad',
        'Líderes': 'FOM_Lider',
        'Lideres': 'FOM_Lider',
        'Certificaciones': 'FOM_Certificacion',
        'Campamentos': 'FOM_Campamento',
        'Juegos': 'FOM_Juego',
        'Deportes': 'FOM_Deporte',
        'Competencias': 'FOM_Competencia',
        'Accesorios': 'FOM_Accesorio'
    }
    nombre_tabla_db = tablas_db.get(tabla)
    if not nombre_tabla_db:
        return jsonify({'error': 'Tabla no válida'}), 400
        
    usuario_actual = session['usuario_logeado']
    password_actual = session['password_logeado']
    conexion_activa = f'DRIVER={{{DB_DRIVER}}};SERVER={SERVER};DATABASE={DATABASE};UID={usuario_actual};PWD={password_actual};TrustServerCertificate=yes'
    
    try:
        conexion = pyodbc.connect(conexion_activa)
        cursor = conexion.cursor()
        cursor.execute(f"SELECT TOP 0 * FROM {nombre_tabla_db}")
        col_pk = cursor.description[0][0]
        col_desc = cursor.description[1][0] if len(cursor.description) > 1 else col_pk
        
        cursor.execute(f"SELECT {col_desc} FROM {nombre_tabla_db} WHERE {col_pk} = ?", id_pk)
        fila = cursor.fetchone()
        conexion.close()
        
        if fila:
            return jsonify({'encontrado': True, 'descripcion': fila[0]})
        else:
            return jsonify({'encontrado': False})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/eliminar', methods=['POST'])
def api_eliminar():
    if 'usuario_logeado' not in session:
        return jsonify({'error': 'No autorizado'}), 401
    datos = request.get_json()
    tabla = datos.get('tabla', '')
    id_baja = datos.get('id_baja', '')
    
    tablas_db = {
        'Clientes': 'FOM_Cliente',
        'Asociaciones': 'FOM_Asociacion',
        'Colonias': 'FOM_Colonia',
        'Actividades': 'FOM_Actividad',
        'Líderes': 'FOM_Lider',
        'Lideres': 'FOM_Lider',
        'Certificaciones': 'FOM_Certificacion',
        'Campamentos': 'FOM_Campamento',
        'Juegos': 'FOM_Juego',
        'Deportes': 'FOM_Deporte',
        'Competencias': 'FOM_Competencia',
        'Accesorios': 'FOM_Accesorio'
    }
    nombre_tabla_db = tablas_db.get(tabla)
    if not nombre_tabla_db:
        return jsonify({'error': 'Tabla no válida'}), 400
        
    usuario_actual = session['usuario_logeado']
    password_actual = session['password_logeado']
    conexion_activa = f'DRIVER={{{DB_DRIVER}}};SERVER={SERVER};DATABASE={DATABASE};UID={usuario_actual};PWD={password_actual};TrustServerCertificate=yes'
    
    try:
        conexion = pyodbc.connect(conexion_activa)
        cursor = conexion.cursor()
        cursor.execute(f"SELECT TOP 0 * FROM {nombre_tabla_db}")
        col_pk = cursor.description[0][0]
        
        query = f"DELETE FROM {nombre_tabla_db} WHERE {col_pk} = ?"
        cursor.execute(query, id_baja)
        conexion.commit()
        conexion.close()
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/datos')
def obtener_datos():
    if 'usuario_logeado' not in session:
        return jsonify({"error": "No autorizado"}), 401
    try:
        usuario_actual = session['usuario_logeado']
        password_actual = session['password_logeado']
        conexion_activa = f'DRIVER={{{DB_DRIVER}}};SERVER={SERVER};DATABASE={DATABASE};UID={usuario_actual};PWD={password_actual};TrustServerCertificate=yes'
        conexion = pyodbc.connect(conexion_activa)
        cursor = conexion.cursor()
        
        columnas_select = CAMPOS_VISTA.get('Clientes', [])
        cols_str = ', '.join(columnas_select)
        cursor.execute(f"SELECT {cols_str} FROM FOM_Cliente")
        
        resultados = []
        for fila in cursor.fetchall():
            resultados.append(dict(zip(columnas_select, fila)))
        conexion.close()
        return jsonify(resultados)
    except Exception as e:
        return jsonify({"error": str(e)})

def is_port_in_use(port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        return s.connect_ex(('127.0.0.1', port)) == 0

def open_browser():
    while not is_port_in_use(port):
        time.sleep(0.1)
    webbrowser.open_new('http://127.0.0.1:5000/login')

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    if SERVER == 'localhost' and not is_port_in_use(port):
        threading.Thread(target=open_browser, daemon=True).start()
    app.run(host='0.0.0.0', port=port, debug=True)