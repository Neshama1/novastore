#include "systeminfo.h"
#include <KConfig>
#include <KConfigGroup>
#include <QDebug>
#include <QColor>
#include <QGuiApplication>
#include <QStyleHints>
#include <QDir>
#include <QString>
#include <QStringList>
#include <QGuiApplication>
#include <QStyleHints>

SystemInfo::SystemInfo() {
}

QString SystemInfo::getWallpaper() {

    // Get wallpaper

    QString wallpaperPath;

    KConfig appletsrc("plasma-org.kde.plasma.desktop-appletsrc", KConfig::NoGlobals);
    KConfigGroup containments(&appletsrc, "Containments");

    const auto groups = appletsrc.groupList();
    qDebug() << "Groups in file" << groups;

    bool match = false;

    for (const QString& group : containments.groupList()) {
        KConfigGroup containment(&containments, group);

        if (containment.groupList().contains("Wallpaper")) {

            match = true;

            KConfigGroup wallpaper = containment.group("Wallpaper").group("org.kde.image").group("General");
            wallpaperPath = wallpaper.readEntry("Image");

            if (wallpaperPath.contains("file://")) {
                wallpaperPath.remove("file://");
            }

            if (wallpaperPath.endsWith("/")) {
                const auto scheme = QGuiApplication::styleHints()->colorScheme();

                QString path;

                if (scheme == Qt::ColorScheme::Light) {
                    path = "contents/images/";
                }
                else {
                    path = "contents/images_dark/";
                }

                QDir pathname(wallpaperPath + path);
                QStringList files = pathname.entryList(QDir::Files | QDir::NoDotAndDotDot);

                QString file = files[files.count() - 1];

                wallpaperPath = wallpaperPath + path + file;
            }
        }
    }

    if(!match) {
        KConfig kdeglobals("kdeglobals", KConfig::NoGlobals);
        KConfigGroup KDE(&kdeglobals, "KDE");
        QString lookAndFeel = KDE.readEntry("LookAndFeelPackage");

        qDebug() << "Look and Feel" << lookAndFeel;

        QString filePath = "/usr/share/plasma/look-and-feel/" + lookAndFeel + "/contents/defaults";

        KConfig defaults(filePath, KConfig::SimpleConfig);
        KConfigGroup wallpaper(&defaults, "Wallpaper");
        QString image = wallpaper.readEntry("Image");

        qDebug() << "Image" << image;

        QString path;

        if (QGuiApplication::styleHints()->colorScheme() == Qt::ColorScheme::Light) {
            path = "/usr/share/wallpapers/" + image + "/contents/images";
        }
        else {
            path = "/usr/share/wallpapers/" + image + "/contents/images_dark";
        }

        QDir pathname(path);

        QStringList files = pathname.entryList(QDir::Files | QDir::NoDotAndDotDot);
        QString file = files[files.count() - 1];

        wallpaperPath = path + "/" + file;
    }

    return wallpaperPath;
}
