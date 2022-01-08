package com.codeqwy.crowd.mvc.handler;

import com.codeqwy.crowd.entity.Admin;
import com.codeqwy.crowd.service.api.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @Author CodeQwy
 * @Date 2022/1/7 14:47
 * @Description TestHandler
 */

@Controller
public class TestHandler {
    @Autowired
    private AdminService adminService;

    @ResponseBody
    @RequestMapping("/send/array/two.html")
    public String testReceiveArrayTwo(@RequestBody List<Integer> array) {
        array.forEach(System.out::println);
        return "Success";
    }

    @ResponseBody
    @RequestMapping("/send/array/one.html")
    public  String testReceiveArrayOne(@RequestParam("array[]") List<Integer> array) {
        array.forEach(System.out::println);
        return "Success";
    }

    @RequestMapping("/test/ssm.html")
    public String testSsm(ModelMap modelMap) {

        List<Admin> adminList = adminService.getAll();

        modelMap.addAttribute("adminList", adminList);

        int i = 10 / 0;

        return "target";
    }
}
