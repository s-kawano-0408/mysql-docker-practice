-- 課題(2): WHERE などを使って CRUD を行う

-- 操作対象を practice データベースに切り替える
USE practice;

-- 何度実行しても同じ結果になるよう、既存データを空にして連番もリセットする
-- （TRUNCATE はテーブル自体は残し、中身だけを全削除する）
TRUNCATE TABLE User;

-- ============================================================
-- C: Create（INSERT）
-- ============================================================

-- ユーザーを3件まとめて登録する（id と日時は自動で入るので指定しない）
INSERT INTO User (name, email) VALUES
  ('Taro Yamada',  'taro@example.com'),
  ('Hanako Suzuki', 'hanako@example.com'),
  ('Jiro Tanaka',  'jiro@example.com');

-- ============================================================
-- R: Read（SELECT）
-- ============================================================

-- 全件を取得する
SELECT * FROM User;

-- WHERE: id が 2 のユーザーだけを取得する
SELECT id, name, email FROM User WHERE id = 2;

-- WHERE + LIKE: email が "ta" で始まるユーザーを取得する（% は任意の文字列）
SELECT id, name, email FROM User WHERE email LIKE 'ta%';

-- ============================================================
-- U: Update（UPDATE）
-- ============================================================

-- updated_at の変化が見えるよう、2秒待つ
SELECT SLEEP(2) AS wait_sec;

-- WHERE: id が 1 のユーザーの名前だけを変更する
-- ※ WHERE を付け忘れると全行が更新されてしまうので注意
UPDATE User SET name = 'Taro Yamada (updated)' WHERE id = 1;

-- 確認: id=1 は updated_at が新しくなり、created_at はそのまま
SELECT id, name, created_at, updated_at FROM User WHERE id = 1;

-- ============================================================
-- D: Delete（DELETE）
-- ============================================================

-- WHERE: email が jiro@example.com のユーザーを削除する
-- ※ WHERE を付け忘れると全行が削除されてしまうので注意
DELETE FROM User WHERE email = 'jiro@example.com';

-- 確認: 残りのユーザー一覧（Jiro が消えていること）
SELECT * FROM User;
