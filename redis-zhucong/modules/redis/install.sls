redis-base-install:
  pkg.installed:
    - pkgs:
      - gcc 
      - gcc-c++ 
      - make 
      - tcl-devel 
      - systemd-devel

tar-redis:
  archive.extracted:
    - name: /usr/local
    - source: salt://modules/redis/files/redis-6.0.6.tar.gz
    - if_missing: /usr/local/redis-6.0.6

{{ pillar['redis-dir'] }}conf:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - unless: test -d {{ pillar['redis-dir'] }}conf

redis-installsh:
  cmd.script:
    - name: salt://modules/redis/files/install.sh
    - unless: test -d {{ pillar['redis-dir'] }}bin

start-redis-server:
  file.managed:
    - names:
      - {{ pillar['redis-dir'] }}conf/redis.conf.j2:
        - source: salt://modules/redis/files/redis.conf
        - template: jinja 
      - /usr/local/bin/redis-server:
        - source: salt://modules/redis/files/redis-server
        - mode: '0755'
      - /usr/lib/systemd/system/redis_server.service:
        - source: salt://modules/redis/files/redis_server.service

redis_server.service:
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: {{ pillar['redis-dir'] }}conf/redis.conf
