CREATE TABLE Usuario(
	email 			VARCHAR(50) 	NOT NULL,
	nome 			VARCHAR(50) 	NOT NULL,
	senha 			VARCHAR(30) 	NOT NULL,
	genero 			VARCHAR(20) 	NOT NULL,
	data_ingresso	TIMESTAMP 		NOT NULL,
	data_nascimento DATE 			NOT NULL,
	CONSTRAINT pk_usuario PRIMARY KEY (email),
    CONSTRAINT uk_usuario UNIQUE (nome)
);

CREATE TABLE Telefones(
	usuario		VARCHAR(50) 	NOT NULL,
	telefone 	CHAR(11) 		NOT NULL,
	CONSTRAINT pk_telefones PRIMARY KEY (usuario, telefone)
);

CREATE TABLE Artista(
	email 				VARCHAR(50) 	NOT NULL,
	funcao 				VARCHAR(20) 	NOT NULL,
	descricao 			VARCHAR(120) 	NULL,
	genero_musical 		VARCHAR(30) 	NOT NULL,
	numero_integrantes 	NUMERIC(2) 		NOT NULL,
	CONSTRAINT pk_artista PRIMARY KEY (email)
);

CREATE TABLE Podcaster(
	email 		VARCHAR(50) 	NOT NULL,
	CONSTRAINT pk_podcaster PRIMARY KEY (email)
);

CREATE TABLE Ouvinte(
	email 		VARCHAR(50) 	NOT NULL,
	CONSTRAINT pk_ouvinte PRIMARY KEY (email)
);

CREATE TABLE Redes_Sociais(
    nome 		VARCHAR(30) 	NOT NULL,
    descricao 	VARCHAR(120) 	NULL,
    CONSTRAINT pk_redes_sociais PRIMARY KEY (nome)
);

CREATE TABLE Tem_Redes( 
    usuario 		VARCHAR(50) 	NOT NULL,
    rede_social 	VARCHAR(30) 	NOT NULL,
	nickname		VARCHAR(20)		NOT NULL,
    CONSTRAINT pk_tem_redes PRIMARY KEY (usuario, rede_social)
);

CREATE TABLE Segue( 
    usuario 	VARCHAR(50)		 NOT NULL,
    ouvinte 	VARCHAR(50)		 NOT NULL,
    CONSTRAINT pk_segue PRIMARY KEY (usuario, ouvinte)
);

CREATE TABLE Gravadora(
    cnpj 				CHAR(14) 		NOT NULL,
    email_corporativo 	VARCHAR(50) 	NOT NULL,
    senha				VARCHAR(30) 	NOT NULL,
    nome 				VARCHAR(50) 	NOT NULL,
    endereco 			VARCHAR(120) 	NULL,
    site 				VARCHAR(50) 	NULL,
    descricao 			VARCHAR(120) 	NULL,
    telefone 			CHAR(11) 		NOT NULL,
    CONSTRAINT pk_gravadora PRIMARY KEY (cnpj),
    CONSTRAINT uk_gravadora UNIQUE (nome)
);

CREATE TABLE Artista_Gravadora(
    artista 		VARCHAR(50) 	NOT NULL,
    gravadora 		CHAR(14) 		NOT NULL,
    data_inicio 	DATE 			NOT NULL,
    data_final 		DATE 			NOT NULL,
    CONSTRAINT pk_artista_gravadora PRIMARY KEY (artista, gravadora)
);

CREATE TABLE Playlist(
	criador 			VARCHAR(50) 	NOT NULL,
	nome 				VARCHAR(30) 	NOT NULL,
	numero_curtidas 	NUMERIC(4) 		NOT NULL 	DEFAULT 0,
	CONSTRAINT pk_playlist PRIMARY KEY (criador, nome)
);

CREATE TABLE Curte_Playlist(
	ouvinte 			VARCHAR(50) 	NOT NULL,
	criador_playlist 	VARCHAR(50) 	NOT NULL,
	nome_playlist 		VARCHAR(30) 	NOT NULL,
	CONSTRAINT pk_curte_playlist PRIMARY KEY (ouvinte, criador_playlist, nome_playlist)	
);

CREATE TABLE Coletanea(
    selo				VARCHAR(20) 	NOT NULL,
    nome 				VARCHAR(30) 	NOT NULL,
    capa 				VARCHAR(120) 	NOT NULL,
    data_lançamento 	DATE 			NOT NULL,
    CONSTRAINT pk_coletanea PRIMARY KEY (selo),
    CONSTRAINT uk_coletanea UNIQUE (nome)
);

CREATE TABLE Podcast(
    selo 		VARCHAR(20) 	NOT NULL,
    podcaster 	VARCHAR(50) 	NOT NULL,
    CONSTRAINT pk_podcast PRIMARY KEY (selo)
);

CREATE TABLE Album(
    selo 		VARCHAR(20) 	NOT NULL,
    artista 	VARCHAR(50) 	NOT NULL,
    gravadora 	CHAR(14)  		NOT NULL,
    CONSTRAINT pk_album PRIMARY KEY (selo)
);

CREATE TABLE Obra(
    registro 	VARCHAR(20) 	NOT NULL, 
    nome 		VARCHAR(30) 	NOT NULL,
    duracao 	TIME 			NOT NULL,   
    CONSTRAINT pk_obra PRIMARY KEY (registro),
    CONSTRAINT uk_obra UNIQUE (nome)
);

CREATE TABLE Episodio(
    registro 	VARCHAR(20) 	NOT NULL, 
    podcast 	VARCHAR(20) 	NOT NULL,
    descricao 	VARCHAR(240) 	NULL,
    CONSTRAINT pk_episodio PRIMARY KEY (registro)
);

CREATE TABLE Musica(
    registro 	VARCHAR(20) 	NOT NULL,
    album 		VARCHAR(20) 	NOT NULL,
    letra 		VARCHAR(300) 	NULL,
    CONSTRAINT pk_musica PRIMARY KEY (registro)
);

CREATE TABLE E_Formada(
	criador_playlist 	VARCHAR(50) 	NOT NULL,
	nome_playlist 		VARCHAR(30) 	NOT NULL,
	obra 				VARCHAR(20) 	NOT NULL, 
	CONSTRAINT pk_e_formada PRIMARY KEY (criador_playlist, nome_playlist, obra)
);

ALTER TABLE Telefones 
ADD CONSTRAINT fk_usuario
FOREIGN KEY (usuario) REFERENCES Usuario (email) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Artista 
ADD CONSTRAINT fk_usuario 
FOREIGN KEY (email) REFERENCES Usuario (email) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Podcaster 
ADD CONSTRAINT fk_usuario 
FOREIGN KEY (email) REFERENCES Usuario (email) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Ouvinte 
ADD CONSTRAINT fk_usuario 
FOREIGN KEY (email) REFERENCES Usuario (email) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Tem_Redes 
ADD CONSTRAINT fk_usuario
FOREIGN KEY (usuario) REFERENCES Usuario (email)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Tem_Redes 
ADD CONSTRAINT fk_rede_social
FOREIGN KEY (rede_social) REFERENCES Redes_Sociais (nome)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Segue 
ADD CONSTRAINT fk_usuario
FOREIGN KEY (usuario) REFERENCES Usuario (email)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Segue 
ADD CONSTRAINT fk_ouvinte
FOREIGN KEY (ouvinte) REFERENCES Ouvinte (email)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Artista_Gravadora 
ADD CONSTRAINT fk_artista 
FOREIGN KEY (artista) REFERENCES Artista (email)
ON UPDATE CASCADE;

ALTER TABLE Artista_Gravadora 
ADD CONSTRAINT fk_gravadora 
FOREIGN KEY (gravadora) REFERENCES Gravadora (cnpj)
ON UPDATE CASCADE;

ALTER TABLE Playlist 
ADD CONSTRAINT fk_criador
FOREIGN KEY (criador) REFERENCES Ouvinte (email)
ON UPDATE CASCADE;

ALTER TABLE Curte_Playlist 
ADD CONSTRAINT fk_ouvinte
FOREIGN KEY (ouvinte) REFERENCES Ouvinte (email) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Curte_Playlist 
ADD CONSTRAINT fk_playlist
FOREIGN KEY (criador_playlist, nome_playlist) REFERENCES Playlist (criador, nome) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Podcast 
ADD CONSTRAINT fk_coletanea FOREIGN KEY (selo) REFERENCES Coletanea (selo)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Podcast 
ADD CONSTRAINT fk_podcaster FOREIGN KEY (podcaster) REFERENCES Podcaster (email)
ON UPDATE CASCADE;

ALTER TABLE Album 
ADD CONSTRAINT fk_coletanea FOREIGN KEY (selo) REFERENCES Coletanea (selo)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Album 
ADD CONSTRAINT fk_artista_gravadora FOREIGN KEY (artista, gravadora) REFERENCES Artista_Gravadora (artista, gravadora)
ON UPDATE CASCADE;

ALTER TABLE Episodio 
ADD CONSTRAINT fk_obra
FOREIGN KEY (registro) REFERENCES Obra (registro)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Episodio 
ADD CONSTRAINT fk_podcast
FOREIGN KEY (podcast) REFERENCES Podcast (selo)
ON UPDATE CASCADE;

ALTER TABLE Musica 
ADD CONSTRAINT fk_obra
FOREIGN KEY (registro) REFERENCES Obra (registro)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Musica 
ADD CONSTRAINT fk_album
FOREIGN KEY (album) REFERENCES Album (selo)
ON UPDATE CASCADE;

ALTER TABLE E_Formada 
ADD CONSTRAINT fk_playlist
FOREIGN KEY (criador_playlist, nome_playlist) REFERENCES Playlist (criador, nome) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE E_Formada 
ADD CONSTRAINT fk_obra
FOREIGN KEY (obra) REFERENCES Obra (registro) 
ON DELETE CASCADE ON UPDATE CASCADE;