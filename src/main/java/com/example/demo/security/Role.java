package com.example.demo.security;

import java.util.List;
import java.util.Set;

/**
 * 角色 → 权限 → 菜单,权限定义只在这一处。
 * 后端按权限拦截接口(AuthInterceptor),前端按 menus 显示菜单、按 permissions 显示按钮。
 */
public enum Role {

    ADMIN("管理员", Set.of(Perm.values())),

    RECEPTION("前台", Set.of(
            Perm.STUDENT_READ, Perm.STUDENT_WRITE,
            Perm.LESSON_READ,
            Perm.ORDER_READ, Perm.ORDER_WRITE,
            Perm.RECHARGE_READ, Perm.POINTS_READ, Perm.BALANCE_READ)),

    ACADEMIC("教务", Set.of(
            Perm.STUDENT_READ,
            Perm.LESSON_READ, Perm.LESSON_WRITE));

    private final String label;
    private final Set<Perm> perms;

    Role(String label, Set<Perm> perms) {
        this.label = label;
        this.perms = perms;
    }

    public String label() {
        return label;
    }

    public boolean has(Perm p) {
        return perms.contains(p);
    }

    public List<String> permissionCodes() {
        return perms.stream().map(Perm::code).sorted().toList();
    }

    /** 菜单(页面 key)及进入该页面需要的权限,顺序即侧边栏顺序 */
    private static final List<Object[]> MENUS = List.of(
            new Object[]{"students", Perm.STUDENT_WRITE},
            new Object[]{"lessons", Perm.LESSON_READ},
            new Object[]{"orders", Perm.ORDER_READ},
            new Object[]{"recharges", Perm.RECHARGE_READ},
            new Object[]{"balance", Perm.BALANCE_READ},
            new Object[]{"points", Perm.POINTS_READ},
            new Object[]{"schedule", Perm.STUDENT_READ},
            new Object[]{"users", Perm.USER_ADMIN},
            new Object[]{"logs", Perm.LOG_READ});

    public List<String> menus() {
        return MENUS.stream().filter(m -> has((Perm) m[1])).map(m -> (String) m[0]).toList();
    }

    public enum Perm {
        STUDENT_READ("student:read"),
        STUDENT_WRITE("student:write"),
        LESSON_READ("lesson:read"),
        LESSON_WRITE("lesson:write"),
        ORDER_READ("order:read"),
        ORDER_WRITE("order:write"),
        RECHARGE_READ("recharge:read"),
        POINTS_READ("points:read"),
        BALANCE_READ("balance:read"),
        USER_ADMIN("user:admin"),
        LOG_READ("log:read");

        private final String code;

        Perm(String code) {
            this.code = code;
        }

        public String code() {
            return code;
        }
    }
}
