CREATE TABLE role (
    role_id serial PRIMARY KEY,
    role_name VARCHAR (255) UNIQUE NOT NULL
);


CREATE TABLE role (
    role_id serial PRIMARY KEY,
    role_name VARCHAR (255) UNIQUE NOT NULL
);


\c todo_db
CREATE TABLE todo (
	id SERIAL PRIMARY KEY,
	task TEXT NOT NULL
);


CREATE TABLE todos (
	id SERIAL PRIMARY KEY,
	task VARCHAR(255) NOT NULL,
	completed BOOLEAN NOT NULL DEFAULT FALSE
);
