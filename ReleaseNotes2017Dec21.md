# Dec 21, 2017

# Release Notes for Version 1.2.0

## Support Versions of iOS
iOS 8.0 and above

##  iOS 11.x Background issue fix

### Summary of the issue and fix
It was seen that in iOS 11.x, the background mode was found to working unreliably. This issue doesn't affect iOS 10.x and earlier. Below is the mandatory configuration:

#### Mandatory App state configuration on Main Thread
**Changes to the MSTCentralManager**

3. Call start API of MSTCentralManager
```
Setting app state is important that too on main thread
dispatch_async(dispatch_get_main_queue(), ^{
/*
 * Please add the below setAppState before the usual startLocationUpdates
 */
[weakSelf.mistManager setAppState:[[UIApplication sharedApplication] applicationState]];
[weakSelf.mistManager startLocationUpdates];
});
```

## Using the SDK in background without rest

### Summary of the changes
Mist SDK allows the app to set the duration to send requests for location, in the background mode, in lieu of battery optimizations. In this release, Mist SDK allows the app to choose to keep the requests for location all the time in the background mode, like in the foreground mode.

**Please note that the battery optimizations will have to be done on the app side**

```
[weakSelf.mistManager wakeUpAppSetting:YES];
[weakSelf.mistManager backgroundAppSetting:YES];

/*
* sendWithoutRest is the new method that can be used instead of:
 * - (void) setSentTimeInBackgroundInMins: (double) sendTimeInBackgroundInMins
 restTimeInBackgroundInMins: (double) restTimeInBackgroundInMins;
 */
[weakSelf.mistManager sendWithoutRest];
```

## Connection status Callback

### Summary of the changes
In this release, Mist SDK allows the app to subscribe to Mist cloud connection status

### Callback to get the cloud connection status
```
-(void)mistManager:(MSTCentralManager *)manager didConnect:(BOOL)isConnected { }
```


## Certificate renewal

In this release, Mist SDK certificate used for SSL / TLS was renewed.

## Map download options

### Summary of the changes
In this release, Mist SDK allows the option to not download the static map. This is particular useful for apps that use external mapping vendors. Mist SDK will default to downloading the static map. 

### Implementation

1. Implement the MSTCentralManagerMapDataSource delegate.

```
self.centralManager = [[MSTCentralManager alloc] ...]
self.centralManager.mapDataSource = self;
```

### Reference

`MSTCentralManagerMapDataSourceOptionDownload`
Setting this option means the SDK will download the static map. This is also the **default** option.

`MSTCentralManagerMapDataSourceOptionDoNotDownload`
Setting this option means that the app will provide the image to the SDK via the **_mapForMapId_** delegate. This is great for:

1. Apps using external map vendors that don't need the static map image
2. Apps that already have the static map image inside the app and want the map to be loaded more quickly.

### Example Codes

```
-(MSTCentralManagerMapDataSourceOption)shouldDownloadMap:(nonnull MSTCentralManager *)manager{
return MSTCentralManagerMapDataSourceOptionDownload; // return one of the above options
}
```

```
-(UIImage *)mapForMapId:(nonnull NSString *)mapId{
// The developer is in control on how to provide the map image in the code here,
// either via REST API or Embed inside the app.

// Simply return the UIImage for the mapId.
// For example:
// UIImage *image = [UIImage imageNamed:@"<map_id>.png"];
// return image;
}
```

