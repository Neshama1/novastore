#include "repodata.h"
#include <QDebug>
#include <QDir>
#include <QString>
#include <QStringList>
#include <KConfig>
#include <KConfigGroup>
#include <QVariantMap>

RepoData::RepoData()
{
    QVariantList repos;
    m_repos.clear();

    // GET FILE LIST

    QString repoPath = "/etc/zypp/repos.d";
    QDir repoDir = QDir(repoPath);
    QStringList repoList = repoDir.entryList(QStringList() << "*.repo", QDir::Files);

    qDebug() << "Repositories" << repoList;

    // GET REPO INFO

    for (QString repo : repoList) {

        qDebug() << "Get data from repo" << repo;

        QString file = repoPath + "/" + repo;
        KConfig repoFile(file, KConfig::SimpleConfig);
        QStringList groupList = repoFile.groupList();

        for (const QString& group : groupList) {

            KConfigGroup repoGroup = repoFile.group(group);

            if (repoGroup.exists()) {

                qDebug() << "Get data from group" << group;

                QVariantMap rpInfo;
                QStringList keyList = repoGroup.keyList();

                rpInfo["filename"] = repo;
                rpInfo["alias"] = group;

                /*
                rpInfo["name"] = "";
                rpInfo["baseurl"] = "";
                rpInfo["enabled"] = 0;
                rpInfo["autorefresh"] = 0;
                rpInfo["priority"] = "";
                rpInfo["type"] = "";
                rpInfo["keeppackages"] = 0;
                rpInfo["gpgcheck"] = 0;
                rpInfo["gpgkey"] = "";
                */

                /*
                for (const QString& key : keyList) {
                    QVariant value = repoGroup.readEntry(key, QVariant());

                    if (key == "name") {
                        rpInfo["name"] = value;
                    }
                }
                */

                // ADD REPO

                repos.append(rpInfo);
            }
        }
    }

    m_repos = repos;

    qDebug() << "Repositorios" << "punto 1" << m_repos;
}

QVariantList RepoData::repositories() const
{
    return m_repos;
}

void RepoData::setRepositories(const QVariantList &repos)
{
    if (m_repos != repos) {
        return;
    }

    m_repos = repos;

    Q_EMIT repositoriesChanged();
}
