package com.codeqwy.crowd.mvc.interceptor;

import com.codeqwy.crowd.constant.CrowdConstant;
import com.codeqwy.crowd.entity.Admin;
import com.codeqwy.crowd.exception.AccessForbiddenException;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @Author CodeQwy
 * @Date 2022/1/9 16:16
 * @Description LoginInterceptor
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1.通过 request 对象获取 Session 对象
        HttpSession session = request.getSession();

        // 2. 尝试从 Session 域中获取 Admin 对象
        Admin admin = (Admin) session.getAttribute(CrowdConstant.ATTR_NAME_LOGIN_ADMIN);

        // 3.判断 admin 对象是否为空
        if(admin == null) {
            // 4.抛出异常
            throw new AccessForbiddenException(CrowdConstant.MESSAGE_ACCESS_FORBIDDEN);
        }
        // 5.如果 Admin 对象不为 null，则返回 true放行
        return true;
    }
}
