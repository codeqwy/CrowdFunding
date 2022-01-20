package com.codeqwy.crowd.service.api;

import com.codeqwy.crowd.entity.Role;
import com.github.pagehelper.PageInfo;

import java.util.List;

/**
 * @Author CodeQwy
 * @Date 2022/1/12 20:36
 * @Description RoleService
 */
public interface RoleService {
    PageInfo<Role> getPageInfo(Integer pageNum, Integer pageSize, String keyword);

    void saveRole(Role role);

    void updateRole(Role role);

    void removeRole(List<Integer> roleIdList);

    List<Role> getAssignedRole(Integer adminId);

    List<Role> getUnAssignedRole(Integer adminId);

}
