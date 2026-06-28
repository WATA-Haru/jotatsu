# howWhatWhy

ノートを「**認識のタイプ**」で物理的に隔離し、プロジェクトの達成に近づけるための、
**展開可能なノート手法テンプレート**。

- 運用ルール: [[rule]]
- 設計判断の記録（ADR）: [[adr]]
- 用語集: [[glossary]]

## 4つの認識タイプ

| ファイル | 認識タイプ | ソフト開発の対応物 |
|---|---|---|
| `how.md`   | 事実     | コードとその実行結果 |
| `what.md`  | 達成条件 | テスト |
| `why.md`   | 判断（ADR） | ADR（Nygard 版） |
| `learn.md` | 知見     | lint・規約・harness・ポストモーテム |

各プロジェクトで得た `learn`（知見）は、棚卸しを経て `principles/`（全プロジェクト
横断の一般原則）へ**昇格**する。詳しくは [[rule]]。

## 構成

```
howWhatWhy/
├── README.md                 ← これ
├── rule.md / adr.md / glossary.md
├── principles/               ← learn から昇格した一般原則
├── template/                 ← how / what / why / learn の雛形
├── reviews/                  ← 週次棚卸しの出力（自動生成）
├── .claude/
│   ├── weekly-review.sh          ← 層2: 週次棚卸しエージェント本体
│   ├── weekly-review-prompt.md   ← その指示
│   └── install-review-timer.sh   ← 層2 を systemd timer として有効化
└── <project>/                ← how / what / why / learn
```

## 使い方

### 新しいプロジェクトを始める

`template/` を複製してプロジェクト名のフォルダを作る:

```bash
cp -r template "あなたのプロジェクト名"
```

あとは作業しながら 4 ファイルを埋める。`why.md` は ADR を `# ADR-NNNN: タイトル` で
inline に並べ、増えたら `why/0001-*.md` に分割する（[[rule]] 参照）。

## 知見の昇格と棚卸し（層1 / 層2）

`principles/` を育てるエンジンが「棚卸し」。人間の意志に依存させないのがキモ。

- **層1（任意）**: プロジェクト完了時などに `learn.md` をざっと見て、自分で `principles/` へ。
- **層2（自動・バックストップ）**: 毎週、エージェントが全 `learn.md` を読み、昇格案を
  `reviews/` に出力する（**提案のみ・自動昇格しない**）。

### 層2（週次棚卸し）の有効化

前提: Linux + systemd（user セッション）、`claude` CLI が使えること。

```bash
bash .claude/install-review-timer.sh
```

これで以下が設定される:

- 毎週 **月曜 10:00** に `weekly-review.sh` が走り、`reviews/review-YYYY-MM-DD.md` に昇格案を出力。
- `Persistent=true` のため、PC が寝ていて時刻を逃しても**次回起動時に実行**される。
- エージェントには読み取り系ツールのみ渡すため、vault は**書き換えられない**（提案のみ）。

補助コマンド:

```bash
# 今すぐ手動でテスト実行
bash .claude/weekly-review.sh

# 次回実行予定の確認
systemctl --user list-timers howwhatwhy-review.timer

# ノートPCで、ログアウト中も走らせたい場合
loginctl enable-linger "$USER"

# 停止・削除
systemctl --user disable --now howwhatwhy-review.timer

# スケジュール変更
# ~/.config/systemd/user/howwhatwhy-review.timer の OnCalendar を編集し:
systemctl --user daemon-reload
```

## 実行環境とプライバシー

- 当面は**ローカル実行 + Obsidian Sync**（紛失防止）。
- 将来 always-on にするなら、**自宅サーバ（未使用ミニPC 等）+ Tailscale / WireGuard**。
  外部公開・ssh ポート開放はしない。詳細は [[adr]] の ADR-0009。
- 個人データを載せた**実運用 vault は公開リポジトリに push しない**こと
  （このリポジトリは個人データを含まないテンプレート）。
