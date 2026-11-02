-- 課題(1): practice データベースを作成する

-- practice という名前のデータベースを作成する
-- IF NOT EXISTS: 既に存在してもエラーにせず、何度実行しても安全にする
CREATE DATABASE IF NOT EXISTS practice
  -- 文字コード: 絵文字も扱える utf8mb4 を指定
  CHARACTER SET utf8mb4
  -- 照合順序: 文字の比較・並び替えのルール
  COLLATE utf8mb4_unicode_ci;

-- 確認: サーバー上のデータベース一覧を表示し、practice があるかを見る
SHOW DATABASES;
