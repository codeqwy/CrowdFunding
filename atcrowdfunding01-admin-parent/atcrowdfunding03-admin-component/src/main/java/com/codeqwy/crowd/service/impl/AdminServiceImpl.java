package com.codeqwy.crowd.service.impl;

import com.codeqwy.crowd.entity.Admin;
import com.codeqwy.crowd.entity.AdminExample;
import com.codeqwy.crowd.mapper.AdminMapper;
import com.codeqwy.crowd.service.api.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author CodeQwy
 * @Date 2022/1/7 10:44
 * @Description AdminServiceImpl
 */

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMapper adminMapper;

    @Override
    public void saveAdmin(Admin admin) {
        adminMapper.insert(admin);
    }

    @Override
    public List<Admin> getAll() {
        return adminMapper.selectByExample(new AdminExample());
    }
}
