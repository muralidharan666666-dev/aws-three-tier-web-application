-- Three-Tier Web Application - Database Setup Script
-- Author: Muralidharan M.N
-- Run this script after connecting to RDS from EC2

-- Create the application database
CREATE DATABASE threetierdb;

-- Use the database
USE threetierdb;

-- Create users table
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  created at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert test data
INSERT INTO users (name, email) 
VALUES ('Muralidharan', 'muralidharan366636@gmail.com');

-- Verify data
SELECT * FROM users;
