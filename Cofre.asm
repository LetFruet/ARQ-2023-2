CREATE TABLE Combustivel (
	cd_combustivel INTEGER,
	ds_combustivel varchar(30)
);

ALTER TABLE Combustivel 
ADD CONSTRAINT combustivel_pk PRIMARY KEY (cd_combustivel); 

CREATE TABLE Veiculo_Combustivel (
	cd_combustivel INTEGER,
	nr_placa char(7)
);

ALTER TABLE Veiculo_Combustivel
ADD CONSTRAINT veiculo_combustivel_pk PRIMARY KEY (cd_combustivel, nr_placa); 

ALTER TABLE Veiculo_Combustivel
	ADD FOREIGN KEY (cd_combustivel)
	REFERENCES Combustivel (cd_combustivel),
	ADD FOREIGN KEY (nr_placa)
	REFERENCES Veiculo (nr_placa);
	
CREATE TABLE Marca (
	cd_marca INTEGER,
	ds_marca varchar(30)
);

ALTER TABLE Marca
ADD CONSTRAINT marca_pk PRIMARY KEY (cd_marca);

CREATE TABLE Veiculo (
	nr_placa char(7),
	cd_proprietario INTEGER,
	cd_modelo INTEGER,
	nr_ano_fab INTEGER,
	nr_ano_mod INTEGER,
	qt_km_rodado INTEGER,
	qt_portas INTEGER,
	ds_observacao varchar(100)
);

ALTER TABLE Veiculo
ADD CONSTRAINT veiculo_pk PRIMARY KEY (nr_placa);

ALTER TABLE veiculo
ADD COLUMN cd_cor INTEGER;

ALTER TABLE Veiculo
	ADD FOREIGN KEY (cd_proprietario)
	REFERENCES Proprietario (cd_proprietario),
	ADD FOREIGN KEY (cd_modelo)
	REFERENCES Modelo (cd_modelo),
	ADD FOREIGN KEY (cd_cor)
	REFERENCES Cor (cd_cor);

CREATE TABLE Localidade (
	cd_localidade INTEGER,
	nm_localidade varchar(50)
);

ALTER TABLE Localidade
ADD CONSTRAINT localidade_pk PRIMARY KEY (cd_localidade);

CREATE TABLE Modelo (
	cd_modelo INTEGER,
	cd_marca INTEGER,
	ds_modelo varchar(50)
);

ALTER TABLE Modelo
ADD CONSTRAINT modelo_pk PRIMARY KEY (cd_modelo);

ALTER TABLE Modelo
ADD CONSTRAINT modelo_marca_fk
	FOREIGN KEY (cd_marca)
	REFERENCES marca (cd_marca);

CREATE TABLE Proprietario (
	cd_proprietario INTEGER,
	cd_localidade INTEGER,
	nm_proprietario varchar(50),
	ds_logradouro varchar(50),
	ds_complemento varchar(50),
	ds_bairro varchar(50),
	nr_telefone varchar(15),
	ds_email varchar(50),
	sg_uf char(2)
);

ALTER TABLE Proprietario
ADD CONSTRAINT proprietario_pk PRIMARY KEY (cd_proprietario);

ALTER TABLE Proprietario
ADD CONSTRAINT proprietario_localidade_fk -- nome da tabela e tabela referência
	FOREIGN KEY (cd_localidade)
	REFERENCES Localidade (cd_localidade);
	
CREATE TABLE Cor (
	cd_cor INTEGER,
	ds_cor VARCHAR(30),
	PRIMARY KEY (cd_cor) -- usa-se quando há mais de uma pk
);

CREATE TABLE Acessorio ( 
	cd_acessorio INTEGER PRIMARY KEY, -- usa-se quando há apenas uma pk
	ds_acessorio VARCHAR(50)
);

CREATE TABLE Veiculo_Acessorio (
	nr_placa CHAR(7),
	cd_acessorio INTEGER,
	PRIMARY KEY (nr_placa, cd_acessorio)
);

ALTER TABLE Veiculo_Acessorio
	ADD FOREIGN KEY (nr_placa)
	REFERENCES Veiculo (nr_placa),
	ADD FOREIGN KEY (cd_acessorio)
	REFERENCES Acessorio (cd_acessorio);	
	
INSERT INTO Combustivel VALUES (1, 'Gasolina comum');
INSERT INTO Combustivel VALUES (2, 'Gasolina aditivada');
INSERT INTO Combustivel VALUES (3, 'Diesel');
INSERT INTO Combustivel VALUES (4, 'Álcool');

INSERT INTO Marca VALUES (1, 'Volkswagen');
INSERT INTO Marca VALUES (2, 'Audi');
INSERT INTO Marca VALUES (3, 'BMW');
INSERT INTO Marca VALUES (4, 'Chevrolet');
INSERT INTO Marca VALUES (5, 'Citroen');
INSERT INTO Marca VALUES (6, 'Ferrari');
INSERT INTO Marca VALUES (7, 'Fiat');
INSERT INTO Marca VALUES (8, 'Ford');
INSERT INTO Marca VALUES (9, 'Jeep');
INSERT INTO Marca VALUES (10, 'Horda');

INSERT INTO Modelo VALUES (1, 1, 'Jetta');
INSERT INTO Modelo VALUES (2, 1, 'Polo');
INSERT INTO Modelo VALUES (3, 2, 'Audi A3');
INSERT INTO Modelo VALUES (4, 2, 'Audi Q5');
INSERT INTO Modelo VALUES (5, 3, 'BMW X3');
INSERT INTO Modelo VALUES (6, 3, 'BMW SÉRIE 5');
INSERT INTO Modelo VALUES (7, 4, 'Camaro');
INSERT INTO Modelo VALUES (8, 4, 'Onix');
INSERT INTO Modelo VALUES (9, 5, 'Citroen C3');
INSERT INTO Modelo VALUES (10, 5, 'Jumpy');
INSERT INTO Modelo VALUES (11, 6, 'Ferrari Roma');
INSERT INTO Modelo VALUES (12, 6, 'Ferrari SF90');
INSERT INTO Modelo VALUES (13, 7, 'Argo');
INSERT INTO Modelo VALUES (14, 7, 'Fiat 500');
INSERT INTO Modelo VALUES (15, 8, 'Mustang');
INSERT INTO Modelo VALUES (16, 8, 'Lincoln');
INSERT INTO Modelo VALUES (17, 9, 'Renegade');
INSERT INTO Modelo VALUES (18, 9, 'Commander');
INSERT INTO Modelo VALUES (19, 5, 'Civic');
INSERT INTO Modelo VALUES (20, 5, 'City');

INSERT INTO Localidade VALUES (1, "Blumenau");
INSERT INTO Localidade VALUES (2, "Rodeio");
INSERT INTO Localidade VALUES (3, "Rio do Sul");
INSERT INTO Localidade VALUES (4, "São Francisco");
INSERT INTO Localidade VALUES (5, "Lages");
INSERT INTO Localidade VALUES (6, "Joinville");
INSERT INTO Localidade VALUES (7, "Rio dos Cedros");
INSERT INTO Localidade VALUES (8, "Itapema");
INSERT INTO Localidade VALUES (9, "São Bento");
INSERT INTO Localidade VALUES (10, "Pomerode");

INSERT INTO Cor VALUES (1, 'Preto');
INSERT INTO Cor VALUES (2, 'Branco');
INSERT INTO Cor VALUES (3, 'Prata');
INSERT INTO Cor VALUES (4, 'Cinza');
INSERT INTO Cor VALUES (5, 'Pérola');
INSERT INTO Cor VALUES (6, 'Bege');
INSERT INTO Cor VALUES (7, 'Azul');
INSERT INTO Cor VALUES (8, 'Vermelho');
INSERT INTO Cor VALUES (9, 'Cobre');
INSERT INTO Cor VALUES (10, 'Verde');

INSERT INTO Acessorio VALUES (1, 'Retrovisor automático');
INSERT INTO Acessorio VALUES (2, 'Câmera de ré');
INSERT INTO Acessorio VALUES (3, 'Airbag');
INSERT INTO Acessorio VALUES (4, 'Ar condicionado');
INSERT INTO Acessorio VALUES (5, 'Banco de couro');
INSERT INTO Acessorio VALUES (6, 'Alarme');
INSERT INTO Acessorio VALUES (7, 'GPS');
INSERT INTO Acessorio VALUES (8, 'Tapetes');
INSERT INTO Acessorio VALUES (9, 'Led colorido');
INSERT INTO Acessorio VALUES (10, 'Freio ABS');

INSERT INTO Veiculo VALUES ('ABC-123', 1, 1, 2017, 2007, 88.000, 4, '', 1);
INSERT INTO Veiculo VALUES ('DEF-123', 2, 2, 2006, 2006, 98.000, 4, 'Sem descrição', 2);
INSERT INTO Veiculo VALUES ('GHI-123', 3, 3, 2013, 2013, 130.000, 4, 'Sem descrição', 3);
INSERT INTO Veiculo VALUES ('JKL-123', 4, 4, 2019, 2019, 60.000, 4, 'Sem descrição', 4);
INSERT INTO Veiculo VALUES ('MNO-123', 5, 5, 2020, 2020, 75.000, 2, 'Sem descrição', 5);
INSERT INTO Veiculo VALUES ('PQR-123', 6, 6, 2023, 2023, 0, 2, 'Sem descrição', 6);
INSERT INTO Veiculo VALUES ('STU-123', 7, 7, 2009, 2009, 49.000, 4, 'Sem descrição', 7);
INSERT INTO Veiculo VALUES ('VWX-123', 8, 8, 2003, 2003, 250.000, 4, 'Sem descrição', 8);
INSERT INTO Veiculo VALUES ('YZA-123', 9, 9, 2010, 2010, 100.000, 4, 'Sem descrição', 9);
INSERT INTO Veiculo VALUES ('BCD-456', 10, 10, 2005, 2005, 120.000, 4, 'Sem descrição', 10);
INSERT INTO Veiculo VALUES ('EFG-456', 1, 11, 2022, 2022, 22.000, 2, 'Sem descrição', 1);
INSERT INTO Veiculo VALUES ('HIJ-456', 2, 12, 2004, 2004, 10.000, 2, 'Sem descrição', 2);
INSERT INTO Veiculo VALUES ('KLM-456', 3, 13, 2021, 2021, 223.000, 4, 'Sem descrição', 3);
INSERT INTO Veiculo VALUES ('NOP-456', 4, 14, 2018, 2018, 102.000, 4, 'Sem descrição', 4);
INSERT INTO Veiculo VALUES ('QRS-456', 5, 15, 2015, 2015, 136.000, 2, 'Sem descrição', 5);
INSERT INTO Veiculo VALUES ('TUV-456', 6, 16, 2008, 2008, 260.000, 2, 'Sem descrição', 6);
INSERT INTO Veiculo VALUES ('WXY-456', 7, 17, 2016, 2016, 190.000, 4, 'Sem descrição', 7);
INSERT INTO Veiculo VALUES ('ZAB-456', 8, 18, 2005, 2005, 137.000, 4, 'Sem descrição', 8);
INSERT INTO Veiculo VALUES ('CDE-789', 9, 19, 2008, 2008, 175.000, 4, 'Sem descrição', 9);
INSERT INTO Veiculo VALUES ('FGH-789', 10, 20, 2023, 2023, 0, 4, '', 10);

INSERT INTO Veiculo_Combustivel VALUES (1, 'ABC-123');
INSERT INTO Veiculo_Combustivel VALUES (2, 'DEF-123');
INSERT INTO Veiculo_Combustivel VALUES (3, 'GHI-123');
INSERT INTO Veiculo_Combustivel VALUES (4, 'JKL-123');
INSERT INTO Veiculo_Combustivel VALUES (1, 'MNO-123');
INSERT INTO Veiculo_Combustivel VALUES (2, 'PQR-123');
INSERT INTO Veiculo_Combustivel VALUES (3, 'STU-123');
INSERT INTO Veiculo_Combustivel VALUES (4, 'VWX-123');
INSERT INTO Veiculo_Combustivel VALUES (1, 'YZA-123');
INSERT INTO Veiculo_Combustivel VALUES (2, 'BCD-456');
INSERT INTO Veiculo_Combustivel VALUES (3, 'EFG-456');
INSERT INTO Veiculo_Combustivel VALUES (4, 'HIJ-456');
INSERT INTO Veiculo_Combustivel VALUES (1, 'KLM-456');
INSERT INTO Veiculo_Combustivel VALUES (2, 'NOP-456');
INSERT INTO Veiculo_Combustivel VALUES (3, 'QRS-456');
INSERT INTO Veiculo_Combustivel VALUES (4, 'TUV-456');
INSERT INTO Veiculo_Combustivel VALUES (1, 'WXY-456');
INSERT INTO Veiculo_Combustivel VALUES (2, 'ZAB-456');
INSERT INTO Veiculo_Combustivel VALUES (3, 'CDE-789');
INSERT INTO Veiculo_Combustivel VALUES (4, 'FGH-789');

INSERT INTO Proprietario VALUES (1, 1, 'Leticia', 'Rua Barão do Rio Branco', 'Casa', 'Centro', '(47) 99999-9999', 'leticia.com', 'SC');
INSERT INTO Proprietario VALUES (2, 2, 'Ana Silva', 'Avenida Rio Branco', 'Apto', 'VK', '(47) 11111-9999', 'ana.com', 'SC');
INSERT INTO Proprietario VALUES (3, 3, 'Clara', 'Rua 7 de Setembro', 'Ap', 'Itoupava', '(47) 99999-1111', 'Clara.com', 'SC');
INSERT INTO Proprietario VALUES (4, 4, 'Alice', 'Rua XV', 'Casa', 'Apartamento', '(11) 12345-6789', 'alice.com', 'SC');
INSERT INTO Proprietario VALUES (5, 5, 'Jéssica', 'Rua Presidente Kenedy', 'Loja', 'Garcia', '(47) 19999-9999', 'jessica.com', 'SC');
INSERT INTO Proprietario VALUES (6, 6, 'Manuela', 'Alameda Rio Branco', 'Comércio', 'Diamante', '(15) 91111-1111', 'manuela.com', 'SC');
INSERT INTO Proprietario VALUES (7, 7, 'Julia', 'Avenida Brasil', 'Casa', 'Centro', '(47) 11111-1111', null, 'SC');
INSERT INTO Proprietario VALUES (8, 8, 'Daniela', 'Rua 1° de Janeiro', 'Escritório', 'Centro', '(85) 91111-9999', 'daniela.com', 'SC');
INSERT INTO Proprietario VALUES (9, 9, 'Ivete', 'Rua Bahia', 'Apto', 'Água Verde', '(47) 56789-1234', 'ivete.com', 'SC');
INSERT INTO Proprietario VALUES (10, 1, 'Brenda', 'Rua Doutor Blumenau', 'Casa', 'Rodeio 12', '(99) 99999-9999', null, 'SC');
INSERT INTO Proprietario VALUES (11, 2, 'João', 'Rua Doutor Pedro Zimmerman', 'Ap', 'Nações', null, null, 'SC');
INSERT INTO Proprietario VALUES (12, 3, 'Pedro', 'Avenida Floral', 'Casa', 'Imigrantes', '(54) 99999-9876', 'pedro.com', 'SC');
INSERT INTO Proprietario VALUES (13, 4, 'Mateus', 'Alameda Sete', 'Casa', 'Pomeranos', '(47) 99999-6789', 'mateus.com', 'SC');
INSERT INTO Proprietario VALUES (14, 5, 'Douglas', 'Alameda 20 de Outubro', 'Casa', 'Vila Nova', '(47) 12345-9999', 'douglas.com', 'SC');
INSERT INTO Proprietario VALUES (15, 6, 'Lucas', 'Rua Carlos Moser', 'Apartamento', 'São Pedro Novo', '(48) 12589-9999', 'lucas.com', 'SC');
INSERT INTO Proprietario VALUES (16, 7, 'Davi', 'Rua Belo Horizonte', 'Casa', 'Capitais', '(15) 11256-9999', 'davi.com', 'SC');
INSERT INTO Proprietario VALUES (17, 8, 'Heitor', 'Avenida Floriano Peixoto', 'Casa', 'Estados', '(11) 13620-9999', 'heitor.com', 'SC');
INSERT INTO Proprietario VALUES (18, 9, 'Marco', 'Rua das Palmeiras', 'Casa', 'Gávea', '(47) 99999-1235', 'marco.com', 'SC');
INSERT INTO Proprietario VALUES (19, 10, 'Gabriel', 'Rua Barão do Rio Branco', 'Casa', 'Encano', '(18) 12785-9999', 'gabriel.com', 'SC');
INSERT INTO Proprietario VALUES (20, 10, 'Kauã', 'Avenida das Américas', 'Casa', 'Glória', '(45) 36879-9546', 'kaua.com', 'SC');

INSERT INTO Veiculo_Acessorio VALUES ('ABC-123', 1);
INSERT INTO Veiculo_Acessorio VALUES ('DEF-123', 2);
INSERT INTO Veiculo_Acessorio VALUES ('GHI-123', 3);
INSERT INTO Veiculo_Acessorio VALUES ('JKL-123', 4);
INSERT INTO Veiculo_Acessorio VALUES ('MNO-123', 5);
INSERT INTO Veiculo_Acessorio VALUES ('PQR-123', 6);
INSERT INTO Veiculo_Acessorio VALUES ('STU-123', 7);
INSERT INTO Veiculo_Acessorio VALUES ('VWX-123', 8);
INSERT INTO Veiculo_Acessorio VALUES ('YZA-123', 9);
INSERT INTO Veiculo_Acessorio VALUES ('BCD-456', 10);
INSERT INTO Veiculo_Acessorio VALUES ('EFG-456', 1);
INSERT INTO Veiculo_Acessorio VALUES ('HIJ-456', 2);
INSERT INTO Veiculo_Acessorio VALUES ('KLM-456', 3);
INSERT INTO Veiculo_Acessorio VALUES ('NOP-456', 4);
INSERT INTO Veiculo_Acessorio VALUES ('QRS-456', 5);
INSERT INTO Veiculo_Acessorio VALUES ('TUV-456', 6);
INSERT INTO Veiculo_Acessorio VALUES ('WXY-456', 7);
INSERT INTO Veiculo_Acessorio VALUES ('ZAB-456', 8);
INSERT INTO Veiculo_Acessorio VALUES ('CDE-789', 9);
INSERT INTO Veiculo_Acessorio VALUES ('FGH-789', 10);


-- a) Listar os nomes dos proprietários com a respectiva localidade (nome) em que residem;
   -- SELECT p.nm_proprietario, l.nm_localidade
   -- FROM Proprietario p, Localidade l
   -- WHERE p.cd_localidade = l.cd_localidade

   -- OU --

SELECT p.nm_proprietario, l.nm_localidade
FROM proprietario p JOIN localidade l ON (p.cd_localidade = l.cd_localidade)

-- b) Listar todos os modelos da marca "FIAT" ordenados pelo descrição do modelo;
SELECT mo.ds_modelo, ma.ds_marca
FROM marca ma JOIN modelo mo ON (ma.cd_marca = mo.cd_marca)
WHERE ma.ds_marca = 'FIAT'
ORDER BY mo.ds_modelo

-- c) Listar todas as marcas (descrição) disponíveis com o respetivo modelo (descrição), em ordem crescente de marca, seguida de modelo;
SELECT ma.ds_marca AS marca, mo.ds_modelo AS modelo
FROM Marca ma JOIN Modelo mo ON (ma.cd_marca = mo.cd_modelo)
ORDER BY ma.ds_marca, mo.ds_modelo

-- d) Listar a placa, o ano modelo e a descrição da cor de todos os veículos cadastrados, ordenando pelo ano modelo, seguido da descrição da cor;
SELECT v.nr_placa, v.nr_ano_mod, c.ds_cor
FROM Veiculo v, Cor c
WHERE v.cd_cor = c.cd_cor
ORDER BY v.nr_ano_mod, c.ds_cor

-- e) Listar os seguintes dados do veículo: placa, nome do proprietário e nome da localidade que o mesmo reside, desde que sua UF seja "SC";
SELECT v.nr_placa, p.nm_proprietario, l.nm_localidade, p.sg_uf
FROM Veiculo v JOIN Proprietario p ON (v.cd_proprietario = p.cd_proprietario)
					JOIN localidade l ON (p.cd_localidade = l.cd_localidade)
WHERE sg_uf = 'SC'

-- f)  Listar os dados dos veículos com placa, descrição da marca, descrição do modelo, ano do modelo e a(s) respectiva(s) descrição(ões) do(s) 
--     combustível(is) que é movido;
SELECT v.nr_placa, ma.ds_marca, mo.ds_modelo, v.nr_ano_mod, c.ds_combustivel
FROM veiculo v JOIN Modelo mo ON (v.cd_modelo = mo.cd_modelo)
 					JOIN Marca ma ON (mo.cd_marca = ma.cd_marca)
					JOIN veiculo_combustivel vc ON (v.nr_placa = vc.nr_placa)
					JOIN combustivel c ON (vc.cd_combustivel = c.cd_combustivel)
ORDER BY c.ds_combustivel

-- g) Listar os veículos (com placa, descrição da marca, descrição do modelo) que possuem como acessório "Direção hidráulica";
SELECT v.nr_placa, ma.ds_marca, mo.ds_modelo, a.ds_acessorio
FROM Veiculo v, Marca ma, Modelo mo, Veiculo_Acessorio va, Acessorio a
WHERE v.cd_modelo = mo.cd_modelo
		AND mo.cd_marca = ma.cd_marca
		AND v.nr_placa = va.nr_placa
		AND va.cd_acessorio = a.cd_acessorio
		AND a.ds_acessorio LIKE 'direção hidr%'

-- h) Listar dados completos dos veículos: placa, descrição da marca, descrição do modelo, descrição da cor, ano modelo, ano fabricação, quantidade 
--    de km rodado, quantidade de portas, descrição dos acessórios e descrição do combustível que o move.
SELECT v.nr_placa, ma.ds_marca, mo.ds_modelo, cr.ds_cor, v.nr_ano_mod, v.nr_ano_fab, v.qt_km_rodado, v.qt_portas, a.ds_acessorio, cm.ds_combustivel
FROM Veiculo v, Marca ma, Modelo mo, Cor cr, Combustivel cm, Acessorio a, Veiculo_Acessorio va, veiculo_combustivel vc
WHERE v.cd_modelo = mo.cd_modelo 
		AND mo.cd_marca = ma.cd_marca
		AND v.cd_cor = cr.cd_cor
		AND v.nr_placa = va.nr_placa
		AND va.cd_acessorio = a.cd_acessorio
		AND v.nr_placa = vc.nr_placa
		AND vc.cd_combustivel = cm.cd_combustivel
		
		
		
		

-- a)     Listar a média de km rodados entre os veículos cadastrados;

SELECT AVG(v.qt_km_rodado)
FROM Veiculo v

-- b)     Listar o ano de fabricação do(s) veículo(s) mais novo e ano de fabricação do(s) veículo(s) mais antigo cadastrado na base de dados;

SELECT MAX(v.nr_ano_fab), MIN(v.nr_ano_fab)
FROM Veiculo v

-- c)     Listar o ano modelo do veículo com a respectiva quantidade de veículos correspondente ao ano listado;

SELECT v.nr_ano_mod, COUNT(v.nr_ano_mod)
FROM Veiculo v
GROUP BY v.nr_ano_mod

-- d)     Listar a descrição do combustível com a respectiva quantidade de veículos que apresentam o combustível, ordenando pelo maior número de veículos descendente;

SELECT co.ds_combustivel, COUNT(vc.nr_placa)
FROM veiculo v, combustivel co, Veiculo_Combustivel vc
WHERE vc.cd_combustivel = co.cd_combustivel AND vc.nr_placa = v.nr_placa
GROUP BY co.ds_combustivel
ORDER BY COUNT(vc.nr_placa) DESC

-- e)     Listar a descrição do modelo com a respectiva quantidade de veículo(s) correspondente ao modelo listado;

SELECT m.ds_modelo, COUNT(v.nr_placa)
FROM veiculo v, modelo m
WHERE v.cd_modelo = m.cd_modelo
GROUP BY v.nr_placa

-- f)      Listar todas as marcas (descrição) disponíveis com o respetivo modelo (descrição), bem como a quantidade de veículo associada a marca e modelo listado;

SELECT ma.ds_marca, mo.ds_modelo, COUNT(v.nr_placa)
FROM veiculo v, marca ma, modelo mo
WHERE v.cd_modelo = mo.cd_modelo AND mo.cd_marca = ma.cd_marca
GROUP BY v.nr_placa

-- g)     Listar a descrição do acessório com a respectiva quantidade de veículo que possuem o referido acessório listado.

SELECT a.ds_acessorio, COUNT(v.nr_placa)
FROM veiculo v, acessorio a, veiculo_acessorio va
WHERE v.nr_placa = va.nr_placa AND a.cd_acessorio = va.cd_acessorio
GROUP BY v.nr_placa

-- h)     Listar o nome da localidade com a respectiva quantidade de proprietários vinculado(s) a cada localidade, restringindo ao estado de "SC";

SELECT l.nm_localidade, COUNT(p.nm_proprietario)
FROM Proprietario p, Localidade l
WHERE p.cd_localidade = l.cd_localidade AND p.sg_uf = 'SC'
GROUP BY p.nm_proprietario

-- i)      Listar dados dos veículos: placa, descrição da marca, descrição do modelo e quantidade de acessórios associado a cada veículo listado, sendo que os veículos devem apresentar dois ou mais acessórios.

SELECT v.nr_placa, ma.ds_marca, mo.ds_modelo, COUNT(a.cd_acessorio)
FROM Veiculo v, acessorio a, marca ma, modelo mo, veiculo_acessorio va
WHERE v.cd_modelo = mo.cd_modelo AND ma.cd_marca = mo.cd_marca AND v.nr_placa = va.nr_placa AND a.cd_acessorio = va.cd_acessorio
GROUP BY a.cd_acessorio
HAVING COUNT(a.cd_acessorio) >= 2

-- j)     Listar dados dos veículos: placa, descrição da marca, descrição do modelo e quantidade de combustíveis associados a cada veículo listado.

SELECT v.nr_placa, ma.ds_marca, mo.ds_modelo, COUNT(c.cd_combustivel)
FROM Veiculo v, combustivel c, marca ma, modelo mo, veiculo_combustivel vc
WHERE v.cd_modelo = mo.cd_modelo AND ma.cd_marca = mo.cd_marca AND v.nr_placa = vc.nr_placa AND c.cd_combustivel = vc.cd_combustivel
GROUP BY c.cd_combustivel