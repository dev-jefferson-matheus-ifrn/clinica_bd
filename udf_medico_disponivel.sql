/*
A função **`fn_medico_disponivel`** foi desenvolvida para verificar se um determinado médico possui pelo menos um horário de atendimento
disponível para agendamento. Ela recebe como parâmetro o identificador (`id`) do médico e retorna um valor do tipo **BOOLEAN**, ou seja,
`TRUE` quando existe pelo menos um horário disponível e `FALSE` quando não há nenhum.
Para realizar essa verificação, a função utiliza a cláusula `EXISTS`, que pesquisa na tabela `tb_horarios` se existe algum registro
em que o campo `id_medico` corresponda ao médico informado e o campo `status_atendimento` esteja com o valor **'Disponível'**.
O uso do `EXISTS` torna a consulta eficiente, pois a busca é interrompida assim que o primeiro registro correspondente é encontrado, 
sem a necessidade de percorrer toda a tabela.
Essa função é útil para facilitar consultas e automatizar verificações no sistema da clínica, permitindo identificar rapidamente 
quais médicos possuem horários livres para novos agendamentos. Dessa forma, evita-se a repetição da mesma lógica em diferentes 
consultas SQL e torna o código mais organizado, reutilizável e de fácil manutenção.
*/
CREATE OR REPLACE FUNCTION fn_medico_disponivel(id_med INT)
RETURNS BOOLEAN AS
$$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM tb_horarios
        WHERE id_medico = id_med
          AND status_atendimento = 'Disponível'
    );
END;
$$
LANGUAGE plpgsql;