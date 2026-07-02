-- ĐÀO SÂU Design Patterns (đợt 3d): SOLID
UPDATE kg_nodes SET
description=
'SOLID — 5 nguyên lý thiết kế hướng đối tượng, nền của nhiều design pattern:

S — Single Responsibility: một lớp chỉ MỘT lý do để thay đổi.
    ✗ class User { save(); sendEmail(); renderHtml(); }  // 3 trách nhiệm
    ✓ tách riêng: User (dữ liệu), UserRepo (lưu), Mailer (email), View.

O — Open/Closed: mở để MỞ RỘNG, đóng để SỬA ĐỔI.
    ✗ if/else theo loại -> thêm loại phải sửa hàm cũ
    ✓ Strategy: thêm loại = thêm một class/hàm, KHÔNG sửa code cũ.

L — Liskov Substitution: lớp con phải thay được lớp cha mà không phá hành vi.
    ✗ class Square extends Rectangle (setWidth đổi luôn height)
       -> phá kỳ vọng của code đang dùng Rectangle.

I — Interface Segregation: nhiều interface NHỎ, chuyên biệt hơn một cái to.
    ✗ interface Worker { work(); eat(); }   // Robot đâu cần eat()
    ✓ tách Workable, Eatable riêng.

D — Dependency Inversion: phụ thuộc ABSTRACTION, không phụ thuộc chi tiết.
    class OrderService {
      constructor(repo) { this.repo = repo; }  // repo là một interface
    }
    // đổi Postgres/Mongo KHÔNG sửa OrderService; dễ mock khi test.

SOLID giúp code dễ mở rộng, dễ test, ít vỡ khi thay đổi. Rất nhiều
design pattern chính là cách HIỆN THỰC các nguyên lý này.'
,description_en=
'SOLID - 5 object-oriented design principles, the basis of many patterns:

S - Single Responsibility: a class has only ONE reason to change.
    WRONG class User { save(); sendEmail(); renderHtml(); }  // 3 duties
    RIGHT split: User (data), UserRepo (persist), Mailer (email), View.

O - Open/Closed: open to EXTENSION, closed to MODIFICATION.
    WRONG if/else by type -> a new type edits the old function
    RIGHT Strategy: a new type = a new class/function, NO edit to old code.

L - Liskov Substitution: a subclass must substitute its base without breaking behavior.
    WRONG class Square extends Rectangle (setWidth also changes height)
       -> breaks the expectations of code using Rectangle.

I - Interface Segregation: many SMALL, specific interfaces beat one large one.
    WRONG interface Worker { work(); eat(); }   // a Robot does not eat()
    RIGHT split Workable, Eatable.

D - Dependency Inversion: depend on ABSTRACTIONS, not on details.
    class OrderService {
      constructor(repo) { this.repo = repo; }  // repo is an interface
    }
    // swap Postgres/Mongo WITHOUT editing OrderService; easy to mock in tests.

SOLID makes code easier to extend and test, and less brittle to change.
Many design patterns are exactly ways to IMPLEMENT these principles.'
WHERE id='n_dp_solid';
