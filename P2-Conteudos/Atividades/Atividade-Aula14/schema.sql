-- ATIVIDADE 14 --

-- Exercicio 1 --
CREATE OR REPLACE PROCEDURE inserir_livro(
    p_titulo VARCHAR,
    p_paginas INT,
    p_ano INT,
    p_id_autor INT,
    p_id_editora INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_existe INT;
BEGIN

    SELECT COUNT(*)
    INTO v_existe
    FROM autor
    WHERE id_autor = p_id_autor;

    IF v_existe = 0 THEN
        RAISE EXCEPTION 'Autor não encontrado';
    END IF;

    INSERT INTO livro(
        titulo,
        paginas,
        ano_publicacao,
        id_autor,
        id_editora
    )
    VALUES(
        p_titulo,
        p_paginas,
        p_ano,
        p_id_autor,
        p_id_editora
    );

END;
$$;

CALL inserir_livro(
    'Harry Potter',
    500,
    2001,
    1,
    1
);
-- Exercicio 2 --
CREATE OR REPLACE PROCEDURE atualizar_paginas(
    p_id_livro INT,
    p_paginas INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_paginas <= 10 THEN

        RAISE EXCEPTION
        'Número de páginas deve ser maior que 10';
    END IF;
    UPDATE livro
    SET paginas = p_paginas
    WHERE id_livro = p_id_livro;

END;
$$;
-- Exercicio 3 --
CREATE OR REPLACE PROCEDURE excluir_autor(
    p_id_autor INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total INT;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM livro
    WHERE id_autor = p_id_autor;
    IF v_total > 0 THEN
        RAISE EXCEPTION
        'Autor possui livros cadastrados';
    END IF;
    DELETE FROM autor
    WHERE id_autor = p_id_autor;
END;
$$;
-- Exercicio 4 --
CREATE OR REPLACE PROCEDURE media_paginas_autor(
    p_id_autor INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT
        a.nome,
        AVG(l.paginas)
    FROM autor a
    JOIN livro l
        ON l.id_autor = a.id_autor
    WHERE a.id_autor = p_id_autor
    GROUP BY a.nome;
END;
$$;
-- Exercicio 5 --
CREATE OR REPLACE PROCEDURE inserir_livro_seguro(
    p_titulo VARCHAR,
    p_paginas INT,
    p_ano INT,
    p_id_autor INT,
    p_id_editora INT

)
LANGUAGE plpgsql
AS $$
DECLARE
    v_autor INT;
BEGIN
    IF TRIM(p_titulo) = '' THEN
        RAISE EXCEPTION
        'Título não pode ser vazio';
    END IF;
    IF p_paginas <= 0 THEN
        RAISE EXCEPTION
        'Páginas devem ser maiores que zero';
    END IF;
    SELECT COUNT(*)
    INTO v_autor
    FROM autor
    WHERE id_autor = p_id_autor;
    IF v_autor = 0 THEN
        RAISE EXCEPTION
        'Autor não encontrado';
    END IF;
    INSERT INTO livro(
        titulo,
        paginas,
        ano_publicacao,
        id_autor,
        id_editora
    )
    VALUES(
        p_titulo,
        p_paginas,
        p_ano,
        p_id_autor,
        p_id_editora
    );
END;
$$;
-- Exercicio 6 --
CALL inserir_livro_seguro(
    'Livro Inválido',
    -100,
    2026,
    1,
    1
);