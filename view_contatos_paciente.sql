-- Made by: Letícia Geovana Lopes dos Santos
-- View: Exibição dos Dados para Contato do Paciente

-- Cria a view vw_contato_paciente que exibe os dados de contato do paciente, incluindo nome, email, telefone e endereço completo.
CREATE OR REPLACE VIEW vw_contato_paciente AS
	SELECT
		p.nome AS paciente,
        p.email AS email,
        t.numero_telefone AS telefone,
        CONCAT(e.nome_rua, ', ', e.numero_casa, ', ', e.nome_bairro, ', ', e.numero_cep, ', ', e.cidade, '/', e.uf) AS endereco
	FROM tb_pacientes p
    JOIN tb_telefones_paciente t ON p.id = t.id_paciente
    JOIN tb_enderecos_paciente e ON p.id_endereco = e.id
	ORDER BY p.id ASC;

-- Exibe os dados de contato do paciente a partir da view vw_contato_paciente.
SELECT * FROM vw_contato_paciente;

-- (Opcional) Exclui a view vw_contato_paciente caso não seja mais necessária.
DROP VIEW vw_contato_paciente;
