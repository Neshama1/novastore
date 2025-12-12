#ifndef REPOS_H
#define REPOS_H

#include <QObject>
#include <QVariantList>

class RepoData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList repositories READ repositories WRITE setRepositories NOTIFY repositoriesChanged)

public:
    explicit RepoData();

public Q_SLOTS:
    QVariantList repositories() const;
    void setRepositories(const QVariantList &repos);

Q_SIGNALS:
    void repositoriesChanged();

private:
    QVariantList m_repos;
};

#endif  // REPOS_H
