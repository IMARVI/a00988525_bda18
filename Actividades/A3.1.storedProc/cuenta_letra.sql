delimiter $$
create procedure cuenta_letra(
IN letra varchar(1))
BEGIN
	declare contador int default 0;
    declare line varchar(15);
	set line = concat(letra, "%");
    
    select count(*) into contador from customers
    where customerName like line;
    
    select contador;
    
END $$