

Pod::Spec.new do |spec|

  spec.name         = "FitBleKit"

  spec.version      = "1.0.3"

  spec.summary      = "Onecoder Ble Framework."

  spec.description  = <<-DESC
                            Onecoder Ble Framework.
                   DESC

  spec.homepage     = "https://github.com/onecoderSDK/FitBleKit"

  spec.license      = "MIT"

  spec.author       = { "onecoder" => "mfpendy@onecoder.com.cn" }

  spec.platform     = :ios, "11.0"

  spec.source       = { :git => "https://github.com/onecoderSDK/FitBleKit.git", :tag => spec.version }

  spec.vendored_frameworks = "FitBleKitDemo/FitBleKit.framework"

  spec.frameworks = "CoreBluetooth"

  spec.pod_target_xcconfig = { "VALID_ARCHS" => "x86_64 armv7 arm64" }

end
