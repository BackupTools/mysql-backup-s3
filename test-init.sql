CREATE TABLE test_table (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(64) NOT NULL UNIQUE
);

INSERT INTO test_table (login) VALUES ('asd'), ('qwe'), ('zxc'), ('ert'), ('dfg');
