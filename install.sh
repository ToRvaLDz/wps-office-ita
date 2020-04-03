#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}" )"

WPS_LOCAL_FLATPAK_DIR="$HOME/.local/share/flatpak/app/com.wps.Office/current/active/files"
WPS_WIDE_FLATPAK_DIR="/var/lib/flatpak/app/com.wps.Office/current/active/files"
WPS_SNAP_DIR="$HOME/snap/wps-office/current/.kingsoft/office6"
WPS_SNAP_ALT_DIR="$HOME/snap/wps-office-multilang/current/.kingsoft/office6"
WPS_OPT_DIR="/opt/kingsoft/wps-office"
WPS_USR_DIR="/usr/lib/office6"

echo "Cerco i percorsi di installazione..."

if [ -d "$WPS_LOCAL_FLATPAK_DIR" ]; then
	echo "Rilevata installazione Flatpak locale, configuro i percorsi...";
	DICT_DIR="$WPS_LOCAL_FLATPAK_DIR/extra/wps-office/office6/dicts/spellcheck"
	MUI_DIR="$WPS_LOCAL_FLATPAK_DIR/share/wps/office6/mui"
	FONT_DIR="$HOME/.fonts"
elif [ -d "$WPS_WIDE_FLATPAK_DIR" ]; then
	echo "Rilevata installazione Flatpak globale, configuro i percorsi...";
	if [[ $(id -u) -ne 0 ]] ; then
  		echo "Per l'installazione globale bisogna lanciare lo script con i permessi di root."
  		exit 1
	fi
	DICT_DIR="$WPS_WIDE_FLATPAK_DIR/extra/wps-office/office6/dicts/spellcheck"
	MUI_DIR="$WPS_WIDE_FLATPAK_DIR/share/wps/office6/mui"
	FONT_DIR="/usr/share/fonts"
elif [ -d "$WPS_SNAP_DIR" ]; then
	echo "Rilevata installazione SNAP, configuro i percorsi..."
	DICT_DIR="$WPS_SNAP_DIR/dicts"
	MUI_DIR="$WPS_SNAP_DIR/mui"
	FONT_DIR="$HOME/.fonts"
elif [ -d "$WPS_SNAP_ALT_DIR" ]; then
	echo "Rilevata installazione SNAP, configuro i percorsi..."
	DICT_DIR="$WPS_SNAP_ALT_DIR/dicts"
	MUI_DIR="$WPS_SNAP_ALT_DIR/mui"
	FONT_DIR="$HOME/.fonts"
elif [ -d "$WPS_OPT_DIR" ]; then	
	echo "Rilevata installazione in $WPS_OPT_DIR"
	if [[ $(id -u) -ne 0 ]] ; then
  		echo "Per l'installazione globale bisogna lanciare lo script con i permessi di root."
  		exit 1
	fi
	DICT_DIR="$HOME/.kingsoft/office6/dicts"
	MUI_DIR="$WPS_OPT_DIR/mui"
	FONT_DIR="/usr/share/fonts"
elif [ -d "$WPS_USR_DIR" ]; then	
	echo "Rilevata installazione in $WPS_USR_DIR"
	if [[ $(id -u) -ne 0 ]] ; then
  		echo "Per l'installazione globale bisogna lanciare lo script con i permessi di root."
  		exit 1
	fi
	DICT_DIR="$HOME/.kingsoft/office6/dicts"
	MUI_DIR="$WPS_USR_DIR/mui"
	FONT_DIR="/usr/share/fonts"	
else
	echo "Nessuna installazione trovata!"
	exit 0
fi

if [ -d "$FONT_DIR" ]; then
	echo "Creo la directory fonts..."
	mkdir -p $FONT_DIR
fi

echo "Creo le directory di installazione mancanti..."
if [ -d "$DICT_DIR" ]; then
	mkdir -p $DICT_DIR
fi

if [ -d "$MUI_DIR" ]; then
	mkdir -p $MUI_DIR
fi

if [ -d "$MUI_DIR" ]; then
	mkdir -p $FONT_DIR
fi


echo "Copia del dizionario italiano..."
cp dicts/spellcheck/it_IT $DICT_DIR -rf

echo "Copia interfaccia italiana..."
cp mui/it_IT $MUI_DIR -rf

echo "Copio i fonts..."
cp wps-fonts $FONT_DIR -rf

echo "Setto i permessi..."
chmod 755 $FONT_DIR/wps-fonts -R
chmod 755 $MUI_DIR/it_IT -R
chmod 755 $DICT_DIR/it_IT -R

echo "Rigenero la cache dei fonts..."
fc-cache -vfs


echo "Installazione terminata."
exit 0