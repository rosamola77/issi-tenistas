-- TEST SQL

USE tenistasdb;                      -- SE USA PARA UTILIZAR ESTA BASE DE DATOS, pasa cuando ejecuto algo y dice que no esta seleccionada la base de datos, pues esto lo soluciona si no la tengo  marcada a la izquierda


-- TABLA DE RESULTADOS DE TESTS (almacena los errores, es decir los registros de si han fallado o no los test)
DROP TABLE if EXISTS test_results;  -- no hace falta ya que el orquestador me borra los datos, no hace falta borrar la tabla (pero igualmente lo pongo xd)

CREATE OR REPLACE TABLE test_results (
	test_id VARCHAR(20) NOT NULL PRIMARY KEY,
	test_name VARCHAR(200) NOT NULL,
	test_message VARCHAR(500) NOT NULL,
	test_status ENUM('PASS', 'FAIL', 'ERROR') NOT NULL,
	execution_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);





-- PROCEDIMIENTO AUXILIAR DE LOGGING (Lo que hace es añadir los datos que le demos como parametros a la tabla de test_results)

DELIMITER //
CREATE OR REPLACE PROCEDURE p_log_test(      -- Parametros de entrada
	IN p_test_id VARCHAR(20),
	IN p_message VARCHAR(500),
	IN p_status ENUM('PASS', 'FAIL', 'ERROR')
)

BEGIN
	INSERT INTO test_results(test_id, test_name, test_message, test_status)
	VALUES (p_test_id, SUBSTRING_INDEX(p_message, ':', 1), p_message, p_status);
END //
DELIMITER ;
	





-- TESTS

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn02_adult_age()   -- En verdad la edad minima de una persona es 12, ya que es la que pueden tener los aficionados
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('RN-02', 'RN-02: No se permiten personas menores de 18 años', 'PASS');  -- Lo que deberia de ocurrir
		
	CALL p_populate_db();
	INSERT INTO people (NAME, age, nacionality) VALUES ('Young Player', 10, 'España');
	CALL p_log_test('RN-02', 'ERROR: Se insertó una persona menor de edad', 'FAIL');				 -- Lo que no deberia de ocurrir
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_test_rn03_unique_name()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('RN-03', 'RN-03: Los nombres deben de ser unicos', 'PASS');  -- Lo que deberia de ocurrir
		
	CALL p_populate_db();
	INSERT INTO people (NAME, age, nacionality) VALUES ('Repe', 50, 'España');
	INSERT INTO people (NAME, age, nacionality) VALUES ('Repe', 30, 'Portugal');
	CALL p_log_test('RN-03', 'ERROR: Se insertó dos personas con nombres repetidos', 'FAIL');				 -- Lo que no deberia de ocurrir
END //
DELIMITER ;

DELIMITER // 
CREATE OR REPLACE PROCEDURE p_test_rn04_invalid_ranking()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		CALL p_log_test('RN_04a', 'RN_04: No se permite ranking >= 1000', 'PASS');
		
	CALL p_populate_db();
	INSERT INTO people (person_id, name, age, nationality) VALUES (101, 'Test Player 2', 25, 'Chile');
	INSERT INTO players (player_id, ranking) VALUES (101, 1001);
	CALL p_log_test('RN_04a', 'ERROR: Se permitió ranking >= 1000', 'FAIL');
END //
DELIMITER ;

DELIMITER // 
CREATE OR REPLACE PROCEDURE p_test_rn04_zero_ranking()
BEGIN 
	DECLARE exit handler FOR SQLEXCEPTION 
		CALL p_log_test('RN_04b', 'RN_04: No se permite ranking <= 0', 'PASS');
		
	CALL p_populate_db();
	INSERT INTO people (person_id, name, age, nationality) VALUES (101, 'Test Player 2', 25, 'Chile');
	INSERT INTO players (player_id, ranking) VALUES (101, 0);
	CALL p_log_test('RN_04b', 'ERROR: Se permitió ranking <= 0', 'FAIL');
END //
DELIMITER ;

DELIMITER // 
CREATE OR REPLACE PROCEDURE p_test_rn05_same_player()
BEGIN 
	DECLARE exit handler FOR SQLEXCEPTION 
		CALL p_log_test('RN_05', 'RN_05: No se permiten los mismos jugadores', 'PASS');
		
	CALL p_populate_db();
	INSERT INTO players (player_id, ranking) VALUES (102, 0);
	INSERT INTO players (player_id, ranking) VALUES (102, 0);
	CALL p_log_test('RN_05', 'ERROR: Se permitieron los mismos jugadores', 'FAIL');
END //
DELIMITER ;

DELIMITER // 
CREATE OR REPLACE PROCEDURE p_test_rn06_max_matches_referee()
BEGIN 
	DECLARE exit handler FOR SQLEXCEPTION 
		CALL p_log_test('RN_06', 'RN_06: No se permite que un árbitro arbitre más de 3 partidos', 'PASS');
		
	CALL p_populate_db();
	INSERT INTO matches (match_id, referee_id) VALUES (80, 50);
	INSERT INTO matches (match_id, referee_id) VALUES (80, 50);
	INSERT INTO matches (match_id, referee_id) VALUES (80, 50);
	INSERT INTO matches (match_id, referee_id) VALUES (80, 50);
	CALL p_log_test('RN_06', 'ERROR: Se permitió que un árbitro arbitrase más de 3 partidos', 'FAIL');
END //
DELIMITER ;

DELIMITER // 
CREATE OR REPLACE PROCEDURE p_test_rn07_referee_nationality()
BEGIN 
	DECLARE exit handler FOR SQLEXCEPTION 
		CALL p_log_test('RN_07', 'RN_07: La nacionalidad del árbitro no puede ser la misma que la del jugador', 'PASS');
		
	CALL p_populate_db();
	INSERT INTO people (person_id, name, age, nationality) VALUES (33, 'Lucia', 25, 'Chile');
	INSERT INTO players (player_id, ranking) VALUES (33, 44);
	INSERT INTO people (person_id, name, age, nationality) VALUES (35, 'Juan', 29, 'Chile');
	INSERT INTO referees (player_id, license) VALUES (35, 'Nacional');
	CALL p_log_test('RN_07', 'ERROR: Se permitió que un árbitro tenga la misma nacionalidad que un jugador', 'FAIL');
END //
DELIMITER ;

DELIMITER // 
CREATE OR REPLACE PROCEDURE p_test_sets_invalid_winner()
BEGIN 
	DECLARE exit handler FOR SQLEXCEPTION 
		CALL p_log_test('RN_08', 'RN_08: El ganador debe ser uno de los jugadores del partido (jugador 1 o 2)', 'PASS');
		
	CALL p_populate_db();
	INSERT INTO people (peopleId, name, age, nacionality) 
    VALUES (201, 'Jugador A', 25, 'España'),
           (202, 'Jugador B', 27, 'Francia'),
           (203, 'Jugador C', 22, 'Italia');   -- <- ganador inválido

    -- Los metemos como players (para evitar otros triggers)
   INSERT INTO players (player_id, ranking) VALUES (201, 100);
   INSERT INTO players (player_id, ranking) VALUES (202, 150);
   INSERT INTO players (player_id, ranking) VALUES (203, 200);

    -- Intentamos insertar un partido con ganador inválido (203 NO juega)
   INSERT INTO matches (matchId, player1Id, player2Id, refereeid, matchdate, winnerid)
   VALUES (700, 201, 202, 1, '2024-01-01', 203);
	CALL p_log_test('RN_08', 'ERROR: Se permitió que el ganador fuese uno jugador diferente al 1 o al 2', 'FAIL');
END //
DELIMITER ;

DELIMITER // 
CREATE OR REPLACE PROCEDURE p_test_sets_max_5_sets()
BEGIN 
	DECLARE exit handler FOR SQLEXCEPTION 
		CALL p_log_test('RN_09', 'RN_09: No se pueden tener más de 5 sets por partido', 'PASS');
		
	CALL p_populate_db();
	INSERT INTO matches (matchid, player1id, player2id, winnerid, refereeid, matchdate, matchround, tournament, durationtime) VALUES (1000, 1, 2, 1, 7, '2025-12-01', 'Final', 'Test Open', 120);
   INSERT INTO sets (setid, matchid, winnerid, orden, resultado) VALUES 
      (1001, 1000, 1, 1, '6-4'),
      (1002, 1000, 2, 2, '4-6'),
      (1003, 1000, 1, 3, '6-3'),
      (1004, 1000, 2, 4, '5-7'),
      (1005, 1000, 1, 5, '7-6');

    INSERT INTO sets (setid, matchid, winnerid, orden, resultado)
    VALUES (1006, 1000, 1, 6, '6-0');
	CALL p_log_test('RN_09', 'ERROR: Se permitió más de 5 sets en un partido', 'FAIL');
END //
DELIMITER ;





-- ORQUESTADOR (Ejecuta todos los test)

DELIMITER //
CREATE OR REPLACE PROCEDURE p_run_all_tests()
BEGIN 
	DELETE FROM test_results;
	CALL p_test_rn02_adult_age();     -- En verdad la edad minima de una persona es 12, ya que es la que pueden tener los aficionados
   CALL p_test_rn03_unique_name();
   CALL p_test_rn04_invalid_ranking();
   CALL p_test_rn04_zero_ranking();
   CALL p_test_rn05_same_player();
	CALL p_test_rn06_max_matches_referee();
	CALL p_test_rn07_referee_nationality();
	CALL p_test_sets_invalid_winner();
	CALL p_test_sets_max_5_sets();
	
	-- Resultados
	SELECT * FROM test_results ORDER BY execution_time, test_id;
	-- Resumen
	SELECT test_status, COUNT(*) AS COUNT FROM test_results GROUP BY test_status;
END //
DELIMITER ;



-- LLamada al orquestador
CALL p_run_all_tests();  -- Llamada al orquestador (para ejecutar todos los tests)