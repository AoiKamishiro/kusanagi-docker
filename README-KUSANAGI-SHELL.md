# KUSANAGI Shell

## 概要

`kusanagi-shell.sh`は、コンテナ内でKUSANAGI Dockerコマンドを実行するためのシェル環境です。ホストにKUSANAGIをインストールせず、Dockerコンテナ内で完結したKUSANAGI環境を構築・管理できます。

## 使用方法

### 起動

```bash
./kusanagi-shell.sh
```

初回起動時は自動的にDockerイメージがビルドされます。

### コマンド実行

シェル内で通常のKUSANAGI Dockerコマンドを実行できます：

```bash
kusanagi-docker provision --fqdn example.com MySite
kusanagi-docker start
kusanagi-docker stop
```

### 終了

```bash
exit
```

## Docker-in-Docker対応

コンテナ内からDockerコマンドを実行できるよう、以下の仕組みを実装しています：

- **Docker Socketのマウント**: ホストのDocker daemonを共有
- **ホストパスの自動マッピング**: 生成される`docker-compose.yml`が正しいホストパスを参照
- **環境変数の受け渡し**: `HOST_WORKSPACE_DIR`でホストのパスをコンテナに伝達

### 生成されるdocker-compose.ymlの特徴

`.wp_mysqli.ini`がホストの絶対パスでマウントされます：

```yaml
volumes:
  - /Users/username/project/MySite/.wp_mysqli.ini:/usr/local/etc/php/conf.d/wp_mysqli.ini
```

これにより、コンテナ内からDockerを呼び出す際も正しくファイルがマウントされます。

## トラブルシューティング

### イメージの再ビルド

```bash
docker rmi kusanagi-cli
./kusanagi-shell.sh
```

### 既存ディレクトリの削除

```bash
rm -rf MySite
kusanagi-docker provision --fqdn example.com MySite
```

## 参考資料

- [KUSANAGI Runs on Docker 公式ドキュメント](HowToUse_RoD.md)
