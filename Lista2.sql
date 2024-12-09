-- Criação do pacote Alunos
CREATE OR REPLACE PACKAGE PKG_ALUNO IS
    PROCEDURE EXCLUIR_ALUNO(p_id_aluno IN NUMBER);
    CURSOR CURSOR_ALUNOS_MAIORES_DE_18 IS
        SELECT nome, data_nascimento 
        FROM aluno 
        WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;
    CURSOR CURSOR_ALUNOS_POR_CURSO(p_id_curso IN NUMBER) IS
        SELECT a.nome 
        FROM aluno a
        JOIN matricula m ON a.id_aluno = m.id_aluno
        WHERE m.id_curso = p_id_curso;
END PKG_ALUNO;
/

-- Criação do corpo do pacote Alunos
CREATE OR REPLACE PACKAGE BODY PKG_ALUNO IS
    PROCEDURE EXCLUIR_ALUNO(p_id_aluno IN NUMBER) IS
    BEGIN
        DELETE FROM matricula WHERE id_aluno = p_id_aluno;
        DELETE FROM aluno WHERE id_aluno = p_id_aluno;
        DBMS_OUTPUT.PUT_LINE('Aluno e matrículas excluídos com sucesso!');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Aluno não encontrado.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao excluir aluno: ' || SQLERRM);
    END EXCLUIR_ALUNO;
END PKG_ALUNO;
/

-- Criação do pacote Disciplina
CREATE OR REPLACE PACKAGE PKG_DISCIPLINA IS
    PROCEDURE CADASTRAR_DISCIPLINA(
        p_nome        IN VARCHAR2,
        p_descricao   IN VARCHAR2,
        p_carga_horaria IN NUMBER
    );
    CURSOR CURSOR_TOTAL_ALUNOS IS
        SELECT d.nome AS nome_disciplina, COUNT(m.id_aluno) AS total_alunos
        FROM disciplina d
        JOIN matricula m ON d.id_disciplina = m.id_disciplina
        GROUP BY d.nome
        HAVING COUNT(m.id_aluno) > 10;
    CURSOR CURSOR_MEDIA_IDADE(p_id_disciplina IN NUMBER) IS
        SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12)) AS media_idade
        FROM aluno a
        JOIN matricula m ON a.id_aluno = m.id_aluno
        WHERE m.id_disciplina = p_id_disciplina;
    PROCEDURE LISTAR_ALUNOS_DISCIPLINA(p_id_disciplina IN NUMBER);
END PKG_DISCIPLINA;
/

-- Criação do corpo do pacote Disciplina
CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA IS
    PROCEDURE CADASTRAR_DISCIPLINA(
        p_nome        IN VARCHAR2,
        p_descricao   IN VARCHAR2,
        p_carga_horaria IN NUMBER
    ) IS
    BEGIN
        INSERT INTO disciplina (nome, descricao, carga_horaria)
        VALUES (p_nome, p_descricao, p_carga_horaria);
        DBMS_OUTPUT.PUT_LINE('Disciplina cadastrada com sucesso!');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar disciplina: ' || SQLERRM);
    END CADASTRAR_DISCIPLINA;

    PROCEDURE LISTAR_ALUNOS_DISCIPLINA(p_id_disciplina IN NUMBER) IS
        CURSOR c_alunos IS
            SELECT a.nome
            FROM aluno a
            JOIN matricula m ON a.id_aluno = m.id_aluno
            WHERE m.id_disciplina = p_id_disciplina;
        v_nome_aluno aluno.nome%TYPE;
    BEGIN
        OPEN c_alunos;
        LOOP
            FETCH c_alunos INTO v_nome_aluno;
            EXIT WHEN c_alunos%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Aluno: ' || v_nome_aluno);
        END LOOP;
        CLOSE c_alunos;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao listar alunos: ' || SQLERRM);
    END LISTAR_ALUNOS_DISCIPLINA;
END PKG_DISCIPLINA;
/

-- Criação do pacote Professor
CREATE OR REPLACE PACKAGE PKG_PROFESSOR IS
    CURSOR CURSOR_TOTAL_TURMAS_PROFESSOR IS
        SELECT p.nome AS nome_professor, COUNT(t.id_turma) AS total_turmas
        FROM professor p
        JOIN turma t ON p.id_professor = t.id_professor
        GROUP BY p.nome
        HAVING COUNT(t.id_turma) > 1;
    FUNCTION TOTAL_TURMAS_PROFESSOR(p_id_professor IN NUMBER) RETURN NUMBER;
    FUNCTION PROFESSOR_DA_DISCIPLINA(p_id_disciplina IN NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;
/

-- Criação do corpo do pacote Professor
CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR IS
    FUNCTION TOTAL_TURMAS_PROFESSOR(p_id_professor IN NUMBER) RETURN NUMBER IS
        v_total_turmas NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total_turmas
        FROM turma
        WHERE id_professor = p_id_professor;
        RETURN v_total_turmas;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao calcular total de turmas: ' || SQLERRM);
            RETURN -1;
    END TOTAL_TURMAS_PROFESSOR;

    FUNCTION PROFESSOR_DA_DISCIPLINA(p_id_disciplina IN NUMBER) RETURN VARCHAR2 IS
        v_nome_professor VARCHAR2(100);
    BEGIN
        SELECT p.nome
        INTO v_nome_professor
        FROM professor p
        JOIN turma t ON p.id_professor = t.id_professor
        JOIN disciplina d ON t.id_disciplina = d.id_disciplina
        WHERE d.id_disciplina = p_id_disciplina;
        RETURN v_nome_professor;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Professor não encontrado';
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao buscar professor da disciplina: ' || SQLERRM);
            RETURN NULL;
    END PROFESSOR_DA_DISCIPLINA;
END PKG_PROFESSOR;
/
