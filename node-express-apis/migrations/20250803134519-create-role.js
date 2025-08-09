'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Roles', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.SMALLINT.UNSIGNED,
        comment: '角色ID'
      },
      role_id: {
        type: Sequelize.SMALLINT.UNSIGNED,
        allowNull: false,
        unique: true,
        foreignKey: true,
        references: {
          model: 'Roles',
          key: 'role_id'
        },
        comment: '角色ID'
      },
      is_deleted: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false,
        comment: '是否已删除(软删除)'
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        comment: '创建时间'
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        comment: '更新时间'
      }
    }, {
      comment: '系统角色定义',
      engine: 'InnoDB'
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('Roles');
  }
};