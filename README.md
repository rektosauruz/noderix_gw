# noderix_gw
all base files for experimentation



### TERMINAL COMMANDS TO SET UP GATEWAY AS DEVICE ON GOOGLE IOT CLOUD ###

-- instruction : open up terminal, CTRL + T 



### UPDATES AND REQUIRED PROGRAMS

sudo apt-get update && sudo apt-get upgrade

sudo apt-get install build-essential

sudo apt-get install libssl-dev -E

sudo apt-get install git

sudo apt-get install python

sudo apt-get install pyhton-dev

sudo apt-get install libffi-dev

sudo pip install cryptography

sudo pip install paho-mqtt

sudo pip install pyjwt



### CLONING TUTORIALS

sudo git clone https://github.com/GoogleCloudPlatform/community.git

sudo git clone https://github.com/GabeWeiss/IoT_Core_Quick_Starts



####after creating a folder for mqtt connection, create asymmetric keys (public & private) and get the Google's CA root certificate



### line below creates a folder for the project files to run ( private key, public key, google root certificate download )
sudo mkdir project_name (for our setup its noderix_gw)

### go to noderix_gw file
cd noderix_gw/

### get google root certificates
sudo wget https://pki.goog/roots.pem

### create SHA256 key pair
openssl genrsa -out rsa_private.pem 2048
openssl rsa -in rsa_private.pem -pubout -out rsa_public.pem
