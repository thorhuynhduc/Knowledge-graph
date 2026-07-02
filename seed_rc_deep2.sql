-- ĐÀO SÂU React (đợt 4b): Re-render, Perf, Virtual DOM, Fiber, Keys
UPDATE kg_nodes SET
description=
'Một component re-render khi MỘT trong các điều sau xảy ra:
  1. State của chính nó đổi (setState).
  2. Props từ cha đổi.
  3. Cha nó re-render (mặc định con render THEO, dù props không đổi!).
  4. Context nó đang dùng đổi giá trị.

  Cha render ─► TẤT CẢ con render (mặc định) ─► cháu render ...
     (React KHÔNG tự so props; nó render lại cả cây con)

HIỂU LẦM PHỔ BIẾN: "props không đổi thì con không render" -> SAI. Con
render vì CHA render. Muốn chặn phải React.memo:
  const Child = React.memo(function Child({ value }) { ... });
  // giờ Child chỉ render khi prop value đổi (so sánh nông)

RE-RENDER != CẬP NHẬT DOM:
  render (chạy hàm component) -> tạo virtual DOM -> React DIFF -> chỉ
  phần DOM khác mới bị đụng. Render lại KHÔNG đồng nghĩa thao tác DOM
  thật, nhưng render thừa vẫn tốn CPU (diff + tính toán).

GIẢI THÍCH TỪNG BƯỚC:
  1. Trigger (state/props/context) -> React gọi lại hàm component.
  2. So sánh output (reconciliation) với lần trước.
  3. Chỉ commit khác biệt xuống DOM.

Biết điều này để tối ưu ĐÚNG chỗ: giảm render thừa (memo, đưa state
xuống thấp) thay vì tối ưu mù.'
,description_en=
'A component re-renders when ONE of these happens:
  1. Its own state changes (setState).
  2. Props from the parent change.
  3. Its parent re-renders (by default children follow, even if props are
     unchanged!).
  4. A Context it consumes changes value.

  Parent renders ─► ALL children render (default) ─► grandchildren render ...
     (React does NOT auto-compare props; it re-renders the whole subtree)

COMMON MISCONCEPTION: "if props are unchanged the child does not render"
-> WRONG. The child renders because the PARENT rendered. To stop it use
React.memo:
  const Child = React.memo(function Child({ value }) { ... });
  // now Child renders only when the value prop changes (shallow compare)

RE-RENDER != DOM UPDATE:
  render (running the component function) -> builds virtual DOM -> React
  DIFFs -> only the differing DOM is touched. A re-render does NOT mean real
  DOM work, but wasted renders still cost CPU (diffing + computation).

STEP BY STEP:
  1. A trigger (state/props/context) -> React re-calls the component function.
  2. It compares the output (reconciliation) with the previous one.
  3. It commits only the difference to the DOM.

Knowing this lets you optimize the RIGHT spot: cut wasted renders (memo,
push state lower) instead of optimizing blindly.'
WHERE id='n_rc_render';

UPDATE kg_nodes SET
description=
'Tối ưu re-render = ngăn render THỪA. Thứ tự ưu tiên (làm từ trên xuống):

1) SỬA CẤU TRÚC trước khi memo:
   • Đưa state xuống THẤP nhất có thể (state colocation) -> chỉ nhánh cần
     mới render.
   • "Lift content up": truyền children thay vì render bên trong:
     <Slow>{<Heavy/>}</Slow>  // Heavy không render lại khi Slow đổi state

2) React.memo — chặn con render khi props không đổi (so sánh nông):
   const Row = React.memo(RowBase);

3) useMemo/useCallback — giữ reference props ổn định cho con đã memo,
   hoặc nhớ tính toán nặng.

4) Danh sách dài -> VIRTUALIZATION (react-window): chỉ render item trong
   viewport thay vì cả nghìn dòng.

VÍ DỤ colocation (sửa cấu trúc, không cần memo):
  ✗ state ô input nằm ở cha -> gõ phím render cả trang
  ✓ tách <SearchBox/> giữ state của nó -> gõ chỉ render SearchBox

ĐO TRƯỚC KHI TỐI ƯU: React DevTools Profiler chỉ ra component nào render
nhiều/chậm. Đừng rải memo khắp nơi — đo, tìm điểm nóng, sửa đúng chỗ.'
,description_en=
'Optimizing re-renders = preventing WASTED renders. Priority order (top down):

1) FIX STRUCTURE before reaching for memo:
   • Push state as LOW as possible (state colocation) -> only the branch
     that needs it re-renders.
   • "Lift content up": pass children instead of rendering inside:
     <Slow>{<Heavy/>}</Slow>  // Heavy does not re-render when Slow changes state

2) React.memo - stop a child rendering when props are unchanged (shallow):
   const Row = React.memo(RowBase);

3) useMemo/useCallback - keep prop references stable for memoized children,
   or remember heavy computations.

4) Long lists -> VIRTUALIZATION (react-window): render only items in the
   viewport instead of thousands of rows.

COLOCATION EXAMPLE (structural fix, no memo needed):
  ✗ the input state lives in the parent -> typing re-renders the whole page
  ✓ extract <SearchBox/> holding its own state -> typing renders only SearchBox

MEASURE BEFORE OPTIMIZING: the React DevTools Profiler shows which
components render often/slowly. Do not sprinkle memo everywhere - measure,
find the hot spot, fix the right place.'
WHERE id='n_rc_perf';

UPDATE kg_nodes SET
description=
'Virtual DOM = cây object JS mô tả UI. React so cây MỚI với cây CŨ
(reconciliation) rồi chỉ cập nhật phần DOM thật sự khác -> ít chạm DOM
(vốn chậm).

  setState -> render() -> VDOM mới ─┐
                                    ├─ DIFF (so 2 cây) ─► patch DOM tối thiểu
                     VDOM cũ  ──────┘

THUẬT TOÁN DIFF (heuristic O(n)):
  1. Khác LOẠI element (div -> span) -> hủy cây con cũ, dựng mới.
  2. Cùng loại -> giữ node, chỉ cập nhật attribute/prop đổi.
  3. Danh sách con -> so theo KEY (nên diff hiệu quả cần key ổn định).

VÍ DỤ vì sao cần diff:
  UI cũ:  <ul><li>A</li><li>B</li></ul>
  UI mới: <ul><li>A</li><li>B</li><li>C</li></ul>
  -> React chỉ THÊM <li>C</li>, không dựng lại cả <ul>.

GIẢI THÍCH: VDOM không "nhanh hơn DOM" một cách kỳ diệu; nó giúp GOM và
GIẢM số thao tác DOM, đồng thời cho phép viết UI KHAI BÁO (mô tả trạng
thái, React lo cập nhật). Đây là nền cho keys, reconciliation và Fiber.'
,description_en=
'The Virtual DOM = a tree of JS objects describing the UI. React compares
the NEW tree with the OLD tree (reconciliation) then updates only the DOM
that truly differs -> fewer DOM touches (which are slow).

  setState -> render() -> new VDOM ─┐
                                    ├─ DIFF (compare 2 trees) ─► minimal DOM patch
                     old VDOM ──────┘

THE DIFF ALGORITHM (an O(n) heuristic):
  1. Different element TYPE (div -> span) -> discard the old subtree, build new.
  2. Same type -> keep the node, update only changed attributes/props.
  3. Child lists -> compared by KEY (efficient diffing needs stable keys).

WHY DIFFING MATTERS:
  old UI: <ul><li>A</li><li>B</li></ul>
  new UI: <ul><li>A</li><li>B</li><li>C</li></ul>
  -> React only ADDS <li>C</li>, it does not rebuild the whole <ul>.

EXPLANATION: the VDOM is not magically "faster than the DOM"; it BATCHES
and REDUCES DOM operations, and lets you write DECLARATIVE UI (describe the
state, React handles updates). It is the basis for keys, reconciliation,
and Fiber.'
WHERE id='n_rc_vdom';

UPDATE kg_nodes SET
description=
'Fiber = kiến trúc reconciler viết lại (React 16+) cho phép render CÓ THỂ
NGẮT (interruptible): chia công việc thành đơn vị (fiber) và làm theo
lát thời gian.

TRƯỚC (stack reconciler): diff chạy MỘT MẠCH, đồng bộ, không dừng được
-> cây lớn làm nghẽn main thread, UI khựng.

FIBER: chia việc thành các unit, có thể TẠM DỪNG / TIẾP TỤC / BỎ -> nhường
chỗ cho việc ưu tiên cao (gõ phím, animation).

CONCURRENT FEATURES (React 18, dựa trên Fiber):
  • useTransition — đánh dấu cập nhật KHÔNG khẩn -> giữ UI mượt:
      const [isPending, startTransition] = useTransition();
      startTransition(() => setQuery(text));  // lọc danh sách nặng
      // gõ phím (khẩn) vẫn mượt; kết quả lọc cập nhật ngay sau
  • useDeferredValue — hoãn một giá trị nặng chạy theo sau giá trị khẩn.
  • Suspense — chờ dữ liệu / lazy component, hiện fallback trong lúc chờ.

GIẢI THÍCH: Fiber cho React tách render thành 2 pha — RENDER (tính toán,
có thể ngắt) và COMMIT (đụng DOM, đồng bộ, nhanh, không ngắt). Nhờ đó có
ưu tiên hóa cập nhật và các tính năng concurrent.'
,description_en=
'Fiber = the rewritten reconciler architecture (React 16+) that makes
rendering INTERRUPTIBLE: it splits work into units (fibers) and processes
them in time slices.

BEFORE (the stack reconciler): diffing ran in ONE synchronous pass that
could not stop -> a large tree blocked the main thread and froze the UI.

FIBER: splits work into units that can PAUSE / RESUME / ABORT -> yielding to
higher-priority work (typing, animation).

CONCURRENT FEATURES (React 18, built on Fiber):
  • useTransition - marks a NON-urgent update -> keeps the UI smooth:
      const [isPending, startTransition] = useTransition();
      startTransition(() => setQuery(text));  // heavy list filtering
      // typing (urgent) stays smooth; filtered results update just after
  • useDeferredValue - defers a heavy value that trails an urgent value.
  • Suspense - waits for data / a lazy component, showing a fallback meanwhile.

EXPLANATION: Fiber lets React split rendering into 2 phases - RENDER
(computation, interruptible) and COMMIT (DOM mutation, synchronous, fast,
uninterruptible). This enables update prioritization and concurrent features.'
WHERE id='n_rc_fiber';

UPDATE kg_nodes SET
description=
'key giúp React nhận diện item nào là item nào khi danh sách thay đổi,
để tái dùng đúng DOM/state thay vì dựng lại.

  {items.map(it => <Row key={it.id} data={it} />)}  // key ỔN ĐỊNH, duy nhất

VÌ SAO KHÔNG DÙNG INDEX làm key khi danh sách đổi thứ tự/chèn/xóa:
  Danh sách: [A, B, C]   key = index 0,1,2
  Xóa A ->   [B, C]      B nhận key 0 (trước là của A)
  -> React tưởng "item 0 đổi nội dung A->B" và tái dùng SAI DOM/state.

HẬU QUẢ THỰC TẾ: ô input đang gõ ở dòng này nhảy sang dòng khác;
checkbox tick sai dòng; animation giật — vì state nội bộ bám theo key.

  ✗ items.map((it, i) => <Row key={i} .../>)   // sai khi reorder/insert
  ✓ items.map(it => <Row key={it.id} .../>)    // id ổn định theo dữ liệu

KHI NÀO index CHẤP NHẬN ĐƯỢC: danh sách TĨNH, không sắp xếp lại, không
thêm/xóa ở giữa.

GIẢI THÍCH: key là ĐỊNH DANH trong reconciliation của danh sách con. Đúng
key -> React ghép đúng phần tử cũ-mới -> giữ được state + patch tối thiểu.'
,description_en=
'A key lets React identify which item is which when a list changes, so it
reuses the right DOM/state instead of rebuilding.

  {items.map(it => <Row key={it.id} data={it} />)}  // STABLE, unique key

WHY NOT USE THE INDEX as the key when the list reorders/inserts/deletes:
  list: [A, B, C]   key = index 0,1,2
  delete A -> [B, C]   B now gets key 0 (previously A had it)
  -> React thinks "item 0 changed content A->B" and reuses the WRONG DOM/state.

REAL CONSEQUENCES: an input being typed in one row jumps to another row;
a checkbox ticks the wrong row; animations glitch - because internal state
sticks to the key.

  ✗ items.map((it, i) => <Row key={i} .../>)   // wrong on reorder/insert
  ✓ items.map(it => <Row key={it.id} .../>)    // id stable to the data

WHEN AN INDEX IS ACCEPTABLE: a STATIC list that is never reordered and
never inserted/deleted in the middle.

EXPLANATION: the key is the IDENTITY used in child-list reconciliation. A
correct key -> React matches old and new elements correctly -> preserves
state + minimal patching.'
WHERE id='n_rc_keys';
