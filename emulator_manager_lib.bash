install_emulator_image()
{
	#arg1 is android API, arg2 is TAG, and arg3 is ABI
	#install image package
	API=$1
	TAG=$2
	ABI=$3
	sdkmanager --install "system-images;android-$API;$TAG;$ABI"
	sdkmanager --install "platforms;android-$API" #solves SDK installation not found problem
}
