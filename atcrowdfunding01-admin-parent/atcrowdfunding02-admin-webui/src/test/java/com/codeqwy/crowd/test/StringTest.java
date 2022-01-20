package com.codeqwy.crowd.test;

import com.codeqwy.crowd.util.CrowdUtil;
import org.junit.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * @Author CodeQwy
 * @Date 2022/1/9 15:16
 * @Description StringTest
 */
public class StringTest {

    @Test
    public void testMd5() {
        String source = "123123";
        System.out.println(CrowdUtil.md5(source));

        BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
        String encode = bCryptPasswordEncoder.encode("123456");
        System.out.println(encode);
    }
}
