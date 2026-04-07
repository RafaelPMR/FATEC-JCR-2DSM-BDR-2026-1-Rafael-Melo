SELECT nome
FROM editora;

SELECT e.nome, count(l.id_livro)
FROM editora e
LEFT JOIN livro l
ON e.id_editora = l.id_editora
GROUP BY e.nome;

SELECT e.nome, count(l.id_livro), a.nome
FROM editora e
INNER JOIN livro l
ON l.id_editora = e.id_editora
INNER JOIN autor a
ON l.id_autor = a.id_autor
GROUP BY e.nome, a.nome;

SELECT e.nome, count(l.id_livro)
FROM editora e
INNER JOIN livro l
ON e.id_editora = l.id_editora
GROUP BY e.nome
HAVING count(l.id_livro) > 1;

SELECT e.nome, count(l.id_livro), count(el.id_emprestimo)
FROM editora e
INNER JOIN livro l
ON e.id_editora = l.id_livro
INNER JOIN emprestimo_livro el
ON l.id_livro = el.id_livro
GROUP BY e.nome;