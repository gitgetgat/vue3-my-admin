-- 初始化角色
INSERT INTO roles (role_name, description, is_default) VALUES
('admin', '系统管理员', false),
('editor', '内容编辑', false),
('author', '作者', true),
('subscriber', '订阅者', false);

-- 初始化权限
INSERT INTO permissions (permission_key, name, category) VALUES
('post:create', '创建文章', '内容'),
('post:edit', '编辑文章', '内容'),
('post:publish', '发布文章', '内容'),
('post:delete', '删除文章', '内容'),
('comment:moderate', '评论审核', '内容'),
('user:manage', '用户管理', '系统'),
('settings:manage', '系统设置', '系统');

-- 为管理员分配权限
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.role_id, p.permission_id
FROM roles r, permissions p
WHERE r.role_name = 'admin';

-- 创建默认用户
INSERT INTO users (username, password_hash, email, display_name) 
VALUES ('admin', '$2y$10$ExampleHash...', 'admin@blog.com', '管理员');

-- 分配管理员角色
INSERT INTO user_roles (user_id, role_id)
VALUES (1, (SELECT role_id FROM roles WHERE role_name = 'admin'));