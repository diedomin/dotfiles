#!/bin/bash

ask_reboot() {
    echo
    echo "Done!!! Customization complete!!!"
    read -p "Do you want to reboot the system now? (y/n): " resp

    case "$resp" in
      [yYsS]* )
        echo "Restarting..."
        sudo reboot
        ;;
      [nN]* )
        echo "Remember to restart later to apply all changes."
        ;;
      * )
        echo "Option not recognized. The system does not restart."
        ;;
    esac
}
