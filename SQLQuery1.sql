CREATE DATABASE Pruebas;

USE Pruebas;
USE ProyectoFinal;

CREATE TABLE FOM_Asociacion (
	CVE_Asoc_PK  INT PRIMARY KEY IDENTITY(1,1),
	Nombre_Asoc VARCHAR(20),
	Direccion_Asoc VARCHAR(20),
	Telefono_Asoc VARCHAR(10),
	Correo_Asoc VARCHAR(30)
);

CREATE TABLE FOM_Colonia (
	CVE_Col_PK  INT PRIMARY KEY IDENTITY(1,1),
	Nombre_Col VARCHAR(20),
	Direccion_Col VARCHAR(20),
	Telefono_Col VARCHAR(10),
	Correo_Col VARCHAR(30),
	CVE_Asoc_FK INT	FOREIGN KEY REFERENCES FOM_Asociacion(CVE_Asoc_PK)
);

CREATE TABLE FOM_Cliente (
	CVE_Clien_PK  INT PRIMARY KEY IDENTITY(1,1),
	Nombre_Clien VARCHAR(20),
	Correo_Clien VARCHAR(30),
	Direccion_Clien VARCHAR(20),
	Telefono_Clien VARCHAR(10),
	Edad_Clien INT,
);

CREATE TABLE FOM_Actividad (
	CVE_Act_PK  INT PRIMARY KEY IDENTITY(1,1),
	Descripcion_Act VARCHAR(30),
	Duracion_Act INT,
	Tipo_Act VARCHAR(20),
	Capacidad_Act INT,
);

CREATE TABLE FOM_Lider (
	CVE_Lider_PK  INT PRIMARY KEY IDENTITY(1,1),
	Nombre_Lider VARCHAR(20),
	Edad_Lider INT,
	Direccion_Lider VARCHAR(20),
	Correo_Lider VARCHAR(30),
	Telefono_Lider VARCHAR(10),
	CVE_Asoc_FK INT FOREIGN KEY REFERENCES FOM_Asociacion(CVE_Asoc_PK)
);

CREATE TABLE FOM_Certificacion (
	CVE_Cert_PK  INT PRIMARY KEY IDENTITY(1,1),
	Nombre_Cert VARCHAR(20),
	Grado_Cert VARCHAR(10),
	Fecha_Cert VARCHAR(10),
	Descripcion_Cert VARCHAR(25),
	CVE_Lider_FK INT FOREIGN KEY REFERENCES FOM_Lider(CVE_Lider_PK),
	CVE_Asoc1_FK INT FOREIGN KEY REFERENCES FOM_Asociacion(CVE_Asoc_PK)
);

CREATE TABLE FOM_Campamento (
	CVE_Camp_PK  INT PRIMARY KEY IDENTITY(1,1),
	Nombre_Camp VARCHAR(20),
	Ubicacion_Camp VARCHAR(25),
	Duracion_Camp INT,
	Telefono_Camp VARCHAR(10),
	CVE_Act1_FK INT FOREIGN KEY REFERENCES FOM_Actividad(CVE_Act_PK)
);

CREATE TABLE FOM_Juego (
	CVE_Juego_PK  INT PRIMARY KEY IDENTITY(1,1),
	Descripcion_Juego VARCHAR(25),
	Cantidad_Part_Juego INT,
	Tipo_Juego VARCHAR(20),
	Duracion_Juego INT,
	CVE_Act2_FK INT FOREIGN KEY REFERENCES FOM_Actividad(CVE_Act_PK)
);

CREATE TABLE FOM_Deporte (
	CVE_Deporte_PK  INT PRIMARY KEY IDENTITY(1,1),
	Descripcion_Deporte VARCHAR(25),
	Horas_Semanal_Deporte INT,
	Duracion_Deporte INT,
	Cantidad_Part_Deporte INT,
	CVE_Act3_FK INT FOREIGN KEY REFERENCES FOM_Actividad(CVE_Act_PK)
);

CREATE TABLE FOM_Competencia (
	CVE_Comp_PK  INT PRIMARY KEY IDENTITY(1,1),
	Nombre_Comp VARCHAR(20),
	Fecha_Comp VARCHAR(10),
	Descripcion_Comp VARCHAR(25),
	Cantidad_Part_Comp INT,
	CVE_Deporte_FK INT FOREIGN KEY REFERENCES FOM_Deporte(CVE_Deporte_PK)
);

CREATE TABLE FOM_Accesorio (
	CVE_Acc_PK  INT PRIMARY KEY IDENTITY(1,1),
	Nombre_Acc VARCHAR(20),
	Tipo_Acc VARCHAR(20),
	Existencia_Acc INT,
	Color_Acc VARCHAR(15),
	CVE_Dep1_FK INT FOREIGN KEY REFERENCES FOM_Deporte(CVE_Deporte_PK)
);

CREATE TABLE FOM_Colonia_Cliente (
	CVE_Colien_PK  INT PRIMARY KEY IDENTITY(1,1),
	CVE_Col_FK INT FOREIGN KEY REFERENCES FOM_Colonia(CVE_Col_PK),
	CVE_Clien_FK INT FOREIGN KEY REFERENCES FOM_Cliente(CVE_Clien_PK)
);

CREATE TABLE FOM_Colonia_Lider (
	CVE_Colider_PK  INT PRIMARY KEY IDENTITY(1,1),
	CVE_Col1_FK INT FOREIGN KEY REFERENCES FOM_Colonia(CVE_Col_PK),
	CVE_Lider1_FK INT FOREIGN KEY REFERENCES FOM_Lider(CVE_Lider_PK)
);

CREATE TABLE FOM_Cliente_Actividad (
	CVE_Clienact_PK  INT PRIMARY KEY IDENTITY(1,1),
	CVE_Clien1_FK INT FOREIGN KEY REFERENCES FOM_Cliente(CVE_Clien_PK),
	CVE_Act4_FK INT FOREIGN KEY REFERENCES FOM_Actividad(CVE_Act_PK)
);

Select * from FOM_Cliente_Actividad

INSERT INTO FOM_Cliente (Nombre_Clien, Correo_Clien, Direccion_Clien, Telefono_Clien, Edad_Clien) 
VALUES ('Laura Cruz', 'Laura_Cruz@gmail.com', 'Ecatepec', '5531234231', 2),
('Aide Arevalo', 'Aide_Ar@gmail.com', 'Nezahualcoyotl', '5531234232', 1),
('Sofia Hernandez', 'Sofia_Hdz@gmail.com', 'Naucalpan', '5531234233', 3),
('Diego Ramirez', 'Diego_Ram@gmail.com', 'Tlalnepantla', '5531234234', 5),
('Valeria Gomez', 'Vale_Gomez@gmail.com', 'Ecatepec', '5531234235', 4);

INSERT INTO FOM_Asociacion (Nombre_Asoc, Direccion_Asoc, Telefono_Asoc, Correo_Asoc)
VALUES ('Fed. de Futbol', 'Av. Principal 2', '5551234567', 'FedFUT@gmail.com'),
('Asoc. Basquet', 'Secundaria 4', '5559876543', 'AsBaquet@gmail.com'),
('Club de Tenis', 'Av. Central 7', '5555678901', 'Tenis@gmail.com'),
('Asoc. Natacion', 'Av. del Mar 3', '5552468101', 'Natacion@gmail.com'),
('Fed. Atletismo', 'Call. Deporte 6', '5551357913', 'Atletismo@gmail.com');

INSERT INTO FOM_Colonia (Nombre_Col, Direccion_Col, Telefono_Col, Correo_Col, CVE_Asoc_FK)
VALUES ('Valle Hermoso', 'Tlalnepantla', '5512345678', 'ValleH@gmail.com', 3),
('Jardines de Sol', 'Naucalpan', '5512345679', 'JardinesS@gmail.com', 4),
('Bosques Lomas', 'Cuautitlan', '5512345680', 'BosquesL@gmail.com', 1),
('Lomas Verdes', 'Naucalpan', '5512345681', 'LomasV@gmail.com', 2),
('Santa Fe', 'Santa Fe', '5512345682', 'SantaFe@gmail.com', 5);

INSERT INTO FOM_Actividad (Descripcion_Act, Duracion_Act, Tipo_Act, Capacidad_Act)
VALUES ('Torneo Futbol', 120, 'Deportivo', 22),
('Clase Natacion', 60, 'Formativo', 10),
('Taller Pintura', 90, 'Recreativo', 15),
('Carrera Relevos', 45, 'Competitivo', 16),
('Campamento Base', 240, 'Excursion', 30);

INSERT INTO FOM_Lider (Nombre_Lider, Edad_Lider, Direccion_Lider, Correo_Lider, Telefono_Lider, CVE_Asoc_FK)
VALUES ('Carlos Perez', 25, 'Ecatepec', 'Carlo@gmail.com', '5522334455', 1),
('Ana Gomez', 28, 'Naucalpan', 'AnaGo@gmail.com', '5511223344', 2),
('Luis Martinez', 30, 'Tlalnepantla', 'LuisM@gmail.com', '5544556677', 3),
('Rosa Silva', 26, 'Santa Fe', 'RosaS@gmail.com', '5588990011', 4),
('Jose Diaz', 29, 'Cuautitlan', 'JoseD@gmail.com', '5566778899', 5);

INSERT INTO FOM_Certificacion (Nombre_Cert, Grado_Cert, Fecha_Cert, Descripcion_Cert, CVE_Lider_FK, CVE_Asoc1_FK)
VALUES ('Cert Primeros', 'Basico', '2023-01-15', 'Primeros auxilios', 1, 1),
('Cert Rescate', 'Avanzado', '2023-02-20', 'Rescate acuatico', 2, 4),
('Cert Arbitro', 'Medio', '2023-03-10', 'Arbitraje oficial', 3, 3),
('Cert Coach', 'Basico', '2023-04-05', 'Entrenador base', 4, 2),
('Cert Nutricion', 'Avanzado', '2023-05-12', 'Nutricion depor', 5, 5);

INSERT INTO FOM_Campamento (Nombre_Camp, Ubicacion_Camp, Duracion_Camp, Telefono_Camp, CVE_Act1_FK)
VALUES ('Camp Verano', 'Valle de Bravo', 72, '5599887766', 5),
('Camp Aventura', 'Huasca', 48, '5588776655', 5),
('Camp Deportivo', 'Oaxtepec', 96, '5577665544', 1),
('Camp Extremo', 'Jalcomulco', 120, '5566554433', 4),
('Camp Bosque', 'Ajusco', 24, '5555443322', 3);

INSERT INTO FOM_Juego (Descripcion_Juego, Cantidad_Part_Juego, Tipo_Juego, Duracion_Juego, CVE_Act2_FK)
VALUES ('Partido Amistoso', 22, 'Futbol', 90, 1),
('Relevos 4x100', 8, 'Atletismo', 15, 4),
('Pinta tu mural', 10, 'Arte', 60, 3),
('Busqueda Tesoro', 15, 'Estrategia', 45, 5),
('Clavados Libres', 6, 'Acuatico', 30, 2);

INSERT INTO FOM_Deporte (Descripcion_Deporte, Horas_Semanal_Deporte, Duracion_Deporte, Cantidad_Part_Deporte, CVE_Act3_FK)
VALUES ('Futbol Soccer', 10, 90, 22, 1),
('Natacion Libre', 5, 60, 10, 2),
('Atletismo Pista', 8, 120, 15, 4),
('Basquetbol 3x3', 6, 40, 6, 1),
('Tenis Dobles', 4, 90, 4, 3);

INSERT INTO FOM_Competencia (Nombre_Comp, Fecha_Comp, Descripcion_Comp, Cantidad_Part_Comp, CVE_Deporte_FK)
VALUES ('Liga Infantil', '2024-01-10', 'Torneo menores', 22, 1),
('Copa Acuatica', '2024-02-15', 'Nado sincronizado', 10, 2),
('Carrera 5K', '2024-03-20', 'Maraton local', 50, 3),
('Torneo Rafaga', '2024-04-25', 'Eliminatoria basket', 12, 4),
('Open Tenis', '2024-05-30', 'Dobles mixto', 8, 5);

INSERT INTO FOM_Accesorio (Nombre_Acc, Tipo_Acc, Existencia_Acc, Color_Acc, CVE_Dep1_FK)
VALUES ('Balon Futbol', 'Pelota', 50, 'Blanco', 1),
('Goggles', 'Proteccion', 30, 'Azul', 2),
('Testigo', 'Relevo', 20, 'Rojo', 3),
('Balon Basquet', 'Pelota', 40, 'Naranja', 4),
('Raqueta', 'Golpeo', 25, 'Verde', 5);

INSERT INTO FOM_Colonia_Cliente (CVE_Col_FK, CVE_Clien_FK)
VALUES (1, 4),
(2, 3),
(4, 2),
(5, 5),
(1, 1);

INSERT INTO FOM_Colonia_Lider (CVE_Col1_FK, CVE_Lider1_FK)
VALUES (1, 3),
(2, 2),
(3, 5),
(4, 4),
(5, 1);

INSERT INTO FOM_Cliente_Actividad (CVE_Clien1_FK, CVE_Act4_FK)
VALUES (1, 1),
(2, 3),
(3, 2),
(4, 4),
(5, 5);

ALTER TABLE FOM_Campamento
ADD Descripcion_Camp VARCHAR(25);

ALTER TABLE FOM_Juego
ADD Nombre_Juego VARCHAR(15);

ALTER TABLE FOM_Deporte
ADD Nombre_Deporte VARCHAR(15);

CREATE VIEW V_Cliente_Colonia AS
SELECT c.Nombre_Clien, c.Correo_Clien, col.Nombre_Col, col.Direccion_Col
FROM FOM_Cliente c
INNER JOIN FOM_Colonia_Cliente cc ON c.CVE_Clien_PK = cc.CVE_Clien_FK
INNER JOIN FOM_Colonia col ON cc.CVE_Col_FK = col.CVE_Col_PK;

CREATE VIEW V_Lider_Certificacion AS
SELECT l.Nombre_Lider, c.Nombre_Cert, c.Grado_Cert, c.Fecha_Cert
FROM FOM_Lider l
INNER JOIN FOM_Certificacion c ON l.CVE_Lider_PK = c.CVE_Lider_FK;

CREATE VIEW V_Campamento_Actividad AS
SELECT camp.Nombre_Camp, camp.Ubicacion_Camp, camp.Duracion_Camp, act.Descripcion_Act, act.Tipo_Act
FROM FOM_Campamento camp
INNER JOIN FOM_Actividad act ON camp.CVE_Act1_FK = act.CVE_Act_PK;

CREATE INDEX IX_Cliente_Correo 
ON FOM_Cliente(Correo_Clien);

CREATE INDEX IX_Actividad_Tipo 
ON FOM_Actividad(Tipo_Act);

CREATE INDEX IX_Lider_Nombre 
ON FOM_Lider(Nombre_Lider);

UPDATE FOM_Cliente 
SET Edad_Clien = 3 
WHERE Nombre_Clien = 'Laura Cruz';

UPDATE FOM_Accesorio 
SET Color_Acc = 'Blanco y Negro' 
WHERE Nombre_Acc = 'Balon Futbol';

UPDATE FOM_Actividad 
SET Capacidad_Act = 25 
WHERE Descripcion_Act = 'Torneo Futbol';

DELETE FROM FOM_Juego 
WHERE CVE_Juego_PK = 5;

DELETE FROM FOM_Accesorio 
WHERE CVE_Acc_PK = 1;

DELETE FROM FOM_Competencia 
WHERE CVE_Comp_PK = 3;

SELECT * FROM FOM_Asociacion;
SELECT * FROM FOM_Colonia;
SELECT * FROM FOM_Actividad;
SELECT * FROM FOM_Lider;
SELECT * FROM FOM_Certificacion;
SELECT * FROM FOM_Campamento;
SELECT * FROM FOM_Juego;
SELECT * FROM FOM_Deporte;
SELECT * FROM FOM_Competencia;
SELECT * FROM FOM_Accesorio;
SELECT * FROM FOM_Colonia_Cliente;
SELECT * FROM FOM_Colonia_Lider;
SELECT * FROM FOM_Cliente_Actividad;

CREATE LOGIN Fernando WITH PASSWORD = 'Password123!';

CREATE USER FernandoORT FOR LOGIN Fernando;
ALTER ROLE db_datareader ADD MEMBER FernandoORT;
ALTER ROLE db_datawriter ADD MEMBER FernandoORT;

SELECT Descripcion_Act, Duracion_Act AS Duracion_Min
From FOM_Actividad 
Where Duracion_Act =(Select MIN (Duracion_Act) from FOM_Actividad);

SELECT Descripcion_Act, Duracion_Act AS Duracion_Max
From FOM_Actividad 
Where Duracion_Act =(Select MAX (Duracion_Act) from FOM_Actividad);

SELECT Descripcion_Act, Duracion_Act,(SELECT AVG(Duracion_Act) FROM FOM_Actividad) AS Promedio_Dur_Act from FOM_Actividad;

CREATE PROCEDURE CP_FOM_ACTIVIDAD_DURACION
@Duracion_Act INT,
@No_Minutos INT
AS
BEGIN TRY
	BEGIN TRAN
	UPDATE FOM_Actividad
	SET Duracion_Act = Duracion_Act + @No_Minutos
	WHERE Duracion_Act < @Duracion_Act
	SELECT Descripcion_Act,Duracion_Act, @No_Minutos As Minutos_Agregados FROM FOM_Actividad
	WHERE Duracion_Act < @Duracion_Act
COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
END CATCH;

EXEC CP_FOM_ACTIVIDAD_DURACION @Duracion_Act = 100, @No_Minutos = 2;

DECLARE @MaxID INT;
SELECT @MaxID = ISNULL(MAX(CVE_Clien_PK), 0) FROM FOM_Cliente;
DBCC CHECKIDENT ('FOM_Cliente', RESEED, @MaxID);


CREATE TABLE FOM_CONTROL_ACTIVIDAD (
ID_Actividad_PK INT,
Fecha VARCHAR(12),
Hora VARCHAR (12),
Usuario VARCHAR (25),
Estado VARCHAR (10)
);

/* PROCEDURE Y TRIGGER ALTAS */
CREATE PROCEDURE CP_FOM_ALTAS_ACTIVIDAD
@Descripcion_Act VARCHAR(30),
@Duracion_Act INT,
@Tipo_Act VARCHAR(20),
@Capacidad_Act INT
AS
INSERT INTO FOM_Actividad (Descripcion_Act, Duracion_Act, Tipo_Act, Capacidad_Act)
VALUES (@Descripcion_Act, @Duracion_Act, @Tipo_Act, @Capacidad_Act)
SELECT * FROM FOM_Actividad;
EXEC CP_FOM_ALTAS_ACTIVIDAD @Descripcion_Act = 'Yoga Matutino', @Duracion_Act = 60, @Tipo_Act = 'Recreativo', @Capacidad_Act = 20;

CREATE TRIGGER CT_FOM_ALTAS_ACTIVIDAD
ON FOM_ACTIVIDAD
FOR INSERT
AS
    INSERT INTO FOM_CONTROL_ACTIVIDAD (ID_Actividad_PK, Fecha, Hora, Usuario, Estado)
SELECT inserted.CVE_Act_PK, (SELECT CONVERT(VARCHAR, GETDATE(),103)),
(SELECT CONVERT(VARCHAR, GETDATE(), 108)), SUSER_NAME(), 'ALTA'
FROM inserted
	
	SELECT * FROM FOM_CONTROL_ACTIVIDAD
    SELECT * FROM inserted;

/*PROCEDURE BAJAS*/
CREATE PROCEDURE CP_FOM_BAJAS_ACTIVIDAD
@CVE_Act_PK INT
AS
DELETE FROM FOM_Actividad
WHERE CVE_Act_PK = @CVE_Act_PK
SELECT * FROM FOM_Actividad;
EXEC CP_FOM_BAJAS_ACTIVIDAD @CVE_Act_PK = 2;

CREATE TRIGGER CT_FOM_Eliminar_Aactividad
ON FOM_Actividad
INSTEAD OF DELETE
AS 
UPDATE FOM_Cliente_Actividad
SET CVE_Act4_FK=NULL
FROM deleted
WHERE CVE_Act4_FK=deleted.CVE_Act_PK

UPDATE FOM_Juego
SET CVE_Act2_FK=NULL
FROM deleted
WHERE CVE_Act2_FK=deleted.CVE_Act_PK

UPDATE FOM_Deporte
SET CVE_Act3_FK=NULL
FROM deleted
WHERE CVE_Act3_FK=deleted.CVE_Act_PK

	DELETE 
	FROM FOM_Actividad
	FROM deleted
	WHERE FOM_Actividad.CVE_Act_PK = deleted.CVE_Act_PK

INSERT INTO FOM_CONTROL_ACTIVIDAD (ID_Actividad_PK, Fecha, Hora, Usuario, Estado)
SELECT deleted.CVE_Act_PK, (SELECT CONVERT(VARCHAR, GETDATE(),103)),
(SELECT CONVERT(VARCHAR, GETDATE(), 108)), SUSER_NAME(), 'ELIMINAR'
FROM deleted
	
	SELECT * FROM FOM_CONTROL_ACTIVIDAD
	SELECT * FROM FOM_Juego
	SELECT * FROM FOM_Cliente_Actividad
	SELECT * FROM FOM_Deporte
	SELECT * FROM FOM_Actividad
	SELECT * FROM deleted;

/*PROCEDURE ACTUALIZAR*/
CREATE PROCEDURE CP_FOM_ACTUALIZAR_ACTIVIDAD
@CVE_Act_PK INT,
@Duracion_Act INT
AS
UPDATE FOM_Actividad
SET Duracion_Act = @Duracion_Act
WHERE CVE_Act_PK = @CVE_Act_PK;
EXEC CP_FOM_ACTUALIZAR_ACTIVIDAD 6,"130";

CREATE TRIGGER CT_FOM_ACTIVIDAD_ACTUALIZAR
ON FOM_Actividad
FOR UPDATE
AS
INSERT INTO FOM_CONTROL_ACTIVIDAD_ACTUALIZAR (ID_Actividad_PK, Fecha, Hora, Usuario, Valor_Anterior, Estado)
SELECT inserted.CVE_Act_PK, (SELECT CONVERT(VARCHAR, GETDATE(),103)),
(SELECT CONVERT(VARCHAR, GETDATE(), 108)), SUSER_NAME(), deleted.Duracion_Act,'ACTUALIZAR'
FROM inserted, deleted
	
	SELECT * FROM FOM_CONTROL_ACTIVIDAD_ACTUALIZAR
	SELECT * FROM FOM_Actividad
	SELECT * FROM inserted
	SELECT * FROM deleted;

	 TABLE FOM_CONTROL_ACTIVIDAD
	DROP COLUMN Duracion_Act_Ant;

CREATE TABLE FOM_CONTROL_ACTIVIDAD_ACTUALIZAR (
ID_Actividad_PK INT,
Fecha VARCHAR(12),
Hora VARCHAR (12),
Usuario VARCHAR (25),
Valor_Anterior INT,
Estado VARCHAR (10)
);
SELECT * FROM FOM_CONTROL_ACTIVIDAD_ACTUALIZAR;


