CREATE OR REPLACE PROCEDURE sp_agendar_consulta(
    IN p_id_paciente INT,
    IN p_id_horario INT,
    IN p_status_agendamento VARCHAR(20) DEFAULT 'Confirmado'
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status_horario VARCHAR(12);
    v_paciente_existe BOOLEAN;
BEGIN
    -- Verifica se o paciente existe
    SELECT EXISTS (
        SELECT 1
        FROM tb_pacientes
        WHERE id = p_id_paciente
    )
    INTO v_paciente_existe;

    IF NOT v_paciente_existe THEN
        RAISE EXCEPTION 'Erro: paciente com ID % não encontrado.', p_id_paciente;
    END IF;

    -- Obtém o status do horário
    SELECT status_atendimento
    INTO v_status_horario
    FROM tb_horarios
    WHERE id = p_id_horario;

    -- Verifica se o horário existe
    IF v_status_horario IS NULL THEN
        RAISE EXCEPTION 'Erro: horário com ID % não existe.', p_id_horario;
    END IF;

    -- Verifica disponibilidade
    IF LOWER(v_status_horario) <> 'disponível'
       AND LOWER(v_status_horario) <> 'disponivel' THEN
        RAISE EXCEPTION
            'Erro: o horário informado não está disponível. Status atual: %',
            v_status_horario;
    END IF;

    -- Cria o agendamento
    INSERT INTO tb_agendamentos (
        id_paciente,
        id_horario,
        status_agendamento
    )
    VALUES (
        p_id_paciente,
        p_id_horario,
        p_status_agendamento
    );

    -- Atualiza o horário
    UPDATE tb_horarios
    SET status_atendimento = 'Ocupado'
    WHERE id = p_id_horario;

    RAISE NOTICE 'Agendamento realizado com sucesso.';

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Falha ao processar o agendamento: %', SQLERRM;
END;
$$;
