/*
GO
CREATE DATABASE Fracking
GO

USE Fracking
*/

CREATE TABLE Parcelas (
id int NOT NULL Constraint PK_Parcelas Primary Key,
extensión int NULL,
)

CREATE TABLE Limites (
id int Constraint PK_Limites Primary Key,
latitud int NOT NULL,
longitud int NOT NULL
)

CREATE TABLE ParcelasLimites (

idParcela int NOT NULL,
idLimite int NOT NULL,
Constraint FK_Parcela Foreign Key (idParcela) REFERENCES Parcelas(id),
Constraint FK_Limite Foreign Key (idLimite) REFERENCES Limites(id),
Constraint PK_ParcelasLimites Primary Key (idParcela, idLimite)
 
 )

 CREATE TABLE Propietarios (

 id int NOT NULL Constraint PK_Propietarios Primary Key,
 nombre VarChar(15) NOT NULL,
 apellidos VarChar(40) NOT NULL,
 telefono nchar(9) NOT NULL,
 direccion VarChar(50) NOT NULL,
 facilidadSondeo tinyInt NOT NULL,

 )

 CREATE TABLE ParcelasPropietarios (

 idParcela int NOT NULL,
 idPropietario int NOT NULL,
 
 Constraint FK_ParcelaPropietario Foreign Key (idParcela) REFERENCES Parcelas(id),
 Constraint FK_PropietariosParcela Foreign Key (idPropietario) REFERENCES Propietarios(id),
 Constraint PK_ParcelasPropietarios Primary Key (idParcela, idPropietario)

 )


 CREATE TABLE Instituciones (

 id int NOT NULL Constraint PK_Instituciones Primary Key,
 nombre VarChar(30) NOT NULL

 )

 CREATE TABLE ParcelasInstituciones (

 idParcela int NOT NULL,
 idInstitucion int NOT NULL,

 Constraint FK_ParcelasInstituciones Foreign Key (idParcela) REFERENCES Parcelas(id),
 Constraint FK_InstitucionesParcelas Foreign Key (idInstitucion) REFERENCES Instituciones(id),
 Constraint PK_ParcelasInstituciones Primary Key (idParcela, idInstitucion)
 )

 CREATE TABLE Trabajadores(

 id int NOT NULL Constraint PK_Trabajadores Primary Key,
 nombre VarChar(15) NOT NULL,
 apellidos VarChar(30) NOT NULL,
 telefono nChar(9) NOT NULL,
 direccion VarChar(40) NOT NULL,
 categoria tinyInt NOT NULL,
 idInstitucion int NOT NULL,

 Constraint FK_Institucion Foreign Key (idInstitucion) REFERENCES Instituciones (id)

 )

 CREATE TABLE Funcionarios(

 idTrabajador int NOT NULL,
 cargo VarChar(20) NULL

 Constraint FK_TrabajadorFuncionario Foreign Key (idTrabajador) REFERENCES Trabajadores (id),
 Constraint PK_Funcionarios Primary Key (idTrabajador)

 )

 CREATE TABLE Politicos(

 idTrabajador int NOT NULL,
 puesto VarChar(20) NULL

 Constraint FK_TrabajadorPoliticos Foreign Key (idTrabajador) REFERENCES Trabajadores (id),
 Constraint PK_Politicos Primary Key (idTrabajador)

 )

 CREATE TABLE PuntosDebiles(

 id int NOT NULL Constraint PK_PuntosDebiles Primary Key,
 nombre VarChar(30) NOT NULL

 )

 CREATE TABLE Organizaciones(

 id int NOT NULL Constraint PK_Organizaciones Primary Key,
 nombre VarChar(20) NOT NULL,
 lema VarChar(50) NULL,
 telefono nChar(9) NOT NULL

 )

 CREATE TABLE OrganizacionesParcelas(

 idOrganizacion int NOT NULL,
 idParcela int NOT NULL

 Constraint FK_OrganizacionParcela Foreign Key (idOrganizacion) REFERENCES Organizaciones (id),
 Constraint FK_ParcelaOrganizacion Foreign Key (idParcela) REFERENCES Parcelas (id)

 )

 CREATE TABLE Actos (

 id int NOT NULL Constraint PK_Actos Primary Key,
 lugar VarChar(30) NULL,
 momento date NOT NULL,

 )

 CREATE TABLE Espias (

 id int NOT NULL Constraint PK_Espias Primary Key,
 nombre VarChar(15) NOT NULL,
 apellidos VarChar(30) NOT NULL,
 telefono nChar(9) NOT NULL,
 direccion VarChar(40) NULL
 )

 CREATE TABLE ActosEspias (

 idActo int,
 idEspia int, 

 Constraint FK_ActosEspias Foreign Key (idActo) REFERENCES Actos (id),
 Constraint FK_EspiasActos Foreign Key (idEspia) REFERENCES Espias (id),
 Constraint PK_ActosEspias Primary Key (idActo, idEspia)

 )

  CREATE TABLE ActosPoliticos (

 idActo int,
 idPolitico int, 

 Constraint FK_ActosPoliticos Foreign Key (idActo) REFERENCES Actos (id),
 Constraint FK_PoliticosActos Foreign Key (idPolitico) REFERENCES Politicos (idTrabajador),
 Constraint PK_ActosPoliticos Primary Key (idActo, idPolitico)

 )

 