#include "systeminfo.h"
#include <KConfig>
#include <KConfigGroup>
#include <QDebug>

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
        }
    }

    return wallpaperPath;
}
