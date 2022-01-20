package com.codeqwy.crowd.mvc.config;

import com.codeqwy.crowd.entity.Admin;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

/**
 * @Author CodeQwy
 * @Date 2022/1/19 19:52
 * @Description SecurityAdmin
 */
public class SecurityAdmin extends User {
    // 原始的Admin 对象，包含Admin 对象的全部属性
    private Admin originalAdmin;

    public SecurityAdmin(Admin originalAdmin, Collection<? extends GrantedAuthority> authorities) {
        // 调用父类构造器
        super(originalAdmin.getLoginAcct(), originalAdmin.getUserPswd(), authorities);
        this.originalAdmin = originalAdmin;
        this.originalAdmin.setUserPswd(null);
    }

    // 对外提供的获取原始Admin 对象的getXxx()方法
    public Admin getOriginalAdmin() {
        return originalAdmin;
    }
}
