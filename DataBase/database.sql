-- ============================================================
--  Recipes Diary — Complete SQL Schema
--  Database Management Systems | Spring 2026
--  Team: Ashlyn Garza, Chase McCool, Kori-Elise Rushing,Aniyah Stewart-Smith, Mia Abrego, Helen Gomes, Larsen Riise
-- ============================================================

CREATE DATABASE IF NOT EXISTS recipes_diary;
USE recipes_diary;

-- 1. USERS
CREATE TABLE IF NOT EXISTS USERS (
    user_id       INT           NOT NULL AUTO_INCREMENT,
    username      VARCHAR(50)   NOT NULL UNIQUE,
    email         VARCHAR(100)  NOT NULL UNIQUE,
    password_hash VARCHAR(255)  NOT NULL,
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id)
);

-- 2. CATEGORIES
CREATE TABLE IF NOT EXISTS CATEGORIES (
    category_id INT         NOT NULL AUTO_INCREMENT,
    name        VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (category_id)
);

-- 3. CUISINES
CREATE TABLE IF NOT EXISTS CUISINES (
    cuisine_id INT         NOT NULL AUTO_INCREMENT,
    name       VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (cuisine_id)
);

-- 4. INGREDIENTS
CREATE TABLE IF NOT EXISTS INGREDIENTS (
    ingredient_id INT          NOT NULL AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL UNIQUE,
    unit          VARCHAR(30)  NOT NULL DEFAULT '',
    PRIMARY KEY (ingredient_id)
);

-- 5. RECIPES
CREATE TABLE IF NOT EXISTS RECIPES (
    recipe_id     INT           NOT NULL AUTO_INCREMENT,
    title         VARCHAR(150)  NOT NULL,
    difficulty    ENUM('Easy','Medium','Hard') NOT NULL DEFAULT 'Easy',
    prep_time_min INT           NOT NULL DEFAULT 0,
    cook_time_min INT           NOT NULL DEFAULT 0,
    servings      INT           NOT NULL DEFAULT 1,
    instructions  TEXT          NOT NULL,
    submitted_by  INT           NOT NULL,
    created_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (recipe_id),
    CONSTRAINT fk_recipe_user
        FOREIGN KEY (submitted_by) REFERENCES USERS(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. RECIPE_CATEGORIES
CREATE TABLE IF NOT EXISTS RECIPE_CATEGORIES (
    recipe_id   INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (recipe_id, category_id),
    CONSTRAINT fk_rc_recipe
        FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rc_category
        FOREIGN KEY (category_id) REFERENCES CATEGORIES(category_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. RECIPE_CUISINES
CREATE TABLE IF NOT EXISTS RECIPE_CUISINES (
    recipe_id  INT NOT NULL,
    cuisine_id INT NOT NULL,
    PRIMARY KEY (recipe_id, cuisine_id),
    CONSTRAINT fk_rcui_recipe
        FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rcui_cuisine
        FOREIGN KEY (cuisine_id) REFERENCES CUISINES(cuisine_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. RECIPE_INGREDIENTS
CREATE TABLE IF NOT EXISTS RECIPE_INGREDIENTS (
    recipe_id     INT         NOT NULL,
    ingredient_id INT         NOT NULL,
    quantity      VARCHAR(50) NOT NULL,
    PRIMARY KEY (recipe_id, ingredient_id),
    CONSTRAINT fk_ri_recipe
        FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ri_ingredient
        FOREIGN KEY (ingredient_id) REFERENCES INGREDIENTS(ingredient_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. COOK_LOG
CREATE TABLE IF NOT EXISTS COOK_LOG (
    log_id    INT      NOT NULL AUTO_INCREMENT,
    user_id   INT      NOT NULL,
    recipe_id INT      NOT NULL,
    cooked_on DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (log_id),
    CONSTRAINT fk_cl_user
        FOREIGN KEY (user_id) REFERENCES USERS(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_cl_recipe
        FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 10. RATINGS
CREATE TABLE IF NOT EXISTS RATINGS (
    rating_id INT      NOT NULL AUTO_INCREMENT,
    user_id   INT      NOT NULL,
    recipe_id INT      NOT NULL,
    stars     TINYINT  NOT NULL CHECK (stars BETWEEN 1 AND 5),
    rated_on  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (rating_id),
    UNIQUE KEY uq_user_recipe_rating (user_id, recipe_id),
    CONSTRAINT fk_rat_user
        FOREIGN KEY (user_id) REFERENCES USERS(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rat_recipe
        FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 11. REVIEWS
CREATE TABLE IF NOT EXISTS REVIEWS (
    review_id INT      NOT NULL AUTO_INCREMENT,
    user_id   INT      NOT NULL,
    recipe_id INT      NOT NULL,
    body      TEXT     NOT NULL,
    posted_on DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (review_id),
    UNIQUE KEY uq_user_recipe_review (user_id, recipe_id),
    CONSTRAINT fk_rev_user
        FOREIGN KEY (user_id) REFERENCES USERS(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rev_recipe
        FOREIGN KEY (recipe_id) REFERENCES RECIPES(recipe_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- SEED DATA
INSERT IGNORE INTO CATEGORIES (name) VALUES
    ('Breakfast'),('Lunch'),('Dinner'),
    ('Desserts'),('Snacks'),('Drinks'),('Coffee'),('Tea');

INSERT IGNORE INTO CUISINES (name) VALUES
    ('Italian'),('Mexican'),('Asian'),('Mediterranean'),
    ('American'),('French'),('Indian'),('Middle Eastern'),
    ('Greek'),('Japanese'),('Chinese'),('Thai'),
    ('Spanish'),('Caribbean');

-- RECOMMENDATION ENGINE QUERY
SELECT   c.category_id, c.name, COUNT(*) AS times_cooked
FROM     COOK_LOG cl
JOIN     RECIPES r            ON cl.recipe_id   = r.recipe_id
JOIN     RECIPE_CATEGORIES rc ON r.recipe_id    = rc.recipe_id
JOIN     CATEGORIES c         ON rc.category_id = c.category_id
WHERE    cl.user_id = 1
GROUP BY c.category_id, c.name
ORDER BY times_cooked DESC
LIMIT    3;
