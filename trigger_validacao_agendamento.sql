CREATE OR REPLACE FUNCTION fn_impedir_data_passada()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.data_atendimento < CURRENT_DATE THEN
        RAISE EXCEPTION 'Erro: Não é permitido cadastrar horários em datas passadas!';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tg_impedir_data_passada
BEFORE INSERT ON tb_horarios
FOR EACH ROW
EXECUTE FUNCTION fn_impedir_data_passada();
