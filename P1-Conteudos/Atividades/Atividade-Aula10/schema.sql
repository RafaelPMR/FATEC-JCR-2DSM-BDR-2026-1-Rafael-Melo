
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
(2, 3);

--Exercicio 1
SELECT e.nome AS editora, e.cidade
FROM editora e
LEFT JOIN livro l ON e.id_editora = l.id_editora;

--Exercicio 2
SELECT e.nome AS editora, COUNT(l.id_livro) AS total_livros
FROM editora e
LEFT JOIN livro l ON e.id_editora = l.id_editora
GROUP BY e.nome;

--Exercicio 3
SELECT a.nome AS autor, e.nome AS editora, COUNT(l.id_livro) AS total_livros
FROM autor a
JOIN livro l ON a.id_autor = l.id_autor
JOIN editora e ON l.id_editora = e.id_editora
GROUP BY a.nome, e.nome
ORDER BY a.nome, total_livros DESC;

--Exercicio 4
SELECT e.nome AS editora, COUNT(l.id_livro) AS total_livros
FROM editora e
JOIN livro l ON e.id_editora = l.id_editora
GROUP BY e.nome
HAVING COUNT(l.id_livro) > 1;

--Exercicio 5
SELECT e.nome AS editora,
COUNT(DISTINCT l.id_livro) AS total_livros,
COUNT(el.id_emprestimo) AS total_emprestimos
FROM editora e
LEFT JOIN livro l ON e.id_editora = l.id_editora
LEFT JOIN emprestimo_livro el ON l.id_livro = el.id_livro
LEFT JOIN emprestimo em ON el.id_emprestimo = em.id_emprestimo
GROUP BY e.nome
ORDER BY total_emprestimos DESC;
