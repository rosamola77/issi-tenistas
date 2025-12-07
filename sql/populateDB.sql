USE t_tenis_c_base;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_populate_db()
BEGIN
    -- Limpiar datos (orden seguro por claves foráneas)
    DELETE FROM tickets;
    DELETE FROM fans;
    DELETE FROM sets;
    DELETE FROM matches;
    DELETE FROM players;
    DELETE FROM referees;
    DELETE FROM people;

    -- Personas (ids explícitos 1..18)
    INSERT INTO people (peopleId, name, age, nacionality) VALUES
        (1, 'Novak Djokovic', 38, 'Serbia'),
        (2, 'Carlos Alcaraz', 22, 'España'),
        (3, 'Jannik Sinner', 24, 'Italia'),
        (4, 'Daniil Medvedev', 29, 'Rusia'),
        (5, 'Rafael Nadal', 39, 'España'),
        (6, 'Roger Federer', 44, 'Suiza'),
        (7, 'Carlos Ramos', 53, 'España'),
        (8, 'Mohamed Lahyani', 58, 'Suecia'),
        (9, 'Eva Asderaki', 43, 'Grecia'),
        (10, 'Roberto Bautista Agut', 36, 'España'),
        (11, 'Paula Badosa', 27, 'España'),
        (12, 'Taylor Fritz', 27, 'Estados Unidos'),
        (13, 'Andy Murray', 37, 'Reino Unido'),
        (14, 'Felix Auger-Aliassime', 25, 'Canadá'),
        (15, 'James Keothavong', 42, 'Reino Unido'),
        (16, 'Aurelie Tourte', 41, 'Francia'),
        (17, 'Carlos Bernardes', 58, 'Brasil'),
        (18, 'Diego Fernandez', 50, 'Argentina'),
		  (19, 'Manolito peque' , 12, 'Venezuela'),
		  (20, 'Juanlu peque' , 15, 'España'),
		  (21, 'Manolito Primo grande' , 22, 'Italia');

    -- Árbitros
    INSERT INTO referees (peopleId, license) VALUES 
        (7, 'Internacional'),
        (8, 'Internacional'),
        (9, 'Internacional'),
        (15, 'Internacional'),
        (16, 'Internacional'),
        (17, 'Internacional'),
        (18, 'Nacional');

    -- Jugadores
    INSERT INTO players (peopleId, ranking) VALUES 
        (1, 1),
        (2, 2),
        (3, 4),
        (4, 5),
        (5, 9),
        (6, 1000),
        (10, 18),
        (11, 25),
        (12, 10),
        (13, 22),
        (14, 11);

    -- Partidos y sets (formato individual por partido, revisado para RN-07)

    -- Partido 1: Wimbledon 2024, Final (Djokovic vs Alcaraz) - árbitro 8 (Suecia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (1, 8, 1, 2, 2, 'Wimbledon 2024', '2024-07-14', 'Final', 230);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (1, 1, 1, '6-3'),
        (1, 2, 2, '7-6'),
        (1, 2, 3, '6-4');

    -- Partido 2: US Open 2024, Semifinal (Sinner vs Medvedev) - árbitro 7 (España)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (2, 7, 3, 4, 3, 'US Open 2024', '2024-09-06', 'Semifinal', 195);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (2, 3, 1, '6-4'),
        (2, 4, 2, '3-6'),
        (2, 3, 3, '7-5');

    -- Partido 3: Roland Garros 2024, Cuartos de final (Nadal vs Djokovic) - árbitro 9 (Grecia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (3, 9, 5, 1, 1, 'Roland Garros 2024', '2024-06-04', 'Cuartos de final', 210);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (3, 1, 1, '7-5'),
        (3, 5, 2, '4-6'),
        (3, 1, 3, '6-3');

    -- Partido 4: Indian Wells 2024, Final (Alcaraz vs Medvedev) - árbitro 9 (Grecia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (4, 9, 2, 4, 2, 'Indian Wells 2024', '2024-03-17', 'Final', 125);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (4, 2, 1, '7-5'),
        (4, 2, 2, '6-2');

    -- Partido 5: Australian Open 2024, Final (Djokovic vs Sinner) - árbitro 7 (España)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (5, 7, 1, 3, 1, 'Australian Open 2024', '2024-01-28', 'Final', 180);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (5, 1, 1, '6-4'),
        (5, 3, 2, '3-6'),
        (5, 1, 3, '6-3');

    -- Partido 6: Madrid 2024, Semifinal (Alcaraz vs Nadal) - árbitro 8 (Suecia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (6, 8, 2, 5, 2, 'Mutua Madrid Open 2024', '2024-05-03', 'Semifinal', 140);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (6, 2, 1, '6-2'),
        (6, 2, 2, '6-4');

    -- Partido 7: ATP Finals 2024, Grupo (Medvedev vs Djokovic) - árbitro 9 (Grecia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (7, 9, 4, 1, 4, 'ATP Finals 2024', '2024-11-12', 'Grupo', 115);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (7, 4, 1, '7-6'),
        (7, 4, 2, '6-3');

    -- Partido 8: Monte-Carlo 2024, Cuartos de final (Sinner vs Nadal) - árbitro 9 (Grecia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (8, 9, 3, 5, 3, 'Monte-Carlo 2024', '2024-04-12', 'Cuartos de final', 150);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (8, 3, 1, '6-3'),
        (8, 5, 2, '4-6'),
        (8, 3, 3, '6-4');

    -- Partido 9: Roland Garros 2025, Final (Alcaraz vs Sinner) - árbitro 15 (Reino Unido)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (9, 15, 2, 3, 2, 'Roland Garros 2025', '2025-06-08', 'Final', 205);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (9, 3, 1, '6-4'),
        (9, 2, 2, '7-5'),
        (9, 2, 3, '6-0'),
        (9, 2, 4, '6-2');

    -- Partido 10: Wimbledon 2025, Final (Djokovic vs Alcaraz) - árbitro 16 (Francia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (10, 16, 1, 2, 1, 'Wimbledon 2025', '2025-07-14', 'Final', 240);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (10, 1, 1, '6-4'),
        (10, 2, 2, '4-6'),
        (10, 1, 3, '7-6'),
        (10, 2, 4, '3-6'),
        (10, 1, 5, '6-3');

    -- Partido 11: Wimbledon 2025, Cuartos (Bautista Agut vs Fritz) - árbitro 17 (Brasil)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (11, 17, 10, 12, 12, 'Wimbledon 2025', '2025-07-08', 'Cuartos de final', 180);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (11, 12, 1, '6-4'),
        (11, 10, 2, '4-6'),
        (11, 12, 3, '6-3'),
        (11, 12, 4, '6-4');

    -- Partido 12: Queen's Club 2025, R32 (Bautista Agut vs Murray) - árbitro 16 (Francia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (12, 16, 10, 13, 10, 'Queens Club 2025', '2025-06-15', 'R32', 95);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (12, 10, 1, '7-6'),
        (12, 10, 2, '6-4');

    -- Partido 13: Queen's Club 2025, R16 (Fritz vs Auger-Aliassime) - árbitro 16 (Francia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (13, 16, 12, 14, 14, 'Queens Club 2025', '2025-06-15', 'R16', 88);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (13, 14, 1, '6-4'),
        (13, 14, 2, '6-3');

    -- Partido 14: Queen's Club 2025, Cuartos (Djokovic vs Bautista Agut) - árbitro 16 (Francia)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (14, 16, 1, 10, 10, 'Queens Club 2025', '2025-06-15', 'Cuartos de final', 105);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (14, 1, 1, '6-2'),
        (14, 10, 2, '6-4'),
        (14, 10, 3, '6-4');

    -- Partido 15: Rio Open 2025, Final (Nadal vs Bautista Agut) - árbitro 18 (Argentina)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (15, 18, 5, 10, 5, 'Rio Open 2025', '2025-02-25', 'Final', 175);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (15, 5, 1, '6-3'),
        (15, 10, 2, '4-6'),
        (15, 5, 3, '6-4');

    -- Partido 16: Laver Cup 2025, Exhibición (Auger-Aliassime vs Murray) - árbitro 17 (Brasil)
    INSERT INTO matches (matchid, refereeid, player1id, player2id, winnerid, tournament, matchdate, matchround, durationtime)
        VALUES (16, 17, 14, 13, 14, 'Laver Cup 2025', '2025-09-25', 'Exhibición', 120);
    INSERT INTO sets (matchid, winnerid, orden, resultado) VALUES
        (16, 14, 1, '6-4'),
        (16, 14, 2, '7-5');
        
        
        
      -- MODIFICACION DE LA FOTO DE HOY 27/11/25, LOS INSERST (POPULATE) DE LOS CAMBIOS NO NOS LO DAN, LOS TENEMOS QUE HACER NOSOTROS
   -- Jugadores
	INSERT INTO fans (peopleId) VALUES 
       (19),
       (20),
       (21);
       
       
	-- Tickets
	INSERT INTO tickets (peopleId, matchid, price, localidad, dateBuyTicket) VALUES
		(19, 9, 100, 'Gol norte, asiento 33', '2021-06-08'),   -- Manolito peque para Roland Garros 2025
    	(20, 10, 120, 'Preferencia, asiento 33', '2024-07-14'),  -- Juanlu peque para Wimbledon 2025
    	(21, 16, 90,  'Gol sur, asiento 23', '2024-09-25');  -- Manolito Primo grande para Laver Cup 2025


END //
DELIMITER ;

-- Ejecutar población automáticamente
CALL p_populate_db();
