#cloud-config
package_update: true
package_upgrade: true
packages:
  - git
  - curl
  - apt-transport-https
  - ca-certificates
runcmd:
  - |
    set -eux
    # add Docker repo and install
    if ! command -v docker >/dev/null 2>&1; then
      curl -fsSL https://get.docker.com -o get-docker.sh
      sh get-docker.sh
      usermod -aG docker ${admin_user}
      # install docker-compose v2 (plugin)
      mkdir -p /usr/local/lib/docker/cli-plugins
      curl -SL "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64" -o /usr/local/lib/docker/cli-plugins/docker-compose
      chmod +x /usr/local/lib/docker/cli-plugins/docker-compose || true
    fi

    # clone repo
    cd /home/${admin_user}
    if [ -n "${repo_url}" ]; then
      rm -rf app || true
      git clone --depth 1 --branch ${repo_branch} "${repo_url}" app || (echo "git clone failed" && exit 1)
      cd app
      # try startup options
      if [ -n "${startup_command}" ]; then
        echo "Running provided startup command..."
        bash -c "${startup_command}" || echo "startup command failed"
      elif [ -f docker-compose.yml ] || [ -f docker-compose.yaml ]; then
        echo "Found docker-compose, launching..."
        docker compose up -d || docker-compose up -d || (echo "docker-compose failed" && exit 1)
      elif [ -x ./startup.sh ]; then
        echo "Running ./startup.sh"
        ./startup.sh || (echo "startup.sh failed" && exit 1)
      elif [ -f package.json ]; then
        echo "Node app detected, installing and starting using pm2"
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
        apt-get install -y nodejs
        npm ci
        npm start &
      else
        echo "No known start method detected. Please provide startup_command or include docker-compose/startup.sh"
      fi
      # ensure permissions
      chown -R ${admin_user}:${admin_user} /home/${admin_user}/app || true
    else
      echo "No repo_url provided"
    fi
