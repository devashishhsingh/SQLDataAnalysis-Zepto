# 📦 SQLDataAnalysis-Zepto

This project demonstrates a complete, real-world data analysis pipeline — from deploying a PostgreSQL database using Docker to answering business questions using SQL.

We use a real-world-like e-commerce dataset inspired by **Zepto**, and the project is structured in two main parts:

1. **Docker Setup** — Deploy PostgreSQL and pgAdmin locally using Docker.
2. **SQL Data Analysis** — Explore, clean, and extract insights from the database using SQL.

---

## 🚀 Project Workflow

### 🔧 1. Docker & PostgreSQL Setup

- Download Docker from the [official website](https://www.docker.com/) or Microsoft Store.
- Visit [DockerHub](https://hub.docker.com/) to pull the following two images:
  - [`postgres`](https://hub.docker.com/_/postgres)
  - [`dpage/pgadmin4`](https://hub.docker.com/r/dpage/pgadmin4)

Create a folder named `postgres-docker` and inside it, create a file named `docker-compose.yml`:

```yaml
version: '3.8'

services:
  database:
    image: postgres:latest
    environment:
      POSTGRES_PASSWORD: [PASSWORD]
    volumes:
      - C:/[your_folder_name]/postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  pgadmin:
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: [USEREMAIL]
      PGADMIN_DEFAULT_PASSWORD: [PASSWORD]
    ports:
      - "8080:80"
    depends_on:
      - database
````

> Replace `[PASSWORD]` and `[USEREMAIL]` with your preferred values.

**Run the following command** from inside the folder:

```bash
docker-compose up
```

Open `http://localhost:8080` in your browser to access pgAdmin.

Log in with the credentials you set above and create a new database named `zepto`.

---

## 🗃 Dataset Overview

The dataset (sourced from Kaggle) mimics an actual inventory structure from Zepto’s platform.

Each row represents a unique **SKU** (Stock Keeping Unit) of a product.

### 📄 Columns:

| Column                   | Description                                |
| ------------------------ | ------------------------------------------ |
| `sku_id`                 | Unique identifier (Synthetic Primary Key)  |
| `name`                   | Product name                               |
| `category`               | Product category (e.g., Fruits, Snacks)    |
| `mrp`                    | Maximum Retail Price (₹)                   |
| `discountPercent`        | Discount applied on MRP (%)                |
| `discountedSellingPrice` | Final price after discount (₹)             |
| `availableQuantity`      | Units available in inventory               |
| `weightInGms`            | Product weight in grams                    |
| `outOfStock`             | Boolean flag indicating stock availability |
| `quantity`               | Number of units per package                |

---

## 🛠️ Database Setup

### 1. Create Table in pgAdmin

Use the following SQL query to create the table structure:

```sql
CREATE TABLE zepto_kaggle (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);
```

### 2. Import CSV Data

* Right-click on the `zepto_kaggle` table → Import/Export.
* **General Tab**:

  * File Name: (path to the CSV file)
  * Format: `CSV`
  * Encoding: `UTF8`
<img width="873" height="685" alt="image" src="https://github.com/user-attachments/assets/ea017179-8aa8-4e05-bb08-e6dd28ee764a" />

* **Options Tab**:

  * Header: ✔️ (Checked, because CSV includes headers)
<img width="877" height="678" alt="image" src="https://github.com/user-attachments/assets/ea6dc013-5fa9-4ff1-80b0-bd38a0ea4584" />

* **Columns Tab**:

  * Exclude `sku_id` (It auto-generates)
<img width="874" height="678" alt="image" src="https://github.com/user-attachments/assets/f9420775-a95a-41df-8064-060d77313249" />

---

## 🔎 Data Exploration

* Counted total number of records.
* Viewed sample data to understand structure.
* Checked for `NULL` values.
* Identified distinct categories.
* Compared **in-stock** vs **out-of-stock** product counts.
* Found duplicate products listed under multiple SKUs.

---

## 🧹 Data Cleaning

* Removed rows with `MRP` or `discountedSellingPrice` = 0.
* Converted MRP and price fields from paise to ₹ (if required).
* Validated data consistency across key columns.

---

## 📊 Business Insights

1. **Top 10 Best-Value Products** — Based on highest discount percentage.
2. **Out-of-Stock Premium Products** — High MRP items currently unavailable.
3. **Category-wise Revenue Potential** — Estimation based on stock & price.
4. **Minimal Discount Premium Products** — MRP > ₹500 but discounts < 10%.
5. **Top 5 Discount Categories** — Based on average discount percentage.
6. **Price per Gram** — Identify best-value products by weight.
7. **Product Weight Bucketing** — Grouped into:

   * Low: < 250g
   * Medium: 250g–500g
   * Bulk: > 500g
8. **Total Inventory Weight** — Measured per product category.

---

## 📌 Key Skills Demonstrated

* Docker & container orchestration
* PostgreSQL database setup
* pgAdmin usage
* Writing efficient SQL queries (Basic to Intermediate)
* Data Cleaning & Analysis
* Real-world dataset handling

---

## 🧠 Final Note

This project is ideal for beginners and intermediate SQL learners who want hands-on experience with Docker and PostgreSQL while solving business problems through real data.

Happy Learning! 🚀



