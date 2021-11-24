include:
  - modules.redis.install

/usr/local/redis/conf/redis.conf:
  file.managed:
    - source: salt://modules/rediszhucong/files/redis-slave.conf.j2

redis_server.service:
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: {{ pillar['redis-dir'] }}conf/redis.conf
