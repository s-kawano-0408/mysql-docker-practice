# mysql-docker-practice

課題「MySQL」の実施リポジトリです。
Docker で MySQL コンテナを起動し、`practice` データベースと `User` テーブルを作成して CRUD を行います。

## 必要なもの

- Docker Desktop（Compose v2 同梱）
- Git / GitHub CLI（`gh`）
- Claude Code（任意。`CLAUDE.md` に引き継ぎ資料あり）

## セットアップ

```bash
cp .env.example .env          # パスワードを編集
docker compose up -d          # MySQL 起動
docker compose ps             # STATUS が healthy になるまで待つ
```

## 課題(1): コンテナ接続と DB 作成

```bash
docker exec -it mysql-practice bash
mysql -u root -p
```

```sql
CREATE DATABASE practice;
SHOW DATABASES;
```

## 課題(2): User テーブル作成と CRUD

`sql/02_create_user_table.sql` と `sql/03_crud.sql` を参照。

```bash
docker exec -i mysql-practice sh -c 'mysql -t -uroot -p"$MYSQL_ROOT_PASSWORD"' < sql/02_create_user_table.sql
docker exec -i mysql-practice sh -c 'mysql -t -uroot -p"$MYSQL_ROOT_PASSWORD"' < sql/03_crud.sql
```

## 実施結果

- [x] 課題(1) 完了（Docker で MySQL 8.0 起動 → practice DB 作成）
- [x] 課題(2) 完了（User テーブル作成 → INSERT / SELECT(WHERE) / UPDATE(WHERE) / DELETE(WHERE)）

詳細ログ: [docs/log.md](docs/log.md)

## 後片付け

```bash
docker compose down        # コンテナ停止（データは残る）
docker compose down -v     # データも削除
```
