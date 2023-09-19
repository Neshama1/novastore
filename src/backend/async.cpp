#include "backend/async.h"
#include <QDebug>
#include <QtCore>

Async::Async()
{
}

Async::~Async()
{
}

void Async::run()
{
    int error;

    if (m_operation == "get")
        error = system("echo " + m_pass.toUtf8() + " | sudo -S zypper -n install " + m_package.toStdString().c_str());
    if (m_operation == "remove")
        error = system("echo " + m_pass.toUtf8() + " | sudo -S zypper -n remove " + m_package.toStdString().c_str());

    QProcess notification;

    if (error == 0)
    {
        if (m_operation == "get")
            notification.execute("kdialog --passivepopup \"The application has been installed\" 2");
        if (m_operation == "remove")
            notification.execute("kdialog --passivepopup \"The application has been removed\" 2");
    }
    else
    {
        notification.execute("kdialog --passivepopup \"An error occurred\" 2");
    }
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
    emit packageChanged(m_package);
}

void Async::setOperation(QString operation)
{
    m_operation = operation;
}

void Async::setPassword(QString pass)
{
    m_pass = pass;
}
