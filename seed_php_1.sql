-- ===================================================================
--  TOPIC: PHP (song ngữ VI + EN, ví dụ code). File 1: cấu trúc + Cơ bản + OOP
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_php_1.sql
-- ===================================================================
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_php','PHP','Backend',
'Ngôn ngữ kịch bản phía server phổ biến cho web: cú pháp & kiểu dữ liệu,
mảng, hàm, lập trình hướng đối tượng, Composer/PSR, vòng đời request,
PDO và bảo mật, cùng PHP hiện đại (8.x) và framework.',
'A popular server-side scripting language for the web: syntax & types,
arrays, functions, object-oriented programming, Composer/PSR, the request
lifecycle, PDO and security, plus modern PHP (8.x) and frameworks.',
'[]',600,-380),

('s_php_basics','PHP Cơ bản','Backend',
'Cú pháp, biến & kiểu dữ liệu, mảng, hàm và chuỗi — nền tảng của PHP.',
'Syntax, variables & types, arrays, functions, and strings - the PHP core.',
'[]',520,-460),
('s_php_oop','Lập trình hướng đối tượng','Backend',
'Class/object, interface/abstract, trait, namespace & autoload bằng Composer.',
'Classes/objects, interfaces/abstract, traits, namespaces & Composer autoloading.',
'[]',660,-460),
('s_php_web','PHP cho Web','Backend',
'Vòng đời request, superglobals & form, session/cookie, PDO truy vấn DB, và
các lỗ hổng bảo mật (SQLi/XSS/CSRF).',
'The request lifecycle, superglobals & forms, sessions/cookies, PDO database
access, and security holes (SQLi/XSS/CSRF).',
'[]',520,-300),
('s_php_modern','PHP hiện đại','Backend',
'Tính năng PHP 8.x, chuẩn PSR + Composer, framework (Laravel/Symfony) và
PHP-FPM/OPcache.',
'PHP 8.x features, PSR standards + Composer, frameworks (Laravel/Symfony),
and PHP-FPM/OPcache.',
'[]',680,-300),

-- ------------------------- CƠ BẢN ---------------------------------
('n_php_syntax','Cú pháp & nền tảng','Backend',
'PHP là ngôn ngữ kịch bản phía SERVER, có thể nhúng trong HTML, chạy bởi
trình thông dịch. File .php; mã PHP nằm trong <?php ... ?>.

  <?php
    echo "Hello";        // in ra màn hình
    $name = "An";        // biến LUÔN bắt đầu bằng $
    echo "Hi $name";     // nội suy biến trong nháy KÉP -> Hi An
    echo ''Hi $name'';   // nháy ĐƠN: KHÔNG nội suy -> Hi $name
  ?>

ĐẶC ĐIỂM:
  • Biến bắt đầu bằng $, không khai báo kiểu (dynamically typed).
  • Kết thúc câu lệnh bằng dấu ;
  • Comment: // hoặc # (1 dòng), /* ... */ (nhiều dòng).
  • Nối chuỗi bằng dấu chấm: "a" . "b" -> "ab"
  • So sánh: == (lỏng, có ép kiểu) vs === (chặt, cùng kiểu + giá trị).

  var_dump(0 == "a");   // PHP 8: false (trước 8 là true - bẫy kinh điển)
  var_dump("0" == false); // true (lỏng)   "0" === false // false (chặt)

CHẠY: qua web server (Nginx/Apache + PHP-FPM) hoặc CLI: php file.php

MẸO: luôn ưu tiên === để tránh bug ép kiểu ngầm. PHP 8 đã siết lại quy
tắc so sánh số với chuỗi nên an toàn hơn trước.',
'PHP is a SERVER-side scripting language, embeddable in HTML, run by an
interpreter. Files end in .php; PHP code lives inside <?php ... ?>.

  <?php
    echo "Hello";        // print to output
    $name = "An";        // variables ALWAYS start with $
    echo "Hi $name";     // interpolation in DOUBLE quotes -> Hi An
    echo ''Hi $name'';   // SINGLE quotes: NO interpolation -> Hi $name
  ?>

CHARACTERISTICS:
  • Variables start with $, no type declaration (dynamically typed).
  • Statements end with ;
  • Comments: // or # (one line), /* ... */ (multi-line).
  • String concatenation uses a dot: "a" . "b" -> "ab"
  • Comparison: == (loose, with type juggling) vs === (strict, same type + value).

  var_dump(0 == "a");     // PHP 8: false (before 8 it was true - a classic trap)
  var_dump("0" == false); // true (loose)   "0" === false // false (strict)

RUN: via a web server (Nginx/Apache + PHP-FPM) or the CLI: php file.php

TIP: always prefer === to avoid implicit type-juggling bugs. PHP 8 tightened
number-vs-string comparison rules, so it is safer than before.',
'[]',440,-520),

('n_php_types','Biến & Kiểu dữ liệu','Backend',
'PHP có kiểu động: biến mang kiểu theo GIÁ TRỊ gán vào, có thể đổi kiểu.

KIỂU VÔ HƯỚNG: int, float, string, bool.
KIỂU HỢP: array, object, callable, iterable.
ĐẶC BIỆT: null (không giá trị), resource.

  $n = 42;            // int
  $pi = 3.14;         // float
  $s = "hello";       // string
  $ok = true;         // bool
  $x = null;          // null

  gettype($n);              // "integer"
  var_dump(is_int($n));     // bool(true)
  $n = (string)$n;          // ép kiểu tường minh -> "42"

KHAI BÁO KIỂU (type declaration, khuyên dùng từ PHP 7+):
  function add(int $a, int $b): int { return $a + $b; }
  declare(strict_types=1);  // đặt ĐẦU file -> ép kiểu chặt, báo lỗi nếu sai

HẰNG: const MAX = 100;  hoặc  define("MAX", 100);

GIÁ TRỊ "falsy" (coi như false): 0, 0.0, "", "0", [], null, false.

MẸO: bật declare(strict_types=1) + khai báo kiểu tham số/trả về -> bắt lỗi
sớm, code rõ ràng, IDE gợi ý tốt. Đây là thực hành chuẩn của PHP hiện đại.',
'PHP is dynamically typed: a variable takes the type of the VALUE assigned,
and can change type.

SCALAR TYPES: int, float, string, bool.
COMPOUND TYPES: array, object, callable, iterable.
SPECIAL: null (no value), resource.

  $n = 42;            // int
  $pi = 3.14;         // float
  $s = "hello";       // string
  $ok = true;         // bool
  $x = null;          // null

  gettype($n);              // "integer"
  var_dump(is_int($n));     // bool(true)
  $n = (string)$n;          // explicit cast -> "42"

TYPE DECLARATIONS (recommended since PHP 7+):
  function add(int $a, int $b): int { return $a + $b; }
  declare(strict_types=1);  // put at the FILE TOP -> strict typing, errors on mismatch

CONSTANTS: const MAX = 100;  or  define("MAX", 100);

"FALSY" VALUES (treated as false): 0, 0.0, "", "0", [], null, false.

TIP: enable declare(strict_types=1) + declare parameter/return types -> catch
bugs early, clearer code, better IDE hints. This is standard modern PHP practice.',
'[]',420,-460),

('n_php_arrays','Mảng (Arrays)','Backend',
'Mảng PHP cực kỳ linh hoạt: vừa là danh sách theo chỉ số, vừa là bản đồ
khóa-giá trị (associative array). Một cấu trúc dùng cho mọi thứ.

  $list = [1, 2, 3];                  // mảng chỉ số (0,1,2)
  $map  = ["name" => "An", "age" => 30]; // mảng kết hợp (khóa => giá trị)
  $list[] = 4;                        // thêm vào cuối
  echo $map["name"];                  // "An"

DUYỆT:
  foreach ($list as $v) { echo $v; }
  foreach ($map as $key => $val) { echo "$key=$val"; }

HÀM MẢNG HAY DÙNG:
  count($a)          // số phần tử
  array_map(fn($x)=>$x*2, $list)      // biến đổi từng phần tử
  array_filter($list, fn($x)=>$x>1)   // lọc
  array_reduce($list, fn($c,$x)=>$c+$x, 0) // gộp
  in_array(2,$list), array_keys($map), array_values($map)
  array_merge($a,$b), sort($a), usort($a, $cmp)

SPREAD & DESTRUCTURING:
  $all = [...$a, ...$b];              // gộp
  ["name"=>$name] = $map;             // rút khóa ra biến

MẸO: mảng kết hợp là "trái tim" của PHP (config, dữ liệu form, kết quả DB
đều là mảng). Nắm array_map/filter/reduce giúp code hàm gọn, tránh vòng
lặp thủ công.',
'PHP arrays are extremely flexible: both an indexed list and a key-value map
(associative array). One structure used for everything.

  $list = [1, 2, 3];                  // indexed array (0,1,2)
  $map  = ["name" => "An", "age" => 30]; // associative array (key => value)
  $list[] = 4;                        // append to the end
  echo $map["name"];                  // "An"

ITERATION:
  foreach ($list as $v) { echo $v; }
  foreach ($map as $key => $val) { echo "$key=$val"; }

COMMON ARRAY FUNCTIONS:
  count($a)          // number of elements
  array_map(fn($x)=>$x*2, $list)      // transform each element
  array_filter($list, fn($x)=>$x>1)   // filter
  array_reduce($list, fn($c,$x)=>$c+$x, 0) // fold
  in_array(2,$list), array_keys($map), array_values($map)
  array_merge($a,$b), sort($a), usort($a, $cmp)

SPREAD & DESTRUCTURING:
  $all = [...$a, ...$b];              // merge
  ["name"=>$name] = $map;             // pull a key into a variable

TIP: the associative array is the heart of PHP (config, form data, DB rows
are all arrays). Mastering array_map/filter/reduce yields concise functional
code and avoids manual loops.',
'[]',480,-440),

('n_php_functions','Hàm (Functions)','Backend',
'Hàm gom logic tái dùng. PHP hỗ trợ tham số mặc định, kiểu, biến động và
closure (hàm nặc danh).

  function greet(string $name, string $greeting = "Hi"): string {
    return "$greeting, $name!";
  }
  echo greet("An");            // "Hi, An!"  (dùng mặc định)
  echo greet("An", "Hello");   // "Hello, An!"

CLOSURE / ARROW FUNCTION:
  $double = function($x) { return $x * 2; };
  $triple = fn($x) => $x * 3;         // arrow fn (PHP 7.4+), tự bắt biến ngoài

  $factor = 10;
  $scale = fn($x) => $x * $factor;    // arrow fn TỰ nhìn thấy $factor
  $scale2 = function($x) use ($factor) { return $x * $factor; }; // phải use

THAM SỐ NÂNG CAO:
  function sum(...$nums) { return array_sum($nums); }  // variadic
  sum(1, 2, 3);                       // 6
  named args (PHP 8): greet(name: "An", greeting: "Yo");

MẸO: dùng khai báo kiểu tham số + trả về để rõ ràng và an toàn. Arrow fn
(fn) gọn cho callback (array_map/filter); function...use khi cần logic dài
hoặc sửa biến ngoài.',
'Functions group reusable logic. PHP supports default parameters, types,
variadics, and closures (anonymous functions).

  function greet(string $name, string $greeting = "Hi"): string {
    return "$greeting, $name!";
  }
  echo greet("An");            // "Hi, An!"  (uses the default)
  echo greet("An", "Hello");   // "Hello, An!"

CLOSURE / ARROW FUNCTION:
  $double = function($x) { return $x * 2; };
  $triple = fn($x) => $x * 3;         // arrow fn (PHP 7.4+), auto-captures outer vars

  $factor = 10;
  $scale = fn($x) => $x * $factor;    // arrow fn SEES $factor automatically
  $scale2 = function($x) use ($factor) { return $x * $factor; }; // needs use

ADVANCED PARAMETERS:
  function sum(...$nums) { return array_sum($nums); }  // variadic
  sum(1, 2, 3);                       // 6
  named args (PHP 8): greet(name: "An", greeting: "Yo");

TIP: declare parameter + return types for clarity and safety. Arrow fns (fn)
are concise for callbacks (array_map/filter); use function...use when you
need longer logic or to modify outer variables.',
'[]',540,-420),

-- ------------------------- OOP ------------------------------------
('n_php_oop','Class, Object & Kế thừa','Backend',
'PHP hỗ trợ OOP đầy đủ: class, đối tượng, kế thừa, đóng gói (visibility),
abstract class.

  class Animal {
    public function __construct(
      protected string $name          // PHP 8: khai báo + gán thẳng
    ) {}
    public function speak(): string { return "..."; }
  }
  class Dog extends Animal {
    public function speak(): string { return "$this->name says Woof"; }
  }
  $d = new Dog("Rex");
  echo $d->speak();                   // "Rex says Woof"

VISIBILITY (đóng gói):
  public    : truy cập mọi nơi
  protected : trong class này + class con
  private   : chỉ trong chính class này

THÀNH PHẦN:
  • $this  -> đối tượng hiện tại;  self:: / static:: -> chính class
  • static : thuộc CLASS, không thuộc instance (Counter::$count)
  • const  : hằng của class (self::MAX)
  • abstract class: không tạo instance được, để làm khuôn kế thừa.
  • __construct/__destruct, __get/__set (magic methods).

MẸO: PHP 8 "constructor property promotion" (khai kiểu + visibility ngay ở
tham số __construct) giúp bỏ bớt boilerplate. Dùng type + visibility rõ
ràng; ưu tiên composition hơn kế thừa sâu.',
'PHP has full OOP: classes, objects, inheritance, encapsulation (visibility),
abstract classes.

  class Animal {
    public function __construct(
      protected string $name          // PHP 8: declare + assign inline
    ) {}
    public function speak(): string { return "..."; }
  }
  class Dog extends Animal {
    public function speak(): string { return "$this->name says Woof"; }
  }
  $d = new Dog("Rex");
  echo $d->speak();                   // "Rex says Woof"

VISIBILITY (encapsulation):
  public    : accessible everywhere
  protected : this class + subclasses
  private   : only within this class

MEMBERS:
  • $this  -> the current object;  self:: / static:: -> the class itself
  • static : belongs to the CLASS, not an instance (Counter::$count)
  • const  : a class constant (self::MAX)
  • abstract class: cannot be instantiated, serves as an inheritance template.
  • __construct/__destruct, __get/__set (magic methods).

TIP: PHP 8 "constructor property promotion" (declaring type + visibility
right in the __construct parameters) removes boilerplate. Use clear types +
visibility; prefer composition over deep inheritance.',
'[]',640,-540),

('n_php_traits','Interface, Abstract & Trait','Backend',
'Ba công cụ tổ chức OOP trong PHP:

INTERFACE — hợp đồng (chỉ chữ ký, không thân hàm); một class có thể
implements NHIỀU interface:
  interface Jsonable { public function toJson(): string; }
  class User implements Jsonable {
    public function toJson(): string { return json_encode($this); }
  }

ABSTRACT CLASS — khuôn có sẵn một phần cài đặt, KHÔNG tạo instance được;
class con phải hiện thực các method abstract:
  abstract class Shape {
    abstract public function area(): float;   // con phải viết
    public function describe(): string { return "Area = " . $this->area(); }
  }

TRAIT — tái dùng CODE ngang giữa nhiều class (PHP đơn kế thừa nên trait
giải bài "muốn dùng chung method mà không kế thừa"):
  trait Timestamps {
    public function touch(): void { $this->updatedAt = time(); }
  }
  class Post { use Timestamps; }
  class Comment { use Timestamps; }   // cả hai dùng chung touch()

KHÁC NHAU:
  • interface: "CÓ THỂ làm gì" (hợp đồng, đa hình) — không code.
  • abstract : quan hệ "là một" + chia sẻ một phần code.
  • trait    : nhồi code dùng chung vào nhiều class không liên quan.

MẸO: lập trình HƯỚNG interface (type-hint theo interface) để dễ thay/mock.
Trait tiện nhưng lạm dụng gây khó lần nguồn method — dùng có chừng mực.',
'Three OOP organization tools in PHP:

INTERFACE - a contract (signatures only, no bodies); a class can implement
MANY interfaces:
  interface Jsonable { public function toJson(): string; }
  class User implements Jsonable {
    public function toJson(): string { return json_encode($this); }
  }

ABSTRACT CLASS - a partially-implemented template that CANNOT be
instantiated; subclasses must implement the abstract methods:
  abstract class Shape {
    abstract public function area(): float;   // subclass must write it
    public function describe(): string { return "Area = " . $this->area(); }
  }

TRAIT - horizontal CODE reuse across classes (PHP has single inheritance, so
traits solve "share methods without inheriting"):
  trait Timestamps {
    public function touch(): void { $this->updatedAt = time(); }
  }
  class Post { use Timestamps; }
  class Comment { use Timestamps; }   // both share touch()

DIFFERENCES:
  • interface: "CAN do what" (contract, polymorphism) - no code.
  • abstract : an "is-a" relation + some shared code.
  • trait    : inject shared code into unrelated classes.

TIP: program to INTERFACES (type-hint by interface) for easy swapping/mocking.
Traits are handy but overuse makes methods hard to trace - use in moderation.',
'[]',720,-500),

('n_php_namespaces','Namespace, Autoload & Composer','Backend',
'Namespace tránh trùng tên class giữa các thư viện; Composer là trình quản
lý gói + tự nạp file (autoload) theo chuẩn PSR-4.

NAMESPACE:
  namespace App\\Service;          // khai báo ở đầu file
  class Mailer { }

  // file khác:
  use App\\Service\\Mailer;        // import
  $m = new Mailer();

COMPOSER — quản lý phụ thuộc:
  composer require guzzlehttp/guzzle    // cài gói + ghi vào composer.json
  composer install                      // cài theo composer.lock
  composer update                       // nâng cấp

AUTOLOAD PSR-4 (composer.json): ánh xạ namespace -> thư mục:
  "autoload": { "psr-4": { "App\\\\": "src/" } }
  -> class App\\Service\\Mailer nằm ở file src/Service/Mailer.php
  Nạp một dòng duy nhất: require "vendor/autoload.php";

  -> KHÔNG cần require từng file class; Composer tự tìm theo tên class.

MẸO: cấu trúc dự án PHP hiện đại = 1 namespace gốc (App\\) map vào src/,
mọi phụ thuộc qua Composer. composer.lock phải commit để cài đúng phiên
bản trên mọi máy/server (giống package-lock.json của Node).',
'Namespaces avoid class-name clashes between libraries; Composer is the
dependency manager + file autoloader following the PSR-4 standard.

NAMESPACE:
  namespace App\\Service;          // declared at the file top
  class Mailer { }

  // another file:
  use App\\Service\\Mailer;        // import
  $m = new Mailer();

COMPOSER - dependency management:
  composer require guzzlehttp/guzzle    // install a package + record in composer.json
  composer install                      // install per composer.lock
  composer update                       // upgrade

PSR-4 AUTOLOAD (composer.json): maps a namespace -> a directory:
  "autoload": { "psr-4": { "App\\\\": "src/" } }
  -> class App\\Service\\Mailer lives in src/Service/Mailer.php
  Load with a single line: require "vendor/autoload.php";

  -> NO need to require each class file; Composer finds them by class name.

TIP: a modern PHP project layout = one root namespace (App\\) mapped to src/,
all dependencies via Composer. Commit composer.lock so every machine/server
installs the exact versions (like Node package-lock.json).',
'[]',740,-440)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
