initdb -D mylocal_db3
pg_ctl -D mylocal_db3 -l logfile start
createuser --encrypted --no-password mynonsuperuser3
createdb mylocal_db3
echo "alter user mynonsuperuser3 with encrypted password 'password';" > db_test
echo "grant all privileges on database mylocal_db3 to mynonsuperuser3" >> db_test
psql mylocal_db3 < db_test
git clone https://github.com/lmb-embrapa/machado.git $CONDA_PREFIX/src/machado/	
python $CONDA_PREFIX/src/machado/setup.py install --single-version-externally-managed --record=record.txt
mkdir $CONDA_PREFIX/machado-django
cd $CONDA_PREFIX/machado-django
django-admin startproject WEBPROJECT
cd WEBPROJECT/WEBPROJECT
sed -i -E "s/.*django.contrib.staticfiles.*/    'django.contrib.staticfiles',\n    'machado'/" settings.py
sed -i -E "s/.*django.db.backends.sqlite3.*/        'ENGINE': 'django.db.backends.postgresql',    # Set the DB driver\n        'NAME': 'mylocal_db3',                       # Set the DB name\n        'USER': 'mynonsuperuser3',                           # Set the DB user/" settings.py
sed -i -E "s/.*db.sqlite3.*/        'PASSWORD': 'password',                       # Set the DB password\n        'HOST': 'localhost',                          # Set the DB host\n        'PORT': '',                                   # Set the DB port/" settings.py
cd ..
python manage.py migrate