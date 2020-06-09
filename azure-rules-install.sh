#!/bin/bash -e

processor=$(uname -m)

if [ "$processor" == "x86_64" ]; then
  arch="amd64"
else
  arch="386"
fi

case "$(uname -s)" in
  Darwin*)
    os="darwin_${arch}"
    ;;
  MINGW64*)
    os="windows_${arch}"
    ;;
  MSYS_NT*)
    os="windows_${arch}"
    ;;
  *)
    os="linux_${arch}"
    ;;
esac

echo "os=$os"

echo -e "\n\n===================================================="

get_latest_release() {
  curl --silent "https://api.github.com/repos/terraform-linters/tflint-ruleset-azurerm/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                                                                  # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                                                          # Pluck JSON value
}

if [[ -z "${TFLINT_RULESET_AZURE_VERSION}" ]]; then
  echo "Looking up the latest version ..."
  version=$(get_latest_release)
else
  version=${TFLINT_RULESET_AZURE_VERSION}
fi

echo "Downloading TFLint Azure Ruleset Plugin $version"

curl -L -o /tmp/tflint-ruleset-azurerm.zip "https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/${version}/tflint-ruleset-azurerm_${os}.zip"
retVal=$?
if [ $retVal -ne 0 ]; then
  echo "Failed to download tflint-rulset-azurerm_${os}.zip"
  exit $retVal
else
  echo "Download was successfully"
fi

echo -e "\n\n===================================================="
echo "Unpacking /tmp/tflint-ruleset-azurerm.zip ..."
mkdir -p ~/.tflint.d/plugins/
unzip -u -j /tmp/tflint-ruleset-azurerm.zip -d ~/.tflint.d/plugins/

if [ -d "$HOME/.tflint.d/plugins/tflint-ruleset-azurerm/" ] ; then
  echo "TFLint Azure Ruleset Plugin installed at /.tflint.d/plugins/ successfully"
else
  echo "TFLint Azure Ruleset Plugin installation FAILED!"
fi

echo "Cleaning /tmp/tflint-ruleset-azurerm.zip ..."
rm /tmp/tflint-ruleset-azurerm.zip

echo -e "\n\n===================================================="
