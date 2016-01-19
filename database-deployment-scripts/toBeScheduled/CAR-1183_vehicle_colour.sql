CREATE TABLE aggregator.vehicle_colour (
	vehicleColourId TINYINT UNSIGNED NOT NULL,
	colourCode VARCHAR(50) NOT NULL,
	colourDescription VARCHAR(50) NOT NULL
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

INSERT INTO aggregator.vehicle_colour (vehicleColourId, colourCode, colourDescription) VALUES
	(0, 'other','Other'),
	(1, 'beige', 'Beige'),
	(2, 'black', 'Black'),
	(3, 'blue', 'Blue'),
	(4, 'bronze', 'Bronze'),
	(5, 'brown', 'Brown'),
	(6, 'cream', 'Cream'),
	(7, 'fawn', 'Fawn'),
	(8, 'gold', 'Gold'),
	(9, 'green', 'Green'),
	(10, 'grey', 'Grey'),
	(11, 'khaki', 'Khaki'),
	(12, 'maroon', 'Maroon'),
	(13, 'mauve', 'Mauve'),
	(14, 'orange', 'Orange'),
	(15, 'purple', 'Purple'),
	(16, 'pink', 'Pink'),
	(17, 'red', 'Red'),
	(18, 'silver', 'Silver'),
	(19, 'tan', 'Tan'),
	(20, 'turquoise', 'Turquoise'),
	(21, 'white', 'White'),
	(22, 'yellow', 'Yellow');


-- Rollback
-- DROP TABLE aggregator.vehicle_colour;
