#!/bin/bash
less <&0
user_pwd=$1

for user in mleone zainsw; do 
  EXISTS=`ls /home/ | grep $user`
  
  if [ "$EXISTS" != "" ]; then
    echo "Found User $user, adding groups"
  else
    echo "User $user does not exists, creating it"
    useradd -g rfdev -m -d /home/$user -s /bin/bash $user
    echo "Setting the password"
    passwd ${user} << EOF 
${user_pwd}
${user_pwd}
EOF
    chage -d 0 $user
  fi

usermod -aG wheel $user
usermod -aG docker $user

done


