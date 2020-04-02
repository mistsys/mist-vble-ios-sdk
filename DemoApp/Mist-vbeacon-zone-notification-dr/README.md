## Mist Sample vBeacon and Zone Notifications - DR
This application depicts usage of notifications feature, targeted for the mobile client, using the vBeacons and Zones concepts using Mist core SDK - Dead Reakoning(DR).

### Prerequisites
For running this application you need Mobile SDK secret, which can be obtained from the Mist Portal (Organization —> Mobile SDK  —> secret)

### Manual Installation:
Drag and drop the MistSDK.framework file in your xcode project. 

### Classes:
MainViewController.Swift:
This class will input Mobile SDK secret in TextField.

ViewController.Swift:
This class imports the Mist SDK. It implements the MSTCentralManagerDelegate methods given below. 
didConnect
didUpdateDRMap
didUpdateDRRelativeLocation
didReceiveNotificationMessage

### vBeacon and zone notifications
Mist SDK provide you proximity related and area related notification. Using this you can provide contextual information to you user based on the proximity and area they are in.
There're two types of notifications:
   1. zones
   2. virtual beacon (vBeacon).

### Support
For more information, refer Mist SDK documentation [wiki page](https://github.com/mistsys/mist-vble-ios-sdk/wiki) or contact <support@mist.com>
