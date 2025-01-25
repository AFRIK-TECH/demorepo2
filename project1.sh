#!/bin/bash

# Initialize variables
username=""
ipadress=""
answer=""

# Step 1: Generate SSH keys
echo "****************************************************************************************************************+"
echo "******* Welcome to my SSH key generation script, follow the steps and everything will be OK ********************+"
echo "****************************************************************************************************************+"
echo ""
echo""
echo""

ssh-keygen -t rsa -b 4096 -C "davidnguena270@gmail.com" -f ~/.ssh/first_key
echo""
echo""
echo "***************************************************************************************************************"
echo "First key created. We will now create the second key."
echo "***************************************************************************************************************"
echo ""
echo""
ssh-keygen -t rsa -b 4096 -C "davidnguena270@gmail.com" -f ~/.ssh/second_key

echo""
echo "***********************************************************************************************************************"
echo "Great! The keys have been created successfully. Next, we will copy these keys to the server."
echo "I will prompt you to enter the server username and IP address because these might change due to your Wi-Fi address provider."
echo "***************************************************************************************************************************"
echo ""
while [[ -z "$username" || -z "$ipadress" ]]; do
    # Check for the username and read the value input by the user
    if [[ -z "$username" ]]; then
echo""
        read -p "Entrez le nom d'utilisateur de votre serveur: " username
echo""
echo
    fi

    # Check for the IP address and read the value input by the user
    if [[ -z "$ipadress" ]]; then
	    echo
        read -p "Entrez l'adresse IP de votre serveur: " ipadress
	echo
	echo
    fi

    # Validate inputs are not empty
    if [[ -z "$username" ]]; then
	    echo
	    echo
        echo "Le nom d'utilisateur de votre serveur ne peut pas être vide."
	echo
	echo
    fi

    if [[ -z "$ipadress" ]]; then
	    echo
	    echo
        echo "L'adresse IP de votre serveur ne peut être vide."
	echo
	echo
    fi
done

# Copy keys to the server
ssh-copy-id -i ~/.ssh/first_key.pub "$username@$ipadress"
ssh-copy-id -i ~/.ssh/second_key.pub "$username@$ipadress"


echo
echo
echo "The keys have been successfully copied to the server."
echo "Now, we will create the alias that shall be used to connect to the server."
echo
echo

# Create SSH config file and write aliases
touch ~/.ssh/config
cat > ~/.ssh/config <<EOF
Host connection1
    HostName $ipadress
    User $username
    IdentityFile ~/.ssh/first_key
    Port 22

Host connection2
    HostName $ipadress
    User $username
    IdentityFile ~/.ssh/second_key
    Port 22
EOF

echo
echo
echo "The SSH configuration has been written to the config file."
echo "Do you want to check the configuration file?"
echo "******************************************"
echo "  yes ******** or ********* no ***********"
echo
read answer

# Validate user choice
while [[ -z "$answer" || ( "$answer" != "yes" && "$answer" != "no" ) ]]; do
	echo
	echo
    echo "Your choice cannot be null. Please choose 'yes' or 'no'."
    read answer
done

if [[ "$answer" == "yes" ]]; then 
    cat ~/.ssh/config
    echo
    echo
  echo " Everything is configured as you can see, now try accessing your server via the aliases 'connection1' or 'connection2'."
else
    echo "Great! Everything is configured. You can try accessing your SSH via the aliases 'connection1' or 'connection2'."
fi

