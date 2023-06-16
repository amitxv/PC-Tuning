function main() {
    $power_device_enable = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi
    $usb_devices = @("Win32_USBController", "Win32_USBControllerDevice", "Win32_USBHub")

    foreach ($power_device in $power_device_enable) {
        $instance_name = $power_device.InstanceName.ToUpper()
        foreach ($device in $usb_devices) {
            foreach ($hub in Get-WmiObject $device) {
                $pnp_id = $hub.PNPDeviceID
                if ($instance_name -like "*$pnp_id*") {
                    $power_device.enable = $False
                    $power_device.psbase.put()
                }
            }
        }
    }

    return 0
}

exit main
