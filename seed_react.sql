-- ===================================================================
--  TOPIC: React Core (song ngữ VI + EN, ví dụ + sơ đồ)
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_react.sql
-- ===================================================================

INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_reactc','React Core','Frontend',
'Kiến thức chuyên sâu về React: Virtual DOM & cơ chế render, hooks, quản lý state & dữ liệu, hiệu năng và các mẫu tổ chức component. Bổ trợ cho topic React (Q&A phỏng vấn).',
'In-depth React: Virtual DOM & rendering, hooks, state & data management, performance, and component patterns. Complements the React interview Q&A topic.',
'[]',120,100),

('s_rc_1','Render & Virtual DOM','Frontend',
'Virtual DOM, reconciliation, khi nào component re-render, và vai trò của key.',
'Virtual DOM, reconciliation, when a component re-renders, and the role of keys.',
'[]',40,60),
('s_rc_2','Hooks','Frontend',
'useState, useEffect, useMemo/useCallback và quy tắc hooks + custom hook.',
'useState, useEffect, useMemo/useCallback, and the rules of hooks + custom hooks.',
'[]',220,60),
('s_rc_3','State & Data','Frontend',
'Chọn nơi lưu state, Context, và quản lý dữ liệu server.',
'Choosing where state lives, Context, and server data management.',
'[]',40,220),
('s_rc_4','Hiệu năng & Nâng cao','Frontend',
'Tối ưu re-render, Fiber & concurrent, và các mẫu tổ chức component.',
'Optimizing re-renders, Fiber & concurrent features, and component patterns.',
'[]',220,220),

-- ===== Section 1 =====
('n_rc_vdom','Virtual DOM & Reconciliation','Frontend',
'Virtual DOM (VDOM) là một cây object JS mô tả UI. Khi state đổi,
React tạo VDOM MỚI, SO SÁNH (diffing) với cây cũ, rồi chỉ cập nhật
đúng phần DOM thật thay đổi -> tránh thao tác DOM tốn kém.

SƠ ĐỒ:
  state/props đổi
    ▼
  render() -> VDOM mới
    ▼
  reconciliation (so cây mới với cây cũ)
    ▼
  tính patch tối thiểu -> cập nhật DOM thật

Quy tắc diffing:
  • Cùng type element -> giữ node, chỉ cập nhật thuộc tính đổi.
  • Khác type -> hủy node cũ, tạo mới hoàn toàn.
  • Danh sách -> dùng "key" để nhận diện phần tử (xem node Keys).

Nhờ VDOM, ta viết UI khai báo theo state, React lo phần cập nhật DOM.',
'The Virtual DOM (VDOM) is a JS object tree describing the UI. When
state changes, React builds a NEW VDOM, DIFFS it against the old
tree, then updates only the real DOM parts that changed -> avoiding
expensive DOM operations.

DIAGRAM:
  state/props change
    ▼
  render() -> new VDOM
    ▼
  reconciliation (compare new tree with old)
    ▼
  compute the minimal patch -> update the real DOM

Diffing rules:
  • Same element type -> keep the node, update only changed props.
  • Different type -> destroy the old node, create a brand-new one.
  • Lists -> use a "key" to identify elements (see the Keys node).

Thanks to the VDOM, you write UI declaratively from state and React
handles the DOM updates.',
'[]',20,20),

('n_rc_render','Khi nào component re-render','Frontend',
'Một component re-render khi: state của nó đổi (useState/useReducer),
props đổi, hoặc COMPONENT CHA re-render.

Render chia 2 pha:
  • Render phase : gọi function component để tính VDOM. PHẢI thuần
    (không side effect), có thể bị React chạy lại/hủy.
  • Commit phase : áp thay đổi vào DOM thật, rồi chạy useEffect.

Điểm hay nhầm:
  • Cha render -> mọi con render theo, DÙ props không đổi — trừ khi
    bọc React.memo.
  • Re-render KHÁC cập nhật DOM: nếu VDOM không đổi thì DOM không bị
    chạm, nên re-render không phải lúc nào cũng đắt.

  setCount(c => c + 1);  // dùng dạng hàm khi phụ thuộc giá trị cũ
  // setState là bất đồng bộ + gộp (batching), state không đổi ngay',
'A component re-renders when: its own state changes (useState/
useReducer), its props change, or its PARENT re-renders.

Rendering has 2 phases:
  • Render phase : call the function component to compute the VDOM.
    It MUST be pure (no side effects); React may re-run/abort it.
  • Commit phase : apply changes to the real DOM, then run useEffect.

Common confusions:
  • A parent re-render -> all children re-render too, EVEN if props
    did not change - unless wrapped in React.memo.
  • Re-render is NOT the same as a DOM update: if the VDOM is
    unchanged the DOM is untouched, so a re-render is not always
    expensive.

  setCount(c => c + 1);  // use the function form when it depends on
                         // the previous value
  // setState is async + batched, so state does not change immediately',
'[]',100,20),

('n_rc_keys','Keys trong danh sách','Frontend',
'key giúp React nhận diện phần tử nào trong một danh sách đã được
thêm/xóa/đổi chỗ -> tái dùng đúng DOM node và state của mỗi item.

  {items.map(it => <Row key={it.id} data={it} />)}

Quy tắc:
  • Dùng id ỔN ĐỊNH & duy nhất làm key.
  • TRÁNH dùng index của mảng làm key khi danh sách có thể sắp xếp,
    chèn, hoặc xóa -> gây bug: state/DOM bị gán nhầm sang item khác.

Ví dụ lỗi kinh điển: dùng index -> xóa item đầu làm ô input của các
item còn lại hiển thị sai giá trị.

key chỉ cần duy nhất trong CÙNG một danh sách anh em, không cần
toàn cục.',
'A key lets React identify which element in a list was added,
removed, or reordered -> reusing the correct DOM node and state for
each item.

  {items.map(it => <Row key={it.id} data={it} />)}

Rules:
  • Use a STABLE, unique id as the key.
  • AVOID using the array index as the key when the list can be
    sorted, inserted into, or deleted from -> it causes bugs:
    state/DOM gets assigned to the wrong item.

A classic bug: using the index -> deleting the first item makes the
remaining items input fields show the wrong values.

A key only needs to be unique among SIBLINGS in the same list, not
globally.',
'[]',20,120),

-- ===== Section 2: Hooks =====
('n_rc_usestate','useState','Frontend',
'useState lưu state cục bộ trong một function component.

  const [count, setCount] = useState(0);
  setCount(count + 1);          // đặt giá trị
  setCount(c => c + 1);         // dạng HÀM: dùng khi phụ thuộc giá trị cũ

Điểm quan trọng:
  • setState là BẤT ĐỒNG BỘ và được GỘP (batching) trong một sự kiện
    -> state không cập nhật ngay dòng sau setState.
  • State là IMMUTABLE: tạo object/array MỚI thay vì mutate trực tiếp.
      setUser(u => ({ ...u, name: "A" }));   // đúng
      user.name = "A"; setUser(user);         // sai, React không thấy đổi
  • State khởi tạo nặng -> dùng dạng lazy: useState(() => compute()).',
'useState holds local state in a function component.

  const [count, setCount] = useState(0);
  setCount(count + 1);          // set a value
  setCount(c => c + 1);         // FUNCTION form: use when it depends on
                                // the previous value

Key points:
  • setState is ASYNCHRONOUS and BATCHED within an event -> state does
    not update on the line right after setState.
  • State is IMMUTABLE: create a NEW object/array instead of mutating.
      setUser(u => ({ ...u, name: "A" }));   // correct
      user.name = "A"; setUser(user);         // wrong, React sees no change
  • Expensive initial state -> use the lazy form: useState(() => compute()).',
'[]',200,20),

('n_rc_useeffect','useEffect','Frontend',
'useEffect chạy SIDE EFFECT sau khi render: gọi API, subscribe, timer,
thao tác DOM thủ công.

  useEffect(() => {
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);   // cleanup: khi unmount hoặc deps đổi
  }, [deps]);   // chạy lại khi deps đổi; [] = chỉ chạy 1 lần sau mount

Các bẫy phổ biến:
  • Thiếu dependency -> stale closure (đọc giá trị cũ).
  • deps là object/hàm tạo mới mỗi render -> effect chạy liên tục
    (ổn định bằng useMemo/useCallback).
  • Quên cleanup -> rò rỉ (timer, listener, subscription vẫn sống).

Xu hướng mới: KHÔNG dùng useEffect để đồng bộ dữ liệu server; hãy
dùng thư viện query (xem node Server data).',
'useEffect runs SIDE EFFECTS after render: API calls, subscriptions,
timers, manual DOM work.

  useEffect(() => {
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);   // cleanup: on unmount or when deps change
  }, [deps]);   // re-runs when deps change; [] = run once after mount

Common pitfalls:
  • Missing a dependency -> stale closure (reads old values).
  • deps that are objects/functions created each render -> the effect
    runs constantly (stabilize with useMemo/useCallback).
  • Forgetting cleanup -> leaks (timers, listeners, subscriptions stay
    alive).

Modern guidance: do NOT use useEffect to sync server data; use a
query library instead (see the Server data node).',
'[]',280,20),

('n_rc_usememo_cb','useMemo & useCallback','Frontend',
'useMemo nhớ (memoize) một GIÁ TRỊ tính toán; useCallback nhớ một
HÀM -> tránh tính lại / tạo tham chiếu mới mỗi lần render.

  const sorted  = useMemo(() => expensiveSort(list), [list]);
  const onClick = useCallback(() => doSomething(id), [id]);

KHI NÀO dùng (chỉ khi có lý do):
  • Tính toán thực sự nặng cần cache theo deps.
  • Truyền props xuống component con đã bọc React.memo (giữ tham
    chiếu ổn định để memo có tác dụng).

KHI NÀO KHÔNG:
  • Tính toán rẻ -> memo hóa còn tốn hơn (so sánh deps + bộ nhớ).
  • Bọc mọi thứ "cho chắc" -> code rối, không nhanh hơn.

Nguyên tắc: đo bằng Profiler trước, đừng tối ưu theo cảm giác.',
'useMemo memoizes a computed VALUE; useCallback memoizes a FUNCTION
-> avoiding recomputation / a new reference on every render.

  const sorted  = useMemo(() => expensiveSort(list), [list]);
  const onClick = useCallback(() => doSomething(id), [id]);

WHEN to use (only with a reason):
  • A genuinely heavy computation to cache by deps.
  • Passing props down to a child wrapped in React.memo (keep a
    stable reference so memo actually helps).

WHEN NOT:
  • Cheap computation -> memoizing costs more (comparing deps + memory).
  • Wrapping everything "just in case" -> messy code, no faster.

Principle: measure with the Profiler first; do not optimize by feel.',
'[]',200,120),

('n_rc_rules','Rules of Hooks & Custom Hooks','Frontend',
'Hai quy tắc bắt buộc của hooks:
  1. CHỈ gọi hook ở TOP LEVEL của component/custom hook — KHÔNG trong
     if / vòng lặp / hàm lồng. React dựa vào THỨ TỰ gọi hook giữa các
     lần render để khớp state.
  2. CHỈ gọi hook trong function component hoặc trong custom hook
     (tên bắt đầu bằng "use").

Custom hook = gom LOGIC tái dùng (state + effect) thành một hàm use:

  function useToggle(initial = false) {
    const [on, setOn] = useState(initial);
    const toggle = useCallback(() => setOn(v => !v), []);
    return [on, toggle];
  }
  const [open, toggleOpen] = useToggle();

Vi phạm quy tắc 1 (gọi hook có điều kiện) -> thứ tự hook lệch giữa
các render -> state gán nhầm, lỗi khó hiểu.',
'Two mandatory rules of hooks:
  1. ONLY call hooks at the TOP LEVEL of a component/custom hook - NOT
     inside if / loops / nested functions. React relies on the ORDER
     of hook calls across renders to match state.
  2. ONLY call hooks inside a function component or a custom hook
     (name starting with "use").

A custom hook = bundling reusable LOGIC (state + effects) into a use
function:

  function useToggle(initial = false) {
    const [on, setOn] = useState(initial);
    const toggle = useCallback(() => setOn(v => !v), []);
    return [on, toggle];
  }
  const [open, toggleOpen] = useToggle();

Violating rule 1 (calling hooks conditionally) -> the hook order
shifts between renders -> state is misassigned, causing confusing
bugs.',
'[]',280,120),

-- ===== Section 3: State & Data =====
('n_rc_state_mgmt','Chọn nơi lưu State','Frontend',
'Chọn nơi lưu state theo PHẠM VI dùng, từ gần tới xa:

  • Local (useState)   : state của một component.
  • Lift up + props    : chia sẻ giữa vài component gần nhau.
  • Context            : tránh prop-drilling (theme, user hiện tại) —
                         KHÔNG hợp state đổi liên tục (re-render rộng).
  • Thư viện toàn cục  : Redux Toolkit / Zustand / Jotai cho state
                         client phức tạp, nhiều nơi dùng.
  • Server state       : React Query / SWR cho dữ liệu từ server
                         (KHÁC client state — có cache, refetch, đồng
                         bộ; đừng nhét vào Redux).

Nguyên tắc: giữ state CÀNG GẦN nơi dùng càng tốt; chỉ nâng lên/toàn
cục khi thực sự cần chia sẻ. Tránh mặc định nhét mọi thứ vào Redux.',
'Choose where state lives by its SCOPE, from near to far:

  • Local (useState)   : state for one component.
  • Lift up + props    : shared among a few nearby components.
  • Context            : avoid prop-drilling (theme, current user) -
                         NOT for frequently changing state (wide re-render).
  • Global library     : Redux Toolkit / Zustand / Jotai for complex
                         client state used in many places.
  • Server state       : React Query / SWR for server data (DIFFERENT
                         from client state - has caching, refetch,
                         sync; do not stuff it into Redux).

Principle: keep state AS CLOSE as possible to where it is used; only
lift/globalize when sharing is truly needed. Avoid defaulting
everything into Redux.',
'[]',20,180),

('n_rc_context','Context API','Frontend',
'Context truyền dữ liệu xuyên cây component mà không cần prop-drilling.

  const ThemeCtx = createContext("light");
  <ThemeCtx.Provider value={theme}>
    <App />
  </ThemeCtx.Provider>
  // trong con:
  const theme = useContext(ThemeCtx);

CẢNH BÁO hiệu năng: MỌI consumer sẽ RE-RENDER khi value của provider
đổi. Vì vậy:
  • Đừng đặt state đổi liên tục vào một context lớn.
  • Tách context theo mối quan tâm (ThemeCtx, AuthCtx riêng).
  • Memo hóa value: value={useMemo(() => ({...}), [deps])}.

Lưu ý: Context CHỈ là cơ chế TRUYỀN dữ liệu, KHÔNG phải state manager
(không có tối ưu re-render như Redux/Zustand).',
'Context passes data through the component tree without prop-drilling.

  const ThemeCtx = createContext("light");
  <ThemeCtx.Provider value={theme}>
    <App />
  </ThemeCtx.Provider>
  // in a child:
  const theme = useContext(ThemeCtx);

Performance WARNING: EVERY consumer RE-RENDERS when the provider
value changes. Therefore:
  • Do not put frequently changing state into one large context.
  • Split contexts by concern (separate ThemeCtx, AuthCtx).
  • Memoize the value: value={useMemo(() => ({...}), [deps])}.

Note: Context is ONLY a mechanism to PASS data, NOT a state manager
(it has no re-render optimization like Redux/Zustand).',
'[]',100,180),

('n_rc_data','Quản lý dữ liệu server','Frontend',
'Dữ liệu từ server nên dùng thư viện chuyên (TanStack Query, SWR)
thay vì tự viết useEffect + fetch: chúng tự lo cache, khử trùng lặp
(dedupe), refetch, và trạng thái loading/error.

  const { data, isLoading, error } = useQuery({
    queryKey: ["user", id],
    queryFn: () => fetchUser(id),
  });

Vì sao KHÔNG dùng useEffect thủ công:
  • Dễ dính race condition (phản hồi cũ về sau ghi đè mới).
  • Lặp lại code loading/error/cache ở khắp nơi.
  • Không có cache dùng chung giữa các component.

Server state khác client state: nó là bản SAO của dữ liệu ở server
-> cần đồng bộ, hết hạn, refetch. React 18 + Suspense giúp khai báo
trạng thái tải gọn hơn.',
'Server data should use a dedicated library (TanStack Query, SWR)
instead of hand-written useEffect + fetch: they handle caching,
deduping, refetching, and loading/error states for you.

  const { data, isLoading, error } = useQuery({
    queryKey: ["user", id],
    queryFn: () => fetchUser(id),
  });

Why NOT hand-rolled useEffect:
  • Prone to race conditions (a stale response overwrites a newer one).
  • Repeated loading/error/cache code everywhere.
  • No shared cache across components.

Server state differs from client state: it is a COPY of data on the
server -> it needs sync, expiry, refetch. React 18 + Suspense makes
declaring loading states cleaner.',
'[]',20,240),

-- ===== Section 4: Performance & Advanced =====
('n_rc_perf','Tối ưu re-render','Frontend',
'Giảm render thừa:
  • React.memo(Component) : bỏ render con nếu props KHÔNG đổi (so nông).
  • useMemo / useCallback : giữ props/giá trị truyền xuống ổn định để
    React.memo có tác dụng.
  • Tách component        : cô lập phần hay đổi khỏi phần tĩnh.
  • Ảo hóa danh sách dài  : react-window / virtualization.

Nguyên nhân render thừa hay gặp:
  • Truyền object/hàm INLINE làm props "mới" mỗi lần render.
      <Child style={{color:"red"}} onClick={() => x()} />  // mới mỗi lần
  • Đặt state quá cao khiến cả nhánh lớn render lại.

Quy trình: dùng React DevTools Profiler tìm component render thừa
TRƯỚC, rồi mới tối ưu đúng chỗ. Đừng tối ưu sớm.',
'Reduce wasteful renders:
  • React.memo(Component) : skip a child render if props did NOT change
    (shallow compare).
  • useMemo / useCallback : keep passed-down props/values stable so
    React.memo actually helps.
  • Split components       : isolate the changing part from static parts.
  • Virtualize long lists  : react-window / virtualization.

Common causes of wasteful renders:
  • Passing INLINE objects/functions makes props "new" every render.
      <Child style={{color:"red"}} onClick={() => x()} />  // new each time
  • Placing state too high, re-rendering a large branch.

Process: use the React DevTools Profiler to find wasteful renders
FIRST, then optimize the right spot. Do not optimize prematurely.',
'[]',200,180),

('n_rc_fiber','Fiber & Concurrent Features','Frontend',
'Fiber là kiến trúc reconciler mới (từ React 16): chia công việc
render thành các đơn vị nhỏ có thể TẠM DỪNG, tiếp tục, hoặc bỏ theo
ưu tiên -> render không chặn luồng chính (concurrent).

React 18 mở ra các tính năng concurrent:
  • startTransition : đánh dấu cập nhật ÍT ưu tiên (vd lọc danh sách
    lớn) để giữ input mượt.
      startTransition(() => setQuery(text));
  • useDeferredValue : hoãn một giá trị nặng để UI phản hồi trước.
  • Automatic batching : gộp nhiều setState kể cả trong promise/timeout.

Mục tiêu: giữ ứng dụng PHẢN HỒI ngay cả khi có render nặng, bằng
cách ưu tiên tương tác của người dùng.',
'Fiber is the newer reconciler architecture (since React 16): it
splits render work into small units that can be PAUSED, resumed, or
dropped by priority -> non-blocking rendering (concurrent).

React 18 unlocks concurrent features:
  • startTransition : mark a LOW-priority update (e.g. filtering a big
    list) to keep input smooth.
      startTransition(() => setQuery(text));
  • useDeferredValue : defer a heavy value so the UI responds first.
  • Automatic batching : batch multiple setState even inside a
    promise/timeout.

Goal: keep the app RESPONSIVE even under heavy rendering, by
prioritizing user interactions.',
'[]',280,180),

('n_rc_patterns','Component Patterns','Frontend',
'Các mẫu tổ chức component trong React:

  • Composition (children/slots) : ghép component bằng props.children
    -> linh hoạt hơn kế thừa (React KHÔNG khuyến khích kế thừa).
      <Card><Avatar/><Info/></Card>
  • Custom hooks : tái dùng LOGIC có state (cách hiện đại thay cho HOC
    và render props).
  • HOC (Higher-Order Component) : hàm nhận component, trả component
    mới (vd withAuth(Page)) — nay ít dùng hơn hooks.
  • Render props : truyền một hàm render qua prop để chia sẻ logic.
  • Container / Presentational : tách component logic khỏi component
    hiển thị.

Xu hướng hiện đại: ưu tiên COMPOSITION + CUSTOM HOOKS; HOC/render
props chủ yếu còn trong code cũ hoặc thư viện.',
'Component patterns in React:

  • Composition (children/slots) : compose via props.children -> more
    flexible than inheritance (React does NOT favor inheritance).
      <Card><Avatar/><Info/></Card>
  • Custom hooks : reuse stateful LOGIC (the modern replacement for
    HOCs and render props).
  • HOC (Higher-Order Component) : a function taking a component and
    returning a new one (e.g. withAuth(Page)) - now used less than hooks.
  • Render props : pass a render function via a prop to share logic.
  • Container / Presentational : separate logic components from
    presentational ones.

Modern trend: prefer COMPOSITION + CUSTOM HOOKS; HOC/render props
mostly remain in legacy code or libraries.',
'[]',200,240)
ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);

-- ------------------------- EDGES -----------------------------------
INSERT INTO kg_edges (id,source,target,type) VALUES
('e_root_t_reactc_part-of','root','t_reactc','part-of'),
('e_t_reactc_t_react_related','t_reactc','t_react','related'),
('e_t_reactc_s_rc_1_part-of','t_reactc','s_rc_1','part-of'),
('e_t_reactc_s_rc_2_part-of','t_reactc','s_rc_2','part-of'),
('e_t_reactc_s_rc_3_part-of','t_reactc','s_rc_3','part-of'),
('e_t_reactc_s_rc_4_part-of','t_reactc','s_rc_4','part-of'),
('e_s_rc_1_n_rc_vdom','s_rc_1','n_rc_vdom','part-of'),
('e_s_rc_1_n_rc_render','s_rc_1','n_rc_render','part-of'),
('e_s_rc_1_n_rc_keys','s_rc_1','n_rc_keys','part-of'),
('e_s_rc_2_n_rc_usestate','s_rc_2','n_rc_usestate','part-of'),
('e_s_rc_2_n_rc_useeffect','s_rc_2','n_rc_useeffect','part-of'),
('e_s_rc_2_n_rc_usememo_cb','s_rc_2','n_rc_usememo_cb','part-of'),
('e_s_rc_2_n_rc_rules','s_rc_2','n_rc_rules','part-of'),
('e_s_rc_3_n_rc_state_mgmt','s_rc_3','n_rc_state_mgmt','part-of'),
('e_s_rc_3_n_rc_context','s_rc_3','n_rc_context','part-of'),
('e_s_rc_3_n_rc_data','s_rc_3','n_rc_data','part-of'),
('e_s_rc_4_n_rc_perf','s_rc_4','n_rc_perf','part-of'),
('e_s_rc_4_n_rc_fiber','s_rc_4','n_rc_fiber','part-of'),
('e_s_rc_4_n_rc_patterns','s_rc_4','n_rc_patterns','part-of'),
('e_n_rc_render_n_rc_perf_rel','n_rc_render','n_rc_perf','related'),
('e_n_rc_data_n_rc_useeffect_rel','n_rc_data','n_rc_useeffect','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
