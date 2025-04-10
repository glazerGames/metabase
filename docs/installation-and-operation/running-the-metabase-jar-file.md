---
title: Running the Metabase JAR file
redirect_from:
  - /docs/latest/operations-guide/running-the-metabase-jar-file
  - /docs/installation-and-operation/java-versions
---

# Running the Metabase OSS JAR file

> We recommend running Metabase on [Metabase Cloud](https://www.metabase.com/cloud/). If you need to self-host, you _can_ run Metabase as a standalone JAR, but [we recommend running Metabase in a Docker container](./running-metabase-on-docker.md).

To run the free, Open Source version of Metabase via a JAR file, you will need to have a Java Runtime Environment (JRE) installed on your system.

If you have a token for the [Pro or Enterprise editions](https://www.metabase.com/pricing/) of Metabase, see [Activating your Metabase commercial license](../installation-and-operation/activating-the-enterprise-edition.md).

## Quick start

> The quick start is intended for running Metabase locally. See below for instructions on [running Metabase in production](#production-installation).

If you have Java installed:

1. [Download the JAR file for Metabase OSS](https://metabase.com/start/oss/jar). If you're on a [Pro](https://www.metabase.com/product/pro) or [Enterprise](https://www.metabase.com/product/enterprise) plan, download the [JAR for the Enterprise Edition](https://downloads.metabase.com/enterprise/latest/metabase.jar).
2. Create a new directory and move the Metabase JAR into it.
3. Change into your new Metabase directory and run the JAR.

```
java --add-opens java.base/java.nio=ALL-UNNAMED -jar metabase.jar
```

Metabase will log its progress in the terminal as it starts up. Wait until you see "Metabase Initialization Complete" and visit `http://localhost:3000/setup`.

If you are using a Pro or Enterprise version, be sure to [activate your license](../installation-and-operation/activating-the-enterprise-edition.md).

## Local installation

If you just want to try Metabase out, play around with Metabase, or just use Metabase on your local machine, Metabase ships with a default application database that you can use. **This setup is not meant for production**. If you intend to run Metabase for real at your organization, see [Production installation](#production-installation).

The below instructions are the same as the quick start above, just with a little more context around each step.

### 1. Install Java JRE

You may already have Java installed. To check the version, open a terminal and run:

```
java -version
```

If Java isn't installed, you'll need to install Java before you can run Metabase. We recommend version 21 of JRE from [Eclipse Temurin](https://adoptium.net/) with HotSpot JVM. You can run Metabase wherever Java 21 runs. Earlier Java versions aren't supported. The particular processor architecture shouldn't matter (although we only test Metabase for x86 and ARM).

### 2. Download Metabase

Download the JAR file:

- [Metabase OSS](https://www.metabase.com/start/oss/jar)
- [Metabase Enterprise/Pro edition](https://downloads.metabase.com/enterprise/latest/metabase.jar)

If you want to install the [Pro or Enterprise editions](https://www.metabase.com/pricing/) of Metabase, see [Activating your Metabase commercial license](../installation-and-operation/activating-the-enterprise-edition.md).

### 3. Create a new directory and move the Metabase JAR into it

When you run Metabase, Metabase will create some new files, so it's important to put the Metabase Jar file in a new directory before running it (so move it out of your downloads folder and put it a new directory).

On posix systems, the commands would look something like this:

Assuming you downloaded to `/Users/person/Downloads`:

```
mkdir ~/metabase
```

then

```
mv /Users/person/Downloads/metabase.jar ~/metabase
```

### 4. Change into your new Metabase directory and run the jar

Change into the directory you created in step 2:

```
cd ~/metabase
```

Now that you have Java working you can run the JAR from a terminal with:

```
java --add-opens java.base/java.nio=ALL-UNNAMED -jar metabase.jar
```

Metabase will start using the default settings. You should see some log entries starting to run in your terminal window showing you the application progress as it starts up. Once Metabase is fully started you'll see a confirmation such as:

```
...
06-19 10:29:34 INFO metabase.task :: Initializing task CheckForNewVersions
06-19 10:29:34 INFO metabase.task :: Initializing task SendAnonymousUsageStats
06-19 10:29:34 INFO metabase.task :: Initializing task SendAbandomentEmails
06-19 10:29:34 INFO metabase.task :: Initializing task SendPulses
06-19 10:29:34 INFO metabase.task :: Initializing task SendFollowUpEmails
06-19 10:29:34 INFO metabase.task :: Initializing task TaskHistoryCleanup
06-19 10:29:34 INFO metabase.core :: Metabase Initialization COMPLETE
```

At this point you're ready to go! You can access your new Metabase server on port 3000, most likely at `http://localhost:3000`.

You can use another port than 3000 by setting the `MB_JETTY_PORT` [environment variable](../configuring-metabase/environment-variables.md) before running the jar.

If you are using a Pro or Enterprise version of Metabase, be sure to [activate your license](../installation-and-operation/activating-the-enterprise-edition.md).

## Production installation

The steps are similar to those steps above with two important differences: if you want to run Metabase in production, you'll want to:

- Use a [production application database](#production-application-database) to store your Metabase application data.
- Run [Metabase as a service](#running-the-metabase-jar-as-a-service).

If you'd prefer to use Docker, check out [running Metabase on Docker](running-metabase-on-docker.md).

### Production application database

Here are some [databases we support](migrating-from-h2.md#supported-databases-for-storing-your-metabase-application-data).

For example, say you want to use [PostgreSQL](https://www.postgresql.org/). You would get a PostgreSQL service up and running and create an empty database:

```
createdb metabaseappdb
```

You can call your app db whatever you want. And there's no need to create any tables in that database; Metabase will do that for you. You'll just need to set environment variables for Metabase to use on startup so Metabase knows how to connect to this database.

You'll create a directory for your Metabase like in the steps listed above for the [Local installation](#local-installation), but when it's time to run the `java --add-opens java.base/java.nio=ALL-UNNAMED -jar` command to start up the JAR, you'll prefix the command with some environment variables to tell Metabase how to connect to the `metabaseappdb` you created:

```
export MB_DB_TYPE=postgres
export MB_DB_DBNAME=metabaseappdb
export MB_DB_PORT=5432
export MB_DB_USER=username
export MB_DB_PASS=password
export MB_DB_HOST=localhost
java --add-opens java.base/java.nio=ALL-UNNAMED -jar metabase.jar
```

The above command would connect Metabase to your Postgres database, `metabaseappdb` via `localhost:5432` with the user account `username` and password `password`. If you're running Metabase as a service, you'll put these environment variables in a separate configuration file.

### Running the Metabase JAR as a service

If you need to run the JAR in production, you should run Metabase as a service. Running Metabase as a service will:

- Make sure Metabase runs automatically (and stay running).
- Allow you to run Metabase with an unprivileged user (which is good for security).

The exact instructions for how to run Metabase as a service will differ depending on your operating system. For an example of how to set up Metabase as a service, check out [Running Metabase on Debian](./running-metabase-on-debian.md).

### Migrating to a production installation

If you've been running Metabase with the default H2 application database and your team has already created questions, dashboards, collections and so on, you'll want to migrate that data to a production application database. And the sooner you do, the better. See [Migrating from the H2 database](migrating-from-h2.md).

## Troubleshooting

If you run into any problems during installation, check out our [troubleshooting page](../troubleshooting-guide/running.md).

## Upgrading Metabase

See [Upgrading Metabase](upgrading-metabase.md).

## Setting up Metabase

Now that you’ve installed Metabase, it’s time to [set it up and connect it to your database](../configuring-metabase/setting-up-metabase.md).
