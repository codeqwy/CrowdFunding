package com.codeqwy.crowd.service.api;

import com.codeqwy.crowd.entity.Admin;

import java.util.List;

/**
 * @Author CodeQwy
 * @Date 2022/1/7 10:44
 * @Description AdminService
 */
public interface AdminService {
    void saveAdmin(Admin admin);

    List<Admin> getAll();
}
