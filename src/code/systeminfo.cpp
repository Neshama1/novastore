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

SystemInfo::SystemInfo() {
}

QString SystemInfo::getWallpaper() {

    // Get wallpaper

    QString wallpaperPath;

    KConfig appletsrc("plasma-org.kde.plasma.desktop-appletsrc", KConfig::NoGlobals);
    KConfigGroup containments(&appletsrc, "Containments");

    const auto groups = appletsrc.groupList();
    qDebug() << "Groups in file" << groups;

    for (const QString& group : containments.groupList()) {
        KConfigGroup containment(&containments, group);

        if (containment.groupList().contains("Wallpaper")) {
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

    return wallpaperPath;
}
