# README

This project integrates Swift and Objective-C codebases to leverage the strengths of both languages. Below are the specific steps and configurations required to ensure seamless interoperability between Swift and Objective-C.

---

## Build Settings Configuration

1. Open the **Xcode Project** for the target where you want to integrate Swift and Objective-C.
2. Navigate to the **Build Settings** tab.
3. Under the **Packaging** section, locate the `Defines Module` setting.
4. Set the `Defines Module` option to **Yes** for the target containing the Swift code.

This ensures that the Swift module is generated and can be imported into Objective-C files.

---

## Importing Swift Code into Objective-C

To use Swift code in Objective-C files, you need to import the automatically generated Swift header file. Follow these steps:

1. Use the following syntax to import the Swift module into your Objective-C `.m` files:
   ```objective-c
   #import <ProductName/ProductModuleName-Swift.h>
   ```
   Replace:
   - `ProductName` with the name of your Xcode project.
   - `ProductModuleName` with the name of the module or target containing the Swift code.

2. Example:
   - If your project is named `SampleAppWakeUp` and the Swift module is part of the `SampleAppWakeUp` target, the import statement would look like this:
     ```objective-c
     #import <SampleAppWakeUp/SampleAppWakeUp-Swift.h>
     ```

3. Add this import statement at the top of any Objective-C `.m` file where you want to use Swift code.

---

## Reference

For more details, refer to the official Apple documentation:  
[Importing Swift into Objective-C](https://developer.apple.com/documentation/swift/importing-swift-into-objective-c)