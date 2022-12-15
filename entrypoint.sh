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

cmd_rsync="rsync -avz"

# Uploading the file-s
echo Upload file/-s...
if [ ${INPUT_REPOSITORY_PATH:0:1} = "/" ]; then
  ${cmd_rsync} ${GITHUB_WORKSPACE}/${INPUT_REPOSITORY_PATH:1} server:files.pharo.org
else
  ${cmd_rsync} ${GITHUB_WORKSPACE}/${INPUT_REPOSITORY_PATH} server:files.pharo.org
fi
