DROP TABLE IF EXISTS emprestimo_livro;
DROP TABLE IF EXISTS emprestimo;
DROP TABLE IF EXISTS livro;
DROP TABLE IF EXISTS aluno;
DROP TABLE IF EXISTS autor;
DROP TABLE IF EXISTS editora;
-- Autor
CREATE TABLE autor (
    id_autor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Editora
CREATE TABLE editora (
    id_editora SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100)
);

-- Livro
CREATE TABLE livro (
    id_livro SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    ano_publicacao INT,
    id_autor INT REFERENCES autor(id_autor),
    id_editora INT REFERENCES editora(id_editora)
);

-- Aluno
CREATE TABLE aluno (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    curso VARCHAR(100)
);

-- Empréstimo
CREATE TABLE emprestimo (
    id_emprestimo SERIAL PRIMARY KEY,
    data_emprestimo DATE NOT NULL,
    id_aluno INT REFERENCES aluno(id_aluno)
);

-- Tabela associativa N:M entre empréstimo e livro
CREATE TABLE emprestimo_livro (
    id_emprestimo INT REFERENCES emprestimo(id_emprestimo),
    id_livro INT REFERENCES livro(id_livro),
    PRIMARY KEY (id_emprestimo, id_livro)
);

-- Autores
INSERT INTO autor (nome) VALUES
('J. R. R. Tolkien'),
('Machado de Assis'),
('Clarice Lispector'),
('J.K. Rowling');

-- Editoras
INSERT INTO editora (nome, cidade) VALUES
('Companhia das Letras', 'São Paulo'),
('Saraiva', 'São Paulo'),
('Atlas', 'Rio de Janeiro');

-- Livros
INSERT INTO livro (titulo, ano_publicacao, id_autor, id_editora) VALUES
('O Senhor dos Anéis', 1954, 1, 1),
('Dom Casmurro', 1899, 2, 2),
('A Hora da Estrela', 1977, 3, 3),
('O Hobbit', 1937, 1, 1);

-- Alunos
INSERT INTO aluno (nome, curso) VALUES
('Erick', 'Sistemas de Informação'),
('Rafael', 'Engenharia de Software');

-- Empréstimos
INSERT INTO emprestimo (data_emprestimo, id_aluno) VALUES
('2025-08-20', 1),
('2025-08-21', 2);

-- Empréstimo_Livro
INSERT INTO emprestimo_livro (id_emprestimo, id_livro) VALUES
(1, 1),
(1, 2),
(2, 3)

ALTER TABLE livro
ADD COLUMN paginas INT;

UPDATE livro
SET paginas = 1216
WHERE id_livro = 1;

UPDATE livro
SET paginas = 256
WHERE id_livro = 2;

UPDATE livro
SET paginas = 88
WHERE id_livro = 3;

UPDATE livro
SET paginas = 336
WHERE id_livro = 4;

-- exercicio 1
SELECT
    a.nome,
    (
        SELECT COUNT(*)
        FROM livro l
        WHERE l.id_autor = a.id_autor
    ) AS quantidade_livros,
    (
        SELECT AVG(l.paginas)
        FROM livro l
        WHERE l.id_autor = a.id_autor
    ) AS media_paginas
	
FROM autor a;
-- CTE
WITH estatistica AS (
SELECT id_autor, COUNT(*) AS quantidade_livros, AVG(paginas) AS media_paginas
FROM livro GROUP BY id_autor
) 
SELECT a.nome, e.quantidade_livros, e.media_paginas
FROM autor a JOIN estatistica e ON a.id_autor = e.id_autor;

-- Exercicio 2

WITH paginas_por_autor AS
(
SELECT id_autor, SUM(paginas) AS total_paginas
FROM LIVRO 
GROUP BY id_autor
)
SELECT a.nome, p.total_paginas
FROM paginas_por_autor p JOIN autor a ON a.id_autor = p.id_autor 
WHERE p.total_paginas >
(
SELECT AVG(total_paginas)
FROM paginas_por_autor
);

-- Exercicio 3

-- Correlacionada
SELECT a.nome FROM autor a
WHERE (
SELECT COUNT(*)
FROM livro 1
WHERE 1.id_autor = a.id_autor
) > 1;

-- CTE Pré-Agrupada

WITH livros_por_autor AS (
    SELECT
        id_autor,
        COUNT(*) AS quantidade
    FROM livro
    GROUP BY id_autor
)
SELECT
    a.nome
FROM autor a
JOIN livros_por_autor l
    ON a.id_autor = l.id_autor

WHERE l.quantidade > 1;