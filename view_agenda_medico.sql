/* VIEW USADA PARA RETORNAR A AGENDA GERAL COM BASE EM UMA DATA*/
CREATE OR REPLACE VIEW vw_agenda_medicos AS
    SELECT 
        e.nome AS especialidade, 
        m.nome AS medico,
        p.nome AS paciente,
        h.horario_atendimento AS horario,
        st.status_agendamento AS status,
        h.data_atendimento AS data
    FROM tb_agendamentos st
    JOIN tb_pacientes p ON st.id_paciente = p.id
    JOIN tb_horarios h ON st.id_horario = h.id
    JOIN tb_medicos m ON h.id_medico = m.id
    JOIN tb_especialidades e ON m.id_especialidade = e.id;