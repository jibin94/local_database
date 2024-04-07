## Enable Sqflite in Flutter
SQLite is an open-source relation database that can be used to store and manipulate data like add, delete, and remove data.
It does not require a server or back-end code and all data is saved to a text file on the device.

Step 1: Add the ```sqflite``` package to pubspec.yaml.
Visit pub.dev and add ```sqflite:^latest_version``` in the file pubspec.yaml.

Step 2: Add the ```path:^latest_version``` plugin in Flutter
The path plugin is a cross-platform path manipulation library for Dart, and it helps to specify the location of the file that contains the database.

Step 3: Create a database_helper.dart file in the service folder.

Step 4: initialize the database
✅ ```getDatabasePath()```: gets the default database location.
✅ ```openDatabase()```: accepts a mandatory String as an argument that is the path of the database.
✅ We use the method ```join()``` which is inside the package path to join the given path into a single path, so for example we would get ```databasepath/database.db```.
✅ ```onCreate()``` callback: It will be called when the database is created for the first time, and it will execute the above SQL query to create the table notes. This is where the creation of tables and the initial population of the tables should happen.

### Upgrade the table schema in SQLite
In the SQLite, ```onCreate()``` and ```onUpgrade()``` are invoked when the database is opened. The version number is an int argument that is passed to the constructor and is saved within the SQLite database file.
✅ ```onCreate()``` callback: It is called when the database file did not exist and was just created. If onCreate() returns successfully and does not throw an exception, the database is assumed to be created with the requested version number.
✅ ```onUpgrade()``` callback: It is called when the database file exists but the version number is lower than requested in the constructor. Basically, it’s used when the database needs to be upgraded. The implementation should use this method to drop tables, add tables, or do anything else it needs to upgrade to the new schema version.
The ```onUpgrade()``` should update the table schema to the requested version.

Two approaches to changing the table schema:
1️⃣: Delete the old database file so the ```onCreate()``` callback is run again. This is perfect during the development time when you have more control over the installed versions and data loss is not an issue.
2️⃣: Increment the version number so the ```onUpgrade()``` callback is invoked. During the development time, when data loss is not an issue, you can execute a SQL like DROP TABLE IF EXIST <table name> to remove the existing tables and call ```onCreate()``` to re-create the database.
However, if the app is released, you need to implement data migration in the ```onUpgrade()``` callback so your users don’t lose their data.


