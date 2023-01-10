TRUNCATE TABLE albums, artists RESTART IDENTITY;

INSERT INTO "public"."albums" ("title", "release_year", "artist_id") VALUES
('Doolittle', 1989, 1),
('Surfer Rosa', 1988, 1);

INSERT INTO "public"."artists" ("name", "genre") VALUES
('Pixies', 'Rock'),
('ABBA', 'Pop');