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

### 运行迁移文件

`sequelize db:migrate`

### 创建种子文件

`sequelize seed:generate --name article`

### 运行指定种子

#### --seed 后是种子文件名（不含后缀），例如种子文件名是 20250802061028-article.js

`sequelize db:seed --seed 20250802061028-article`

### 运行所有种子

`sequelize db:seed:all`
