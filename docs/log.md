# 作業ログ

実行したコマンドと結果をここに記録します。
実施日: 2026-11-02 / 実施環境: Claude Code のクラウド環境（Linux, Docker Engine 29.9.2）

## 事前確認

```
$ docker --version
Docker version 29.9.2, build a82e528
$ docker compose version
Docker Compose version v5.6.1
$ git --version
git version 2.43.0
```

## 課題(1)

### .env 作成

```
$ cp .env.example .env
# MYSQL_ROOT_PASSWORD をランダムな値に変更（.env は .gitignore 済みでコミットしない）
```

### コンテナ起動

```
$ docker compose up -d
 Container mysql-practice Started
$ docker compose ps
NAME             IMAGE       COMMAND                  SERVICE   CREATED          STATUS                    PORTS
mysql-practice   mysql:8.0   "docker-entrypoint.s…"   mysql     19 seconds ago   Up 17 seconds (healthy)   0.0.0.0:3306->3306/tcp, 33060/tcp
```

### コンテナへの接続

対話端末（TTY）がない環境のため、`docker exec -it mysql-practice bash` → `mysql -u root -p` の代わりに、
非対話で mysql クライアントを実行して接続できることを確認した。

```
$ docker exec mysql-practice sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SELECT VERSION();"'
VERSION()
8.0.46
```

### practice データベース作成（sql/01_create_database.sql）

```
$ docker exec -i mysql-practice sh -c 'mysql -t -uroot -p"$MYSQL_ROOT_PASSWORD"' < sql/01_create_database.sql
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| practice           |
| sys                |
+--------------------+
```

## 課題(2)

### User テーブル作成（sql/02_create_user_table.sql）

```
$ docker exec -i mysql-practice sh -c 'mysql -t -uroot -p"$MYSQL_ROOT_PASSWORD"' < sql/02_create_user_table.sql
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
| Field      | Type         | Null | Key | Default           | Extra                                         |
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
| id         | int          | NO   | PRI | NULL              | auto_increment                                |
| name       | varchar(255) | NO   |     | NULL              |                                               |
| email      | varchar(255) | NO   | UNI | NULL              |                                               |
| created_at | datetime     | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED                             |
| updated_at | datetime     | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
+------------+--------------+------+-----+-------------------+-----------------------------------------------+
```

### CRUD（sql/03_crud.sql）

出力される表は上から順に:
1. INSERT 後の全件 SELECT
2. `WHERE id = 2` の SELECT
3. `WHERE email LIKE 'ta%'` の SELECT
4. SLEEP(2)（updated_at の差を見るための待機。0 は正常終了の意味）
5. `WHERE id = 1` の UPDATE 後 → updated_at だけが 2 秒進んでいる
6. `WHERE email = 'jiro@example.com'` の DELETE 後の全件 → Jiro が消えている

```
$ docker exec -i mysql-practice sh -c 'mysql -t -uroot -p"$MYSQL_ROOT_PASSWORD"' < sql/03_crud.sql
+----+---------------+--------------------+---------------------+---------------------+
| id | name          | email              | created_at          | updated_at          |
+----+---------------+--------------------+---------------------+---------------------+
|  1 | Taro Yamada   | taro@example.com   | 2026-11-02 13:38:38 | 2026-11-02 13:38:38 |
|  2 | Hanako Suzuki | hanako@example.com | 2026-11-02 13:38:38 | 2026-11-02 13:38:38 |
|  3 | Jiro Tanaka   | jiro@example.com   | 2026-11-02 13:38:38 | 2026-11-02 13:38:38 |
+----+---------------+--------------------+---------------------+---------------------+
+----+---------------+--------------------+
| id | name          | email              |
+----+---------------+--------------------+
|  2 | Hanako Suzuki | hanako@example.com |
+----+---------------+--------------------+
+----+-------------+------------------+
| id | name        | email            |
+----+-------------+------------------+
|  1 | Taro Yamada | taro@example.com |
+----+-------------+------------------+
+----------+
| wait_sec |
+----------+
|        0 |
+----------+
+----+-----------------------+---------------------+---------------------+
| id | name                  | created_at          | updated_at          |
+----+-----------------------+---------------------+---------------------+
|  1 | Taro Yamada (updated) | 2026-11-02 13:38:38 | 2026-11-02 13:38:40 |
+----+-----------------------+---------------------+---------------------+
+----+-----------------------+--------------------+---------------------+---------------------+
| id | name                  | email              | created_at          | updated_at          |
+----+-----------------------+--------------------+---------------------+---------------------+
|  1 | Taro Yamada (updated) | taro@example.com   | 2026-11-02 13:38:38 | 2026-11-02 13:38:40 |
|  2 | Hanako Suzuki         | hanako@example.com | 2026-11-02 13:38:38 | 2026-11-02 13:38:38 |
+----+-----------------------+--------------------+---------------------+---------------------+
```

## トラブルシュート

### Docker デーモンが起動していない

- 症状: `docker info` が `failed to connect to the docker API at unix:///var/run/docker.sock ... no such file or directory`
- 原因: Docker の CLI はあるが、本体（dockerd）が起動していなかった
- 対処: `dockerd` をバックグラウンドで起動した（ローカルでは Docker Desktop を起動すればよい）

### 補足: `Using a password on the command line interface can be insecure.`

- コマンドライン引数でパスワードを渡すと出る MySQL の警告。学習用途なので無視してよい（ログからは省略）
