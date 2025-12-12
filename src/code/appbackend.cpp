// <one line to give the program's name and a brief idea of what it does.>
// SPDX-FileCopyrightText: 2023 asterion <email>
// SPDX-License-Identifier: GPL-3.0-or-later

#include "appbackend.h"
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
    Q_EMIT packagesChanged(m_packages);
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
    Q_EMIT packageChanged(m_package);
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
    Q_EMIT countChanged(m_count);
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
    arguments << "-x" << "search" << "--search-descriptions" << "-t" << "package" << package;
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

    //m_count = count;
}

void AppBackend::detail(QString package)
{
    m_package.clear();

    // PACKAGE

    qDebug() << package;

    // GET INFO

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

    // GET DATA IN OBJECT

    QTextStream stream(&output);

    QVariantMap item;
    QString description;
    bool start = false;

    QString line = stream.readLine();

    while (!stream.atEnd()) {

        line = stream.readLine();

        if (start) {

            // GET KEYS AND VALUES

            QString key = line.section(':', 0, 0).trimmed().toLower();
            QString value = line.section(':', 1).trimmed();

            if (key != "description") {
                item[key] = value;
            }
            else {

                // GET KEY AND VALUE FOR DESCRIPTION

                QString description;

                while (!stream.atEnd()) {
                    line = stream.readLine().trimmed();
                    if (line != "") {
                        description += line + " ";
                    }
                }

                value = description.trimmed();
                item[key] = value;
            }
        }

        if (line.contains("----------"))
            start = true;
    }

    m_package.append(item);
}

void AppBackend::listModernApps()
{
    m_packages.clear();

    // Search..

    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << "-x" << "search" << "-r" << "https://download.opensuse.org/repositories/home:/hopeandtruth6517:/mauikit-apps/openSUSE_Tumbleweed_standard" << "-r" << "https://download.opensuse.org/repositories/home:/hopeandtruth6517:/nova-apps/mauikit-apps_openSUSE_Tumbleweed_standard" << "-r" << "https://download.opensuse.org/repositories/home:/hopeandtruth6517:/kirigami-apps/openSUSE_Tumbleweed_standard" << "-t" << "package" << "*";
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
    QString command;

    command = "echo " + sudoPwd + " | sudo -S zypper -n --gpg-auto-import-keys refresh";
    int error = system(command.toUtf8());

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

void AppBackend::getApps()
{
    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << "-x" << "search" << "--provides" << "application()";
    process->start("zypper",arguments);

    QString output;
    if (process->waitForStarted(-1)) {
        while(process->waitForReadyRead(-1)) {
            output += process->readAll();
        }
    }
    process->waitForFinished();

    QFile file("/tmp/apps.xml");
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

    QFile xmlFile("/tmp/apps.xml");
    if (!xmlFile.open(QIODevice::ReadOnly))
    {
        // Error while loading file
    }
    appsXML.setContent(&xmlFile);
    xmlFile.close();
}

void AppBackend::getPackages()
{
    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << "-x" << "search";
    process->start("zypper",arguments);

    QString output;
    if (process->waitForStarted(-1)) {
        while(process->waitForReadyRead(-1)) {
            output += process->readAll();
        }
    }
    process->waitForFinished();

    QFile file("/tmp/packages.xml");
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

    QFile xmlFile("/tmp/packages.xml");
    if (!xmlFile.open(QIODevice::ReadOnly))
    {
        // Error while loading file
    }
    appsXML.setContent(&xmlFile);
    xmlFile.close();
}

void AppBackend::getRequires(const QString &package)
{
    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << "-x" << "search" << "--requires" << package;
    process->start("zypper",arguments);

    QString output;
    if (process->waitForStarted(-1)) {
        while(process->waitForReadyRead(-1)) {
            output += process->readAll();
        }
    }
    process->waitForFinished();

    QFile file("/tmp/requires.xml");
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

    QFile xmlFile("/tmp/requires.xml");
    if (!xmlFile.open(QIODevice::ReadOnly))
    {
        // Error while loading file
    }
    appsXML.setContent(&xmlFile);
    xmlFile.close();
}

void AppBackend::getProvides(const QString &package)
{
    QProcess *process = new QProcess(this->parent());
    QStringList arguments;
    arguments << "-x" << "search" << "--provides" << package;
    process->start("zypper",arguments);

    QString output;
    if (process->waitForStarted(-1)) {
        while(process->waitForReadyRead(-1)) {
            output += process->readAll();
        }
    }
    process->waitForFinished();

    QFile file("/tmp/provides.xml");
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

    QFile xmlFile("/tmp/provides.xml");
    if (!xmlFile.open(QIODevice::ReadOnly))
    {
        // Error while loading file
    }
    appsXML.setContent(&xmlFile);
    xmlFile.close();
}
