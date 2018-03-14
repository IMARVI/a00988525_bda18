delimiter //

create procedure demo_cursor()
begin
	declare ids int;
    declare done int default FALSE;
    declare cursor1 cursor for select actor_id from actor;
    declare continue handler
		for not found
        set done = true;
        
        open cursor1;
        read_loop: loop
        fetch cursor1 into ids;
        if done then
			leave read_loop;
		end if;
        -- set ids = id_actor;
        
	end loop;
		select ids;
        close cursor1;
end //

-- ------------------------------------------------- Tarea

use sakila;

drop procedure categoria_peli;

-- select * from film_category;

delimiter //

create procedure categoria_peli()

begin
    declare done int default false;
	declare nuevoNombre varchar(60);
    
    declare peli varchar(30);
    declare cat varchar(30);
    
    declare c,p int;
    declare p1 cursor for select film_id from film_category;
	declare c1 cursor for select category_id from film_category;
	
    declare continue handler for not found set done = true;
			
	open p1;
    open c1;
		
	read_loop: loop
		
        fetch p1 into p;
        fetch c1 into c;
        set peli = (select title from film where film_id = p);
        set cat = (select name from category where category_id = c);
		
        if done then
			leave read_loop;
		end if;
        
        if film.film_id = p then
			set nuevoNombre = concat(cat,'_',peli);
		end if;
        
	end loop;
    
    close p1; 
    close c1;
end //

call categoria_peli;