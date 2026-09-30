/* 三个页面共用的工具和列表引擎(列表 + 新增 / 编辑 / 删除)。页面与接口同源,不需要处理跨域。 */
const API = '/api';
const PAGE_SIZE = 10;

const $ = (s) => document.querySelector(s);
const esc = (v) => String(v ?? '').replace(/[&<>"']/g,
  (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const pad = (n) => String(n).padStart(2, '0');

const fmtDate = (v) => {
  if (!v) return '—';
  if (Array.isArray(v)) return `${v[0]}-${pad(v[1])}-${pad(v[2])}`;
  return String(v).slice(0, 10);
};
const fmtDateTime = (v) => {
  if (!v) return '—';
  if (Array.isArray(v)) return `${fmtDate(v)} ${pad(v[3] || 0)}:${pad(v[4] || 0)}:${pad(v[5] || 0)}`;
  return String(v).replace('T', ' ').slice(0, 19);
};
/* 时间:接口可能返回 "09:30:00" 或 [9, 30],统一成 "09:30" */
const fmtTime = (v) => {
  if (!v) return '';
  if (Array.isArray(v)) return `${pad(v[0])}:${pad(v[1] || 0)}`;
  return String(v).slice(0, 5);
};
/* 日期时间拆成 Date 对象(按本地时间),接口返回 "2026-10-06T09:00:00" 或数组 */
const toDate = (v) => {
  if (!v) return null;
  if (Array.isArray(v)) return new Date(v[0], v[1] - 1, v[2], v[3] || 0, v[4] || 0, v[5] || 0);
  return new Date(String(v).replace(' ', 'T'));
};
const WEEK = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
/* "10-06 周一" */
const fmtDay = (v) => { const d = toDate(v); return d ? `${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${WEEK[d.getDay()]}` : '—'; };
/* 课次时间段 "10-06 周一 09:00-10:30" */
const fmtSpan = (start, end) => `${fmtDay(start)} ${fmtTime(fmtDateTime(start).slice(11))}-${fmtTime(fmtDateTime(end).slice(11))}`;
const money = (n) => (n == null ? '—' : '¥' + Number(n).toFixed(2));
const fullName = (s) => {
  const first = s.firstName || '', last = s.lastName || '';
  return /[\u4e00-\u9fa5]/.test(first + last) ? last + first : `${first} ${last}`.trim();
};

const ORDER_STATUS = {
  PENDING:   { text: '待确认', cls: 'warn' },
  CONFIRMED: { text: '已确认', cls: 'ok' },
  CANCELLED: { text: '已取消', cls: 'idle' },
};
const SESSION_STATUS = {
  SCHEDULED: { text: '正常', cls: 'ok' },
  CANCELLED: { text: '已停课', cls: 'bad' },
};
/* 操作日志分类 */
const LOG_CATEGORY = {
  LOGIN:     { text: '登录', cls: 'ok' },
  OPERATION: { text: '操作', cls: 'idle' },
  DENIED:    { text: '越权拒绝', cls: 'bad' },
  SYSTEM:    { text: '系统', cls: 'warn' },
};
/* 余额流水类型 */
const BALANCE_TYPE = {
  OPENING:  { text: '期初余额', cls: 'idle' },
  INITIAL:  { text: '开户余额', cls: 'idle' },
  RECHARGE: { text: '充值', cls: 'ok' },
  PAY:      { text: '支付', cls: 'warn' },
  REFUND:   { text: '退款', cls: 'ok' },
};
/* 支付截止前还剩多少分钟;已过期返回 0 */
const minutesLeft = (deadline) => Math.max(0, Math.ceil((toDate(deadline) - new Date()) / 60000));
/* 积分流水类型 */
const POINTS_TYPE = {
  EARN:     { text: '支付获得', cls: 'ok' },
  REDEEM:   { text: '抵扣支付', cls: 'warn' },
  REFUND:   { text: '退课退回', cls: 'idle' },
  CLAWBACK: { text: '退课扣回', cls: 'bad' },
  RECHARGE: { text: '充值赠送', cls: 'ok' },
};
/* 积分数量:千分位 */
const pts = (n) => Number(n || 0).toLocaleString('zh-CN');
const ITEM_STATUS = {
  ACTIVE:    { text: '有效', cls: 'ok' },
  CANCELLED: { text: '已退课', cls: 'idle' },
};
const PAY_STATUS = {
  UNPAID: { text: '未支付', cls: 'warn' },
  PAID:   { text: '已支付', cls: 'ok' },
  REFUNDED: { text: '已退款', cls: 'idle' },
};
const badge = (map, key) => {
  const m = map[key] || { text: key || '—', cls: 'idle' };
  return `<span class="badge ${m.cls}">${esc(m.text)}</span>`;
};

/* 统一的接口调用:失败时抛出带中文说明的 Error */
async function api(method, path, body) {
  let res;
  try {
    res = await fetch(API + path, {
      method,
      headers: body !== undefined ? { 'Content-Type': 'application/json' } : undefined,
      body: body !== undefined ? JSON.stringify(body) : undefined,
    });
  } catch (e) {
    throw new Error('无法连接到服务器,请确认后端已启动');
  }
  if (!res.ok) {
    let msg = '';
    try { msg = (await res.json()).message || ''; } catch (e) { /* 忽略 */ }
    // 未登录或会话过期:回到登录页,登录后再回到当前页面(登录接口自己的 401 是"密码错误",不跳转)
    if (res.status === 401 && path !== '/auth/login') {
      goLogin();
      throw new Error(msg || '登录已过期,请重新登录');
    }
    if (!msg) {
      msg = ({ 400: '提交的数据格式不正确', 403: '没有权限执行此操作', 404: '数据不存在,可能已被删除', 409: '操作与现有数据冲突' })[res.status]
        || `请求失败(${res.status})`;
    }
    throw new Error(msg);
  }
  if (res.status === 204) return null;
  const text = await res.text();
  return text ? JSON.parse(text) : null;
}
const getJSON = (path) => api('GET', path);

/* ---------- 登录与权限 ---------- */
let ME = null; // 当前登录用户:{ userId, username, displayName, role, roleName, mustChangePassword, permissions, menus }

function goLogin() {
  const next = location.pathname + location.search;
  location.replace('/login.html' + (next && next !== '/' ? '?next=' + encodeURIComponent(next) : ''));
}

/* 当前用户是否有某个权限(只用来显示/隐藏按钮;真正的权限检查在后端) */
const hasPerm = (code) => !!ME && ME.permissions.includes(code);

/*
 * 每个页面渲染前调用:未登录跳登录页;没有该页面的菜单权限则跳到第一个有权限的页面。
 * 返回当前用户。
 */
async function requireLogin(pageKey) {
  try {
    ME = await getJSON('/auth/me');
  } catch (e) {
    if (!ME) {
      // 401 已在 api() 里跳转;其他错误(如后端没启动)显示在页面上
      document.body.innerHTML = `<div class="boot-error"><strong>无法连接到服务器</strong>${esc(e.message)}</div>`;
    }
    throw e;
  }
  if (pageKey && !ME.menus.includes(pageKey)) {
    location.replace(ME.menus.length ? `/${ME.menus[0]}.html` : '/login.html');
    throw new Error('没有该页面的权限');
  }
  return ME;
}

async function logout() {
  try { await api('POST', '/auth/logout'); } catch (e) { /* 已过期也无妨 */ }
  location.replace('/login.html');
}

/* 修改密码;force 为 true 时是首次登录强制修改,不能关闭 */
function openChangePassword(force) {
  openDialog({
    title: force ? '请修改初始密码' : '修改密码',
    locked: force,
    body: `${force ? '<p class="note">为了账号安全,首次登录需要设置自己的密码。</p>' : ''}
      <div class="field"><label for="pw_old">${force ? '初始密码' : '原密码'}</label>
        <input id="pw_old" name="oldPassword" type="password" required autocomplete="current-password"></div>
      <div class="field"><label for="pw_new">新密码</label>
        <input id="pw_new" name="newPassword" type="password" required minlength="8" maxlength="64" autocomplete="new-password">
        <span class="help">8~64 位,同时包含字母和数字</span></div>
      <div class="field"><label for="pw_new2">确认新密码</label>
        <input id="pw_new2" name="confirm" type="password" required autocomplete="new-password"></div>`,
    submit: '保存',
    success: '密码已修改',
    onSubmit: async (d) => {
      if (d.newPassword !== d.confirm) throw new Error('两次输入的新密码不一致');
      ME = await api('PUT', '/auth/password', { oldPassword: d.oldPassword, newPassword: d.newPassword });
    },
    after: () => { if (force) location.reload(); },
  });
}

/* 操作结果提示 */
let toastTimer;
function toast(msg) {
  let t = $('#toast');
  if (!t) {
    t = document.createElement('div');
    t.id = 'toast';
    t.className = 'toast';
    t.setAttribute('role', 'status');
    document.body.appendChild(t);
  }
  t.textContent = msg;
  // 先移除再添加,连续操作时也能重新触发显示
  t.classList.remove('show');
  void t.offsetWidth;
  t.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => t.classList.remove('show'), 3200);
}

/*
 * 对话框:表单和确认共用。onSubmit 抛出错误时,错误显示在对话框内,不会关闭。
 * 不传 submit 时是只读的查看对话框,只有「关闭」按钮;wide 为 true 时加宽(用于表格)。
 */
function openDialog({ title, body, submit, danger, onSubmit, success, after, wide, locked }) {
  const dlg = document.createElement('dialog');
  dlg.className = 'dlg' + (wide ? ' wide' : '');
  dlg.innerHTML = `
    <form>
      <h2>${esc(title)}</h2>
      <div class="dlg-body">${body}</div>
      <p class="form-error" role="alert" hidden></p>
      <div class="dlg-foot">
        ${locked ? '' : `<button type="button" class="btn" data-close>${submit ? '返回' : '关闭'}</button>`}
        ${submit ? `<button type="submit" class="btn ${danger ? 'danger' : 'primary'}">${esc(submit)}</button>` : ''}
      </div>
    </form>`;
  document.body.appendChild(dlg);

  const form = dlg.querySelector('form');
  const err = dlg.querySelector('.form-error');
  const btn = dlg.querySelector('[type=submit]');
  let busy = false;

  // 关闭即移除;不只依赖 close 事件(部分环境下它不触发,关掉的对话框会残留在页面里)
  const nativeClose = dlg.close.bind(dlg);
  dlg.close = (v) => { nativeClose(v); dlg.remove(); };
  // locked:不能通过「返回」、Esc 或点背景关闭(如首次登录强制改密码)
  if (!locked) dlg.querySelector('[data-close]').onclick = () => dlg.close();
  dlg.addEventListener('close', () => dlg.remove());
  dlg.addEventListener('click', (e) => { if (e.target === dlg && !busy && !locked) dlg.close(); });
  dlg.addEventListener('cancel', (e) => { if (busy || locked) e.preventDefault(); });

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    if (busy || !submit) return;
    busy = true; err.hidden = true; btn.disabled = true;
    const label = btn.textContent;
    btn.textContent = '处理中…';
    try {
      await onSubmit(Object.fromEntries(new FormData(form)));
      dlg.close();
      if (success) toast(success);
      if (after) after();
    } catch (ex) {
      err.textContent = ex.message;
      err.hidden = false;
      btn.disabled = false;
      btn.textContent = label;
      busy = false;
    }
  });
  dlg.showModal();
  return dlg;
}

const svg = (d) => `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${d}</svg>`;
const ICON = {
  students: svg('<circle cx="9" cy="8" r="3.5"/><path d="M2.5 20a6.5 6.5 0 0 1 13 0"/><path d="M16 4.5a3.5 3.5 0 0 1 0 7M18.5 20a6.5 6.5 0 0 0-3-5.5"/>'),
  lessons: svg('<path d="M4 5.5A1.5 1.5 0 0 1 5.5 4H19v14H5.5A1.5 1.5 0 0 0 4 19.5z"/><path d="M4 19.5A1.5 1.5 0 0 0 5.5 21H19v-3"/><path d="M8 8h7M8 11.5h5"/>'),
  orders: svg('<rect x="4" y="3" width="16" height="18" rx="2"/><path d="M8 8h8M8 12h8M8 16h5"/>'),
  recharges: svg('<rect x="3" y="6" width="18" height="13" rx="2"/><path d="M3 10h18"/><path d="M16 14.5h2"/><path d="M7 3.5 12 6l5-2.5"/>'),
  balance: svg('<path d="M4 6h16M4 12h16M4 18h10"/><path d="M18 15v6M15 18h6"/>'),
  points: svg('<circle cx="12" cy="12" r="8.5"/><path d="m12 7.5 1.4 2.9 3.1.4-2.3 2.2.6 3.1L12 14.6 9.2 16.1l.6-3.1-2.3-2.2 3.1-.4z"/>'),
  schedule: svg('<rect x="3" y="4.5" width="18" height="16" rx="2"/><path d="M3 9.5h18M8 2.5v4M16 2.5v4"/><path d="M7.5 13.5h3M13.5 13.5h3M7.5 17h3"/>'),
  users: svg('<circle cx="12" cy="8" r="3.5"/><path d="M5 20a7 7 0 0 1 14 0"/><path d="M19 4.5l1.5 1.5L23 3.5"/>'),
  logs: svg('<path d="M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><path d="M14 3v6h6M8 13h8M8 17h5"/>'),
  logout: svg('<path d="M15 4h3a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-3"/><path d="M10 16l-4-4 4-4M6 12h10"/>'),
  key: svg('<circle cx="8" cy="15" r="4"/><path d="m11 12 9-9M17 6l3 3M14 9l2 2"/>'),
  search: svg('<circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/>'),
  refresh: svg('<path d="M20 11a8 8 0 1 0-2.3 5.7"/><path d="M20 4v7h-7"/>'),
  plus: svg('<path d="M12 5v14M5 12h14"/>'),
  logo: svg('<path d="M12 2 3 7v10l9 5 9-5V7z"/><path d="m3 7 9 5 9-5M12 12v10"/>'),
};

const NAV = [
  ['students', '学生', 'STU'],
  ['lessons', '课程', 'LSN'],
  ['orders', '订单', 'ORD'],
  ['recharges', '充值记录', 'RCG'],
  ['balance', '余额流水', 'BAL'],
  ['points', '积分记录', 'PTS'],
  ['schedule', '学生课表', 'SCH'],
  ['users', '用户管理', 'USR'],
  ['logs', '操作日志', 'LOG'],
];

/* 右上角时钟 */
function startClock() {
  const tick = () => {
    const d = new Date();
    const el = $('#clock');
    if (el) el.innerHTML = `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} <b>${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}</b>`;
  };
  tick();
  setInterval(tick, 1000);
}

/* 侧边栏的接口状态:online 为 true/false,ms 为本次加载耗时 */
function setLink(online, ms) {
  $('#link').innerHTML = `<span class="dot ${online ? 'on' : 'off'}"></span>${online ? 'ONLINE' : 'OFFLINE'}`;
  $('#latency').textContent = online ? `${ms} ms` : '—';
  const live = $('#live');
  if (live) live.innerHTML = `<span class="dot ${online ? 'on' : 'off'}"></span>${online ? 'LIVE' : 'NO SIGNAL'}`;
}

/*
 * 页面外框:侧边栏 + 顶部标题栏 + 时钟,inner 是标题栏下面的内容。列表页和自定义页面共用。
 * 必须在 requireLogin() 之后调用:菜单按当前用户的角色显示。
 */
function renderShell({ key, heading, subtitle }, inner) {
  const navItem = NAV.find(([k]) => k === key);
  const menus = NAV.filter(([k]) => ME && ME.menus.includes(k));
  $('#app').innerHTML = `
  <div class="shell">
    <aside class="side">
      <a class="brand" href="/${menus.length ? menus[0][0] : 'login'}.html">
        <span class="logo">${ICON.logo}</span>
        <span><b>课程管理</b><small>EDU·CONSOLE</small></span>
      </a>
      <div class="nav-group">
        <div class="nav-title">// MODULES</div>
        <nav class="nav" aria-label="功能菜单">
          ${menus.map(([k, label, en]) =>
            `<a href="${k}.html" title="${label}"${k === key ? ' aria-current="page"' : ''}>${ICON[k]}<span class="lbl">${label}</span><span class="en">${en}</span></a>`).join('')}
        </nav>
      </div>
      <div class="user-box">
        <span class="avatar">${esc((ME.displayName || ME.username).slice(0, 1))}</span>
        <span class="who"><b>${esc(ME.displayName)}</b><small>${esc(ME.username)} · ${esc(ME.roleName)}</small></span>
        <button type="button" class="icon-btn" id="btn-pw" title="修改密码" aria-label="修改密码">${ICON.key}</button>
        <button type="button" class="icon-btn" id="btn-logout" title="退出登录" aria-label="退出登录">${ICON.logout}</button>
      </div>
      <div class="side-foot">
        <div class="row">API <b id="link"><span class="dot"></span>…</b></div>
        <div class="row">LATENCY <b id="latency">—</b></div>
        <div class="row">NODE <b>${esc(location.host || 'local')}</b></div>
      </div>
    </aside>
    <main class="main"><div class="page-inner">
      <header class="top">
        <div>
          <p class="crumb">CONSOLE / <span>${navItem ? navItem[2] : ''}</span></p>
          <h1>${heading}</h1>
          <p class="sub">${subtitle}</p>
        </div>
        <div class="clock" id="clock"></div>
      </header>
      ${inner}
    </div></main>
  </div>`;
  startClock();
  $('#btn-pw').addEventListener('click', () => openChangePassword(false));
  $('#btn-logout').addEventListener('click', logout);
  if (ME.mustChangePassword) openChangePassword(true);
}

/**
 * cfg: {
 *   key, entity, heading?, title, subtitle, search, empty, emptyHint,
 *   endpoint, idOf(row), rowName(row, ctx),
 *   can: { create, update, remove }, canRemove?(row), removeNote?,
 *   fields: [{ name, label, type, required(true|false|'create'), only?('create'|'edit'), attrs, help, get(row), options(ctx), emptyHint }],
 *            type 为 'custom' 时: { render(value, mode) => html(含 name=字段名 的隐藏输入), mount?(box), set(box, value) }
 *   toBody(values, mode),
 *   actions?: [{ label, title?, danger, show(row), confirm(row, ctx), fields?, run(row, values), success(string | (row) => string) }
 *              或 { label, show?(row), href(row) }  跳转链接
 *              或 { label, show?(row), open(row, ctx, reload) }  自定义对话框;
 *              任一种都可加 menu: true,表示优先收进行内「更多」菜单],
 *   inlineOps?  操作列最多直接显示几个按钮(默认 2),其余进「更多」菜单,
 *   pageSize?  每页条数(默认 10),
 *   onCreate?(ctx, reload)  新增时用自定义对话框代替通用表单,
 *   filter?: { all, options(rows, ctx), match(row, value) },  地址栏 ?filter=值 可指定初始筛选
 *   columns: [{ title, cls?, cell(row, ctx) }],
 *   text(row, ctx),
 *   copy?: { label(row, ctx), adjust?(values, row) }  新增时可从已有记录复制,行内出现「复制」
 *   stats?(rows, ctx): [{ label, value, hint?, tone?('ok'|'warn'|'accent') }]  (rows 为空时也要能返回标签)
 *   load(): Promise<{ rows, ctx }>
 * }
 * can 和 actions 也可以写成函数 (me) => ...,按当前用户的权限决定显示哪些按钮。
 * 先检查登录和页面权限,通过后才渲染。
 */
function initListPage(cfg) {
  requireLogin(cfg.key).then((me) => startListPage(cfg, me), () => { /* 已跳转或已显示错误 */ });
}

function startListPage(cfg, me) {
  const can = Object.assign({ create: false, update: false, remove: false }, typeof cfg.can === 'function' ? cfg.can(me) : cfg.can);
  const actions = (typeof cfg.actions === 'function' ? cfg.actions(me) : cfg.actions) || [];
  const hasOps = can.update || can.remove || actions.length > 0;
  const state = { page: 1, keyword: '', filter: new URLSearchParams(location.search).get('filter') || '' };
  let rows = [], ctx = {}, seq = 0;

  const columns = cfg.columns.slice();
  if (hasOps) columns.push({ title: '操作', cls: 'ops', cell: (r) => opsHTML(r) });

  const statKeys = cfg.stats ? cfg.stats([], {}).map((s) => s.label) : [];

  renderShell({ key: cfg.key, heading: cfg.heading || cfg.entity + '管理', subtitle: cfg.subtitle }, `
      ${statKeys.length ? `<section class="stats" id="stats" aria-label="数据概览">
        ${statKeys.map((k) => `<div class="stat skeleton"><div class="k">${k}</div><div class="v">--</div><div class="h">&nbsp;</div></div>`).join('')}
      </section>` : ''}
      <section class="panel" aria-live="polite">
        <div class="panel-head">▍<b>${cfg.title}</b><span>DATA STREAM</span><span class="live" id="live"></span></div>
        <div class="toolbar">
          <label class="search">${ICON.search}<input type="search" id="q" placeholder="${cfg.search}" aria-label="关键词搜索"></label>
          <select id="filter" aria-label="筛选" hidden></select>
          <button class="btn" id="refresh" type="button">${ICON.refresh.replace('<svg', '<svg width="16" height="16"')}刷新</button>
          ${can.create ? `<button class="btn primary" id="add" type="button">${ICON.plus.replace('<svg', '<svg width="16" height="16"')}新增${cfg.entity}</button>` : ''}
        </div>
        <div class="table-wrap"><table id="table"></table></div>
        <div class="state" id="state" hidden></div>
        <div class="pager" id="pager" hidden>
          <span id="summary"></span>
          <span class="ctrl">
            <button class="btn" id="prev" type="button">上一页</button>
            <span id="pageno"></span>
            <button class="btn" id="next" type="button">下一页</button>
          </span>
        </div>
      </section>`);

  function renderStats() {
    if (!cfg.stats) return;
    $('#stats').innerHTML = cfg.stats(rows, ctx).map((s) =>
      `<div class="stat ${s.tone || ''}"><div class="k">${s.label}</div><div class="v">${esc(s.value)}</div><div class="h">${esc(s.hint || ' ')}</div></div>`).join('');
  }

  /* ---------- 列表渲染 ---------- */
  /*
   * 一行的全部操作按钮,顺序:自定义操作、复制、编辑、删除。
   * 返回 [{ html, menu }]:menu 为 true 的优先收进「更多」(action 上写 menu: true;删除默认收进去,避免误点)。
   */
  function opsList(r) {
    const id = esc(cfg.idOf(r));
    const b = [];
    actions.forEach((a, i) => {
      if (a.show && !a.show(r)) return;
      const html = a.href
        ? `<a class="act" href="${esc(a.href(r))}">${a.label}</a>`
        : `<button type="button" class="act${a.danger ? ' danger' : ''}" data-op="action" data-i="${i}" data-id="${id}">${a.label}</button>`;
      b.push({ html, menu: !!a.menu });
    });
    if (can.create && cfg.copy) b.push({ html: `<button type="button" class="act" data-op="copy" data-id="${id}">复制</button>`, menu: true });
    if (can.update) b.push({ html: `<button type="button" class="act" data-op="edit" data-id="${id}">编辑</button>`, menu: false });
    if (can.remove && (!cfg.canRemove || cfg.canRemove(r))) {
      b.push({ html: `<button type="button" class="act danger" data-op="delete" data-id="${id}">删除</button>`, menu: true });
    }
    return b;
  }

  /*
   * 操作列最多直接显示 inlineOps 个按钮(默认 2 个),其余收进「更多」菜单,避免一行太长出现横向滚动。
   * 只多出 1 个时直接显示,不值得为它开菜单。返回 [行内按钮, 菜单按钮]。
   */
  const inlineOps = cfg.inlineOps || 2;
  const pageSize = cfg.pageSize || PAGE_SIZE;
  function splitOps(r) {
    const all = opsList(r);
    if (all.length <= inlineOps + 1) return [all, []];
    const inline = all.filter((o) => !o.menu).slice(0, inlineOps);
    return [inline, all.filter((o) => !inline.includes(o))];
  }
  function opsHTML(r) {
    const [inline, more] = splitOps(r);
    return inline.map((o) => o.html).join('') + (more.length
      ? `<button type="button" class="act more" data-more="${esc(cfg.idOf(r))}" aria-haspopup="menu" aria-expanded="false">更多 ▾</button>`
      : '');
  }

  /* 「更多」弹出菜单:挂在 body 上、按按钮位置定位,不会被表格的滚动区域裁掉 */
  let menu = null;
  function closeMenu() {
    if (!menu) return;
    menu.btn.setAttribute('aria-expanded', 'false');
    menu.el.remove();
    menu = null;
  }
  function openMenu(btn) {
    const same = menu && menu.btn === btn;
    closeMenu();
    if (same) return;
    const row = rows.find((r) => String(cfg.idOf(r)) === btn.dataset.more);
    if (!row) return;
    const el = document.createElement('div');
    el.className = 'op-menu';
    el.setAttribute('role', 'menu');
    el.innerHTML = splitOps(row)[1].map((o) => o.html).join('');
    document.body.appendChild(el);
    const rect = btn.getBoundingClientRect();
    const w = el.offsetWidth, h = el.offsetHeight;
    // 默认在按钮下方右对齐;放不下就放到上方
    el.style.left = `${Math.max(8, Math.min(rect.right - w, innerWidth - w - 8))}px`;
    el.style.top = `${rect.bottom + 4 + h > innerHeight ? rect.top - h - 4 : rect.bottom + 4}px`;
    el.addEventListener('click', (e) => {
      const b = e.target.closest('button[data-op]');
      if (b) { closeMenu(); dispatch(b); }
      else if (e.target.closest('a')) closeMenu();
    });
    btn.setAttribute('aria-expanded', 'true');
    menu = { el, btn };
    const first = el.querySelector('button, a');
    if (first) first.focus();
  }
  document.addEventListener('click', (e) => { if (menu && !menu.el.contains(e.target) && e.target !== menu.btn) closeMenu(); });
  document.addEventListener('keydown', (e) => { if (e.key === 'Escape' && menu) { const b = menu.btn; closeMenu(); b.focus(); } });
  addEventListener('resize', closeMenu);
  addEventListener('scroll', closeMenu, true);

  function showState(kind, detail) {
    const box = $('#state');
    $('#table').innerHTML = '';
    $('#pager').hidden = true;
    box.hidden = false;
    if (kind === 'loading') {
      box.innerHTML = '<span class="loader"><i></i>LOADING…</span>';
    } else if (kind === 'error') {
      box.innerHTML = `<strong>加载失败</strong>${esc(detail)}${/无法连接/.test(detail) ? "<br>请确认后端已启动,并通过 Spring Boot 的地址打开本页。" : ""}
        <br><button class="btn" type="button" id="retry">重新加载</button>`;
      $('#retry').onclick = () => load();
    } else if (kind === 'empty') {
      box.innerHTML = `<strong>${cfg.empty}</strong>${cfg.emptyHint}`;
    } else if (kind === 'nomatch') {
      box.innerHTML = `<strong>没有符合条件的记录</strong>换个关键词,或清除筛选再试试。
        <br><button class="btn" type="button" id="clear">清除条件</button>`;
      $('#clear').onclick = () => {
        state.keyword = ''; state.filter = ''; state.page = 1;
        $('#q').value = '';
        render();
      };
    }
  }

  function render() {
    closeMenu();
    const sel = $('#filter');
    if (cfg.filter) {
      const opts = cfg.filter.options(rows, ctx);
      sel.innerHTML = `<option value="">${cfg.filter.all}</option>` +
        opts.map(([v, label]) => `<option value="${esc(v)}">${esc(label)}</option>`).join('');
      sel.value = opts.some(([v]) => v === state.filter) ? state.filter : '';
      state.filter = sel.value;
      sel.hidden = false;
    }

    if (rows.length === 0) return showState('empty');

    const kw = state.keyword.trim().toLowerCase();
    const list = rows.filter((r) =>
      (!state.filter || cfg.filter.match(r, state.filter)) &&
      (!kw || cfg.text(r, ctx).toLowerCase().includes(kw)));
    if (list.length === 0) return showState('nomatch');

    const pages = Math.max(1, Math.ceil(list.length / pageSize));
    state.page = Math.min(state.page, pages);
    const start = (state.page - 1) * pageSize;
    const pageRows = list.slice(start, start + pageSize);

    $('#state').hidden = true;
    $('#table').innerHTML =
      `<caption class="sr-only">${cfg.title}</caption>` +
      '<thead><tr>' + columns.map((c) => `<th scope="col" class="${c.cls === 'num' ? 'num' : ''}">${c.title}</th>`).join('') + '</tr></thead>' +
      '<tbody>' + pageRows.map((r) =>
        '<tr>' + columns.map((c) => `<td class="${c.cls || ''}" data-label="${esc(c.title.replace(/<[^>]*>/g, ''))}">${c.cell(r, ctx)}</td>`).join('') + '</tr>').join('') + '</tbody>';

    $('#pager').hidden = false;
    $('#summary').textContent = `共 ${list.length} 条` + (list.length !== rows.length ? `(全部 ${rows.length} 条)` : '');
    $('#pageno').textContent = `第 ${state.page} / ${pages} 页`;
    $('#prev').disabled = state.page <= 1;
    $('#next').disabled = state.page >= pages;
  }

  /* silent 为 true 时保留当前表格,数据到达后再刷新(增删改之后使用) */
  async function load(silent) {
    const my = ++seq;
    // 首次登录还没改初始密码:不请求数据(后端也会拒绝),改完密码页面会自动刷新
    if (ME.mustChangePassword) { showState('error', '请先修改初始密码,修改后即可使用'); return; }
    if (!silent) showState('loading');
    const t0 = performance.now();
    try {
      const result = await cfg.load();
      if (my !== seq) return;
      rows = result.rows;
      ctx = result.ctx || {};
      setLink(true, Math.round(performance.now() - t0));
      renderStats();
      render();
    } catch (e) {
      if (my !== seq) return;
      setLink(false);
      showState('error', e.message);
    }
  }
  const reload = () => load(true);

  /* ---------- 新增 / 编辑 ---------- */
  function fieldHTML(f, mode, values) {
    const id = 'f_' + f.name;
    const req = f.required === true || (f.required === 'create' && mode === 'create');
    const v = values[f.name] ?? '';
    let help = typeof f.help === 'function' ? f.help(mode) : (f.help || '');
    const label = `<label for="${id}">${f.label}${req ? '' : '<span class="opt">(选填)</span>'}</label>`;
    let input;
    if (f.type === 'custom') {
      // 自定义控件:render 返回的 HTML 里要有一个 name=f.name 的(隐藏)输入框承载提交值
      return `<div class="field" data-field="${f.name}"><label>${f.label}</label>${f.render(v, mode)}${help ? `<span class="help">${esc(help)}</span>` : ''}</div>`;
    } else if (f.type === 'textarea') {
      input = `<textarea id="${id}" name="${f.name}" ${req ? 'required' : ''} ${f.attrs || ''}>${esc(v)}</textarea>`;
    } else if (f.type === 'select') {
      const opts = f.options(ctx);
      if (opts.length === 0) help = f.emptyHint || '暂无可选项';
      input = `<select id="${id}" name="${f.name}" ${req ? 'required' : ''}>
        <option value="">请选择</option>` +
        opts.map(([val, text, disabled]) =>
          `<option value="${esc(val)}"${disabled ? ' disabled' : ''}${String(val) === String(v) ? ' selected' : ''}>${esc(text)}</option>`).join('') +
        '</select>';
    } else {
      input = `<input id="${id}" name="${f.name}" type="${f.type || 'text'}" value="${esc(v)}" ${req ? 'required' : ''} ${f.attrs || ''}>`;
    }
    return `<div class="field">${label}${input}${help ? `<span class="help">${esc(help)}</span>` : ''}</div>`;
  }

  /* 从一条记录取出表单初值;copy 为 true 时是"复制为新记录",交给 cfg.copy.adjust 调整(如标题加"副本") */
  function valuesOf(row, copy) {
    const values = {};
    cfg.fields.forEach((f) => { values[f.name] = f.get ? f.get(row) : row[f.name]; });
    if (copy && cfg.copy && cfg.copy.adjust) cfg.copy.adjust(values, row);
    return values;
  }

  /* mode 为 'create' 时可传 source:以该记录为模板预填表单 */
  function openForm(mode, row, source) {
    const values = row ? valuesOf(row) : source ? valuesOf(source, true) : {};
    const fields = cfg.fields.filter((f) => !f.only || f.only === mode);
    // 新增时提供"从已有记录复制"下拉框;它没有 name,不会随表单提交
    const copyBox = mode === 'create' && cfg.copy && rows.length > 0
      ? `<div class="field copy-from">
          <label for="copy_src">从已有${cfg.entity}复制<span class="opt">(选填)</span></label>
          <select id="copy_src">
            <option value="">不复制,从空白开始</option>
            ${rows.map((r) => `<option value="${esc(cfg.idOf(r))}"${source && cfg.idOf(r) === cfg.idOf(source) ? ' selected' : ''}>${esc(cfg.copy.label(r, ctx))}</option>`).join('')}
          </select>
          <span class="help">选择后自动填入下方内容,可继续修改</span>
        </div>`
      : '';
    const dlg = openDialog({
      title: (mode === 'create' ? '新增' : '编辑') + cfg.entity,
      body: copyBox + fields.map((f) => fieldHTML(f, mode, values)).join(''),
      submit: mode === 'create' ? '添加' : '保存',
      success: mode === 'create' ? `已添加${cfg.entity}` : `已保存${cfg.entity}`,
      onSubmit: async (data) => {
        const body = cfg.toBody(data, mode);
        if (mode === 'create') await api('POST', cfg.endpoint, body);
        else await api('PUT', `${cfg.endpoint}/${cfg.idOf(row)}`, body);
      },
      after: reload,
    });

    const box = (f) => dlg.querySelector(`[data-field="${f.name}"]`);
    fields.forEach((f) => { if (f.type === 'custom' && f.mount) f.mount(box(f)); });

    const src = dlg.querySelector('#copy_src');
    if (src) {
      src.addEventListener('change', () => {
        const from = rows.find((r) => String(cfg.idOf(r)) === src.value);
        const v = from ? valuesOf(from, true) : {};
        const form = dlg.querySelector('form');
        fields.forEach((f) => {
          if (f.type === 'custom') f.set(box(f), v[f.name] ?? '');
          else form.elements[f.name].value = v[f.name] ?? '';
        });
      });
    }
  }

  /* ---------- 删除与自定义操作(都先确认) ---------- */
  function confirmDelete(row) {
    const note = cfg.removeNote ? `<p class="note">${esc(cfg.removeNote)}</p>` : '';
    openDialog({
      title: `删除${cfg.entity}`,
      body: `<p>确定删除「${esc(cfg.rowName(row, ctx))}」吗?此操作无法撤销。</p>${note}`,
      submit: '删除',
      danger: true,
      success: `已删除${cfg.entity}`,
      onSubmit: () => api('DELETE', `${cfg.endpoint}/${cfg.idOf(row)}`),
      after: reload,
    });
  }

  function runAction(a, row) {
    if (a.open) return a.open(row, ctx, reload); // 自定义对话框(如订单明细),自己负责界面
    const fields = (a.fields || []).map((f) => fieldHTML(f, 'action', {})).join('');
    openDialog({
      title: a.title || `${a.label}${cfg.entity}`,
      body: `<p>${esc(a.confirm(row, ctx))}</p>${fields}`,
      submit: a.label,
      danger: !!a.danger,
      success: typeof a.success === 'function' ? a.success(row) : a.success,
      onSubmit: (data) => a.run(row, data),
      after: reload,
    });
  }

  /* ---------- 事件 ---------- */
  $('#q').addEventListener('input', (e) => { state.keyword = e.target.value; state.page = 1; render(); });
  $('#filter').addEventListener('change', (e) => { state.filter = e.target.value; state.page = 1; render(); });
  $('#refresh').addEventListener('click', () => load());
  $('#prev').addEventListener('click', () => { state.page--; render(); });
  $('#next').addEventListener('click', () => { state.page++; render(); });
  // cfg.onCreate:新增用自定义对话框(如下单选课次),不走通用表单
  if (can.create) $('#add').addEventListener('click', () => (cfg.onCreate ? cfg.onCreate(ctx, reload) : openForm('create')));

  $('#table').addEventListener('click', (e) => {
    const more = e.target.closest('button[data-more]');
    if (more) { openMenu(more); return; }
    const b = e.target.closest('button[data-op]');
    if (b) dispatch(b);
  });

  /* 行内按钮和「更多」菜单里的按钮共用 */
  function dispatch(b) {
    const row = rows.find((r) => String(cfg.idOf(r)) === b.dataset.id);
    if (!row) return;
    if (b.dataset.op === 'edit') openForm('edit', row);
    else if (b.dataset.op === 'copy') openForm('create', null, row);
    else if (b.dataset.op === 'delete') confirmDelete(row);
    else if (b.dataset.op === 'action') runAction(actions[Number(b.dataset.i)], row);
  }

  load();
}
