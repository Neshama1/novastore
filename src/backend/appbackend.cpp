// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "backend/appbackend.h"
#include <QtCore>

AppBackend::AppBackend()
{
    m_query = "";
}

AppBackend::~AppBackend()
{
}

QVariantList AppBackend::packages() const
{
    return m_packages;
}

void AppBackend::setPackages(QVariantList packages)
{
    if (m_packages == packages) {
        return;
    }

    m_packages = packages;
    emit packagesChanged(m_packages);
}

QVariantList AppBackend::package() const
{
    return m_package;
}

void AppBackend::setPackage(QVariantList package)
{
    if (m_package == package) {
        return;
    }

    m_package = package;
    emit packageChanged(m_package);
}

int AppBackend::count() const
{
    return m_count;
}

void AppBackend::setCount(int count)
{
    if (m_count == count) {
        return;
    }

    m_count = count;
    emit countChanged(m_count);
}

void AppBackend::search(QString package)
{
    m_packages.clear();

    if (package == "")
        return;

    m_query = package;

    // Search..

    qDebug() << package;

    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << "-x" << "search" << "-t" << "package" << package;
    process->start("zypper",arguments);

    QString output;
    if (process->waitForStarted(-1)) {
        while(process->waitForReadyRead(-1)) {
            output += process->readAll();
        }
    }
    process->waitForFinished();


    QFile file("/tmp/search.xml");
    QTextCodec *codec = QTextCodec::codecForLocale();

    if (!file.open(QFile::ReadWrite|QFile::Truncate)) {
        qDebug() << "Error opening for write: " << file.errorString();
        return;
    }
    file.write(codec->fromUnicode(output));
    file.close();

    qDebug() << "salida estandar" << output;

    // Load XML document
    QDomDocument appsXML;

    QFile xmlFile("/tmp/search.xml");
    if (!xmlFile.open(QIODevice::ReadOnly))
    {
        // Error while loading file
    }
    appsXML.setContent(&xmlFile);
    xmlFile.close();

    QDomElement root = appsXML.documentElement();
    QDomElement node = root.firstChild().toElement();

    int count = 0;

    while(node.isNull() == false)
    {
        node = node.nextSibling().toElement();
        if(node.tagName() == "search-result"){
            QDomNode solvableListNode = node.firstChild();
                while (!solvableListNode.isNull()) {
                    QDomElement solvableListElement = node.firstChild().toElement();
                    QDomNode solvableNode = solvableListElement.firstChild();
                    while (!solvableNode.isNull()) {
                        QDomElement solvableElement = solvableNode.toElement();

                        QVariantMap item;
                        item["status"] = solvableElement.attribute("status","status");
                        item["name"] = solvableElement.attribute("name","name");
                        item["summary"] = solvableElement.attribute("summary","summary");
                        item["kind"] = solvableElement.attribute("kind","kind");
                        m_packages.append(item);
                        count++;

                        solvableNode = solvableNode.nextSibling();
                    }
                    solvableListNode = solvableListNode.nextSibling();
                }
        }
    }
    m_count = count;
}

void AppBackend::detail(QString package)
{
    m_package.clear();

    // Detail

    qDebug() << package;

    QProcess *process = new QProcess(this->parent());
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    env.insert("LANG", "en");
    process->setProcessEnvironment(env);
    QStringList arguments;
    arguments << "info" << package;
    process->start("zypper",arguments);

    QString output;
    if (process->waitForStarted(-1)) {
        while(process->waitForReadyRead(-1)) {
            output += process->readAll();
        }
    }
    process->waitForFinished();


    QFile file("/tmp/detail.txt");
    QTextCodec *codec = QTextCodec::codecForLocale();

    if (!file.open(QFile::ReadWrite|QFile::Truncate)) {
        qDebug() << "Error opening for write: " << file.errorString();
        return;
    }
    file.write(codec->fromUnicode(output));
    file.close();

    // Load detail.txt

    QFile inputFile(QString("/tmp/detail.txt"));
    inputFile.open(QIODevice::ReadOnly);
    if (!inputFile.isOpen())
        return;

    QTextStream stream(&inputFile);
    QString line = stream.readLine();

    QVariantMap item;
    bool start = false;
    int indexInfo = 0;
    QString description;

    while (!line.isNull())
    {
        /* process information */
        line = stream.readLine();

        if (start == true)
        {
            if (indexInfo == 0)
                item["repository"] = line.remove("Repository     : ");
            if (indexInfo == 1)
                item["name"] = line.remove("Name           : ");
            if (indexInfo == 2)
                item["version"] = line.remove("Version        : ");
            if (indexInfo == 3)
                item["arch"] = line.remove("Arch           : ");
            if (indexInfo == 4)
                item["vendor"] = line.remove("Vendor         : ");
            if (indexInfo == 5)
                item["installedsize"] = line.remove("Installed Size : ");
            if (indexInfo == 6)
                item["installed"] = line.remove("Installed      : ");
            if (indexInfo == 7)
                item["status"] = line.remove("Status         : ");
            if (indexInfo == 8)
                item["source"] = line.remove("Source package : ");
            if (indexInfo == 9)
                item["url"] = line.remove("Upstream URL   : ");
            if (indexInfo == 10)
                item["summary"] = line.remove("Summary        : ");
            if (indexInfo > 11)
                description.append(line);

            indexInfo++;
        }

        if (line.contains("----------"))
            start = true;
    }

    QString cleanDescription = description.remove(0,4);
    item ["description"] = cleanDescription;
    m_package.append(item);
}

void AppBackend::listModernApps()
{
    m_packages.clear();

    // Search..

    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << "-x" << "search" << "-r" << "https://download.opensuse.org/repositories/home:/hopeandtruth6517:/mauikit-apps/openSUSE_Tumbleweed/" << "-r" << "https://download.opensuse.org/repositories/home:/hopeandtruth6517:/kirigami-apps/openSUSE_Tumbleweed/" << "-r" << "https://download.opensuse.org/repositories/home:/hopeandtruth6517:/nova-apps/home_hopeandtruth6517_mauikit-apps_tumbleweed" << "-t" << "package" << "*";
    process->start("zypper",arguments);

    QString output;
    if (process->waitForStarted(-1)) {
        while(process->waitForReadyRead(-1)) {
            output += process->readAll();
        }
    }
    process->waitForFinished();


    QFile file("/tmp/search.xml");
    QTextCodec *codec = QTextCodec::codecForLocale();

    if (!file.open(QFile::ReadWrite|QFile::Truncate)) {
        qDebug() << "Error opening for write: " << file.errorString();
        return;
    }
    file.write(codec->fromUnicode(output));
    file.close();

    qDebug() << "salida estandar" << output;

    // Load XML document
    QDomDocument appsXML;

    QFile xmlFile("/tmp/search.xml");
    if (!xmlFile.open(QIODevice::ReadOnly))
    {
        // Error while loading file
    }
    appsXML.setContent(&xmlFile);
    xmlFile.close();

    QDomElement root = appsXML.documentElement();
    QDomElement node = root.firstChild().toElement();

    int count = 0;

    while(node.isNull() == false)
    {
        node = node.nextSibling().toElement();
        if(node.tagName() == "search-result"){
            QDomNode solvableListNode = node.firstChild();
                while (!solvableListNode.isNull()) {
                    QDomElement solvableListElement = node.firstChild().toElement();
                    QDomNode solvableNode = solvableListElement.firstChild();
                    while (!solvableNode.isNull()) {
                        QDomElement solvableElement = solvableNode.toElement();

                        QVariantMap item;
                        item["status"] = solvableElement.attribute("status","status");
                        item["name"] = solvableElement.attribute("name","name");
                        item["summary"] = solvableElement.attribute("summary","summary");
                        item["kind"] = solvableElement.attribute("kind","kind");
                        m_packages.append(item);
                        count++;

                        solvableNode = solvableNode.nextSibling();
                    }
                    solvableListNode = solvableListNode.nextSibling();
                }
        }
    }
    m_count = count;
}

void AppBackend::refresh(QString pass)
{
    QByteArray sudoPwd(pass.toUtf8());
    int error = system("echo " + sudoPwd + " | sudo -S zypper -n refresh");

    QProcess notification;

    if (error == 0)
    {
        notification.execute("kdialog --passivepopup \"Repositories has been updated.\" 2");
    }
    else
    {
        notification.execute("kdialog --passivepopup \"An error occurred\" 2");
    }
}

void AppBackend::updateState()
{
    search(m_query);
}
