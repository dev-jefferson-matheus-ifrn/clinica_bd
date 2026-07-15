create or replace procedure sp_agendar_consulta(
    p_id_paciente int,
    p_id_horario int,
    p_status_agendamento varchar(20) default 'confirmado'
)
language plpgsql
as $$
declare
    v_status_horario varchar(12);
    v_paciente_existe boolean;
begin
    select exist(select 1 from tb_paciente where id = p_id_paciente) into v_paciente_existe;
    if not v_paciente_existe then
    raise exception 'erro: paciente id não encontrado', p_id_paciente;
end if;

    select status_atendimento into v_status_horario
    from tb_horarios
    where id = p_id_horario;

    if v_status_horario is null then
        raise exception 'erro: horário com id não existe', p_id_horario
    elsif v_status_horario <> 'disponivel' then
        raise exception 'erro: o horário informado não está disponivel. status atual: %', v_status_horario;
end if;

    insert into tb_agendamentos (id_paciente, id_horario, status_agendamentos)
    values (p_id_paciente, p_id_horario, p_status_agendamento);

    update tb_horarios
    set status_atendimento = 'ocupado'
    where id = p_id_horario;

    raise notice 'sucesso: falha ao processar o agendamento:',sqlerrm;

exception
    when others then
        raise exception 'falha ao processar o agendamento:', sqlerrm;
end;
$$;

