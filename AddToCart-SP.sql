use MyShoeStore;

drop procedure if exists AddToCart;

delimiter $$
    create procedure AddToCart(
        costumerId int,
        orderId int,
        productId int
    )
        begin
            declare exit handler for sqlexception
            begin
                rollback;
                set autocommit=on;
                resignal;
            end;
            -- Create Order if it does not exist already
            if not exists(select id from `order` where id=orderId) or orderId is null then
                insert into `order`(id, costumer_id) values (orderId, costumerId);
                select last_insert_id() into orderId;
                insert into product_variation_in_order (order_id, product_variation_id) values
                    (orderId, productId);
            end if;

            -- Add product row to order if it does not exist already
            if not exists(
                    select * from `order`
                    inner join product_variation_in_order on `order`.id = product_variation_in_order.order_id
                    where product_variation_in_order.product_variation_id=productId
                ) then
                insert into product_variation_in_order (order_id, product_variation_id) values
                    (orderId, productId);
            end if;

            set autocommit=off;
            start transaction;
            -- Add One To Order
            update product_variation_in_order set amount = amount + 1
            where product_variation_id = productId and order_id = orderId;
            -- Remove One From Stock
            update product_variation set stock = stock - 1 where id=productId;

            -- Only commit if item were in stock
            if (select stock from product_variation where id=productId) > 0 then
                commit;
            else
                rollback;
                signal sqlstate '45000' set message_text = 'Out Of Stock!';
            end if;

            set autocommit=on;
        end $$
delimiter ;

call AddToCart(3, 10, 11);