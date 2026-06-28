# ADR: howWhatWhy ノート手法の設計判断

この手法（howWhatWhy という note 取り手法そのものの設計）について、
ユーザーと Claude の対話で採用・不採用を決めた経緯を記録する。
形式は Nygard 版（Context / Decision / Consequences）の最小スタート。
運用ルールの要約は [[rule]] を参照。

決定が増えて1ファイルが痛くなったら、`adr/0001-*.md` のように
1決定1ファイルへ分割する（[[rule]] の「ADR の運用」を参照）。

---

# ADR-0001: 認識のタイプでノートを物理的に隔離する（howWhatWhy を採用）

- Status: Accepted
- Date: 2026-06-28

## Context

Zettelkasten のようなものでメモを取ってきたが、事実／解釈／達成条件／経緯が
一緒くたになり、プロジェクト達成に不向きだと感じた。
Zettelkasten は意図的にフラットでアイデア・資料の保存向きであり、
プロジェクトトラッキング向きではない。文脈を区切れず凝縮度が足りない。

## Decision

ドキュメントを how（事実）／what（達成条件）／why（判断）で物理的に隔離する。
ソフトウェア開発の コード／テスト／ADR の対応に着想を得た。

## Consequences

- 書く時に「これは事実か、解釈か、条件か、経緯か」が明確になり、迷いが減る。
- Why not（棄却案）: Zettelkasten 単独で継続 → 文脈を区切れず凝縮度不足のため棄却。

---

# ADR-0002: 4つ目のバケツ `learn`（知見）を追加

- Status: Accepted
- Date: 2026-06-28

## Context

how/what/why の3バケツに対し、当初分離したかった認識は4種類あった
（事実／解釈／達成条件／経緯）。「解釈」の居場所が無かった。
さらに、実務のコードも lint・規約・harness のような規範知に支えられており、
「学んだこと・アンチパターンの防止・どうすればうまくいくか」をまとめる場所が、
人間のメモには最も重要だと判明した。

## Decision

`learn.md` を追加する。how/what/why の3分割の美しさは犠牲にするが、
当初の4分類に忠実にする。

## Consequences

- 「最も重要な知見」を捨てずに済む。
- Why not（検討した代替案と不採用理由）:
  - why に統合 → 教訓は判断とは独立に再利用されるため不適。
  - how 内で明示分離 → 事実と解釈を混ぜると隔離の意図が薄れる。
  - すべて別所に逃がす → 未蒸留の知見で溢れる。
    一旦 `learn` に溜め、蒸留後に昇格する案（ADR-0004）を採用。

---

# ADR-0003: `learn.md` は「解釈」と「教訓」を両方持つ

- Status: Accepted
- Date: 2026-06-28

## Context

「特定結果の解釈（なぜ落ちたか）」と「一般化した教訓（こうすべき）」は
本来別物である（後ろ向き／前向き、寿命も異なる）。これを分けるべきか。

## Decision

同じ `learn.md` に両方入れる。書く時に迷わないことを優先する。
問題が出たら後で分離する。

## Consequences

- 運用開始時の境界判断コストが下がる。
- Why not: 解釈は how の結果欄・教訓は learn と最初から分ける案は、
  境界判断のコストが高く迷いを生むため見送り。

---

# ADR-0004: 知見の昇格ルール = 同じ知見が3回出たら `principles/` へ

- Status: Accepted
- Date: 2026-06-28

## Context

`learn` → `principles` への昇格トリガーを決めないと、
`principles` が育たないか、逆に未成熟な知見で溢れる。

## Decision

同じ知見が3回出てきたら `principles/` に昇格させる。

## Consequences

- 昇格基準が明確になり、`principles` が一定の品質で育つ。
- Why not: 手動・気づいたら昇格 → 基準が無く属人的になり育たない懸念で棄却。

---

# ADR-0005: principles/ を最上位とし、Zettelkasten は一旦スコープ外にする

- Status: Accepted
- Date: 2026-06-28

## Context

当初は Zettelkasten を howWhatWhy 内に「2階建てで同居」させる案を検討した。
しかし設計を単純に保つため、Zettelkasten は一旦スコープ外とする。

## Decision

`principles/` を howWhatWhy 内の「全プロジェクト横断の一般法則」の最上位の知識層とする。
将来 `principles/` の中から、プロジェクトを超えてさらに普遍的・時間に依らない知見が出てきたら、
howWhatWhy と**同じ階層（兄弟ディレクトリ）の `zettelkasten/`** へ移す。
ただし `zettelkasten/` の設計は今はしない。

## Consequences

- 設計が単純になる。昇格チェーンは `learn` → `principles`（→ 将来 `zettelkasten`）。
- 一般知が深い階層に埋もれず「上に浮上」するため、階層の深さ問題（課題2）は引き続き緩和される。
- 当初の課題3「Zettelkasten との使い分け」は一旦保留。必要になった時点で別途設計する。
- Why not: Zettelkasten を howWhatWhy 内に同居させる案 → 設計が複雑になるため見送り。

---

# ADR-0006: ADR は Nygard 版・1ファイル1決定を標準とし、最小から始める

- Status: Accepted
- Date: 2026-06-28

## Context

ADR を1ファイルにまとめるか、1決定1ファイルにするか。
また、最初に採用するテンプレートをどれにするか。

## Decision

テンプレートは Nygard 版（Context / Decision / Consequences + Status / Date）を採用する。
各プロジェクトは `why.md` 1枚に inline で複数決定を書いて始め（最小スタート）、
決定が増えて痛くなったら `why/0001-*.md` の1決定1ファイルへ昇格する。

## Consequences

- 不変・追記専用・隔離・安定参照という ADR の利点を、必要になった時点で得られる。
- 「迷わない運用優先、問題が出たら後で分離」（ADR-0003）と一貫する。
- Why not: 最初から1決定1ファイルに分割 → 小規模では過剰で、運用開始の摩擦が大きいため見送り。
