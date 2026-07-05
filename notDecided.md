# notDecided（未決事項・議論の続きから始める用）

このファイルは、対話で結論が出きらなかった論点を「続きから再開できる」形で保存する器。
決着したら ADR / rule / glossary へ移し、ここから消す。
関連: [[adr]] / [[rule]] / [[glossary]]

最終更新: 2026-07-05

---

## 決着済み（参照のみ・再議不要）

- **jotatsu 核は what/why/learn だけ（現在・確定した情報）。log/inbox/実行計画/タスクは核外へ** →
  [[adr]] ADR-0016。中核手法を howWhatWhyLearn → **whatWhyLearn** に改称。物理分離は責務を
  保証しない・保証するのは書く規律、も同 ADR。
- **プロジェクトの形＝ what/why/learn＋生 note.md／実態は外部(GitHub/zettelkasten)＋link／
  learn は craft の知見（ドメイン技術知識は zettelkasten へ）／実行計画は解体／タスクは当面外部ツール**
  → [[adr]] ADR-0017。
- （前セッション）カンバン見送り ADR-0014／how 廃止・log 新設 ADR-0015。

---

## 運用モデル（合意済み）

傘 = jotatsu（1リポジトリ）。

- **核 whatWhyLearn**（what/why/learn）… 現在・確定した情報だけ。
- **projects/<p>/note.md** … 核外・生の working note（log＋roadmap思考＋知見の種を混ぜる）。
- **実態**（動く実物・ドメイン技術知識）… GitHub / zettelkasten 等の外部。frontmatter に link。
- **タスク** … 外部ツール（自作しない）。
- **inbox**（プロジェクト未定の捕捉）… 別レイヤー（住所は下記未決）。

---

## 未決：実物の置き場の細則（ADR-0017 の補足・保留）

- 大枠は ADR-0017（実態は外部＋link）で決着。残る細則: **専用インフラの有無**で同居可否を分ける。
  - 専用インフラ不要（小さいコード・数ファイル）→ concern-dir に**同居可**でもよい（作業しやすさ）。
  - 専用インフラ必要（独立 git 履歴・CI・公開 push・巨大/バイナリ）→ native 一択。
- 運用してみて固まったら ADR 化する。

## 未決：concern「inbox」— 単一かプロジェクト別か

- [[adr]] ADR-0013 は「vault ルート1個」。本人想定は「プロジェクト別」。食い違い未決。
- inbox は核外の別レイヤー（ADR-0016）。この住所論はその設計で決める。

## 未決：稽古系プロジェクトの扱い

- 反復・期限なし・done にならない・cadence/dose で回す。一回性 project と別分岐が要る。
- 標準フロー確定時に rule へ。

## 未決：標準運用フロー（rule.md 確定）

- inbox・稽古系が決まってから確定。

---

## 実装タスク：whatWhyLearn 改称 ＆ 核純化の波及書き換え

- [x] `README.md`（3層の表・認識タイプ表・構成図・how→note・whatWhyLearn 改称・済）
- [x] `glossary.md`（whatWhyLearn 改称・how→note・learn の守備範囲・更新済）
- [x] `rule.md`（着想元・認識タイプ表・2階建て図・ルール・inbox 表記・whatWhyLearn・済）
- [x] `template/`（how.md 削除・note.md 追加・index.md のリンク更新・済）
- [x] `projects/正規表現処理系作成/`（how.md → note.md へ移行・index リンク更新・済）
- [ ] `dashboard.md` / `.claude` スクリプト（運用層を concern 分離する場合のみ・保留）
