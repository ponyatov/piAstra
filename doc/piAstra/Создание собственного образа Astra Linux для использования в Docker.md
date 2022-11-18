# Создание собственного образа Astra Linux для использования в Docker


https://wiki.astralinux.ru/pages/viewpage.action?pageId=120651784

Для Astra Linux Special Edition РУСБ.10015-01 (очередное обновление 1.7) следует использовать код дистрибутива 1.7_x86-64, например:  

```
sudo debootstrap \  
    --include ncurses-term,mc,locales,nano,gawk,lsb-release,acl,perl-modules-5.28 \  
    --components=main,contrib,non-free 1.7_x86-64 \  
    /var/docker-chroot \  
    http://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main
```