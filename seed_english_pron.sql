-- ===================================================================
--  TOPIC: Tiếng Anh Mỹ (American English) — song ngữ VI + EN, ví dụ + IPA
--  Áp: docker compose exec -T mysql \
--        mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --default-character-set=utf8mb4 \
--        "$DB_NAME" < seed_english_pron.sql
--  (utf8mb4 BẮT BUỘC). File này tạo topic + 6 section + node phần Phát âm.
-- ===================================================================

INSERT INTO kg_nodes (id,label,category,description,description_en,links,pos_x,pos_y) VALUES
('t_en','Tiếng Anh Mỹ','English',
'Tiếng Anh Mỹ (American English) toàn diện cho người Việt: phát âm & lưu ý, chunking, ngữ pháp, 12 thì, quy tắc thêm -s/-es/-ed/-ing, động từ bất quy tắc, và mẹo nói như người bản xứ.',
'Comprehensive American English for Vietnamese learners: pronunciation and notes, chunking, grammar, the 12 tenses, spelling rules for -s/-es/-ed/-ing, irregular verbs, and tips to sound like a native.',
'[]',-600,380),

('s_en_pron','Phát âm (Pronunciation)','English',
'Phát âm giọng Mỹ: IPA, âm /r/ rhotic, flap T, schwa, trọng âm từ & câu, ngữ điệu, nối âm, âm th và các âm khó với người Việt.',
'American pronunciation: IPA, rhotic /r/, flap T, schwa, word & sentence stress, intonation, linking, the th sounds and sounds hard for Vietnamese speakers.',
'[]',-720,300),
('s_en_chunk','Chunking & Connected Speech','English',
'Nhóm ý khi nói (chunking), nhịp điệu stress-timed và các biến đổi âm khi nói liền (assimilation, elision, catenation).',
'Grouping ideas (chunking), stress-timed rhythm, and how sounds change in connected speech (assimilation, elision, catenation).',
'[]',-760,180),
('s_en_grammar','Ngữ pháp (Grammar)','English',
'Ngữ pháp cốt lõi: trật tự từ, mạo từ, danh từ, đại từ, tính/trạng từ, giới từ, modal verbs, câu điều kiện, bị động, tường thuật, câu hỏi, gerund/infinitive.',
'Core grammar: word order, articles, nouns, pronouns, adjectives/adverbs, prepositions, modal verbs, conditionals, passive, reported speech, questions, gerund/infinitive.',
'[]',-560,180),
('s_en_tenses','Các thì (12 Tenses)','English',
'12 thì tiếng Anh: bản đồ tổng quan và 4 nhóm hiện tại / quá khứ / tương lai kèm cách dùng và dấu hiệu nhận biết.',
'The 12 English tenses: an overview map and the four present / past / future groups with uses and signal words.',
'[]',-400,260),
('s_en_verbs','Động từ & Quy tắc chính tả','English',
'Quy tắc chính tả & phát âm: thêm -s/-es, -ed, -ing; động từ bất quy tắc và danh từ số nhiều bất quy tắc hay dùng.',
'Spelling & pronunciation rules: adding -s/-es, -ed, -ing; common irregular verbs and irregular plural nouns.',
'[]',-380,120),
('s_en_native','Nói như người bản xứ','English',
'Contractions/reductions, phrasal verbs, idioms, slang, fillers, small talk, collocations, khác biệt Anh-Mỹ vs Anh-Anh, và mức độ trang trọng (register).',
'Contractions/reductions, phrasal verbs, idioms, slang, fillers, small talk, collocations, American vs British differences, and register.',
'[]',-560,40),

-- ------------------------- PHÁT ÂM (leaf nodes) --------------------
('n_en_ipa','Bảng âm & IPA (giọng Mỹ)','English',
'Tiếng Anh Mỹ (General American) có ~24 phụ âm + ~15 nguyên âm, ghi bằng
ký hiệu IPA. Chính tả KHÔNG khớp âm -> học theo ÂM, đừng đọc theo mặt chữ.

NGUYÊN ÂM hay gặp (kèm ví dụ):
  /iː/ see   /ɪ/ sit   /eɪ/ say   /ɛ/ bed   /æ/ cat
  /ɑː/ father /ʌ/ cup  /ə/ about (schwa)   /ɔː/ thought
  /oʊ/ go    /ʊ/ book  /uː/ too   /aɪ/ my   /aʊ/ now   /ɔɪ/ boy

PHỤ ÂM khó với người Việt:
  /θ/ think, /ð/ this, /r/ (cong lưỡi), /v/ (khác /w/),
  /z/ zoo, /ʒ/ vision; cụm cuối /st/ /kt/ /ld/ (hay bị nuốt).

MẸO TRA CỨU: từ điển tốt (Merriam-Webster, Cambridge) đều ghi IPA +
phát âm Mỹ, bấm loa nghe được. Hãy NGHE và NHẠI (shadowing) thay vì đoán
theo chữ viết.

VÌ SAO QUAN TRỌNG: một chữ đọc nhiều kiểu (a trong cat / car / care /
about), nhiều chữ đọc một âm. Nắm IPA giúp tự học phát âm chính xác bất
kỳ từ nào.',
'General American has about 24 consonants + 15 vowels, written in IPA.
Spelling does NOT match sound -> learn by SOUND, not by letters.

COMMON VOWELS (with examples):
  /iː/ see   /ɪ/ sit   /eɪ/ say   /ɛ/ bed   /æ/ cat
  /ɑː/ father /ʌ/ cup  /ə/ about (schwa)   /ɔː/ thought
  /oʊ/ go    /ʊ/ book  /uː/ too   /aɪ/ my   /aʊ/ now   /ɔɪ/ boy

CONSONANTS hard for Vietnamese speakers:
  /θ/ think, /ð/ this, /r/ (curled tongue), /v/ (unlike /w/),
  /z/ zoo, /ʒ/ vision; final clusters /st/ /kt/ /ld/ (often dropped).

LOOKUP TIP: good dictionaries (Merriam-Webster, Cambridge) show IPA + US
audio. LISTEN and IMITATE (shadowing) instead of guessing from spelling.

WHY IT MATTERS: one letter has many sounds (a in cat / car / care /
about), many letters map to one sound. Knowing IPA lets you self-learn
the exact pronunciation of any word.',
'[]',-820,340),

('n_en_r','Âm /r/ & rhotic (rất Mỹ)','English',
'Đặc trưng LỚN NHẤT của giọng Mỹ: RHOTIC — luôn phát âm /r/ ở MỌI vị trí,
kể cả cuối từ và trước phụ âm (giọng Anh-Anh thường bỏ /r/).

  car  /kɑːr/ (Mỹ đọc rõ r; Anh: /kɑː/)
  hard /hɑːrd/   four /fɔːr/   teacher /ˈtiːtʃər/

CÁCH TẠO ÂM /r/ MỸ: cong đầu lưỡi lên (retroflex) hoặc gồng gốc lưỡi,
môi hơi tròn; đầu lưỡi KHÔNG chạm vòm miệng. Không rung như "r" tiếng Việt.

R-CONTROLLED VOWELS (nguyên âm + r, đặc trưng Mỹ):
  /ɑːr/ car   /ɔːr/ more   /ɜːr/ bird, her, work (âm "ơ-r" đặc trưng)
  /ɪr/ here   /ɛr/ air     /ʊr/ tour

MẸO: âm /ɜːr/ (bird, work, her, first) là "ơ" kéo dài + cong lưỡi suốt
âm — luyện riêng vì cực hay gặp.

LƯU Ý người Việt: đừng bỏ /r/ cuối (car không phải "ca"), và đừng rung
đầu lưỡi.',
'The BIGGEST feature of American accent: RHOTIC - /r/ is always pronounced
in EVERY position, including word-final and before consonants (British
usually drops /r/).

  car  /kɑːr/ (US pronounces r clearly; UK: /kɑː/)
  hard /hɑːrd/   four /fɔːr/   teacher /ˈtiːtʃər/

MAKING THE US /r/: curl the tongue tip up (retroflex) or bunch the tongue
back, lips slightly rounded; the tip does NOT touch the roof. It does not
trill like a Vietnamese "r".

R-CONTROLLED VOWELS (vowel + r, very American):
  /ɑːr/ car   /ɔːr/ more   /ɜːr/ bird, her, work (the signature sound)
  /ɪr/ here   /ɛr/ air     /ʊr/ tour

TIP: /ɜːr/ (bird, work, her, first) is a long "er" with the tongue curled
throughout - drill it separately, it is extremely common.

NOTE for Vietnamese: do not drop final /r/ (car is not "ca"), and do not
trill the tongue tip.',
'[]',-860,260),

('n_en_t','Flap T & các biến thể của T','English',
'Trong giọng Mỹ, chữ T giữa hai nguyên âm biến thành FLAP /ɾ/ — nghe gần
như /d/ búng nhanh. Đây là lý do nghe người Mỹ nói lạ so với chữ viết.

  water  -> "wah-der"    better -> "bedder"
  city, letter, butter, party, later, matter, thirty
  cụm: "get it" -> "geddit",  "a lot of" -> "a lodda"

BỐN BIẾN THỂ CỦA T:
  1. Flap T (nguyên âm _T_ nguyên âm): water, later -> /ɾ/ (như d nhanh)
  2. Glottal stop T (trước /n/ hoặc cuối âm tiết): button, kitten,
     mountain -> nín hơi ở cổ họng, không bật /t/ rõ
  3. T bị nuốt sau N: "interview" -> "innerview", "twenty" -> "twenny"
  4. T rõ ràng: đầu từ hoặc trong âm nhấn (top, time, reTURN, aTTEND)

MẸO: người Anh-Anh vẫn bật /t/ rõ (water /ˈwɔːtə/). Luyện flap T giúp
giọng Mỹ tự nhiên hơn hẳn, và nghe hiểu nhanh hơn.',
'In American English, T between two vowels becomes a FLAP /ɾ/ - it sounds
almost like a quick /d/. This is why American speech sounds unlike its
spelling.

  water  -> "wah-der"    better -> "bedder"
  city, letter, butter, party, later, matter, thirty
  phrases: "get it" -> "geddit",  "a lot of" -> "a lodda"

FOUR VARIANTS OF T:
  1. Flap T (vowel _T_ vowel): water, later -> /ɾ/ (like a fast d)
  2. Glottal stop T (before /n/ or at syllable end): button, kitten,
     mountain -> a catch in the throat, no clear /t/ burst
  3. T dropped after N: "interview" -> "innerview", "twenty" -> "twenny"
  4. Clear T: word-initial or in a stressed syllable (top, time, reTURN)

TIP: British keeps a clear /t/ (water /ˈwɔːtə/). Practicing the flap T
makes an American accent far more natural and speeds up listening.',
'[]',-900,200),

('n_en_schwa','Schwa /ə/ & giảm âm','English',
'Schwa /ə/ là nguyên âm PHỔ BIẾN NHẤT tiếng Anh — âm "ơ" ngắn, yếu, nằm ở
âm tiết KHÔNG nhấn. Đây là chìa khóa của nhịp điệu tiếng Anh.

  about /əˈbaʊt/    banana /bəˈnænə/ (hai chữ a thành schwa)
  problem, sofa, support, the, a, to, of, from

VOWEL REDUCTION — âm tiết không nhấn bị giảm về schwa:
  photograph  /ˈfoʊtəɡræf/     (o thứ hai -> ə)
  photographer /fəˈtɑːɡrəfər/  (trọng âm dời -> nguyên âm đổi hẳn)

FUNCTION WORDS thường đọc DẠNG YẾU (weak form) với schwa:
  to -> /tə/, for -> /fər/, and -> /ən/, of -> /əv/, can -> /kən/
  "a cup of tea" -> "a cuppa tea"

MẸO người Việt: đừng đọc RÕ mọi nguyên âm như tiếng Việt. Nhấn mạnh âm
tiết chính, NUỐT nhẹ phần còn lại về schwa -> nghe Mỹ và tự nhiên hơn.
Đọc "TO-DAY" đều nhau nghe rất cứng; đúng là "tə-DAY".',
'The schwa /ə/ is the MOST COMMON vowel in English - a short, weak "uh"
in UNSTRESSED syllables. It is the key to English rhythm.

  about /əˈbaʊt/    banana /bəˈnænə/ (both a letters become schwa)
  problem, sofa, support, the, a, to, of, from

VOWEL REDUCTION - unstressed syllables reduce to schwa:
  photograph  /ˈfoʊtəɡræf/     (second o -> ə)
  photographer /fəˈtɑːɡrəfər/  (stress shifts -> the vowel changes entirely)

FUNCTION WORDS often take a WEAK FORM with schwa:
  to -> /tə/, for -> /fər/, and -> /ən/, of -> /əv/, can -> /kən/
  "a cup of tea" -> "a cuppa tea"

TIP for Vietnamese: do not pronounce every vowel fully like in Vietnamese.
Stress the main syllable and SWALLOW the rest into schwa -> more American
and natural. Saying "TO-DAY" evenly sounds stiff; it should be "tə-DAY".',
'[]',-820,140),

('n_en_wordstress','Trọng âm từ (Word Stress)','English',
'Mỗi từ nhiều âm tiết có MỘT âm tiết nhấn: đọc TO hơn, DÀI hơn, RÕ hơn.
Nhấn sai chỗ -> người Mỹ khó hiểu dù bạn phát âm đúng từng âm.

  ˈTA-ble   com-ˈPU-ter   ˈbeau-ti-ful   un-der-ˈSTAND

QUY TẮC HAY DÙNG (không tuyệt đối):
  • Danh/tính từ 2 âm tiết -> thường nhấn ĐẦU: TA-ble, HAP-py
  • Động từ 2 âm tiết -> thường nhấn SAU: re-LAX, de-CIDE
  • Cặp danh/động cùng chữ: ˈRE-cord (n) / re-ˈCORD (v),
    ˈPRE-sent (n) / pre-ˈSENT (v)
  • Đuôi -tion/-sion/-ic/-ical -> nhấn âm NGAY TRƯỚC đuôi:
    in-for-MA-tion, de-CI-sion, e-co-NO-mic
  • Đuôi -ty/-cy/-phy/-gy -> nhấn âm thứ 3 từ cuối:
    pho-TO-gra-phy, de-MO-cra-cy, a-BI-li-ty

MẸO: học từ mới là học LUÔN trọng âm (dấu ˈ đứng trước âm nhấn trong từ
điển). Âm không nhấn giảm về schwa.',
'Every multi-syllable word has ONE stressed syllable: LOUDER, LONGER,
CLEARER. Wrong stress -> Americans struggle to understand even if each
sound is correct.

  ˈTA-ble   com-ˈPU-ter   ˈbeau-ti-ful   un-der-ˈSTAND

USEFUL RULES (not absolute):
  • 2-syllable nouns/adjectives -> usually stress the FIRST: TA-ble, HAP-py
  • 2-syllable verbs -> usually stress the SECOND: re-LAX, de-CIDE
  • Noun/verb pairs spelled the same: ˈRE-cord (n) / re-ˈCORD (v),
    ˈPRE-sent (n) / pre-ˈSENT (v)
  • Endings -tion/-sion/-ic/-ical -> stress the syllable JUST BEFORE:
    in-for-MA-tion, de-CI-sion, e-co-NO-mic
  • Endings -ty/-cy/-phy/-gy -> stress the 3rd syllable from the end:
    pho-TO-gra-phy, de-MO-cra-cy, a-BI-li-ty

TIP: learning a new word means learning its stress too (the ˈ mark
precedes the stressed syllable in dictionaries). Unstressed syllables
reduce to schwa.',
'[]',-760,90),

('n_en_sentencestress','Trọng âm câu & nhịp điệu','English',
'Tiếng Anh là ngôn ngữ STRESS-TIMED: nhấn CONTENT WORDS (từ mang nghĩa),
lướt nhanh FUNCTION WORDS (từ ngữ pháp). Khoảng cách giữa các từ nhấn
gần như ĐỀU nhau về thời gian.

  CONTENT (nhấn): danh từ, động từ chính, tính từ, trạng từ, từ WH
  FUNCTION (lướt): a/the, to/of/in, and/but, đại từ, trợ động từ, be

  "I want to GO to the STORE to BUY some MILK."
   -> nhấn GO, STORE, BUY, MILK; phần còn lại lướt nhanh + schwa.

CONTRASTIVE STRESS — đổi chỗ nhấn đổi hàm ý:
  "I didn''t say he stole it."
   nhấn I  = không phải tôi nói;  nhấn STOLE = anh ta không TRỘM mà...

MẸO người Việt: tiếng Việt đọc mọi tiếng gần đều nhau; tiếng Anh KHÔNG.
Kéo dài từ nhấn, nuốt từ nối -> tạo nhịp điệu Mỹ. Đây là yếu tố SỐ 1 để
nghe tự nhiên, quan trọng hơn cả phát âm từng âm.',
'English is STRESS-TIMED: stress CONTENT WORDS (meaning), rush through
FUNCTION WORDS (grammar). The gaps between stressed words are roughly
EQUAL in time.

  CONTENT (stressed): nouns, main verbs, adjectives, adverbs, WH-words
  FUNCTION (rushed): a/the, to/of/in, and/but, pronouns, auxiliaries, be

  "I want to GO to the STORE to BUY some MILK."
   -> stress GO, STORE, BUY, MILK; the rest is fast + schwa.

CONTRASTIVE STRESS - moving the stress changes the implication:
  "I didn''t say he stole it."
   stress I  = it was not me who said it;  stress STOLE = he did not STEAL
   it (but did something else)...

TIP for Vietnamese: Vietnamese gives every syllable near-equal weight;
English does NOT. Lengthen stressed words, swallow linkers -> American
rhythm. This is the NUMBER 1 factor for sounding natural, more than
individual sounds.',
'[]',-680,60),

('n_en_intonation','Ngữ điệu (Intonation)','English',
'Ngữ điệu = lên/xuống cao độ giọng, truyền cảm xúc và báo kiểu câu. Sai
ngữ điệu nghe máy móc hoặc bị hiểu nhầm thái độ.

MẪU CƠ BẢN:
  • Xuống cuối câu: câu kể, câu hỏi WH (hỏi thông tin)
      "I live in Boston."      "Where do you live?"
  • Lên cuối câu: câu hỏi Yes/No, ý chưa xong, xác nhận
      "Are you coming?"        "So... (còn tiếp)"
  • Lên rồi xuống khi liệt kê:
      "I bought apples, oranges, and pears."  (lên ở giữa, xuống ở cuối)

UPTALK: lên giọng cuối câu KỂ nghe thiếu tự tin / như hỏi lại -> tránh
khi muốn tỏ ra chắc chắn.

CHỨC NĂNG CẢM XÚC: cùng chữ "Really?" — lên cao = ngạc nhiên; xuống thấp
= chán/nghi ngờ. "Fine." xuống gắt = KHÔNG ổn thật.

MẸO: nghe và NHẠI nguyên câu (shadowing) cả giai điệu, không chỉ từ. Ghi
âm rồi so sánh. Ngữ điệu + trọng âm câu quyết định độ tự nhiên.',
'Intonation = the rising/falling pitch of the voice; it carries emotion
and signals the sentence type. Wrong intonation sounds robotic or is
misread as an attitude.

BASIC PATTERNS:
  • Falling at the end: statements, WH-questions (asking for info)
      "I live in Boston."      "Where do you live?"
  • Rising at the end: Yes/No questions, unfinished thoughts, checking
      "Are you coming?"        "So... (to be continued)"
  • Rise then fall when listing:
      "I bought apples, oranges, and pears."  (rise mid, fall at end)

UPTALK: rising at the end of a STATEMENT sounds unsure / like a question
-> avoid it when you want to sound certain.

EMOTIONAL FUNCTION: the same "Really?" - high rise = surprise; low fall =
bored/doubtful. A sharp falling "Fine." means it is NOT fine.

TIP: listen and IMITATE whole sentences (shadowing), the melody too, not
just words. Record and compare. Intonation + sentence stress determine how
natural you sound.',
'[]',-620,120),

('n_en_linking','Nối âm (Linking)','English',
'Người Mỹ NỐI các từ khi nói, không tách rời từng chữ -> nghe thành chuỗi
liền. Đây là lý do "đọc thì hiểu mà nghe không kịp".

CÁC KIỂU NỐI:
  1. Phụ âm + nguyên âm: "an apple" -> "a-napple", "turn it on" -> "tur-ni-ton"
  2. Nguyên âm + nguyên âm (chèn /w/ hoặc /j/):
     "go on" -> "gow-on",  "I am" -> "I-yam"
  3. Hai phụ âm giống nhau -> giữ một: "this Saturday" -> "thi-Saturday"
  4. /t/,/d/ + /y/ -> hòa âm: "want you" -> "wanchu", "did you" -> "dijou"

VÍ DỤ chuỗi:
  "What are you doing?" -> "Wha-da-ya-doin?"
  "Give it up"          -> "Gi-vi-dup"

MẸO NGHE: luyện nghe theo CỤM (chunk), đừng cố tách từng từ. MẸO NÓI:
tập nối để miệng quen -> nói trôi hơn và nghe tốt hơn vì hiểu cách âm
biến đổi. Gắn chặt với connected speech.',
'Americans LINK words when speaking, not word by word -> it becomes one
stream. This is why "I can read it but cannot catch it when spoken".

TYPES OF LINKING:
  1. Consonant + vowel: "an apple" -> "a-napple", "turn it on" -> "tur-ni-ton"
  2. Vowel + vowel (insert /w/ or /j/):
     "go on" -> "gow-on",  "I am" -> "I-yam"
  3. Two identical consonants -> keep one: "this Saturday" -> "thi-Saturday"
  4. /t/,/d/ + /y/ -> blend: "want you" -> "wanchu", "did you" -> "dijou"

STREAM EXAMPLES:
  "What are you doing?" -> "Wha-da-ya-doin?"
  "Give it up"          -> "Gi-vi-dup"

LISTENING TIP: train on CHUNKS, do not force word-by-word. SPEAKING TIP:
practice linking so your mouth gets used to it -> smoother speech and
better listening because you understand how sounds change. Tightly tied
to connected speech.',
'[]',-680,170),

('n_en_th','Âm th /θ/ /ð/ & âm khó','English',
'Âm /θ/ và /ð/ (chữ "th") KHÔNG có trong tiếng Việt -> người Việt hay đọc
nhầm thành /t/, /d/, /s/, /z/. Cần luyện riêng.

  /θ/ (vô thanh): think, thank, three, month, bath, both
  /ð/ (hữu thanh): this, that, the, they, mother, breathe

CÁCH TẠO ÂM: đặt ĐẦU LƯỠI chạm nhẹ giữa/hoặc sau răng trên, thổi hơi ra.
/θ/ không rung dây thanh; /ð/ rung.
  ✗ think -> "sink" hay "tink" (sai, rất hay gặp)
  ✓ đầu lưỡi ló ra chạm răng rồi mới bật "th"

CÁC ÂM KHÁC NGƯỜI VIỆT HAY NHẦM:
  • /v/ vs /w/: "vest" (răng chạm môi dưới) ≠ "west" (tròn môi)
  • cụm phụ âm cuối: "asked" /æskt/, "texts" /teksts/ — đừng nuốt
  • /z/ cuối phải RUNG: "is, was, cheese" — đừng thành /s/
  • /l/ cuối (dark L): "feel, milk" — gồng gốc lưỡi

MẸO: soi gương xem lưỡi có ló ra khi nói th không. Luyện cặp tối thiểu
(minimal pairs): think/sink, they/day, vote/... (v vs w).',
'The /θ/ and /ð/ ("th") sounds do NOT exist in Vietnamese -> learners often
swap them for /t/, /d/, /s/, /z/. Drill them separately.

  /θ/ (voiceless): think, thank, three, month, bath, both
  /ð/ (voiced): this, that, the, they, mother, breathe

HOW TO MAKE THEM: put the TONGUE TIP lightly between/behind the upper
teeth and push air out. /θ/ has no vocal-cord vibration; /ð/ vibrates.
  ✗ think -> "sink" or "tink" (a very common error)
  ✓ let the tip show against the teeth, then release "th"

OTHER SOUNDS VIETNAMESE OFTEN CONFUSE:
  • /v/ vs /w/: "vest" (teeth on lower lip) is not "west" (rounded lips)
  • final clusters: "asked" /æskt/, "texts" /teksts/ - do not drop them
  • final /z/ must VIBRATE: "is, was, cheese" - not /s/
  • dark L at end: "feel, milk" - bunch the back of the tongue

TIP: use a mirror to check the tongue shows for th. Practice minimal
pairs: think/sink, they/day, vote vs w-sounds.',
'[]',-760,230)

ON DUPLICATE KEY UPDATE
  label=VALUES(label), category=VALUES(category),
  description=VALUES(description), description_en=VALUES(description_en);
