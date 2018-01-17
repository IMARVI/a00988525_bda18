delimiter $$
create procedure barato_caro()
BEGIN
	declare caro varchar(20);
    declare barato varchar(20);
    
	select max(buyPrice) into caro from products;
    select min(buyPrice) into barato from products;
    
    select caro, barato;
END$$

delimiter ;