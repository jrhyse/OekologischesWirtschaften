# Cultural Policy Manifesto Analysis — methodological experiment log

**Status:** Working research README, revised 16 November 2026  
**Scope:** Exploratory analysis of election manifestos; development of an evidence-based cultural-policy codebook; proposed CHES-inspired measurement experiment; possible later transfer to parliamentary *Drucksachen*.  

## 1. Research purpose

The project is experimenting with a human–AI workflow for identifying, comparing, and eventually measuring party positions on cultural policy. The immediate pilot uses German 2025 national election manifestos. The longer-term aim is a transparent, reproducible coding procedure that could extend across countries and genres of political text, including parliamentary documents.

The work has **not yet reached validated formal coding**. The initial exercises are **open, top-level topic assessment and keyword generation**. Their purpose is to discover salient concepts, clarify what counts as cultural policy, identify textual boundaries, and supply evidence for constructing a formal codebook. This distinction is fundamental: exploratory thematic descriptions are not numerical party-position estimates.

## 2. Evidence and files inspected for this README

The following workbook files were available and inspected on 16 November 2026:

| File | Role | What was observed |
| --- | --- | --- |
| `01_manifesto_sampling_DE_jre' and 02_manifesto_sampling_DE_sc.xlsx` | Human coder JRE and SC - first exploratory assessments | Eight German national-election party rows contain `culture_wordcount`, `first_last`, `culture_salience_keywords`, and `culture_salience_open_notes`; formal `culture_salience_score` is blank. |
| `01_manifesto_sampling_DE_IT_blank_agent.xlsx` | Independent-agent input template | Blank analytical fields; an `Agent task` worksheet specifies scope, source-only analysis, neutrality, evidence traceability, and a firewall against earlier assessments. |
| `03_manifesto_sampling_DE_Agent1_completed.xlsx` and `04_manifesto_sampling_DE_Agent2_completed.xlsx`| ChatGPT's exploratory output | Eight German national-election party rows contain word counts, spans, **in-vivo** keywords, **other/analytical** keywords, and open notes; `culture_salience_score` is blank. The task sheet explicitly distinguishes the two keyword types. |

The README also records methodological decisions and proposals from project discussions. **The original manifesto PDFs were not re-audited for this README**.

### Pilot sampling unit

- **Country/election:** Germany, 2025 Bundestag election.
- **Party rows:** CDU/CSU, SPD, FDP, Bündnis 90/Die Grünen, Die Linke, AfD, BSW, Freie Wähler (nine rows).
- **Distinct source manifestos:** eight, because CDU and CSU share a joint programme. Retain party-level records but identify the shared document for document-level statistics.
- **Cross-national ambitions:** Germany, Italy, and Poland have been discussed; the complete proposed five-country list has not been confirmed in the available discussion. Do not assume the other two countries or the election years.

## 3. Experimentation so far:

### 3.1 Initial sampling and research design — observed/planned

A sampling workbook was developed to link party/election records with manifesto metadata and, eventually, party identifiers (including CHES IDs and possible OpenMusE harmonisation). The unit is the party–election manifesto, with a caution that party names alone are not stable merge keys. The project has also discussed cultural-policy salience, trust/low-information responses, and a three-point scale plus confidence for a later formal coding exercise. Those ideas are not implemented in the exploratory workbook fields and should not be retroactively attributed to the first pass.

### 3.2 Human open assessments — observed

JRE and SC's workbooks record four exploratory fields for the eight German party rows:

- `culture_wordcount`: estimated or counted words in the passage considered relevant;
- `first_last`: beginning and ending markers for the assessed passage;
- `culture_salience_keywords`: salient phrases/themes;
- `culture_salience_open_notes`: open, descriptive notes on the relevant cultural-policy material.

These fields were meant to support codebook generation from the discovered vocabulary, not to constitute formal scoring.

### 3.3 Independent AI replication design — observed instructions; execution status to verify

A blank version of the sampling workbook was prepared with a separate `Agent task` sheet. The independent assessor was instructed to:

1. Read only the original manifestos, the project background, and the supplied task instructions.
2. Work only on German 2025 national-election rows.
3. Identify the substantive cultural-policy passage and record its start/end with section/page references where available.
4. Estimate/count the relevant passage's words, generate salient keywords, and write neutral, source-traceable open notes.
5. Leave formal scoring fields blank.
6. Avoid access to human assessments, other agents' outputs, and subsequent reconciliation material.

The pathway of creating separate chats within the project and including explicit firewall instructions was decided as a practical isolation mechanism. This is an operational precaution, **not a guarantee of technical isolation**: shared project instructions, files, memory/context, or other retained materials must be checked explicitly.

### 3.4 ChatGPT's parallel exploratory pass — observed

Two instances of ChatGPT were given the same general task and manifesto dataset, and the resulting workbooks are present as `03_manifesto_sampling_DE_Agent1_completed.xlsx` and `04_manifesto_sampling_DE_Agent2_completed.xlsx`. They include complete exploratory entries for the eight German party rows. The task specification adds an important distinction:

- `culture_salience_keywords_in_vivo`: terms/phrases presented as occurring in the source text;
- `culture_salience_keywords_other`: analyst-generated thematic keywords, in German.

A previous qualitative review found this separation useful for codebook development.

### 3.5 Complete comparison of exploratory spans and word counts — observed

The following table transcribes **eight German 2025 party rows** from the two human workbooks. The coders' reported `culture_wordcount` values are shown side by side; the difference is **JRE minus SC**. Short opening markers are taken from each workbook's `first_last` field. These are *recorded assessments*, not independently re-counted PDF passages.

| Party | SC: words / recorded opening | JRE: words / recorded opening | Difference (JRE − SC) | Comparison of recorded span markers |
| --- | --- | --- | ---: | --- |
| CDU | **1,622** — “Ja zu Leitkultur und Zusammenhalt” | **1,040** — “Freiheit leben und Kultur fördern” | **−582** | **Different opening scope:** broader chapter versus dedicated culture subsection; ending references cultural cooperation/funding, with slightly different quoted lengths. |
| SPD | **697** — “Wir fördern kulturelle Teilhabe” | **1,087** — “Wir kämpfen für Medienvielfalt, für Vielfalt in Kunst und Kultur und für einen starken Sport” | **+390** | **Different opening scope:** JRE starts at chapter 18; SC starts at the cultural-participation passage. Both end at the games/creative-diversity passage. JRE reports excluding an intervening sports paragraph. |
| FDP | **228** — “Vielfältige Kunst und Kultur” | **229** — “e. Vielfältige Kunst und Kultur” | **+1** | Essentially matching opening and closing markers; likely counting convention, pending text audit. |
| Bündnis 90/Die Grünen | **770** — “Für lebendige Kunst und Kultur” | **730** — “Für lebendige Kunst und Kultur” | **−40** | Matching named section and e-lending endpoint; count differs despite apparently equivalent boundaries. |
| Die Linke | **545** — “Medien und Kultur für eine plurale Gesellschaft” | **519** — “19. Medien und Kultur für eine plurale Gesellschaft” | **−26** | Matching chapter and closing funding-programme sentence; counting or internal inclusions need checking. |
| AfD | **965** — “Deutsche Leitkultur statt „Multikulturalismus“” | **914** — “Kultur und Medienpolitik” | **−51** | JRE includes a chapter heading before SC's opening; both end at the creative/economic-freedom passage. Lower count cannot be explained from headings alone. |
| BSW | **640** — “Medien und Kultur: Meinung statt Maulkorb” | **582** — “Medien und Kultur: Meinung statt Maulkorb” | **−58** | Matching section and closing artists' social-insurance passage; count needs independent verification. |
| Freie Wähler | **821** — “Kultur und Medienvielfalt für Deutschland” | **818** — “Kultur und Medienvielfalt für Deutschland” | **−3** | Matching section and final youth-media-protection sentence; near-identical counts. |

**Interpretation:** CDU/CSU and SPD provide clear evidence of **non-equivalent recorded opening boundaries**. For most other parties, the documented starts and ends are substantially similar even where word counts differ. The AfD has a heading-level opening difference but its word-count discrepancy is not explained by that fact. It would be premature to call every numerical difference a passage-boundary disagreement: extraction, hyphenation, punctuation, counting rules, and whether intermediate adjacent-policy paragraphs are included may all matter. Neither workbook documents a reproducible counting script. A subsequent audit should extract the exact passage text for each distinct source, compare offsets and excluded subspans, and re-count with one frozen tokenizer. **CDU/CSU must be counted once in document-level discrepancy statistics.**

### 3.6 Proposed CHES-inspired semantic-differential experiment — planned

The next methodological idea is to derive a set of **anchored 0–10 cultural-policy dimensions** from the exploratory evidence and test whether independent assessments can locate manifesto statements on those dimensions. Candidate areas discussed include:

- Public responsibility and financing versus predominantly private/market provision;
- Cultural pluralism versus prioritisation of a unified national cultural identity;
- Artistic autonomy versus explicit instrumental or political direction;
- Cultural participation and access;
- Interpretations of cultural heritage and continuity;
- Centralised versus decentralised cultural governance;
- Culture as public/social good versus economic/industrial resource;
- International cultural exchange versus national cultural prioritisation.

**These are candidate constructs, not an adopted codebook.** Several apparently bipolar pairs may in fact contain independent dimensions. For instance, support for public funding can coexist with a market-oriented creative sector; instrumental objectives can coexist with artistic freedom. The proposed exercise must test and, where necessary, split these constructs before scoring.

A simulated 'expert panel' would consist of multiple independently executed, evidence-based AI assessments using identical definitions, rather than an assertion that the model is a panel of real political scientists. The experiment may compare within-model reproducibility, cross-model agreement, and ultimately human–AI agreement. **No completed CHES-style scores are documented here.** Simulated estimates must not be represented as official CHES data or human expert judgments.

### 3.7 Transfer to parliamentary *Drucksachen* — planned, not completed

The project has discussed assembling a Bundestag corpus, initially **2024–2025** and prioritising **Anträge** (motions), with a machine-readable inventory containing at least:

`document_id`, `date`, `party`, `document_type`, `title`, `full_text_link`.

The DIP parliamentary-document system/API and access-key process were discussed as possible retrieval infrastructure. **This README does not establish that the corpus has been downloaded, that an API key has been obtained, or that a crawler is running.** The manifesto pilot is intended to validate concepts and procedures before scaling to a corpus where identifying relevant cultural-policy documents and passages is itself a substantial task.

## 4. Key methodological distinctions to preserve

| Distinction | Why it matters |
| --- | --- |
| **Topic discovery vs formal coding** | Open keywords/notes are inputs to category construction, not reliable numeric position scores. |
| **Source vocabulary vs analyst vocabulary** | In-vivo expressions support audit and retrieval; analytical terms support abstraction and comparison. Do not conflate them. |
| **Passage-level vs manifesto-wide coverage** | Dedicated culture sections may omit scattered references to language, heritage, education, media, identity, or creative industries. |
| **Salience vs position** | How much a manifesto discusses culture is distinct from what policy it advocates. |
| **Topic vs stance vs policy instrument** | A mention of funding, heritage, or media does not itself indicate whether the party advocates expansion, restriction, reform, or another action. |
| **Culture vs adjacent domains** | Media, broadcasting, education, sport, language, memory politics, and digital/creative industries need explicit inclusion/exclusion or overlapping-code rules. |
| **Party row vs unique document** | CDU and CSU share a manifesto; do not double-count their joint text as two independent documents. |
| **Moderation vs missing evidence** | Silence on a dimension is `not_assessable`, not a midpoint score. |
| **Reproducibility vs validity** | AI agreement may reflect shared assumptions; it does not prove that a construct is well measured. |

## 5. Recommended development roadmap

**Intended endpoint:** a **version-controlled, executable coding pipeline in Python or R**, with transparent extraction, retrieval, classification, evidence storage, evaluation, and human adjudication. LLMs may help develop the taxonomy, create candidate labels, or serve as optional benchmark systems, but **the production coding need not occur inside an LLM**. The pilot should establish what can be measured reliably by auditable rules and conventional or transformer-based statistical models before introducing generative components.

### Technical feasibility: RAG, content analysis, and sentiment/stance tools

**Feasibility assessment (design proposal, not an implemented or benchmarked system):**

| Task | Feasibility with existing Python/R tools | Appropriate method and limits |
| --- | --- | --- |
| PDF extraction, text segmentation, metadata and offsets | **High**, subject to source quality | Python: PyMuPDF, pdfplumber; R: `pdftools`. Keep page numbers, character offsets, document hashes, extraction version, and OCR flags. PDF layouts and OCR errors require checks. |
| Finding cultural-policy passages in a large *Drucksachen* corpus | **High for candidate retrieval; recall must be tested** | Combine dictionaries/BM25 with multilingual sentence embeddings and a vector index (e.g. FAISS or pgvector). R: `quanteda`, `text2vec`; Python: `scikit-learn`, `sentence-transformers`. Use retrieval-augmented analysis, not necessarily generation. |
| Coding explicit topics, instruments, named institutions, and mentions | **High to moderate** | Rules/dictionaries (`quanteda`, spaCy, regex) plus supervised multilabel classifiers. Codebook definitions, negation and context handling, and human-reviewed training examples are essential. |
| Detecting policy stance (support, oppose, reform, restrict) | **Moderate; more demanding than topic detection** | Sentence-/passage-level supervised stance classifiers or entailment-style models, trained/tested on human labels; attach evidence and abstain when ambiguous. Simple positive/negative sentiment is **not** a valid substitute for stance toward a specified policy target. |
| General sentiment or emotional tone | **Technically straightforward, limited substantive relevance** | R: `quanteda`, `tidytext`; Python: lexicons and transformer classifiers. Sentiment can be an auxiliary descriptive feature, but “negative” text may support, oppose, or criticize different targets. Cross-language lexicons require validation. |
| Anchored 0–10 cultural-policy position estimates | **Feasible as a research experiment; hardest to validate** | Define document-level aggregation rules or supervised ordinal/regression models using sufficiently numerous human-anchored examples. Preserve `not_assessable`, contradictory evidence, and uncertainty; avoid deriving a numerical scale directly from sentiment or embedding proximity. |
| Cross-national generalisation and reproducibility | **Feasible with substantial validation work** | Multilingual embeddings and source-language models can help, but test each country/language separately, check conceptual equivalence, domain shift, calibration, and failure modes. |

**Clarifying “RAG”:** retrieval-augmented generation conventionally combines document retrieval with a *generative* model. The project can retain its useful **retrieval architecture** (keyword search + semantic search + passage citations) without a generative model at coding time. If generation is used during experimentation, distinguish its outputs from the deterministic retrieval index and from the final, reproducible coding algorithm.

**Recommended architecture:** `raw PDF / parliamentary record → parsed and segmented text → keyword + embedding retrieval → candidate cultural-policy passages → topic/instrument classifiers → target-specific stance or ordinal-position model → evidence-linked document/party aggregation → uncertainty flags → stratified human review → versioned output`. Keep all passage offsets and intermediate model outputs so that any score can be traced back to original text. A fixed random seed and pinned software/model versions improve reproducibility but do not replace validation.

**Crucial constraint:** eight distinct German manifestos are far too few to train and evaluate a credible high-dimensional supervised position model by themselves. The manifesto pilot can define constructs and supply seed annotations; reliable supervised coding will require a larger, manually labelled set of *passages* spanning parties, countries, document genres, and negative examples. Avoid splitting training/test data by random passage alone when passages from the same document or party could leak across splits. Prefer held-out documents and, where possible, held-out country/genre tests.

**Python versus R:** Python is a practical primary implementation for multilingual embeddings, vector retrieval, and transformer classifiers; R is excellent for corpus management, dictionary-based content analysis, statistical measurement, reliability analysis, and publication workflows. A Python pipeline with R-based evaluation/reporting—or a mostly R workflow calling precomputed embedding/classification outputs—is entirely plausible. The choice should follow team expertise and deployment constraints, not an assumption that LLMs are required.

### Phase A — Lock and audit the exploratory evidence

1. Preserve copies of human and any subsequent independent-agent runs. Add timestamps, model/version, exact task prompts, and available inputs.
2. Establish a common **span convention**: main dedicated cultural-policy section, all relevant passages throughout the manifesto, or both as separate measures. Record page, section, opening/closing quotations, and extraction method.
3. Verify a sample (ideally all) of in-vivo keywords, quotations, page references, and word counts against the PDFs. Record discrepancies and corrections separately from the original outputs.
4. Agree on handling of disputed keywords or interpretations regarding media/broadcasting, cultural education, heritage, language, sport, memory politics, and dispersed mentions.


### Phase B — Build a preliminary codebook

1. Compare human and independent agent findings for **thematic convergence, unique themes, and differences in granularity**, not numerical intercoder reliability.
2. Cluster keywords inductively; retain an audit trail from each proposed category to the original in-vivo terms and passages.
3. Organise the codebook into at least three distinct layers: **policy domains** (what is discussed), **policy instruments** (what is proposed), and **normative/positional frames** (how it is justified or oriented).
4. Write inclusion/exclusion rules, boundary cases, counterexamples, and multilingual equivalence notes. Avoid defining categories solely around German political vocabulary.
5. Version the codebook; do not revise it midway through supposedly comparable independent runs without re-coding earlier material.

### Phase C — Pilot CHES-inspired positional measurement

1. Select a parsimonious set of non-redundant cultural-policy constructs (initially approximately six to eight).
2. For each 0–10 dimension, define both endpoints, intermediate anchors (e.g., 2/5/8), the unit of inference, and `not_assessable` rules.
3. Test whether dimensions are truly bipolar. Split 'public support vs privatisation' and 'instrumentalism vs autonomy' where evidence supports two independent variables.
4. Require each assessment to return: `country`, `party`, `document_id`, `dimension_id`, `position`, `confidence`, `evidence_quote`, `page_or_section`, `rationale`, `assessor_id`, and `instrument_version`.
5. Run independent, same-instrument assessments; retain individual outputs, not only an average. Flag cases with weak evidence or wide disagreement for human adjudication.
6. Check repeated-run stability and cross-model agreement; later validate a subset against genuinely independent human political scientists.

### Phase D — Cross-national adaptation

1. Confirm the **five countries**, party samples, election years, languages, and comparable source genres.
2. Test definitions on a small manifesto sample from every country **before** finalising the scales; seek country-specific boundary cases.
3. Use source-language evidence and preserve original quotations; document translation and conceptual equivalence decisions.
4. Distinguish institutional structure (federal, regional, municipal, arm's-length) from substantive policy positions.
5. Compare missingness and interpretability by country; do not assume a dimension has equivalent meaning merely because the scale labels translate.

### Phase E — Parliamentary-document retrieval and scaled analysis

1. Build and preserve the raw Bundestag *Anträge* inventory (2024–2025) with stable identifiers and links; document the DIP/API query and collection dates.
2. Develop a **retrieval stage** to find potentially relevant cultural-policy documents/passages. Include both keyword and semantic approaches; log false positives and false negatives.
3. Manually label a stratified retrieval test set, including hard negatives (e.g., incidental uses of *Kultur*) and ambiguous adjacent-policy cases.
4. Apply the codebook to a held-out, human-reviewed sample before processing the full corpus. Evaluate **retrieval performance separately from coding performance**.
5. Store document metadata, extracted text, passage offsets, evidence, model/prompt/codebook versions, confidence, and review status. Support reprocessing and correction.
6. Expand to other document types only after checking genre-specific changes in how parties express positions (e.g., motions versus questions or government responses).

### Phase F — Implement and validate the non-LLM production coder

1. Freeze a human-adjudicated, source-linked gold standard, with negative and ambiguous cases and explicit annotation guidelines. Include country, party, document, passage offsets, policy target, category, and stance/position labels.
2. Implement reproducible ingestion and hybrid retrieval in Python/R. Measure passage-retrieval **recall and precision** on held-out data before treating downstream coding as complete.
3. Establish simple baselines first: exact/dictionary rules, TF–IDF or BM25, and conventional supervised classifiers. Add multilingual embeddings and contextual classifiers only where they improve held-out performance.
4. Train and evaluate **topic classification, policy-target identification, stance classification, and document-level position estimation separately**. Report per-category precision/recall/F1, confusion matrices, missingness, and (if an ordinal scale is used) appropriate ordinal error and calibration statistics. Do not infer ideological positions from generic sentiment alone.
5. Use grouped evaluation splits (document, party, country, time, and genre as relevant); inspect class imbalance, hard negatives, low-confidence predictions, and distribution shifts. Record all models, thresholds, training sets, random seeds, software versions, and codebook versions.
6. Implement a review queue for low-confidence, contradictory, or novel cases; save human adjudications as new versioned training data. Keep LLM-assisted suggestions separate from the independent human gold standard.
7. Only after adequate held-out performance, apply the pipeline to the full *Drucksachen* corpus and report error bounds, coverage, abstention rates, and manual audit results. Treat new countries or document genres as fresh validation settings.

**Deliverable:** Executable Python/R repository, pinned environment, retrieval index, versioned annotation set, validated coding models, machine-readable evidence log, and reproducible evaluation report. A non-LLM system may still use pretrained embedding or transformer models; the requirement is that **production decisions are explicit, testable, reproducible software outputs**, not opaque ad hoc chat judgments.

## 6. Quality assurance and interpretation

- **Source fidelity:** Do not accept exact-looking counts or 'in-vivo' labels without verification against source text.
- **Blindness:** Independent runs should use separate inputs and outputs; record which shared project materials were visible. A new chat alone is not proof of isolation.
- **Reliability:** Before categories are fixed, compare thematic overlap and boundaries qualitatively. After formal coding, calculate agreement appropriate to the variable type, missingness, and sample design; report uncertainty and prevalence.
- **Validity:** Check whether a score follows from cited statements, whether the scale captures a coherent construct, and whether alternative interpretations are plausible.
- **Missing information:** Distinguish `not_mentioned`, `ambiguous`, `conflicting_statements`, and `not_assessable` as appropriate. Do not interpret silence as ideological moderation.
- **Versioning:** Keep original model outputs immutable. Corrections, adjudications, and harmonised datasets should be separate derivatives with recorded provenance.
- **Reporting accuracy:** Explain clearly for readers that a model-generated panel is a simulation.

## 7. Reporting language for a methods section (draft)

> We began with an exploratory assessment of cultural-policy material in German 2025 national election manifestos. The first human-led pass identified relevant textual spans, estimated their length, extracted salient keywords, and produced open thematic notes. An independent AI-assisted exercise was designed to replicate this descriptive task without access to earlier assessments. Parallel model-generated workbooks additionally distinguished expressions drawn from the manifestos from analyst-generated thematic keywords. These exercises were intended to inform inductive codebook construction. Subsequent stages are planned to reconcile textual boundaries, verify source fidelity, construct operational categories and anchored cultural-policy dimensions, and test the reproducibility and validity of AI-assisted assessment before extending the procedure across countries and to parliamentary documents.

---

**Maintenance rule:** Update this README whenever a new pass, prompt, codebook version, corpus extraction, or validation exercise is completed. Distinguish completed evidence from methodological proposals and record the date, file/version, and reviewer for each update.
