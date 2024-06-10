# Defines custom method to install all Flutter plugins.
def install_all_flutter_pods(flutter_application_path)
    Dir.glob(File.join(flutter_application_path, '.symlinks', 'plugins', '*', 'ios', '*.podspec')).each do |podspec|
      pod_name = File.basename(podspec, '.podspec')
      pod pod_name, :path => File.dirname(podspec)
    end
  end
  
  # Adds pods for the Flutter framework itself.
  def install_flutter_engine_pod(flutter_root)
    pod 'Flutter', :path => File.join(flutter_root, 'bin', 'cache', 'artifacts', 'engine', 'ios')
  end
  
  # Adds additional iOS-specific build settings.
  def flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
  