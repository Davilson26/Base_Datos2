CREATE DATABASE IF NOT EXISTS empresas DEFAULT CHARACTER SET utf8 ;
USE empresas ;

-- Tabla fabricantes
CREATE TABLE IF NOT EXISTS fabricantes (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


-- Tabla productos
CREATE TABLE IF NOT EXISTS productos (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NULL,
  precio DOUBLE NULL,
  fabricantes_id INT NOT NULL,
  PRIMARY KEY (id, fabricantes_id),
  CONSTRAINT fk_productos_fabricantes
    FOREIGN KEY (fabricantes_id)
    REFERENCES fabricantes (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;