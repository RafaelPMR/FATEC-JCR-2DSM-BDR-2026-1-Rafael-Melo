ALTER TABLE livro
ADD COLUMN quantidade INT DEFAULT 0;

CREATE TABLE log_livro (
    id_log SERIAL PRIMARY KEY,
    titulo VARCHAR(150),
    data_exclusao TIMESTAMP,
    mensagem VARCHAR(255)
);
-- Exercicio 1 --

CREATE OR REPLACE FUNCTION bloquear_exclusao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.quantidade > 0 THEN
        RAISE EXCEPTION
        'Não é possível excluir livro com exemplares disponíveis';
    END IF;
    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_bloquear_exclusao
BEFORE DELETE
ON livro
FOR EACH ROW
EXECUTE FUNCTION bloquear_exclusao();

-- Exercicio 2 --
CREATE OR REPLACE FUNCTION log_exclusao_livro()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO log_livro(
        titulo,
        data_exclusao,
        mensagem
    )
    VALUES(
        OLD.titulo,
        NOW(),
        'Livro removido do sistema'
    );
    RETURN OLD;
END;
$$;

CREATE TRIGGER trg_log_exclusao
AFTER DELETE
ON livro
FOR EACH ROW
EXECUTE FUNCTION log_exclusao_livro();

-- Exercicio 3 --
CREATE OR REPLACE FUNCTION validar_limite_estoque()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.quantidade > 100 THEN
        RAISE EXCEPTION
        'Quantidade não pode ultrapassar 100 unidades';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validar_limite
BEFORE UPDATE
ON livro
FOR EACH ROW
EXECUTE FUNCTION validar_limite_estoque();

-- Exercicio 4 --

-- A. BEFORE executa antes da operação (INSERT, UPDATE ou DELETE),
-- permitindo validar ou impedir a ação.

-- AFTER executa após a operação ter sido concluída,
-- sendo utilizado principalmente para auditoria, logs e ações complementares.

-- B. BEFORE, pois permite impedir a operação antes que os dados sejam gravados no banco.

-- C. AFTER, pois garante que apenas operações concluídas com sucesso sejam registradas.

-- D. Porque não adianta registrar uma alteração no BEFORE se ela pode ser
-- bloqueada pela validação. Da mesma forma, não adianta validar no AFTER,
-- pois a alteração já terá sido realizada. A ordem garante que primeiro
-- ocorra a validação e depois o registro da operação.

-- Exercicio 5 --
-- A.Usuários ou sistemas com acesso direto ao banco podem inserir dados inválidos.
-- Em caso de falha na aplicação, as regras de negócio podem deixar de ser aplicadas.

-- B.Menos encargo para o Backend, mais segurança de que mesmo burlando o Backend, ainda haverá validação/registro, com um banco autoprotegido

-- C. Padronizam, protegem, registram automaticamente ações, prevenindo erros e esquecimentos
-- D. Um registro de acessos de uma página por exemplo, usaria um Trigger After, para registrar logs de acesso

