# 作業ログ

実行したコマンドとその結果を、日付ごとに記録する。
エラーが出たときは「原因」と「対処」も書く。

---

## 2026-11-12 ステップ 1: 必要な道具がそろっているか確認する

### ブランチの整理

| コマンド | 結果 |
|---|---|
| `git switch main` / `git pull` | 手元の `main` を GitHub の最新（`19361fd` PR #1 のマージ）に合わせた |
| `git branch -d docs/learning-setup` | マージ済みの古いブランチを手元から削除 |
| `git push origin --delete docs/learning-setup` | 同じブランチを GitHub からも削除 |
| `git switch -c docs/step1-check-tools` | ステップ 1 用のブランチを作成して移動 |

### 道具のバージョン確認

```bash
git --version
# => git version 2.49.0

docker --version
# => Docker version 29.6.2, build dfc4efb

docker compose version
# => Docker Compose version v5.3.1
```

結果: 3 つともインストール済みで、使える状態だった。

### つまずいたこと

- 最初はブランチを作る前に `docker --version` を打ってしまい、`main` のまま作業していた
  - 気づき方: プロンプトの `git:(main)` を見ると、今いるブランチが分かる
  - 対処: `git switch -c docs/step1-check-tools` でブランチを作ってから続けた

---

## 2026-11-14 ステップ 2: MySQL コンテナを起動するための環境を作る

### 手元のイメージとコンテナを確認（見るだけのコマンド）

```bash
docker images
# => イメージが 37 個あった（ほかの勉強やプロジェクトで以前ダウンロードしたもの）
#    その中に mysql:8.4 がすでにあった
#    postgres:17-alpine に U（In Use = このイメージから作ったコンテナがある）が付いていた

docker ps -a
# => コンテナは 1 個だけ: g-ranche-app-db-1
#    （postgres:17-alpine から作ったもの。STATUS は Exited = 停止中）
#    MySQL のコンテナはまだない
```

- ほかのプロジェクトで使っている可能性があるので、既存のイメージ・コンテナは消さない

### 使う MySQL のバージョンを決めた

- **`mysql:9.7`（安定版 LTS の新しいほう）を使う**
- 検討したもの: `8.4`（手元にある安定版）/ `26.10`（いちばん新しい Innovation 版）/ `latest`
- `latest` は「中身が変わる名札」なので使わず、バージョン番号をはっきり書く
