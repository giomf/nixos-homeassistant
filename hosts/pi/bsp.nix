{ ... }:

{
  raspberry-pi-nix.board = "bcm2711";
  # raspberry-pi-nix.kernel-version = "v6_10_12";
  hardware.raspberry-pi.config = {
    all.base-dt-params = {
      pwr_led_activelow = {
        enable = true;
        value = "off";
      };
    };
  };
}
