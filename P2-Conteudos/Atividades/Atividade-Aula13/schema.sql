-- ATIVIDADE 13 --

-- Exercicio 1 --
CREATE VIEW vw_livros_paginas AS 
SELECT titulo, paginas FROM livro;
SELECT * FROM vw_livros_paginas

-- Exercicio 2 --
CREATE VIEW vw_autores_mais_de_um_livro AS
SELECT
a.nome,
COUNT(*) AS total_livros
FROM autor a
JOIN livro l
ON a.id_autor = l.id_autor
GROUP BY a.nome
HAVING COUNT(*) > 1;
SELECT * FROM vw_autores_mais_de_um_livro

-- Exercicio 3 --

CREATE VIEW vw_acima_da_media AS
SELECT titulo, paginas
FROM livro
WHERE paginas >
(
SELECT AVG(paginas)
FROM livro
);
SELECT * FROM vw_acima_da_media

-- Exercicio 4 --

CREATE VIEW vw_autor_livro_ano AS
SELECT
a.nome AS autor,
l.titulo,
l.ano_publicacao
FROM autor a
JOIN livro l
ON a.id_autor = l.id_autor;
SELECT * FROM vw_autor_livro_ano

-- Exercicio 5 --
CREATE VIEW vw_estatistica AS
SELECT
    a.nome AS autor,
    COUNT(*) AS total_livros,
    MAX(l.paginas) AS maior_numero_paginas

FROM autor a
JOIN livro l
    ON a.id_autor = l.id_autor

GROUP BY a.nome;

SELECT * FROM vw_estatistica