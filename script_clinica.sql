/*
SCRIPT: clinica_medica
OBJETIVO: Criar banco de dados, tabelas, inserir dados, e realizar consultas
SGBD: PostgreSQL
AUTORES: Jefferson Matheus Ferreira de Lima, Felipe Lima, Ryan Kauan Medeiros de Souza, Jose Viton dos Santos
*/

-- Criação do banco de dados (Descomente caso queira que o script crie o banco)
-- CREATE DATABASE clinica ENCODING 'UTF8';

-- No psql, você se conectaria ao banco usando o comando abaixo:
-- \c clinica;

-- Remover tabelas existentes (se existirem) respeitando a hierarquia ou forçando com CASCADE
DROP TABLE IF EXISTS tb_agendamentos CASCADE;
DROP TABLE IF EXISTS tb_horarios CASCADE;
DROP TABLE IF EXISTS tb_telefones_paciente CASCADE;
DROP TABLE IF EXISTS tb_medicos CASCADE;
DROP TABLE IF EXISTS tb_pacientes CASCADE;
DROP TABLE IF EXISTS tb_enderecos_paciente CASCADE;
DROP TABLE IF EXISTS tb_especialidades CASCADE;

--
-- Estrutura da tabela tb_especialidades
--
CREATE TABLE tb_especialidades (
    id      SERIAL PRIMARY KEY,
    nome    VARCHAR(80) NOT NULL UNIQUE
);

COMMENT ON TABLE tb_especialidades IS 'Tabela responsável por armazenar o nome das especialidades disponíveis na clínica';
COMMENT ON COLUMN tb_especialidades.id IS 'Identificador único da especialidade';
COMMENT ON COLUMN tb_especialidades.nome IS 'Nome da especialidade';

--
-- Estrutura da tabela tb_enderecos_paciente
--
CREATE TABLE tb_enderecos_paciente(
    id          SERIAL PRIMARY KEY,
    cidade      VARCHAR(30) NOT NULL,
    uf          VARCHAR(2) NOT NULL,
    nome_rua    VARCHAR(80) NOT NULL,
    numero_casa VARCHAR(6) NOT NULL,
    numero_cep  VARCHAR(9) NOT NULL,
    nome_bairro VARCHAR(80) NOT NULL
);

COMMENT ON TABLE tb_enderecos_paciente IS 'Tabela responsável por armazenar o endereço onde os pacientes moram';
COMMENT ON COLUMN tb_enderecos_paciente.id IS 'Identificador único do endereço do paciente';
COMMENT ON COLUMN tb_enderecos_paciente.cidade IS 'Nome da cidade';
COMMENT ON COLUMN tb_enderecos_paciente.uf IS 'Nome do estado';
COMMENT ON COLUMN tb_enderecos_paciente.nome_rua IS 'Nome da rua';
COMMENT ON COLUMN tb_enderecos_paciente.numero_casa IS 'Número da casa';
COMMENT ON COLUMN tb_enderecos_paciente.numero_cep IS 'Número do CEP';
COMMENT ON COLUMN tb_enderecos_paciente.nome_bairro IS 'Nome do bairro';

--
-- Estrutura da tabela tb_pacientes
--
CREATE TABLE tb_pacientes(
    id              SERIAL PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL,
    cpf             VARCHAR(14) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    sexo            VARCHAR(10) NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    id_endereco     INT,

    CONSTRAINT fk_paciente_endereco FOREIGN KEY(id_endereco)
        REFERENCES tb_enderecos_paciente(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE tb_pacientes IS 'Tabela responsável por armazenar informações relacionadas aos pacientes da clínica';
COMMENT ON COLUMN tb_pacientes.id IS 'Identificador único do paciente';
COMMENT ON COLUMN tb_pacientes.nome IS 'Nome do paciente';
COMMENT ON COLUMN tb_pacientes.cpf IS 'Número do CPF';
COMMENT ON COLUMN tb_pacientes.data_nascimento IS 'Data de nascimento';
COMMENT ON COLUMN tb_pacientes.sexo IS 'Sexo do paciente';
COMMENT ON COLUMN tb_pacientes.email IS 'Email do paciente';
COMMENT ON COLUMN tb_pacientes.id_endereco IS 'Identificador do endereço do paciente';

--
-- Estrutura da tabela tb_telefones_paciente
--
CREATE TABLE tb_telefones_paciente(
    id              SERIAL PRIMARY KEY,
    numero_telefone VARCHAR(20) NOT NULL,
    id_paciente     INT,

    CONSTRAINT fk_telefone_paciente FOREIGN KEY(id_paciente)
        REFERENCES tb_pacientes(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE 
);

COMMENT ON TABLE tb_telefones_paciente IS 'Tabela responsável por armazenar os telefones de um paciente';
COMMENT ON COLUMN tb_telefones_paciente.id IS 'Identificador único do telefone do paciente';
COMMENT ON COLUMN tb_telefones_paciente.numero_telefone IS 'Número de telefone';
COMMENT ON COLUMN tb_telefones_paciente.id_paciente IS 'Identificador do paciente responsavel pelo número de telefone';

--
-- Estrutura da tabela tb_medicos
--
CREATE TABLE tb_medicos(
    id                  SERIAL PRIMARY KEY,
    nome                VARCHAR(100) NOT NULL,
    curriculo           VARCHAR(255) NOT NULL,
    id_especialidade    INT,

    CONSTRAINT fk_especialidade FOREIGN KEY (id_especialidade)
        REFERENCES tb_especialidades(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE tb_medicos IS 'Tabela responsável por armazenar as informações dos médicos que trabalham na clínica';
COMMENT ON COLUMN tb_medicos.id IS 'Identificador único do medico';
COMMENT ON COLUMN tb_medicos.nome IS 'Nome do medico';
COMMENT ON COLUMN tb_medicos.curriculo IS 'Curriculo profisional do medico';
COMMENT ON COLUMN tb_medicos.id_especialidade IS 'Identificador da especialidade que o medico atua';

--
-- Estrutura da tabela tb_horarios
--
CREATE TABLE tb_horarios(
    id                  SERIAL PRIMARY KEY,
    data_atendimento    DATE NOT NULL,
    horario_atendimento TIME NOT NULL,
    status_atendimento  VARCHAR(12) NOT NULL,
    id_medico           INT,

    CONSTRAINT fk_medico FOREIGN KEY (id_medico)
        REFERENCES tb_medicos(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

COMMENT ON TABLE tb_horarios IS 'Tabela responsável por armazenar os horários em que os médicos estarão disponíveis ou não para realizar seu atendimento';
COMMENT ON COLUMN tb_horarios.id IS 'Identificador único do horario';
COMMENT ON COLUMN tb_horarios.data_atendimento IS 'Data de atendimento';
COMMENT ON COLUMN tb_horarios.horario_atendimento IS 'Horario do atendimento';
COMMENT ON COLUMN tb_horarios.status_atendimento IS 'Status do atendimento';
COMMENT ON COLUMN tb_horarios.id_medico IS 'Identificador do medico em seu horario';

--
-- Estrutura da tabela tb_agendamentos
--
CREATE TABLE tb_agendamentos(
    id                  SERIAL PRIMARY KEY,
    id_paciente         INT,
    id_horario          INT,
    status_agendamento  VARCHAR(20),

    CONSTRAINT fk_paciente FOREIGN KEY (id_paciente)
        REFERENCES tb_pacientes(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_horario FOREIGN KEY (id_horario)
        REFERENCES tb_horarios(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

COMMENT ON TABLE tb_agendamentos IS 'Tabela responsável por armazenar informações dos agendamentos que serão efetuados com um determinado paciente e médico de uma determinada especialidade';
COMMENT ON COLUMN tb_agendamentos.id IS 'Identificador único do agendamento';
COMMENT ON COLUMN tb_agendamentos.id_paciente IS 'Identificador do paciente';
COMMENT ON COLUMN tb_agendamentos.id_horario IS 'Identificador do horario';
COMMENT ON COLUMN tb_agendamentos.status_agendamento IS 'Status do agendamendo';

--
-- Inserindo dados para a tabela tb_especialidades
--
INSERT INTO tb_especialidades (id, nome) VALUES
    (1, 'Cardiologia'),
    (2, 'Dermatologia'),
    (3, 'Ginecologia'),
    (6, 'Oftalmologia'),
    (4, 'Ortopedia'),
    (5, 'Pediatria');

-- Apenas atualizando o contador da sequence devido aos inserts manuais de IDs
SELECT setval(pg_get_serial_sequence('tb_especialidades', 'id'), coalesce(max(id),0) + 1, false) FROM tb_especialidades;

--
-- Inserindo dados para a tabela tb_medicos
--
INSERT INTO tb_medicos (id, nome, curriculo, id_especialidade) VALUES
    (1, 'Raimundão', 'Se seu coração está acelerado, pare de tomar café. Se está devagar, tome café. Prescrição padrão: água e resignação. Atendo plantões apenas para fugir da minha família.', 1),
    (2, 'Tonho dos Couros', 'Prescrevo sabão de coco para tudo, até câncer de pele. Se a pele está ruim, a vida provavelmente também está. Minha loção milagrosa é 99% água e 1% esperança.', 2),
    (3, 'Já Queline', 'Acredito que 90% dos sintomas são culpa do seu parceiro. Minha especialidade é o olhar de julgamento silencioso durante a consulta. Trabalho com a técnica do "já acabou, Jéssica?".', 3),
    (4, 'Kal Citran', 'Se quebrou, coloque gelo. Se não quebrou, também coloque. Minha terapia: "na minha época ninguém reclamava de dor nas costas". Cirurgias realizadas com nível técnico de montador de móveis de loja de departamentos.', 4),
    (5, 'Maria das Graças', 'Diagnóstico padrão: "é virose, volta em 7 dias se não melhorar". Conselho profissional: "dá um celular que ele para de chorar". Acredito que febre se cura com cobertor, suor e culpa materna.', 5),
    (6, 'Iris Retina', 'Se não enxerga bem, provavelmente é frescura sua. Minha tese de doutorado se chama "Por que todo paciente mente sobre usar os óculos". Agendamentos apenas para quem não pisca durante a consulta.', 6);

SELECT setval(pg_get_serial_sequence('tb_medicos', 'id'), coalesce(max(id),0) + 1, false) FROM tb_medicos;

--
-- Inserindo dados para a tabela tb_horarios
--
INSERT INTO tb_horarios (id, data_atendimento, horario_atendimento, status_atendimento, id_medico) VALUES
    (1, '2026-02-01', '08:00:00', 'Ocupado', 1),
    (2, '2026-02-01', '09:00:00', 'Disponível', 1),
    (3, '2026-02-01', '10:00:00', 'Ocupado', 2),
    (4, '2026-02-01', '11:00:00', 'Disponível', 2),
    (5, '2026-02-01', '08:00:00', 'Ocupado', 3),
    (6, '2026-01-31', '09:00:00', 'Ocupado', 3),
    (7, '2026-02-03', '14:00:00', 'Disponível', 6),
    (8, '2026-02-03', '14:30:00', 'Ocupado', 6),
    (9, '2026-02-03', '15:30:00', 'Ocupado', 6),
    (10, '2026-02-03', '16:00:00', 'Disponível', 6),
    (11, '2026-02-03', '17:00:00', 'Disponível', 6),
    (12, '2026-02-03', '10:00:00', 'Disponível', 4),
    (13, '2026-02-03', '10:30:00', 'Disponível', 4),
    (14, '2026-02-03', '14:00:00', 'Disponível', 4),
    (15, '2026-02-03', '14:30:00', 'Disponível', 4),
    (16, '2026-02-03', '17:00:00', 'Ocupado', 4),
    (17, '2026-02-03', '17:30:00', 'Disponível', 4),
    (18, '2026-02-03', '08:00:00', 'Ocupado', 3),
    (19, '2026-02-03', '08:30:00', 'Disponível', 3),
    (20, '2026-02-03', '09:00:00', 'Disponível', 3),
    (21, '2026-02-03', '09:30:00', 'Disponível', 3),
    (22, '2026-02-03', '10:00:00', 'Disponível', 3),
    (23, '2026-02-03', '10:30:00', 'Disponível', 3),
    (24, '2026-02-03', '11:00:00', 'Disponível', 3),
    (25, '2026-02-03', '11:30:00', 'Disponível', 3);

SELECT setval(pg_get_serial_sequence('tb_horarios', 'id'), coalesce(max(id),0) + 1, false) FROM tb_horarios;

--
-- Inserindo dados para a tabela tb_enderecos_paciente
--
INSERT INTO tb_enderecos_paciente (id, cidade, uf, nome_rua, numero_casa, numero_cep, nome_bairro) VALUES
    (1, 'Natal', 'RN', 'Av. Hermes da Fonseca', '120', '59020-000', 'Tirol'),
    (2, 'Parnamirim', 'RN', 'Rua Clementino Bento', '45', '59140-100', 'Centro'),
    (3, 'Mossoró', 'RN', 'Rua Alberto Maranhão', '1010', '59600-005', 'Alto da Conceição'),
    (4, 'Natal', 'RN', 'Rua dos Potiguares', '500', '59054-000', 'Lagoa Nova'),
    (5, 'Caicó', 'RN', 'Av. Seridó', '22', '59300-000', 'Centro'),
    (6, 'gvwergwer gerg et', 'rf', 'rua de teste', '234', '12312-343', 'vwetrgertg');

SELECT setval(pg_get_serial_sequence('tb_enderecos_paciente', 'id'), coalesce(max(id),0) + 1, false) FROM tb_enderecos_paciente;

--
-- Inserindo dados para a tabela tb_pacientes
--
INSERT INTO tb_pacientes (id, nome, cpf, data_nascimento, sexo, email, id_endereco) VALUES
    (1, 'Ana Silva Sauro', '111.222.333-44', '1990-05-15', 'Feminino', 'ana.silva@email.com', 1),
    (2, 'Zé da Mina Abandonada', '222.333.444-55', '1985-10-20', 'Masculino', 'zedamina.a@email.com', 2),
    (3, 'Pauliiiiiiiiiiiiinha me diz o que que eu faço', '333.444.555-66', '2000-01-30', 'Feminino', 'pau.linha@email.com', 3),
    (4, 'Maicon Jéquisson Bile Jeans', '444.555.666-77', '1978-03-12', 'Masculino', 'my.comjeqisson@email.com', 4),
    (5, 'Silvo Santo', '555.666.777-88', '1995-07-07', 'Masculino', 'silvo.santo@email.com', 5),
    (6, 'Ixxtéffanny Aubisoluta', '966.666.345-23', '1990-10-10', 'Feminino', 'teste@teste.com', 6);

SELECT setval(pg_get_serial_sequence('tb_pacientes', 'id'), coalesce(max(id),0) + 1, false) FROM tb_pacientes;

--
-- Inserindo dados para a tabela tb_telefones_paciente
--
INSERT INTO tb_telefones_paciente (id, numero_telefone, id_paciente) VALUES
    (1, '(84) 99999-9999', 1),
    (2, '(85) 98888-8888', 1),
    (4, '(77) 77777-7777', 6),
    (5, '(33) 33333-3333', 6),
    (6, '(77) 77777-7777', 5),
    (7, '(44) 44444-4444', 4),
    (8, '(22) 22222-2222', 4),
    (9, '(34) 63647-4567', 3);

SELECT setval(pg_get_serial_sequence('tb_telefones_paciente', 'id'), coalesce(max(id),0) + 1, false) FROM tb_telefones_paciente;

--
-- Inserindo dados para a tabela tb_agendamentos
--
INSERT INTO tb_agendamentos (id, id_paciente, id_horario, status_agendamento) VALUES
    (1, 1, 1, 'Confirmado'),
    (2, 2, 3, 'Confirmado'),
    (3, 3, 5, 'Pendente'),
    (4, 4, 6, 'Cancelado'),
    (5, 4, 8, 'Confirmado'),
    (6, 3, 9, 'Confirmado'),
    (7, 5, 16, 'A Confirmar'),
    (8, 6, 18, 'A Confirmar');

SELECT setval(pg_get_serial_sequence('tb_agendamentos', 'id'), coalesce(max(id),0) + 1, false) FROM tb_agendamentos;

COMMIT;