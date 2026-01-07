-- Exercício: Definindo a Estrutura de um Banco de Dados (DDL)
-- Aluno: Lucas Bassani
-- Curso: FullStack Python
-- GitHub: Lcbzinho

############################################################

-- Criando um banco
CREATE DATABASE dbebac;

-- Conectar ao banco de dados ebac
\c dbebac;

-- criar o esquema
CREATE SCHEMA store;

-- Criando a tabela de CLIENTES
CREATE TABLE "store".customer (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20),
  document_number VARCHAR(20) UNIQUE,
  address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(50),
  postal_code VARCHAR(20),
  birth_date DATE,
  registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'active'
);

-- Criando a tabela de PRODUTOS
CREATE TABLE "store".product (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price NUMERIC(12, 2) NOT NULL,
  stock_quantity INTEGER NOT NULL,
  sku VARCHAR(50) UNIQUE,
  brand VARCHAR(100),
  category VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'available'
);

-- Criando a tabela de FORNECEDOR
CREATE TABLE "store".suppliers (
  supplier_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  contact_person VARCHAR(100),
  phone VARCHAR(20),
  email VARCHAR(255) UNIQUE,
  address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(50),
  postal_code VARCHAR(20),
  country VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'active'
);

-- Criando a tabela de ESTOQUE
CREATE TABLE "store".product_stock (
  stock_id SERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL CHECK (quantity >= 0), -- Garantir que a quantidade não seja negativa
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  location VARCHAR(100),
  supplier_id INTEGER, -- ID do fornecedor, se aplicável
  stock_threshold INTEGER DEFAULT 10, -- Limite de alerta para reabastecimento
  FOREIGN KEY (product_id) REFERENCES "store".product(product_id) ON DELETE CASCADE,
  FOREIGN KEY (supplier_id) REFERENCES "store".suppliers(supplier_id) ON DELETE SET NULL -- Opcional, caso o fornecedor seja removido
);

-- Índice auxiliar para acelerar buscas por produto no estoque
CREATE INDEX IF NOT EXISTS idx_product_stock_product_id ON "store".product_stock(product_id);

-- Inserindo dados de CLIENTES
INSERT INTO "store".customer (name, email, phone, document_number, address, city, state, postal_code, birth_date, status)
VALUES
  ('Ana Silva', 'ana.silva@example.com', '+55 11 99999-1111', '12345678901', 'Rua A, 100', 'São Paulo', 'SP', '01000-000', '1990-05-12', 'active'),
  ('Bruno Souza', 'bruno.souza@example.com', '+55 21 98888-2222', '98765432100', 'Av. B, 200', 'Rio de Janeiro', 'RJ', '20000-000', '1985-02-20', 'active'),
  ('Carla Mendes', 'carla.mendes@example.com', '+55 31 97777-3333', '45678912300', 'Rua C, 300', 'Belo Horizonte', 'MG', '30000-000', '1992-09-08', 'active');

-- Inserindo dados de PRODUTOS (inclui marca)
INSERT INTO "store".product (name, description, price, stock_quantity, sku, brand, category, status)
VALUES
  ('Notebook Pro 14', 'Notebook 14" com 16GB RAM e 512GB SSD', 7499.90, 20, 'NBP14-001', 'TechBrand', 'Informática', 'available'),
  ('Smartphone X', 'Tela 6.5", 128GB, câmera dupla', 2999.00, 35, 'SMX-128', 'MobileCorp', 'Celulares', 'available'),
  ('Headphone Wireless', 'Over-ear, cancelamento de ruído', 599.90, 50, 'HPW-01', 'SoundMax', 'Áudio', 'available');

-- Inserindo dados de ESTOQUE (relaciona com produtos via FK)
INSERT INTO "store".product_stock (product_id, quantity, location, supplier_id, stock_threshold)
VALUES
  (1, 15, 'Centro-SP', NULL, 10),
  (2, 25, 'Centro-RJ', NULL, 12),
  (3, 40, 'Centro-MG', NULL, 8);