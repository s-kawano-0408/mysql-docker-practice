# CLAUDE.md — 引き継ぎ資料（Claude Code 用）

このファイルは Claude Code がこのリポジトリで作業する際のコンテキストです。
作業前に必ず全体を読んでください。

## プロジェクト概要

- プロジェクト名: `mysql-docker-practice`
- 目的: 課題「MySQL」をローカル環境で実施し、GitHub で管理する
- オーナー: Seiya（学習目的。説明は日本語で、初学者にも分かるように）

## ⚠️ 最重要: 進め方のルール（毎回必ず守る）

オーナーは **Docker も SQL もまったく初めて**。目的は「課題を終わらせること」ではなく「**本人が理解して、自分で手を動かせるようになること**」。

- **先回りして作業を全部やらない**。1回の返答で進めるのは 1 ステップだけ
  - 過去に Claude が課題を一気に最後まで実行してしまい、「何も分からない」と止められた経緯がある
- 新しいものが出てきたら、まず **「それは何か・なぜ必要か」** を身近なたとえで説明する
  - 例: イメージ = 箱の設計図、コンテナ = 実際の箱、docker-compose.yml = 箱の作り方メモ
- ファイルは **1 行ずつコメント付き** で中身を説明する。全部覚えなくてよいので「今はここだけ分かればOK」というポイントを示す
- ファイルの作り方（エディタで新規作成 → 名前を付けて保存 など）や、コマンドをどこで打つかも省略しない
- 説明のあとは **次に何をするかを本人に選んでもらう / 質問を受ける**。理解を確認してから次へ進む
- 専門用語は使ったらすぐ言い換える。長い一覧より短い区切りで

## 学習の進捗（次回はここから再開）

| 日付 | 内容 |
|---|---|
| 2026-11-02 | Claude がクラウド環境で課題(1)(2)を一通り実行・push 済み（`sql/`・`docs/log.md` は完成版がある）。ただし本人はまだ中身を理解していない |
| 2026-11-02 | 説明済み: Docker とは（イメージ / コンテナ）、Dockerfile が今回不要な理由、`docker-compose.yml` の各行の意味、YAML は字下げで階層を表すこと |

| 2026-11-02 | 本人の回答: **進め方は A（一から自分で作り直す）**。手元の PC に **Docker Desktop はインストール済み**。次回からは**ローカル環境**で行う |

**次回の最初にやること**（決定済み。本人に聞き直さなくてよい）

1. **Docker の説明から改めて始める**（前回の説明はもう一度、ゆっくりやり直す）
   - Docker とは何か → イメージ / コンテナ → Docker Desktop が起動しているかの確認方法
2. そのうえで、本人と一緒にファイルを空に戻し、**本人が自分で手を動かして**作り直す
   - 空に戻す前に、何をするか説明して本人の了承をとる（完成版は git 履歴 `058636f` に残っているので消えない）
   - 作る順番の目安: `.env` → `docker-compose.yml` → コンテナ起動 → `docker exec -it` で対話的に接続 → `01` → `02` → `03` の SQL
3. ローカルでは **コマンドは本人がターミナルで打つ**。Claude は何をどこに打つか・結果の読み方を説明する役に徹する
   - 課題文どおり `docker exec -it mysql-practice bash` → `mysql -u root -p` の対話接続も本人に体験してもらう

※ 下の「作業タスク（チェックリスト）」が全部 `[x]` なのは、Claude がクラウドで先に実行した分。**本人の学習の進み具合はこの表で管理する**。

> 進捗を進めたら、この表に 1 行追加して commit / push すること。

## 課題内容（原文要約）

### 課題(1)
1. ローカルマシンで Docker を使って MySQL の Docker Container を起動する
2. 起動したコンテナに接続する（`docker exec -it <container> bash` など）
3. MySQL 内に `practice` という名前のデータベースを作成する

### 課題(2)
1. `practice` データベースに `User` テーブルを作成する
   ※課題文には "practive" とあるが誤字。`practice` で統一する
2. `WHERE` などを利用して CRUD（INSERT / SELECT / UPDATE / DELETE）を行う

スキーマ例:

| カラム | 型（例） | 備考 |
|---|---|---|
| id | INT AUTO_INCREMENT | PRIMARY KEY |
| name | VARCHAR(255) | NOT NULL |
| email | VARCHAR(255) | NOT NULL, UNIQUE 推奨 |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |
| updated_at | DATETIME | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |

## ディレクトリ構成

```
mysql-docker-practice/
├── CLAUDE.md              # この引き継ぎ資料
├── README.md              # 人間向けの手順・提出用まとめ
├── docker-compose.yml     # MySQL 8.0 コンテナ定義
├── .env.example           # 環境変数のテンプレート（.env にコピーして使う）
├── .gitignore
├── sql/
│   ├── 01_create_database.sql   # 課題(1) DB作成
│   ├── 02_create_user_table.sql # 課題(2) テーブル作成
│   └── 03_crud.sql              # 課題(2) CRUD
└── docs/
    └── log.md             # 実行コマンドと結果のログ（提出・振り返り用）
```

## 環境

- Docker Desktop（または Docker Engine + Compose v2）が必要
- イメージ: `mysql:8.0`
- コンテナ名: `mysql-practice`
- ホスト側ポート: `3306`（使用中なら `.env` の `MYSQL_PORT` を変更）
- 接続情報は `.env` で管理（**`.env` は Git にコミットしない**）
- `practice` DB は課題として手動作成するため、`MYSQL_DATABASE` は**あえて設定しない**

## 作業タスク（チェックリスト）

Claude Code は以下を順に進め、完了したら `[x]` に更新し、`docs/log.md` に実行コマンドと出力を記録すること。

- [x] 0. 事前確認: `docker --version` / `docker compose version` / `git --version`
- [x] 1. `cp .env.example .env` し、パスワードを設定
- [x] 2. `docker compose up -d` でコンテナ起動、`docker compose ps` で healthy を確認
- [x] 3. `docker exec -it mysql-practice bash` → `mysql -u root -p` で接続
- [x] 4. `sql/01_create_database.sql` を作成・実行し `SHOW DATABASES;` で確認
- [x] 5. `sql/02_create_user_table.sql` を作成・実行し `DESCRIBE User;` で確認
- [x] 6. `sql/03_crud.sql` を作成・実行（INSERT → SELECT(WHERE) → UPDATE(WHERE) → DELETE(WHERE)）
- [x] 7. 各ステップの結果を `docs/log.md` に記録
- [x] 8. README の「実施結果」欄を更新
- [x] 9. 意味のある単位でコミットし、GitHub に push

## SQL ファイルの実行方法

ホストから直接流す場合:

```bash
docker exec -i mysql-practice sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < sql/01_create_database.sql
```

`-t` を付けると表形式で出力されるのでログに残しやすい:

```bash
docker exec -i mysql-practice sh -c 'mysql -t -uroot -p"$MYSQL_ROOT_PASSWORD"' < sql/03_crud.sql
```

## Git / GitHub 運用ルール

- ブランチ: `main` を基本とし、課題ごとに `feature/task1`, `feature/task2` を切ってもよい
- コミットメッセージは日本語可。プレフィックス例: `feat:`, `docs:`, `chore:`
  - 例: `feat: 課題(1) practice データベース作成SQLを追加`
- `.env`、`mysql-data/` などの生成物はコミットしない（`.gitignore` 済み）
- リモート作成は GitHub CLI を使う:
  ```bash
  gh auth login            # 初回のみ
  gh repo create mysql-docker-practice --private --source=. --remote=origin --push
  ```

## Claude Code への指示

- **冒頭の「進め方のルール」を最優先する**

- 学習目的なので、コマンドや SQL を実行する前に「何をするか・なぜか」を短く日本語で説明する
- SQL は 1 文ずつ意味が分かるようにコメントを付ける
- 破壊的操作（`DROP`, `docker compose down -v` など）は実行前にユーザーへ確認する
- エラー時は原因と対処を `docs/log.md` に残す（よくある例: ポート3306競合、起動直後で接続拒否）
