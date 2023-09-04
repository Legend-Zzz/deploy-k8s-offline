#!/bin/bash

work_dir=$(dirname $(readlink -f $0))

cd ${work_dir}/

# install ansible
if [ -f /etc/os-release ]; then
  source /etc/os-release

  case $ID in
    "debian")
      if ! command -v sudo &> /dev/null; then
        echo "主机未安装sudo，请输入root用户密码进行安装："
        read -s password
        if ! echo $password | su -c "dpkg -i ./package/sudo/*.deb" &>/dev/null; then
          echo "密码错误或安装失败，程序退出"
          exit 1
        fi
      fi

      if ! sudo -v &> /dev/null; then
        if [ ! -v password ]; then
          echo "当前用户$USER没有sudo权限，请输入root用户密码为当前用户配置权限："
          read -s password
        fi
        if ! echo $password | su -c 'echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers' &>/dev/null; then
          echo "密码错误或配置失败，程序退出"
          exit 1
        fi
      fi

      if ! command -v ansible &>/dev/null; then
        sudo dpkg -i ./package/ansible-debian/*.deb
      fi

      sudo sed -i 's#interpreter_python=/usr/bin/python2#interpreter_python=/usr/bin/python3#g' .ansible/ansible.cfg
      ;;
    "centos")
      if ! sudo -v &> /dev/null; then
        if [ ! -v password ]; then
          echo "当前用户$USER没有sudo权限，请输入root用户密码为当前用户配置权限："
          read -s password
        fi
        if ! echo $password | su -c 'echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers' &>/dev/null; then
          echo "密码错误或配置失败，程序退出"
          exit 1
        fi
      fi

      if ! command -v ansible &>/dev/null; then
        sudo yum localinstall -y ./package/ansible-centos/*.rpm
      fi
      ;;
    *)
      echo "Unsupported operating system: $ID"
      exit 1
      ;;
  esac
else
  echo "Unable to read /etc/os-release."
  exit 1
fi



cd ${work_dir}/.ansible/


case $1 in 
  run)
    ansible-playbook deploy_k8s.yml -e work_dir=${work_dir}   ${@:2}
    ;;
  join)
    ansible-playbook -f 1 join.yml -e work_dir=${work_dir}    ${@:2}
    ;;
  *)
    ;;
esac

cd - > /dev/null
