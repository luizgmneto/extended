#!/bin/bash
# create debian, redhat and tar.gz packages

directory=`dirname $0`
echo "Working in $directory"
cd $directory 
./version.sh ./CreateUpdateIni-gnome-i386/DEBIAN/control CreateUpdateIni.ini
cp CreateUpdateIni CreateUpdateIni-gnome-i386/usr/share/createupdateini
cp CreateUpdateIni.ini CreateUpdateIni-gnome-i386/usr/share/createupdateini
cp CreateUpdateIni CreateUpdateIni-gnome-i386.tar
cp CreateUpdateIni.ini CreateUpdateIni-gnome-i386.tar
sudo chown -R root CreateUpdateIni-gnome-i386.tar
sudo tar -czvf CreateUpdateIni-gnome-i386.tar.gz CreateUpdateIni-gnome-i386.tar
sudo chown -R matthieu CreateUpdateIni-gnome-i386.tar
sudo chown -R root CreateUpdateIni-gnome-i386
sudo dpkg-deb -b CreateUpdateIni-gnome-i386
sudo chown -R matthieu CreateUpdateIni-gnome-i386
sudo chown matthieu *.deb
rm *el.rpm
sudo alien -r --scripts CreateUpdateIni-gnome-i386.deb
sudo chown matthieu *.rpm
mv *i386*.rpm CreateUpdateIni-gnome-i386.rpm
