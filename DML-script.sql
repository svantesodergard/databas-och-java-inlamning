use MyShoeStore;

-- • Vilka kunder har köpt svarta sandaler i storlek 38 av märket Ecco? Lista deras namn och
-- använd inga hårdkodade id-nummer i din fråga.
select name as costumer_name from costumer
    inner join `order` on costumer.id = `order`.costumer_id
    inner join product_variation_in_order on `order`.id = product_variation_in_order.order_id
    inner join product_variation on product_variation_in_order.product_variation_id = product_variation.id
    inner join product on product_variation.product_id = product.id

    where `order`.costumer_id = costumer.id and
        product.brand = 'Ecco' and product_variation.size = 38 and product_variation.color = 'Black';

-- • Lista antalet produkter per kategori. Listningen ska innehålla kategori-namn och antalet
-- produkter.
select category.name as category_name, count(product_in_category.category_id) as products_in_category from category
    inner join product_in_category on category.id = product_in_category.category_id
    group by product_in_category.category_id;


-- • Skapa en kundlista med den totala summan pengar som varje kund har handlat för. Kundens
-- för- och efternamn, samt det totala värdet som varje person har shoppats för, skall visas.
select costumer.name as costumer_name, sum(product.price) as total_money_spent from costumer
    inner join `order` on costumer.id = `order`.costumer_id
    inner join product_variation_in_order on `order`.id = product_variation_in_order.order_id
    inner join product_variation on product_variation_in_order.product_variation_id = product_variation.id
    inner join product on product_variation.product_id = product.id
    group by `order`.costumer_id;

-- • Skriv ut en lista på det totala beställningsvärdet per ort där beställningsvärdet är större än
-- 1000 kr. Ortnamn och värde ska visas. (det måste finnas orter i databasen där det har
-- handlats för mindre än 1000 kr för att visa att frågan är korrekt formulerad)
select `order`.delivery_city, sum(product.price) as sales_total_from_city from `order`
    inner join product_variation_in_order on `order`.id = product_variation_in_order.order_id
    inner join product_variation on product_variation_in_order.product_variation_id = product_variation.id
    inner join product on product_variation.product_id = product.id

    group by `order`.delivery_city having sum(product.price) > 1000;

-- • Skapa en topp-5 lista av de mest sålda produkterna.
select product.brand, product.model, sum(product_variation_in_order.amount) from product
    left join product_variation on product.id = product_variation.product_id
    left join product_variation_in_order on product_variation.id = product_variation_in_order.product_variation_id

    group by product.id order by sum(product_variation_in_order.amount) desc limit 5;

-- • Vilken månad hade du den största försäljningen? (det måste finnas data som anger
-- försäljning för mer än en månad i databasen för att visa att frågan är korrekt formulerad
select year(`order`.time_placed) as year, date_format(`order`.time_placed, '%M') as month,
    sum(product_variation_in_order.amount) as total_sales from `order`
    inner join product_variation_in_order on `order`.id = product_variation_in_order.order_id
    group by year(`order`.time_placed), date_format(`order`.time_placed, '%M')
    order by sum(product_variation_in_order.amount) desc limit 1;