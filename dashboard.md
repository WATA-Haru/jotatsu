# Dashboard — いま全体で何をしているか

`projects/` を走査して自動生成。**手で更新しない。**
（要 Obsidian コミュニティプラグイン **Dataview**。クエリは環境に応じて微調整が要る場合あり）

## 📊 WIP（同時 active は上限 5）

```dataview
TABLE WITHOUT ID length(rows) AS "active 件数 / 上限 5"
FROM "projects"
WHERE status = "active"
GROUP BY true
```

## ▶ Active（最終更新が古い順）

```dataview
TABLE WITHOUT ID file.folder AS プロジェクト, last-touched AS 最終更新, cadence AS 頻度, dose AS 一日量
FROM "projects"
WHERE status = "active"
SORT last-touched ASC
```

## ⚠ 停滞（active かつ 14日以上ノータッチ → 再開 / paused / dropped を決める）

```dataview
TABLE WITHOUT ID file.folder AS プロジェクト, last-touched AS 最終更新
FROM "projects"
WHERE status = "active" AND date(last-touched) < date(today) - dur(14 days)
SORT last-touched ASC
```

## 🗺 全体俯瞰（状態ごと）

```dataview
TABLE WITHOUT ID rows.file.folder AS プロジェクト
FROM "projects"
WHERE status
GROUP BY status AS 状態
```

## 📥 Backlog

```dataview
TABLE WITHOUT ID file.folder AS プロジェクト, tags
FROM "projects"
WHERE status = "backlog"
```
