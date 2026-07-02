-- ===================================================================
--  TOPIC: Vue Core (song ngữ VI + EN, ví dụ + sơ đồ)
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_vue.sql
-- ===================================================================

INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_vue','Vue Core','Frontend',
'Kiến thức chuyên sâu về Vue 3: hệ reactivity (Proxy), computed/watch, vòng đời, Single File Component, Composition API, directive & slot, Pinia, hiệu năng và so sánh với React.',
'In-depth Vue 3: the reactivity system (Proxy), computed/watch, lifecycle, Single File Components, the Composition API, directives & slots, Pinia, performance, and a comparison with React.',
'[]',1800,100),

('s_vue_1','Reactivity','Frontend',
'Cơ chế theo dõi thay đổi (ref/reactive, Proxy), computed vs watch, và vòng đời.',
'The change-tracking mechanism (ref/reactive, Proxy), computed vs watch, and lifecycle.',
'[]',1720,60),
('s_vue_2','Component & Composition','Frontend',
'Single File Component, Composition API vs Options API, và props/emit + v-model.',
'Single File Components, Composition API vs Options API, and props/emit + v-model.',
'[]',1900,60),
('s_vue_3','Template & Directives','Frontend',
'Các directive (v-if/v-for/v-bind/v-on/v-model) và slots.',
'Directives (v-if/v-for/v-bind/v-on/v-model) and slots.',
'[]',1720,220),
('s_vue_4','State & Nâng cao','Frontend',
'Quản lý state với Pinia, tối ưu hiệu năng, và so sánh Vue vs React.',
'State management with Pinia, performance optimization, and Vue vs React.',
'[]',1900,220),

-- ===== Section 1: Reactivity =====
('n_vue_reactivity','Reactivity (ref & reactive)','Frontend',
'Vue 3 theo dõi thay đổi TỰ ĐỘNG nhờ reactivity dựa trên Proxy.

  import { ref, reactive } from "vue";
  const count = ref(0);                 // giá trị đơn -> dùng count.value
  const state = reactive({ items: [] }); // object/array -> dùng trực tiếp
  count.value++;         // Vue tự biết và cập nhật UI liên quan
  state.items.push(1);   // cũng phản ứng

SƠ ĐỒ track/trigger:
  đọc reactive trong render/computed  -> Vue TRACK (ghi nhớ phụ thuộc)
  ghi reactive                        -> Vue TRIGGER -> chạy lại đúng
                                         effect/render phụ thuộc nó

Khác React (phải gọi setState và so sánh VDOM), Vue biết CHÍNH XÁC
cái gì phụ thuộc cái gì -> cập nhật mịn, ít render thừa hơn.

Lưu ý: ref cần .value trong JS (template tự mở); reactive không dùng
được với kiểu nguyên thủy.',
'Vue 3 tracks changes AUTOMATICALLY via Proxy-based reactivity.

  import { ref, reactive } from "vue";
  const count = ref(0);                 // a single value -> use count.value
  const state = reactive({ items: [] }); // object/array -> use directly
  count.value++;         // Vue knows and updates the related UI
  state.items.push(1);   // also reactive

track/trigger DIAGRAM:
  reading reactive in render/computed  -> Vue TRACKS (records the dependency)
  writing reactive                     -> Vue TRIGGERS -> re-runs exactly
                                          the effects/renders that depend on it

Unlike React (which needs setState and VDOM diffing), Vue knows
EXACTLY what depends on what -> fine-grained updates with fewer
wasted renders.

Note: ref needs .value in JS (templates auto-unwrap); reactive does
not work with primitive types.',
'[]',1680,20),

('n_vue_computed','computed vs watch','Frontend',
'computed = giá trị DẪN XUẤT, tự CACHE theo phụ thuộc; watch = chạy
SIDE EFFECT khi nguồn đổi.

  const count = ref(1);
  const double = computed(() => count.value * 2);  // cache, chỉ tính
                                                    // lại khi count đổi
  watch(count, (newV, oldV) => {
    console.log("count đổi:", oldV, "->", newV);     // side effect
  });

Khi nào dùng gì:
  • computed : giá trị hiển thị dẫn xuất từ state (lọc, tính tổng,
    format). Có cache nên hiệu quả.
  • watch    : phản ứng thay đổi bằng hành động (gọi API khi từ khóa
    tìm kiếm đổi, ghi localStorage, điều hướng).

Sai lầm: dùng watch để tính một giá trị rồi gán vào ref khác — hãy
dùng computed (gọn, có cache, ít bug).',
'computed = a DERIVED value that CACHES by its dependencies; watch =
runs a SIDE EFFECT when a source changes.

  const count = ref(1);
  const double = computed(() => count.value * 2);  // cached, recomputes
                                                    // only when count changes
  watch(count, (newV, oldV) => {
    console.log("count changed:", oldV, "->", newV);  // side effect
  });

When to use which:
  • computed : a display value derived from state (filtering, totals,
    formatting). Cached, so efficient.
  • watch    : react to a change with an action (call an API when the
    search term changes, write localStorage, navigate).

Mistake: using watch to compute a value then assign it to another ref
- use computed instead (concise, cached, fewer bugs).',
'[]',1760,20),

('n_vue_lifecycle','Lifecycle hooks','Frontend',
'Vòng đời component (Composition API):

  import { onMounted, onUpdated, onUnmounted } from "vue";
  onMounted(()   => { /* DOM đã gắn -> gọi API, thao tác DOM */ });
  onUpdated(()   => { /* sau khi DOM cập nhật lại */ });
  onUnmounted(() => { /* dọn dẹp: clear timer, gỡ listener */ });

Ví dụ dọn dẹp đúng cách:
  const id = setInterval(tick, 1000);
  onUnmounted(() => clearInterval(id));   // tránh rò rỉ

Các mốc khác: onBeforeMount, onBeforeUpdate, onBeforeUnmount,
onErrorCaptured.

So với React: các hook này tương ứng vai trò của useEffect nhưng
TÁCH RÕ từng mốc vòng đời -> dễ đọc ý định hơn.',
'Component lifecycle (Composition API):

  import { onMounted, onUpdated, onUnmounted } from "vue";
  onMounted(()   => { /* DOM mounted -> call API, DOM work */ });
  onUpdated(()   => { /* after the DOM re-updates */ });
  onUnmounted(() => { /* cleanup: clear timers, remove listeners */ });

Proper cleanup example:
  const id = setInterval(tick, 1000);
  onUnmounted(() => clearInterval(id));   // avoid leaks

Other hooks: onBeforeMount, onBeforeUpdate, onBeforeUnmount,
onErrorCaptured.

Versus React: these hooks play the role of useEffect but are SPLIT
CLEARLY per lifecycle moment -> easier to read the intent.',
'[]',1680,120),

-- ===== Section 2: Component & Composition =====
('n_vue_sfc','Single File Component (.vue)','Frontend',
'Một component Vue gói gọn trong một file .vue gồm 3 khối:

  <template>
    <button @click="inc">{{ count }}</button>   <!-- HTML + directive -->
  </template>

  <script setup>
    import { ref } from "vue";
    const count = ref(0);
    const inc = () => count.value++;             // logic (Composition API)
  </script>

  <style scoped>
    button { color: teal; }                       /* CSS chỉ áp component này */
  </style>

  • scoped : CSS không rò ra ngoài (Vue thêm thuộc tính data riêng).
  • <script setup> : cú pháp GỌN nhất cho Composition API — biến/hàm
    khai báo tự động expose ra template.

SFC gom cấu trúc + logic + style của một component vào một chỗ.',
'A Vue component is packaged in one .vue file with 3 blocks:

  <template>
    <button @click="inc">{{ count }}</button>   <!-- HTML + directives -->
  </template>

  <script setup>
    import { ref } from "vue";
    const count = ref(0);
    const inc = () => count.value++;             // logic (Composition API)
  </script>

  <style scoped>
    button { color: teal; }                       /* CSS only for this component */
  </style>

  • scoped : CSS does not leak out (Vue adds a unique data attribute).
  • <script setup> : the most CONCISE syntax for the Composition API -
    declared variables/functions are auto-exposed to the template.

An SFC groups a component structure + logic + style in one place.',
'[]',1860,20),

('n_vue_composition','Composition API vs Options API','Frontend',
'Hai cách tổ chức logic component:

  • Options API : chia theo TÙY CHỌN (data, methods, computed, watch).
    Dễ cho người mới nhưng logic của MỘT tính năng bị rải ra nhiều
    khối khi component lớn.
  • Composition API (setup) : gom logic theo TÍNH NĂNG; tái dùng qua
    "composable" (tương đương custom hooks của React).

Composable tái dùng logic:
  // useCounter.js
  export function useCounter(start = 0) {
    const count = ref(start);
    const inc = () => count.value++;
    return { count, inc };
  }
  // trong component: const { count, inc } = useCounter();

Composition API hợp component lớn/logic tái dùng; Options API vẫn ổn
cho component nhỏ. Vue hỗ trợ cả hai.',
'Two ways to organize component logic:

  • Options API : split by OPTIONS (data, methods, computed, watch).
    Beginner-friendly but the logic of ONE feature scatters across
    several blocks as the component grows.
  • Composition API (setup) : group logic by FEATURE; reuse via a
    "composable" (equivalent to React custom hooks).

A composable for reusable logic:
  // useCounter.js
  export function useCounter(start = 0) {
    const count = ref(start);
    const inc = () => count.value++;
    return { count, inc };
  }
  // in a component: const { count, inc } = useCounter();

The Composition API suits large components/reusable logic; the
Options API is fine for small ones. Vue supports both.',
'[]',1940,20),

('n_vue_props_emit','Props, Emit & v-model','Frontend',
'Luồng dữ liệu một chiều: cha truyền xuống con qua PROPS, con báo lên
cha qua EMIT sự kiện.

  <!-- Child.vue -->
  <script setup>
    const props = defineProps(["title"]);
    const emit  = defineEmits(["save"]);
    function onClick() { emit("save", { id: 1 }); }
  </script>

  <!-- Parent -->
  <Child :title="t" @save="onSave" />

v-model = đường tắt cho cặp props + emit (two-way binding tiện):
  <input v-model="text" />
  <!-- tương đương -->
  <input :value="text" @input="text = $event.target.value" />

Component tự làm v-model qua prop modelValue + emit update:modelValue.
Không sửa trực tiếp prop trong con (one-way) — hãy emit để cha đổi.',
'One-way data flow: the parent passes down via PROPS, the child
reports up via EMIT events.

  <!-- Child.vue -->
  <script setup>
    const props = defineProps(["title"]);
    const emit  = defineEmits(["save"]);
    function onClick() { emit("save", { id: 1 }); }
  </script>

  <!-- Parent -->
  <Child :title="t" @save="onSave" />

v-model = shorthand for the props + emit pair (convenient two-way
binding):
  <input v-model="text" />
  <!-- equivalent to -->
  <input :value="text" @input="text = $event.target.value" />

A component implements v-model via a modelValue prop + an
update:modelValue emit. Do not mutate a prop directly in the child
(one-way) - emit so the parent changes it.',
'[]',1860,120),

-- ===== Section 3: Template & Directives =====
('n_vue_directives','Directives','Frontend',
'Directive là thuộc tính đặc biệt (bắt đầu v-) điều khiển DOM trong
template:

  v-if / v-else-if / v-else : GẮN/GỠ element theo điều kiện
  v-show                    : ẩn/hiện bằng CSS (element VẪN trong DOM)
  v-for                     : lặp danh sách (luôn kèm :key)
  v-bind  (viết tắt :)      : ràng buộc thuộc tính  :href="url"
  v-on    (viết tắt @)      : nghe sự kiện  @click="fn"
  v-model                   : two-way binding

  <ul>
    <li v-for="u in users" :key="u.id">{{ u.name }}</li>
  </ul>
  <p v-if="loading">Đang tải...</p>
  <button :disabled="busy" @click="submit">Gửi</button>

v-if (tốn hơn: gắn/gỡ + tạo lại) vs v-show (rẻ khi bật/tắt LIÊN TỤC
vì chỉ đổi CSS display). Đừng dùng v-if chung với v-for trên cùng
một thẻ.',
'Directives are special attributes (starting with v-) that control
the DOM in a template:

  v-if / v-else-if / v-else : ADD/REMOVE an element by condition
  v-show                    : hide/show via CSS (element STAYS in the DOM)
  v-for                     : loop a list (always with :key)
  v-bind  (shorthand :)     : bind an attribute  :href="url"
  v-on    (shorthand @)     : listen to an event  @click="fn"
  v-model                   : two-way binding

  <ul>
    <li v-for="u in users" :key="u.id">{{ u.name }}</li>
  </ul>
  <p v-if="loading">Loading...</p>
  <button :disabled="busy" @click="submit">Send</button>

v-if (more costly: add/remove + recreate) vs v-show (cheap when
toggling FREQUENTLY, since it only changes CSS display). Do not use
v-if together with v-for on the same tag.',
'[]',1680,180),

('n_vue_slots','Slots','Frontend',
'Slot cho phép component CHA chèn nội dung vào chỗ định sẵn trong
component con -> tạo component linh hoạt (tương tự children /
composition của React).

  <!-- Card.vue -->
  <div class="card">
    <slot name="header" />
    <div class="body"><slot /></div>   <!-- slot mặc định -->
  </div>

  <!-- sử dụng -->
  <Card>
    <template #header><h3>Tiêu đề</h3></template>
    <p>Nội dung thân card</p>
  </Card>

Scoped slot (con truyền dữ liệu RA cho cha render):
  <slot name="row" :item="item" />
  <!-- cha: <template #row="{ item }">{{ item.name }}</template> -->

Slot là nền để xây component tái dùng và bố cục linh hoạt.',
'Slots let the PARENT inject content into predefined places in the
child component -> flexible components (similar to React children /
composition).

  <!-- Card.vue -->
  <div class="card">
    <slot name="header" />
    <div class="body"><slot /></div>   <!-- default slot -->
  </div>

  <!-- usage -->
  <Card>
    <template #header><h3>Title</h3></template>
    <p>Card body content</p>
  </Card>

Scoped slot (the child passes data OUT for the parent to render):
  <slot name="row" :item="item" />
  <!-- parent: <template #row="{ item }">{{ item.name }}</template> -->

Slots are the basis for building reusable components and flexible
layouts.',
'[]',1760,180),

-- ===== Section 4: State & Advanced =====
('n_vue_pinia','Pinia (State Management)','Frontend',
'Pinia là thư viện quản lý state chính thức của Vue (thay Vuex cũ),
gọn và hỗ trợ TypeScript tốt.

  // stores/cart.js
  import { defineStore } from "pinia";
  export const useCart = defineStore("cart", {
    state:   () => ({ items: [] }),
    getters: { count: (s) => s.items.length },   // giống computed
    actions: { add(item) { this.items.push(item); } },
  });

  // trong component
  const cart = useCart();
  cart.add(product);
  console.log(cart.count);

Dùng cho state TOÀN CỤC chia sẻ nhiều nơi (giỏ hàng, user đăng nhập,
cấu hình). State CỤC BỘ của một component thì vẫn dùng ref/reactive.
Pinia store cũng reactive -> UI tự cập nhật khi state đổi.',
'Pinia is the official Vue state management library (replacing the
old Vuex), concise and with good TypeScript support.

  // stores/cart.js
  import { defineStore } from "pinia";
  export const useCart = defineStore("cart", {
    state:   () => ({ items: [] }),
    getters: { count: (s) => s.items.length },   // like computed
    actions: { add(item) { this.items.push(item); } },
  });

  // in a component
  const cart = useCart();
  cart.add(product);
  console.log(cart.count);

Use it for GLOBAL state shared across many places (cart, logged-in
user, config). LOCAL component state still uses ref/reactive. A
Pinia store is also reactive -> the UI updates automatically when
state changes.',
'[]',1860,180),

('n_vue_perf','Tối ưu hiệu năng','Frontend',
'Nhờ reactivity mịn, Vue thường ít render thừa, nhưng vẫn có kỹ thuật
tối ưu:

  • v-show thay v-if khi bật/tắt LIÊN TỤC (tránh gắn/gỡ tốn kém).
  • :key ĐÚNG và ổn định trong v-for.
  • computed (có cache) thay vì gọi method trong template (method
    chạy lại mỗi lần render).
  • v-once  : render một lần rồi bỏ qua (nội dung tĩnh).
  • v-memo  : bỏ qua cập nhật khi deps không đổi.
  • <KeepAlive> : giữ (cache) component khi chuyển qua lại, tránh dựng
    lại từ đầu.
  • Lazy load: defineAsyncComponent + tách route -> giảm bundle đầu.

Nguyên tắc chung giống React: đo trước (Vue DevTools), tránh tính
toán nặng trong template, giữ component nhỏ và rõ phụ thuộc.',
'Thanks to fine-grained reactivity, Vue usually has few wasted
renders, but optimization techniques still exist:

  • v-show instead of v-if when toggling FREQUENTLY (avoid costly
    add/remove).
  • Correct, stable :key in v-for.
  • computed (cached) instead of calling a method in the template (a
    method re-runs on every render).
  • v-once  : render once then skip (static content).
  • v-memo  : skip updates when deps are unchanged.
  • <KeepAlive> : keep (cache) a component when switching back and
    forth, avoiding a full rebuild.
  • Lazy load: defineAsyncComponent + route splitting -> smaller
    initial bundle.

The general principle matches React: measure first (Vue DevTools),
avoid heavy computation in templates, keep components small with
clear dependencies.',
'[]',1940,180),

('n_vue_vs_react','Vue vs React','Frontend',
'Cả hai đều component-based, dùng Virtual DOM, dữ liệu một chiều.

  Tiêu chí     | React                    | Vue 3
  -------------|--------------------------|--------------------------
  Reactivity   | thủ công (setState) +    | tự động (Proxy track/
               | so sánh VDOM             | trigger), mịn hơn
  View         | JSX (JavaScript thuần)   | template + directive (SFC)
  Tái dùng     | custom hooks             | composables
  State global | Redux/Zustand (ngoài)    | Pinia (chính thức)
  Học          | linh hoạt, tự lắp ghép   | quy ước rõ, dễ vào
  Hệ sinh thái | rất lớn nhất             | lớn, tích hợp sẵn nhiều

Điểm chung: component, VDOM, reactive UI, có hệ router/tooling.
Khác biệt lớn nhất: Vue theo dõi phụ thuộc TỰ ĐỘNG + dùng template;
React tường minh hơn với JSX + tự chọn thư viện.

Chọn theo đội và dự án; cả hai đều đủ mạnh cho hầu hết ứng dụng.',
'Both are component-based, use a Virtual DOM, and have one-way data
flow.

  Criteria     | React                    | Vue 3
  -------------|--------------------------|--------------------------
  Reactivity   | manual (setState) +      | automatic (Proxy track/
               | VDOM diffing             | trigger), finer-grained
  View         | JSX (plain JavaScript)   | template + directives (SFC)
  Reuse        | custom hooks             | composables
  Global state | Redux/Zustand (external) | Pinia (official)
  Learning     | flexible, assemble it    | clear conventions, easy start
  Ecosystem    | the largest              | large, more built-in

In common: components, VDOM, reactive UI, router/tooling.
Biggest difference: Vue tracks dependencies AUTOMATICALLY + uses
templates; React is more explicit with JSX + you pick libraries.

Choose by team and project; both are powerful enough for most apps.',
'[]',1860,240)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_vue_part-of','root','t_vue','part-of'),
('e_t_vue_s_vue_1_part-of','t_vue','s_vue_1','part-of'),
('e_t_vue_s_vue_2_part-of','t_vue','s_vue_2','part-of'),
('e_t_vue_s_vue_3_part-of','t_vue','s_vue_3','part-of'),
('e_t_vue_s_vue_4_part-of','t_vue','s_vue_4','part-of'),
('e_s_vue_1_n_vue_reactivity','s_vue_1','n_vue_reactivity','part-of'),
('e_s_vue_1_n_vue_computed','s_vue_1','n_vue_computed','part-of'),
('e_s_vue_1_n_vue_lifecycle','s_vue_1','n_vue_lifecycle','part-of'),
('e_s_vue_2_n_vue_sfc','s_vue_2','n_vue_sfc','part-of'),
('e_s_vue_2_n_vue_composition','s_vue_2','n_vue_composition','part-of'),
('e_s_vue_2_n_vue_props_emit','s_vue_2','n_vue_props_emit','part-of'),
('e_s_vue_3_n_vue_directives','s_vue_3','n_vue_directives','part-of'),
('e_s_vue_3_n_vue_slots','s_vue_3','n_vue_slots','part-of'),
('e_s_vue_4_n_vue_pinia','s_vue_4','n_vue_pinia','part-of'),
('e_s_vue_4_n_vue_perf','s_vue_4','n_vue_perf','part-of'),
('e_s_vue_4_n_vue_vs_react','s_vue_4','n_vue_vs_react','part-of'),
('e_n_vue_vs_react_t_reactc_related','n_vue_vs_react','t_reactc','related'),
('e_n_vue_composition_n_rc_rules_related','n_vue_composition','n_rc_rules','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
