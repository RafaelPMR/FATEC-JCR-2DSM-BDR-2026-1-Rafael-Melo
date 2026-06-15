DROP TABLE IF EXISTS carro, pessoa;

CREATE TABLE IF NOT EXISTS pessoa (
    id_pessoa INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nascimento DATE
);

CREATE TABLE IF NOT EXISTS carro (
    id_carro INTEGER PRIMARY KEY,
    placa CHAR(7) NOT NULL,
    ano INTEGER,
    id_pessoa INTEGER NOT NULL,
    FOREIGN KEY (id_pessoa)
    REFERENCES pessoa(id_pessoa)
    ON DELETE CASCADE
);

COPY pessoa(id_pessoa,nome,nascimento)
FROM 'C:/temp/aula3_pessoa.csv'
DELIMITER ','
CSV HEADER;

COPY carro(id_carro, placa, ano, id_pessoa)
FROM 'C:/temp/aula3_carro.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*)
FROM carro;

SELECT COUNT(*)
FROM pessoa;

-- Exercicio 1 --

---------------------------------------
-- Parte A --
---------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nome = 'Ana Silva';

-- Planning Time: 0.188 ms --
-- Execution Time: 14.850 ms --

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nome = 'João Santos';

-- Planning Time: 0.245 ms --
-- Execution Time: 16.962 ms --

-----------------------------------------
-- Parte B --
-----------------------------------------

CREATE INDEX idx_pessoa_nome
ON pessoa (nome);
----------------------------------------
-- Parte C --
----------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nome = 'Ana Silva';

-- Planning Time: 2.664 ms --
-- Execution Time: 0.175 ms --

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nome = 'João Santos';

-- Planning Time: 0.155 ms --
-- Execution Time: 0.230 ms --

----------------------------------------
-- Parte D --
----------------------------------------

-- 1. Seq Scan
-- 2. Bitmap Heap Scan
-- 3. Sim
-- 4. Sim, ambos utilizaram Bitmap Index Scan on Idx_pessoa_nome

-- Exercicio 2 --

----------------------------------------
-- Parte A --
-----------------------------------------

DROP INDEX IF EXISTS idx_pessoa_nome;

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nascimento >= DATE '1970-01-01';

-- Planning Time: 1.361 ms --
-- Execution Time: 16.742 ms --

---------------------------------------
-- Parte B --
----------------------------------------

CREATE INDEX idx_pessoa_nascimento
ON pessoa (nascimento);

---------------------------------------
-- Parte C --
---------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nascimento >= DATE '1970-01-01';

-- Planning Time: 3.488 ms --
-- Execution Time: 16.931 ms --

---------------------------------------
-- Parte D --
--------------------------------------

-- 1. Não
-- 2. Não
-- 3. Não
-- 4. Se uma consulta for ampla e pretende recuperar grande parte das linhas de uma tabela, costuma ser mais eficiente simplesmente ler todos os registros de uma só vez do que perder tempo acessando as entradas por meio de um índice.

-- Exercicio 3 --

-------------------------------------
-- Parte A --
--------------------------------------

DROP INDEX IF EXISTS idx_pessoa_nascimento;

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nascimento >= DATE '2000-01-01'
AND nome = 'Ana Silva';

-- Planning Time: 0.234 ms --
-- Execution Time: 17.796 ms --

---------------------------------------
-- Parte B --
---------------------------------------

CREATE INDEX idx_pessoa_nascimento_nome
ON pessoa (nascimento, nome);

--------------------------------------------
-- Parte C --
--------------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nascimento >= DATE '2000-01-01'
AND nome = 'Ana Silva';

-- Planning Time: 3.596 ms --
-- Execution Time: 3.045 ms --

--------------------------------------
-- Parte D --
--------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nome = 'Ana Silva';

-- Planning Time: 0.209 ms --
-- Execution Time: 15.053 ms --

--------------------------------------
-- Parte E --
---------------------------------------

-- Seq Scan
-- Index Scan
-- Não
-- Por ser organizado em formato hierárquico, é possível realizar a busca pela primeira coluna ou por ambas as colunas simultaneamente, porém não se pode pesquisar apenas pela segunda coluna isolada.

-- Exercicio 4 --

--------------------------------------
-- Parte A --
---------------------------------------

DROP INDEX IF EXISTS idx_pessoa_nascimento_nome;

CREATE INDEX idx_pessoa_nascimento
ON pessoa (nascimento);
CREATE INDEX idx_pessoa_nome
ON pessoa (nome);

-----------------------------------------
-- Parte B --
------------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nascimento >= DATE '2000-01-01'
AND nome = 'Ana Silva';

-- Planning Time: 4.283 ms --
-- Execution Time: 0.196 ms --

------------------------------------
-- Parte C --
------------------------------------

-- 1. Não, apenas o nome
-- 2. Ele realiza a intersecção dos bits de dois índices, retornando apenas os endereços das linhas que atendem a ambas as consultas.
-- 3. Ele aplicou a varredura do índice bitmap na coluna de nome e, em seguida, filtrou esses resultados com a data de nascimento, uma vez que o índice de nome já trouxe muito poucas linhas, tornando desnecessário usar outro índice para a segunda filtragem.
-- Exercicio 5 --

EXPLAIN ANALYZE
SELECT *
FROM carro
WHERE ano BETWEEN 2015 AND 2020;

-- Planning Time: 3.343 ms --
-- Execution Time: 14.055 ms --

CREATE INDEX idx_carro_ano
ON carro (ano);

EXPLAIN ANALYZE
SELECT *
FROM carro
WHERE ano BETWEEN 2015 AND 2020;

-- Planning Time: 2.829 ms --
-- Execution Time: 6.426 ms --

-- Antes foi usado Seq Scan, depois foi usado Bitmap Index Scan, o tempo deminuiu em 50% --

-- Exercicio 6 --

DROP INDEX IF EXISTS idx_pessoa_nome;
DROP INDEX IF EXISTS idx_carro_ano;

EXPLAIN ANALYZE
SELECT p.nome, c.placa
FROM pessoa p
JOIN carro c ON p.id_pessoa = c.id_pessoa
WHERE p.nome = 'Ana Silva';

-- Planning Time: 5.413 ms --
-- Execution Time: 57.840 ms --

CREATE INDEX idx_pessoa_nome
ON pessoa (nome);
CREATE INDEX idx_carro_id_pessoa
ON carro (id_pessoa);

EXPLAIN ANALYZE
SELECT p.nome, c.placa
FROM pessoa p
JOIN carro c ON p.id_pessoa = c.id_pessoa
WHERE p.nome = 'Ana Silva';

-- Planning Time: 5.104 ms --
-- Execution Time: 0.250 ms --

-- Resposta: Antes foi usado Seq Scan nas duas tabelas, depois foi usado Bitmap Index Scan na tabela pessoa e Index Scan na tabela carro, reduzindo o tempo para quase 0.

-- Exercicio 7 --

DROP INDEX IF EXISTS idx_pessoa_nome;
DROP INDEX IF EXISTS idx_carro_id_pessoa;

EXPLAIN ANALYZE
SELECT p.nome, c.placa, c.ano
FROM pessoa p
JOIN carro c ON p.id_pessoa = c.id_pessoa
WHERE p.nascimento >= DATE '1980-01-01'
AND c.ano >= 2018;

-- Planning Time: 21.660 ms --
-- Execution Time: 66.855 ms --

CREATE INDEX idx_pessoa_nome_nascimento
ON pessoa (nascimento, nome);
CREATE INDEX idx_carro_id_pessoa_ano
ON carro (id_pessoa, ano);

EXPLAIN ANALYZE
SELECT p.nome, c.placa, c.ano
FROM pessoa p
JOIN carro c ON p.id_pessoa = c.id_pessoa
WHERE p.nascimento >= DATE '1980-01-01'
AND c.ano >= 2018;

-- Planning Time: 0.400 ms --
-- Execution Time: 31.766 ms --

-- Antes foi usado Seq Scan nas duas tabelas com Hash Join, depois foi usado Index Scan através dos índices compostos criados, reduzindo o tempo de execução pela metade. --

-- Exercicio 8 --

DROP INDEX IF EXISTS idx_pessoa_nome_nascimento;
DROP INDEX IF EXISTS idx_carro_id_pessoa_ano;

-----------------------------------------
-- Parte A --
-----------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nascimento BETWEEN DATE '1980-01-01' AND DATE '1990-12-31';

-- Planning Time: 2.563 ms --
-- Execution Time: 12.817 ms --

--------------------------------------
-- Parte B --
---------------------------------------

CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE INDEX idx_pessoa_nascimento_gist
ON pessoa
USING GIST (nascimento);

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'pessoa';

------------------------------------------
-- Parte C --
------------------------------------------

EXPLAIN ANALYZE
SELECT *
FROM pessoa
WHERE nascimento BETWEEN DATE '1980-01-01' AND DATE '1990-12-31';

-- Planning Time: 3.072 ms --
-- Execution Time: 7.074 ms --

---------------------------------------
-- Parte D --
---------------------------------------

-- 1. Seq Scan
-- 2. Sim, foi utilizado Bitmap Index Scan através do Indice GiST
-- 3. Sim