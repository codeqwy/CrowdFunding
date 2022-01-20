package com.codeqwy.crowd.service.api;

import com.codeqwy.crowd.entity.Menu;

import java.util.List;

/**
 * @Author CodeQwy
 * @Date 2022/1/17 11:49
 * @Description MenuService
 */
public interface MenuService {
    List<Menu> getAll();

    void saveMenu(Menu menu);

    void editMenu(Menu menu);

    void removeMenuById(Integer id);
}
