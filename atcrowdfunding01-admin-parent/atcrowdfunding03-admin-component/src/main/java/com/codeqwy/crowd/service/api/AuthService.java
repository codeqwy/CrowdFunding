package com.codeqwy.crowd.service.api;

import com.codeqwy.crowd.entity.Auth;

import java.util.List;
import java.util.Map;

/**
 * @Author CodeQwy
 * @Date 2022/1/18 14:17
 * @Description AuthService
 */
public interface AuthService {
    List<Auth> getAll();

    List<Integer> getAssignedAuthIdByRoleId(Integer roleId);

    void saveRoleAuthRelationship(Map<String, List<Integer>> map);

    List<String> getAssignedAuthNameByAdminId(Integer adminId);

}
