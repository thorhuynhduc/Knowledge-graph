-- ĐÀO SÂU Vue (đợt 5b): Props/Emit/v-model, Slots, Directives, SFC
UPDATE kg_nodes SET
description=
'Giao tiếp cha-con: props đi XUỐNG (cha -> con), emit đi LÊN (con báo cha).
Dữ liệu MỘT CHIỀU: con KHÔNG sửa trực tiếp prop.

CON nhận props, phát event:
  <script setup>
  const props = defineProps({ modelValue: String });
  const emit  = defineEmits(["update:modelValue"]);
  function onInput(e) { emit("update:modelValue", e.target.value); }
  </script>

  ✗ props.modelValue = "x";   // SAI: sửa prop trực tiếp -> cảnh báo, đứt luồng
  ✓ emit lên cha để cha đổi state -> chảy lại xuống qua prop

v-model = ĐƯỜNG TẮT của (prop modelValue + event update:modelValue):
  <Child v-model="text" />
  <!-- tương đương: -->
  <Child :modelValue="text" @update:modelValue="text = $event" />

NHIỀU v-model (Vue 3):
  <Child v-model:title="t" v-model:body="b" />

GIẢI THÍCH TỪNG BƯỚC:
  1. Cha truyền dữ liệu xuống qua prop.
  2. Con muốn đổi -> EMIT event, KHÔNG tự sửa prop (one-way data flow).
  3. Cha nghe event -> cập nhật state -> prop mới chảy xuống.
  4. v-model chỉ là cú pháp gọn cho cặp prop + event đó.

Vì sao một chiều: nguồn sự thật nằm ở CHA -> dễ lần luồng dữ liệu, tránh
hai bên cùng sửa gây khó gỡ lỗi.'
,description_en=
'Parent-child communication: props go DOWN (parent -> child), emit goes UP
(child notifies parent). Data is ONE-WAY: the child does NOT mutate a prop
directly.

CHILD receives props, emits events:
  <script setup>
  const props = defineProps({ modelValue: String });
  const emit  = defineEmits(["update:modelValue"]);
  function onInput(e) { emit("update:modelValue", e.target.value); }
  </script>

  ✗ props.modelValue = "x";   // WRONG: mutating a prop -> warning, broken flow
  ✓ emit to the parent so it changes state -> flows back down via the prop

v-model = SHORTHAND for (a modelValue prop + an update:modelValue event):
  <Child v-model="text" />
  <!-- equivalent to: -->
  <Child :modelValue="text" @update:modelValue="text = $event" />

MULTIPLE v-model (Vue 3):
  <Child v-model:title="t" v-model:body="b" />

STEP BY STEP:
  1. The parent passes data down via a prop.
  2. To change it, the child EMITS an event, it does NOT mutate the prop
     (one-way data flow).
  3. The parent listens -> updates state -> the new prop flows down.
  4. v-model is just concise syntax for that prop + event pair.

Why one-way: the source of truth lives in the PARENT -> easy to trace data
flow and avoid both sides mutating (which is hard to debug).'
WHERE id='n_vue_props_emit';

UPDATE kg_nodes SET
description=
'Slot = chỗ trống để CHA nhét nội dung vào CON -> component bao bọc linh
hoạt (giống children của React).

DEFAULT SLOT:
  <!-- Card.vue -->
  <div class="card"><slot /></div>
  <!-- dùng -->
  <Card><p>Nội dung tùy ý</p></Card>   <!-- <p> thế vào <slot/> -->

NAMED SLOTS (nhiều vùng):
  <!-- Layout.vue -->
  <header><slot name="header" /></header>
  <main><slot /></main>
  <!-- dùng -->
  <Layout>
    <template #header><h1>Tiêu đề</h1></template>
    <p>Thân trang</p>
  </Layout>

SCOPED SLOT (con TRUYỀN dữ liệu ngược ra cho cha render):
  <!-- List.vue -->
  <li v-for="it in items" :key="it.id"><slot :item="it" /></li>
  <!-- dùng: cha quyết định render mỗi item -->
  <List :items="users">
    <template #default="{ item }">{{ item.name }}</template>
  </List>

GIẢI THÍCH: slot đảo quyền render — CON định nghĩa KHUNG, CHA cấp NỘI DUNG.
Scoped slot cho con "cho mượn" dữ liệu ra ngoài để cha tùy biến hiển thị
(bảng, danh sách tái dùng, component headless).'
,description_en=
'A slot = a placeholder where the PARENT injects content into the CHILD ->
flexible wrapper components (like React children).

DEFAULT SLOT:
  <!-- Card.vue -->
  <div class="card"><slot /></div>
  <!-- usage -->
  <Card><p>Any content</p></Card>   <!-- <p> replaces <slot/> -->

NAMED SLOTS (multiple regions):
  <!-- Layout.vue -->
  <header><slot name="header" /></header>
  <main><slot /></main>
  <!-- usage -->
  <Layout>
    <template #header><h1>Title</h1></template>
    <p>Page body</p>
  </Layout>

SCOPED SLOT (the child PASSES data back out for the parent to render):
  <!-- List.vue -->
  <li v-for="it in items" :key="it.id"><slot :item="it" /></li>
  <!-- usage: the parent decides how to render each item -->
  <List :items="users">
    <template #default="{ item }">{{ item.name }}</template>
  </List>

EXPLANATION: slots invert render control - the CHILD defines the FRAME, the
PARENT supplies the CONTENT. A scoped slot lets the child "lend" data out so
the parent can customize the display (tables, reusable lists, headless
components).'
WHERE id='n_vue_slots';

UPDATE kg_nodes SET
description=
'Directive = thuộc tính đặc biệt (tiền tố v-) gắn hành vi lên DOM.

CÁC DIRECTIVE LÕI:
  v-if / v-else : thêm/xóa element khỏi DOM theo điều kiện (tốn hơn khi
                  bật/tắt liên tục).
  v-show        : luôn render, chỉ đổi CSS display (rẻ khi bật/tắt nhiều).
  v-for         : lặp danh sách — LUÔN kèm :key ổn định:
      <li v-for="u in users" :key="u.id">{{ u.name }}</li>
  v-bind (:)    : bind thuộc tính -> :href="url"
  v-on   (@)    : nghe sự kiện   -> @click="save"
  v-model       : two-way binding cho input.

v-if vs v-show:
  ✗ v-show cho thứ hiếm khi hiện -> vẫn render sẵn (tốn tài nguyên).
  ✓ v-show khi bật/tắt LIÊN TỤC (tab, tooltip); v-if khi ít đổi / nặng.

  ✗ dùng CHUNG v-if và v-for trên một thẻ (ưu tiên nhập nhằng)
  ✓ tách: bọc v-if ở ngoài, hoặc lọc bằng computed trước khi v-for.

CUSTOM DIRECTIVE (khi cần thao tác DOM mức thấp):
  app.directive("focus", { mounted: (el) => el.focus() });
  <input v-focus />

GIẢI THÍCH: directive là cách Vue gắn logic KHAI BÁO lên DOM. Nhớ phân
biệt v-if (thêm/bớt node thật) vs v-show (ẩn bằng CSS) — câu hỏi phỏng vấn
rất hay gặp.'
,description_en=
'A directive = a special attribute (v- prefix) attaching behavior to the DOM.

CORE DIRECTIVES:
  v-if / v-else : add/remove an element from the DOM by condition (costlier
                  when toggled frequently).
  v-show        : always renders, only toggles CSS display (cheap for
                  frequent toggling).
  v-for         : loop a list - ALWAYS with a stable :key:
      <li v-for="u in users" :key="u.id">{{ u.name }}</li>
  v-bind (:)    : bind an attribute -> :href="url"
  v-on   (@)    : listen to an event -> @click="save"
  v-model       : two-way binding for inputs.

v-if vs v-show:
  ✗ v-show for something rarely shown -> still rendered upfront (wasteful).
  ✓ v-show for FREQUENT toggling (tabs, tooltips); v-if for rarely-changing
    / heavy content.

  ✗ combining v-if and v-for on one tag (ambiguous precedence)
  ✓ split them: wrap v-if outside, or filter with a computed before v-for.

CUSTOM DIRECTIVE (for low-level DOM work):
  app.directive("focus", { mounted: (el) => el.focus() });
  <input v-focus />

EXPLANATION: directives are how Vue attaches DECLARATIVE logic to the DOM.
Remember the difference between v-if (adds/removes real nodes) and v-show
(hides via CSS) - a very common interview question.'
WHERE id='n_vue_directives';

UPDATE kg_nodes SET
description=
'Single File Component (.vue) gói 3 phần của MỘT component vào 1 file:
template (HTML) + script (logic) + style (CSS), đặt cạnh nhau.

  <template>
    <button @click="inc">{{ count }}</button>
  </template>

  <script setup>
  import { ref } from "vue";
  const count = ref(0);
  const inc = () => count.value++;
  </script>

  <style scoped>
  button { color: teal; }   /* scoped -> CHỈ áp cho component này */
  </style>

ĐIỂM QUAN TRỌNG:
  • <script setup> : cú pháp gọn của Composition API — biến/khai báo tự
    expose ra template, KHÔNG cần return.
  • <style scoped> : Vue thêm attribute băm (data-v-xxx) -> CSS không rò rỉ
    ra component khác.
  • Build: .vue được Vite/vue-loader biên dịch sang render function JS.

VÌ SAO TỐT: mọi thứ của một component nằm CÙNG chỗ -> dễ đọc, dễ di chuyển,
dễ xóa. CSS cô lập theo component -> tránh xung đột class toàn cục.

GIẢI THÍCH: SFC là đơn vị chuẩn của app Vue. Kết hợp <script setup> +
scoped style cho component gọn gàng, an toàn CSS, và tận dụng tối ưu lúc
build (biên dịch template thành render function).'
,description_en=
'A Single File Component (.vue) packs the 3 parts of ONE component into one
file: template (HTML) + script (logic) + style (CSS), side by side.

  <template>
    <button @click="inc">{{ count }}</button>
  </template>

  <script setup>
  import { ref } from "vue";
  const count = ref(0);
  const inc = () => count.value++;
  </script>

  <style scoped>
  button { color: teal; }   /* scoped -> applies ONLY to this component */
  </style>

KEY POINTS:
  • <script setup> : concise Composition API syntax - declarations auto-expose
    to the template, NO return needed.
  • <style scoped> : Vue adds a hashed attribute (data-v-xxx) -> CSS does not
    leak into other components.
  • Build: .vue is compiled by Vite/vue-loader into a JS render function.

WHY IT IS GOOD: everything for a component lives TOGETHER -> easy to read,
move, and delete. Component-scoped CSS -> avoids global class conflicts.

EXPLANATION: the SFC is the standard unit of a Vue app. Combining
<script setup> + scoped style gives tidy components, CSS safety, and
build-time optimization (compiling the template into a render function).'
WHERE id='n_vue_sfc';
