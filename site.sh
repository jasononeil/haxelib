#!/bin/bash

# Build the site, copy components over

mkdir -p www/legacy
mkdir -p www/api/3.0

haxe site.hxml

cp src/tools/haxelib/.htaccess www/
cp -ar src/tools/haxelib/tmpl www/
cp src/tools/haxelib/haxelib.css www/
cp src/tools/haxelib/dbconfig.json.example www/

cp src/tools/legacyhaxelib/.htaccess www/legacy/
cp src/tools/legacyhaxelib/website.mtt www/legacy/
cp src/tools/legacyhaxelib/haxelib.css www/legacy/

# If the databases don't exist, run "setup"

if [ ! -f www/haxelib.db ];
then
    cd www
    neko index.n setup
    cd ..
fi

if [ ! -f www/legacy/haxelib.db ];
then
    cd www/legacy
    neko index.n setup
    cd ../..
fi

# Make sure the server folders are writeable.  

chmod a+w www
chmod a+w www/tmp
chmod a+w www/files
chmod a+w www/files/3.0
chmod a+w www/legacy
chmod a+w www/haxelib.db
chmod a+w www/legacy/haxelib.db


cd www
# starting server on port 2000, because binding port 80 requires root privileges,
# which might be a bad idea
nekotools server -rewrite
