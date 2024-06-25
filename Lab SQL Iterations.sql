SELECT s.store_id, SUM(p.amount) AS total_sales
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id;
DELIMITER $$

CREATE PROCEDURE GetTotalSalesByStore()
BEGIN
    SELECT s.store_id, SUM(p.amount) AS total_sales
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    GROUP BY s.store_id;
END $$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE GetTotalSalesForStore(IN input_store_id INT)
BEGIN
    SELECT s.store_id, SUM(p.amount) AS total_sales
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    WHERE s.store_id = input_store_id
    GROUP BY s.store_id;
END $$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE GetTotalSalesForStoreWithOutput(IN input_store_id INT, OUT total_sales_value FLOAT)
BEGIN
    SELECT SUM(p.amount) INTO total_sales_value
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    WHERE s.store_id = input_store_id
    GROUP BY s.store_id;
END $$

DELIMITER ;

-- Example of calling the stored procedure and printing the result
CALL GetTotalSalesForStoreWithOutput(1, @total_sales);
SELECT @total_sales;
DELIMITER $$

CREATE PROCEDURE GetTotalSalesForStoreWithFlag(IN input_store_id INT, OUT total_sales_value FLOAT, OUT flag VARCHAR(10))
BEGIN
    SELECT SUM(p.amount) INTO total_sales_value
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN store s ON i.store_id = s.store_id
    WHERE s.store_id = input_store_id
    GROUP BY s.store_id;

    IF total_sales_value > 30000 THEN
        SET flag = 'green_flag';
    ELSE
        SET flag = 'red_flag';
    END IF;
END $$

DELIMITER ;

-- Example of calling the stored procedure and printing the result
CALL GetTotalSalesForStoreWithFlag(1, @total_sales, @flag);
SELECT @total_sales, @flag;
