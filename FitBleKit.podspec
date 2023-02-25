

Pod::Spec.new do |spec|

  spec.name         = "FitBleKit"

  spec.version      = "1.0.1"

  spec.summary      = "Onecoder Ble Framework."

  spec.description  = <<-DESC
                            Onecoder Ble Framework.
                   DESC

  spec.homepage     = "https://github.com/onecoderSDK/FitBleKit"

  spec.license      = "MIT"

  spec.author       = { "onecoder" => "mfpendy@onecoder.com.cn" }

  spec.platform     = :ios, "11.0"

  spec.source       = { :git => "https://github.com/onecoderSDK/FitBleKit.git", :tag => "1.0.1" }

  spec.source_files = "FitBleKit/**/*.{h,m}"

  spec.public_header_files = "FitBleKit/KitHeader/FitBleKit.h"

  spec.frameworks = "CoreBluetooth"

  spec.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }


end
