wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip


mkdir cmdline-tools

unzip -q -d cmdline-tools commandline*.zip

rm commandline*.zip

export PATH=$PATH:"$( echo cmdline-tools/**/bin)":"$( echo cmdline-tools/tools)"

#for now list versions so we know what build tools to get
yes | sdkmanager --licenses > /dev/null

sdkmanager "emulator" > /dev/null #"tools" "platform-tools" > /dev/null

#install emulator package
sdkmanager --install "system-images;android-28;default;x86_64"

echo no | avdmanager create avd -f -n emulator1 -c "512M" -k "system-images;android-28;default;x86_64"

avdmanager list avds
