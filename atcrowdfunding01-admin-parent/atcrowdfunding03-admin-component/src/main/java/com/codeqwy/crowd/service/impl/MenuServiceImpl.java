package com.codeqwy.crowd.service.impl;

import com.codeqwy.crowd.entity.Menu;
import com.codeqwy.crowd.entity.MenuExample;
import com.codeqwy.crowd.mapper.MenuMapper;
import com.codeqwy.crowd.service.api.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author CodeQwy
 * @Date 2022/1/17 11:50
 * @Description MenuServiceImpl
 */
@Service
public class MenuServiceImpl implements MenuService {
    @Autowired
    private MenuMapper menuMapper;

    @Override
    public List<Menu> getAll() {
        return menuMapper.selectByExample(new MenuExample());
    }

    @Override
    public void saveMenu(Menu menu) {
        menuMapper.insert(menu);
    }

    @Override
    public void editMenu(Menu menu) {
        menuMapper.updateByPrimaryKeySelective(menu);
    }

    @Override
    public void removeMenuById(Integer id) {
        menuMapper.deleteByPrimaryKey(id);
    }
}
