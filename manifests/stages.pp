class stdlib::stages {

  stage { 'setup_fs': }
  stage { 'setup_mount': }
  stage { 'setup_repo': }
  stage { 'setup_packages': }
  stage { 'setup': }

  Stage['setup_fs'] -> Stage['setup_mount']
  Stage['setup_repo'] -> Stage['setup_packages'] -> Stage['setup'] -> Stage['main']

}
