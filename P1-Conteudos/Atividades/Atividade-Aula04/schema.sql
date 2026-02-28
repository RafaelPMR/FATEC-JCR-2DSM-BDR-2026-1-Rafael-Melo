CREATE TABLE localizacao (
    idlocalizacao SERIAL PRIMARY KEY,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    cidade VARCHAR(100),
    estado CHAR(2)
);

CREATE TABLE tipo_evento (
    idtipoevento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao VARCHAR(255),
    dataHora TIMESTAMP NOT NULL,
    status VARCHAR(30),
    idtipoevento INTEGER NOT NULL,
    idlocalizacao INTEGER NOT NULL,
    
    CONSTRAINT fk_evento_tipoevento
        FOREIGN KEY (idtipoevento)
        REFERENCES tipo_evento(idtipoevento),
        
    CONSTRAINT fk_evento_localizacao
        FOREIGN KEY (idlocalizacao)
        REFERENCES localizacao(idlocalizacao)
);

CREATE TABLE usuario (
    idusuario SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    senhaHash VARCHAR(255)
);

CREATE TABLE relato (
    idrelato SERIAL PRIMARY KEY,
    texto VARCHAR(255),
    dataHora TIMESTAMP,
    id_evento INTEGER NOT NULL,
    idusuario INTEGER NOT NULL,
    
    CONSTRAINT fk_relato_evento
        FOREIGN KEY (id_evento)
        REFERENCES evento(id_evento),
        
    CONSTRAINT fk_relato_usuario
        FOREIGN KEY (idusuario)
        REFERENCES usuario(idusuario)
);

CREATE TABLE alerta (
    idalerta SERIAL PRIMARY KEY,
    mensagem VARCHAR(255),
    dataHora TIMESTAMP,
    nivel VARCHAR(30),
    id_evento INTEGER NOT NULL,
    
    CONSTRAINT fk_alerta_evento
        FOREIGN KEY (id_evento)
        REFERENCES evento(id_evento)
);
CREATE TABLE historico_evento (
    idhistorico SERIAL PRIMARY KEY,
    id_evento INTEGER NOT NULL,
    status_anterior VARCHAR(30),
    status_novo VARCHAR(30),
    data_alteracao TIMESTAMP,
    
    CONSTRAINT fk_historico_evento
        FOREIGN KEY (id_evento)
        REFERENCES evento(id_evento)
);