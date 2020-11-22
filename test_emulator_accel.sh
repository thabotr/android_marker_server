wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip


mkdir cmdline-tools

unzip -q -d cmdline-tools commandline*.zip

rm commandline*.zip

export PATH=$PATH:"$( echo cmdline-tools/**/bin)":"$( echo cmdline-tools/tools)"

#for now list versions so we know what build tools to get
echo yes| sdkmanager --licences

sdkmanager "emulator" "tools" "platform-tools" > /dev/null

sdkmanager --list 
