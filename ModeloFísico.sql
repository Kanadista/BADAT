/*
Diagrama Ayuntamientos:
Ayuntamientos: ID(PK), localidad provincia
Alcaldes: ID(PK), nombre, apellidos, fecha de alta, IDAyuntamiento(FK Ayuntamiento)
Secretarios: ID(PK), nombre, apellidos, fecha de alta, IDAyuntamiento(FK Ayuntamiento)
*/
CREATE DATABASE Ayuntamientos
USE Ayuntamientos

CREATE TABLE Ayuntamientos(
ID int NOT NULL Constraint PK_Ayuntamientos Primary Key,
Localidad VarChar(20) NOT NULL,
Provincia VarChar(20) NOT NULL
)

CREATE TABLE Alcaldes(
ID int NOT NULL Constraint PK_Alcaldes Primary Key,
Nombre VarChar(15) NOT NULL,
Apellidos VarChar(30) NOT NULL,
Fecha_Alta date NOT NULL,
Constraint FK_Ayuntamiento_Alcalde Foreign Key (ID) REFERENCES Ayuntamientos(ID)
)

CREATE TABLE Secretarios(
ID int NOT NULL Constraint PK_Secretarios Primary Key,
Nombre VarChar(15) NOT NULL,
Apellidos VarChar(30) NOT NULL,
Fecha_Alta date NOT NULL,
Constraint FK_Ayuntamiento_Secretario Foreign Key (ID) REFERENCES Ayuntamientos(ID)
)


SELECT * FROM SECRETARIOS
---------------------------------------------------------------------------------------------

/*
Usuarios: Nº Seguridad Social (PK), nombre, apellidos, Nº Colegiado (FK Médico)
Médicos: Nº Colegiado (PK), nombre, apellidos
*/

CREATE DATABASE Medicos
USE Medicos

CREATE TABLE Medicos(
NumeroColegiado nchar(6) NOT NULL Constraint PK_Medico Primary Key,
Nombre VarChar(15) NOT NULL,
Apellidos VarChar(30) NOT NULL,
)

CREATE TABLE Usuario(
NumeroSeguridadSocial nchar(8) NOT NULL Constraint PK_Usuario Primary Key,
Nombre VarChar(15) NOT NULL,
Apellidos VarChar(30) NOT NULL,
NumeroColegiado nchar(8) NOT NULL,
Constraint FK_Medico_Usuario Foreign Key (NumeroColegiado) REFERENCES Medicos(NumeroColegiado)
)

-----------------------------------------------------------------------------------------
/*
Clientes:  ID (PK), nombre, apellidos, dirección, teléfono
Reservas: ID (PK), día, hora, número de personas, IDCliente (FK Clientes)
Paellas: Nombre (PK), ingredientes
ReservasPaellas: IDReserva (FK Reservas), NombrePaella(FK Paellas) (PK), número comensales
*/

CREATE DATABASE ArrozConCosas
USE ArrozConCosas

CREATE TABLE Clientes(
ID int NOT NULL Constraint PK_Clientes Primary Key,
Nombre VarChar(15) NOT NULL,
Apellidos VarChar(30) NOT NULL,
Direccion VarChar(50) NOT NULL,
Telefono nChar(9),
)

CREATE TABLE Reservas(
ID int NOT NULL Constraint PK_Reservas Primary Key,
Dia date NOT NULL,
Hora time NOT NULL,
NumeroPersonas tinyint NOT NULL,
IDCliente int NOT NULL,
Constraint FK_Reservas_Clientes Foreign Key (IDCliente) REFERENCES Clientes(ID)
)

CREATE TABLE Paellas(
Nombre VarChar(15) NOT NULL Constraint PK_Paellas Primary Key,
Ingredientes VarChar(20) NOT NULL,
)

CREATE TABLE ReservasPaellas(
IDReserva int NOT NULL, 
NombrePaella VarChar(15), 
NumeroComensales tinyint NOT NULL,
Constraint FK_Reserva Foreign Key (IDReserva) REFERENCES Reservas(ID),
Constraint FK_Paellas Foreign Key (NombrePaella) REFERENCES Paellas(Nombre),
Constraint PK_ReservasPaellas Primary Key (IDReserva, NombrePaella)
)

------------------------------------------------------------------------------------

/*
Actos: ID (PK), fecha, hora, lugar, nombreOrganizador, númeroAsistentes, tipoManifestantes
Policías: NúmeroPlaca (PK), nombre, apellidos, graduación
Equipamientos: ID (PK), peso, peligrosidad, tipoMaterial
ActosPoliciasEquipamientos: IDActo (FK Actos), NúmeroPlaca (FK Polícias), IDEquipamiento(FK Equipamientos) (PK)
*/

CREATE DATABASE Compañeros
USE Compañeros

CREATE TABLE Actos (
ID int NOT NULL Constraint PK_Actos Primary Key,
Fecha date NOT NULL, 
Hora time NOT NULL,
NombreOrganizador VarChar(15) NOT NULL,
NumeroAsistentes int,
TipoManifestantes VarChar(20),
)

CREATE TABLE Policias (
NumeroPlaca VarChar(9) NOT NULL Constraint PK_Policias Primary Key,
Nombre VarChar(15) NOT NULL,
Apellidos VarChar(20) NOT NULL,
Graduacion date,
)

CREATE TABLE Equipamientos (
ID int NOT NULL Constraint PK_Equipamientos Primary Key,
Peso int, 
Peligrosidad VarChar(15),
tipoMaterial VarChar(15)
)

CREATE TABLE ActosPoliciasEquipamientos (
IDActo int,
NumeroPlaca VarChar(9),
IDEquipamiento int NOT NULL,

Constraint FK_Actos Foreign Key (IDActo) REFERENCES Actos(ID),
Constraint FK_Policias Foreign Key (NumeroPlaca) REFERENCES Policias(NumeroPlaca),
Constraint FK_Equipamientos Foreign Key (IDEquipamiento) REFERENCES Equipamientos(ID) 
)

-----------------------------------------------------------------------------------------


