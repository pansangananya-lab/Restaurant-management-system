-- สร้างฐานข้อมูลระบบจัดการร้านอาหาร
CREATE DATABASE IF NOT EXISTS restaurant_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restaurant_db;

-- 1. ตารางผู้ใช้งาน (พนักงาน, แคชเชียร์, ผู้จัดการ)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('staff', 'cashier', 'admin') DEFAULT 'staff',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. ตารางโต๊ะอาหาร
CREATE TABLE tables (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    table_number VARCHAR(10) NOT NULL UNIQUE,
    capacity INT DEFAULT 4,
    status ENUM('available', 'occupied', 'reserved') DEFAULT 'available'
);

-- 3. ตารางเมนูอาหาร
CREATE TABLE menus (
    menu_id INT AUTO_INCREMENT PRIMARY KEY,
    menu_name VARCHAR(100) NOT NULL,
    category ENUM('food', 'drink', 'dessert') DEFAULT 'food',
    price DECIMAL(10, 2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

-- 4. ตารางคำสั่งซื้อ (หัวบิล)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    table_id INT NOT NULL,
    user_id INT NOT NULL,
    total_price DECIMAL(10, 2) DEFAULT 0.00,
    order_status ENUM('pending', 'cooking', 'served', 'paid', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (table_id) REFERENCES tables(table_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 5. ตารางรายละเอียดรายการอาหารในออเดอร์
CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (menu_id) REFERENCES menus(menu_id)
);

-- 6. ตารางสต็อกวัตถุดิบ
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    min_threshold DECIMAL(10, 2) DEFAULT 5.00
);

-- ข้อมูลเริ่มต้น (Mock Data) สำหรับทดสอบระบบ
INSERT INTO users (username, password, full_name, role) VALUES 
('admin', '1234', 'ผู้จัดการร้าน', 'admin'),
('staff01', '1234', 'พนักงานรับออเดอร์', 'staff');

INSERT INTO tables (table_number, capacity, status) VALUES 
('T01', 4, 'available'),
('T02', 4, 'available'),
('T03', 6, 'available'),
('T04', 2, 'available');

INSERT INTO menus (menu_name, category, price) VALUES 
('ข้าวผัดกะเพราหมูสับไข่ดาว', 'food', 65.00),
('ต้มยำกุ้งน้ำข้น', 'food', 150.00),
('ชาไทยเย็น', 'drink', 45.00),
('น้ำเปล่า', 'drink', 15.00);