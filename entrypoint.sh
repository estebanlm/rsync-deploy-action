#!/bin/sh

# Prepare SSH connection
mkdir -p /root/.ssh/
echo "${INPUT_PRIVATE_SSH_KEY}" > /root/.ssh/id_rsa.key
chmod 600 /root/.ssh/id_rsa.key

INPUT_HOST=files.pharo.org
INPUT_PORT=22
INPUT_USER=pharoorgde

ssh-keyscan -H ${INPUT_HOST} >> /root/.ssh/known_hosts
cat >>/root/.ssh/config <<END
Host server
    HostName ${INPUT_HOST}
    User ${INPUT_USER}
    Port ${INPUT_PORT}
    IdentityFile /root/.ssh/id_rsa.key
END

cmd_rsync="rsync -avz"

# Uploading the file-s
echo Upload file/-s...
${cmd_rsync} ${GITHUB_WORKSPACE}/generated files.pharo.org:/homez.141/pharoorgde/www

#if [ ${INPUT_REPOSITORY_PATH:0:1} = "/" ]; then
#  ${cmd_rsync} ${GITHUB_WORKSPACE}/${INPUT_REPOSITORY_PATH:1} ${INPUT_HOST}:${INPUT_SERVER_PATH}
#else
#  ${cmd_rsync} ${GITHUB_WORKSPACE}/${INPUT_REPOSITORY_PATH} ${INPUT_HOST}:${INPUT_SERVER_PATH}
#fi
