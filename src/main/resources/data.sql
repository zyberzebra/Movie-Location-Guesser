CREATE TABLE IF NOT EXISTS movie (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(255) NOT NULL,
    latitude DOUBLE NOT NULL,
    longitude DOUBLE NOT NULL
);

INSERT OR IGNORE INTO movie (title, latitude, longitude) VALUES
('The Lord of the Rings', -41.2865, 174.7762),
('Inception', 37.7749, -122.4194),
('Gladiator', 41.9028, 12.4964),
('The Beach', 8.0424, 98.8398),
('Lost in Translation', 35.6762, 139.6503),
('The Sound of Music', 47.8095, 13.0550),
('Casino Royale', 45.4408, 12.3155),
('The Last Samurai', 35.6762, 139.6503),
('Out of Africa', -1.2921, 36.8219),
('Midnight in Paris', 48.8566, 2.3522); 