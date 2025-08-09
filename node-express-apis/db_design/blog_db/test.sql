-- 检查用户是否有删除文章的权限
SELECT EXISTS (
        SELECT 1
        FROM
            user_roles ur
            JOIN role_permissions rp ON ur.role_id = rp.role_id
            JOIN permissions p ON rp.permission_id = p.permission_id
        WHERE
            ur.user_id = 123
            AND p.permission_key = 'post:delete'
    ) AS has_permission;

-- 获取最近30天文章阅读趋势
SELECT DATE_FORMAT(metric_date, '%Y-%m-%d') AS day, SUM(view_count) AS total_views
FROM post_metrics
WHERE
    metric_type = 'DAILY'
    AND metric_date BETWEEN CURDATE() - INTERVAL 30 DAY AND CURDATE()
GROUP BY
    day
ORDER BY day;

-- 分析热门内容
SELECT p.post_id, p.title, COUNT(
        CASE
            WHEN ua.action_type = 'VIEW' THEN 1
        END
    ) AS views, COUNT(
        CASE
            WHEN ua.action_type = 'LIKE' THEN 1
        END
    ) AS likes, COUNT(
        CASE
            WHEN ua.action_type = 'SHARE' THEN 1
        END
    ) AS shares
FROM posts p
    LEFT JOIN user_actions ua ON p.post_id = ua.post_id
WHERE
    ua.created_at & gt;

NOW() - INTERVAL 7 DAY
GROUP BY
    p.post_id
ORDER BY views DESC
LIMIT 10;