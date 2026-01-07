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
  FOREIGN KEY (product_id) REFERENCES "store".products(product_id) ON DELETE CASCADE,
  FOREIGN KEY (supplier_id) REFERENCES "store".suppliers(supplier_id) ON DELETE SET NULL -- Opcional, caso o fornecedor seja removido
);