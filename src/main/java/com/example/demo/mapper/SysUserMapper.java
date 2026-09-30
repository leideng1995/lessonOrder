package com.example.demo.mapper;

import com.example.demo.model.SysUser;
import com.example.demo.security.Role;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/** 系统用户表 sys_user(后台登录账号) */
@Mapper
public interface SysUserMapper {

    int insert(SysUser user);

    /** 修改姓名、角色、启用状态(不含密码) */
    int update(SysUser user);

    /** 改密码哈希;mustChange=true 表示下次登录必须修改(新建、管理员重置时) */
    int updatePassword(@Param("id") long id, @Param("hash") String hash, @Param("mustChange") boolean mustChange);

    /** 更新最后登录时间 */
    int touchLogin(@Param("id") long id);

    SysUser findById(@Param("id") long id);

    /** 按用户名查询(用户名统一存小写) */
    SysUser findByUsername(@Param("username") String username);

    List<SysUser> findAll();

    /** 用户总数,为 0 时启动会创建初始管理员 */
    int count();

    /** 启用中的某角色用户数,用于保证至少保留一个可用的管理员 */
    int countEnabledByRole(@Param("role") Role role);
}
