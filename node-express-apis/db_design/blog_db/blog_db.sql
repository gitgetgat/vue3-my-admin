-- 创建数据库（使用UTF8MB4字符集支持完整Unicode和emoji）
CREATE DATABASE blog_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE blog_db;

-- ======================= 核心权限系统 (RBAC模型) =======================

-- 角色表：定义系统角色（管理员、编辑、作者等）
CREATE TABLE `roles` (
    `role_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    `role_name` VARCHAR(50) NOT NULL UNIQUE COMMENT '角色名称(如admin, editor, author)',
    `description` VARCHAR(255) DEFAULT NULL COMMENT '角色描述',
    `is_default` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '新用户默认角色',
    `is_deleted` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '是否已删除(软删除)',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`role_id`)
) ENGINE = InnoDB COMMENT = '系统角色定义';

-- 权限表：定义具体操作权限（原子权限）
CREATE TABLE `permissions` (
    `permission_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '权限ID',
    `permission_key` VARCHAR(100) NOT NULL UNIQUE COMMENT '权限键(如post:create, user:delete)',
    `name` VARCHAR(100) NOT NULL COMMENT '权限名称',
    `description` VARCHAR(255) DEFAULT NULL COMMENT '权限详细描述',
    `category` VARCHAR(50) NOT NULL DEFAULT 'General' COMMENT '权限分类',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`permission_id`)
) ENGINE = InnoDB COMMENT = '系统权限清单';

-- 角色权限关联表：分配角色拥有的权限
CREATE TABLE `role_permissions` (
    `role_id` SMALLINT UNSIGNED NOT NULL COMMENT '角色ID',
    `permission_id` SMALLINT UNSIGNED NOT NULL COMMENT '权限ID',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`role_id`, `permission_id`),
    FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
    FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`permission_id`) ON DELETE CASCADE
) ENGINE = InnoDB COMMENT = '角色权限分配';

-- ======================= 用户系统 (集成RBAC) =======================

-- 用户表（移除is_admin字段，改用角色系统）
CREATE TABLE `users` (
    `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '登录账号',
    `password_hash` CHAR(100) NOT NULL COMMENT 'BCrypt加密密码',
    `email` VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    `display_name` VARCHAR(50) NOT NULL COMMENT '显示名称',
    `avatar_url` VARCHAR(255) DEFAULT NULL COMMENT '头像URL',
    `status` ENUM('ACTIVE', 'LOCKED', 'PENDING') NOT NULL DEFAULT 'ACTIVE' COMMENT '账户状态',
    `last_login_at` DATETIME DEFAULT NULL COMMENT '最后登录时间',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_id`),
    INDEX `idx_email` (`email`)
) ENGINE = InnoDB COMMENT = '用户账户信息';

-- 用户角色分配表：用户可拥有多个角色
CREATE TABLE `user_roles` (
    `user_id` INT UNSIGNED NOT NULL COMMENT '用户ID',
    `role_id` SMALLINT UNSIGNED NOT NULL COMMENT '角色ID',
    `assigned_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
    PRIMARY KEY (`user_id`, `role_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE
) ENGINE = InnoDB COMMENT = '用户角色分配';

-- ======================= 内容系统 =======================

-- 文章表（移除view_count字段，改由metrics表记录）
CREATE TABLE `posts` (
    `post_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '文章ID',
    `user_id` INT UNSIGNED NOT NULL COMMENT '作者ID',
    `title` VARCHAR(255) NOT NULL COMMENT '文章标题',
    `slug` VARCHAR(255) NOT NULL UNIQUE COMMENT 'URL友好标识',
    `summary` TEXT COMMENT '文章摘要',
    `content` LONGTEXT NOT NULL COMMENT '文章内容',
    `cover_image` VARCHAR(255) DEFAULT NULL COMMENT '封面图URL',
    `status` ENUM(
        'DRAFT',
        'PUBLISHED',
        'SCHEDULED',
        'ARCHIVED'
    ) NOT NULL DEFAULT 'DRAFT' COMMENT '发布状态',
    `is_featured` BOOLEAN NOT NULL DEFAULT FALSE COMMENT '是否置顶',
    `comment_status` BOOLEAN NOT NULL DEFAULT TRUE COMMENT '评论开关',
    `published_at` DATETIME DEFAULT NULL COMMENT '发布时间',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`post_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    INDEX `idx_slug` (`slug`),
    INDEX `idx_published` (`published_at`),
    FULLTEXT KEY `ft_content` (`title`, `content`)
    WITH
        PARSER ngram COMMENT '全文索引'
) ENGINE = InnoDB COMMENT = '博客文章';

-- ======================= 数据分析系统 =======================

-- 文章指标表：按时间维度存储文章指标
CREATE TABLE `post_metrics` (
    `metric_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '指标ID',
    `post_id` INT UNSIGNED NOT NULL COMMENT '文章ID',
    `metric_type` ENUM('DAILY', 'WEEKLY', 'MONTHLY') NOT NULL DEFAULT 'DAILY' COMMENT '统计粒度',
    `metric_date` DATE NOT NULL COMMENT '统计日期',
    `view_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '阅读数',
    `like_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
    `share_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '分享数',
    `comment_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '评论数',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`metric_id`),
    UNIQUE KEY `uq_post_metric` (
        `post_id`,
        `metric_type`,
        `metric_date`
    ), -- 唯一约束防止重复统计
    FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
    INDEX `idx_metric_date` (`metric_date`)
) ENGINE = InnoDB COMMENT = '文章指标统计';

-- 用户行为表：记录关键用户行为
CREATE TABLE `user_actions` (
    `action_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '行为ID',
    `user_id` INT UNSIGNED DEFAULT NULL COMMENT '用户ID(可为匿名用户)',
    `post_id` INT UNSIGNED DEFAULT NULL COMMENT '关联文章ID',
    `action_type` VARCHAR(50) NOT NULL COMMENT '行为类型(VIEW, LIKE, SHARE, COMMENT)',
    `action_data` JSON DEFAULT NULL COMMENT '行为附加数据',
    `ip_address` VARCHAR(45) NOT NULL COMMENT '用户IP',
    `user_agent` VARCHAR(255) DEFAULT NULL COMMENT '浏览器标识',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`action_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
    FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE SET NULL,
    INDEX `idx_action_type` (`action_type`)
) ENGINE = InnoDB COMMENT = '用户行为分析';

-- ======================= 内容分类系统 =======================

-- 分类表（树形结构）
CREATE TABLE `categories` (
    `category_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `slug` VARCHAR(100) NOT NULL UNIQUE,
    `parent_id` INT UNSIGNED DEFAULT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`category_id`),
    FOREIGN KEY (`parent_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE = InnoDB COMMENT = '文章分类';

-- 文章分类关联表
CREATE TABLE `post_categories` (
    `post_id` INT UNSIGNED NOT NULL,
    `category_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`post_id`, `category_id`),
    FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
    FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- ======================= 标签系统 =======================

-- 标签表
CREATE TABLE `tags` (
    `tag_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `slug` VARCHAR(100) NOT NULL UNIQUE,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`tag_id`)
) ENGINE = InnoDB COMMENT = '文章标签';

-- 文章标签关联表
CREATE TABLE `post_tags` (
    `post_id` INT UNSIGNED NOT NULL,
    `tag_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`post_id`, `tag_id`),
    FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
    FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`) ON DELETE CASCADE
) ENGINE = InnoDB;

-- ======================= 评论系统 =======================

-- 评论表（三级回复结构）
CREATE TABLE `comments` (
    `comment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `post_id` INT UNSIGNED NOT NULL COMMENT '所属文章',
    `user_id` INT UNSIGNED DEFAULT NULL COMMENT '评论用户',
    `author` VARCHAR(50) NOT NULL COMMENT '作者名(用户或访客)',
    `email` VARCHAR(100) NOT NULL COMMENT '邮箱',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `parent_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '父评论ID',
    `status` ENUM(
        'APPROVED',
        'PENDING',
        'SPAM',
        'TRASH'
    ) NOT NULL DEFAULT 'PENDING' COMMENT '审核状态',
    `like_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`comment_id`),
    FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
    FOREIGN KEY (`parent_id`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE,
    INDEX `idx_post_status` (`post_id`, `status`)
) ENGINE = InnoDB COMMENT = '文章评论';

-- ======================= 其他系统 =======================

-- 系统设置表
CREATE TABLE `settings` (
    `setting_key` VARCHAR(100) NOT NULL,
    `setting_value` JSON NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`setting_key`)
) ENGINE = InnoDB COMMENT = '系统配置';

-- 附件表
CREATE TABLE `attachments` (
    `file_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `original_name` VARCHAR(255) NOT NULL,
    `storage_path` VARCHAR(255) NOT NULL UNIQUE,
    `mime_type` VARCHAR(100) NOT NULL,
    `file_size` INT UNSIGNED NOT NULL COMMENT '字节大小',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`file_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE = InnoDB COMMENT = '上传文件';

-- 操作日志表（审计用）
CREATE TABLE `audit_logs` (
    `log_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` INT UNSIGNED DEFAULT NULL,
    `action` VARCHAR(50) NOT NULL COMMENT '操作类型',
    `target_type` VARCHAR(50) NOT NULL COMMENT '操作对象类型',
    `target_id` VARCHAR(100) NOT NULL COMMENT '操作对象ID',
    `ip_address` VARCHAR(45) NOT NULL,
    `user_agent` VARCHAR(255) DEFAULT NULL,
    `details` TEXT COMMENT '操作详情',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`log_id`),
    INDEX `idx_action_time` (`action`, `created_at`)
) ENGINE = InnoDB COMMENT = '审计日志';