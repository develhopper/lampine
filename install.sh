echo "Installing Lampine"

mkdir -p ~/.local/bin

cp lampine.sh ~/.local/bin/lampine
cp php7/lampine.sh ~/.local/bin/lampine7

cp lampinerc ~/.lampinerc
cp php7/lampinerc ~/.lampinerc7

. ~/.lampinerc

if [ ! -d $etc_dir ];then
		mkdir -p $etc_dir
fi
cp -r ./etc/* "$etc_dir" 

echo -e "\n.:: Done ::.\n"

echo "Please Add ~/.local/bin to your PATH"

echo -e "\nto change default configs edit .lampinerc file in your home directory \nor run lampine config"

echo -e "to edit apache or php configs edit files in $etc_dir directory\n"

echo "Have Fun :)"
