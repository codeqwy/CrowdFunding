package com.codeqwy.crowd.test;

import com.codeqwy.crowd.entity.Admin;
import com.codeqwy.crowd.entity.Role;
import com.codeqwy.crowd.mapper.AdminMapper;
import com.codeqwy.crowd.mapper.RoleMapper;
import com.codeqwy.crowd.service.api.AdminService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * @Author CodeQwy
 * @Date 2022/1/6 21:23
 * @Description CrowdTest
 */

// Spring 整合 Junit
// 指定 Spring 给 Junit 提供的运行器类
@RunWith(SpringJUnit4ClassRunner.class)
// 加载 Spring 配置文件的注解
@ContextConfiguration(locations = {"classpath:spring-persist-mybatis.xml", "classpath:spring-persist-tx.xml"})
public class CrowdTest {
    @Autowired
    private DataSource dataSource;

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private AdminService adminService;

    @Autowired
    private RoleMapper roleMapper;

    @Test
    public void testRole() {
        for (int i = 0; i < 234; ++i) {
            roleMapper.insert(new Role(null, "role" + i));
        }
    }

    @Test
    public void testTx() {
        for(int i = 1; i <= 222; ++i) {
            Admin admin = new Admin(null, "jerry" + i, "123123", "杰瑞" + i, "jerry@qq.com", null);
            adminService.saveAdmin(admin);
        }
    }

    @Test
    public void testInsertAdmin() {
        Admin admin = new Admin(null, "CodeQwy", "123456", "Quwny", "codeqwy@qq.com", null);
        int count = adminMapper.insert(admin);
        System.out.println("受影响的行数：" + count);
    }
    
    @Test
    public void testConnection() throws SQLException {
        // 通过数据源对象获取数据源连接
        Connection connection = dataSource.getConnection();
        System.out.println(connection);
    }

    
}
