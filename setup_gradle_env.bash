source src/gradle_setup.bash
source set_env_vars.bash

set_var_gradle

install_java
mkdir -p $GRADLE
install_gradle $GRADLE
