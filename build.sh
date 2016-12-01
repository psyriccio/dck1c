#!/bin/bash
source $BASEDIRECTORY/lib/ansiesc.sh
source $BASEDIRECTORY/lib/utils.sh
source $BASEDIRECTORY/config.sh

function print_banner() {

    printf "\n\n"
    printf "${_BLU}         88            88               ${_LYLW}88   ,ad8888ba,   ${_NA}\n"
    printf "${_BLU}         88            88             ${_LYLW},d88  d8\"\'    \`\"8b  ${_NA}\n"
    printf "${_BLU}         88            88           ${_LYLW}888888 d8\'            ${_NA}\n"
    printf "${_BLU} ,adPPYb,88  ,adPPYba, 88   ,d8         ${_LYLW}88 88             ${_NA}\n"
    printf "${_BLU}a8\"    \`Y88 a8\"     \"\" 88 ,a8\"          ${_LYLW}88 88             ${_NA}\n"
    printf "${_BLU}8b       88 8b         8888[            ${_LYLW}88 Y8,            ${_NA}\n"
    printf "${_BLU}\"8a,   ,d88 \"8a,   ,aa 88\`\"Yba,         ${_LYLW}88  Y8a.    .a8P  ${_NA}\n"
    printf "${_BLU} \`\"8bbdP\"Y8  \`\"Ybbd8\"\' 88   \`Y8a        ${_LYLW}88   \`\"Y8888Y\"\'   ${_NA}\n"
    printf "\n"
    printf "                 ${_LWHT}%40s${_NA}\n" "1C docker container builder"
    printf "                 ${_LGRE}%40s${_NA}\n" ${_VERSION}
    printf "                 ${_LGRE}%40s${_NA}\n\n" "pltf."${DCK1C_1CPLATFORM_VERSION}
}

function print_usage() {
    printf "\nиспользование: ${_LWHT}build.sh <режим>${_NA}\n\n"
    printf "${_LWHT}\t<режим> ${_WHT}- режим сборки, поддерживаемые режимы:${_NA}\n\n"
    printf "${_LWHT}\t\t clean ${_WHT}- удалить образы, вернуть дерево сборки в изначальное состояние${_NA}\n"
    printf "${_LWHT}\t\t image ${_WHT}- собрать образ и загрузить его в docker${_NA}\n"
    printf "${_LWHT}\t\t dist ${_WHT}- собрать пакет для быстрой установки в другие системы${_NA}\n"
    printf "${_LWHT}\t\t arch ${_WHT}- собрать ArchLinux-пакет${_NA}\n\n"
}

function make_dockerfiles() {
    cat ./ubn1c-base/parts/00_head.Dockerfile > ./ubn1c-base/Dockerfile
    cat ./ubn1c-base/parts/01_ftr.Dockerfile >> ./ubn1c-base/Dockerfile
    cat ./parts/00_head.Dockerfile > ./Dockerfile
    cat ./parts/01_env.Dockerfile | sed "s/!!VERSION!!/${DCK1C_1CPLATFORM_VERSION}/g" | sed "s/!!ARCH!!/${DCK1C_1CPLATFORM_ARCH}/g" | sed "s/!!LANG!!/${DCK1C_LANG}/g" >> ./Dockerfile
    cat ./parts/02_dist.Dockerfile >> ./Dockerfile
    if [[ $DCK1C_INJECT_NONFREE_FONTS ]]; then
        cat ./parts/03_nff.Dockerfile >> ./Dockerfile
    fi
    if [[ $DCK1C_INJECT_FIRACODE_FONT ]]; then
        cat ./parts/04_fira.Dockerfile >> ./Dockerfile
    fi
    if [[ $DCK1C_INJECT_UI_THEMES ]]; then
        cat ./parts/05_thms.Dockerfile >> ./Dockerfile
    fi
    cat ./parts/06_dcln.Dockerfile >> ./Dockerfile
    if [[ $DCK1C_AWESOME_FONTS_RENDERING ]]; then
        cat ./parts/07_awsf.Dockerfile >> ./Dockerfile
    fi
    cat ./parts/08_ftr.Dockerfile >> ./Dockerfile
}

_VERSION=$(git describe --tags --always)
printf "${_VERSION}" > ./VERSION

print_banner

if [[ -z $1 ]]; then
    print_usage
    exit 0
fi

if [[ $1 != "clean" ]] && [[ $1 != "image" ]] && [[ $1 != "dist" ]] && [[ $1 != "arch" ]]; then
    error_exit "Ошибка в параметрах коммандной строки, запустите без параметров чтобы увидеть справку об использовании"
fi

if [[ $1 == "clean" ]]; then
    printf "${_LWHT}Сброс дерева сборки...${_NA}\n"
    rm -f ./images/*
    rm -rf ./cache/
    echo "" > ./ubn1c-base/Dockerfile
    echo "" > ./Dockerfile
    printf "${_LGRN}Готово!${_NA}\n"
    exit 0
fi

make_dockerfiles

CACHEDIR=./cache/$(sha256sum ./config.sh | awk '{  print $1 }')
BASE_REBUILD=false
DCK_REBUILD=false
BASE_CACHED=false
DCK_CACHED=false
if [[ -d $CACHEDIR ]]; then
    printf "${_LWHT}Найдена запись в кэше, проверка хэшей...${_NA}\n"
    printf "${_WHT}\t./images/ubn1c-base.image.tar...${_NA}\n"
    shabase=$(sha256sum --binary ./images/ubn1c-base.image.tar | awk '{  print $1 }')
    shabasecache=$(cat $CACHEDIR/../ubn1c-base.image.sha)
    if [[ $shabase != $shabasecache ]]; then
        printf "${_LRED} несовпадение хэшей, конфигурация была изменена, требуется пересборка${_NA}\n"
        BASE_REBUILD=true
        DCK_REBUILD=true
    else
        BASE_CACHED=true
    fi
    if [[ ! $BASE_REBUILD ]]; then
        printf "${_WHT}\t./images/dck1c.image${_NA}\n"
        shadck=$(sha256sum --binary ./images/dck1c.image.tar | awk '{  print $1 }')
        shadckcache=$(cat $CACHEDIR/dck.image.sha)
        if [[ $shadck != $shadckcache ]]; then
            printf "${_LRED} несовпадение хэшей, конфигурация была изменена, требуется пересборка${_NA}\n"
            DCK_REBUILD=true
        else
            DCK_CACHED=true
        fi
    fi
else
    BASE_REBUILD=true
    DCK_REBUILD=true
fi
mkdir -p ./images
if [[ BASE_REBUILD ]]; then
    printf "${_LWHT}Сборка базового образа ubn1c-base...${_NA}\n"
    cd ubn1c-base
    docker build -t psyriccio/ubn1c-base .
    cd ..
    docker save psyriccio/ubn1c-base -o ./images/ubn1c-base.image.tar
else
    printf "${_LWHT}Взят готовый образ ubn1c-base${_NA}\n"
    docker load -i ./images/ubn1c-base.image.tar
fi
if [[ DCK_REBUILD ]]; then
    printf "${_LWHT}Сборка dck1c образа...${_NA}\n"
    docker build -t psyriccio/dck1c .
    docker save psyriccio/dck1c -o ./images/dck1c.image.tar
else
    printf "${_LWHT}Взят готовый образ dck1c${_NA}\n"
    docker load -i ./images/dck1c.image.tar
fi

if [[ $DCK1C_SQUASH_IMAGES ]]; then
    printf "${_LWHT}Уплотнение и оптимизация образов...${_NA}\n"
    printf "\t./images/ubn1c-base.image.tar\n"
    if [[ ! $BASE_CACHED ]]; then
        docker tag psyriccio/ubn1c-base psyriccio/ubn1c-base-unsq
        mv ./images/ubn1c-base.image.tar ./images/ubn1c-base-unsq.image.tar
        ./tools/docker-squash -i ./images/ubn1c-base-unsq.image.tar -o ./images/ubn1c-base.image.tar -t psyriccio/ubn1c-base
        docker load -i ./images/ubn1c-base.image.tar
    else
        printf "\t\t${_YLW} образ из кэша, оптимизация не требуется${_NA}\n"
    fi

    if [[ ! $DCK_CACHED ]]; then
        docker tag psyriccio/dck1c psyriccio/dck1c-unsq
        mv ./images/dck1c.image.tar ./images/dck1c-unsq.image.tar
        ./tools/docker-squash -i ./images/dck1c-unsq.image.tar -o ./images/dck1c.image.tar -t psyriccio/dck1c
        docker load -i ./images/dck1c.image.tar
    else
        printf "\t\t${_YLW} образ из кэша, оптимизация не требуется${_NA}\n"
    fi
fi

if [[ -n $DCK1C_DOCKER_REGISTRY ]]; then
    docker tag psyriccio/ubn1c-base $DCK1C_DOCKER_REGISTRY/psyriccio/ubn1c-base
    docker tag psyriccio/dck1c $DCK1C_DOCKER_REGISTRY/psyriccio/dck1c
    docker push $DCK1C_DOCKER_REGISTRY/psyriccio/ubn1c-base
    docker push $DCK1C_DOCKER_REGISTRY/psyriccio/ubn1c-base
fi

printf "${_LWHT}Вычисление хэшей образов...${_NA}\n"
CACHEDIR=./cache/$(sha256sum ./config.sh | awk '{  print $1 }')
mkdir -p "$CACHEDIR"
printf "${_WHT}\t./images/ubn1c-base.image.tar...${_NA}\n"
sha256sum --binary ./images/ubn1c-base.image.tar | awk '{  print $1 }' > $CACHEDIR/../ubn1c-base.image.sha
printf "${_WHT}\t./images/dck1c.image${_NA}\n"
sha256sum --binary ./images/dck1c.image.tar | awk '{  print $1 }' > $CACHEDIR/dck1c.image.sha
printf "${_LGRN}Готово!${_NA}\n\n"
printf "${_LWHT}\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D"
printf "\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D"
printf "\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D\x2D${_NA}\n\n"
printf "    образы: $(ls -lsah ./images)\n\n"
