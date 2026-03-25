
# Recipes Diary
**Recipes Diary** is a web-based recipe recommendation and community review platform. Inspired by social sharing sites, it tracks user cooking history and cuisine preferences to provide a personalized experience. The more you cook and rate, the better the platform understands your taste.

---

### Features
* **Personalized Recommendations:** Data-driven suggestions based on your unique "Cuisine Preference Profile."
* **Cook Log:** Track every dish you make and build a digital diary of your culinary journey.
* **Community Reviews:** Rate recipes, write reviews, and share modifications with other users.
* **Recipe Contributions:** Upload your own recipes to our growing community-driven catalog.
* **Advanced Search:** Filter by cuisine, difficulty, ingredients, or prep time.

---

### Tech Stack
* **Frontend:** HTML5, CSS3
* **Backend:** PHP
* **Database:** MySQL
* **Server:** Apache (XAMPP)
* **Version Control:** GitHub

---

###  Project Structure
* `/assets` - CSS styles and UI images.
* `/src` - Core PHP logic and `db.php` connection.
* `/sql` - Database `schema.sql` and migration files.
* `/public` - User-facing HTML pages (Home, Login, Recipe Details).

---

### Team & Roles
| Member | Primary Role |
| :--- | :--- |
| **Helen** | Database & Backend Lead |
| **Larsen** | Backend Development |
| **Kori** | Database & Frontend |
| **Aniyah** | Database & Frontend |
| **Mia** | Frontend Lead (UI/UX) |
| **Ashlyn** | Frontend Development |
| **Chase** | Frontend Development |

---

###  Setup Instructions
1.  **Clone the Repo:** `git clone https://github.com/[username]/recipes-diary.git`
2.  **Database:** Import `sql/schema.sql` into your local MySQL instance via phpMyAdmin.
3.  **Connection:** Update `src/db.php` with your local database credentials.
4.  **Launch:** Move the project folder to your `htdocs` directory and start Apache/MySQL via XAMPP.

---

###  Workflow Rules
* **Feature Branches:** Never push directly to `main`. Create a branch: `git checkout -b feature/your-task-name`.
* **Sync Often:** Always `git pull` before starting new work.
* **Pull Requests:** All code must be reviewed via a PR before merging into `main`.

