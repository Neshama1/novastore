#include "async.h"
#include <QDebug>
#include <QtCore>

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

Async::Async()
{
}

Async::~Async()
{
}

void Async::run()
{
    qDebug() << "empieza hilo asíncrono";

    int error;

    QString command;

    if (m_operation == "get") {
        QString command;
        command = "echo " + m_password.toUtf8() + " | sudo -S zypper -n install " + m_package.toStdString().c_str();
        error = system(command.toUtf8());
    }
    if (m_operation == "remove") {
        QString command;
        command = "echo " + m_password.toUtf8() + " | sudo -S zypper -n remove " + m_package.toStdString().c_str();
        error = system(command.toUtf8());
    }
    if (m_operation == "refresh") {
        QString command;
        command = "echo " + m_password.toUtf8() + " | sudo -S zypper -n refresh";
        error = system(command.toUtf8());
    }
    if (m_operation == "get-requires") {

        // GET REQUIRES

        qDebug() << "empieza obtener paquetes requeridos";

        QProcess *process = new QProcess(this->parent());
        QStringList arguments;
        arguments << "-x" << "search" << "--requires" << m_query;
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

        /*
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
        */

        qDebug() << "paquetes requeridos han sido obtenidos";
    }
    if (m_operation == "get-provides") {

        // GET PROVIDES

        QProcess *process = new QProcess(this->parent());
        QStringList arguments;

        arguments << "-x" << "search" << "--provides" << m_query;
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

        /*
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
        */
    }
    if (m_operation == "get-apps") {

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

        /*
        qDebug() << "salida estandar" << output;
        */

        // Load XML document

        /*
        QDomDocument appsXML;

        QFile xmlFile("/tmp/apps.xml");
        if (!xmlFile.open(QIODevice::ReadOnly))
        {
            // Error while loading file
        }
        appsXML.setContent(&xmlFile);
        xmlFile.close();
        */
    }
    if (m_operation == "get-packages") {
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

        /*
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
        */
    }

    QProcess notification;

    if (error == 0)
    {
        /*
        if (m_operation == "get")
            notification.execute("kdialog --passivepopup \"The application has been installed\" 30");

        if (m_operation == "remove")
            notification.execute("kdialog --passivepopup \"The application has been removed\" 30");
        */
    }
    else
    {
        notification.execute("kdialog --passivepopup \"An error occurred\" 10");
    }

    qDebug() << "enviar señal";

    taskCompleted(error);

    qDebug() << "ha terminado hilo asíncrono";
}

QString Async::package() const
{
    return m_package;
}

void Async::setPackage(QString package)
{
    if (m_package == package) {
        return;
    }

    qDebug() << package;

    m_package = package;
    Q_EMIT packageChanged(m_package);
}

void Async::setOperation(QString operation)
{
    m_operation = operation;
}

QString Async::getOperation()
{
    return m_operation;
}

void Async::setQuery(QString query)
{
    m_query = query;
}

void Async::setPassword(QString password)
{
    m_password = password;
}
