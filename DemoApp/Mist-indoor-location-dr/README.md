## Mist Indoor Location DR
This application depicts the indoor location feature targeted for the mobile client, with a bluedot, using the MIST Core SDK - Dead Reckoning (DR).

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

### Support
For more information, refer Mist SDK documentation [wiki page](https://github.com/mistsys/mist-vble-ios-sdk/wiki) or contact <support@mist.com>
