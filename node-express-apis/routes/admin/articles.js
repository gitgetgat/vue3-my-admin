var express = require('express');
var router = express.Router();
const { Article } = require('../../models');
const { Op } = require('sequelize');
const { NotFoundError, resSuccess, resError } = require('../../utils/response');

/**
 * 白名单过滤 body
 * @param {*} body 
 */
function filterBody(body) {
  const { title, content } = body;
  return {
    title,
    content
  }
}

/* 
 * @description 公共方法：查询当前文章
 */
async function getArticle(req) {
  const { id } = req.params;

  const article = await Article.findByPk(id);
  // 文章不存在, 抛出 404 错误
  if (!article) {
    throw new NotFoundError(`ID: ${id} 的文章不存在`);
  }
  return article;
}

/* 
 * @description 获取文章列表
 * @route GET /api/articles
 */
router.get('/', async function (req, res, next) {
  try {
    const query = req.query;

    // 分页参数, 默认第一页
    const pageNum = Math.abs(Number(query.pageNum)) || 1;
    // 每页条数, 默认10条
    const pageSize = Math.abs(Number(query.pageSize)) || 10;

    // 计算分页参数
    const offset = (pageNum - 1) * pageSize;

    const condition = {
      order: [
        ['id', 'DESC']
      ],
      limit: pageSize,
      offset: offset
    };
    if (query.title) {
      condition.where = {
        title: {
          [Op.like]: `%${query.title}%`
        }
      }
    }
    if (query.content) {
      condition.where = {
        content: {
          [Op.like]: `%${query.content}%`
        }
      }
    }
    const { count, rows } = await Article.findAndCountAll(condition);

    resSuccess(res, '获取文章列表成功', {
      articles: rows,
      pagination: {
        total: count,
        pageNum,
        pageSize
      }
    });
  } catch (error) {
    resError(res, error);
  }
});

/**
 * @description 获取文章详情
 * @route GET /api/articles/:id
 */
router.get('/:id', async (req, res) => {
  try {
    const article = await getArticle(req);

    resSuccess(res, '获取文章详情成功', article);

  } catch (error) {
    resError(res, error);
  }
});

/**
 * @description 创建文章
 * @route POST /api/articles
 */
router.post('/', async (req, res) => {
  try {
    const body = filterBody(req.body);

    const article = await Article.create(body);

    resSuccess(res, '创建文章成功', article, 201);

  } catch (error) {
    resError(res, error);
  }
});

/**
 * @description 更新文章
 * @route PUT /api/articles/:id
 */
router.put('/:id', async (req, res) => {
  try {
    const body = filterBody(req.body);

    const article = await getArticle(req);

    await article.update(body);

    resSuccess(res, '更新文章成功', article);

  } catch (error) {
    resError(res, error);
  }
});

/**
 * @description 删除文章
 * @route DELETE /api/articles/:id
 */
router.delete('/:id', async (req, res) => {
  try {
    const article = await getArticle(req);

    await article.destroy();

    resSuccess(res, '删除文章成功', article);

  } catch (error) {
    resError(res, error);
  }
});

module.exports = router;
