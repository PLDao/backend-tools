# README



## 1 数据库

### 1.1 mysql

``` text
username: root
passwd: root
```

### 1.2 postgresql

``` text
username: postgres
passwd: postgres
```

### 1.3 redis

``` text
redis-conf: Line 500 by 'requirepass redis' setting redis passwd
passwd: redis
```



## 2 基础命令

### 2.1 command

``` shell
docker-compose up -d
docker-compose stop
docker container prune -f
docker volume prune -f
rm -rf ./data/mysql-data/*
rm -rf ./data/pgsql-data/*
rm -rf ./data/redis-data/*
```



## 3 打包

### 3.1 package

``` shell
tar -jcvf db-engine.tar.bz2 db-engine
tar -jxvf db-engine.tar.bz2
chmod -R 755 db-engine
```
