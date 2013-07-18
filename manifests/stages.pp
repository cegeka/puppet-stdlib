class stdlib::stages {

  stage { 'setup_repo': }
  stage { 'setup': }

  Stage['setup_repo'] -> Stage['setup'] -> Stage['main']
}
