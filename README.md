# vue3-my-admin

# node-express-apis

## sequelize 命令

### 安装依赖包

`npm i sequelize mysql2`

### 初始化项目

`sequelize init`

### 创建数据库

`sequelize db:create --charset utf8mb4 --collate utf8mb4_unicode_ci`

### 创建模型

`sequelize model:generate --name Article --attributes title:string,content:text`

### 查看迁移状态

`sequelize db:migrate:status`

### 运行所有迁移文件

`sequelize db:migrate`

### 运行指定迁移文件

`sequelize db:migrate --name 20250802061028-article.js`

### 运行当前状态到指定迁移文件的所有迁移

`sequelize db:migrate --to 20250802061028-article.js`

### 查看迁移文件状态

`sequelize db:migrate:status`

### 创建种子文件

`sequelize seed:generate --name article`

### 运行指定种子

#### --seed 后是种子文件名（不含后缀），例如种子文件名是 20250802061028-article.js

`sequelize db:seed --seed 20250802061028-article`

### 运行所有种子

`sequelize db:seed:all`

### 回滚迁移文件

`sequelize db:migrate:undo`

### 回滚所有迁移文件

`sequelize db:migrate:undo:all`

### 回滚指定迁移文件

`sequelize db:migrate:undo --to 20250802061028-article.js`

### 先撤销再运行指定迁移文件

`sequelize db:migrate:undo --to 20250802061028-article.js && sequelize db:migrate --name 20250802061028-article.js`
