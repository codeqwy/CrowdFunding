package com.codeqwy.crowd.util;

import javax.servlet.http.HttpServletRequest;

/**
 * @Author CodeQwy
 * @Date 2022/1/7 17:12
 * @Description CrowdUtil
 */

public class CrowdUtil {
    /**
     * 判断当前请求是否为 Ajax 请求
     * @param request 请求对象
     * @return true：当前请求是 Ajax 请求；false：不是
     */
    public static boolean judgeRequestType(HttpServletRequest request) {
        // 1.获取请求消息头
        String acceptHeader = request.getHeader("Accept");
        String xRequestHeader = request.getHeader("X-Requested-With");
        // 2. 判断
        return (acceptHeader != null && acceptHeader.contains("application/json")) || (xRequestHeader != null && xRequestHeader.contains("XMLHttpRequest"));
    }
}
