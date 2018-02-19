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