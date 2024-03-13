-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema bd_banco
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bd_banco` DEFAULT CHARACTER SET utf8mb4 ;
USE `bd_banco` ;

-- -----------------------------------------------------
-- Table `bd_banco`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_banco`.`cliente` (
  `idcliente` INT NOT NULL AUTO_INCREMENT,
  `cedula` VARCHAR(45) NULL,
  `nombre` VARCHAR(45) NULL,
  `email` VARCHAR(100) NULL,
  `telefono` VARCHAR(20) NULL,
  PRIMARY KEY (`idcliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_banco`.`cuenta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_banco`.`cuenta` (
  `idcuenta` INT NOT NULL AUTO_INCREMENT,
  `numero_cuenta` VARCHAR(45) NULL,
  `saldo` DOUBLE NULL DEFAULT 0,
  -- `actualizado_el` TIMESTAMP(6) NULL DEFAULT TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `actualizado_el` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `idcliente` INT NOT NULL,
  PRIMARY KEY (`idcuenta`),
  CONSTRAINT `fk_Cuenta_cliente1`
    FOREIGN KEY (`idcliente`)
    REFERENCES `bd_banco`.`cliente` (`idcliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_banco`.`tipo_transaccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_banco`.`tipo_transaccion` (
  `idtipo_transaccion` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL,
  `descripcion` VARCHAR(300) NULL,
  PRIMARY KEY (`idtipo_transaccion`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bd_banco`.`transaccion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bd_banco`.`transaccion` (
  `idtransaccion` INT NOT NULL AUTO_INCREMENT,
  `monto` DOUBLE NULL,
  `creado_el` TIMESTAMP(6) NULL DEFAULT CURRENT_TIMESTAMP,
  `idcuenta` INT NOT NULL,
  `idtipo_transaccion` INT NOT NULL,
  PRIMARY KEY (`idtransaccion`),
  CONSTRAINT `fk_movimientos_Cuenta`
    FOREIGN KEY (`idcuenta`)
    REFERENCES `bd_banco`.`cuenta` (`idcuenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaccion_tipo_transaccion1`
    FOREIGN KEY (`idtipo_transaccion`)
    REFERENCES `bd_banco`.`tipo_transaccion` (`idtipo_transaccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
