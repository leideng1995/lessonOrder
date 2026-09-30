package com.example.demo.mapper;

import com.example.demo.model.SysUser;
import com.example.demo.security.Role;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SysUserMapper {

    int insert(SysUser user);

    /** 修改姓名、角色、启用状态(不含密码) */
    int update(SysUser user);

    int updatePassword(@Param("id") long id, @Param("hash") String hash, @Param("mustChange") boolean mustChange);

    int touchLogin(@Param("id") long id);

    SysUser findById(@Param("id") long id);

    SysUser findByUsername(@Param("username") String username);

    List<SysUser> findAll();

    int count();

    /** 启用中的某角色用户数,用于保证至少保留一个可用的管理员 */
    int countEnabledByRole(@Param("role") Role role);
}
