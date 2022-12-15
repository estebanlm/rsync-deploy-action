#!/bin/sh

# Prepare SSH connection
mkdir -p /root/.ssh/
echo "${INPUT_PRIVATE_SSH_KEY}" > /root/.ssh/id_rsa.key
chmod 600 /root/.ssh/id_rsa.key
ssh-keyscan -H ${INPUT_HOST} >> /root/.ssh/known_hosts
cat >>/root/.ssh/config <<END
Host server
    HostName ${INPUT_HOST}
    User ${INPUT_USER}
    Port ${INPUT_PORT}
    IdentityFile /root/.ssh/id_rsa.key
END

if [ -z "$ARGS" ]; then
	echo "ARGS not defined, using default -avz"
	ARGS="-avvvvz"
fi

cmd_rsync="rsync ${ARGS} ${ARGS_MORE} --debug=all4 --stderr=all"

# Ping
ping -4 -c 4 ${INPUT_HOST}

# Uploading the file-s
echo Upload file/-s...
if [ ${INPUT_REPOSITORY_PATH:0:1} = "/" ]; then
  ${cmd_rsync} ${GITHUB_WORKSPACE}/${INPUT_REPOSITORY_PATH:1} server:${INPUT_SERVER_PATH}
else
  ${cmd_rsync} ${GITHUB_WORKSPACE}/${INPUT_REPOSITORY_PATH} server:${INPUT_SERVER_PATH}
fi
