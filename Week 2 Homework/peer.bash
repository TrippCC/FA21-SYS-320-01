 #!/bin/bash

# Storyline: Create peer VPN Configuration file


# What is peer's name 
echo -n "What is the peer's name? "
read the_client

#Filename variable
pFile="${the_client}-wg0.conf"
#Check is the peer file exists
if [[ -f "${pFile}"  ]]
then


	# Prompt if we nee to overwrit the file
	echo "The file ${pFile} exists."
	echo -n "Do you want to overwrite it? [y|N]"
	read to_overwrite

	if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" ]]
	then
		echo "Exit.."
		exit 0
	elif [[ "${to_overwrite}" == "y" ]]
	then
		echo "Creating the wireguard configuration file..."
	# If the admin doesn't specify a y or N then error.
	else

		echo "Invalid Value"
		exit 1
	fi
fi


# Create a private key

p="$(wg genkey)"

# create public key

ClientPub="$(echo ${p} | wg pubkey)"


# Generate preshared key

pre="$(wg genpsk)"

#  198.199.97.163:4282 nb6w78Wq/CxBt8QVXfrZA/YdgoNlfOFhCohdp7Kcqgo= 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0

# Endpoint
end="$(head -1 wg0.conf | awk ' { print $3 } ')"
# Server Public Key
pub="$(head -1 wg0.conf | awk ' { print $4 } ')"
# DNS servers
dns="$(head -1 wg0.conf | awk ' { print $5 } ')"
# MTU
mtu="$(head -1 wg0.conf | awk ' { print $6 } ')"
# KeepAlive
keep="$(head -1 wg0.conf | awk ' { print $7 } ')"

#ListenPort
lport="$(shuf -n1 -i 40000-50000)"

#Default routes for VPN
routes="$(head -1 wg0.conf | awk ' { print $8 } ')"
#Create the client configuration file

echo "[Interface]
Address = 10.254.132.100/24
DNS = ${dns}
Listen Port = ${lport}
MTU = ${mtu}
PrivateKey = ${p}

[Peer]
AllowedIPs = ${routes}
PeerisitentKeepAlive = ${keep}
PresharedKey = ${pre}
PublicKey = ${pub}
Endpoint = ${end}
" > ${pFile}

# Add our peer configuration to the server config

echo "
#mason begin
[Peer]
PublicKey = ${ClientPub}
PresharedKey = ${pre}
AllowedIPs = 10.254.132.100/32
#mason end" | tee -a wg0.conf


