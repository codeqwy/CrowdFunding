package com.codeqwy.crowd.mvc.handler;

import com.codeqwy.crowd.constant.CrowdConstant;
import com.codeqwy.crowd.entity.Admin;
import com.codeqwy.crowd.service.api.AdminService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

/**
 * @Author CodeQwy
 * @Date 2022/1/9 15:25
 * @Description AdminHandler
 */
@Controller
public class AdminHandler {
    @Autowired
    private AdminService adminService;

    @RequestMapping("/admin/update.html")
    public String update(Admin admin) {
        adminService.update(admin);
        return "redirect:/admin/get/page.html";
    }


    @RequestMapping("/admin/to/edit/page.html")
    public String toEditPage(@RequestParam("adminId") Integer adminId, ModelMap modelMap) {

        Admin admin = adminService.getAdminById(adminId);

        modelMap.addAttribute("admin", admin);
        return "admin-edit";
    }

    @PreAuthorize("hasAuthority('user:save')")
    @RequestMapping("/admin/save.html")
    public String save(Admin admin) {
        adminService.saveAdmin(admin);
        return "redirect:/admin/get/page.html";
    }

    @RequestMapping("/admin/remove/{adminId}.html")
    public String remove(@PathVariable("adminId") Integer adminId) {
        adminService.remove(adminId);
        return "redirect:/admin/get/page.html";
    }

    @RequestMapping("/admin/get/page.html")
    public String getPageInfo(
            // 使用@RequestParam注解的defaultValue属性，指定默认值，在请求中没有携带对应参数时使用默认值
            // keyword默认值使用空字符串，和SQL语句配合实现两种情况适配
            @RequestParam(value="keyword", defaultValue="") String keyword,
            // pageNum默认值使用1
            @RequestParam(value="pageNum", defaultValue="1") Integer pageNum,
            // pageSize默认值使用5
            @RequestParam(value="pageSize", defaultValue="5") Integer pageSize,
            ModelMap modelMap
    ) {

        // 调用Service方法获取PageInfo对象
        PageInfo<Admin> pageInfo = adminService.getPageInfo(keyword, pageNum, pageSize);

        // 将PageInfo对象存入模型
        modelMap.addAttribute(CrowdConstant.ATTR_NAME_PAGE_INFO, pageInfo);

        return "admin-page";
    }

    @RequestMapping("/admin/do/logout.html")
    public String doLogout(HttpSession session) {
        // 强制Session失效
        session.invalidate();
        return "redirect:/admin/to/login/page.html";
    }

    @RequestMapping("/admin/do/login.html")
    public String doLogin(@RequestParam("loginAcct") String loginAcct, @RequestParam("userPswd") String userPswd, HttpSession session) {
        Admin admin = adminService.getAdminByLoginAcct(loginAcct, userPswd);

        session.setAttribute(CrowdConstant.ATTR_NAME_LOGIN_ADMIN, admin);
        return "admin-main";
    }
}
