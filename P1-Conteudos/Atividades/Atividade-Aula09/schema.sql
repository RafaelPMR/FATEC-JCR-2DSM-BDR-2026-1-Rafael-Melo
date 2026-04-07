SELECT e.titulo, te.nome
FROM Evento e
INNER JOIN TipoEvento te
ON e.idTipoEvento = te.idTipoEvento;

SELECT e.titulo, l.cidade, l.estado
FROM Evento e
INNER JOIN Localizacao l
ON e.idLocalizacao = l.idLocalizacao;

SELECT e.titulo, te.nome, l.cidade
FROM Evento e
INNER JOIN TipoEvento te
ON e.idTipoEvento = te.idTipoEvento
LEFT JOIN Localizacao l
ON e.idLocalizacao = l.idLocalizacao;

SELECT l.cidade, l.estado, e.titulo 
FROM Localizacao l
INNER JOIN Evento e
ON l.idLocalizacao = e.idLocalizacao;

SELECT l.cidade,  count(e.idLocalizacao)
FROM Localizacao l
INNER JOIN Evento e
ON l.idLocalizacao = e.idLocalizacao
GROUP BY l.cidade;