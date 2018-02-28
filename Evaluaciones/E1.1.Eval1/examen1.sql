use sakila;

CREATE TABLE LOG_FILM (
	tipo int default 1 , -- 1 = update
    Film_id int not null,
    Last_value tinyint(3) not null,
    New_value tinyint(3)not null,
    cambio TIMESTAMP DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP
);

delimiter $$
create procedure cuenta_letra(
    IN Film_id int,
    IN New_value tinyint(3)
)
BEGIN
	insert into LOG_FILM (tipo,Film_id,Last_value,New_value) values(1,Film_id,null,New_value);
END
$$


DELIMITER ///
CREATE TRIGGER cambiar_lang AFTER UPDATE ON film
    FOR EACH ROW
    BEGIN
		IF NEW.original_language_id THEN
			CALL cuenta_letra(NEW.film_id, NEW.original_language_id);
        END IF;
    END;
///


delimiter //
create procedure asign_original_lang()
begin
        
    declare done int default FALSE;
	declare film_id smallint(5);
    declare category_id tinyint(3);
    declare actor_id smallint(5);
    
    declare cactor_id cursor for select actor_id, film_id from film_actor;
    declare ccategory_id cursor for select category_id, film_id from film_category;
    
    declare continue handler
    
	for not found set done = true;
        
	set 
	@documentaryID = 6,
	@foraneaID = 9 ,
	@sissiID = 31 ,
	@chaseID = 3 ,
	@audrey = 34 ; 
        
	open cactor_id;
	open ccategory_id;
        
	read_loop: loop
        
        fetch cactor_id into actor_id, film_id ;
        
        if(actor_id = @sissiID) then
			update film set original_language_id = 6;
        
        elseif(actor_id = @chaseID) then
			update film set original_language_id = 4;
        
        elseif(actor_id = @audrey) then
			update film set original_language_id = 5;
        
		fetch ccategory_id into category_id, film_id ;
        
		elseif(category_id = @documentaryID) then
			update film set original_language_id = 2;
        
        elseif(category_id = @foraneaID) then
			update film set original_language_id = 3;
		
        else 
			update film set original_language_id = 1;
		end if;
        
	end loop;
	close cactor_id;
	close ccategory_id;
    
end //

--  Pregunta 6 DB2 Gomas

CREATE TABLE gomitas(
  ID INT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(10,6) NOT NULL,
  cstart DATE NOT NULL,
  cend DATE NOT NULL,
  periodo business_time(cstart, cend),
  PRIMARY KEY(ID, business_time WITHOUT overlaps)
);

INSERT INTO gomitas (NAME, precio, cstart, cend) VALUES
  ('prod1', 1, '2018-1-1', '2019-1-1'),
  ('prod2', 2, '2018-1-1', '2019-1-1'),
  ('prod3', 3, '2018-1-1', '2019-1-1'),
  ('prod4', 4, '2018-1-1', '2019-1-1'),
  ('prod5', 5, '2018-1-1', '2019-1-1'),
  ('prod6', 6, '2018-1-1', '2019-1-1'),
  ('prod7', 7, '2018-1-1', '2019-1-1'),
  ('prod8', 8, '2018-1-1', '2019-1-1'),
  ('prod9', 9, '2018-1-1', '2019-1-1'),
  ('prod10', 10, '2018-1-1', '2019-1-1'),
  ('prod11', 11, '2018-1-1', '2019-1-1'),
  ('prod12', 12, '2018-1-1', '2019-1-1');


UPDATE gomitas
FOR PORTION OF BUSINESS_TIME FROM '2018-2-1' to '2018-4-25'
  SET precio = precio*1.45;

UPDATE gomitas
FOR PORTION OF BUSINESS_TIME FROM '2018-4-25' to '2018-10-25'
  SET precio = precio*1.45;

UPDATE gomitas
FOR PORTION OF BUSINESS_TIME FROM '2018-10-25' to '2019-1-1'
  SET precio = precio*1.45;

UPDATE gomitas
FOR PORTION OF BUSINESS_TIME FROM '2018-2-15' to '2019-1-1'
  SET precio = (precio/1.45)*1.1;


SELECT SUM(precio)/COUNT(*) as AVG from gomitas WHERE NAME='prod12';

SELECT MAX(precio) as MAX from gomitas WHERE NAME='prod12';

SELECT MIN(precio) as MIN from gomitas WHERE NAME='prod12';