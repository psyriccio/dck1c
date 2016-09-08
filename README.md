# Docker контейнер для linux 1С клиента

Контейнер на базе ubuntu 14.04, в составе infinality-патчи (рендеринг шрифтов),
шрифт "Fira Code", набор стандартных шрифтов mscorefonts (читайте лицензию в архиве),
набор тем Zukitwo, UltraFlatIcons, YltraIcons
можно не использовать: выкинуть файлы "ultraflat-icons.zip, yltra-icons.zip, zukitwo-themes.zip" ,
и удалить из DockerFile строки:
<blockquote>
  <p>
  && unzip /opt/zukitwo-themes.zip -d /usr/share/themes \ <br>
  && unzip /opt/yltra-icons.zip -d /usr/share/icons \ <br>
  && unzip /opt/ultraflat-icons.zip -d /usr/share/icons \ <br>
  </p>
</blockquote>

### Настройка перед сборкой

* В Dockerfile исправить версию платформы, архитектуру и используемую кодировку
<blockquote>
  ENV PLT_VERSION 8.3.7-1873 <br>
  ENV PLT_ARCH amd64 <br>
  ENV LANG ru_RU.utf8 <br>
</blockquote>

* Разместить официальные deb-пакеты 1С соответствующих версий и архитектуры (common, server, client) в директории ./dist (server нужен тоже, не знаю зачем, но он указан в зависимостях пакета client (1С -- такая 1С))

* Собрать контейнер `docker build -t psyriccio/docker1c .`

* Использовать для запуска `./run.sh` или комманду вида
`docker run -t --rm -e DISPLAY -v $HOME/.Xauthority:/home/user/.Xauthority -v $HOME:/home/user -v /mnt:/mnt --net=host --pid=host --ipc=host psyriccio/docker1c`
