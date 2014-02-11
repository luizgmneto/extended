#!/bin/bash
# create debian, redhat and tar.gz packages

directory=`dirname $0`
echo "Working in $directory"
cd $directory 
./version.sh ./CreateUpdateIni/DEBIAN/control ./i386-linux/CreateUpdateIni.ini
cp ./i386-linux/CreateUpdateIni ./CreateUpdateIni/usr/share/createupdateini
cp ./i386-linux/CreateUpdateIni.ini ./CreateUpdateIni/usr/share/createupdateini
sudo chown -R root CreateUpdateIni.tar
sudo tar -czvf CreateUpdateIni.tar.gz CreateUpdateIni.tar
sudo chown -R matthieu CreateUpdateIni.tar
sudo chown -R root CreateUpdateIni
sudo dpkg-deb -b CreateUpdateIni 
sudo chown -R matthieu CreateUpdateIni
sudo chown matthieu *.deb
rm *el.rpm
sudo alien -r --scripts CreateUpdateIni.deb
sudo chown matthieu *.rpm
mv *i386*.rpm CreateUpdateIni.rpm
