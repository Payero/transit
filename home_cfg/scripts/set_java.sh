#!/bin/sh

echo ""
echo "Setting all the links for Java"
echo ""

JAVA_SRC=/usr/java/latest



for exe in $( ls ${JAVA_SRC}/bin ); do
	if [ -e /usr/bin/$exe ]; then
		rm -f /usr/bin/$exe
		#echo "Removing file /usr/bin/$exe"
	fi
	
	#echo "Creating link: ln -s ${JAVA_SRC}/bin/$exe /usr/bin/$exe"
	ln -s ${JAVA_SRC}/bin/$exe /usr/bin/$exe
	
done
