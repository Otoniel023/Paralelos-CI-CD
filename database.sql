CREATE DATABASE IF NOT EXISTS calzado_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE calzado_db;

CREATE TABLE IF NOT EXISTS usuarios (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(100) NOT NULL,
  apellido    VARCHAR(100) NOT NULL,
  email       VARCHAR(150) NOT NULL UNIQUE,
  password    VARCHAR(255) NOT NULL,
  rol         ENUM('admin', 'vendedor', 'cliente') NOT NULL DEFAULT 'cliente',
  activo      TINYINT(1) NOT NULL DEFAULT 1,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Usuario admin por defecto (password: admin123)
INSERT IGNORE INTO usuarios (nombre, apellido, email, password, rol) VALUES
  ('Admin', 'Sistema', 'admin@calzado.com', '$2a$10$uAxvolx.iDkG3QCbPwu0hOiliigQ6EH7XU4gilsSIgZt1tLZQOUyK', 'admin'),
  ('Juan', 'Vendedor', 'vendedor@calzado.com', '$2a$10$uAxvolx.iDkG3QCbPwu0hOiliigQ6EH7XU4gilsSIgZt1tLZQOUyK', 'vendedor'),
  ('Maria', 'Cliente', 'cliente@calzado.com', '$2a$10$uAxvolx.iDkG3QCbPwu0hOiliigQ6EH7XU4gilsSIgZt1tLZQOUyK', 'cliente');
