// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#ifndef APPBACKEND_H
#define APPBACKEND_H

#include <QObject>
#include <QVariantList>
#include <QDomDocument>
#include <QDomElement>
#include <QDomNode>
#include <QFile>
#include <QTextCodec>
#include <QString>
#include <QProcess>
#include <QStringList>
#include <QDebug>
#include <QByteArray>

/**
 * @todo write docs
 */
class AppBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList packages READ packages WRITE setPackages NOTIFY packagesChanged)
    Q_PROPERTY(QVariantList package READ package WRITE setPackage NOTIFY packageChanged)
    Q_PROPERTY(int count READ count WRITE setCount NOTIFY countChanged)

public:
    Q_INVOKABLE void search(QString package);
    Q_INVOKABLE void detail(QString package);
    Q_INVOKABLE void listModernApps();
    Q_INVOKABLE void refresh(QString pass);
    Q_INVOKABLE void updateState();

public:
    /**
     * Default constructor
     */
    AppBackend();

    /**
     * Destructor
     */
    ~AppBackend();

    /**
     * @return the packages
     */
    QVariantList packages() const;
    QVariantList package() const;
    int count() const;

public Q_SLOTS:
    /**
     * Sets the packages.
     *
     * @param packages the new packages
     */
    void setPackages(QVariantList packages);
    void setPackage(QVariantList packages);
    void setCount(int count);

Q_SIGNALS:
    void packagesChanged(QVariantList packages);
    void packageChanged(QVariantList packages);
    void countChanged(int count);

private:
    QVariantList m_packages;
    QVariantList m_package;
    int m_count;
    QString m_query;
};

#endif // APPBACKEND_H
