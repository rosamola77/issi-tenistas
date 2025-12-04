DELIMITER //
CREATE OR REPLACE PROCEDURE createDB()
BEGIN 
	DROP TABLE if EXISTS tickets;
	DROP TABLE if EXISTS fans;
	DROP TABLE if EXISTS sets;           -- la ultima tabla que creamos es la primera que borramos
	DROP TABLE if EXISTS matches;
	DROP TABLE if EXISTS referees;
	DROP TABLE if EXISTS players;
	DROP TABLE if EXISTS people;			-- la primera tabla que creamos es la ultima que borramos
	
	
	-- Tabla de Personas:
	CREATE OR REPLACE TABLE people(
		peopleId INT AUTO_INCREMENT NOT NULL,
		name VARCHAR(64) NOT NULL,               -- TODOS LOS ATRIBUTOS SON OBLIGATORIOS, ES DECIR, SON NOT NULL (RN-01)
		age INTEGER NOT NULL,
		nacionality VARCHAR(64) NOT NULL,
		PRIMARY KEY(peopleId),
		-- CONSTRAINT RN_02_EdadAdulta CHECK (age >= 18),   EN LA MODIFICACION ESTO LO HACEMOS CON TRIGGERS, puedo poner que sea >= que 12 y asi me ahorro el trigger de aficionados (fans)
		CONSTRAINT RN_03_NombresUnicos UNIQUE (name)
	);
	
	-- Tabla de Tenistas:
	CREATE OR REPLACE TABLE players(
		peopleId INT NOT NULL,
		ranking INT NOT NULL,
		PRIMARY KEY(peopleId),
		FOREIGN KEY(peopleId)
			REFERENCES people(peopleId),
		CONSTRAINT RN_04_NumeroPositivoMenorOIgualA1000 CHECK (ranking BETWEEN 0 AND 1000)
	);
	
	-- Tabla de Árbitros:
	CREATE OR REPLACE TABLE referees(
		peopleId INT NOT NULL,
		license VARCHAR(64) NOT NULL,
		PRIMARY KEY(peopleId),
		FOREIGN KEY(peopleId)
			REFERENCES people(peopleId)
	);
	
	-- Tabla de Pertidos:
	CREATE OR REPLACE TABLE matches(
		matchid INT AUTO_INCREMENT NOT NULL,
		player1id INT NOT NULL,
		player2id INT NOT NULL,
		winnerid INT NOT NULL,
		refereeid INT NOT NULL,
		matchdate DATE NOT NULL,
		matchround VARCHAR(64) NOT NULL,
		durationtime INT NOT NULL,
		tournament VARCHAR(64) NOT NULL,
		PRIMARY KEY(matchid),
		FOREIGN KEY(player1id)
			REFERENCES players(peopleId),
		FOREIGN KEY(player2id)
			REFERENCES players(peopleId),
		FOREIGN KEY(winnerid)
			REFERENCES players(peopleId),
		FOREIGN KEY(refereeid)
			REFERENCES referees(peopleId),
		CONSTRAINT RN_05_tenista1_y_tenista2_diferentes CHECK (player1id <> player2id)
	);
	
	-- Tabla de Sets:
	CREATE OR REPLACE TABLE sets(
		setid INT AUTO_INCREMENT NOT NULL,
		winnerid INT NOT NULL,
		matchid INT NOT NULL,
		orden INT NOT NULL,
		resultado VARCHAR(64) NOT NULL,
		PRIMARY KEY (setid),
		FOREIGN KEY(winnerid)
			REFERENCES players(peopleId),
		FOREIGN KEY(matchid)
			REFERENCES matches(matchid),
		CONSTRAINT orden_debe_de_estar_en CHECK (orden IN (1,2,3,4,5))
	);
	
	

	-- MODIFICACION DE LA FOTO DE HOY 27/11/25, LOS INSERST (POPULATE) DE LOS CAMBIOS NO NOS LO DAN, LOS TENEMOS QUE HACER NOSOTROS
	-- Quitamos la restriccion de mayor de 18 de persona y lo hacemos en triggers para comprobar que arbitro y tenista sea mayor de 18, y el de aficionado mayor de 12
	
	-- Tabla de Aficionado:
	CREATE OR REPLACE TABLE fans(
		peopleId INT NOT NULL,
		PRIMARY KEY(peopleId),
		FOREIGN KEY(peopleId)
			REFERENCES people(peopleId)
	);
	
	-- Tabla Entrada:
	CREATE OR REPLACE TABLE tickets(
		ticketsId INT AUTO_INCREMENT NOT NULL,
		peopleId INT NOT NULL,
		matchid INT NOT NULL,
		price INT NOT NULL,
		localidad VARCHAR(64) NOT NULL,     -- la localidad es como la silla donde te vas a sentar
		dateBuyTicket DATE NOT NULL,
		PRIMARY KEY(ticketsId),
		FOREIGN KEY(peopleId)
			REFERENCES people(peopleId),
		FOREIGN KEY(matchid)
			REFERENCES matches(matchid),
		CONSTRAINT persona_por_partido UNIQUE(peopleId, matchid),  -- Esto se hace para que una misma persona no compre varias entradas
		CONSTRAINT precio_mayor_que_0 CHECK(price > 0),
		CONSTRAINT localidad_unica UNIQUE(localidad)              -- Porque mi asiento es unico, no debe de haber 2 personas con el mismo asiento
	);
	
END //
DELIMITER ;

CALL createDB();



-- RN 6 y 7 son trigger porque nos referimos a atributos de diferentes tablas, si fueran check deberia de ser solo un atributo