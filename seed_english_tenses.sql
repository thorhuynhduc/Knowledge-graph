-- ĐĂNG KÝ node: Tenses (map + present group + past group + future group)
INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('n_en_tenses_map','Bản đồ 12 thì','English',
'12 thì = 3 mốc thời gian (Hiện tại / Quá khứ / Tương lai) × 4 dạng
(Simple / Continuous / Perfect / Perfect Continuous).

BẢNG 12 THÌ (dạng khẳng định, động từ "do"):
             SIMPLE      CONTINUOUS        PERFECT            PERFECT CONT.
  PRESENT    do/does     am/is/are doing   have/has done      have/has been doing
  PAST       did         was/were doing    had done           had been doing
  FUTURE     will do     will be doing     will have done     will have been doing

Ý NGHĨA MỖI DẠNG:
  • Simple            : sự thật, thói quen, hành động trọn vẹn.
  • Continuous        : đang diễn ra tại một thời điểm (tạm thời, chưa xong).
  • Perfect           : nối 2 mốc — việc XONG TRƯỚC mốc đang nói.
  • Perfect Continuous: nhấn KHOẢNG kéo dài tới mốc đó.

TRỤC THỜI GIAN:
  QUÁ KHỨ ────────── HIỆN TẠI ────────── TƯƠNG LAI
   had done          have done           will have done   (perfect: xong TRƯỚC mốc)
   was doing         am doing            will be doing    (cont: đang tại mốc)

MẸO: đừng học 12 thì rời rạc. Nhớ 2 câu hỏi: (1) MỐC nào? (2) trọn vẹn /
đang diễn ra / đã xong trước / kéo dài? Ghép lại ra đúng thì. Chi tiết ở
các node hiện tại / quá khứ / tương lai.',
'The 12 tenses = 3 time frames (Present / Past / Future) x 4 aspects
(Simple / Continuous / Perfect / Perfect Continuous).

TABLE OF 12 TENSES (affirmative, verb "do"):
             SIMPLE      CONTINUOUS        PERFECT            PERFECT CONT.
  PRESENT    do/does     am/is/are doing   have/has done      have/has been doing
  PAST       did         was/were doing    had done           had been doing
  FUTURE     will do     will be doing     will have done     will have been doing

MEANING OF EACH ASPECT:
  • Simple            : facts, habits, complete actions.
  • Continuous        : in progress at a point in time (temporary, unfinished).
  • Perfect           : links 2 points - DONE BEFORE the point in question.
  • Perfect Continuous: stresses a DURATION leading up to that point.

TIMELINE:
  PAST ────────── PRESENT ────────── FUTURE
   had done       have done          will have done   (perfect: done BEFORE point)
   was doing      am doing           will be doing    (cont: happening at point)

TIP: do not learn the 12 tenses in isolation. Remember 2 questions: (1)
which TIME FRAME? (2) complete / in progress / done before / ongoing?
Combine them to get the right tense. Details in the present / past / future
nodes.',
'[]',-400,320),

('n_en_present','Nhóm Hiện tại (4 thì)','English',
'NHÓM HIỆN TẠI — 4 thì:

1) PRESENT SIMPLE (V / V-s): thói quen, sự thật, lịch trình.
   dấu hiệu: always, usually, often, every day, sometimes.
   "I work in Hanoi."  "She goes to the gym."  "Water boils at 100 C."
   (ngôi thứ 3 số ít thêm -s/-es; phủ định don''t / doesn''t)

2) PRESENT CONTINUOUS (am/is/are + V-ing): đang xảy ra LÚC NÓI, tạm thời,
   kế hoạch gần.  dấu hiệu: now, right now, at the moment, currently.
   "I am studying now."  "She is living with her parents (tạm thời)."
   Lưu ý: động từ TRẠNG THÁI (know, like, want, need) thường KHÔNG dùng -ing.

3) PRESENT PERFECT (have/has + V3): việc đã xong nhưng LIÊN QUAN hiện tại,
   hoặc kéo dài tới giờ; kinh nghiệm.
   dấu hiệu: just, already, yet, ever, never, since, for, recently.
   "I have finished."  "She has lived here for 5 years."  "Have you ever...?"
   -> KHÁC quá khứ đơn: perfect KHÔNG kèm mốc rõ (không đi với "yesterday").

4) PRESENT PERFECT CONTINUOUS (have/has been + V-ing): kéo dài liên tục
   tới hiện tại, nhấn quá trình / thời lượng.
   "I have been working since 9am."  "It has been raining all day."

MẸO người Việt: lỗi lớn nhất là QUÊN -s ngôi 3, và lạm dụng quá khứ đơn
thay cho present perfect. Có "since/for" + còn liên quan hiện tại ->
present perfect.',
'THE PRESENT GROUP - 4 tenses:

1) PRESENT SIMPLE (V / V-s): habits, facts, schedules.
   signals: always, usually, often, every day, sometimes.
   "I work in Hanoi."  "She goes to the gym."  "Water boils at 100 C."
   (3rd person singular adds -s/-es; negatives don''t / doesn''t)

2) PRESENT CONTINUOUS (am/is/are + V-ing): happening NOW, temporary, near
   plans.  signals: now, right now, at the moment, currently.
   "I am studying now."  "She is living with her parents (temporarily)."
   Note: STATE verbs (know, like, want, need) usually take NO -ing.

3) PRESENT PERFECT (have/has + V3): done but RELEVANT to now, or lasting up
   to now; experience.
   signals: just, already, yet, ever, never, since, for, recently.
   "I have finished."  "She has lived here for 5 years."  "Have you ever...?"
   -> UNLIKE past simple: the perfect takes NO specific time (not "yesterday").

4) PRESENT PERFECT CONTINUOUS (have/has been + V-ing): continuous up to now,
   stressing the process / duration.
   "I have been working since 9am."  "It has been raining all day."

TIP for Vietnamese: the biggest errors are FORGETTING 3rd-person -s, and
overusing past simple instead of present perfect. With "since/for" + still
relevant now -> present perfect.',
'[]',-460,360),

('n_en_past','Nhóm Quá khứ (4 thì)','English',
'NHÓM QUÁ KHỨ — 4 thì:

1) PAST SIMPLE (V2 / V-ed): hành động XONG trong quá khứ, có mốc rõ.
   dấu hiệu: yesterday, ago, last week, in 2010, when.
   "I visited Paris in 2019."  "She didn''t call." (phủ định did not + V)
   -> động từ bất quy tắc: go->went, see->saw, buy->bought (xem bảng riêng).

2) PAST CONTINUOUS (was/were + V-ing): đang diễn ra tại một thời điểm quá
   khứ, hoặc làm nền cho một hành động chen vào.
   "At 8pm I was having dinner."
   "I was cooking WHEN he called." (đang nấu thì bị chen ngang)

3) PAST PERFECT (had + V3): việc xong TRƯỚC một mốc / việc khác trong quá
   khứ (quá khứ của quá khứ).
   "When I arrived, the train HAD already LEFT." (tàu đi trước khi tôi tới)
   dấu hiệu: before, after, already, by the time.

4) PAST PERFECT CONTINUOUS (had been + V-ing): kéo dài liên tục tới một
   mốc quá khứ.
   "She was tired because she had been working all night."

MẸO: dùng past perfect để làm RÕ việc nào xảy ra TRƯỚC khi kể hai việc
quá khứ. Nếu đã có "before/after" chỉ rõ thứ tự thì thường past simple là
đủ. Trục: had done (xong trước) -> [mốc quá khứ] -> rồi mới...',
'THE PAST GROUP - 4 tenses:

1) PAST SIMPLE (V2 / V-ed): a COMPLETED past action with a clear time.
   signals: yesterday, ago, last week, in 2010, when.
   "I visited Paris in 2019."  "She didn''t call." (negative: did not + V)
   -> irregular verbs: go->went, see->saw, buy->bought (see the table node).

2) PAST CONTINUOUS (was/were + V-ing): in progress at a past moment, or a
   background for an interrupting action.
   "At 8pm I was having dinner."
   "I was cooking WHEN he called." (cooking, then interrupted)

3) PAST PERFECT (had + V3): done BEFORE another past point / action (the
   past of the past).
   "When I arrived, the train HAD already LEFT." (it left before I arrived)
   signals: before, after, already, by the time.

4) PAST PERFECT CONTINUOUS (had been + V-ing): continuous up to a past point.
   "She was tired because she had been working all night."

TIP: use the past perfect to make CLEAR which event came FIRST when telling
two past events. If "before/after" already shows the order, past simple is
often enough. Timeline: had done (done first) -> [past point] -> then...',
'[]',-400,380),

('n_en_future','Nhóm Tương lai','English',
'NHÓM TƯƠNG LAI — các cách diễn đạt:

1) FUTURE SIMPLE (will + V): quyết định TỨC THÌ, dự đoán, lời hứa.
   "I will help you."  "It will rain tomorrow."  "I won''t be late."

2) BE GOING TO + V: kế hoạch ĐÃ ĐỊNH trước, hoặc dự đoán có bằng chứng.
   "I am going to start a business." (đã dự tính)
   "Look at those clouds - it''s going to rain." (có dấu hiệu)
   -> will = quyết định NGAY lúc nói; going to = đã tính TỪ TRƯỚC.

3) PRESENT CONTINUOUS chỉ tương lai (sắp xếp cố định, đã hẹn):
   "I am meeting John at 6."

4) PRESENT SIMPLE cho lịch trình cố định:
   "The train leaves at 9am."

5) FUTURE CONTINUOUS (will be + V-ing): đang diễn ra tại một thời điểm
   tương lai.  "This time tomorrow I will be flying to Tokyo."

6) FUTURE PERFECT (will have + V3): sẽ XONG trước một mốc tương lai.
   "By 2030 I will have graduated."

MẸO người Việt: đừng mặc định mọi tương lai đều dùng "will". Kế hoạch có
sẵn -> "be going to" hoặc hiện tại tiếp diễn; lịch cố định -> hiện tại
đơn. Chọn đúng nghe tự nhiên hơn hẳn.',
'THE FUTURE GROUP - ways to express the future:

1) FUTURE SIMPLE (will + V): an INSTANT decision, prediction, promise.
   "I will help you."  "It will rain tomorrow."  "I won''t be late."

2) BE GOING TO + V: a plan DECIDED beforehand, or a prediction with evidence.
   "I am going to start a business." (already planned)
   "Look at those clouds - it''s going to rain." (there is evidence)
   -> will = decided AT the moment of speaking; going to = planned BEFORE.

3) PRESENT CONTINUOUS for the future (fixed arrangements, appointments):
   "I am meeting John at 6."

4) PRESENT SIMPLE for fixed timetables:
   "The train leaves at 9am."

5) FUTURE CONTINUOUS (will be + V-ing): in progress at a future moment.
   "This time tomorrow I will be flying to Tokyo."

6) FUTURE PERFECT (will have + V3): will be DONE before a future point.
   "By 2030 I will have graduated."

TIP for Vietnamese: do not default every future to "will". Prearranged
plans -> "be going to" or present continuous; fixed schedules -> present
simple. Choosing the right one sounds far more natural.',
'[]',-340,360)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
