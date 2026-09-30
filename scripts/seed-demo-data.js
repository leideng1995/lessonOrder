/*
 * 生成演示数据:50 个学生 + 10 门课程,通过后端接口创建(课次由后端按日期 × 节次自动生成)。
 *
 *   node scripts/seed-demo-data.js                     # 默认 http://localhost:8082/api
 *   API=http://localhost:18082/api node scripts/seed-demo-data.js
 *
 * 可重复执行:邮箱已存在的学生、标题已存在的课程会跳过。
 * 学生的初始余额通过「充值」接口写入,所以充值记录页也会有数据。
 * 随机数用固定种子,每次生成的内容相同。
 */
const API = process.env.API || 'http://localhost:8082/api';
const DEMO_PASSWORD = 'Demo@123456'; // 演示账号统一密码(仅用于本地测试数据)
const EMAIL_DOMAIN = 'demo.example.com';

/* ---------- 固定种子的随机数 ---------- */
let seed = 20261012;
const rand = () => ((seed = (seed * 1103515245 + 12345) % 2147483648) / 2147483648);
const pick = (arr) => arr[Math.floor(rand() * arr.length)];
const int = (min, max) => min + Math.floor(rand() * (max - min + 1));
const pad = (n) => String(n).padStart(2, '0');

async function call(method, path, body) {
  const r = await fetch(API + path, {
    method,
    headers: body ? { 'Content-Type': 'application/json' } : {},
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await r.text();
  const data = text ? JSON.parse(text) : null;
  if (!r.ok) throw new Error(`${method} ${path} -> ${r.status} ${data && data.message ? data.message : text}`);
  return data;
}

/* ---------- 50 个学生 ---------- */
const SURNAMES = ['王', '李', '张', '刘', '陈', '杨', '黄', '赵', '吴', '周', '徐', '孙', '马', '朱', '胡', '郭', '何', '林', '罗', '高', '梁', '郑', '谢', '宋', '唐', '许', '韩', '冯', '邓', '曹'];
const GIVEN = ['子涵', '欣怡', '梓萱', '浩然', '宇轩', '雨桐', '一诺', '思远', '若曦', '俊杰', '诗涵', '明轩', '可馨', '嘉怡', '皓轩',
  '语桐', '天佑', '梓睿', '欣妍', '博文', '晨曦', '子墨', '安琪', '泽宇', '雅琪', '奕辰', '佳怡', '宇航', '梦瑶', '俊熙',
  '思琪', '沐阳', '雨萱', '承泽', '芷若', '铭哲', '依依', '景行', '书瑶', '亦凡', '乐怡', '修远', '心悦', '瑞霖', '婉清',
  '昊天', '语嫣', '锦程', '星辰', '知夏'];
const BALANCES = [0, 200, 300, 500, 500, 800, 1000, 1000, 1500, 2000, 3000];

function buildStudents() {
  return GIVEN.map((given, i) => {
    const no = pad(i + 1);
    const year = int(2012, 2018), month = int(1, 12), day = int(1, 28);
    return {
      lastName: pick(SURNAMES),
      firstName: given,
      email: `student${no}@${EMAIL_DOMAIN}`,
      password: DEMO_PASSWORD,
      phone: `1${pick(['35', '36', '37', '38', '39', '50', '52', '58', '86', '88'])}${String(int(0, 99999999)).padStart(8, '0')}`,
      dateOfBirth: `${year}-${pad(month)}-${pad(day)}`,
      recharge: pick(BALANCES),
    };
  });
}

/* ---------- 10 门课程 ---------- */
// 「小学数学思维训练」和「围棋启蒙」上课时间在 10-12 ~ 10-21 部分重叠,用来演示下单时的时间冲突置灰
const LESSONS = [
  { title: '小学数学思维训练', category: '数学', price: 60, capacity: 20, startDate: '2026-10-12', endDate: '2026-10-23',
    periods: [['09:00', '10:00'], ['10:15', '11:15']], description: '通过趣味题型培养数感与逻辑推理,适合 2-4 年级。' },
  { title: '少儿英语口语', category: '英语', price: 80, capacity: 12, startDate: '2026-10-12', endDate: '2026-10-30',
    periods: [['14:00', '14:45'], ['15:00', '15:45']], description: '小班情景对话,外教与中教搭配授课。' },
  { title: 'Python 编程入门', category: '编程', price: 120, capacity: 15, startDate: '2026-10-19', endDate: '2026-10-30',
    periods: [['19:00', '20:30']], description: '从变量、循环到小游戏开发,适合 10 岁以上零基础学生。' },
  { title: 'Scratch 创意编程', category: '编程', price: 90, capacity: 15, startDate: '2026-10-12', endDate: '2026-10-18',
    periods: [['16:00', '17:00']], description: '积木式编程,完成动画与互动故事作品。' },
  { title: '语文阅读与写作', category: '语文', price: 70, capacity: 25, startDate: '2026-10-13', endDate: '2026-10-24',
    periods: [['08:30', '09:30']], description: '精读绘本与短篇,练习看图写话和记叙文。' },
  { title: '少儿素描', category: '美术', price: 75, capacity: 10, startDate: '2026-10-17', endDate: '2026-10-25',
    periods: [['13:30', '15:00']], description: '线条、明暗与静物写生基础。' },
  { title: '钢琴基础', category: '音乐', price: 150, capacity: 6, startDate: '2026-10-20', endDate: '2026-10-31',
    periods: [['17:00', '17:45'], ['18:00', '18:45']], description: '识谱、指法与简单曲目演奏,小班教学。' },
  { title: '围棋启蒙', category: '棋类', price: 65, capacity: 16, startDate: '2026-10-12', endDate: '2026-10-21',
    periods: [['10:00', '11:30']], description: '围棋规则、吃子与死活入门。' },
  { title: '小学科学实验', category: '科学', price: 85, capacity: 18, startDate: '2026-10-24', endDate: '2026-11-06',
    periods: [['09:30', '11:00']], description: '动手做实验,认识力、光、电与植物生长。' },
  { title: '奥数竞赛冲刺', category: '数学', price: 110, capacity: 20, startDate: '2026-11-02', endDate: '2026-11-13',
    periods: [['19:00', '20:00'], ['20:10', '21:10']], description: '面向竞赛的专题训练与真题讲解,适合 4-6 年级。' },
];

(async () => {
  console.log('API:', API);

  const existingEmails = new Set((await call('GET', '/students')).map((s) => s.email));
  let created = 0, skipped = 0, recharged = 0;
  for (const s of buildStudents()) {
    if (existingEmails.has(s.email)) { skipped++; continue; }
    const { recharge, ...body } = s;
    const st = await call('POST', '/students', body);
    created++;
    if (recharge > 0) {
      await call('POST', `/students/${st.studentId}/recharge`, { amount: recharge });
      recharged++;
    }
  }
  console.log(`学生:新建 ${created},跳过已存在 ${skipped},充值 ${recharged} 人`);

  const existingTitles = new Set((await call('GET', '/lessons')).map((l) => l.title));
  let lc = 0, ls = 0, sessions = 0;
  for (const l of LESSONS) {
    if (existingTitles.has(l.title)) { ls++; continue; }
    const res = await call('POST', '/lessons', {
      ...l,
      periods: l.periods.map(([startTime, endTime]) => ({ startTime, endTime })),
    });
    lc++;
    sessions += res.sessionCount;
    console.log(`  + ${res.title}  ${l.startDate} ~ ${l.endDate}  ${res.sessionCount} 节`);
  }
  console.log(`课程:新建 ${lc},跳过已存在 ${ls},共生成 ${sessions} 个课次`);
})().catch((e) => {
  console.error('失败:', e.message);
  process.exit(1);
});
