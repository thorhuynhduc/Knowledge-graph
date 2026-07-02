-- ĐÀO SÂU Vue (đợt 5a): Reactivity, computed/watch, Composition API, Lifecycle
UPDATE kg_nodes SET
description=
'Reactivity: Vue TỰ ĐỘNG cập nhật DOM khi dữ liệu đổi, nhờ theo dõi
(track) nơi dữ liệu được ĐỌC và kích hoạt (trigger) khi bị GHI.

ref vs reactive:
  const count = ref(0);        // bọc một GIÁ TRỊ (số, chuỗi, cả object)
  count.value++;               // trong JS phải dùng .value
  // template dùng thẳng {{ count }} (Vue tự bỏ .value)

  const state = reactive({ n: 0, user: { name: "An" } });
  state.n++;                   // KHÔNG cần .value; proxy sâu

CƠ CHẾ (Vue 3, dựa trên Proxy):
  reactive() bọc object bằng Proxy -> bẫy get để TRACK dependency, bẫy set
  để TRIGGER cập nhật. ref() dùng getter/setter trên .value.

BẪY THƯỜNG GẶP:
  ✗ mất reactivity khi destructure reactive:
     const { n } = reactive({ n: 0 });   // n thành số thường, KHÔNG reactive
  ✓ dùng toRefs: const { n } = toRefs(state);   // giữ liên kết reactive
  ✗ gán mới cả object reactive: state = {...}    // đứt Proxy
  ✓ đổi từng field, hoặc dùng ref rồi ref.value = {...}

GIẢI THÍCH TỪNG BƯỚC:
  1. Khi render đọc count.value / state.n -> Vue GHI NHỚ effect này phụ
     thuộc dữ liệu đó.
  2. Khi ghi -> Vue tìm các effect phụ thuộc -> chạy lại (cập nhật DOM).
  3. Vì theo dõi ở mức truy cập, chỉ phần THẬT SỰ dùng dữ liệu mới cập nhật.

DÙNG GÌ: ref cho giá trị đơn / đổi cả cụm; reactive cho object gom nhiều
field. Nhiều team dùng ref cho tất cả để nhất quán.'
,description_en=
'Reactivity: Vue AUTOMATICALLY updates the DOM when data changes, by
tracking where data is READ and triggering when it is WRITTEN.

ref vs reactive:
  const count = ref(0);        // wraps a VALUE (number, string, even object)
  count.value++;               // in JS you must use .value
  // the template uses {{ count }} directly (Vue unwraps .value)

  const state = reactive({ n: 0, user: { name: "An" } });
  state.n++;                   // no .value needed; deep proxy

MECHANISM (Vue 3, based on Proxy):
  reactive() wraps an object in a Proxy -> the get trap TRACKS dependencies,
  the set trap TRIGGERS updates. ref() uses a getter/setter on .value.

COMMON PITFALLS:
  ✗ losing reactivity when destructuring a reactive:
     const { n } = reactive({ n: 0 });   // n becomes a plain number, NOT reactive
  ✓ use toRefs: const { n } = toRefs(state);   // keeps the reactive link
  ✗ reassigning the whole reactive object: state = {...}   // breaks the Proxy
  ✓ change fields individually, or use a ref then ref.value = {...}

STEP BY STEP:
  1. When render reads count.value / state.n -> Vue RECORDS that this effect
     depends on that data.
  2. On a write -> Vue finds the dependent effects -> re-runs them (updates DOM).
  3. Because tracking is at access level, only the parts that actually use
     the data update.

WHAT TO USE: ref for a single value / whole-value swaps; reactive for an
object grouping many fields. Many teams use ref for everything for consistency.'
WHERE id='n_vue_reactivity';

UPDATE kg_nodes SET
description=
'computed: giá trị DẪN XUẤT, tự tính lại KHI phụ thuộc đổi, và ĐƯỢC CACHE.
watch: chạy SIDE EFFECT khi nguồn đổi.

computed (có cache — không tính lại nếu deps không đổi):
  const price = ref(100), qty = ref(2);
  const total = computed(() => price.value * qty.value);
  // total.value = 200; đọc nhiều lần KHÔNG tính lại tới khi price/qty đổi

watch (phản ứng có side effect: gọi API, lưu localStorage):
  watch(qty, (moi, cu) => {
    console.log(`qty: ${cu} -> ${moi}`);
    saveToServer(qty.value);
  });
  // watchEffect(() => ...) tự dò deps và chạy ngay lần đầu

KHI NÀO DÙNG GÌ:
  • Cần một GIÁ TRỊ tính từ state khác -> computed (khai báo, có cache).
  • Cần LÀM VIỆC khi state đổi (fetch, ghi log, thao tác ngoài) -> watch.

  ✗ dùng watch để gán một biến dẫn xuất -> nên là computed:
     watch(price, () => total.value = price.value * qty.value)  // thừa
  ✓ const total = computed(() => price.value * qty.value)

GIẢI THÍCH: computed như một "công thức" — Vue biết nó phụ thuộc gì, chỉ
tính lại đúng lúc và nhớ kết quả. watch là "khi X đổi thì làm Y". Ưu tiên
computed; chỉ dùng watch khi cần EFFECT thật sự.'
,description_en=
'computed: a DERIVED value that recomputes WHEN its dependencies change and
is CACHED. watch: runs a SIDE EFFECT when a source changes.

computed (cached - does not recompute if deps are unchanged):
  const price = ref(100), qty = ref(2);
  const total = computed(() => price.value * qty.value);
  // total.value = 200; reading it many times does NOT recompute until
  //   price/qty change

watch (reacts with a side effect: call an API, save to localStorage):
  watch(qty, (next, prev) => {
    console.log(`qty: ${prev} -> ${next}`);
    saveToServer(qty.value);
  });
  // watchEffect(() => ...) auto-detects deps and runs immediately once

WHICH TO USE:
  • Need a VALUE computed from other state -> computed (declarative, cached).
  • Need to DO WORK when state changes (fetch, log, external ops) -> watch.

  ✗ using watch to assign a derived variable -> it should be computed:
     watch(price, () => total.value = price.value * qty.value)  // redundant
  ✓ const total = computed(() => price.value * qty.value)

EXPLANATION: computed is like a "formula" - Vue knows its dependencies,
recomputes only when needed, and caches the result. watch is "when X
changes, do Y". Prefer computed; use watch only when you truly need an EFFECT.'
WHERE id='n_vue_computed';

UPDATE kg_nodes SET
description=
'Hai cách viết logic component trong Vue 3:

OPTIONS API (theo "loại" tùy chọn: data, methods, computed, watch...):
  export default {
    data() { return { count: 0 }; },
    computed: { double() { return this.count * 2; } },
    methods: { inc() { this.count++; } },
  }
  // logic của MỘT tính năng bị RẢI ra nhiều khối (data + methods + watch...)

COMPOSITION API (gom theo TÍNH NĂNG, dùng trong <script setup>):
  <script setup>
  import { ref, computed } from "vue";
  const count = ref(0);
  const double = computed(() => count.value * 2);
  function inc() { count.value++; }
  </script>
  // mọi thứ của một tính năng nằm CẠNH nhau -> dễ đọc, dễ tách

LỢI ÍCH COMPOSITION:
  • Tái dùng logic bằng COMPOSABLE (giống custom hook của React):
      function useCounter() {
        const count = ref(0);
        const inc = () => count.value++;
        return { count, inc };
      }
  • Gom logic theo tính năng (tính năng lớn không bị xé nhỏ).
  • Hợp TypeScript hơn (suy kiểu tốt, không phụ thuộc this).

KHI NÀO DÙNG: Composition cho app vừa/lớn, cần tái dùng logic. Options vẫn
ổn cho component nhỏ / người mới. Hai cách chạy trên CÙNG hệ reactivity.'
,description_en=
'Two ways to write component logic in Vue 3:

OPTIONS API (organized by option "type": data, methods, computed, watch...):
  export default {
    data() { return { count: 0 }; },
    computed: { double() { return this.count * 2; } },
    methods: { inc() { this.count++; } },
  }
  // logic for ONE feature gets SCATTERED across blocks (data + methods + watch)

COMPOSITION API (grouped by FEATURE, used in <script setup>):
  <script setup>
  import { ref, computed } from "vue";
  const count = ref(0);
  const double = computed(() => count.value * 2);
  function inc() { count.value++; }
  </script>
  // everything for a feature sits TOGETHER -> easier to read and extract

COMPOSITION BENEFITS:
  • Reuse logic via a COMPOSABLE (like a React custom hook):
      function useCounter() {
        const count = ref(0);
        const inc = () => count.value++;
        return { count, inc };
      }
  • Group logic by feature (a large feature is not torn apart).
  • Better with TypeScript (good inference, no reliance on this).

WHEN TO USE: Composition for medium/large apps needing logic reuse. Options
is still fine for small components / beginners. Both run on the SAME
reactivity system.'
WHERE id='n_vue_composition';

UPDATE kg_nodes SET
description=
'Lifecycle hooks = các mốc trong vòng đời component để chạy code đúng thời
điểm (setup DOM, fetch, dọn dẹp).

VÒNG ĐỜI (rút gọn):
  setup/created ─► onMounted ─► (cập nhật: onUpdated) ─► onUnmounted
     (chưa có DOM)   (DOM sẵn)                          (dọn dẹp)

COMPOSITION API (trong <script setup>):
  import { onMounted, onUnmounted } from "vue";
  onMounted(() => {
    // DOM đã có -> đo kích thước, khởi tạo chart, add listener
    window.addEventListener("resize", onResize);
  });
  onUnmounted(() => {
    window.removeEventListener("resize", onResize);  // DỌN để tránh rò rỉ
  });

TƯƠNG ĐƯƠNG OPTIONS API: mounted(), updated(), unmounted().

DÙNG ĐÚNG CHỖ:
  • onMounted   : việc CẦN DOM (thư viện DOM, focus input, fetch lần đầu).
  • onUnmounted : HỦY timer/listener/subscription -> tránh memory leak.
  • onUpdated   : hiếm khi cần; cẩn thận vòng lặp cập nhật vô hạn.

GIẢI THÍCH: setup chạy TRƯỚC khi có DOM (đừng chạm phần tử DOM ở đây). Cặp
onMounted/onUnmounted giống useEffect có cleanup của React — mở tài nguyên
khi vào, đóng khi rời.'
,description_en=
'Lifecycle hooks = milestones in a component life to run code at the right
moment (DOM setup, fetch, cleanup).

LIFECYCLE (condensed):
  setup/created ─► onMounted ─► (updates: onUpdated) ─► onUnmounted
     (no DOM yet)   (DOM ready)                        (cleanup)

COMPOSITION API (in <script setup>):
  import { onMounted, onUnmounted } from "vue";
  onMounted(() => {
    // the DOM exists -> measure sizes, init a chart, add a listener
    window.addEventListener("resize", onResize);
  });
  onUnmounted(() => {
    window.removeEventListener("resize", onResize);  // CLEAN to avoid leaks
  });

OPTIONS API EQUIVALENT: mounted(), updated(), unmounted().

USE THE RIGHT ONE:
  • onMounted   : work that NEEDS the DOM (DOM libs, focusing an input,
    initial fetch).
  • onUnmounted : CANCEL timers/listeners/subscriptions -> avoid memory leaks.
  • onUpdated   : rarely needed; beware infinite update loops.

EXPLANATION: setup runs BEFORE the DOM exists (do not touch DOM elements
here). The onMounted/onUnmounted pair is like React useEffect with cleanup -
open resources on entry, close on leave.'
WHERE id='n_vue_lifecycle';
