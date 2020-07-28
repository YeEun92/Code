############ https://devtidbits.com/2015/11/26/update-the-nano-text-editor-on-ubuntu/

### Update nano

# when if you start qiime1 with disk, may be nano version is v2.x
# so if you wanna use nano little bit fancier, then update nano

# first, check version
nano -V

# Compile and install

# First we remove the existing nano package and install some dependencies that we will need to compile nano from source. 
sudo apt-get build-dep nano
sudo apt-get install libmagic-dev

# download
cd ~
wget http://www.nano-editor.org/dist/v2.9/nano-2.9.3.tar.gz
tar -xf nano-2.9.3.tar.gz
cd nano-2.9.3

# run configureation script
./configure --enable-utf8

# now compile and install
make
sudo apt-get remove nano
sudo make install

#Bash shell users will need to reload .bashrc.
source ~/.bashrc
nano -V

### setting nano

# The nano install copies a sample settings file into the etc directory. We will duplicate this file to our home directory and apply our own custom settings.

cp ~/nano-2.9.2/doc/sample.nanorc ~/.nanorc
nano ~/.nanorc
# In nano tap Ctrl _ (underscore) and type 258 to jump to line 258. Un-comment the following text and exit nano.

# include "/usr/local/share/nano/*.nanorc" (remove #)
# Reload and again edit .nanorc but now it will be in colour.

nano ~/.nanorc
# Go through the .nanorc<em> settings file and un-comment any features you want turned on. I personally enable.
# It means if you wanna that setting, remove # and un-comment it.

set boldtext
set constantshow
set linenumbers
set mouse
set smarthome
set smooth
set titlecolor brightwhite,blue
set statuscolor brightwhite,green
set selectedcolor brightwhite,magenta
set numbercolor white
set keycolor cyan
set functioncolor green