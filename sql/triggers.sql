-- Triggers


-- RN-06: Un árbitro no puede arbitrar más de 3 partidos en un mismo día.

DELIMITER //
CREATE OR REPLACE TRIGGER max_partidos_arbitro_dia
BEFORE INSERT OR UPDATE ON matches FOR EACH ROW
BEGIN
	DECLARE total_partidos INT;
	SET total_partidos = (SELECT COUNT(*) FROM matches WHERE refereeid = NEW.refereeid AND matchdate = NEW.matchdate);
	if (total_partidos >= 3) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un árbitro no puede arbitar más de 3 partidos el mismo día';
	END if;
END //
DELIMITER ;

-- RN-07: La nacionalidad de un árbitro no puede coincidir con la de cualquiera de los tenistas
DELIMITER //
CREATE OR REPLACE TRIGGER nacionalidad_distinta
BEFORE INSERT OR UPDATE ON matches FOR EACH ROW
BEGIN
	DECLARE nac_arbitro VARCHAR(64);
   DECLARE nac_p1 VARCHAR(64);
   DECLARE nac_p2 VARCHAR(64);
   
   SET nac_arbitro = (SELECT nacionality FROM people WHERE peopleId = NEW.refereeid);  -- EL WHERE LO QUE HACE ES COMPARAR DENTRO DE MATCHES QUE LA ID DE LA PERSONA FROM PEOPLE SEA IGUAL QUE LA ID DE REFEREE EN MATCHES
   SET nac_p1 = (SELECT nacionality FROM people WHERE peopleId = NEW.player1id);
   SET nac_p2 = (SELECT nacionality FROM people WHERE peopleId = NEW.player2id);
   
   if (nac_arbitro = nac_p1 OR nac_arbitro = nac_p2) then
   	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La nacionalidad de un árbitro no puede coincidir con la de cualquiera de los tenistas';
   END if;
END //
DELIMITER ;



	-- MODIFICACION DE LA FOTO DE HOY 27/11/25, LOS INSERST (POPULATE) DE LOS CAMBIOS NO NOS LO DAN, LOS TENEMOS QUE HACER NOSOTROS

-- RN-Mdodificacion1.1: Tenista1 mayor de edad      (AL PROFE LE GUSTA QUE PONGAMOS INTO EN VEZ DE SET Y EN VEZ DE DECLARAR PONGAMOS ARROBA QUE ES LO MISMO)
DELIMITER //
CREATE OR REPLACE TRIGGER tenista_mayor_edad
BEFORE INSERT OR UPDATE ON referees FOR EACH ROW
BEGIN
	-- DECLARE edad_tenista INT;
   
   SELECT age INTO @edad_tenista FROM people WHERE peopleId = NEW.peopleId;
   
   if (@edad_tenista < 18) then
   	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La edad del tenista debe de ser mayor a 18';
   END if;
END //
DELIMITER ;


-- RN-Mdodificacion2: Árbitro mayor de edad      (AL PROFE LE GUSTA QUE PONGAMOS INTO EN VEZ DE SET Y EN VEZ DE DECLARAR PONGAMOS ARROBA QUE ES LO MISMO)
DELIMITER //
CREATE OR REPLACE TRIGGER arbitro_mayor_edad
BEFORE INSERT OR UPDATE ON players FOR EACH ROW
BEGIN
	-- DECLARE edad_arbitro INT;
   
   SELECT age INTO @edad_arbitro FROM people WHERE peopleId = NEW.peopleId;
   
   if (@edad_arbitro < 18) then
   	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La edad del árbitro debe de ser mayor a 18';
   END if;
END //
DELIMITER ;


-- RN-Mdodificacion3: Aficionado mayor de 12 años      (AL PROFE LE GUSTA QUE PONGAMOS INTO EN VEZ DE SET Y EN VEZ DE DECLARAR PONGAMOS ARROBA QUE ES LO MISMO)
DELIMITER //
CREATE OR REPLACE TRIGGER aficionado_mayor_de_12
BEFORE INSERT OR UPDATE ON fans FOR EACH ROW
BEGIN
	-- DECLARE edad_aficionado INT;
   
   SELECT age INTO @edad_aficionado FROM people WHERE peopleId = NEW.peopleId;
   
   if (@edad_aficionado < 12) then
   	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La edad del aficionado debe de ser mayor a 12';
   END if;
END //
DELIMITER ;



-- RN-Modificacion4: La fecha del partido tiene que ser posterior a la fecha de compra del ticket
DELIMITER //
CREATE OR REPLACE TRIGGER fecha_partudo_posterior_a_la_actual
BEFORE INSERT OR UPDATE ON tickets FOR EACH ROW
BEGIN
	DECLARE fecha_partido DATE;
	
	SET fecha_partido = (SELECT matchdate FROM matches WHERE matchid = NEW.matchid);  -- EL WHERE LO QUE HACE ES COMPARAR UN MATCHID DE LA TABLA DE PARTIDOS QUE SEA IGUAL A UNO DE LA TABLA DE TICKETS
	
	if (fecha_partido <= NEW.dateBuyTicket) then
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha del partido debe de ser posterior a la del ticket';
   END if;
END //
DELIMITER ;

		-- TRIGGERS nuevos de hoy 2/12/25, foto de hoy
		
-- RN nuevoTrigger: Al introducir un partido, si no tiene ganador lo ponga automaticamente como el jugador 1
DELIMITER // 
CREATE OR REPLACE TRIGGER ganadorAutomatico
BEFORE INSERT OR UPDATE ON matches FOR EACH ROW
BEGIN
	IF NEW.winnerid IS NULL THEN
   	SET NEW.winnerid = NEW.player1id;
	END IF;
END //
DELIMITER ;