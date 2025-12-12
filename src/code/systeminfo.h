#ifndef SYSTEMINFO_H
#define SYSTEMINFO_H

#include <QObject>
#include <QString>

class SystemInfo : public QObject {
    Q_OBJECT

public:
    explicit SystemInfo();

public:
    Q_INVOKABLE QString getWallpaper();
};

#endif // SYSTEMINFO_H
