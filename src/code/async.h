#ifndef ASYNC_H
#define ASYNC_H

#include <QThread>
#include <QObject>

class Async : public QThread
{
    Q_OBJECT
    Q_PROPERTY(QString package READ package WRITE setPackage NOTIFY packageChanged)

public:
    Q_INVOKABLE void setOperation(QString operation);
    Q_INVOKABLE QString getOperation();
    Q_INVOKABLE void setQuery(QString query);
    Q_INVOKABLE void setPassword(QString password);

public:
    Async();
    ~Async();

    QString package() const;

    void run();

public Q_SLOTS:
    void setPackage(QString packages);

Q_SIGNALS:
    void packageChanged(QString package);
    void taskCompleted(int error);

private:
    QString name;
    QString m_package;
    QString m_operation;
    QString m_query;
    QString m_password;
};

#endif // ASYNC_H
