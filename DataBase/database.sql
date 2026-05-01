CREATE DATABASE IF NOT EXISTS recipes_diary;
USE recipes_diary;
CREATE TABLE USERS (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- For BCRYPT
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE RECIPES (
    recipe_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    difficulty ENUM('Easy', 'Medium', 'Hard'),
    prep_time_min INT,
    cook_time_min INT,
    servings INT,
    instructions TEXT,
    submitted_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (submitted_by) REFERENCES USERS(user_id)
);

CREATE TABLE CATEGORIES (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE CUISINES (
    cuisine_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE INGREDIENTS (
    ingredient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    unit VARCHAR(30)
);
CREATE TABLE RECIPE_CATEGORIES (
    recipe_id INT,
    category_id INT,
    PRIMARY KEY (recipe_id, category_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    FOREIGN KEY (category_id) REFERENCES CATEGORIES(category_id)
);

CREATE TABLE RECIPE_CUISINES (
    recipe_id INT,
    cuisine_id INT,
    PRIMARY KEY (recipe_id, cuisine_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    FOREIGN KEY (cuisine_id) REFERENCES CUISINES(cuisine_id)
);

CREATE TABLE RECIPE_INGREDIENTS (
    recipe_id INT,
    ingredient_id INT,
    quantity VARCHAR(50),
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id),
    FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id)
);
CREATE TABLE COOK_LOG (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recipe_id INT,
    cooked_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
);

CREATE TABLE RATINGS (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recipe_id INT,
    stars TINYINT CHECK (stars BETWEEN 1 AND 5),
    rated_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, recipe_id), -- Prevent duplicate ratings
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
);

CREATE TABLE REVIEWS (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    recipe_id INT,
    body TEXT,
    posted_on DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
);