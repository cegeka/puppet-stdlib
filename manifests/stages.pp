class stdlib::stages {

  stage { 'setup_fs': }
  stage { 'setup_mount': }
  stage { 'setup_repo': }
  stage { 'setup_packages': }
  stage { 'setup_users': }
  stage { 'setup': }

  Stage['setup_fs'] -> Stage['setup_mount']
  Stage['setup_users'] -> Stage['setup_repo'] -> Stage['setup_packages'] -> Stage['setup'] -> Stage['main']

}
