-- ĐÀO SÂU Vue (đợt 5c): Pinia, Perf, Vue vs React
UPDATE kg_nodes SET
description=
'Pinia = store quản lý state TOÀN CỤC chính thức của Vue (thay Vuex). Dùng
khi nhiều component xa nhau cần chia sẻ / đổi cùng một state.

ĐỊNH NGHĨA STORE:
  export const useCounter = defineStore("counter", () => {
    const count  = ref(0);                          // state
    const double = computed(() => count.value * 2); // getter
    function inc() { count.value++; }               // action
    return { count, double, inc };
  });

DÙNG trong component:
  const c = useCounter();
  c.inc();  c.count;  c.double;
  // muốn destructure mà giữ reactivity:
  const { count, double } = storeToRefs(c);   // state/getter -> giữ reactive
  const { inc } = c;                           // action lấy thẳng được

VÌ SAO PINIA (so Vuex cũ):
  • API gọn, KHÔNG mutations rườm rà; hợp Composition API + TypeScript.
  • Modular tự nhiên: mỗi store một file, tự tách nhỏ.
  • Devtools + hỗ trợ SSR sẵn.

KHI NÀO CẦN: state DÙNG CHUNG nhiều nơi (user đăng nhập, giỏ hàng, theme
phức tạp). State chỉ một nhánh dùng -> để cục bộ (ref/composable), đừng
nhồi hết vào store.

GIẢI THÍCH TỪNG BƯỚC:
  1. defineStore tạo một store singleton theo id.
  2. Component gọi useStore() -> nhận CÙNG một instance chia sẻ.
  3. storeToRefs giữ reactivity khi tách state ra biến rời.'
,description_en=
'Pinia = the official global state store for Vue (replacing Vuex). Use it
when many distant components must share / change the same state.

DEFINING A STORE:
  export const useCounter = defineStore("counter", () => {
    const count  = ref(0);                          // state
    const double = computed(() => count.value * 2); // getter
    function inc() { count.value++; }               // action
    return { count, double, inc };
  });

USING IT in a component:
  const c = useCounter();
  c.inc();  c.count;  c.double;
  // to destructure while keeping reactivity:
  const { count, double } = storeToRefs(c);   // state/getters -> stay reactive
  const { inc } = c;                           // actions can be taken directly

WHY PINIA (vs old Vuex):
  • Lean API, NO verbose mutations; fits Composition API + TypeScript.
  • Naturally modular: one store per file, split easily.
  • Devtools + SSR support out of the box.

WHEN NEEDED: state SHARED across many places (logged-in user, cart, complex
theme). State used by only one branch -> keep it local (ref/composable), do
not cram everything into the store.

STEP BY STEP:
  1. defineStore creates a singleton store by id.
  2. Components call useStore() -> get the SAME shared instance.
  3. storeToRefs preserves reactivity when extracting state into loose vars.'
WHERE id='n_vue_pinia';

UPDATE kg_nodes SET
description=
'Tối ưu Vue = giảm việc reactivity + render thừa. Thứ tự ưu tiên:

1) KEY ĐÚNG cho v-for (id ổn định) -> Vue tái dùng DOM đúng, patch tối
   thiểu (giống React keys):
   <li v-for="u in users" :key="u.id">

2) v-show vs v-if đúng chỗ: bật/tắt liên tục -> v-show; ít đổi/nặng -> v-if.

3) v-once / v-memo cho phần TĨNH hoặc ít đổi:
   <div v-once>...</div>            <!-- render 1 lần, không cập nhật nữa -->
   <div v-memo="[id]">...</div>     <!-- chỉ render lại khi id đổi -->

4) computed thay cho tính trong template (có cache) — đừng gọi hàm nặng
   trực tiếp trong {{ }} (chạy MỖI lần render).

5) Danh sách rất dài -> VIRTUAL SCROLL (vue-virtual-scroller): chỉ render
   phần đang thấy.

6) shallowRef / shallowReactive cho cấu trúc lớn KHÔNG cần reactivity sâu
   -> bớt chi phí theo dõi.

  ✗ {{ heavyCompute(item) }} trong template -> chạy lại mỗi render
  ✓ dùng computed hoặc tính sẵn khi dữ liệu đổi

GIẢI THÍCH: reactivity của Vue vốn đã giới hạn cập nhật ở nơi dùng dữ liệu,
nên tối ưu chủ yếu là: key đúng, tránh tính lặp trong template, cache bằng
computed, cắt render phần tĩnh/dài. Luôn ĐO bằng Vue Devtools trước khi tối ưu.'
,description_en=
'Optimizing Vue = reducing reactivity work + wasted renders. Priority order:

1) CORRECT KEY for v-for (stable id) -> Vue reuses the right DOM, minimal
   patching (like React keys):
   <li v-for="u in users" :key="u.id">

2) v-show vs v-if in the right place: frequent toggling -> v-show;
   rarely-changing/heavy -> v-if.

3) v-once / v-memo for STATIC or rarely-changing parts:
   <div v-once>...</div>            <!-- renders once, never updates again -->
   <div v-memo="[id]">...</div>     <!-- re-renders only when id changes -->

4) computed instead of computing in the template (cached) - do not call a
   heavy function directly in {{ }} (it runs on EVERY render).

5) Very long lists -> VIRTUAL SCROLL (vue-virtual-scroller): render only the
   visible portion.

6) shallowRef / shallowReactive for large structures that do NOT need deep
   reactivity -> less tracking cost.

  ✗ {{ heavyCompute(item) }} in the template -> re-runs every render
  ✓ use a computed or precompute when data changes

EXPLANATION: Vue reactivity already limits updates to where data is used, so
optimization is mainly: correct keys, avoiding repeated computation in
templates, caching via computed, and skipping renders for static/long parts.
Always MEASURE with Vue Devtools before optimizing.'
WHERE id='n_vue_perf';

UPDATE kg_nodes SET
description=
'Vue và React đều component-based + virtual DOM, khác ở CÁCH viết và CƠ CHẾ
reactivity.

  Khía cạnh        Vue                          React
  ──────────       ─────────────────────        ─────────────────────
  Template         HTML + directive (v-if,      JSX (JS thuần)
                   v-for) trong .vue
  Reactivity       TỰ ĐỘNG (Proxy track/        THỦ CÔNG (setState + so
                   trigger), ít render thừa     sánh; cần memo)
  Đổi state        gán trực tiếp: count.value++ bất biến: setCount(c=>c+1)
  Tái dùng logic   composable (useX)            custom hook (useX)
  Style            <style scoped> sẵn có         CSS-in-JS / module (ngoài)
  Đường học        thoải hơn cho người mới       linh hoạt, "JS-centric"

REACTIVITY — khác biệt cốt lõi:
  Vue:   const count = ref(0); count.value++;     // Vue tự biết ai phụ thuộc
         -> chỉ effect dùng count chạy lại, KHÔNG cần memo tay.
  React: const [c,setC]=useState(0); setC(c+1);   // render lại cả cây con
         -> phải React.memo/useMemo để chặn render thừa.

GIỐNG NHAU: component + props, dữ liệu một chiều xuống con, virtual DOM +
diff, hệ sinh thái router/store, SSR (Nuxt vs Next).

CHỌN THẾ NÀO: cả hai đều mạnh cho SPA lớn. Vue: template quen HTML,
reactivity tự động, ít boilerplate. React: hệ sinh thái + thị trường tuyển
dụng lớn hơn, JSX linh hoạt. Chọn theo team + hệ sinh thái, KHÔNG phải vì
hiệu năng (hai bên tương đương).'
,description_en=
'Vue and React are both component-based + virtual DOM, differing in how you
write them and their reactivity mechanism.

  Aspect           Vue                          React
  ──────────       ─────────────────────        ─────────────────────
  Template         HTML + directives (v-if,     JSX (plain JS)
                   v-for) in .vue
  Reactivity       AUTOMATIC (Proxy track/      MANUAL (setState +
                   trigger), fewer wasted       comparison; needs memo)
                   renders
  Changing state   direct: count.value++        immutable: setCount(c=>c+1)
  Logic reuse      composable (useX)            custom hook (useX)
  Style            <style scoped> built in      CSS-in-JS / modules (extra)
  Learning curve   gentler for beginners        flexible, "JS-centric"

REACTIVITY - the core difference:
  Vue:   const count = ref(0); count.value++;     // Vue knows who depends on it
         -> only effects using count re-run, NO manual memo needed.
  React: const [c,setC]=useState(0); setC(c+1);   // re-renders the whole subtree
         -> need React.memo/useMemo to stop wasted renders.

SIMILARITIES: components + props, one-way data flow to children, virtual
DOM + diff, router/store ecosystems, SSR (Nuxt vs Next).

HOW TO CHOOSE: both are strong for large SPAs. Vue: HTML-familiar templates,
automatic reactivity, less boilerplate. React: larger ecosystem + job
market, flexible JSX. Choose by team + ecosystem, NOT by performance (the
two are comparable).'
WHERE id='n_vue_vs_react';
