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


INSERT INTO localizacao (latitude, longitude, cidade, estado)
VALUES (-23.305, -45.956, 'Jacareí',       'SP'),
       (-23.548, -46.636, 'São Paulo',      'SP'),
       (-22.903, -43.173, 'Rio de Janeiro', 'RJ');

INSERT INTO usuario (nome, email, senhaHash)
VALUES ('Rafael Melo',    'rafael.pmr@hotmail.com',    'hash23241'),
       ('Erick Rost',     'ErickRost@gmail.com',        'hash231423'),
       ('Thiago Tolosa',  'Thiagotoloso@hotmail.com',   'hash2949300');

INSERT INTO tipo_evento (nome, descricao)
VALUES ('Queimada',     'Incendio em área urbana ou rural'),
       ('Alagamento',   'Acúmulo de água em vias públicas ou residências'),
       ('Deslizamento', 'Movimento de massa de terra ou rocha em encostas');


INSERT INTO evento (titulo, descricao, dataHora, status, idtipoevento, idlocalizacao)
VALUES ('Queimada proxima a represa',        'Fogo se espalhando rapidamente.',          '2025-08-15 14:35:00', 'Ativo',     1, 1),
       ('Alagamento na Avenida Central',     'Ruas alagadas após forte chuva.',          '2025-09-03 08:20:00', 'Ativo',     2, 2),
       ('Deslizamento em encosta residencial','Deslizamento atingindo casas no morro.', '2025-10-21 17:45:00', 'Resolvido', 3, 3);

INSERT INTO relato (texto, dataHora, id_evento, idusuario)
VALUES ('Fumaça forte na região',      '2025-08-15 15:00:00', 1, 1),
       ('Ruas completamente alagadas', '2025-09-03 09:00:00', 2, 2),
       ('Casas soterradas no morro',   '2025-10-21 18:00:00', 3, 3);


INSERT INTO alerta (mensagem, dataHora, nivel, id_evento)
VALUES ('Evitar a área afetada',              '2025-08-15 15:30:00', 'Alto',  1),
       ('Acionar Defesa Civil imediatamente', '2025-09-03 08:20:00', 'Alto',  2),
       ('Evacuar residências próximas',       '2025-10-21 18:30:00', 'Médio', 3);


INSERT INTO historico_evento (id_evento, status_anterior, status_novo, data_alteracao)
VALUES (1, 'Ativo',     'Em Monitoramento', '2025-08-16 09:00:00'),
       (2, 'Ativo',     'Controlado',       '2025-09-04 14:00:00'),
       (3, 'Resolvido', 'Arquivado',        '2025-10-22 10:30:00');


SELECT COUNT(idusuario) AS quant_usuarios
FROM usuario;

SELECT te.nome,
       COUNT(e.id_evento) AS quant_eventos
FROM evento e
JOIN tipo_evento te 
  ON e.idtipoevento = te.idtipoevento
GROUP BY te.nome;


SELECT MIN(dataHora) AS evento_mais_antigo,
       MAX(dataHora) AS evento_mais_recente
FROM evento;

SELECT AVG(quant) AS media_por_cidade
FROM (
    SELECT l.cidade, COUNT(e.id_evento) AS quant
    FROM localizacao l
    JOIN evento e 
      ON l.idlocalizacao = e.idlocalizacao
    GROUP BY l.cidade
) AS quant_por_cidade;

 
