-- ĐĂNG KÝ edges cho topic Tiếng Anh Mỹ (part-of + vài related)
INSERT INTO kg_edges (id,source,target,type) VALUES
-- root -> topic
('e_root_t_en','root','t_en','part-of'),
-- topic -> sections
('e_t_en_s_en_pron','t_en','s_en_pron','part-of'),
('e_t_en_s_en_chunk','t_en','s_en_chunk','part-of'),
('e_t_en_s_en_grammar','t_en','s_en_grammar','part-of'),
('e_t_en_s_en_tenses','t_en','s_en_tenses','part-of'),
('e_t_en_s_en_verbs','t_en','s_en_verbs','part-of'),
('e_t_en_s_en_native','t_en','s_en_native','part-of'),
-- section Phát âm -> leaf
('e_s_en_pron_ipa','s_en_pron','n_en_ipa','part-of'),
('e_s_en_pron_r','s_en_pron','n_en_r','part-of'),
('e_s_en_pron_t','s_en_pron','n_en_t','part-of'),
('e_s_en_pron_schwa','s_en_pron','n_en_schwa','part-of'),
('e_s_en_pron_wordstress','s_en_pron','n_en_wordstress','part-of'),
('e_s_en_pron_sentencestress','s_en_pron','n_en_sentencestress','part-of'),
('e_s_en_pron_intonation','s_en_pron','n_en_intonation','part-of'),
('e_s_en_pron_linking','s_en_pron','n_en_linking','part-of'),
('e_s_en_pron_th','s_en_pron','n_en_th','part-of'),
-- section Chunking -> leaf
('e_s_en_chunk_chunking','s_en_chunk','n_en_chunking','part-of'),
('e_s_en_chunk_connected','s_en_chunk','n_en_connected','part-of'),
('e_s_en_chunk_rhythm','s_en_chunk','n_en_rhythm','part-of'),
-- section Grammar -> leaf
('e_s_en_grammar_wordorder','s_en_grammar','n_en_wordorder','part-of'),
('e_s_en_grammar_articles','s_en_grammar','n_en_articles','part-of'),
('e_s_en_grammar_nouns','s_en_grammar','n_en_nouns','part-of'),
('e_s_en_grammar_pronouns','s_en_grammar','n_en_pronouns','part-of'),
('e_s_en_grammar_adj_adv','s_en_grammar','n_en_adj_adv','part-of'),
('e_s_en_grammar_prepositions','s_en_grammar','n_en_prepositions','part-of'),
('e_s_en_grammar_modals','s_en_grammar','n_en_modals','part-of'),
('e_s_en_grammar_conditionals','s_en_grammar','n_en_conditionals','part-of'),
('e_s_en_grammar_passive','s_en_grammar','n_en_passive','part-of'),
('e_s_en_grammar_reported','s_en_grammar','n_en_reported','part-of'),
('e_s_en_grammar_questions','s_en_grammar','n_en_questions','part-of'),
('e_s_en_grammar_gerund_inf','s_en_grammar','n_en_gerund_inf','part-of'),
-- section Tenses -> leaf
('e_s_en_tenses_map','s_en_tenses','n_en_tenses_map','part-of'),
('e_s_en_tenses_present','s_en_tenses','n_en_present','part-of'),
('e_s_en_tenses_past','s_en_tenses','n_en_past','part-of'),
('e_s_en_tenses_future','s_en_tenses','n_en_future','part-of'),
-- section Verbs -> leaf
('e_s_en_verbs_s_es','s_en_verbs','n_en_s_es','part-of'),
('e_s_en_verbs_ed','s_en_verbs','n_en_ed','part-of'),
('e_s_en_verbs_ing','s_en_verbs','n_en_ing','part-of'),
('e_s_en_verbs_irregular','s_en_verbs','n_en_irregular','part-of'),
('e_s_en_verbs_plural_irregular','s_en_verbs','n_en_plural_irregular','part-of'),
-- section Native -> leaf
('e_s_en_native_contractions','s_en_native','n_en_contractions','part-of'),
('e_s_en_native_phrasal','s_en_native','n_en_phrasal','part-of'),
('e_s_en_native_idioms','s_en_native','n_en_idioms','part-of'),
('e_s_en_native_slang','s_en_native','n_en_slang','part-of'),
('e_s_en_native_fillers','s_en_native','n_en_fillers','part-of'),
('e_s_en_native_smalltalk','s_en_native','n_en_smalltalk','part-of'),
('e_s_en_native_collocations','s_en_native','n_en_collocations','part-of'),
('e_s_en_native_am_vs_br','s_en_native','n_en_am_vs_br','part-of'),
('e_s_en_native_politeness','s_en_native','n_en_politeness','part-of'),
-- related (liên kết chéo ý nghĩa)
('e_en_schwa_wordstress','n_en_schwa','n_en_wordstress','related'),
('e_en_wordstress_sentencestress','n_en_wordstress','n_en_sentencestress','related'),
('e_en_sentencestress_rhythm','n_en_sentencestress','n_en_rhythm','related'),
('e_en_linking_connected','n_en_linking','n_en_connected','related'),
('e_en_connected_contractions','n_en_connected','n_en_contractions','related'),
('e_en_s_es_nouns','n_en_s_es','n_en_nouns','related'),
('e_en_ed_irregular','n_en_ed','n_en_irregular','related'),
('e_en_ing_gerund_inf','n_en_ing','n_en_gerund_inf','related'),
('e_en_present_s_es','n_en_present','n_en_s_es','related'),
('e_en_tenses_irregular','n_en_tenses_map','n_en_irregular','related')
ON DUPLICATE KEY UPDATE
  source=VALUES(source), target=VALUES(target), type=VALUES(type);
