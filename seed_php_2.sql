-- TOPIC PHP file 2: Web + Modern
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_php_request','Vòng đời request','Backend',
'Khác Node (server thường trực), PHP truyền thống theo mô hình
SHARED-NOTHING: MỖI request khởi tạo lại toàn bộ, chạy xong thì XÓA sạch
-> không giữ state trong bộ nhớ giữa các request.

SƠ ĐỒ (PHP-FPM):
  Client -> Nginx -> PHP-FPM -> khởi tạo PHP -> chạy script -> trả HTML -> dọn sạch
                                (mỗi request = một môi trường mới, sạch)

Ý NGHĨA:
  • Biến toàn cục KHÔNG sống qua request -> muốn giữ state phải dùng
    session / DB / cache (Redis).
  • Ít lo memory leak tích lũy như server thường trực (xong là giải phóng).
  • Đánh đổi: chi phí khởi tạo MỖI request -> giảm bằng OPcache (cache bytecode).

KHÁC NODE.JS: Node một tiến trình phục vụ nhiều request, giữ state trong RAM
(phải cẩn thận leak); PHP mỗi request sạch — đơn giản, nhưng cần OPcache +
FPM để nhanh.

MẸO: hiểu shared-nothing giải thích vì sao PHP dùng $_SESSION/DB cho state,
và vì sao PHP dễ SCALE NGANG (không có state trong tiến trình -> thêm máy
thoải mái).',
'Unlike Node (a long-running server), traditional PHP uses a SHARED-NOTHING
model: EACH request re-initializes everything and wipes it all when done
-> no in-memory state is kept between requests.

DIAGRAM (PHP-FPM):
  Client -> Nginx -> PHP-FPM -> init PHP -> run script -> return HTML -> clean up
                                (each request = a fresh, clean environment)

IMPLICATIONS:
  • Global variables do NOT survive across requests -> to keep state use
    sessions / DB / cache (Redis).
  • Less worry about accumulating memory leaks than a long-running server
    (everything is freed at the end).
  • Trade-off: an init cost PER request -> reduced by OPcache (bytecode cache).

VS NODE.JS: Node has one process serving many requests, holding state in RAM
(watch for leaks); PHP starts each request clean - simpler, but needs OPcache
+ FPM to be fast.

TIP: understanding shared-nothing explains why PHP uses $_SESSION/DB for
state, and why PHP scales HORIZONTALLY easily (no in-process state -> add
machines freely).',
'[]',440,-340),

('n_php_superglobals','Superglobals & Form','Backend',
'Superglobals là các mảng toàn cục PHP tự tạo, truy cập được ở MỌI nơi,
chứa dữ liệu của request.

  $_GET     - tham số query string (?q=abc)
  $_POST    - dữ liệu form gửi bằng POST
  $_REQUEST - gộp GET+POST+COOKIE (nên TRÁNH, mơ hồ nguồn)
  $_SERVER  - thông tin server/request ($_SERVER["REQUEST_METHOD"])
  $_FILES   - file upload
  $_SESSION - dữ liệu phiên;   $_COOKIE - cookie
  $_ENV / getenv() - biến môi trường

XỬ LÝ FORM:
  if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $email = trim($_POST["email"] ?? "");     // ?? tránh lỗi undefined
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
      // báo lỗi
    }
  }

QUAN TRỌNG (bảo mật): dữ liệu từ $_GET/$_POST/$_FILES là INPUT NGƯỜI DÙNG
-> KHÔNG tin. Luôn validate + escape trước khi dùng; đừng nhét thẳng vào
SQL hay HTML.

MẸO: dùng ?? (null coalescing) để đọc key có thể thiếu; validate bằng
filter_var; ép kiểu ((int)$_GET["id"]) khi mong đợi số. Với API hiện đại,
dữ liệu JSON đọc qua json_decode(file_get_contents("php://input")).',
'Superglobals are global arrays PHP creates automatically, accessible
EVERYWHERE, holding the request data.

  $_GET     - query-string params (?q=abc)
  $_POST    - form data sent via POST
  $_REQUEST - GET+POST+COOKIE combined (AVOID, ambiguous source)
  $_SERVER  - server/request info ($_SERVER["REQUEST_METHOD"])
  $_FILES   - uploaded files
  $_SESSION - session data;   $_COOKIE - cookies
  $_ENV / getenv() - environment variables

HANDLING A FORM:
  if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $email = trim($_POST["email"] ?? "");     // ?? avoids undefined errors
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
      // report an error
    }
  }

IMPORTANT (security): data from $_GET/$_POST/$_FILES is USER INPUT -> do NOT
trust it. Always validate + escape before use; never drop it straight into
SQL or HTML.

TIP: use ?? (null coalescing) to read possibly-missing keys; validate with
filter_var; cast ((int)$_GET["id"]) when you expect a number. For modern
APIs, read JSON via json_decode(file_get_contents("php://input")).',
'[]',420,-280),

('n_php_pdo','PDO & Database','Backend',
'PDO (PHP Data Objects) là lớp truy cập DB thống nhất (MySQL, PostgreSQL...),
hỗ trợ PREPARED STATEMENTS chống SQL injection.

KẾT NỐI:
  $pdo = new PDO("mysql:host=localhost;dbname=app;charset=utf8mb4", $u, $p, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,       // lỗi -> ném exception
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,  // fetch ra mảng kết hợp
  ]);

TRUY VẤN có tham số (BẮT BUỘC khi có input người dùng):
  $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
  $stmt->execute([$email]);          // tham số TÁCH khỏi câu SQL
  $user = $stmt->fetch();            // 1 dòng
  $all  = $stmt->fetchAll();         // tất cả
  // named placeholder:
  $pdo->prepare("... WHERE id = :id")->execute([":id" => $id]);

GHI + transaction:
  $stmt = $pdo->prepare("INSERT INTO users(name,email) VALUES(?,?)");
  $stmt->execute([$name, $email]);
  $id = $pdo->lastInsertId();

  $pdo->beginTransaction();
  try { /* nhiều lệnh */ $pdo->commit(); }
  catch (Exception $e) { $pdo->rollBack(); throw $e; }

MẸO: LUÔN dùng prepared statement, ĐỪNG nối chuỗi input vào SQL. Đặt
ERRMODE_EXCEPTION để lỗi không bị nuốt. PDO là nền tảng bên dưới mọi ORM
(Eloquent của Laravel, Doctrine của Symfony).',
'PDO (PHP Data Objects) is a unified DB access layer (MySQL, PostgreSQL...)
with PREPARED STATEMENTS to prevent SQL injection.

CONNECT:
  $pdo = new PDO("mysql:host=localhost;dbname=app;charset=utf8mb4", $u, $p, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,       // errors -> throw exceptions
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,  // fetch as associative arrays
  ]);

PARAMETERIZED QUERY (MANDATORY with user input):
  $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
  $stmt->execute([$email]);          // params SEPARATED from the SQL
  $user = $stmt->fetch();            // one row
  $all  = $stmt->fetchAll();         // all rows
  // named placeholder:
  $pdo->prepare("... WHERE id = :id")->execute([":id" => $id]);

WRITE + transaction:
  $stmt = $pdo->prepare("INSERT INTO users(name,email) VALUES(?,?)");
  $stmt->execute([$name, $email]);
  $id = $pdo->lastInsertId();

  $pdo->beginTransaction();
  try { /* several statements */ $pdo->commit(); }
  catch (Exception $e) { $pdo->rollBack(); throw $e; }

TIP: ALWAYS use prepared statements, NEVER concatenate input into SQL. Set
ERRMODE_EXCEPTION so errors are not swallowed. PDO underlies every ORM
(Laravel Eloquent, Symfony Doctrine).',
'[]',480,-260),

('n_php_security','Bảo mật Web (SQLi/XSS/CSRF)','Backend',
'Các lỗ hổng web phổ biến và cách chặn trong PHP:

SQL INJECTION — nối input vào câu SQL:
  ✗ $pdo->query("SELECT * FROM users WHERE name = ''$name''"); // chèn SQL độc
  ✓ prepared: prepare("... WHERE name = ?")->execute([$name]);

XSS (Cross-Site Scripting) — in input người dùng ra HTML chưa escape:
  ✗ echo $_GET["q"];                       // <script> của kẻ gian sẽ chạy
  ✓ echo htmlspecialchars($_GET["q"], ENT_QUOTES, "UTF-8");

CSRF — kẻ gian giả request thay người đã đăng nhập:
  ✓ token CSRF ẩn trong form, kiểm tra khi POST (dùng hash_equals để so sánh).

MẬT KHẨU — KHÔNG lưu dạng thô:
  $hash = password_hash($pw, PASSWORD_DEFAULT);   // bcrypt/argon2 tự thêm salt
  if (password_verify($input, $hash)) { /* đúng */ }

KHÁC:
  • Production: display_errors = 0 (đừng lộ lỗi/đường dẫn), ghi log riêng.
  • Validate + ép kiểu MỌI input; giới hạn loại/kích thước file upload.
  • HTTPS + cookie HttpOnly/Secure/SameSite cho session.

MẸO: quy tắc vàng — KHÔNG tin dữ liệu người dùng. ESCAPE khi XUẤT
(HTML/SQL/shell), VALIDATE khi NHẬP. Dùng password_hash (tuyệt đối đừng
md5/sha1 cho mật khẩu). Framework lo sẵn phần lớn (CSRF token, auto-escape
trong template).',
'Common web vulnerabilities and how to block them in PHP:

SQL INJECTION - concatenating input into SQL:
  ✗ $pdo->query("SELECT * FROM users WHERE name = ''$name''"); // injects SQL
  ✓ prepared: prepare("... WHERE name = ?")->execute([$name]);

XSS (Cross-Site Scripting) - echoing user input into HTML unescaped:
  ✗ echo $_GET["q"];                       // an attacker <script> would run
  ✓ echo htmlspecialchars($_GET["q"], ENT_QUOTES, "UTF-8");

CSRF - an attacker forges a request as a logged-in user:
  ✓ a hidden CSRF token in the form, checked on POST (compare with hash_equals).

PASSWORDS - do NOT store them raw:
  $hash = password_hash($pw, PASSWORD_DEFAULT);   // bcrypt/argon2, auto-salted
  if (password_verify($input, $hash)) { /* correct */ }

OTHER:
  • Production: display_errors = 0 (do not leak errors/paths), log separately.
  • Validate + cast ALL input; limit uploaded file type/size.
  • HTTPS + HttpOnly/Secure/SameSite cookies for sessions.

TIP: the golden rule - do NOT trust user data. ESCAPE on OUTPUT
(HTML/SQL/shell), VALIDATE on INPUT. Use password_hash (never md5/sha1 for
passwords). Frameworks handle most of this (CSRF tokens, auto-escaping in
templates).',
'[]',520,-240),

-- ------------------------- HIỆN ĐẠI -------------------------------
('n_php_php8','Tính năng PHP 8.x','Backend',
'PHP 8.x nhanh hơn (có JIT) và thêm nhiều cú pháp hiện đại đáng dùng:

NULLSAFE (?->): tránh chuỗi if kiểm null lồng nhau:
  $city = $user?->address?->city;   // null nếu bất kỳ khâu nào null

MATCH (thay switch: so sánh CHẶT ===, TRẢ giá trị, không fall-through):
  $label = match($code) {
    200, 201 => "success",
    404      => "not found",
    default  => "unknown",
  };

CONSTRUCTOR PROPERTY PROMOTION:
  class Point { public function __construct(public int $x, public int $y) {} }

ENUM (PHP 8.1) — thay các hằng string rời rạc:
  enum Status: string { case Active = "active"; case Banned = "banned"; }
  Status::Active->value;            // "active"

READONLY property (8.1): thuộc tính chỉ gán 1 lần -> DTO bất biến.
NAMED ARGUMENTS: htmlspecialchars($s, double_encode: false);
FIRST-CLASS CALLABLE (8.1): $fn = strlen(...);
ATTRIBUTES (#[Route(...)]) — metadata thay annotation trong docblock.

MẸO: match an toàn hơn switch (không quên break, so sánh ===). enum thay
"magic string". readonly cho object bất biến. Nâng lên PHP 8.1+ để tận dụng
và nhanh hơn hẳn PHP 7.',
'PHP 8.x is faster (has a JIT) and adds many modern, worthwhile syntaxes:

NULLSAFE (?->): avoid nested null-check if-chains:
  $city = $user?->address?->city;   // null if any link is null

MATCH (replaces switch: STRICT === comparison, RETURNS a value, no fall-through):
  $label = match($code) {
    200, 201 => "success",
    404      => "not found",
    default  => "unknown",
  };

CONSTRUCTOR PROPERTY PROMOTION:
  class Point { public function __construct(public int $x, public int $y) {} }

ENUM (PHP 8.1) - replaces scattered string constants:
  enum Status: string { case Active = "active"; case Banned = "banned"; }
  Status::Active->value;            // "active"

READONLY property (8.1): assigned once -> immutable DTOs.
NAMED ARGUMENTS: htmlspecialchars($s, double_encode: false);
FIRST-CLASS CALLABLE (8.1): $fn = strlen(...);
ATTRIBUTES (#[Route(...)]) - metadata replacing docblock annotations.

TIP: match is safer than switch (no forgotten break, === comparison). enums
replace "magic strings". readonly for immutable objects. Move to PHP 8.1+ to
benefit and to be much faster than PHP 7.',
'[]',640,-260),

('n_php_psr','PSR & Công cụ chuẩn','Backend',
'PSR (PHP Standards Recommendations) là các chuẩn chung do PHP-FIG đặt ra,
giúp code và thư viện tương thích nhau:

  • PSR-1 / PSR-12 : coding style (đặt tên, thụt lề, khoảng trắng).
  • PSR-4          : autoload namespace -> thư mục (Composer dùng).
  • PSR-3          : LoggerInterface -> đổi thư viện log không sửa code.
  • PSR-7 / PSR-15 : HTTP message & middleware (Request/Response chuẩn).
  • PSR-11         : Container interface (dependency injection).

CÔNG CỤ HAY DÙNG:
  • Composer      : quản lý gói + autoload.
  • PHPUnit       : unit test.
  • PHPStan/Psalm : phân tích TĨNH, bắt lỗi kiểu mà không cần chạy.
  • PHP-CS-Fixer / phpcs : tự sửa / kiểm tra style theo PSR-12.

Ý NGHĨA: nhờ PSR + Composer, các thư viện PHP hiện đại ghép nối rất dễ (một
Logger PSR-3 thay cho cái khác mà KHÔNG phải sửa code phụ thuộc).

MẸO: theo PSR-12 + chạy PHPStan ở mức cao trong CI -> code sạch, ít bug,
đội đọc code của nhau dễ. Đây là chuẩn nghề của PHP hiện đại, khác hẳn kiểu
PHP chắp vá ngày xưa.',
'PSR (PHP Standards Recommendations) are shared standards from PHP-FIG that
make code and libraries interoperable:

  • PSR-1 / PSR-12 : coding style (naming, indentation, whitespace).
  • PSR-4          : namespace -> directory autoloading (used by Composer).
  • PSR-3          : LoggerInterface -> swap logging libraries without code changes.
  • PSR-7 / PSR-15 : HTTP messages & middleware (standard Request/Response).
  • PSR-11         : Container interface (dependency injection).

COMMON TOOLS:
  • Composer      : dependency manager + autoload.
  • PHPUnit       : unit testing.
  • PHPStan/Psalm : STATIC analysis, catching type bugs without running.
  • PHP-CS-Fixer / phpcs : auto-fix / check style per PSR-12.

WHY IT MATTERS: thanks to PSR + Composer, modern PHP libraries plug together
easily (one PSR-3 Logger replaces another WITHOUT editing dependent code).

TIP: follow PSR-12 + run PHPStan at a high level in CI -> clean code, fewer
bugs, easier to read each other code. This is professional modern PHP,
unlike the patchwork PHP of old.',
'[]',720,-240),

('n_php_frameworks','Framework & Runtime (FPM/OPcache)','Backend',
'PHP hiếm khi viết thuần trong dự án thật; đa số dùng framework để có cấu
trúc, bảo mật và ORM sẵn.

LARAVEL — phổ biến nhất, "batteries included", cú pháp thanh lịch:
  Route::get("/users/{id}", [UserController::class, "show"]);
  // ORM Eloquent:
  User::where("active", true)->get();
  // sẵn có: routing, migration, queue, auth, Blade template, artisan CLI.

SYMFONY — mô-đun, mạnh, nhiều component tái dùng (Laravel dùng lại nhiều
component của Symfony). Hợp dự án lớn / enterprise.
KHÁC: Slim (micro API), CodeIgniter (nhẹ), Laminas.

RUNTIME — chạy PHP nhanh ở production:
  • PHP-FPM  : quản lý một pool tiến trình PHP; Nginx đẩy request qua FPM.
  • OPcache  : cache BYTECODE đã biên dịch -> KHÔNG parse lại .php mỗi
    request (tăng tốc rất lớn; luôn bật ở production).
  • Preloading (7.4+), JIT (8.0): tăng tốc thêm cho tải nặng.

MẸO: mới học nên bắt đầu với Laravel (tài liệu tốt, cộng đồng lớn, dựng
CRUD/API rất nhanh). Luôn bật OPcache trên production. Framework lo sẵn
routing + bảo mật (CSRF, auto-escape) nên an toàn hơn tự viết thuần nhiều.',
'PHP is rarely written raw in real projects; most use a framework for
structure, security, and a ready ORM.

LARAVEL - the most popular, "batteries included", elegant syntax:
  Route::get("/users/{id}", [UserController::class, "show"]);
  // Eloquent ORM:
  User::where("active", true)->get();
  // built in: routing, migrations, queues, auth, Blade templates, artisan CLI.

SYMFONY - modular, powerful, many reusable components (Laravel reuses many
Symfony components). Suits large / enterprise projects.
OTHERS: Slim (micro APIs), CodeIgniter (lightweight), Laminas.

RUNTIME - running PHP fast in production:
  • PHP-FPM  : manages a pool of PHP processes; Nginx forwards requests to FPM.
  • OPcache  : caches compiled BYTECODE -> does NOT re-parse .php each
    request (a big speedup; always enable in production).
  • Preloading (7.4+), JIT (8.0): extra speed for heavy loads.

TIP: beginners should start with Laravel (great docs, big community, very
fast CRUD/API scaffolding). Always enable OPcache in production. Frameworks
handle routing + security (CSRF, auto-escaping), so they are much safer than
hand-rolled raw PHP.',
'[]',700,-180)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
