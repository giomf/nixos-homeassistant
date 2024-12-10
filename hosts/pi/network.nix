{ ... }:

let
  lan_interface = "lan";
  wifi_interface = "wlan0";
in
{
  systemd.network = {
    enable = true;
    # broken: https://github.com/NixOS/nixpkgs/issues/247608
    wait-online.enable = false;
    links = {
      "10-lan" = {
        matchConfig.PermanentMACAddress = "dc:a6:32:60:86:a3";
        linkConfig.Name = "${lan_interface}";
      };
      "20-wireless" = {
        matchConfig.PermanentMACAddress = "dc:a6:32:60:86:a5";
        linkConfig.Name = "${wifi_interface}";
      };
    };

    networks = {
      "10-lan" = {
        matchConfig.Name = "${lan_interface}";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "no";
      };
      "20-wireless" = {
        matchConfig.Name = "${wifi_interface}";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  networking = {
    hostName = "homeassistant";
    useNetworkd = true;
    networkmanager.enable = false;
    firewall = {
      enable = true;
    };
    wireless = {
      enable = false;
    };
  };
}
