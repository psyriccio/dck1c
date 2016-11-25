# Установите в эту переменную путь к директории и в ней будут
# сохраняться готовые образы в процессе сборки
DCK1C_SAVE_IMAGES_TO='./images'

# Использовать docker-репозиторий
DCK1C_DOCKER_REGISTRY='jws:5000'

# Добавить шрифты mscorefonts (ВНИМАНИЕ!!! несвободный контент,
# читайте прилагаемую лицензию mscorefonts.zip/mscorefonts_LICENSE)
# отключение может привести к нестабильной работе 1С
DCK1C_INJECT_NONFREE_FONTS=true

# Добавить Fira Code -- свободный, моноширный шрифт для кода,
# с поддержкой кирилицы и расширенным набором юникод-символов
DCK1C_INJECT_FIRACODE_FONT=true

# Включить infinality патчи, исправляет рендеринг шрифтов,
# если не жалко глаза -- можно отключить
DCK1C_AWESOME_FONTS_RENDERING=true

# Добавить тему оформления zookitwo + ultraflat icons set
DCK1C_INJECT_UI_THEMES=true

# Пакеты, дополнительно устанавливаемые в контейнер
DCK1C_INSTALL_PACKAGES='nano mc'

# Добавить эти файлы в контейнер (будут находиться в /opt/custom
# с правами { user:user rw.rw.... (660) } после сборки контейнера)
#DCK1C_ADD_FILES='somefile.ext someotherfile.ext'

# Описание дополнительных комманд добавляемых в сервисное меню, в формате:
# Имя1:Описание1:Коммандная_строка1; Имя2:Описание2:Коммандная_строка2; ...
# Имя должно быть уникальным! Зарезервированные имена: "OneMore", "ListAll", "Bash", "Kill", "KillAll", "Kill&Exit"
DCK1C_CUSTOM_COMMANDS='nano:Запустить текстовый редактор nano:nano;MC:Запустить Midnight Commander: mc;'

# Включает оптимизацию и объединение слоёв в образе после сборки
# (уменьшает и оптимизирует образ)
# Если контейнер работает нестабильно -- можно попробовать выключить эту опцию
DCK1C_SQUASH_IMAGES=true

# Версия платформы для сборки
DCK1C_1CPLATFORM_VERSION='8.3.7-1873'

# Попытаться скачать необходимые пакеты с сайта users.v8.1c.ru (необходоимо указать логин и пароль)
DOCK1C_USERSV81C_DOWNLOAD=true

# Логин и пароль для доступа к users.v8.1c.ru,
# если не указано, но параметр DOCK1C_USERSV81C_DOWNLOAD=true -- будет спрошено при сборке
DOCK1C_USERSV81C_USERNAME='user'
DOCK1C_USERSV81C_PASSWORD='secret'
