-- 課題(2): practice データベースに User テーブルを作成する

-- 以降の操作対象を practice データベースに切り替える
USE practice;

-- User テーブルを作成する（既にあれば何もしない）
CREATE TABLE IF NOT EXISTS User (
  -- id: 自動で連番が振られる主キー（1行を一意に特定する番号）
  id         INT          NOT NULL AUTO_INCREMENT,
  -- name: ユーザー名。空(NULL)は禁止
  name       VARCHAR(255) NOT NULL,
  -- email: メールアドレス。空禁止 + 重複禁止(UNIQUE)
  email      VARCHAR(255) NOT NULL,
  -- created_at: 行を作成した日時。INSERT 時に自動で現在時刻が入る
  created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- updated_at: 最終更新日時。UPDATE のたびに自動で現在時刻に更新される
  updated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  -- 主キーの指定
  PRIMARY KEY (id),
  -- email の重複を禁止する制約（制約名 uq_user_email）
  UNIQUE KEY uq_user_email (email)
);

-- 確認: テーブルの構造（カラム名・型・制約）を表示する
DESCRIBE User;
