USE DEMO

/************** Suppression des Contraintes **************/


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ARTI_CARA]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ARTICLE] DROP CONSTRAINT FK_ARTI_CARA
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ARTI_FOUR]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ARTICLE] DROP CONSTRAINT FK_ARTI_FOUR
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ARTI_GAMM]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ARTICLE] DROP CONSTRAINT FK_ARTI_GAMM
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GATY_GAMM]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[GAMME_TYPR] DROP CONSTRAINT FK_GATY_GAMM
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_ARTI_TYPR]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[ARTICLE] DROP CONSTRAINT FK_ARTI_TYPR
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_GATY_TYPR]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[GAMME_TYPR] DROP CONSTRAINT FK_GATY_TYPR
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_TYPR_TYPC]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[TYPE_PRODUIT_CARA] DROP CONSTRAINT FK_TYPR_TYPC
GO

/******************** Suppression des Triggers ********************/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TR_LSOU_CARA]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[TR_LSOU_CARA]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TR_LSOU_CATE]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[TR_LSOU_CATE]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TR_LSOU_GAMM]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[TR_LSOU_GAMM]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TR_LSOU_TYPR]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[TR_LSOU_TYPR]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TR_LSOU_ARTI]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[TR_LSOU_ARTI]
GO

/******************** Suppression des Tables ********************/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ARTICLE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ARTICLE]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CARACTERISTIQUE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CARACTERISTIQUE]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CATEGORIE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CATEGORIE]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GAMME]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[GAMME]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GAMME_TYPR]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[GAMME_TYPR]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TYPE_PRODUIT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TYPE_PRODUIT]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TYPE_PRODUIT_CARA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TYPE_PRODUIT_CARA]
GO


/************** Création des TABLES **************/

CREATE TABLE [dbo].[ARTICLE] (
	[ARTI_Clep] [varchar] (12) NOT NULL ,
	[ARTI_Libelle] [varchar] (120) NOT NULL ,
	[ARTI__CARA] [varchar] (20) NULL ,
	[ARTI__TYPR] [varchar] (12) NULL ,
	[ARTI__GAMM] [varchar] (5) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CARACTERISTIQUE] (
	[CARA_Clep] [varchar] (20) NOT NULL ,
	[CARA_Libelle] [varchar] (150) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CATEGORIE] (
	[CATE_Clep] [int] NOT NULL ,
	[CATE_Lib] [varchar] (20) NULL ,
	[CATE_Valide] [bit] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[GAMME] (
	[GAMM_Clep] [varchar] (5) NOT NULL ,
	[GAMM_Libelle] [varchar] (100) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[GAMME_TYPR] (
	[GATY__GAMM] [varchar] (5) NOT NULL ,
	[GATY__TYPR] [varchar] (12) NOT NULL 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[TYPE_PRODUIT] (
	[TYPR_Clep] [varchar] (12) NOT NULL ,
	[TYPR_Libelle] [varchar] (120) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TYPE_PRODUIT_CARA] (
	[TYPC__TYPR] [varchar] (12) NOT NULL ,
	[TYPC__CARA] [varchar] (20) NOT NULL 
) ON [PRIMARY]
GO



/************** Ajout des clés primaires **************/

ALTER TABLE [dbo].[ARTICLE] WITH NOCHECK ADD 
	CONSTRAINT [PK_ART] PRIMARY KEY  CLUSTERED 
	(
		[ARTI_Clep]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CARACTERISTIQUE] WITH NOCHECK ADD 
	CONSTRAINT [PK_CARA] PRIMARY KEY  CLUSTERED 
	(
		[CARA_Clep]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CATEGORIE] WITH NOCHECK ADD 
	CONSTRAINT [PK_CATE] PRIMARY KEY  CLUSTERED 
	(
		[CATE_Clep]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[GAMME] WITH NOCHECK ADD 
	CONSTRAINT [PK_GAMM] PRIMARY KEY  CLUSTERED 
	(
		[GAMM_Clep]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[GAMME_TYPR] WITH NOCHECK ADD 
	CONSTRAINT [PK_GATY] PRIMARY KEY  CLUSTERED 
	(
		[GATY__GAMM],
		[GATY__TYPR]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TYPE_PRODUIT] WITH NOCHECK ADD 
	CONSTRAINT [PK_TYPR] PRIMARY KEY  CLUSTERED 
	(
		[TYPR_Clep]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TYPE_PRODUIT_CARA] WITH NOCHECK ADD 
	CONSTRAINT [PK_TYPC] PRIMARY KEY  CLUSTERED 
	(
		[TYPC__TYPR],
		[TYPC__CARA]
	)  ON [PRIMARY] 
GO

/************** Ajout des dépendances fonctionnelles **************/
ALTER TABLE [dbo].[ARTICLE] WITH NOCHECK ADD 
	CONSTRAINT [DF_ARTICLE_ARTI_Compose] DEFAULT (0) FOR [ARTI_Compose]
GO

/************** Ajout des index **************/
CREATE INDEX [FK_ARTI_FOUR] ON [dbo].[ARTICLE]([ARTI__FOUR]) ON [PRIMARY]
GO


/************** Ajout des clés étrangères **************/

ALTER TABLE [dbo].[ARTICLE] ADD 
	CONSTRAINT [FK_ARTI_CARA] FOREIGN KEY 
	(
		[ARTI__CARA]
	) REFERENCES [dbo].[CARACTERISTIQUE] (
		[CARA_Clep]
	),
	CONSTRAINT [FK_ARTI_GAMM] FOREIGN KEY 
	(
		[ARTI__GAMM]
	) REFERENCES [dbo].[GAMME] (
		[GAMM_Clep]
	) ON UPDATE CASCADE  NOT FOR REPLICATION ,
	CONSTRAINT [FK_ARTI_TYPR] FOREIGN KEY 
	(
		[ARTI__TYPR]
	) REFERENCES [dbo].[TYPE_PRODUIT] (
		[TYPR_Clep]
	) ON UPDATE CASCADE  NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].[GAMME_TYPR] ADD 
	CONSTRAINT [FK_GATY_GAMM] FOREIGN KEY 
	(
		[GATY__GAMM]
	) REFERENCES [dbo].[GAMME] (
		[GAMM_Clep]
	) ON DELETE CASCADE  ON UPDATE CASCADE  NOT FOR REPLICATION ,
	CONSTRAINT [FK_GATY_TYPR] FOREIGN KEY 
	(
		[GATY__TYPR]
	) REFERENCES [dbo].[TYPE_PRODUIT] (
		[TYPR_Clep]
	) ON DELETE CASCADE  ON UPDATE CASCADE  NOT FOR REPLICATION 
GO

ALTER TABLE [dbo].[TYPE_PRODUIT_CARA] ADD 
	CONSTRAINT [FK_CARA_TYPC] FOREIGN KEY 
	(
		[TYPC__CARA]
	) REFERENCES [dbo].[CARACTERISTIQUE] (
		[CARA_Clep]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_TYPR_TYPC] FOREIGN KEY 
	(
		[TYPC__TYPR]
	) REFERENCES [dbo].[TYPE_PRODUIT] (
		[TYPR_Clep]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

/************** Création des Triggers **************/
/* Les triggers liés aux indicateurs des lots */

CREATE TRIGGER TR_LSOU_CARA ON [dbo].[CARACTERISTIQUE]
FOR INSERT, UPDATE, DELETE
AS
DECLARE @indic bit
SELECT @indic = LSOU_Indicateur FROM LOT_SIEGE_OUT WHERE LSOU_Clep = 'CARA'
IF @indic = 0
UPDATE LOT_SIEGE_OUT
SET LSOU_Indicateur = 1, LSOU_Dernmodif = getdate() WHERE LSOU_Clep = 'CARA' AND LSOU_Indicateur = 0
GO

CREATE TRIGGER TR_LSOU_CATE ON [dbo].[CATEGORIE]
FOR INSERT, UPDATE, DELETE
AS
DECLARE @indic bit
SELECT @indic = LSOU_Indicateur FROM LOT_SIEGE_OUT WHERE LSOU_Clep = 'CATE'
IF @indic = 0
UPDATE LOT_SIEGE_OUT
SET LSOU_Indicateur = 1, LSOU_Dernmodif = getdate() WHERE LSOU_Clep = 'CATE' AND LSOU_Indicateur = 0
GO

CREATE TRIGGER TR_LSOU_GATY ON [dbo].[GAMME_TYPR]
FOR INSERT, UPDATE, DELETE
AS
DECLARE @indic bit
SELECT @indic = LSOU_Indicateur FROM LOT_SIEGE_OUT WHERE LSOU_Clep = 'GATY'
IF @indic = 0
UPDATE LOT_SIEGE_OUT
SET LSOU_Indicateur = 1, LSOU_Dernmodif = getdate() WHERE LSOU_Clep = 'GATY' AND LSOU_Indicateur = 0
GO

CREATE TRIGGER TR_LSOU_GAMM ON [dbo].[GAMME]
FOR INSERT, UPDATE, DELETE
AS
DECLARE @indic bit
SELECT @indic = LSOU_Indicateur FROM LOT_SIEGE_OUT WHERE LSOU_Clep = 'GAMM'
IF @indic = 0
UPDATE LOT_SIEGE_OUT
SET LSOU_Indicateur = 1, LSOU_Dernmodif = getdate() WHERE LSOU_Clep = 'GAMM' AND LSOU_Indicateur = 0
GO

CREATE TRIGGER TR_LSOU_TYPR ON [dbo].[TYPE_PRODUIT]
FOR INSERT, UPDATE, DELETE
AS
DECLARE @indic bit
SELECT @indic = LSOU_Indicateur FROM LOT_SIEGE_OUT WHERE LSOU_Clep = 'TYPR'
IF @indic = 0
UPDATE LOT_SIEGE_OUT
SET LSOU_Indicateur = 1, LSOU_Dernmodif = getdate() WHERE LSOU_Clep = 'TYPR' AND LSOU_Indicateur = 0
GO

CREATE TRIGGER TR_LSOU_TYPC ON [dbo].[TYPE_PRODUIT_CARA]
FOR INSERT, UPDATE, DELETE
AS
DECLARE @indic bit
SELECT @indic = LSOU_Indicateur FROM LOT_SIEGE_OUT WHERE LSOU_Clep = 'TYPC'
IF @indic = 0
UPDATE LOT_SIEGE_OUT
SET LSOU_Indicateur = 1, LSOU_Dernmodif = getdate() WHERE LSOU_Clep = 'TYPC' AND LSOU_Indicateur = 0
GO

CREATE TRIGGER TR_LSOU_ARTI ON [dbo].[ARTICLE]
FOR INSERT, UPDATE, DELETE
AS
DECLARE @indic bit
SELECT @indic = LSOU_Indicateur FROM LOT_SIEGE_OUT WHERE LSOU_Clep = 'ARTI'
IF @indic = 0
UPDATE LOT_SIEGE_OUT
SET LSOU_Indicateur = 1, LSOU_Dernmodif = getdate() WHERE LSOU_Clep = 'ARTI' AND LSOU_Indicateur = 0
GO

