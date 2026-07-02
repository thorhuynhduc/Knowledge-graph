-- ĐÀO SÂU React (đợt 4a): useState, useEffect, useMemo/useCallback, Rules of Hooks
UPDATE kg_nodes SET
description=
'useState thêm state cục bộ cho function component. Đổi state -> React
lên lịch re-render component đó.

  const [count, setCount] = useState(0);   // [giá trị, hàm cập nhật]

QUY TẮC QUAN TRỌNG:
1) State là BẤT BIẾN — tạo mới, đừng sửa tại chỗ:
  ✗ user.name = "An"; setUser(user);   // cùng reference -> React coi như
                                       //   KHÔNG đổi -> bỏ render
  ✓ setUser({ ...user, name: "An" });  // object MỚI -> re-render

2) Cập nhật theo BATCH + BẤT ĐỒNG BỘ. Nhiều setState trong 1 event gộp
   lại, render một lần. Đọc count ngay sau set vẫn là giá trị cũ:
  ✗ setCount(count + 1); setCount(count + 1);   // cùng count -> chỉ +1
  ✓ setCount(c => c + 1); setCount(c => c + 1); // updater -> +2 đúng

3) LAZY INIT cho khởi tạo tốn kém (chỉ chạy lần đầu):
  const [v] = useState(() => expensiveInit());  // truyền HÀM, không giá trị

GIẢI THÍCH TỪNG BƯỚC:
  1. setState báo React có state mới -> đưa component vào hàng render.
  2. React so sánh reference -> KHÁC mới render (nên cần object/array mới).
  3. Dùng dạng updater c => ... khi giá trị mới phụ thuộc giá trị cũ.'
,description_en=
'useState adds local state to a function component. Changing state ->
React schedules a re-render of that component.

  const [count, setCount] = useState(0);   // [value, updater function]

KEY RULES:
1) State is IMMUTABLE - create a new value, do not mutate in place:
  ✗ user.name = "An"; setUser(user);   // same reference -> React sees NO
                                       //   change -> skips the render
  ✓ setUser({ ...user, name: "An" });  // a NEW object -> re-renders

2) Updates are BATCHED + ASYNCHRONOUS. Multiple setState calls in one
   event are merged into one render. Reading count right after setting it
   still gives the old value:
  ✗ setCount(count + 1); setCount(count + 1);   // same count -> only +1
  ✓ setCount(c => c + 1); setCount(c => c + 1); // updater -> +2 correctly

3) LAZY INIT for expensive initialization (runs only on first render):
  const [v] = useState(() => expensiveInit());  // pass a FUNCTION, not a value

STEP BY STEP:
  1. setState tells React there is new state -> queues the component to render.
  2. React compares by reference -> renders only if DIFFERENT (hence a new
     object/array is needed).
  3. Use the updater form c => ... when the new value depends on the old one.'
WHERE id='n_rc_usestate';

UPDATE kg_nodes SET
description=
'useEffect chạy SIDE EFFECT (fetch, subscription, timer, thao tác DOM)
SAU khi render, để đồng bộ component với hệ thống bên ngoài.

  useEffect(() => {
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);  // CLEANUP: chạy trước lần sau + khi unmount
  }, []);                            // dependency array

DEPENDENCY ARRAY quyết định KHI NÀO chạy lại:
  useEffect(fn)             // MỖI lần render
  useEffect(fn, [])         // CHỈ 1 lần (mount)
  useEffect(fn, [userId])   // chạy lại khi userId đổi

LỖI THƯỜNG GẶP:
  ✗ thiếu dependency -> effect dùng giá trị CŨ (stale closure).
  ✗ fetch không kiểm soát race -> response cũ ghi đè response mới.
  ✓ có cleanup + cờ hủy:
     useEffect(() => {
       let alive = true;
       fetch(`/user/${id}`).then(r => r.json())
         .then(d => { if (alive) setUser(d); });
       return () => { alive = false; };   // hủy khi id đổi/unmount
     }, [id]);

GIẢI THÍCH: effect KHÔNG dành cho việc biến đổi dữ liệu lúc render (cái
đó tính trực tiếp trong thân component). Chỉ dùng khi cần đồng bộ với
BÊN NGOÀI React. Nhiều thứ trước hay nhét vào effect nay nên bỏ (React
docs: "You Might Not Need an Effect").'
,description_en=
'useEffect runs a SIDE EFFECT (fetch, subscription, timer, DOM work) AFTER
render, to synchronize the component with an external system.

  useEffect(() => {
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);  // CLEANUP: runs before next run + on unmount
  }, []);                            // dependency array

THE DEPENDENCY ARRAY decides WHEN it re-runs:
  useEffect(fn)             // on EVERY render
  useEffect(fn, [])         // ONCE (on mount)
  useEffect(fn, [userId])   // re-runs when userId changes

COMMON MISTAKES:
  ✗ missing a dependency -> the effect uses an OLD value (stale closure).
  ✗ an uncontrolled fetch race -> an old response overwrites a newer one.
  ✓ with cleanup + a cancel flag:
     useEffect(() => {
       let alive = true;
       fetch(`/user/${id}`).then(r => r.json())
         .then(d => { if (alive) setUser(d); });
       return () => { alive = false; };   // cancel when id changes/unmount
     }, [id]);

EXPLANATION: effects are NOT for transforming data during render (do that
directly in the component body). Use them only to sync with things
OUTSIDE React. Much of what people used to put in effects should now be
removed (React docs: "You Might Not Need an Effect").'
WHERE id='n_rc_useeffect';

UPDATE kg_nodes SET
description=
'useMemo và useCallback GHI NHỚ (memoize) để tránh tính lại / tạo lại
mỗi render — đây là TỐI ƯU, không phải mặc định.

useMemo — nhớ KẾT QUẢ một tính toán tốn kém:
  const sorted = useMemo(
    () => bigList.slice().sort(cmp),   // chỉ chạy lại khi bigList đổi
    [bigList]
  );

useCallback — nhớ chính HÀM (giữ nguyên reference giữa các render):
  const onClick = useCallback(() => doSomething(id), [id]);
  // useCallback(fn, dep) tương đương useMemo(() => fn, dep)

VÌ SAO CẦN: khi truyền hàm/object xuống con đã React.memo. Mỗi render
cha tạo hàm MỚI -> reference khác -> con vẫn render lại dù props giống.
useCallback giữ reference ổn định -> memo của con mới phát huy.

  ✗ <Child onClick={() => f()} />   // hàm mới mỗi render -> memo vô dụng
  ✓ const cb = useCallback(() => f(), []);
    <Child onClick={cb} />          // reference ổn định

CẢNH BÁO: memo có chi phí (lưu + so deps). Đừng bọc mọi thứ; chỉ dùng
khi (a) tính toán thật sự nặng, hoặc (b) cần reference ổn định cho con
đã memo. Lạm dụng làm code rối mà không nhanh hơn.'
,description_en=
'useMemo and useCallback MEMOIZE to avoid recomputing / recreating on every
render - this is an OPTIMIZATION, not the default.

useMemo - remembers the RESULT of an expensive computation:
  const sorted = useMemo(
    () => bigList.slice().sort(cmp),   // recomputes only when bigList changes
    [bigList]
  );

useCallback - remembers the FUNCTION itself (stable reference across renders):
  const onClick = useCallback(() => doSomething(id), [id]);
  // useCallback(fn, dep) is equivalent to useMemo(() => fn, dep)

WHY IT IS NEEDED: when passing a function/object to a React.memo child.
Each parent render creates a NEW function -> different reference -> the
child re-renders even with identical props. useCallback keeps the
reference stable -> the child memo actually works.

  ✗ <Child onClick={() => f()} />   // new function each render -> memo useless
  ✓ const cb = useCallback(() => f(), []);
    <Child onClick={cb} />          // stable reference

WARNING: memoization has a cost (storing + comparing deps). Do not wrap
everything; use it only when (a) the computation is genuinely heavy, or
(b) you need a stable reference for a memoized child. Overusing it clutters
the code without making it faster.'
WHERE id='n_rc_usememo_cb';

UPDATE kg_nodes SET
description=
'RULES OF HOOKS — 2 luật bắt buộc để React khớp đúng state với mỗi hook:

1) CHỈ gọi hook ở TOP LEVEL — không trong if/for/hàm lồng.
   React nhận diện hook theo THỨ TỰ GỌI; gọi có điều kiện -> lệch thứ tự.
  ✗ if (open) { const [x] = useState(0); }        // sai
  ✓ const [x] = useState(0); if (open) { ... }    // đúng

2) CHỈ gọi hook trong React function component hoặc custom hook (KHÔNG
   trong hàm thường, KHÔNG trong class).

CUSTOM HOOK — tách logic dùng state/effect ra hàm tái dùng (tên bắt đầu
bằng "use"):
  function useToggle(init = false) {
    const [on, setOn] = useState(init);
    const toggle = useCallback(() => setOn(o => !o), []);
    return [on, toggle];
  }
  // dùng: const [open, toggleOpen] = useToggle();

GIẢI THÍCH TỪNG BƯỚC:
  1. Mỗi lần render, các hook chạy theo ĐÚNG thứ tự -> React map state.
  2. Custom hook chỉ là hàm GỌI các hook khác -> gói logic, KHÔNG chia sẻ
     state giữa các component (mỗi component gọi có state RIÊNG).
  3. Đặt tên use* để linter kiểm được luật hook.

Lợi ích: tái dùng logic (fetch, form, subscription) mà không cần HOC /
render-props lồng sâu như trước.'
,description_en=
'RULES OF HOOKS - 2 mandatory rules so React matches state to each hook:

1) Only call hooks at the TOP LEVEL - not inside if/for/nested functions.
   React identifies hooks by CALL ORDER; conditional calls skew the order.
  ✗ if (open) { const [x] = useState(0); }        // wrong
  ✓ const [x] = useState(0); if (open) { ... }    // correct

2) Only call hooks inside a React function component or a custom hook
   (NOT in a plain function, NOT in a class).

CUSTOM HOOK - extract state/effect logic into a reusable function (name
starts with "use"):
  function useToggle(init = false) {
    const [on, setOn] = useState(init);
    const toggle = useCallback(() => setOn(o => !o), []);
    return [on, toggle];
  }
  // usage: const [open, toggleOpen] = useToggle();

STEP BY STEP:
  1. On each render, hooks run in the SAME order -> React maps their state.
  2. A custom hook is just a function that CALLS other hooks -> it packages
     logic, it does NOT share state between components (each caller gets its
     OWN state).
  3. Name it use* so the linter can enforce the hook rules.

Benefit: reuse logic (fetch, form, subscription) without deeply nested
HOCs / render-props like before.'
WHERE id='n_rc_rules';
