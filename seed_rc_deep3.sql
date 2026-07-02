-- ĐÀO SÂU React (đợt 4c): Context, State management, Patterns, Server data
UPDATE kg_nodes SET
description=
'Context truyền dữ liệu xuống sâu mà KHÔNG phải chuyền props qua từng
tầng (tránh "prop drilling").

  const ThemeCtx = createContext("light");

  function App() {
    return (
      <ThemeCtx.Provider value={theme}>
        <Toolbar />          {/* Toolbar không cần nhận/chuyền theme */}
      </ThemeCtx.Provider>
    );
  }
  function DeepButton() {
    const theme = useContext(ThemeCtx);   // lấy trực tiếp, dù ở rất sâu
  }

CẢNH BÁO HIỆU NĂNG: khi value của Provider ĐỔI, MỌI component dùng
useContext đó đều re-render.
  ✗ value={{ user, setUser }}            // object mới MỖI render -> render lan
  ✓ const value = useMemo(() => ({ user, setUser }), [user]);
    <Ctx.Provider value={value}>          // reference ổn định

DÙNG ĐÚNG: dữ liệu "toàn cục nhẹ", đổi ÍT — theme, locale, user đăng
nhập, config. KHÔNG dùng Context như state management cho dữ liệu đổi
liên tục (dùng store chuyên: Redux/Zustand) vì sẽ render lan diện rộng.

GIẢI THÍCH: Context giải bài prop drilling, KHÔNG phải công cụ tối ưu
render. Tách nhiều context nhỏ theo tần suất đổi để giảm render thừa.'
,description_en=
'Context passes data deep down WITHOUT threading props through every level
(avoiding "prop drilling").

  const ThemeCtx = createContext("light");

  function App() {
    return (
      <ThemeCtx.Provider value={theme}>
        <Toolbar />          {/* Toolbar need not receive/forward theme */}
      </ThemeCtx.Provider>
    );
  }
  function DeepButton() {
    const theme = useContext(ThemeCtx);   // read directly, however deep
  }

PERFORMANCE WARNING: when the Provider value CHANGES, EVERY component using
that useContext re-renders.
  ✗ value={{ user, setUser }}            // new object EACH render -> renders spread
  ✓ const value = useMemo(() => ({ user, setUser }), [user]);
    <Ctx.Provider value={value}>          // stable reference

USE IT FOR: "light global" data that changes RARELY - theme, locale, the
logged-in user, config. Do NOT use Context as state management for
frequently changing data (use a dedicated store: Redux/Zustand) because it
causes wide re-renders.

EXPLANATION: Context solves prop drilling; it is NOT a render-optimization
tool. Split into several small contexts by change frequency to cut wasted
renders.'
WHERE id='n_rc_context';

UPDATE kg_nodes SET
description=
'Chọn NƠI lưu state theo phạm vi dùng — đừng mặc định nhét mọi thứ vào
một store toàn cục.

THANG QUYẾT ĐỊNH (từ hẹp đến rộng):
  1. Biến thường / tính được  -> KHÔNG cần state (derive lúc render):
     const fullName = first + " " + last;   // đừng useState cho cái này
  2. Chỉ 1 component dùng      -> useState / useReducer cục bộ.
  3. Vài component gần nhau    -> "lift state up" lên cha chung + props.
  4. Nhiều nơi xa, đổi ít      -> Context (theme, user, locale).
  5. State SERVER (từ API)     -> React Query/SWR (KHÔNG phải state UI!).
  6. State client toàn cục phức tạp -> Redux Toolkit / Zustand / Jotai.

SAI LẦM KINH ĐIỂN: nhét dữ liệu server (list, chi tiết) vào Redux rồi tự
lo loading/cache/refetch. -> Dùng React Query: nó lo cache, dedupe,
revalidate, loading/error sẵn.

useReducer khi state phức tạp, nhiều hành động liên quan:
  const [state, dispatch] = useReducer(reducer, initial);
  dispatch({ type: "add", item });

GIẢI THÍCH: giữ state Ở GẦN nơi dùng nhất (colocation) -> ít render lan,
dễ hiểu, dễ xóa. Chỉ nâng lên global khi THỰC SỰ nhiều nơi cần.'
,description_en=
'Choose WHERE to store state by scope of use - do not default to cramming
everything into one global store.

DECISION LADDER (narrow to wide):
  1. Plain / derivable value  -> NO state needed (derive during render):
     const fullName = first + " " + last;   // do not useState for this
  2. Used by 1 component      -> local useState / useReducer.
  3. A few nearby components  -> "lift state up" to a common parent + props.
  4. Many distant places, rarely changing -> Context (theme, user, locale).
  5. SERVER state (from an API) -> React Query/SWR (NOT UI state!).
  6. Complex global client state -> Redux Toolkit / Zustand / Jotai.

CLASSIC MISTAKE: dumping server data (lists, details) into Redux and then
hand-managing loading/cache/refetch. -> Use React Query: it handles cache,
dedupe, revalidation, loading/error out of the box.

useReducer when state is complex with many related actions:
  const [state, dispatch] = useReducer(reducer, initial);
  dispatch({ type: "add", item });

EXPLANATION: keep state as CLOSE as possible to where it is used
(colocation) -> fewer spreading renders, easier to understand and delete.
Promote to global only when MANY places truly need it.'
WHERE id='n_rc_state_mgmt';

UPDATE kg_nodes SET
description=
'Các mẫu tổ chức component phổ biến:

1) CUSTOM HOOK (nay là cách CHÍNH để tái dùng logic có state):
   function useFetch(url) {
     const [data, setData] = useState(null);
     useEffect(() => { let a = true;
       fetch(url).then(r => r.json()).then(d => a && setData(d));
       return () => { a = false; }; }, [url]);
     return data;
   }

2) PRESENTATIONAL vs CONTAINER: tách component "hiển thị" (nhận props,
   không logic) khỏi component "lo dữ liệu/logic" -> UI dễ tái dùng, dễ test.

3) COMPOUND COMPONENTS: nhóm component phối hợp qua context nội bộ, cho
   API khai báo gọn:
   <Tabs>
     <Tabs.List><Tabs.Tab>A</Tabs.Tab></Tabs.List>
     <Tabs.Panel>...</Tabs.Panel>
   </Tabs>

4) children / render prop / slot: truyền UI vào thay vì hardcode -> linh
   hoạt, tránh render thừa (children không render lại khi cha đổi state).

CŨ (ít dùng nay): HOC (withX) và render-props từng dùng để chia sẻ logic
-> nay đa số thay bằng custom hook (gọn, tránh lồng sâu "wrapper hell").

GIẢI THÍCH: mục tiêu chung là TÁCH mối quan tâm (UI vs logic vs dữ liệu)
để tái dùng và test dễ. Chọn mẫu theo vấn đề, đừng áp máy móc.'
,description_en=
'Common component-organization patterns:

1) CUSTOM HOOK (now the MAIN way to reuse stateful logic):
   function useFetch(url) {
     const [data, setData] = useState(null);
     useEffect(() => { let a = true;
       fetch(url).then(r => r.json()).then(d => a && setData(d));
       return () => { a = false; }; }, [url]);
     return data;
   }

2) PRESENTATIONAL vs CONTAINER: split a "display" component (takes props,
   no logic) from a "data/logic" component -> reusable UI, easier to test.

3) COMPOUND COMPONENTS: a group of components cooperating via internal
   context, giving a clean declarative API:
   <Tabs>
     <Tabs.List><Tabs.Tab>A</Tabs.Tab></Tabs.List>
     <Tabs.Panel>...</Tabs.Panel>
   </Tabs>

4) children / render prop / slot: pass UI in instead of hardcoding it ->
   flexible, and avoids wasted renders (children do not re-render when the
   parent changes state).

OLDER (now rarer): HOCs (withX) and render-props once shared logic -> now
mostly replaced by custom hooks (cleaner, avoiding deep "wrapper hell").

EXPLANATION: the common goal is to SEPARATE concerns (UI vs logic vs data)
for reuse and testability. Pick a pattern by the problem, do not apply it
mechanically.'
WHERE id='n_rc_patterns';

UPDATE kg_nodes SET
description=
'Quản lý dữ liệu SERVER (dữ liệu từ API) khác hẳn state UI: nó là bản SAO
của server -> cần cache, đồng bộ lại, xử lý loading/error/stale.

ĐỪNG tự làm bằng useEffect + useState cho mọi thứ:
  ✗ mỗi component tự fetch -> gọi trùng, không cache, tự lo race + loading.

DÙNG React Query (TanStack Query) / SWR:
  const { data, isLoading, error } = useQuery({
    queryKey: ["user", id],
    queryFn: () => fetch(`/user/${id}`).then(r => r.json()),
  });
  // tự động: cache theo key, DEDUPE gọi trùng, refetch khi focus, retry,
  //          loading/error states, invalidate sau mutation.

MUTATION + LÀM MỚI:
  const m = useMutation({
    mutationFn: save,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["user", id] }),
  });                       // sửa xong -> tự refetch dữ liệu liên quan

GIẢI THÍCH TỪNG BƯỚC:
  1. queryKey định danh dữ liệu -> cache + dedupe dựa vào nó.
  2. Nhiều component cùng key -> CHỈ một request, chia sẻ cache.
  3. Sau mutation, invalidate key -> dữ liệu tự cập nhật lại.

CỐT LÕI: tách "server state" khỏi "client/UI state". Server state giao
cho thư viện data-fetching; store toàn cục (Redux/Zustand) chỉ giữ state
UI thực sự của client.'
,description_en=
'Managing SERVER data (data from an API) is very different from UI state:
it is a COPY of the server -> it needs caching, resyncing, and
loading/error/stale handling.

DO NOT hand-roll it with useEffect + useState for everything:
  ✗ each component fetches on its own -> duplicate calls, no cache, manual
    race + loading handling.

USE React Query (TanStack Query) / SWR:
  const { data, isLoading, error } = useQuery({
    queryKey: ["user", id],
    queryFn: () => fetch(`/user/${id}`).then(r => r.json()),
  });
  // automatically: cache by key, DEDUPE duplicate calls, refetch on focus,
  //                retry, loading/error states, invalidate after a mutation.

MUTATION + REFRESH:
  const m = useMutation({
    mutationFn: save,
    onSuccess: () => qc.invalidateQueries({ queryKey: ["user", id] }),
  });                       // after saving -> auto-refetch related data

STEP BY STEP:
  1. The queryKey identifies the data -> cache + dedupe rely on it.
  2. Many components with the same key -> ONE request, shared cache.
  3. After a mutation, invalidating the key -> the data auto-refreshes.

KEY IDEA: separate "server state" from "client/UI state". Hand server state
to a data-fetching library; a global store (Redux/Zustand) should hold only
genuine client UI state.'
WHERE id='n_rc_data';
