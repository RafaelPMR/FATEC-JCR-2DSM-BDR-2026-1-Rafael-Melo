DROP TABLE IF EXISTS emprestimo_livro, emprestimo, livro, aluno, autor CASCADE;

CREATE TABLE autor (
    id_autor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE livro (
    id_livro SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    ano_publicacao INT,
    id_autor INT REFERENCES autor(id_autor)
);

CREATE TABLE aluno (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    curso VARCHAR(100) NOT NULL
);

CREATE TABLE emprestimo (
    id_emprestimo SERIAL PRIMARY KEY,
    data_emprestimo DATE NOT NULL,
    id_aluno INT REFERENCES aluno(id_aluno)
);

CREATE TABLE emprestimo_livro (
    id_emprestimo INT REFERENCES emprestimo(id_emprestimo),
    id_livro INT REFERENCES livro(id_livro),
    PRIMARY KEY (id_emprestimo, id_livro)
);

INSERT INTO autor (nome) VALUES
('J R R Tolkien'),
('Machado de Assis'),
('Clarice Lispector'),
('J.K. Rowling');

INSERT INTO livro (titulo, ano_publicacao, id_autor) VALUES
('O Senhor dos Anéis', 1954, 1),
('Dom Casmurro', 1899, 2),
('A Hora da Estrela', 1977, 3),
('O Hobbit', 1937, 1);

INSERT INTO aluno (nome, curso) VALUES
('Erick', 'Sistemas de Informação'),
('Rafael', 'Engenharia de Software');

INSERT INTO emprestimo (data_emprestimo, id_aluno) VALUES
('2025-08-20', 1),
('2025-08-21', 2);

INSERT INTO emprestimo_livro (id_emprestimo, id_livro) VALUES
(1, 1),
(1, 2),
(2, 3);

SELECT l.titulo, a.nome AS autor
FROM livro l
INNER JOIN autor a ON l.id_autor = a.id_autor;

SELECT l.titulo, al.nome AS aluno, e.data_emprestimo
FROM emprestimo e
INNER JOIN aluno al ON e.id_aluno = al.id_aluno
INNER JOIN emprestimo_livro el ON e.id_emprestimo = el.id_emprestimo
INNER JOIN livro l ON el.id_livro = l.id_livro;

SELECT l.titulo, a.nome AS autor, al.nome AS aluno
FROM livro l
INNER JOIN autor a ON l.id_autor = a.id_autor
LEFT JOIN emprestimo_livro el ON l.id_livro = el.id_livro
LEFT JOIN emprestimo e ON el.id_emprestimo = e.id_emprestimo
LEFT JOIN aluno al ON e.id_aluno = al.id_aluno;

SELECT l.titulo, al.nome AS aluno, e.data_emprestimo
FROM livro l
RIGHT JOIN emprestimo_livro el ON l.id_livro = el.id_livro
RIGHT JOIN emprestimo e ON el.id_emprestimo = e.id_emprestimo
RIGHT JOIN aluno al ON e.id_aluno = al.id_aluno;

SELECT al.nome, COUNT(e.id_emprestimo) AS total_emprestimos
FROM aluno al
INNER JOIN emprestimo e ON al.id_aluno = e.id_aluno
GROUP BY al.nome;