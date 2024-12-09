#Instruções de Execução

-Acesse o Oracle Live SQL.
-Faça login com sua conta Oracle (ou crie uma, se ainda não tiver).
-No painel inicial, clique em "My Scripts" e, em seguida, no botão "Create".
-Copie e cole o conteúdo do script no editor de texto do Oracle Live SQL.
-Clique em "Run" para executar o script.

-------------------------------------------

#Resumo dos Pacotes

#PKG_ALUNO:
Gerencia as operações relacionadas a alunos. Funcionalidades incluídas:
#EXCLUIR_ALUNO: Exclui um aluno e todas as matrículas associadas.
#CURSOR_ALUNOS_MAIORES_DE_18: Lista os alunos maiores de 18 anos.
CURSOR_ALUNOS_POR_CURSO: Lista os alunos matriculados em um curso específico.

#PKG_DISCIPLINA
Executa operações relacionadas a disciplinas. Funcionalidades:
#CADASTRAR_DISCIPLINA: Cadastra uma nova disciplina no banco de dados.
#CURSOR_TOTAL_ALUNOS: Lista as disciplinas com mais de 10 alunos matriculados.
#CURSOR_MEDIA_IDADE: Calcula a média de idade dos alunos matriculados em uma disciplina específica.
#LISTAR_ALUNOS_DISCIPLINA: Exibe os alunos matriculados em uma disciplina.

#PKG_PROFESSOR
Implementa funções para professores. Funcionalidades:
#CURSOR_TOTAL_TURMAS_PROFESSOR: Lista os professores com mais de uma turma.
#TOTAL_TURMAS_PROFESSOR: Retorna o total de turmas de um professor.
#PROFESSOR_DA_DISCIPLINA: Retorna o nome do professor que ministra uma disciplina específica.
