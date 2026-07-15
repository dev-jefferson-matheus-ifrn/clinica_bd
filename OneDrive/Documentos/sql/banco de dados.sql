select * from vw_agenda_medicos
where data = '2026-02-01';

select data_atendimento from tb_horarios;

CREATE OR REPLACE FUNCTION fn_validar_agendamento()
RETURNS TRIGGER AS $$
DECLARE
    v_status_horario VARCHAR(12);
    v_conflito_paciente INT;
BEGIN
    -- 1. Buscar o status do horário que está sendo agendado
    SELECT status_atendimento INTO v_status_horario
    FROM tb_horarios
    WHERE id = NEW.id_horario;

    -- 2. Se o horário já estiver 'Ocupado', cancela o agendamento
    IF v_status_horario = 'Ocupado' THEN
        RAISE EXCEPTION 'Erro: O médico já possui um compromisso neste horário!';
    END IF;

    -- 3. Verificar se o paciente já tem outro agendamento confirmado/pendente no mesmo horário
    SELECT COUNT(*) INTO v_conflito_paciente
    FROM tb_agendamentos a
    JOIN tb_horarios h_novo ON h_novo.id = NEW.id_horario
    JOIN tb_horarios h_existente ON h_existente.id = a.id_horario
    WHERE a.id_paciente = NEW.id_paciente
      AND a.id <> COALESCE(NEW.id, -1) -- Ignora o próprio registro em caso de UPDATE
      AND h_existente.data_atendimento = h_novo.data_atendimento
      AND h_existente.horario_atendimento = h_novo.horario_atendimento
      AND a.status_agendamento IN ('Confirmado', 'Pendente', 'A Confirmar');

    IF v_conflito_paciente > 0 THEN
        RAISE EXCEPTION 'Erro: Este paciente já possui uma consulta marcada neste mesmo dia e horário!';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Remove o gatilho se ele já existir (evita erros ao rodar o script novamente)
DROP TRIGGER IF EXISTS tg_verificar_agendamento ON tb_agendamentos;

-- Cria o gatilho para disparar ANTES de inserir ou atualizar
CREATE TRIGGER tg_verificar_agendamento
BEFORE INSERT OR UPDATE ON tb_agendamentos
FOR EACH ROW
EXECUTE FUNCTION fn_validar_agendamento();