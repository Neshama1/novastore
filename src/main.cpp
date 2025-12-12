// INCLUDE (BASIC SET)

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCommandLineParser>
#include <QFileInfo>
#include <QIcon>

#include <KAboutData>
#include <KLocalizedString>

// INCLUDE

#include <MauiKit4/Core/mauiapp.h>
#include <MauiKit4/FileBrowsing/fmstatic.h>
#include <MauiKit4/FileBrowsing/moduleinfo.h>
#include <MauiMan4/thememanager.h>

#include "code/appbackend.h"
#include "code/async.h"
#include "code/repodata.h"
#include "code/systeminfo.h"

#include "../novastore_version.h"

#define NOVASTORE_URI "org.kde.novastore"

// MAIN FUNCTION

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    // APP

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    if (!MAUIAndroid::checkRunTimePermissions({"android.permission.WRITE_EXTERNAL_STORAGE"}))
        return -1;
#else
    QGuiApplication app(argc, argv);
#endif

    app.setOrganizationName("KDE");
    app.setWindowIcon(QIcon(":/assets/logo.svg"));
    QGuiApplication::setDesktopFileName(QStringLiteral("project"));
    KLocalizedString::setApplicationDomain("novastore");

    // SETS THE VALUE OF THE ENVIRONMENT VARIABLES

    // To make requests to a REST API (RadioBrowser) XMLHttpRequest is used.
    // Set QML_XHR_ALLOW_FILE_READ to 1 to access local files (read).

    // qputenv("QML_XHR_ALLOW_FILE_READ", "1");

    // ABOUT DIALOG

    KAboutData about(QStringLiteral("novastore"),
                     QStringLiteral("Nova Store"),
                     NOVASTORE_VERSION_STRING,
                     i18n("Zypper based package manager."),
                     KAboutLicense::LGPL_V3,
                     APP_COPYRIGHT_NOTICE,
                     QString(GIT_BRANCH) + "/" + QString(GIT_COMMIT_HASH));

    about.addAuthor(QStringLiteral("Miguel Beltrán"), i18n("Developer"), QStringLiteral("novaflowos@gmail.com"));
    about.setHomepage("https://www.novaflowos.com");
    about.setProductName("novastore");
    about.setBugAddress("https://github.com/Neshama1/novastore/issues");
    about.setOrganizationDomain(NOVASTORE_URI);
    about.setProgramLogo(app.windowIcon());

    const auto FBData = MauiKitFileBrowsing::aboutData();
    about.addComponent(FBData.name(), MauiKitFileBrowsing::buildVersion(), FBData.version(), FBData.webAddress());

    KAboutData::setApplicationData(about);
    MauiApp::instance()->setIconName("qrc:/assets/logo.svg");

    // COMMAND LINE

    QCommandLineParser parser;

    about.setupCommandLine(&parser);
    parser.process(app);
    about.processCommandLine(&parser);

    const QStringList args = parser.positionalArguments();
    QPair<QString, QList<QUrl>> arguments;

    // arguments.first
    // args.isEmpty()

    // QQMLAPPLICATIONENGINE

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/org/kde/novastore/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url, &arguments](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    // C++ BACKENDS

	AppBackend appbackend;
	qmlRegisterSingletonInstance<AppBackend>("org.kde.novastore", 1, 0, "AppBackend", &appbackend);

    RepoData repodata;
    qmlRegisterSingletonInstance<RepoData>("org.kde.novastore", 1, 0, "RepoData", &repodata);

    SystemInfo systeminfo;
    qmlRegisterSingletonInstance<SystemInfo>("org.kde.novastore", 1, 0, "SystemInfo", &systeminfo);

    // TIPOS

    qmlRegisterType<MauiMan::ThemeManager>("org.kde.novastore", 1, 0, "ThemeManager");

    /*
    qmlRegisterType<Plasma::Theme>("org.kde.novastore", 1, 0, "PlasmaTheme");
    */

	qmlRegisterType<Async>("Async", 1, 0, "Async");

    // LOAD MAIN.QML

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.load(url);

    // EXEC APP

    return app.exec();
}
