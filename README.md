# jotatsu

プロジェクトを回して上達するための個人システム。
中核は、ノートを「**認識のタイプ**」で物理的に隔離する手法 **whatWhyLearn**（what/why/learn）。
jotatsu はその核に、生の作業ノート・運用・捕捉を束ねた傘（展開可能なテンプレート）。

- 運用ルール: [[rule]] / 設計判断（ADR）: [[adr]] / 用語: [[glossary]]

## 3つの層

| 層 | 役割 | 置き場所 |
|---|---|---|
| 記録 | 成功条件 / 判断 / 学び（＋生の作業ノート） | `projects/<project>/` の what/why/learn ＋ note |
| 地図（案内） | 分類・横断・学習の地図 | タグ ＋ MOC（`maps/`） |
| 運用（現在・未来） | 今アクティブか / 抱えすぎ / 頻度 | `index.md` frontmatter ＋ `dashboard.md` |

各プロジェクトの `learn`（知見）は棚卸しを経て `principles/`（一般原則）へ**昇格**する。

## 3つの認識タイプ（核）

| ファイル | 認識タイプ | ソフト開発の対応物 |
|---|---|---|
| `what.md`  | 達成条件 | テスト |
| `why.md`   | 判断（ADR） | ADR（Nygard 版） |
| `learn.md` | 知見（craft） | lint・規約・ポストモーテム |

核に置くのは「現在・確定した情報」だけ（[[adr]] ADR-0016）。加えて各プロジェクトに生の作業ノート
`note.md`（核外・自由記述。log＋「今こうしよう」＋知見の種を混ぜる）を持つ。動く実物やドメイン技術知識は
GitHub / zettelkasten 等の外部に置き、link で参照する（ADR-0017）。

## 構成

```
jotatsu/                     ← vault ルート
├── README.md / rule.md / adr.md / glossary.md
├── dashboard.md              ← 運用トラッカー（Dataview, 要プラグイン）
├── principles/               ← learn から昇格した一般原則（フラット・リンク）
├── maps/                     ← MOC（分類・案内の地図ノート）
├── template/                 ← index / what / why / learn / note の雛形
├── projects/                 ← プロジェクトのフラットな一覧（カテゴリでネストしない）
│   └── <project>/
│       ├── index.md          ← 表紙＋frontmatter（status, cadence, tags, 実態へのlink…）
│       └── what / why / learn / note
└── .claude/
    ├── weekly-review.sh + install-review-timer.sh        ← 層2: learn→principles 昇格案（AI・提案のみ）
    └── portfolio-review.sh + install-portfolio-timer.sh  ← 運用: WIP/停滞チェック（素のbash・push）
```

## 使い方

### 新しいプロジェクトを始める

```bash
cp -r template "projects/あなたのプロジェクト名"
```

`index.md` の frontmatter（status / started / last-touched / tags、稽古系なら cadence / dose）を埋め、
what/why/learn を書き、生の作業は note に書き殴る（実態＝コード等は外部に置き link）。

**粒度の判断**: 達成条件（what）があれば `projects/` のフォルダ、なければカテゴリ＝タグ／MOC。

### 分類・整理

カテゴリ（frontend, 設計…）はフォルダにせず、`maps/` の MOC ノートと frontmatter のタグで表す。
同じプロジェクトを複数の MOC が指せる（重複しない）。

### 運用トラッカー（dashboard.md）

Obsidian の **Dataview** プラグインを入れて `dashboard.md` を開くと、`projects/` を走査して
「active一覧・停滞・WIP件数・全体俯瞰・backlog」が自動表示される。
ルール: 同時 active は**上限5**、active で**14日**ノータッチは「停滞」。

### 捕捉（疲れているとき）

全ルールを守れないときは `inbox.md` に時刻付きで1行放り込む（捕捉と整理を分ける, [[adr]] ADR-0013）。
後で project の note/learn へ振り分けるか、捨てる。**7日**超の未処理は月曜の点検が push で促す。

- 捕捉ショートカット: **QuickAdd** の Capture をホットキー化（`- {{date:YYYY-MM-DD HH:mm}} ` を inbox.md に追記）
- note の日付ログ: コア「**テンプレート**」プラグインの「現在の日付を挿入」をホットキー化

## 自動化（2つの独立した関心事）

| 何 | すること | 起動 | 有効化 |
|---|---|---|---|
| **週次棚卸し** | 全 learn.md を読み principles 昇格案を出す（AI・提案のみ） | 月 10:00 | `bash .claude/install-review-timer.sh` |
| **ポートフォリオ点検** | WIP超過・停滞を検出して push（素のbash・AI不要） | 月 09:00 | `bash .claude/install-portfolio-timer.sh` |

どちらも systemd user timer（`Persistent=true` ＝ 寝ていても次回起動時に取りこぼし実行）。
出力は `reviews/`。停止は `systemctl --user disable --now <unit>.timer`。

## 実行環境とプライバシー

- 当面は**ローカル実行 + Obsidian Sync**。将来 always-on は**自宅サーバ + Tailscale / WireGuard**（[[adr]] ADR-0009）。
- 個人データを載せた**実運用 vault は公開リポジトリに push しない**（このリポジトリはテンプレート）。
